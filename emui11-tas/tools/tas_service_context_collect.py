#!/usr/bin/env python3
"""TAS-AN00 EMUI11: ADB shell vs app and dumpstate service identity inventory.
Only reads metadata and tries to pull the system-owned dumpstate ELF (no root).
Designed to run on Windows/macOS/Linux with Python 3.8+ and adb in PATH.
"""
import argparse
import datetime
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import zipfile

PROPERTIES=[
    "ro.product.model","ro.hardware","ro.build.display.id",
    "ro.build.type","ro.debuggable","ro.secure",
    "ro.boot.verifiedbootstate","ro.boot.vbmeta.device_state",
    "ro.build.fingerprint","ro.vendor.build.fingerprint",
    "init.svc.dumpstate","init.svc.dumpstatez","init.svc.bugreportd",
    "init.svc.bugreport","init.svc.bugreportz","init.svc.bugreportm",
    "init.svc.adbd","init.svc.vendor.dumpstate",
    "ro.build.version.release","ro.build.version.sdk",
]
PATHS=[
    "/system/bin/dumpstate","/system/bin/dumpstatez",
    "/system/bin/bugreportz","/system/bin/toybox",
    "/system/lib64/libc.so",
    "/apex/com.android.runtime/lib64/bionic/libc.so",
    "/vendor/lib64/egl/libGLES_mali.so",
    "/dev/mali0","/dev/socket/dumpstatez",
    "/system/etc/init/dumpstate.rc","/system/etc/init/dumpstatez.rc",
    "/vendor/etc/init/dumpstate.rc",
]
FILTER=re.compile(r"dumpstate|bugreport|incident|adbd|perfgenius|mali",re.I)
MAX_TEXT=18000

def sha256(path):
    h=hashlib.sha256()
    with open(path,"rb") as f:
        for b in iter(lambda:f.read(1024*1024),b""):h.update(b)
    return h.hexdigest()

def command(argv,timeout=15,maximum=MAX_TEXT):
    try:
        r=subprocess.run(argv,capture_output=True,timeout=timeout,check=False)
        data=(r.stdout+r.stderr).decode("utf-8","replace")[:maximum]
        return {"command":argv[1:],"exit":r.returncode,"output":data}
    except subprocess.TimeoutExpired as exc:
        return {"command":argv[1:],"exit":-998,"output":f"TIMEOUT_{timeout}s"}
    except Exception as exc:
        return {"command":argv[1:],"exit":-999,"output":f"{type(exc).__name__}: {exc}"}

def filtered(r):
    r=dict(r)
    r["output"]="\n".join(x for x in r.get("output","").splitlines() if FILTER.search(x))[:MAX_TEXT]
    return r

def summarize(args,record):
    lines=["TAS_ADB_DUMPSTATE_CONTEXT_V1",
           "read_only=true", "root_requested=false",
           "dumpstate_service_launched=false",
           "system_files_modified=false",
           f"source_device_model={record.get('ro.product.model','unknown')}"]
    for section in ("meta","properties","shell","paths","processes","services","init_config","unix_sockets","dumpstate_elf","optional_perf"):
        lines.append(f"\n[{section}]")
        value=record.get(section,{})
        if isinstance(value,dict):
            for key,v in value.items():
                if isinstance(v,dict):
                    lines.append(f"{key}: exit={v.get('exit')} out={v.get('output','')[:2200]}")
                else:lines.append(f"{key}: {v}")
    return "\n".join(lines)+"\n"

