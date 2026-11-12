# TAS-AN00 × MRX-W09 4.14.116 — original reference assumption re-audit

Date: 2026-11-12. Owner requested deeper review because **MRX EMUI11.0.0.235 recorded UID0 Root, while TAS EMUI11.0.0.185 shares Kirin990 and kernel 4.14.116**. This audit explicitly searches for mistakes in the project's previous interpretation. **No operational vulnerability exploit or device Root test was executed.**

## Evidence sources and confidence

- MRX public research log: [`docs/FACTS.md`](https://github.com/BellezaEmporium/ghostlock-bkl-l09/blob/381476444fbbbcf0c5e8e3c2e2166647e9134ab5/docs/FACTS.md), 335,987 characters, SHA blob `5ac3f4259e3e6173355bcaec24b6297542c33ac1`, reference repository pinned commit `381476444fbbbcf0c5e8e3c2e2166647e9134ab5`.
- BKL developer summary: [top-level README](https://github.com/BellezaEmporium/ghostlock-bkl-l09/blob/381476444fbbbcf0c5e8e3c2e2166647e9134ab5/README.md), which is mainly about Kirin970 BKL and summarizes the earlier MRX mechanism.
- TAS owner-supplied, real-device: [Mali 11.16 and ELF hashes](TAS_DEVICE_MALI_V2_ELF_20261112.md), [exact `dumpstate.rc` and runtime visibility](TAS_SERVICE_CONTEXT_V2_DUMPSTATE_RC_20261112.md), [real vendor init and `toybox`](TAS_INITRC_TOYBOX_STATIC_20261112.md), [kernel static audit v2](TAS_GHOSTLOCK_STATIC_AUDIT_V2_FALSE_POSITIVE_FIX_20261112.md).
- No original MRX `0ch4/ghostlock-mrx-w09` repository was retrievable under that URL; this comparison uses **public copied MRX research history**, not an original mirror-independent build attestation.

## Three overlooked distinctions, with corrections

### A. `bugreportz` as trigger vs actual patched binary

**What was overclaimed:** Earlier TAS handoffs treated its `bugreportz` being a small socket client as a *decisive* reason MRX's whole elevated stage cannot be transferred. The BKL README section 3.1 says the MRX reference used a unified `bugreportz`, which encouraged that inference.

**What the detailed MRX log actually records:**
- `FACTS.md` **lines 24–27** describe a **dumpstate libc-page-cache hook** as the prerequisite that enables Perf sampling.
- `FACTS.md` **lines 1045–1079** discuss userspace `libc` page-cache state, show a service-trigger operation involving `bugreportz`, and report the Perf restriction changed after that trigger.
- The later [re-rooted MRX proof, lines 4837–4849](https://github.com/BellezaEmporium/ghostlock-bkl-l09/blob/381476444fbbbcf0c5e8e3c2e2166647e9134ab5/docs/FACTS.md#L4837-L4849) confirms the same broad order, but includes system-specific operations.

**Correct conclusion:** The BKL summary and detailed MRX log are not fully equivalent descriptions of the staging target. The detailed log establishes a **shared-library page-cache dimension**, so *the fact TAS `bugreportz` is a socket client does NOT by itself disprove the entire MRX prestage concept*. The actual TAS `bugreportz` remains a client, not a privileged service, and privileged execution of shared-library code remains **unmeasured**. A particular protected service can also have independent access restrictions. This is a **hypothesis reopened**, not evidence of a working TAS bypass.

The actual TAS APEX libc was obtained and hashed (`ecdaf9a20bafd6659649d755023c34137a2788d6fdedb543c10dd20ad2b77ecd`); its exact contents do not establish that an app-controlled page-cache operation affects an elevated process.

### Independent AOSP corroboration: a `bugreportz` socket client is normal Android architecture

AOSP's public [`cmds/bugreportz/bugreportz.cpp` implementation](https://android.googlesource.com/platform/frameworks/native/+/324b700b4b0669683efff3d696324dc0d4e24ec5/cmds/bugreportz/bugreportz.cpp) already uses `socket_local_client` to connect to the `dumpstate` service rather than acting as the service. Its historical [development diff](https://android.googlesource.com/platform/frameworks/native/+/d65a388e1b426afb1a4e4c5dd9b47c605ed26b96%5E2..d65a388e1b426afb1a4e4c5dd9b47c605ed26b96/) also explicitly separates the client from the started `dumpstatez` service. This is source-level architectural background, **not confirmation of an exact TAS or MRX runtime privilege**.

Therefore the original TAS ELF observation is best understood as **consistent with Android's familiar bugreport client/service split**, rather than inherently evidence of a removed functionality in the older/other EMUI build. Whether a privileged process loads and executes the relevant shared library, and whether an ordinary APK has any effect across that security boundary, are **unverified**.

### B. Perf EACCES is a measurement of its **starting security context**, not every context

**What was overclaimed:** `perf_event_open EACCES` in the TAS user APK was repeatedly presented as proof that the MRX-style leak is simply blocked. The same labels appeared as “G4 BLOCKED” without the qualifier `in the app's current context`.

**What the real reference shows:** MRX also began with restricted Perf access; its success log describes a **distinct prerequisite that changes relevant operating conditions before address sampling**. TAS app's 4 denied calls were made **before any such transition**, under `u:r:untrusted_app_27`, UID `10161`, `CapEff=0`, `Seccomp=2`.

**Correct conclusion:** `APP_PRESTAGE_PERF_EACCES` is **verified**; `POST_PRIVILEGED_STAGE_PERF` is **unmeasured**. The first does not logically determine the second. Conversely, a public MRX positive result cannot prove a TAS privileged context is available. The project must not treat either as a Root result.

### C. MRX success input context differs from phone-only app

**What was underemphasized:** MRX's public record repeatedly operates from `adb shell` and `/data/local/tmp`, whereas TAS must run entirely from a third-party installed APK. On production Android these are **not the same UID/SELinux domain**. The actual TAS app is `untrusted_app_27`, not `shell`.

**Correct conclusion:** Even if MRX's kernel binary and TAS kernel were byte-identical (not demonstrated), one cannot infer that a third-party APK has shell-domain file access, service permissions, Perf access or writable paths. The initial execution context is a *separate compatibility axis*. We must not ask the owner to use ADB (explicitly excluded), and must not invent an APK→shell transition.

## Revised stage matrix, without false negatives or false positives

| Stage | TAS evidence | Proper status |
|---|---|---|
| Shared Kirin990 and 4.14.116 | Real OS data | FAMILY MATCH, exact binaries/policies not identical by proof |
| `remove_waiter` vulnerable morphology | TAS pinned, stronger static checker v2 | CONSISTENT WITH UNPATCHED, NOT LIVE EXPLOIT |
| Mali userspace ioctl and app-owned cache behavior | Six real-device cases | PASSED **for app-owned scope only** |
| TAS `bugreportz` ELF | Real 11.6KB socket client | CONFIRMED CLIENT; *not* proof of total prestage incompatibility |
| TAS `dumpstate` init services | Three system + one vendor modes declared | CONFIGURED; live UID/domain/perf unmeasured |
| Shared-library executable identity | TAS APEX libc hash available | OFFLINE IDENTITY CONFIRMED; elevated execution of altered code not tested |
| Perf before any privilege-bearing prestage | Four app EACCES | DENIED IN APP CONTEXT |
| Perf after hypothetical privileged prestage | No TAS result | UNMEASURED (not “necessarily denied”) |
| MRX userland starting context | Public logs primarily shell/ADB | DIFFERENT FROM TAS APP — additional porting axis |
| Functional privileged action, cred transition, UID0 | No TAS result | **NOT PROVEN** |

## Research outcome and next actions

**Previously missed research was interpretive, not a hidden Root success:** the app-only failure and `bugreportz` client identity were **overinterpreted**. Their correction makes the MRX comparison more faithful and avoids discarding a plausible research hypothesis prematurely. It does **not** imply that EMUI 11.0.0.185 must succeed because MRX 11.0.0.235 succeeded, and does not supply an operational APK exploit.

New code correction: [`tools/tas_context_decision.py`](../tools/tas_context_decision.py) schema V2 now distinguishes pre-stage app Perf from unmeasured post-privileged Perf; records MRX shell/ADB versus TAS third-party APK, stops recommending ADB, and does not misclassify the client executable as a categorical failure. CI selftest must enforce these invariants.

**No further handset action is requested in this round.** Owner's old Mali/ELF/init logs are already sufficient for the stated observations. Next useful authorized work is source-accurate read-only comparison of execution contexts and exact files under the owner's no-PC constraint, with explicit measurement rather than unverified assumptions.
