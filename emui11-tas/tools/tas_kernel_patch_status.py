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

def classify(disasm):
    text = disasm.split("Disassembly of section", 1)[-1]
    ops = []
    for line in text.splitlines():
        m = re.search(r":\s+(mrs|ldr|str|add|mov|bl)\s+([^;]+)", line, re.I)
        if m:
            ops.append((m.group(1).lower(), m.group(2).strip()))
    task_regs = []
    for op, instruction in ops:
        if op != "mrs":
            continue
        m = re.match(r"\s*(x\d+)\s*,\s*SP_EL0\b", instruction, re.I)
        if m:
            task_regs.append(m.group(1))
    current_clear = any(
        op == "str" and re.match(r"\s*xzr\s*,\s*\[" + re.escape(reg) + r"\s*,", instr)
        for op, instr in ops for reg in task_regs
    )
    current_lock = any(
        op == "add" and re.match(r"\s*x\d+\s*,\s*" + re.escape(reg) + r"\s*,", instr)
        for op, instr in ops for reg in task_regs
    )
    checks = {
        "remove_waiter_symbolized": "remove_waiter>:" in text,
        "uses_sp_el0_current_task": bool(task_regs),
        "clears_pi_state_via_current_task": current_clear,
        "derives_lock_from_current_task": current_lock,
    }
    checks["classification"] = ("CONSISTENT_WITH_UNPATCHED_GHOSTLOCK"
                                if all(checks.values()) else "INDETERMINATE")
    return checks

def audit(elf):
    h = hashlib.sha256()
    with elf.open("rb") as inp:
        for part in iter(lambda: inp.read(1024*1024), b""):
            h.update(part)
    digest = h.hexdigest()
    result = {
        "schema": "TAS_GHOSTLOCK_READONLY_PATCH_AUDIT_V1",
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
         "--start-address=" + str(start), "--stop-address=" + str(start + 288),
         str(elf)],
        capture_output=True, text=True, check=True, timeout=30
    ).stdout
    result.update(classify(disasm))
    return result

def selftest():
    a = ("Disassembly of section .kernel:\n"
         "abcd <remove_waiter>:\n"
         "abcd: mrs x19, SP_EL0\n"
         "abce: add x21, x19, #0xa0\n"
         "abcf: str xzr, [x19, #0xb00]\n")
    assert classify(a)["classification"] == "CONSISTENT_WITH_UNPATCHED_GHOSTLOCK"
    assert classify(a.replace("str xzr, [x19,", "str xzr, [x24,"))["classification"] == "INDETERMINATE"
    assert classify(a.replace("mrs x19, SP_EL0", "mov x19, x0"))["classification"] == "INDETERMINATE"
    assert classify("")["classification"] == "INDETERMINATE"
    print("TAS_GHOSTLOCK_READONLY_KERNEL_AUDIT_SELFTEST_PASS")

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
