# TAS-AN00 device validation: Bifrost 11.16 all six cases, system ELF identities
Date: 2026-11-12 UTC
Branch: `emui11-firmware-offline-audit-20261112`
Owner-provided target: HUAWEI TAS-AN00 / HWTAS / kirin990, EMUI 11.0.0.185, Android 10, Linux 4.14.116

## Results — actually executed on the handset

User supplied full `TAS_MALI_BATCH_RUNNER_BEGIN ... TAS_MALI_BATCH_RUNNER_END` log.
- Six cases `CASE_EXIT=00:0` through `CASE_EXIT=05:0`; `native_exit_code=0`.
- Mali kernel API `VERSION_CHECK` 11.16, `SET_FLAGS`, tracking `mmap`, `MEM_ALLOC`, one-page CPU mapping + roundtrip, `MEM_IMPORT`, imported buffer CPU mapping, and `JOB_SUBMIT`: all report **PASS**.
- `soft_job_atom_bytes=48`.
- App-created 4,096-byte private file page-cache canary:
  - `canary_ro_map=PASS`
  - `canary_same_fd_read_bytes=4096`
  - `canary_same_fd_modified=1`
  - `canary_second_fd_modified=1`
  - `canary_private_map_modified=1`
  - `canary_cleanup=PASS`.
- **Interpretation:** Reference BKL Mali API behavior and the application-owned page-cache effect are verified by real-device results. This supports compatibility of the *specific tested operation*, not persistence across reboot, privileged executable tampering, privilege escalation, or bootloader unlock. GhostLock Root remains **NOT VERIFIED**.
- Previous hard blocker remains: app-context `perf_event_paranoid=3`, four different `perf_event_open` requests fail with `EACCES`; standalone `--root` returns `KASLR leak failed`.

## Exact user-provided OS binary archive check

Archive local name `system-elfs.zip`; SHA-256 **`1e92d7a89d33063b4040beb25b774472c81c821ef12aaa59990eb9ff6ded19e0`**; 769,979 bytes.

All six OS/vendor files independently decompressed and SHA-256 validated. **All match the earlier runtime-inventory app log**.

| Path in archive | Size | SHA-256 | ELF Build ID |
|---|---:|---|---|
| `os/system/bin/bugreportz` | 11,632 | `b85051d0eb7717ed2509c76440f48ec16608b83af3e79efb29d7662f40aee47d` | `d64becc0edbe4144757a73be2b322d6a` |
| `os/system/bin/toybox` | 482,560 | `549a1750493b7c2df15798a387ec61fdbed89bb8ee6f7123a9bf91371d3e167b` | `230b56fefa5048df13b5b128499c7087` |
| `os/system/bin/app_process64` | 33,424 | `635579cb4828ed34dfc5215ac41d86341e810bb0fd1b2a4cbd0d3b84149fc0a5` | `3dc4e1c3832386d747cee6ace24f22b9` |
| `os/apex/com.android.runtime/lib64/bionic/libc.so` | 1,136,456 | `ecdaf9a20bafd6659649d755023c34137a2788d6fdedb543c10dd20ad2b77ecd` | `0f53a45090c371e49b6824269190f1fa` |
| `os/vendor/etc/selinux/vendor_sepolicy.cil` | 554,865 | `48edac67678f02e7b953afa8582862a3d53ee3dfa0ac8bdf3409dfc058dc5431` | N/A |
| `os/vendor/etc/selinux/vendor_file_contexts` | 67,366 | `fd68b0362809be28f07aec105ffad1f1e6154dbafb1ab2738de36dedd2150173` | N/A |

All four ELF binaries are 64-bit little-endian AArch64. `bugreportz`, `toybox`, and `app_process64` request `/system/bin/linker64` and include Android API 29 note.

### Consequences of the actual files

1. `bugreportz` is **11.6 KiB**, contains `dumpstatez` and `connect`-related strings. This is consistent with a socket-client-style binary instead of proving it runs as a uid0 dumpstate service. **Do not silently assume MRX-W09's original unified service binary/entrypoint.** Its exact Build ID above is now known.
2. `/system/lib64/libc.so` is a symlink into APEX. The actual libc ELF is the 1,136,456B file in `/apex/com.android.runtime/lib64/bionic/libc.so`. No BKL/MRX static offset should be reused without validation.
3. `vendor_sepolicy.cil` has `dumpstate_29_0` type/rules and `gpu_device_29_0` rules, but the complete effective SELinux policy also depends on platform/other policy files. Absence of a direct vendor-only `allow dumpstate_29_0 proc_perf` rule **does not** establish denial in the merged policy.
4. `/system/bin/dumpstate` was `EACCES` in the ordinary app and **could not be included in the ZIP**. EACCES is not proof of a nonexistent executable; acquisition from a context with read permission remains a separate evidence task.

## Build / previous source
- Reference BKL project: https://github.com/BellezaEmporium/ghostlock-bkl-l09
- TAS v1.1 test source: `emui11-tas/runtime-inventory/native/tas_mali_batch.c`
- TAS v1.1 build (successful): https://github.com/lly8666/qairt-sdk-archive/actions/runs/43182369524
- Exact source binary snapshots remain with the phone owner's user attachment. **Do not commit proprietary system ELF bytes to this public GitHub repository**; hashes and Build IDs are sufficient for source matching.

## Short next-agent plan
1. **No need for another Bifrost ABI or app-owned page-cache canary test. Both succeeded on real hardware.**
2. Use exact `toybox`, `bugreportz`, `libc` Build IDs in any continued *offline firmware compatibility comparison*. Recognize the `bugreportz` client-vs-service distinction; do not assume elevated execution rights.
3. If additional read-only runtime evidence is required, collect `dumpstate` file metadata/ELF build identity and actual service security context using authorized ADB access; no firmware alteration is needed for this diagnostic.
4. Preserve distinction between measured GPU memory behavior, kernel address disclosure (still blocked in app), and Root (still not observed). Report any kernel change, crash or panic only on actual device evidence.
5. Keep `emui11-tas/HANDOFF_LATEST.md` up-to-date after the next engineering step. Add direct CI and source paths for any further artifact.

