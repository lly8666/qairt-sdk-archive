#!/usr/bin/env python3
"""TAS-AN00 reproducibility gate: read-only proof classification, not an exploit.

Consumes owner-authorized text logs and emits a machine-readable distinction
between observed GPU compatibility, service declarations, app perf permission,
and actual Root (not verified by these evidence types).
Python 3.8+ standard library only. No device, network, shell, or kernel access.
"""
import argparse
import json
from pathlib import Path
import re
import sys

GPU_START="TAS_MALI_COMPAT_V2_BEGIN"
GPU_END="TAS_MALI_COMPAT_V2_END"
SERVICE_START="TAS_SERVICE_CONTEXT_V2_BEGIN"
SERVICE_END="TAS_SERVICE_CONTEXT_V2_END"

def kv(text):
    """Keep last exact key, not substring matches."""
    result={}
    for line in text.splitlines():
        if line.count("=")>=1 and not line.lstrip().startswith("#"):
            k,v=line.split("=",1)
            if re.fullmatch(r"[A-Za-z][A-Za-z0-9_./:-]*",k):
                result[k]=v.strip()
    return result

def classify_gpu(text):
    base={"api":"NOT_PROVIDED","canary":"NOT_PROVIDED","verified_cases":[]}
    if not text:return base
    if GPU_START not in text or GPU_END not in text:
        base["api"]="INCOMPLETE_LOG"
        base["canary"]="INCOMPLETE_LOG"
        return base
    values=kv(text)
    expected={f"{i:02d}" for i in range(6)}
    exits=dict(re.findall(r"^CASE_EXIT=(\d{2}):(\d+)$",text,re.MULTILINE))
    ended=set(re.findall(r"^CASE_END=(\d{2}):",text,re.MULTILINE))
    base["verified_cases"]=sorted(
        k for k in expected if exits.get(k)=="0" and k in ended)
    checks=[
        values.get("abi_reported")=="11.16",
        values.get("set_flags_status")=="PASS",
        values.get("tracking_map_status")=="PASS",
        values.get("mem_alloc_ioctl_status")=="PASS",
        values.get("mem_alloc_cpu_map_status")=="PASS",
        values.get("mem_alloc_roundtrip")=="PASS",
        values.get("mem_import_ioctl_status")=="PASS",
        values.get("mem_import_cpu_map_status")=="PASS",
        values.get("soft_job_submit_status")=="PASS",
    ]
    all_cases=len(base["verified_cases"])==6 and set(base["verified_cases"])==expected
    base["api"]="DEVICE_PASS" if all_cases and all(checks) and values.get("native_exit_code")=="0" else "NOT_ALL_PASS"
    cache=[
        values.get("private_dir_guard")=="PASS",
        values.get("canary_path_scope")=="app_private_only",
        values.get("canary_create")=="PASS",
        values.get("canary_ro_map")=="PASS",
        values.get("canary_same_fd_read_bytes")=="4096",
        values.get("canary_same_fd_modified")=="1",
        values.get("canary_second_fd_modified")=="1",
        values.get("canary_private_map_modified")=="1",
        values.get("canary_cleanup")=="PASS",
    ]
    base["canary"]="APP_OWNED_3_VIEW_PASS" if base["api"]=="DEVICE_PASS" and all(cache) else "NOT_PROVED"
    return base

def classify_service(text):
    result={"service_config":"NOT_PROVIDED","app_domain":"NOT_PROVIDED",
            "bugreport_binder":"UNKNOWN","dumpstate_elf_access":"UNKNOWN",
            "init_service_runtime":"NOT_OBSERVED"}
    if not text:return result
    if SERVICE_START not in text or SERVICE_END not in text:
        result["service_config"]="INCOMPLETE_LOG"
        return result
    values=kv(text)
    sys=values.get("rc00_content","")
    vend=(values.get("rc04_content","")+" "+values.get("rc05_content",""))
    targets=["service dumpstate /system/bin/dumpstate -s",
             "service dumpstatez /system/bin/dumpstate -S -d -z",
             "service bugreportd /system/bin/dumpstate -w"]
    if all(x in sys for x in targets) and "service bugreport /system/bin/dumpstate" in vend:
        result["service_config"]="FOUR_INIT_MODES_DECLARED"
    else:result["service_config"]="PARTIAL_OR_DIFFERENT"
    domain=values.get("proc_self_context","")
    if "u:r:untrusted_app" in domain:result["app_domain"]="UNTRUSTED_APP"
    elif domain:result["app_domain"]="OTHER_NOT_PRIVILEGE_PROOF"
    listed=values.get("service_list_filtered","")
    checked=values.get("service_check_bugreport","")
    if "bugreport:" in listed:
        result["bugreport_binder"]="LISTED"
    if "not found" in checked and result["bugreport_binder"]=="LISTED":
        result["bugreport_binder"]="LISTED_CHECK_NOT_FOUND"
    path=values.get("f01_/system/bin/dumpstate","")
    if "EACCES" in path or "ERRNO_13" in path:result["dumpstate_elf_access"]="APP_EACCES"
    elif "OK" in path:result["dumpstate_elf_access"]="APP_STAT_OK"
    return result

def classify_perf(text):
    if not text:return "KNOWN_APP_EACCES_FROM_PRIOR_USER_LOG_NOT_RETESTED"
    values=kv(text)
    errors=[values.get(x) for x in
        ("perf_task_user_errno","perf_cpu_user_errno",
         "perf_cpu_kernel_only_errno","perf_exact_errno")]
    if all(e=="13" for e in errors):return "APP_EACCES_ALL_FOUR"
    if any(e is None for e in errors):return "INCOMPLETE"
    return "DIFFERENT_RESULT_NEEDS_MANUAL_REVIEW"

