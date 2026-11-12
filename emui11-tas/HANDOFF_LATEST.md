# TAS-AN00 GhostLock Research — Current State / Next-Agent Handoff
Updated: 2026-11-12 (UTC) | Status: **Mali 11.16 six-case real-device PASS; exact toybox/BKL static layout match and vendor init bugreport service verified; v1.2 service survey APK built; app-context perf EACCES persists; root not achieved.**
Branch: `emui11-firmware-offline-audit-20261112` | Draft PR: https://github.com/lly8666/qairt-sdk-archive/pull/124

## LATEST ROUND 2026-11-12: privilege-entry static preflight + v1.2 service collector

**New major firmware evidence — real Vendor init.rc**:
- 3 EROFS regions extracted from the user's `SUPER.img` in passing CI:
  https://github.com/lly8666/qairt-sdk-archive/actions/runs/43186500899.
- `region_1/etc/init/hw/init.kirin990.rc` and `init.kirin990E.rc`, lines 1238-1244:
  `service bugreport /system/bin/dumpstate -d -p -B -z -o /data/user_de/0/com.android.shell/files/bugreports/bugreport`, `class main`, `disabled`, `oneshot`, `keycodes 114 115 116`. No explicit user => Android init generally runs as UID0 by default. **No direct on-device service UID, domain, or execution evidence yet.**
- `region_1/ueventd.rc` has `/dev/mali0 0666 system system`, exactly matching runtime.
- Real TAS `/system/bin/bugreportz` is a 11,632B `dumpstatez` socket client, not the privileged daemon.

**Exact TAS toybox ELF: unusual static compatibility with BKL reference**:
- Original user-supplied `toybox` SHA256 `549a1750493b7c2df15798a387ec61fdbed89bb8ee6f7123a9bf91371d3e167b`, BuildID `230b56fefa5048df13b5b128499c7087`.
- BKL reference uses `toybox` prologue candidate at file offset `0x29050` with original ARM64 word `0xd10203ff`; target TAS's **actual first four bytes exactly match**. ELF entry `0x29000`, executable LOAD from `0x29000` through `0x6b970`, following RW LOAD at `0x6c000`. Blank tail `0x6b970–0x6bfff` is 1680 zero bytes. Static layout compatibility ≠ runtime payload execution or privilege escalation.
- New definitive detailed record: [validation/TAS_INITRC_TOYBOX_STATIC_20261112.md](validation/TAS_INITRC_TOYBOX_STATIC_20261112.md).

**Verified downloadable delivery (compiled and packaged in current conversation):**
- `TAS_AN00_Mali_Service_Survey_v1_2.apk`, **69,690 B**, SHA256 `548ce356f205fab041c52b1d4e62ba360a91f12e0f51cd9d558e4064d49ebf0d`.
- `TAS_AN00_EMUI11_Dumpstate_Service_Batch_v1_2.zip`, **51,943 B**, SHA256 `529b11842ab5e42a8a13156dfb5407d28d02bba3daf692451e93bc6afdbe1536`. Contents: v1.2 APK, cross-platform ADB collector, deterministic decision script, the pinned 13-case ARM64 perf probe, vendor init service excerpts, static toybox layout JSON, usage README, APK/CI signature and selftest records, per-file SHA256 sums. ZIP CRC check passed.
- Successful v1.2 CI workflow: https://github.com/lly8666/qairt-sdk-archive/actions/runs/43186655822. App is a **new v12 package**, so does not replace earlier independently signed v1.1 APK.
- In the v1.2 APK, press button **4** only to capture `TAS_SERVICE_CONTEXT_V1_BEGIN ... END` and send text. If PC ADB is available use `python tas_service_context_collect.py --perf TAS_AN00_KASLR_BatchProbe_arm64`, then submit the resulting `tas_adb_context_v1.zip`.
- ADB script deliberately does not launch dumpstate, trigger kernel UAF, read user data, or modify system files; app still carries the old optional GPU test but no need to rerun it.

