# MRX-W09 Kirin 990, Linux 4.14.116: published successful Root evidence vs. TAS-AN00

Date: 2026-11-12. Scope: **source provenance, outcome verification, non-operational firmware compatibility**. Owner's priority: **temporary Root research first**, Android APK-only, no PC/ADB; final Root activation expressly not wanted before controlled validation.

## Critical correction to earlier project interpretation

The public reference is [BellezaEmporium/ghostlock-bkl-l09](https://github.com/BellezaEmporium/ghostlock-bkl-l09), at **commit `381476444fbbbcf0c5e8e3c2e2166647e9134ab5`**. This repository describes *two distinct devices and development statuses*:

1. **MRX-W09**, Huawei Kirin 990, Linux **4.14.116**, EMUI **11.0.0.235**, as recorded in the 335KB [`docs/FACTS.md`](https://github.com/BellezaEmporium/ghostlock-bkl-l09/blob/381476444fbbbcf0c5e8e3c2e2166647e9134ab5/docs/FACTS.md). GitHub blob SHA `5ac3f4259e3e6173355bcaec24b6297542c33ac1`. **The MRX research record DOES report successful on-device UID 0**, not merely an unverified proposal.
2. **BKL-L09**, Kirin 970, Linux 4.14.116, EMUI 10. Its [top-level README](https://github.com/BellezaEmporium/ghostlock-bkl-l09/blob/381476444fbbbcf0c5e8e3c2e2166647e9134ab5/README.md) says `alpha-1 working and verified / root to be achieved`; the BKL enabler and first kernel-address result were demonstrated, but the BKL reference did not claim the same completed full Root outcome.

**Previously, some project notes blurred these two statuses. MRX has a recorded successful Root result; BKL remained incomplete. These claims must not be merged.**

## Public MRX evidence: exact outcome, not exploit instructions

Public `docs/FACTS.md` anchors:
- [Section (131), lines 3866–3880](https://github.com/BellezaEmporium/ghostlock-bkl-l09/blob/381476444fbbbcf0c5e8e3c2e2166647e9134ab5/docs/FACTS.md#L3866-L3880) reports **UID0 on device** in build `32fef8fd`, with a live UID0 child, a proof file and context `u:r:shell:s0`.
- [Section (133), lines 3905–3920](https://github.com/BellezaEmporium/ghostlock-bkl-l09/blob/381476444fbbbcf0c5e8e3c2e2166647e9134ab5/docs/FACTS.md#L3905-L3920) reports **goal complete** on MRX-W09 in build `a0ed46af`, with `rsh -c id` showing `uid=0(root)`, `gid=0(root)` and `context=u:r:shell:s0`.
- [Section (137), lines 3996–4008](https://github.com/BellezaEmporium/ghostlock-bkl-l09/blob/381476444fbbbcf0c5e8e3c2e2166647e9134ab5/docs/FACTS.md#L3996-L4008) reports this successful UID0 result restored following a regression. This supports repeatability *on the MRX setup*, not on TAS.
- This is a public *research record*, not independent lab reproduction on the owner's device; other full SELinux/capability results should not be inferred solely from a shell-context UID0 success.

## Target-specific comparison — reuse research outcomes, not unknown constants

| Topic | MRX-W09 proven or described | TAS-AN00 measured | Readiness |
|---|---|---|---|
| SoC | Kirin 990 | Kirin 990 | Same family only |
| Kernel version | 4.14.116 | 4.14.116, actual kernel SHA pinned | Same release string, different exact binary possible |
| EMUI | 11.0.0.235 | 11.0.0.185(C00E180R7P11) | **Different build** |
| GhostLock vulnerable-code structure | MRX research uses public UAF | TAS exact recovered ELF read-only auditor v2 reports `CONSISTENT_WITH_UNPATCHED_GHOSTLOCK` | Static TAS code evidence, not exploit proof |
| GPU / page cache | Reference setup relies on device-specific driver | TAS Mali 11.16 six-case real-device PASS, **app-owned** 3-view file cache behavior PASS | App-only API proof |
| System privileged executable | MRX discussion used a unified `bugreportz` path | Real TAS `bugreportz` is an 11KB **client**; init service uses protected `/system/bin/dumpstate` | **Incompatible to copy verbatim** |
| Privileged runtime environment | MRX root record contains shell-context UID0 evidence | TAS app `untrusted_app_27`; no privileged service runtime evidence | **Not established** |
| Kernel address via app | MRX reference reports appropriate leak path | TAS app perf calls EACCES | **Blocked for current app** |
| Root proof | MRX: `rsh -c id` UID0 recorded | TAS: no UID0/capabilities/privileged action | **Not reproduced** |

## Practical research decisions

- **Reference priority corrected:** MRX-W09 is the only directly relevant *successful* Kirin 990 / Linux 4.14.116 / EMUI 11 research record examined here. BKL-L09 serves as explanatory contrast only.
- **Already finished on TAS:** base device fingerprint, exact kernel symbolized ELF read-only checks, Mali ioctl ABI/memory import/cache, `toybox` and `bugreportz` ELF identities, four `dumpstate` init modes. Do not request repeats.
- **Real remaining gap:** no TAS on-device evidence demonstrating the privileges and system process behavior that enabled MRX's success. Source-level similarity cannot substitute for a functioning privilege boundary crossing.
- An operational kernel UAF/privileged binary tampering/credential escalation chain is not authored or provided by this evidence review. Blindly substituting MRX offsets and service targets into an APK would be both factually wrong and may destabilize the device.

### Verification automation

Reference-status-only CI can check the pinned public Git tree for exact MRX success markers versus the BKL incomplete banner, **without compiling, downloading, executing or embedding any exploit payload**. Build output is merely a provenance ledger and explicit TAS evidence gaps, not a Root APK.

This audit **does not assert Root on TAS** and performs no new phone test. The user's pre-Root stopping condition remains intact.
