#!/usr/bin/env python3
"""Read-only patch-status audit of the already recovered TAS kernel ELF.

Uses readelf/llvm-objdump for static examination; never runs device code,
triggers a futex bug, writes kernel memory, requests root, or patches files.
A matching signature is NOT a claim of exploitability or live root.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess

PINNED_ELF_SHA256 = "b31c32928f2f095497825b28cc7c31a291ff649bfc4afe2a825bbda0b0ff3716"
PINNED_KERNEL_SHA256 = "d4b6f00aff4a4e05a3d5d794552165b0c950913aa841b356cae9bc69ae8ea2e5"
KALLSYMS_BUILD_RUN = 43215710221

INSTR = re.compile(r'^\s*[0-9a-fA-F]+:\s+([a-z][a-z0-9.]*)\s+(.+?)\s*$', re.I)

def function_instructions(disasm):
    """Restrict matching to the actual symbolized remove_waiter body."""
    inside = False
    result = []
    for line in disasm.splitlines():
        sym = re.search(r'<([^<>]+)>:\s*$', line)
        if sym:
            if sym.group(1) == "remove_waiter":
                inside = True
                continue
            if inside:
                break
        if inside:
            m = INSTR.match(line)
            if m:
                result.append((m.group(1).lower(), m.group(2).strip().lower()))
    return result

def classify(disasm):
    instructions = function_instructions(disasm)
    current_reads = []
    for idx, (op, args) in enumerate(instructions):
        m = re.fullmatch(r'(x\d+),\s*sp_el0', args)
        if op == "mrs" and m:
            current_reads.append((idx, m.group(1)))
    sequences = []
    for i, current in current_reads:
        for j in range(i + 1, min(i + 30, len(instructions))):
            op, args = instructions[j]
            lock = re.fullmatch(r'(x\d+),\s*' + current + r',\s*#0x[0-9a-f]+', args)
            if op != "add" or not lock:
                continue
            lockreg = lock.group(1)
            for k in range(j+1, min(j+22, len(instructions))):
                if instructions[k] != ("mov", "x0, " + lockreg):
                    continue
                for l in range(k+1, min(k+6, len(instructions))):
                    if instructions[l][0] != "bl" or "do_raw_spin_lock" not in instructions[l][1]:
                        continue
                    for m in range(l+1, min(l+35, len(instructions))):
                        if instructions[m][0] != "bl" or "rb_erase_cached" not in instructions[m][1]:
                            continue
                        for n in range(m+1, min(m+16, len(instructions))):
                            if instructions[n][0] != "str" or not re.fullmatch(
                                r'xzr,\s*\[' + current + r',\s*#0x[0-9a-f]+\]',
                                instructions[n][1]
                            ):
                                continue
                            for o in range(n+1, min(n+6, len(instructions))):
                                if instructions[o][0] != "bl" or "do_raw_spin_unlock" not in instructions[o][1]:
                                    continue
                                if any(instructions[t] == ("mov", "x0, " + lockreg)
                                       for t in range(m+1, o)):
                                    sequences.append((i,j,l,m,n,o))
    result = {
        "remove_waiter_symbolized": bool(instructions),
        "sp_el0_current_task_read": bool(current_reads),
        "complete_current_based_critical_section": bool(sequences),
        "basic_instruction_count": len(instructions),
        "signature_method": "same_function_ordered_current_lock_erase_clear_unlock",
        "patch_proven": False,
        "exploitability_proven": False,
    }
    result["classification"] = ("CONSISTENT_WITH_UNPATCHED_GHOSTLOCK"
                                if sequences else "INDETERMINATE")
    return result

def audit(elf):
    h = hashlib.sha256()
    with elf.open("rb") as inp:
        for part in iter(lambda: inp.read(1024*1024), b""):
            h.update(part)
    digest = h.hexdigest()
    result = {
        "schema": "TAS_GHOSTLOCK_READONLY_PATCH_AUDIT_V2",
        "target": "TAS-AN00 EMUI 11.0.0.185",
        "pinned_kernel_image_sha256": PINNED_KERNEL_SHA256,
        "symbolized_elf_sha256": digest,
        "pinned_elf_match": digest == PINNED_ELF_SHA256,
        "source_ci_run": KALLSYMS_BUILD_RUN,
        "live_exploit_attempted": False,
        "root_observed": False,
    }
    if not result["pinned_elf_match"]:
        result["classification"] = "INPUT_NOT_PINNED"
        return result
    symbols = subprocess.run(
        ["readelf", "-Ws", str(elf)], capture_output=True,
        text=True, check=True, timeout=30
    ).stdout
    matched = re.findall(
        r"^\s*\d+:\s+([0-9a-fA-F]+)\s+\d+\s+FUNC\s+LOCAL\s+DEFAULT\s+\d+\s+remove_waiter\s*$",
        symbols, re.M,
    )
    if len(matched) != 1:
        result["classification"] = "SYMBOL_MISSING_OR_AMBIGUOUS"
        return result
    start = int(matched[0], 16)
    disasm = subprocess.run(
        ["llvm-objdump", "-d", "--no-show-raw-insn",
         "--start-address=" + str(start), "--stop-address=" + str(start + 384),
         str(elf)],
        capture_output=True, text=True, check=True, timeout=30
    ).stdout
    result.update(classify(disasm))
    return result

def selftest():
    sequence = [
      "Disassembly of section .kernel:",
      "0000 <remove_waiter>:",
      "0000: mrs x19, SP_EL0",
      "0004: add x21, x19, #0xad0",
      "0008: mov x0, x21",
      "000c: bl 0x1111 <do_raw_spin_lock.cfi>",
      "0010: mov x0, x23",
      "0014: bl 0x2222 <rb_erase_cached.cfi>",
      "0018: str xzr, [x19, #0xb08]",
      "001c: mov x0, x21",
      "0020: bl 0x3333 <do_raw_spin_unlock.cfi>",
    ]
    classify_lines = lambda lines: classify("\n".join(lines))["classification"]
    assert classify_lines(sequence) == "CONSISTENT_WITH_UNPATCHED_GHOSTLOCK"
    # v1 falsely passed an unrelated trio of current-task instructions.
    assert classify_lines([sequence[1], sequence[2], sequence[3], sequence[8]]) == "INDETERMINATE"
    assert classify_lines(sequence[:7] + sequence[8:]) == "INDETERMINATE"  # missing erase
    assert classify_lines(sequence[:8] +
        ["0018: str xzr, [x23, #0xb08]"] + sequence[9:]) == "INDETERMINATE"
    assert classify_lines(sequence[:10] +
        ["0020: bl 0x3333 <not_an_unlock>"]) == "INDETERMINATE"
    assert classify_lines(["0000 <another_function>:"] + sequence[2:]) == "INDETERMINATE"
    assert classify_lines(sequence[:8] +
        ["0030 <another_function>:"] + sequence[8:]) == "INDETERMINATE"
    assert classify_lines(sequence[:8] + [
        "001c: mov x0, x21", "0020: bl 0x3333 <do_raw_spin_unlock.cfi>",
        "0018: str xzr, [x19, #0xb08]"]) == "INDETERMINATE"
    print("TAS_GHOSTLOCK_READONLY_KERNEL_AUDIT_V2_SELFTEST_PASS")

def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--elf", type=Path, help="exact previously recovered symbolized TAS kernel")
    p.add_argument("--out", type=Path, help="optional JSON result file")
    p.add_argument("--selftest", action="store_true")
    args = p.parse_args()
    if args.selftest:
        selftest()
        return
    if not args.elf:
        p.error("--elf required unless --selftest")
    data = audit(args.elf)
    payload = json.dumps(data, ensure_ascii=False, indent=2) + "\n"
    if args.out:
        args.out.write_text(payload, encoding="utf-8")
    else:
        print(payload, end="")

if __name__ == "__main__":
    main()