**New artifact (built, signed, host logic tests pass; NOT yet tested on handset):**
- Android app `emui11-tas/runtime-inventory` v1.2, package `io.github.tasaudit.runtimeinventory.v12`, `versionCode 3`, Android 10 min SDK29/targetSDK27. APK size 69,690 bytes, SHA256 **`548ce356f205fab041c52b1d4e62ba360a91f12e0f51cd9d558e4064d49ebf0d`**. Built and v2-signed in successful Actions https://github.com/lly8666/qairt-sdk-archive/actions/runs/43186655822.
- **Button 4** runs noninvasive `TAS_SERVICE_CONTEXT_V1` via `ServiceSurvey.java` and persistently saves logs: relevant init properties, SELinux file labels, socket stat, process visibility and Binder service manager. No `dumpstate` service start, no root or GPU ioctl. Existing button 2 remains an optional potentially crash-prone GPU test **already passed and does not need rerun**.
- One-shot optional PC ADB script `emui11-tas/tools/tas_service_context_collect.py` gathers only relevant service state / metadata and attempts a read-only `adb pull /system/bin/dumpstate`. Optional `--perf TAS_AN00_KASLR_BatchProbe_arm64` compares ADB shell perf preconditions (without triggering an exploit). Tested with `--selftest`.
- Classifier `emui11-tas/tools/tas_context_decision.py` combines app and ADB observations, labels no-root state, and avoids false conclusions; `--selftest` passed.
- CI artifacts include v1.2 APK, native known 11.16 probe, read-only ADB collector and classifier; no raw proprietary system ELF committed.
- **Next operator input**: request only 1) button-4's `TAS_SERVICE_CONTEXT_V1` full text, and 2) if PC ADB available, its `tas_adb_context_v1.zip`. Do **not** ask for the already provided v1.1 GPU log or system ELF ZIP again.

**Residual blockers**:
1. `dumpstate` actual executable unreadable in ordinary app; init definition alone does not prove live SELinux domain.
2. Using GPU page-cache canary on an **app-owned** file does not establish system executable memory tampering or privileged execution.
3. `perf_event_open` still EACCES in app; GhostLock root never advanced past KASLR leak.
4. No Root on target was observed. Keep this explicit.

## Latest verified evidence: Mali v1.1 SIX-CASE PASS + system ELF ZIP (2026-11-12)

**Authoritative new report:** [validation/TAS_DEVICE_MALI_V2_ELF_20261112.md](validation/TAS_DEVICE_MALI_V2_ELF_20261112.md).

- Real TAS handset returned `native_exit_code=0`, `CASE_EXIT=00:0` ... `CASE_EXIT=05:0` for six Bifrost 11.16 reference API cases. `SET_FLAGS`, tracking map, `MEM_ALLOC` + one-page CPU roundtrip, `MEM_IMPORT` + CPU map, `JOB_SUBMIT` all **PASS**.
- App-owned private file cache canary **PASS in three independent observations**: `canary_same_fd_modified=1`, `canary_second_fd_modified=1`, `canary_private_map_modified=1`; `canary_cleanup=PASS`. This is not evidence of privileged executable tampering, kernel addresses, or Root.
- User provided original system-ELF archive: `system-elfs.zip`, 769,979 bytes, SHA256 `1e92d7a89d33063b4040beb25b774472c81c821ef12aaa59990eb9ff6ded19e0`. All 6 included files validated against earlier runtime inventory.
- 4 pinned Build IDs:
  - `bugreportz`: `d64becc0edbe4144757a73be2b322d6a` (11,632-byte CONFIRMED `dumpstatez` socket CLIENT: imports `socket_local_client` and contains `FAIL:Failed to connect to dumpstatez service`; it is not the privileged service)
  - `toybox`: `230b56fefa5048df13b5b128499c7087`
  - `app_process64`: `3dc4e1c3832386d747cee6ace24f22b9`
  - APEX `libc.so`: `0f53a45090c371e49b6824269190f1fa`.
- `/system/bin/dumpstate` denied to ordinary app; **do not conclude it is absent**. Vendor-only CIL cannot independently prove effective merged SELinux policy.
- **NEXT:** Avoid more GPU ABI/canary re-testing. Ground any code compatibility work in the actual ELF Build IDs. Remaining failure is `perf_event_open EACCES` from the app; no elevated context/root has yet been observed. If necessary, acquire only `dumpstate` read-only metadata from an authorized context. Do not commit the user's proprietary system binaries to the public repo.

## Target (actual user-provided on-device logs)
Huawei Mate 30 `TAS-AN00` / `HWTAS` / board `TAS` / `kirin990`
- EMUI `11.0.0.185(C00E180R7P11)`, Android `10`, API `29`, ARM64
- Kernel `4.14.116`, compiled `Wed Jul 21 19:39:33 CST 2021`
- Bootloader `locked`; AVB state `green`
- App SELinux `u:r:untrusted_app:s0` or `untrusted_app_27`; Seccomp=2, CapEff=0
- RootLab 0.1 and 0.2 compiled and tested on user's TAS device; `--root` returns `[-] KASLR leak failed`, exit 1 **before any memory-write primitive executes**.
- `perf_event_paranoid=3`, four `perf_event_open` shapes all EACCES (errno 13) in app. `/proc/kallsyms`, `/proc/sys/kernel/kptr_restrict`, and `/sys/fs/selinux/enforce` inaccessible to app.
- Distinct next requirement: privileged-stage reference or safe GPU probe; do not repeat app `--root` expecting a different result.