def report(gpu="",service="",perf=""):
    g=classify_gpu(gpu);s=classify_service(service);p=classify_perf(perf)
    return {
        "schema":"TAS_REPRO_EVIDENCE_GATE_V1",
        "target":"TAS-AN00, EMUI 11.0.0.185, Android10, Kirin990",
        "evidence":{
          "mali_api":g["api"],
          "gpu_case_pass_ids":g["verified_cases"],
          "page_cache":g["canary"],
          "page_cache_scope":"OWNER_APP_PRIVATE_FILE_ONLY",
          "dumpstate_init":s["service_config"],
          "dumpstate_process":"NOT_OBSERVED_FROM_APP_SCAN",
          "app_selinux":s["app_domain"],
          "binder_bugreport":s["bugreport_binder"],
          "dumpstate_executable":s["dumpstate_elf_access"],
          "perf":p,
        },
        "root_status":"NOT_VERIFIED",
        "root_claim_allowed":False,
        "reasons":[
          "GPU page-cache tests against an app-owned file do not prove system executable modification.",
          "Static init service definitions do not prove live elevated execution.",
          "No independent evidence of privileged euid/capabilities/SELinux or Root action.",
        ],
        "user_constraints":{"phone_only":False,"request_adb":True,
                            "preferred_host":"WINDOWS_ADB_SHELL_READ_ONLY",
                            "repeat_gpu_tests":False,"privacy_cleanup":"DEFERRED"},
    }

def selftest():
    gpu=["TAS_MALI_BATCH_RUNNER_BEGIN",GPU_START,"abi_reported=11.16",
        "set_flags_status=PASS","tracking_map_status=PASS",
        "mem_alloc_ioctl_status=PASS","mem_alloc_cpu_map_status=PASS",
        "mem_alloc_roundtrip=PASS","mem_import_ioctl_status=PASS",
        "mem_import_cpu_map_status=PASS","soft_job_submit_status=PASS",
        "private_dir_guard=PASS","canary_path_scope=app_private_only",
        "canary_create=PASS","canary_ro_map=PASS",
        "canary_same_fd_read_bytes=4096","canary_same_fd_modified=1",
        "canary_second_fd_modified=1","canary_private_map_modified=1",
        "canary_cleanup=PASS"]
    for i in range(6):gpu.extend([f"CASE_EXIT={i:02d}:0",f"CASE_END={i:02d}:ok"])
    gpu.extend([GPU_END,"native_exit_code=0","TAS_MALI_BATCH_RUNNER_END"])
    lines="\n".join(gpu)
    assert classify_gpu(lines)["api"]=="DEVICE_PASS"
    assert classify_gpu(lines)["canary"]=="APP_OWNED_3_VIEW_PASS"
    assert classify_gpu(lines.replace("canary_second_fd_modified=1","canary_second_fd_modified=0"))["canary"]=="NOT_PROVED"
    assert classify_gpu(lines.replace("CASE_EXIT=05:0","CASE_EXIT=05:1"))["api"]=="NOT_ALL_PASS"
    assert classify_gpu(lines.replace(GPU_END,"NO_END"))["api"]=="INCOMPLETE_LOG"
    serv="\n".join([SERVICE_START,
        "rc00_content=service dumpstate /system/bin/dumpstate -s | service dumpstatez /system/bin/dumpstate -S -d -z | service bugreportd /system/bin/dumpstate -w",
        "rc04_content=service bugreport /system/bin/dumpstate -d -p",
        "proc_self_context=u:r:untrusted_app_27:s0",
        "service_list_filtered=EXIT_0: 180 bugreport: []",
        "service_check_bugreport=EXIT_0: Service bugreport: not found",
        "f01_/system/bin/dumpstate=ERRNO_13:lstat failed: EACCES",
        SERVICE_END])
    assert classify_service(serv)["service_config"]=="FOUR_INIT_MODES_DECLARED"
    assert classify_service(serv)["bugreport_binder"]=="LISTED_CHECK_NOT_FOUND"
    assert report(lines,serv)["root_status"]=="NOT_VERIFIED"
    assert report(lines,serv)["root_claim_allowed"] is False
    assert classify_perf("\n".join(x+"=13" for x in
      ("perf_task_user_errno","perf_cpu_user_errno",
       "perf_cpu_kernel_only_errno","perf_exact_errno")))=="APP_EACCES_ALL_FOUR"
    print("TAS_REPRO_EVIDENCE_GATE_SELFTEST_PASS")

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument("--gpu-log",type=Path,help="previous six-case native app log")
    p.add_argument("--service-log",type=Path,help="previous V2 init/context app log")
    p.add_argument("--perf-log",type=Path,help="optional previous perf read-only log")
    p.add_argument("--output",type=Path,help="write JSON summary to file")
    p.add_argument("--selftest",action="store_true")
    args=p.parse_args()
    if args.selftest:return selftest()
    read=lambda f:f.read_text(encoding="utf-8",errors="replace") if f else ""
    data=report(read(args.gpu_log),read(args.service_log),read(args.perf_log))
    output=json.dumps(data,ensure_ascii=False,indent=2)+"\n"
    if args.output:args.output.write_text(output,encoding="utf-8")
    else:sys.stdout.write(output)

if __name__=="__main__":main()
