# TAS-AN00 — pre-Root validation without activating Root: acceptance boundary

Date: 2026-11-12. Owner request: research and validate the entire published GhostLock route in an APK, on the owner's spare/damaged TAS-AN00, but do **not** finally grant UID0/root capabilities. No PC/ADB.

## Fundamental distinction: confidence versus an actual end-to-end proof

A dry-run that never crosses a privilege boundary can confirm *compatibility prerequisites*, but cannot establish that kernel control, SELinux/HKIP behavior, and credential transition would succeed. Testing all preceding exploit stages but skipping only the last credential change would still require an operational privileged-code/kernel exploit chain, not a passive simulation.

There is no test evidence in this project that satisfies such an operational pre-Root milestone. **Do not claim a completed pathway or a ready-to-root one-click APK.**

## Evidence-based gates for the exact target

| Gate | Question | Evidence | Status |
|---|---|---|---|
| G0 | Exact firmware/device identity | TAS-AN00, Android10 / EMUI11.0.0.185, locked/green, kernel Image SHA256 pinned | VERIFIED for supplied firmware and app identity |
| G1 | GhostLock vulnerable-code pattern | Pinned recovered kernel ELF, read-only `remove_waiter` disassembly consistent with unpatched `current` behavior | STATIC_MATCH; live runtime not proven |
| G2 | Mali 11.16 GPU API and own-file cache mechanism | Six on-device cases, `MEM_ALLOC`, `MEM_IMPORT`, `JOB_SUBMIT`, app-owned canary 3-view changes | VERIFIED only for tested app-owned operation |
| G3 | Accessible privileged service executable path | Real `bugreportz` is socket client; real `dumpstate` has app `lstat EACCES`; four real init modes defined | **NO demonstrated app→privileged execution** |
| G4 | Kernel address disclosure capability in app | Four `perf_event_open` attempts return `EACCES`, paranoid 3 | **BLOCKED in app** |
| G5 | Controlled, bounded non-credential privileged operation | No such owner-device execution evidence | NOT PROVEN |
| G6 | Root verification | No euid0, capabilities, suitable SELinux context or privileged operation observed | NOT PERFORMED (owner specifically does not want final activation) |

## What can be safely validated without activating Root

- Offline matching of target kernel and system ELF identities and known init service modes (already done).
- Real-device non-privileged Mali API and disposable app-owned cache experiments (already done).
- Device-local read-only UID/capabilities/SELinux state and permissions, with no elevated operations (already done).
- Automated fail-closed evaluation of existing logs with `emui11-tas/tools/tas_repro_evidence_gate.py` (CI verified).

These observations are **not** proof that the entire exploit chain can attain kernel write authority or obtain Root in this production build.

## Stop condition and honest engineering outcome

**Current route status: NOT END-TO-END VERIFIED.**

No remote control or instrumentation channel to the owner's handset is connected to the current assistant session, so no new on-device run can be honestly claimed. An operational end-to-end exploit (even ending before credential mutation) would entail modifying the execution of protected system software or exercising kernel-memory corruption. This project does not generate or deliver such a chain as a compiled APK.

There is no additional low-risk GPU ABI/init/ELF re-test that resolves gates G3–G5; asking the owner to repeat them would be wasted effort. Continue from pinned evidence, and separate device-local diagnostics from a verified privilege-crossing result.

## Primary sources in this repository

- [Exact firmware patch-state audit](TAS_GHOSTLOCK_PINNED_KERNEL_PATCH_STATUS_20261112.md)
- [Mali six-case test and actual system ELF hashes](TAS_DEVICE_MALI_V2_ELF_20261112.md)
- [dumpstate init service survey](TAS_SERVICE_CONTEXT_V2_DUMPSTATE_RC_20261112.md)
- [MRX→TAS reference differences](MRX_KIRIN990_TO_TAS_BLIND_PORT_FEASIBILITY_20261112.md)
- [Latest handoff](../HANDOFF_LATEST.md)