## Firmware provenance and offline evidence
Release: https://github.com/lly8666/qairt-sdk-archive/releases/tag/emui11_t
- `UPDATE.APP.zip`: 303,573,408 bytes, SHA256 `fb4cec6aa905416ede031cca602783bc1e59fdd89ee96ba1aaa54dbdaf351b0f`
- ARM64 kernel from BOOT: SHA256 `d4b6f00aff4a4e05a3d5d794552165b0c950913aa841b356cae9bc69ae8ea2e5`
- `SUPER.img`: **1,435,996,536 bytes**, valid Android sparse; NOT standard LP geometry. Sparse raw image contains 3 EROFS filesystem starts near 5186 / 5274 / 6372 MiB. All three were carved and extracted successfully in CI run: https://github.com/lly8666/qairt-sdk-archive/actions/runs/43179298344
- EROFS region 1 is vendor: `vendor_sepolicy.cil` 554,865B SHA256 `48edac67678f02e7b953afa8582862a3d53ee3dfa0ac8bdf3409dfc058dc5431` (on-device hash MATCH), `vendor_file_contexts` 67,366B SHA256 `fd68b0362809be28f07aec105ffad1f1e6154dbafb1ab2738de36dedd2150173` (on-device MATCH).
- `/vendor/lib64/egl/libGLES_mali.so` 42,125,120B, SHA256 `bddbb8bd643ab9fa3389ee2b368a3f1b299fdb5f41aa76a07bf60d4d23cf61c9`, Build ID `85a48c0ac22f20bf408e6758830b8c54`; **exact hash MATCH** on device.
- Vendor fingerprint: `kirin990/kirin990/kirin990:10/QP1A.190711.020/root202107211653:user/test-keys`, while system fingerprint has `user/release-keys`. They can coexist, not proof of an unlocked device.

## 2026-11-12 runtime inventory success — significant new evidence
User ran `TAS_RUNTIME_INVENTORY_V1` on TAS-AN00 (read-only APK).
**Critical Mali discovery:** `/dev/mali0` exists, mode 0666 uid/gid 1000; opens O_RDONLY in app; `ioctl(0xc0048000, version_check)` succeeds and returns **major 11, minor 16**. This **exactly matches the ABI requested by the reference** BKL Mali enabler (`init_mali` in `enabler/inject_hook.c`).
Other device results:
- `/system/bin/bugreportz` regular executable size **11,632** bytes SHA256 `b85051d0eb7717ed2509c76440f48ec16608b83af3e79efb29d7662f40aee47d`
- `/system/bin/dumpstate`: app lstat/read returns EACCES, not proven absent. `dumpstatez`: ENOENT.
- `/system/bin/toybox`: size **482,560** bytes SHA256 `549a1750493b7c2df15798a387ec61fdbed89bb8ee6f7123a9bf91371d3e167b`.
- `/system/bin/app_process64`: 33,424B SHA256 `635579cb4828ed34dfc5215ac41d86341e810bb0fd1b2a4cbd0d3b84149fc0a5`
- `/system/lib64/libc.so` symlink to `/apex/com.android.runtime/lib64/bionic/libc.so`: 1,136,456B, SHA256 `ecdaf9a20bafd6659649d755023c34137a2788d6fdedb543c10dd20ad2b77ecd`.
- `/system/build.prop`, `/product/build.prop`, `/system/etc/selinux/plat_sepolicy.cil` app inaccessible (EACCES).
- `/vendor/lib64/libmali.so` absent; `/vendor/lib64/egl/libGLES_mali.so` found/matches extracted image.
**Inference (not a verified exploit):** Mali driver ABI/version and GPU library match means direct reference *API compatibility testing* is high-value. The 11.6KiB `bugreportz` is consistent with the split client on BKL, **not** proof that the original MRX unified `bugreportz` privileged service hook applies. Need exact ELF source/entrypoint for any candidate.
- The protected `dumpstate` object may be readable in ADB shell or privileged context but NOT in current app. Do not misreport EACCES as nonexistent.

## Reference project and code scope
- Reference port: https://github.com/BellezaEmporium/ghostlock-bkl-l09
- Its `enabler/inject_hook.c` Bifrost Mali `init_mali` asks version 11.16, `SET_FLAGS`, `MEM_ALLOC`, `MEM_IMPORT`, `JOB_SUBMIT`, then uses page-cache modifications. This is **BKL EMUI10** source, not exactly the original MRX code.
- Reference MRX 990 EMUI11 used a separate **privileged pre-stage** before perf-based KASLR leak; cannot obtain kernel address by simply calling `leak_text()` from an untrusted Android app.
- Native core source port: `emui11-tas/native-port/build_tas_source.py` and CI `.github/workflows/emui11-tas-native-port.yml` (compiled). Do not treat a successful build as proof of root.

