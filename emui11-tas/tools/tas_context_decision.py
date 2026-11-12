#!/usr/bin/env python3
"""Deterministic TAS-AN00 decision record from collected nonprivileged evidence.
Does not attempt root, run a kernel exploit, or infer live privilege from static hashes.
"""
import argparse
import json
import pathlib
import re
import sys

def parse_kv(text):
    return dict(x.split("=",1) for x in text.splitlines() if "=" in x and not x.startswith("CASE_"))

def perf_result(text):
    cases=[]
    for line in text.splitlines():
        if line.startswith("perf_") and ("_result=" in line or "_errno=" in line):
            cases.append(line)
    if not cases:return "UNKNOWN"
    if any("_result=ok" in x or "_result=open_ok" in x or "_result=success" in x for x in cases):
        return "POSSIBLE_SUCCESS"
    if all(x.endswith("13") for x in cases if "_errno=" in x) and any("_errno=" in x for x in cases):
        return "EACCES"
    return "OTHER"

def decide(app_context=None,adb=None,perf_shell=None):
    evidence={"device":"TAS-AN00","app_perf":"EACCES (observed 2026-11-12)",
              "mali_11_16":"VERIFIED",
              "mali_six_cases":"PASSED on device",
              "app_file_canary":"THREE_VIEW_MATCH on device",
              "root":"NOT_OBSERVED",
              "bugreportz_kind":"dumpstatez socket client (actual ELF)",
              "dumpstate_process":"UNKNOWN",
              "dumpstate_elf":"NOT_READABLE_FROM_APP",
              "app_perf_scope":"ONLY_PRESTAGE_UNTRUSTED_APP_CONTEXT",
              "post_privileged_stage_perf":"UNMEASURED",
              "reference_mrx_starting_context":"ADB_SHELL_NOT_THIRD_PARTY_APP",
              "reference_mrx_prestage_carrier":"SOURCE_REPORTS_LIBC_PAGE_CACHE",
              "reference_bugreportz_role":"SERVICE_TRIGGER_NOT_PROVEN_PATCH_TARGET",
              "tas_bugreportz_client":"NOT_A_PROOF_OF_PRESTAGE_IMPOSSIBILITY"}
    if app_context:
        p=parse_kv(app_context)
        evidence["app_service_props"]={
            key:p.get(key) for key in [
                "init.svc.dumpstate","init.svc.dumpstatez","init.svc.bugreportd","init.svc.adbd"]
        }
        for line in app_context.splitlines():
            if line.startswith("f01_/system/bin/dumpstate="):
                evidence["app_dumpstate_lstat"]=line.split("=",1)[1]
            if line.startswith("ps_AZ="):evidence["app_ps_visibility"]=line.split("=",1)[1][:1000]
    if adb:
        evidence["adb_dumpstate_elf"]=adb.get("dumpstate_elf",{})
        evidence["adb_context"]=adb.get("shell",{}).get("proc_self_context",{})
        evidence["adb_service_props"]={
            key:value for key,value in adb.get("properties",{}).items()
            if any(x in key for x in ("dumpstate","bugreport","adbd"))
        }
        evidence["adb_dumpstate_stat"]=adb.get("paths",{}).get("/system/bin/dumpstate",{})
        evidence["adb_dumpstate_pid"]=adb.get("processes",{}).get("pidof_dumpstate",{})
        evidence["adb_service_manager"]=adb.get("services",{}).get("service_list",{})
        evidence["adb_perf"]=adb.get("shell",{}).get("perf_event_paranoid",{})
        if adb.get("optional_perf",{}).get("batch"):
            perf_shell=adb["optional_perf"]["batch"].get("output","")
    if perf_shell:
        evidence["shell_perf_diagnostic"]=perf_result(perf_shell)
    recommendation=[]
    if evidence.get("shell_perf_diagnostic")=="EACCES":
        recommendation.append("PRESTAGE_APP_AND_SHELL_PERF_DENIED: privileged post-stage perf access remains UNMEASURED, not permanently blocked.")
    elif evidence.get("shell_perf_diagnostic")=="POSSIBLE_SUCCESS":
        recommendation.append("SHELL_PERF_MAY_WORK: independently validate perf sample count and kernel-IP availability; no Root conclusion.")
    else:
        recommendation.append("SHELL_PERF_UNVERIFIED: owner requires APK-only; do not request ADB or infer privileged-stage failure.")
    elf=evidence.get("adb_dumpstate_elf",{})
    if elf.get("sha256"):
        recommendation.append("DUMPSTATE_ELF_EXACT_HASH_AVAILABLE: compare service executable identity to actual firmware and process label.")
    else:
        recommendation.append("DUMPSTATE_BINARY_UNREADABLE_FROM_APP: app lstat EACCES does not prove privileged service absent or rule out a distinct libc carrier.")
    recommendation.append("DO_NOT_REPEAT_MALI_V1_1: real-device MEM_IMPORT, JOB_SUBMIT and app-private 3-view canary already passed.")
    recommendation.append("ROOT_NOT_ESTABLISHED: MRX source-reported UID0 success does not prove TAS app-to-privileged execution; report only observed operations.")
    return {"schema":"TAS_CONTEXT_DECISION_V2","evidence":evidence,"recommendations":recommendation}

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--app",type=pathlib.Path)
    ap.add_argument("--adb",type=pathlib.Path)
    ap.add_argument("--shell-perf",type=pathlib.Path)
    ap.add_argument("--out",type=pathlib.Path)
    ap.add_argument("--selftest",action="store_true")
    ns=ap.parse_args()
    if ns.selftest:
        assert perf_result("perf_exact_result=error\nperf_exact_errno=13")=="EACCES"
        assert perf_result("perf_exact_result=open_ok\nperf_exact_errno=0")=="POSSIBLE_SUCCESS"
        d=decide(app_context="init.svc.dumpstate=EXIT_0:stopped\n")
        assert d["evidence"]["mali_six_cases"]=="PASSED on device"
        assert len(d["recommendations"])==4
        assert d["evidence"]["app_perf_scope"]=="ONLY_PRESTAGE_UNTRUSTED_APP_CONTEXT"
        assert d["evidence"]["post_privileged_stage_perf"]=="UNMEASURED"
        assert d["evidence"]["tas_bugreportz_client"]=="NOT_A_PROOF_OF_PRESTAGE_IMPOSSIBILITY"
        assert not any("optional read-only shell comparison remains useful" in x for x in d["recommendations"])
        assert not any("APP_AND_SHELL_PERF_DENIED: do not repeat" in x for x in d["recommendations"])
        ds=decide(perf_shell="perf_exact_result=error\\nperf_exact_errno=13")
        assert ds["evidence"]["shell_perf_diagnostic"]=="EACCES"
        assert ds["evidence"]["post_privileged_stage_perf"]=="UNMEASURED"
        assert ds["recommendations"][0].startswith("PRESTAGE_APP_AND_SHELL_PERF_DENIED")
        print("TAS_CONTEXT_DECISION_SELFTEST_PASS")
        return 0
    app=ns.app.read_text(encoding="utf-8",errors="replace") if ns.app else None
    adb=json.loads(ns.adb.read_text(encoding="utf-8")) if ns.adb else None
    shell=ns.shell_perf.read_text(encoding="utf-8",errors="replace") if ns.shell_perf else None
    data=decide(app,adb,shell)
    output=json.dumps(data,ensure_ascii=False,indent=2)+"\n"
    if ns.out:ns.out.write_text(output,encoding="utf-8")
    else:print(output,end="")
    return 0
if __name__=="__main__":sys.exit(main())
