# TAS-AN00 Windows authorized ADB shell — **real on-device** two-ZIP evidence audit

Date: 2026-11-12. Owner ran two previously delivered Windows batch programs on their **actual Huawei TAS-AN00**, and uploaded the two resulting ZIPs. This supersedes any handoff that treats Windows ADB shell tests as unperformed. **No GhostLock exploit or Root was executed.** Avoid asking the owner to repeat these exact tests.

## Input provenance and integrity

- Context ZIP: `TAS_ADB_Shell_Context_20261112_220712.zip`, SHA-256 **`d54ff48198efdb7949c639ab077606cb373619fc593c752ad56501ef66a0323f`**; archive CRC checks passed, **35 entries** (33 command logs, `RESULTS.json`, `SUMMARY.txt`).
- Perf ZIP: `TAS_ADB_Shell_Perf13_20261112_220723.zip`, SHA-256 **`7abb0b83e8a7639b8917466f1975af52287ac81e94b020ed89fe7161bf39528b`**; archive CRC checks passed; `SUMMARY.txt` and `TAS_Shell_Perf_13Case.txt`.
- 13-case native diagnostic executable was the previously verified harmless read-only binary, SHA-256 `f6d1a7d2747b400994d1a54ef1659d6c3fe01e50fd433b652dd8ef4feff3c6d7` (attested by generated runner summary, not independently read back from device).
- Only the **sanitized findings** appear in this public repository; owner's raw logs and device personal data are **not committed**.

## Device identity and starting context — observed, not inferred

| Check | Observed shell result |
|---|---|
| `ro.product.model`; Android SDK; `uname -r` | `TAS-AN00`, **API29 / Android10**, **4.14.116** |
| `ro.build.display.id` | `TAS-AN00 11.0.0.185(C00E180R7P11)` |
| Device build / secure | `user`, `ro.secure=1`, `ro.debuggable=0` |
| Verified Boot / bootloader | `green`, `locked` |
| `id` and `/proc/self/attr/current` | **UID2000 (shell)**, **`u:r:shell:s0`** |
| `getenforce` / `/sys/fs/selinux/enforce` | **Enforcing / 1** |
| `CapEff` and `CapPrm` | **0**; shell's `CapBnd=00000000000000c0` is a separate, non-effective mask |
| `Seccomp` | **0** in the diagnostic shell process |
| `perf_event_paranoid` | **3** |
| `/proc/kallsyms`, `kptr_restrict`, `dmesg_restrict` | **EACCES** in the shell diagnostic context |

The original app ran under `untrusted_app_27` with UID10161, `CapEff=0`, seccomp 2, and all four Perf opens denied. Now the ADB shell is explicitly measured under a **different starting domain**, not a disguised app test.

## Decisive real test: four independent `perf_event_open` failures in shell too

All **13** case begin/end markers appear once, in order; every case returned `CASE_EXIT=xx:0`; test frame is complete. The four *permission checks inside those successful diagnostic functions* report:

| Perf test | Shell result |
|---|---|
| `perf_task_user` | `result=error`, **`errno=13 (EACCES)`** |
| `perf_cpu_user` | `result=error`, **`errno=13 (EACCES)`** |
| `perf_cpu_kernel_only` | `result=error`, **`errno=13 (EACCES)`** |
| `perf_exact` (kernel-IP sampling shape) | `result=error`, **`errno=13 (EACCES)`** |

**Classification: `APP_AND_ADB_SHELL_PRESTAGE_PERF_EACCES`.** Merely launching the same diagnostic under `adb shell` does **NOT** open Perf or produce a kernel address. App+shell denial does **NOT** prove that a hypothetical later privileged-service execution stage would also fail; that context has not been tested.

**Interpretation trap fixed:** `CASE_EXIT=xx:0` indicates the read-only probe returned normally; it does **not** mean the Perf operations succeeded. Also, the previously pinned binary prints a baked-in `scope=app_context_preconditions_only` line even when actually executed from `adb shell`. The live UID2000, SELinux `u:r:shell:s0`, and Windows runner establish the real scope. A future source build should use neutral `current_process_context` metadata.

## New service and ELF corroboration

- **`service check bugreport` returns `Service bugreport: found` from ADB shell**, in contrast to the earlier third-party app's `Service bugreport: not found`. This is a real **Binder visibility difference**; neither call proves a high-privilege `dumpstate` process was executing.
- Shell `service list` sees `incidentcompanion`, `bugreport` and `incident`.
- **`ls -ldZ /system/bin/dumpstate` and `sha256sum /system/bin/dumpstate` both report Permission denied even from shell**. This is **EACCES**, not ENOENT: existence, ELF identity, runtime domain and actual content are still **unverified**, not disproven. No dumpstate service was started by the survey.
- `pidof dumpstate` / `dumpstatez` exited 1; the sampled process list did not show a running `dumpstate`. The service-state properties were blank, **not** conclusively `stopped`. The service sockets were absent at the instant of survey.
- Real `/system/bin/bugreportz` SHA-256 **`b85051d0eb7717ed2509c76440f48ec16608b83af3e79efb29d7662f40aee47d`** — matches the owner's previously acquired 11,632-byte **socket client**.
- Real `/apex/com.android.runtime/lib64/bionic/libc.so` SHA-256 **`ecdaf9a20bafd6659649d755023c34137a2788d6fdedb543c10dd20ad2b77ecd`** — exact match to the owner's earlier APEX ELF snapshot.
- 26 of 33 shell metadata commands reported exit 0; seven exited nonzero (not all seven were permission failures: absent sockets and idle PIDs are separate statuses).

## Impact on reference matching and decision

The [MRX-W09 / Kirin990 / 4.14.116 recorded real UID0 success](MRX_KIRIN990_REAL_ROOT_PROOF_VS_TAS_20261112.md) remains a meaningful *other-build* precedent. **But the newly tested owner handset shows that neither third-party APK nor ordinary authorized ADB shell can directly invoke the specific Perf sampling API at baseline.** The verified `bugreport` Binder service visibility in shell is new evidence of a more capable observation environment; it is not an exploit or a privileged process. The `dumpstate` executable remains unreadable even to shell.

**Updated gates:**
- G0 target firmware: **confirmed live version/kernel/locked+green**.
- G1 GhostLock static unpatched-like code: prior exact extracted image matching, no new runtime code-identity proof.
- G2 Mali11.16 + app-owned 3-view page-cache: previously **real handset PASS**, no repeat.
- G3 privileged service accessible/executable from surveyed context: **NOT VERIFIED**; Binder discovery yes, actual privileged process no.
- G4 perf kernel address sampling in app and in ordinary shell at baseline: **DENIED EACCES in both**. Hypothetical after-privileged stage: **NOT MEASURED**.
- G5 controlled kernel privilege or credential operation: **NOT TESTED/NOT VERIFIED**.
- G6 temporary Root: **not performed** (owner explicitly wanted pre-Root validation).

**Next defensible task:** use these exact observations to prevent misclassification in the Windows ADB analysis tool, and compare only authorized read-only evidence of the relevant Android execution domains and service visibility. Re-running the exact 13 Perf cases in *unchanged* shell context would not add useful information. No operational kernel exploit/privileged-process code injection or final UID0 action is provided here.

Source-of-truth: [HANDOFF_LATEST.md](../HANDOFF_LATEST.md); [user's prior app test](TAS_DEVICE_MALI_V2_ELF_20261112.md); [service V2 evidence](TAS_SERVICE_CONTEXT_V2_DUMPSTATE_RC_20261112.md).
