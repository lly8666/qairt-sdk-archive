# MRX-W09 Kirin 990 → TAS-AN00 compatibility and no-assumption ledger

Date: 2026-11-12. Device-owner instruction: **use the published Kirin 990 MRX-W09 reference as the primary comparison, reuse confirmed matching components, APK-only (no PC/ADB), and try default assumptions for the rest**.

This document records that request accurately. **No root-capable APK was created; no kernel exploit or privileged-system-file patch was performed in this round.** Do not mark a guessed transplant as a verified result.

## 1. Keep model-specific identity separate

| | Published MRX reference | Actual TAS-AN00 |
|---|---|---|
| Device | MRX-W09 (tablet) | TAS-AN00 (Mate 30) |
| Chip | HiSilicon Kirin 990 | HiSilicon Kirin 990 |
| OS | EMUI 11.0.0.235 / Android 10 | EMUI 11.0.0.185(C00E180R7P11) / Android 10 |
| Kernel | Linux 4.14.116 with CFI/HKIP | Linux 4.14.116 with CFI/HKIP; exact image hash `d4b6f00aff4a4e05a3d5d794552165b0c950913aa841b356cae9bc69ae8ea2e5` |
| Boot status | Reference-specific | Real device `locked`, AVB `green`, production `user` |
| Known working Root | Original research describes a different exact firmware | **Not observed on TAS** |

Do not treat shared SoC and kernel version string as equality of code offsets, structure layouts, signatures or SELinux policy.

## 2. What is already confirmed reusable

- Bifrost Mali kernel ABI `11.16`; on actual TAS handset all six initialization/mapping/memory import/soft-job paths exited 0.
- Owner-owned ephemeral 4096-byte cache experiment passed in all three independent reads, including another file descriptor and mapping. **This demonstrates only an app-private file experiment**.
- Exact TAS ELF snapshots for `toybox`, `bugreportz`, APEX `libc`, `app_process64` were checked and hashed. The `toybox` executable's static layout resembles the BKL reference, **not an observed execution path**.
- Real system `dumpstate.rc` read in APK confirms `dumpstate`, `dumpstatez`, `bugreportd` run `/system/bin/dumpstate` in different modes. Vendor Kirin990 init confirms another `bugreport` mode.

## 3. Non-equivalence and unproven steps

| Reference-stage assumption | Exact TAS observation | Porting status |
|---|---|---|
| Privileged implementation in same file as `bugreportz` (as described for MRX) | Real TAS `bugreportz` is a **11,632-byte socket client** (imports `socket_local_client`), not the service executable | **DIFFERENT; cannot copy** |
| Ordinary app can read privileged executable | `lstat(/system/bin/dumpstate)` returns `EACCES`; do not conflate with ENOENT | **DENIED / UNKNOWN across domains** |
| GPU file operation on a privileged executable has the same effects as the owned-file test | Only an **app-owned** disposable canary was tested; zero evidence for changing or executing protected system file pages | **UNPROVEN** |
| `dumpstate` service runs as root with useful privileges | Init `user` omitted (normally defaults root), but no runtime UID/SELinux/capability observed | **NOT MEASURED** |
| App can perform reference perf kernel-address leak | Four `perf_event_open` cases return `EACCES`, with `perf_event_paranoid=3` | **KNOWN APP BLOCKER** |
| Original MRX kernel addresses or struct offsets work on TAS | Exact firmware/build differs; no TAS runtime slide or end-to-end kernel write evidence | **NOT TRANSFERABLE AS-IS** |
| Kernel security mitigation handling identical on TAS | HKIP/HHEE/CFI enabled, effective merged policy not recovered by app | **UNKNOWN / DO NOT ASSUME** |
| Root command can run from installed APK | Latest app SELinux is `untrusted_app_27`, app UID 10161; no effective capability or elevated euid | **NOT ACHIEVED** |

## 4. Decision

**Not an engineering-safe blind transplant.** Reusing publicly documented exploit code or copying unknown kernel constants into an installable APK does not establish compatibility and could cause persistent system instability, boot failure or data loss. The user accepts the device risk, but acceptance does not turn those assumptions into evidence or bypass implementation restrictions.

Allowed for this evidence/compatibility project: read-only static source-to-firmware comparisons, official patch identification, on-device non-privileged diagnostics, sanity/consistency checks, and accurate proof-of-root verification against independent observable evidence.

Not implemented in this round: a working kernel UAF trigger, privileged service hijack, target-system executable hook, SELinux/HKIP bypass, credential patch or a one-click Root APK.

**Next-agent handoff:** Owner's priority is to reproduce the published MRX Kirin990 temporary Root outcome *before* privacy-package cleanup, entirely on-device. Keep the above verified vs unknown ledger, do not request another GPU/ELF/init baseline, and do not report Root until independent euid/capabilities/privileged operation proof is available. Relevant sources:
- [Actual TAS kernel/prestage comparison](../TAS_AN00_MRX_PRESTAGE_COMPATIBILITY.md)
- [Exact TAS service V2 log](TAS_SERVICE_CONTEXT_V2_DUMPSTATE_RC_20261112.md)
- [Verified GPU & ELF record](TAS_DEVICE_MALI_V2_ELF_20261112.md)
- [Latest handoff](../HANDOFF_LATEST.md)