## 2026-11-12 next step DELIVERED: GPU memory import test APK v1.1

**Success in Actions:** https://github.com/lly8666/qairt-sdk-archive/actions/runs/43182369524 (all steps passed, APK v2 signature and no permissions verified).

- Android package: `io.github.tasaudit.runtimeinventory.v11` (separate from earlier v1.0 so side-by-side), version `1.1.0-tas-mali-full-batch`, minSdk29 / targetSdk27 to permit native child process execution on Android 10.
- APK SHA256: `c0beec93e877fdcec4b0af6d2e3fb65ab09341216528be0092ef38cb6f73ac23`, length 69,678 bytes.
- Native binary `tas_mali_batch_arm64` SHA256 `7f0377eb81f1a9eb20cacb913743912e0244f23d0b7e3b33ff7a0a4c9dcf49b6`, 15,944 bytes, PIE, interpreter `/system/bin/linker64`.
- Code paths: `emui11-tas/runtime-inventory/native/tas_mali_batch.c`, `app/src/main/java/io/github/tasaudit/runtimeinventory/MaliBatchRunner.java`, `SystemFileExporter.java`, `SystemFileExportProvider.java`.
- Reuses the exact **BKL 11.16** GPU ABI structure/interface and request codes for VERSION_CHECK, SET_FLAGS, MEM_ALLOC, MEM_IMPORT and JOB_SUBMIT.
- App button **2** runs six fork-isolated GPU stages with per-case 6s watchdog. Last case tests the *reference's page-cache mechanism against a newly created app-private single-page test file only*. Does not patch system files or Root; note that the driver test can crash/kernel panic. Logs are line-by-line fsync'd to `TAS_MALI_COMPAT_V2_last.txt` in app private data, viewable after reboot.
- App button **3** packages exact readable OS ELF bytes (`bugreportz`, `toybox`, `app_process64`, `libc.so` and vendor SELinux CIL/context) into a shared ZIP; encrypted/user-private files are excluded by fixed allowlist. `dumpstate` may be unreadable and is then listed as skipped. No automatic uploads, contents supplied by the user only if they share the ZIP.
- Host C compile with `-Werror` and arm64 clang compile both PASS; APK signature and zip contents inspected. **ON-DEVICE memory import & canary have NOT yet been run.**
- **Next operator input:** request only **button 2's full TAS_MALI_BATCH_RUNNER_BEGIN...END log**, and if possible **button 3's OS ELF ZIP**. Device already proved VERSION_CHECK11.16; do NOT request it again. Mark each case's `rc/errno`, `CASE_EXIT`, `CASE_SIGNAL`, `CASE_TIMEOUT`; use the two canary readbacks to assess the self-file page-cache primitive. DO NOT assume success from compile alone.

## Immediately next — short, prioritized engineering route
1. **Collect and analyze now-implemented Bifrost API compatibility probe** in existing `emui11-tas/runtime-inventory`: after version 11.16 success, test `SET_FLAGS`, small GPU `MEM_ALLOC`, `MEM_IMPORT`, CPU map and cleanup as independent isolated diagnostics. Prefer first a sacrificial user-owned buffer rather than system executable page; report exact errno/return, guard threads/timeouts. Do not claim page-cache exploit works on the basis of ABI version alone.
2. Extract exact `toybox`, `bugreportz`, `libc.so` bytes from device (readable by app) in a shareable ZIP using a minimal Android `ContentProvider` or ADB pull. Use their actual ELF Build IDs and offsets, not BKL's baked offsets.
3. Correlate vendor SELinux source and actual device `/dev/mali0` labels/permissions. App has confirmed version ioctl; note elevated policy restrictions.
4. Port/validate the existing pre-stage only after dynamic compatibility evidence. Re-run `perf_event_open` in the correct context rather than repeating blocked app-mode calls. Full Root remains UNVERIFIED.

## Current code and build
- Read-only system/Mali native ABI APK `emui11-tas/runtime-inventory`, successful CI: https://github.com/lly8666/qairt-sdk-archive/actions/runs/43178755879.
- Super EROFS extraction workflow: `.github/workflows/emui11-tas-super-erofs-audit.yml`, successful CI linked above.
- User asked to maximize efficiency and **commit progress/plans to this GitHub branch every engineering round** so the next agent can continue; update this file at the end of each turn with observed facts, files, build/run links, blockers, next steps.