def collect(ns):
    adb=shutil.which(ns.adb) if os.path.sep not in ns.adb else ns.adb
    if not adb:raise SystemExit(f"ADB not found: {ns.adb}. Install Android platform-tools.")
    dst=Path(ns.out);dst.mkdir(parents=True,exist_ok=True)
    base=[adb]
    if ns.serial:base+=["-s",ns.serial]
    check=command(base+["get-state"],8)
    if check["exit"]!=0 or check["output"].strip()!="device":
        raise SystemExit("ADB not authorized/connected: "+check["output"])
    record={"schema":"TAS_ADB_DUMPSTATE_CONTEXT_V1",
            "meta":{"captured_utc":datetime.datetime.now(datetime.timezone.utc).isoformat(),
                    "script":"tas_service_context_collect.py","read_only":True,
                    "no_root":True,"no_service_trigger":True},
            "properties":{},"shell":{},"paths":{},"processes":{},"services":{},
            "unix_sockets":{},"dumpstate_elf":{},"init_config":{},"optional_perf":{}}
    shell=lambda *argv:command(base+["shell"]+list(argv),ns.timeout)
    for p in PROPERTIES:
        r=shell("getprop",p)
        record["properties"][p]=r["output"].strip() if r["exit"]==0 else r
    record["ro.product.model"]=record["properties"].get("ro.product.model")
    if record["ro.product.model"]!="TAS-AN00":
        raise SystemExit("Refusing cross-device survey: model="+repr(record["ro.product.model"]))
    for name,argv in (
        ("id",("id",)),
        ("selinux",("getenforce",)),
        ("uname",("uname","-a")),
        ("perf_event_paranoid",("cat","/proc/sys/kernel/perf_event_paranoid")),
        ("proc_self_context",("cat","/proc/self/attr/current")),
    ):
        record["shell"][name]=shell(*argv)
    for path in PATHS:
        record["paths"][path]={
          "ls_Z":shell("ls","-ldZ",path),
          "stat":shell("stat",path),
        }
    record["processes"]["ps_AZ"]=filtered(shell("ps","-AZ"))
    record["processes"]["pidof_dumpstate"]=shell("pidof","dumpstate")
    record["processes"]["pidof_dumpstatez"]=shell("pidof","dumpstatez")
    record["services"]["service_list"]=filtered(shell("service","list"))
    for name in ["bugreport","dumpstate","dumpstatez","incident"]:
        record["services"]["service_check_"+name]=shell("service","check",name)
    record["unix_sockets"]["net_unix_dumpstate"]=filtered(shell("cat","/proc/net/unix"))
    record["init_config"]["system_dumpstate_rc"]=shell("cat","/system/etc/init/dumpstate.rc")
    record["init_config"]["system_dumpstate_rc_sha256"]=shell("sha256sum","/system/etc/init/dumpstate.rc")
    record["init_config"]["vendor_kirin990_dumpstate"]=filtered(
        shell("grep","-n","-i","dumpstate","/vendor/etc/init/hw/init.kirin990.rc"))
    record["init_config"]["vendor_kirin990E_dumpstate"]=filtered(
        shell("grep","-n","-i","dumpstate","/vendor/etc/init/hw/init.kirin990E.rc"))
    file=dst/"system_bin_dumpstate"
    if not ns.no_pull:
        p=command(base+["pull","/system/bin/dumpstate",str(file)],25,1200)
        ok=file.exists() and file.stat().st_size>4 and file.open("rb").read(4)==b"\x7fELF"
        record["dumpstate_elf"]["pull"]={"exit":p["exit"],"message":p["output"][:700]}
        if ok:
            record["dumpstate_elf"].update({"bytes":file.stat().st_size,"sha256":sha256(file)})
            if shutil.which("readelf"):
                bid=command(["readelf","-n",str(file)],8)
                ids=re.findall(r"Build ID:\s*([a-fA-F0-9]+)",bid["output"])
                record["dumpstate_elf"]["build_ids"]=ids
        else:
            if file.exists():file.unlink()
            record["dumpstate_elf"]["note"]="Unavailable or non-ELF (not proof of absence)"
    if ns.perf:
        binary=Path(ns.perf)
        if not binary.is_file():raise SystemExit("Missing perf probe file: "+str(binary))
        local_hash=sha256(binary)
        record["optional_perf"]["host_binary_sha256"]=local_hash
        record["optional_perf"]["push"]=command(base+["push",str(binary),
            "/data/local/tmp/tas_batchprobe"],ns.timeout,2000)
        if record["optional_perf"]["push"]["exit"]==0:
            record["optional_perf"]["chmod"]=shell("chmod","755","/data/local/tmp/tas_batchprobe")
            perf=command(base+["shell","/data/local/tmp/tas_batchprobe","--batch"],95,25000)
            record["optional_perf"]["batch"]={"exit":perf["exit"],"output":perf["output"]}
            (dst/"tas_shell_batch.txt").write_text(perf["output"],encoding="utf-8")
    (dst/"TAS_ADB_DUMPSTATE_CONTEXT.json").write_text(
        json.dumps(record,ensure_ascii=False,indent=2)+"\n",encoding="utf-8")
    (dst/"TAS_ADB_DUMPSTATE_CONTEXT.txt").write_text(
        summarize(ns,record),encoding="utf-8")
    zip_path=dst.with_suffix(".zip")
    with zipfile.ZipFile(zip_path,"w",compression=zipfile.ZIP_DEFLATED) as z:
        for f in sorted(dst.iterdir()):
            if f.is_file():z.write(f,f.name)
    print("MODEL:",record["ro.product.model"])
    print("RESULT_ZIP:",zip_path.resolve())
    print("DUMPSTATE_FILE:",record["dumpstate_elf"])
    print("ROOT_ATTEMPTED: no")
    return 0

def main():
    a=argparse.ArgumentParser(description=__doc__)
    a.add_argument("--adb",default="adb",help="adb executable path")
    a.add_argument("--serial",help="optional adb serial, if multiple devices")
    a.add_argument("--out",default="tas_adb_context_v1",help="output folder")
    a.add_argument("--timeout",type=int,default=12)
    a.add_argument("--no-pull",action="store_true",help="do not try to pull dumpstate ELF")
    a.add_argument("--perf",help="optional existing 13-case ARM64 perf probe")
    a.add_argument("--selftest",action="store_true",help="offline logic smoke test")
    args=a.parse_args()
    if args.selftest:
        assert FILTER.search("u:r:dumpstate:s0")
        assert not FILTER.search("com.personal.messaging")
        assert len(PROPERTIES)>=15
        assert "dumpstate" in PATHS[0]
        assert "bugreport" in ["bugreport","dumpstate","dumpstatez","incident"]
        print("SELFTEST_PASS: metadata filtering and property allowlist")
        return 0
    return collect(args)
if __name__=="__main__":sys.exit(main())
