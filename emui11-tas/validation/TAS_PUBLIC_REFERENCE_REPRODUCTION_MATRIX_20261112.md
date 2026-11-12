# TAS-AN00: Published GhostLock reference vs. measured APK-only results

Date: 2026-11-12. Purpose: **faithfully account for reproduction progress** using publicly available research, without claiming a completed root chain.

**Owner's explicit priority:** reproduce the published GhostLock approach and obtain temporary root, from a user-installed APK only, **no PC/ADB**. Privacy app clean-up comes after that. This is owner's own device; do not misrepresent intent as malicious.

## Reference provenance — do not blend devices

Public mirror: [BellezaEmporium/ghostlock-bkl-l09](https://github.com/BellezaEmporium/ghostlock-bkl-l09). Its README describes **BKL-L09 / Kirin 970 / EMUI 10 / Linux 4.14.116**. Its [docs/FACTS.md](https://github.com/BellezaEmporium/ghostlock-bkl-l09/blob/main/docs/FACTS.md) recounts **MRX-W09 / Kirin 990 / EMUI 11.0.0.235 / kernel 4.14.116** research. These are different implementations and devices; the mirror does **not** prove TAS-AN00 compatibility or reproducible APK-only root.

Actual handset in this project: **TAS-AN00 / Kirin 990 / EMUI 11.0.0.185(C00E180R7P11) / Android 10 / Linux 4.14.116**, locked bootloader, AVB green, SELinux app context `untrusted_app_27`. Even MRX's EMUI build is different.

## Measured compatibility matrix

| Question | TAS evidence | Limit |
|---|---|---|
| GPU device/driver ABI | **PASS ON DEVICE**, `/dev/mali0` version 11.16, exact vendor Mali library SHA | Interface available; not inherently a privilege crossing |
| `SET_FLAGS`, GPU mapping, alloc/import/job submit | **PASS ON DEVICE**, six isolated tests | Only proves API paths used in tests |
| Page-cache behavior | **PASS ON DEVICE**, same-fd / second-fd / independent mapping all observed changed bytes | Test only modified a newly created private app file; not a protected system binary |
| Target `toybox` static layout | Owner's TAS ELF prologue and blank executable-page tail match BKL candidate layout | No proof of privileged process execution of a hook |
| Actual `bugreportz` | TAS 11,632-byte client; imports `socket_local_client` | Must NOT treat it as MRX unified privileged service executable |
| `dumpstate` init definition | V2 read-only survey verified 3 system services and 1 vendor service invoking `/system/bin/dumpstate` | Init default user ≠ observed live process euid / SELinux domain / capabilities |
| Ordinary app process | UID 10161 on latest survey; `untrusted_app_27` | No capabilities and no demonstrated privilege transition |
| Kernel address disclosure | Previous perf events failed EACCES; `perf_event_paranoid=3` | KASLR base / kernel address availability **not established** |
| Kernel corruption vulnerability trigger / cred handling | No verified target-device evidence of safe, reliable end-to-end operation | Not reproduced |
| Root/effective uid 0 | **NOT ACHIEVED** | Do not mark success based on compile/ABI/canary alone |

## Critical gap in the published port

The BKL port's public README states the Android 10 `bugreportz` is a socket client and differentiates it from privileged `dumpstate`; TAS actual binaries confirm a similar **client/service split**. It also describes the BKL workaround using a process reachable in two different privilege contexts. TAS static `toybox` file layout happens to resemble the BKL target, but:

- The **actual TAS runtime relationship** between `dumpstate` and its child commands is not proven by init.rc alone.
- App-only perf requests are **denied**. No working privileged leak or root transition has been measured on TAS.
- The published source discusses HKIP and SELinux constraints and a substantial kernel panic rate in its research experiments. A successful compile or matching layout is not an operational proof.
- A patched executable, running system hook, kernel write primitive, or credential escalation is **not** present in this project, and must not be inferred from the existing read-only/owned-file tests.

## APK-only scope and next engineering discipline

- Do not re-request ADB, desktop tooling, the v1.1 six-case GPU log, the owner-provided ELF zip, or the v1.3 init configuration log.
- Do not promise an installable temporary-root APK or report root success without on-device evidence of euid/capabilities/SELinux and successful privileged operation.
- An APK can legitimately carry further bounded diagnostics and root-status validation, but it cannot root a locked production device through an Android API call.
- Any continued firmware/static comparison should be faithful to the TAS-specific binaries and note which steps are **unverified** rather than porting BKL/MRX addresses.
- Work on privacy package disablement is explicitly **deferred until the owner's Root-first goal is addressed**; do not ask the user for unwanted package lists.

**Round result:** This is a published-reference reproduction audit, not an operational exploit reproduction. **No root APK was built and no root access was obtained in this round.**

## Evidence and next-agent handoff

- [GPU + exact OS files](TAS_DEVICE_MALI_V2_ELF_20261112.md)
- [TAS init rc and actual service modes](TAS_SERVICE_CONTEXT_V2_DUMPSTATE_RC_20261112.md)
- [Toybox offline compatibility](TAS_INITRC_TOYBOX_STATIC_20261112.md)
- [Latest handoff](../HANDOFF_LATEST.md)
