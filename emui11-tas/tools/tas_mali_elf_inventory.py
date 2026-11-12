#!/usr/bin/env python3
"""Fail-closed, read-only inventory of the TAS-AN00 symbolized Mali driver.

This records names and counts only. It cannot decide CVE-2021-44828 patch state,
show runtime exploitability, or provide an elevated Android execution route.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import struct
import subprocess
import tempfile

EXPECTED_ELF_SHA256 = "b31c32928f2f095497825b28cc7c31a291ff649bfc4afe2a825bbda0b0ff3716"
EXPECTED_KERNEL_IMAGE_SHA256 = "d4b6f00aff4a4e05a3d5d794552165b0c950913aa841b356cae9bc69ae8ea2e5"
CHECK_SYMBOLS = (
    "kbase_mem_alloc",
    "kbase_mem_import",
    "kbase_mem_copy_from_extres_page",
    "kbase_jd_user_buf_pin_pages",
    "kbase_vmap_prot",
    "kbase_mmu_insert_pages",
    "kbase_gpu_munmap",
    "kbase_sync_single_for_device",
)
SYMBOL_RE = re.compile(
    r"^\s*\d+:\s+[0-9a-fA-F]+\s+\d+\s+FUNC\s+"
    r"\w+\s+\w+\s+(?!UND\b)\S+\s+([^\s]+)\s*$"
)


def file_sha256(path):
    h = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def validate_pinned_aarch64_elf(path):
    actual = file_sha256(path)
    if actual != EXPECTED_ELF_SHA256:
        raise ValueError("INPUT_NOT_PINNED: symbolized ELF SHA256 " + actual)
    with path.open("rb") as stream:
        header = stream.read(20)
    if len(header) < 20 or header[:6] != b"\x7fELF\x02\x01":
        raise ValueError("NOT_AARCH64_ELF64_LE")
    # ELF e_machine is at byte offset 18; EM_AARCH64 == 183.
    if struct.unpack_from("<H", header, 18)[0] != 183:
        raise ValueError("NOT_AARCH64_MACHINE")
    return actual


def parse_func_names(readelf_text):
    names = []
    for line in readelf_text.splitlines():
        match = SYMBOL_RE.match(line)
        if match:
            name = match.group(1)
            # GNU readelf may add a version suffix or decoration; do not
            # silently reinterpret anything other than exact symbol names.
            if "@" not in name:
                names.append(name)
    if not names:
        raise ValueError("NO_FUNCTION_SYMBOLS")
    return sorted(set(names))


def inventory(path):
    actual = validate_pinned_aarch64_elf(path)
    proc = subprocess.run(
        ["readelf", "-Ws", str(path)],
        capture_output=True, text=True, timeout=90, check=True,
    )
    names = parse_func_names(proc.stdout)
    name_set = set(names)
    prefixes = ("kbase_", "kbase_mem_", "kbase_mmu_", "kbase_jd_", "mali_")
    counts = {prefix.rstrip("_"): sum(name.startswith(prefix) for name in names)
              for prefix in prefixes}
    # A recovered kallsyms ELF may contain both .cfi trampolines and original
    # function symbols; report them separately instead of conflating counts.
    return {
        "schema": "TAS_MALI_PINNED_ELF_SYMBOL_INVENTORY_V1",
        "target": "TAS-AN00 / EMUI 11.0.0.185 / Android 10",
        "input": {
            "sha256": actual,
            "related_extracted_kernel_image_sha256": EXPECTED_KERNEL_IMAGE_SHA256,
            "kind": "KALLSYMS_RECOVERED_AARCH64_ELF",
            "note": "Exact symbolized ELF is a recovered offline artifact; no live device read",
        },
        "counts_including_cfi": counts,
        "kbase_cfi_symbols": sum(name.startswith("kbase_") and name.endswith(".cfi") for name in names),
        "kbase_non_cfi_symbols": sum(name.startswith("kbase_") and not name.endswith(".cfi") for name in names),
        "selected_symbol_presence": {sym: sym in name_set for sym in CHECK_SYMBOLS},
        "interpretation": {
            "mali_code_present_in_recovered_elf": counts["kbase"] > 0,
            "driver_version_provenance": "R18P0_CONFIRMED_SEPARATELY_FROM_PINNED_BOOT_IMAGE_STRINGS",
            "cve_2021_44828_version_range_indicator": "BIFROST_R18P0_IN_PUBLIC_RANGE",
            "cve_2021_44828_vendor_backport_status": "UNKNOWN",
            "protected_memory_effect_on_TAS": "NOT_TESTED",
            "tas_root_observed": False,
            "binary_function_presence_is_patch_proof": False,
        },
        "no_device_access": True,
        "no_exploit_execution": True,
    }


def selftest():
    lines = (
        "    1: ffffff8008000000    16 FUNC    LOCAL  DEFAULT    1 kbase_mem_alloc\n"
        "    2: ffffff8008000010     0 FUNC    LOCAL  DEFAULT    1 kbase_mem_alloc.cfi\n"
        "    3: 0000000000000000     0 FUNC    GLOBAL DEFAULT  UND missing\n"
        "    4: ffffff8008000020    16 OBJECT  LOCAL  DEFAULT    1 not_a_function\n"
    )
    assert parse_func_names(lines) == ["kbase_mem_alloc", "kbase_mem_alloc.cfi"]
    try:
        parse_func_names("not a symbol table")
        raise AssertionError("invalid symbol input accepted")
    except ValueError:
        pass
    with tempfile.TemporaryDirectory() as td:
        test_file = Path(td) / "bad.elf"
        test_file.write_bytes(b"\x7fELF" + b"\x00" * 40)
        try:
            validate_pinned_aarch64_elf(test_file)
            raise AssertionError("unpinned input accepted")
        except ValueError as e:
            assert "INPUT_NOT_PINNED" in str(e)
    print("TAS_MALI_PINNED_ELF_INVENTORY_SELFTEST_PASS")


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--elf", type=Path, help="exact recovered, SHA256-pinned TAS ELF")
    ap.add_argument("--out", type=Path)
    ap.add_argument("--selftest", action="store_true")
    args = ap.parse_args()
    if args.selftest:
        return selftest()
    if args.elf is None:
        ap.error("--elf is required unless --selftest is supplied")
    report = json.dumps(inventory(args.elf), ensure_ascii=False, indent=2) + "\n"
    if args.out:
        args.out.write_text(report, encoding="utf-8")
    else:
        print(report, end="")


if __name__ == "__main__":
    main()
