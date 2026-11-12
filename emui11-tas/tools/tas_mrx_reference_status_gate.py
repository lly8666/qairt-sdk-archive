#!/usr/bin/env python3
"""Read-only MRX/BKL reference-status provenance gate for Huawei TAS-AN00.

Operates on two public documentation files, not exploit source/binaries. Never
runs or builds an exploit. An upstream statement is source-reported, not
independent replication on TAS.
"""
import argparse
import json
from pathlib import Path
import re

UPSTREAM_COMMIT = "381476444fbbbcf0c5e8e3c2e2166647e9134ab5"

def check(mrx_facts, bkl_readme):
    header = mrx_facts.splitlines()[:10]
    mrx_identity = (
        any("MRX-W09" in x and "GhostLock" in x for x in header) and
        any("Kirin 990" in x and "4.14.116" in x and "EMUI 11.0.0.235" in x for x in header)
    )
    records = {
        "mrx_uid0_stage": bool(re.search(
            r"(?m)^### \(131\) 2026-09-26 .+ACHIEVED: uid 0 ON DEVICE", mrx_facts)),
        "mrx_root_command_verified": bool(re.search(
            r"(?m)^### \(133\) 2026-09-26 .+GOAL COMPLETE.+MRX-W09", mrx_facts))
            and "uid=0(root) gid=0(root)" in mrx_facts,
        "mrx_root_reproduced_after_regression": bool(re.search(
            r"(?m)^### \(137\) 2026-09-26 root RESTORED", mrx_facts)),
    }
    bkl_is_different = (
        "BKL-L09" in bkl_readme and
        "Kirin 970" in bkl_readme and
        "root to be achieved" in bkl_readme
    )
    return {
        "schema":"TAS_MRX_REFERENCE_STATUS_AUDIT_V1",
        "reference_repository":"BellezaEmporium/ghostlock-bkl-l09",
        "pinned_commit":UPSTREAM_COMMIT,
        "mrx_profile":"MRX-W09 / Kirin990 / Linux4.14.116 / EMUI11.0.0.235",
        "mrx_identity_in_record":mrx_identity,
        "mrx_source_reported_root_status":(
            "UID0_AND_ROOT_COMMAND_RECORDED" if mrx_identity and all(records.values())
            else "NOT_FULLY_ESTABLISHED_FROM_INPUT"),
        "mrx_root_record_markers":records,
        "bkl_comparison":"KIRIN970_ROOT_INCOMPLETE_BANNER" if bkl_is_different else "UNVERIFIED",
        "tas_device":"TAS-AN00 / Kirin990 / EMUI11.0.0.185 / Android10 API29",
        "tas_root_proof":"NOT_OBSERVED",
        "tas_current_gap":"PRIVILEGED_EXECUTION_AND_PERF_ACCESS_UNVERIFIED",
        "notes":[
            "A public MRX-W09 on-device record does not independently validate TAS-AN00.",
            "MRX/BKL do not share binary offsets, SELinux policy, service layout or success claims.",
            "No privilege escalation payload is compiled or executed by this audit.",
        ],
    }

def selftest():
    mrx = (
        "# MRX-W09 × CVE-2026-43499 (GhostLock)\n"
        "Device: Huawei MRX-W09 (Kirin 990, arm64, Linux 4.14.116, EMUI 11.0.0.235)\n"
        "### (131) 2026-09-26 *** ACHIEVED: uid 0 ON DEVICE ***\n"
        "### (133) 2026-09-26 *** GOAL COMPLETE *** - rsh -c id prints uid=0(root) on MRX-W09\n"
        "uid=0(root) gid=0(root)\n"
        "### (137) 2026-09-26 root RESTORED after a regression\n"
    )
    bkl = "# GhostLock on BKL-L09 (Kirin 970)\nStatus: root to be achieved\n"
    ok = check(mrx,bkl)
    assert ok["mrx_source_reported_root_status"] == "UID0_AND_ROOT_COMMAND_RECORDED"
    assert ok["bkl_comparison"]=="KIRIN970_ROOT_INCOMPLETE_BANNER"
    assert ok["tas_root_proof"]=="NOT_OBSERVED"
    assert check(mrx.replace("GOAL COMPLETE","GOAL INCOMPLETE"),bkl)[
        "mrx_source_reported_root_status"]=="NOT_FULLY_ESTABLISHED_FROM_INPUT"
    assert check(mrx.replace("EMUI 11.0.0.235","EMUI 10.0.0.235"),bkl)[
        "mrx_source_reported_root_status"]=="NOT_FULLY_ESTABLISHED_FROM_INPUT"
    assert check(mrx,bkl.replace("root to be achieved","root fully achieved"))[
        "bkl_comparison"]=="UNVERIFIED"
    assert check("",bkl)["mrx_source_reported_root_status"]=="NOT_FULLY_ESTABLISHED_FROM_INPUT"
    print("TAS_MRX_REFERENCE_STATUS_SELFTEST_PASS")

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument("--mrx-facts",type=Path)
    p.add_argument("--bkl-readme",type=Path)
    p.add_argument("--selftest",action="store_true")
    p.add_argument("--out",type=Path)
    args=p.parse_args()
    if args.selftest:return selftest()
    if not args.mrx_facts or not args.bkl_readme:
        p.error("--mrx-facts and --bkl-readme are required unless --selftest")
    data=check(args.mrx_facts.read_text(encoding="utf-8",errors="replace"),
               args.bkl_readme.read_text(encoding="utf-8",errors="replace"))
    payload=json.dumps(data,ensure_ascii=False,indent=2)+"\n"
    if args.out: args.out.write_text(payload,encoding="utf-8")
    else: print(payload,end="")

if __name__=="__main__":main()
