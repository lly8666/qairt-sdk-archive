# TAS-AN00 / EMUI 11.0.0.185 × MRX-W09 GhostLock pre-stage compatibility

## What was verified from the exact OTA

- Firmware SHA-256: `fb4cec6aa905416ede031cca602783bc1e59fdd89ee96ba1aaa54dbdaf351b0f`
- Extracted ARM64 kernel Image SHA-256: `d4b6f00aff4a4e05a3d5d794552165b0c950913aa841b356cae9bc69ae8ea2e5`
- Mali DDK source path marker: **`bifrost-r18p0-01rel0`**
- Actual kernel symbols include: `kbase_ioctl`, `kbase_mem_alloc`, `kbase_mem_import`, `remove_waiter`, `rt_mutex_adjust_prio_chain`, `init_cred`, `init_task`, `policydb`, and HKIP functions.
- CONFIG: `MALI_MIDGARD=y`, `PERF_EVENTS=y`, `FUTEX_PI=y`, `CFI_CLANG=y`, `HISI_HHEE=y`.
- Existing TAS root research core compiled to Android 10 ARM64 but did **not** achieve root; `perf_event_open` was denied with EACCES in `untrusted_app_27`.

## What the BKL/MRX reference actually does

Published BKL project: https://github.com/BellezaEmporium/ghostlock-bkl-l09

Its enabler is a Mali page-cache file patcher using the BKL `/dev/mali0` interface and request of Mali userspace ABI `11.16`. Reference:
https://github.com/BellezaEmporium/ghostlock-bkl-l09/blob/main/enabler/inject_hook.c

MRX-W09 (Kirin 990 / EMUI 11) uses a privileged system process stage before the perf-based GhostLock kernel exploit; see the original MRX research record mirrored in:
https://github.com/BellezaEmporium/ghostlock-bkl-l09/blob/main/docs/FACTS.md

**The BKL enabler is not a byte-identical substitute for the original MRX pre-stage.** The original MRX source repository is unavailable through the current public GitHub connection; the BKL port describes its behavior.

## Compatibility conclusion

- **Kernel functions / build:** confirmed matching family. Reuse *kernel research*, validating each symbol and offset against TAS.
- **GPU Mali DDK:** driver exists and its source version is identified. The runtime-negotiated ioctl ABI and whether BKL's import behavior exists are unverified.
- **System service executable code:** not verifiable from this firmware archive; full `SYSTEM.img` and `VENDOR.img` are absent.
- **Security policy and permissions for privileged stage:** unverified on the target build. A previously observed app-level perf EACCES is expected when the privileged pre-stage has not occurred.
- **Ability to achieve Root:** unverified.

A read-only offline audit script and optional ADB runtime version/hash inventory are supplied in the linked audit package in the working session. This file documents research evidence only and does not install a kernel exploit or modify system binaries.

## Actionable next engineering phase

Complete compatibility evidence for the target's Mali API version, `libc.so` and `bugreportz`/ `dumpstate` hashes, and system service SELinux domains before concluding that the MRX/BKL pre-stage is transferable. Do not substitute unknown offsets with guesses.
