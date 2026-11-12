# TAS-AN00 GhostLock Research — Current State / Next-Agent Handoff
Updated: 2026-11-12 (UTC) | Status: **Device verified; KASLR leak blocked in app; Mali ABI confirmed; root not achieved.**
Branch: `emui11-firmware-offline-audit-20261112` | Draft PR: https://github.com/lly8666/qairt-sdk-archive/pull/124

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

## Immediately next — short, prioritized engineering route
1. **Code and test Bifrost API compatibility probe** in existing `emui11-tas/runtime-inventory`: after version 11.16 success, test `SET_FLAGS`, small GPU `MEM_ALLOC`, `MEM_IMPORT`, CPU map and cleanup as independent isolated diagnostics. Prefer first a sacrificial user-owned buffer rather than system executable page; report exact errno/return, guard threads/timeouts. Do not claim page-cache exploit works on the basis of ABI version alone.
2. Extract exact `toybox`, `bugreportz`, `libc.so` bytes from device (readable by app) in a shareable ZIP using a minimal Android `ContentProvider` or ADB pull. Use their actual ELF Build IDs and offsets, not BKL's baked offsets.
3. Correlate vendor SELinux source and actual device `/dev/mali0` labels/permissions. App has confirmed version ioctl; note elevated policy restrictions.
4. Port/validate the existing pre-stage only after dynamic compatibility evidence. Re-run `perf_event_open` in the correct context rather than repeating blocked app-mode calls. Full Root remains UNVERIFIED.

## Current code and build
- Read-only system/Mali native ABI APK `emui11-tas/runtime-inventory`, successful CI: https://github.com/lly8666/qairt-sdk-archive/actions/runs/43178755879.
- Super EROFS extraction workflow: `.github/workflows/emui11-tas-super-erofs-audit.yml`, successful CI linked above.
- User asked to maximize efficiency and **commit progress/plans to this GitHub branch every engineering round** so the next agent can continue; update this file at the end of each turn with observed facts, files, build/run links, blockers, next steps.
