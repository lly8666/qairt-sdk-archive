#!/usr/bin/env python3
"""Read-only MRX-W09 235 vs TAS-AN00 185 compatibility evidence gate.

Consumes the owner's pinned ZIP reports. Never executes binaries in the ZIP,
runs a device command, triggers a bug, changes kernel memory or requests Root.
"""
import argparse
import hashlib
import json
from pathlib import Path
import zipfile

SYSTEM_ZIP_SHA256 = "1e92d7a89d33063b4040beb25b774472c81c821ef12aaa59990eb9ff6ded19e0"
EROFS_REPORT_SHA256 = "b2ff32a3d1ff8c7185122f8d0afafc9c5934feed8bf58302c2d30041bb845579"
LIBC_SHA256 = "ecdaf9a20bafd6659649d755023c34137a2788d6fdedb543c10dd20ad2b77ecd"
BUGREPORTZ_SHA256 = "b85051d0eb7717ed2509c76440f48ec16608b83af3e79efb29d7662f40aee47d"
SUPER_INPUT_BYTES = 1435996536
MISSING_LEADING_BYTES = 5093982208

def digest_file(path):
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1048576), b""):
            h.update(chunk)
    return h.hexdigest()

def require_pinned(path, expected, label):
    actual = digest_file(path)
    if actual != expected:
        raise ValueError(label + ": input SHA256 mismatch, got " + actual)
    return actual

def analyze(system_zip, erofs_report):
    sha1 = require_pinned(system_zip, SYSTEM_ZIP_SHA256, "system files")
    sha2 = require_pinned(erofs_report, EROFS_REPORT_SHA256, "EROFS report")
    with zipfile.ZipFile(system_zip) as z:
        if z.testzip() is not None:
            raise ValueError("corrupt system ZIP member")
        names = z.namelist()
        known = {
            "os/system/bin/bugreportz": BUGREPORTZ_SHA256,
            "os/apex/com.android.runtime/lib64/bionic/libc.so": LIBC_SHA256,
        }
        for name, expected in known.items():
            if name not in names or hashlib.sha256(z.read(name)).hexdigest() != expected:
                raise ValueError("missing or different system ELF " + name)
    with zipfile.ZipFile(erofs_report) as z:
        if z.testzip() is not None:
            raise ValueError("corrupt EROFS report member")
        layout = json.loads(z.read("SPARSE_LAYOUT.json"))
        inventory = json.loads(z.read("TAS_EROF_TARGET_INVENTORY.json"))
        beginning = [c for c in layout["chunks"]
                     if c["type"] == "DONTCARE" and c["output_offset"] == 0]
        first_hole = beginning[0]["logical_bytes"] if len(beginning) == 1 else 0
        if layout["input_bytes"] != SUPER_INPUT_BYTES or first_hole != MISSING_LEADING_BYTES:
            raise ValueError("sparse SUPER input does not match previously pinned image")
        paths = [x["path"] for x in inventory["matched_files"]]
    return {
        "schema": "TAS_MRX235_TAS185_READONLY_GAP_AUDIT_V1",
        "reference": {
            "model": "MRX-W09", "soc": "Kirin990", "kernel": "4.14.116",
            "emui": "11.0.0.235",
            "root_result": "UID0_REPORTED_IN_MRX_PUBLIC_LOG_ONLY",
            "gpu_stage": "PUBLIC_MRX_RECORD_REPORTS_CVE_2021_44828",
            "libc_file_label": "/system/lib64/libc.so",
            "starting_context": "ADB_SHELL",
        },
        "target": {
            "model": "TAS-AN00", "soc": "Kirin990", "kernel": "4.14.116",
            "emui": "11.0.0.185", "android_sdk": 29,
            "root_result": "NOT_OBSERVED",
            "libc_file_content": "/apex/com.android.runtime/lib64/bionic/libc.so",
            "libc_file_sha256": LIBC_SHA256,
            "bugreportz_client_sha256": BUGREPORTZ_SHA256,
            "mali_driver_family": "BIFROST_R18P0_REPORTED",
            "mali_interface": "11.16_DEVICE_PASS",
            "cache_test_scope": "APP_OWNED_DISPOSABLE_FILE_ONLY",
            "gpu_readonly_memory_vulnerability": "NOT_TESTED",
            "app_perf": "FOUR_EACCES",
            "adb_shell_perf": "FOUR_EACCES",
        },
        "firmware_sources": {
            "system_elf_zip_sha256": sha1,
            "erofs_report_zip_sha256": sha2,
            "super_image_size_bytes": layout["input_bytes"],
            "super_sparse_leading_dontcare_bytes": first_hole,
            "erofs_inventory_files_count": len(paths),
            "dumpstate_elf_in_examined_inputs": (
                "os/system/bin/dumpstate" in names or
                any("/bin/dumpstate" in p for p in paths)
            ),
            "scope": "ONLY_SUPPLIED_OTA_AND_PARTIAL_SPARSE_SUPER",
        },
        "interpretation": {
            "same_kernel_version_means_identical_binary": False,
            "gpu_abi_pass_implies_cve_2021_44828_exploitable": False,
            "mali_r18p0_in_public_affected_family_if_unpatched": True,
            "mali_fix_backport_status": "UNKNOWN",
            "same_libc_file_identity_proven": False,
            "mrx_libc_reference_directly_transferable": False,
            "system_image_absent_means_dumpstate_absent": False,
            "tas_privileged_service_runtime": "UNMEASURED",
            "credential_change": "NOT_ATTEMPTED",
            "root_activated": False,
            "critical_missing_stage": "TAS_PROTECTED_PAGE_CACHE_CAPABILITY_AND_RUNTIME_CONTEXT",
        },
        "no_live_device_test": True,
        "no_exploit_operations": True,
    }

def selftest():
    assert len(LIBC_SHA256) == 64
    assert len(BUGREPORTZ_SHA256) == 64
    assert MISSING_LEADING_BYTES > 5000000000
    assert SUPER_INPUT_BYTES < MISSING_LEADING_BYTES
    print("TAS_MRX235_TAS185_READONLY_GAP_GATE_SELFTEST_PASS")

def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--system-zip", type=Path)
    p.add_argument("--erofs-report-zip", type=Path)
    p.add_argument("--out", type=Path)
    p.add_argument("--selftest", action="store_true")
    args = p.parse_args()
    if args.selftest:
        return selftest()
    if not args.system_zip or not args.erofs_report_zip:
        p.error("--system-zip and --erofs-report-zip required")
    output = json.dumps(analyze(args.system_zip, args.erofs_report_zip),
                        indent=2, ensure_ascii=False) + "\n"
    if args.out:
        args.out.write_text(output, encoding="utf-8")
    else:
        print(output, end="")

if __name__ == "__main__":
    main()
