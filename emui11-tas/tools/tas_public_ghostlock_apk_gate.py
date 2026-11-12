#!/usr/bin/env python3
"""TAS-AN00: read-only APK compatibility gate using pinned public GitHub metadata.

No binaries are downloaded, executed or installed. No exploit or root is attempted.
"""
import argparse
import json
from pathlib import Path
import re

TARGET = {"model":"TAS-AN00", "android_sdk":29, "android_version":"10",
          "emui":"11.0.0.185", "kernel":"4.14.116", "root_verified":False}
SOURCES = [
  {"name":"YuKongA/ghostlock-app", "commit":"5f6d604c0ae66b28530af40bf9b540eeb311b141",
   "role":"root_app", "min_sdk":31, "families":["5.10","5.15","6.1","6.6","6.12"],
   "profile":False, "proof":"app/build.gradle.kts minSdk=31; kernel_profiles/index.conf excludes 4.14.116"},
  {"name":"markyogi585-bot/ghostlock-app", "commit":"9da68bb938af158d8b3f1a67ba7b3445267e748d",
   "role":"root_app", "min_sdk":30, "families":None, "profile":None,
   "proof":"app/build.gradle.kts minSdk=30; kernel profiles not independently checked"},
  {"name":"Haoyu-UT/robust-ghostlock-app", "commit":"9cdc4acbc283a1d1c84a3eb10379f7c9a960fb02",
   "role":"root_app", "min_sdk":None, "min_android":12,
   "families":["5.10","5.15","6.1","6.6","6.12"], "profile":False,
   "proof":"README.md requires Android12+ and supports kernels 5.10–6.12"},
  {"name":"BellezaEmporium/ghostlock-bkl-l09", "commit":"381476444fbbbcf0c5e8e3c2e2166647e9134ab5",
   "role":"manager_only", "min_sdk":26, "families":None, "profile":None,
   "proof":"app/README.md minSdk=26, describes UI for separate root-side service"},
]

def parse_min_sdk(text):
    matches=re.findall(r'(?m)^\s*minSdk\s*=\s*(\d+)\s*$',text)
    matches+=re.findall(r'(?m)^\s*minSdkVersion\s+(\d+)\s*$',text)
    return int(matches[0]) if len(matches)==1 else None

def parse_profiles(text):
    return re.findall(r'\brelease\s*=\s*"([^"]+)"',text)

def assess(s):
    api=TARGET['android_sdk']
    if s['min_sdk'] is not None and s['min_sdk']>api:
        installer='BLOCKED_MIN_SDK'
    elif s.get('min_android') and int(TARGET['android_version'])<s['min_android']:
        installer='BLOCKED_ANDROID_REQUIREMENT'
    elif s['min_sdk'] is not None:
        installer='VERSION_COMPATIBLE_ONLY'
    else:
        installer='MANIFEST_UNVERIFIED'
    if s['role']=='manager_only':
        capability='NEEDS_ALREADY_RUNNING_PRIVILEGED_SERVICE'
    elif s['profile'] is False:
        capability='NO_EXACT_TAS_KERNEL_PROFILE'
    elif s['profile'] is None:
        capability='PROFILE_UNVERIFIED'
    else:
        capability='PROFILE_PRESENT_NOT_ROOT_PROOF'
    families=s['families']
    family=TARGET['kernel'].rsplit('.',1)[0]
    kernel_status=('FAMILY_UNKNOWN' if families is None else
        'FAMILY_NOT_SUPPORTED' if family not in families else 'FAMILY_LISTED_ONLY')
    return {"repository":s['name'],"pinned_commit":s['commit'],"installer":installer,
            "kernel_family":kernel_status,"capability":capability,
            "source_evidence":s['proof'],"root_verified_on_TAS":False}

def report():
    return {"schema":"TAS_GHOSTLOCK_PUBLIC_APK_GATE_V1", "date":"2026-11-12",
            "target":TARGET, "checks":[assess(s) for s in SOURCES],
            "conclusion":"NO_VERIFIED_READY_TO_INSTALL_TAS_ROOT_APK_IN_CHECKED_SET",
            "limits":["An installable app is not proof of root capability.",
                "EMUI11 on this device is Android10 API29.",
                "No live TAS exploit, credential change or privilege transition was tested."]}

def selftest():
    assert parse_min_sdk('minSdk = 31\n')==31
    assert parse_min_sdk('minSdkVersion 26\n')==26
    assert parse_min_sdk('targetSdk = 30\n') is None
    assert parse_profiles('profiles=[{ release = "4.14.116" }]')==['4.14.116']
    rows=report()['checks']
    assert rows[0]['installer']=='BLOCKED_MIN_SDK'
    assert rows[1]['installer']=='BLOCKED_MIN_SDK'
    assert rows[2]['installer']=='BLOCKED_ANDROID_REQUIREMENT'
    assert rows[2]['kernel_family']=='FAMILY_NOT_SUPPORTED'
    assert rows[3]['installer']=='VERSION_COMPATIBLE_ONLY'
    assert rows[3]['capability']=='NEEDS_ALREADY_RUNNING_PRIVILEGED_SERVICE'
    assert all(not x['root_verified_on_TAS'] for x in rows)
    print('TAS_GHOSTLOCK_PUBLIC_APK_GATE_SELFTEST_PASS')

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--selftest',action='store_true')
    p.add_argument('--out',type=Path)
    args=p.parse_args()
    if args.selftest:return selftest()
    data=json.dumps(report(),ensure_ascii=False,indent=2)+'\n'
    if args.out:args.out.write_text(data,encoding='utf-8')
    else:print(data,end='')

if __name__=='__main__':main()
