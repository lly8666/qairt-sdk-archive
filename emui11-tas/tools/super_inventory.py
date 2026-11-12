#!/usr/bin/env python3
"""Read-only inventory of extracted ext4 logical partitions of Huawei SUPER.img."""
import hashlib
import json
import pathlib
import re
import subprocess
import sys

CANDIDATES = {
    "system": [
        "system/bin/bugreportz", "bin/bugreportz",
        "system/bin/dumpstate", "bin/dumpstate",
        "system/bin/toybox", "bin/toybox",
        "system/bin/app_process64", "bin/app_process64",
        "system/lib64/libc.so", "lib64/libc.so",
        "system/etc/selinux/plat_sepolicy.cil", "etc/selinux/plat_sepolicy.cil",
        "system/etc/selinux/plat_file_contexts", "etc/selinux/plat_file_contexts",
        "system/etc/selinux/plat_sepolicy_and_mapping.sha256", "etc/selinux/plat_sepolicy_and_mapping.sha256",
        "system/build.prop", "build.prop",
        "system/etc/build.prop", "etc/build.prop",
    ],
    "vendor": [
        "vendor/build.prop", "build.prop", "vendor/etc/build.prop", "etc/build.prop",
        "vendor/etc/selinux/vendor_sepolicy.cil", "etc/selinux/vendor_sepolicy.cil",
        "vendor/etc/selinux/plat_pub_versioned.cil", "etc/selinux/plat_pub_versioned.cil",
        "vendor/etc/selinux/vendor_file_contexts", "etc/selinux/vendor_file_contexts",
        "vendor/lib64/egl/libGLES_mali.so", "lib64/egl/libGLES_mali.so",
        "vendor/lib64/libmali.so", "lib64/libmali.so",
        "vendor/bin/hw/android.hardware.graphics.mapper@2.0-service", "bin/hw/android.hardware.graphics.mapper@2.0-service",
    ],
    "product": ["product/build.prop","build.prop","product/etc/build.prop","etc/build.prop"],
    "odm": ["odm/build.prop", "build.prop"],
    "cust": ["cust/build.prop","build.prop"],
}
MAX_DUMP=80 * 1024 * 1024

def run(*args):
    return subprocess.run(args, capture_output=True, text=True, errors="replace", timeout=30)

def sha256(path):
    h=hashlib.sha256()
    with open(path,"rb") as f:
        for data in iter(lambda:f.read(1048576),b""):
            h.update(data)
    return h.hexdigest()

def safe_filename(name):
    return re.sub("[^a-zA-Z0-9_.-]+","_",name).strip("_")

def candidates(label):
    for key,values in CANDIDATES.items():
        if label.lower().startswith(key): return values
    return ["build.prop","etc/build.prop"]

def dump_image(image,out):
    label=image.stem
    record={"partition":label,"image_bytes":image.stat().st_size,"image_sha256":sha256(image),"files":[]}
    if image.stat().st_size < 1024: return {**record,"error":"image_too_short"}
    magic=image.open("rb").read(4096)
    record["first_16_bytes"]=magic[:16].hex()
    if b"\x53\xef" not in magic[1080:1082]:
        record["warning"]="ext4 magic not at standard 1080 offset; debugfs may not support partition"
    for candidate in candidates(label):
        # debugfs accepts read-only commands by default; never request -w
        query=f"stat /{candidate.lstrip('/')}"
        try: stat=run("debugfs","-R",query,str(image))
        except Exception as exc:
            record["files"].append({"path":candidate,"error":type(exc).__name__+":"+str(exc)})
            continue
        raw=stat.stdout+stat.stderr
        if "Inode:" not in stat.stdout or re.search(r"File not found|not found|not a directory",raw,re.I):
            continue
        size_match=re.search(r"\bSize:\s+(\d+)",stat.stdout)
        size=int(size_match.group(1)) if size_match else None
        item={"path":"/"+candidate,"stat_size":size,"stat_info":stat.stdout[:4000]}
        if size is not None and size>MAX_DUMP:
            item["dump"]="skipped_size_gt_80MiB"
        else:
            dest=out/(safe_filename(label+"__"+candidate)+".bin")
            d=run("debugfs","-R",f"dump -p /{candidate} {dest}",str(image))
            if d.returncode==0 and dest.exists():
                item.update({"output":dest.name,"size":dest.stat().st_size,"sha256":sha256(dest)})
                f=run("file","-b",str(dest))
                item["file_type"]=f.stdout.strip()
                if item["file_type"].startswith("ELF"):
                    elf=run("readelf","-n",str(dest))
                    buildids=re.findall(r"Build ID:\s*([0-9a-f]+)",elf.stdout)
                    item["elf_build_ids"]=buildids
                if dest.stat().st_size<1048576:
                    # readonly text previews only for known config/property files
                    if candidate.endswith((".prop",".cil",".sha256","contexts")):
                        b=dest.read_bytes()
                        item["text_preview"]=b.decode("utf-8","replace")[:9000]
            else:
                item["dump_error"]=(d.stdout+d.stderr)[-1200:]
        record["files"].append(item)
    return record

def main():
    if len(sys.argv)!=3:
        raise SystemExit("usage: super_inventory.py <partitions_dir> <output_dir>")
    root=pathlib.Path(sys.argv[1]);out=pathlib.Path(sys.argv[2])
    out.mkdir(parents=True,exist_ok=True)
    images=sorted(root.glob("*.img"))
    data={"schema":"TAS_SUPER_INVENTORY_V1","read_only":True,"partition_count":len(images),"partitions":[]}
    for img in images:
        print("Inspecting",img,flush=True)
        data["partitions"].append(dump_image(img,out))
    (out/"super_inventory.json").write_text(json.dumps(data,ensure_ascii=False,indent=2)+"\n")
    with open(out/"super_inventory.txt","w") as f:
        f.write("TAS_SUPER_INVENTORY_V1\n\n")
        for p in data["partitions"]:
            f.write(f"PARTITION {p['partition']} ({p['image_bytes']:,} bytes) {p.get('warning','')}\n")
            for z in p["files"]:
                f.write(f" {z['path']} size={z.get('size')} sha256={z.get('sha256')} type={z.get('file_type')}\n")
    print("FOUND_FILES",sum(len(p["files"]) for p in data["partitions"]),flush=True)
if __name__=="__main__":main()
