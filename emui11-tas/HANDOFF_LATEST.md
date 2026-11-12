# TAS-AN00 GhostLock Research — Current State / Next-Agent Handoff
Updated: 2026-11-12 (UTC) | Status: **TAS V2 dumpstate.rc confirms 4 init service modes across system/vendor; Mali 11.16 owned-page compatibility PASS; no elevated process observed; app perf EACCES; Root NOT obtained.**
Branch: `emui11-firmware-offline-audit-20261112` | Draft PR: https://github.com/lly8666/qairt-sdk-archive/pull/124

## LATEST: MRX 235's TWO-CVE prerequisite and TAS 185 partial system image (2026-11-12)

Owner requests continued **MRX-W09 Kirin990 Linux4.14.116 EMUI11.0.0.235 successful Root** comparison against **TAS-AN00 EMUI11.0.0.185**, using the already completed Windows ADB shell tests rather than rerunning them.

**Significant deeper original-log discovery:** The MRX result is NOT only `CVE-2026-43499 / GhostLock`. Its **prerequisite** used an independently documented **Mali GPU `CVE-2021-44828` page-cache / read-only-memory weakness**, involving `/system/lib64/libc.so` and a privileged system process; then the later stage unlocked perf sampling / GhostLock. Source: pinned [MRX FACTS lines 997–1009 and 1903–1906](https://github.com/BellezaEmporium/ghostlock-bkl-l09/blob/381476444fbbbcf0c5e8e3c2e2166647e9134ab5/docs/FACTS.md#L997-L1009). Official CVE affects Bifrost **r0p0–r34p0**. TAS's original firmware source references **r18p0**, inside that nominal range — **BUT exact patch/backport state and protected-memory effects are UNPROVEN**. Existing six-case real-phone Mali API/APP-OWNED page cache success DOES NOT prove CVE-2021-44828 on system files.

**Another concrete source/identity difference:** MRX's public record names `/system/lib64/libc.so`; TAS's actually obtained Bionic ELF lives in **`/apex/com.android.runtime/lib64/bionic/libc.so`**, with SHA256 `ecdaf9a20bafd6659649d755023c34137a2788d6fdedb543c10dd20ad2b77ecd` confirmed by original user ELF snapshot and new ADB shell. Do NOT copy MRX binary assumptions to that distinct TAS APEX ELF.

**New investigation of why exact `dumpstate` wasn't recoverable:** Original `SUPER.img` 1,435,996,536B is Android sparse and explicitly has a **leading DONTCARE span of 5,093,982,208B**. The previously extracted three EROFS vendor-like regions thus do not cover a complete `/system` image. The owner's `UPDATE.APP.zip` contains 49 images but lacks a full `SYSTEM.img`. Therefore the missing `/system/bin/dumpstate` ELF is **a missing source coverage issue**, not evidence of absent device binary. Actual app and ADB-shell `dumpstate` EACCES remain genuine.

**Work delivered:** [Detailed two-CVE + missing-system-image report](validation/TAS_MRX235_TO_TAS185_TWO_CVE_GAP_AUDIT_20261112.md); [SHA256-pinned offline source-scope gate](tools/tas_mrx235_to_tas185_static_gate.py) which independently read the owner's `system-elfs.zip` and the previously downloaded EROFS report, verified actual ELF bytes and sparse layout, refused unpinned input, and emitted fail-closed JSON. This was actually run locally against real old inputs, not merely CI mocks. [Evidence CI run 43237785490](https://github.com/lly8666/qairt-sdk-archive/actions/runs/43237785490) **SUCCESS** for syntax, selftests and wrong-hash rejection.

**Current highest-value unresolved issue:** The target-specific GPU CVE-2021-44828 patch state and **the actual protected shared-library process mapping**. This is logically earlier than GhostLock's address-leak step. Neither a static version-range match nor app-owned canary proves this prerequisite. Actual protected-system page modification or high-privilege process hijack was **not attempted**. The project has NOT demonstrated a running pre-Root chain or delivered a Root APK. No additional phone / ADB repetition requested.



## LATEST REAL DEVICE EVIDENCE: owner Windows ADB shell two ZIPs (2026-11-12 local 22:07)

**The owner HAS NOW RUN both Windows scripts and supplied the actual archives. Do not request reruns.** Full source-linked, sanitized measurements: [validation/TAS_WINDOWS_ADB_SHELL_REAL_DEVICE_RESULTS_20261112.md](validation/TAS_WINDOWS_ADB_SHELL_REAL_DEVICE_RESULTS_20261112.md).

- Original context ZIP SHA256 `d54ff48198efdb7949c639ab077606cb373619fc593c752ad56501ef66a0323f`; 33 context commands, 26 exit0/7 nonzero. Perf ZIP SHA256 `7abb0b83e8a7639b8917466f1975af52287ac81e94b020ed89fe7161bf39528b`; all **13** cases fully completed.
- **Actual TAS:** `TAS-AN00 11.0.0.185(C00E180R7P11)`, API29, kernel4.14.116, bootloader locked/green, `ro.debuggable=0`. Authorized Windows ADB shell has **UID2000 / u:r:shell:s0 / CapEff=0 / Seccomp=0 / SELinux enforcing**. Previously, app had UID10161/untrusted_app_27/Seccomp2.
- **Both original app AND new ADB shell**: four `perf_event_open` cases **ALL EACCES errno13**. Shell `perf_event_paranoid=3`, `kallsyms` EACCES, `kptr_restrict` EACCES. **No direct perf leak from shell baseline**. Note `CASE_EXIT=00:0…12:0` means the diagnostic function exited normally, **not** that perf opened successfully. A hypothetical post-privileged-process Perf context is **UNMEASURED**, not ruled out.
- **New real access delta:** shell `service check bugreport` **found**, previous untrusted app `service check bugreport` **not found**; different Binder service visibility is now measured but does NOT prove a live privileged process. No `dumpstate` process/socket at survey time, and `init.svc.dumpstate*` properties blank (not proof of stopped).
- **Surprising persistence of denial:** shell `ls -ldZ /system/bin/dumpstate` and `sha256sum /system/bin/dumpstate` both **Permission denied**. This is not ENOENT, and exact dumpstate ELF remains unknown. No elevated execution occurred.
- SHA256 of real `/system/bin/bugreportz` and APEX `libc.so` precisely match the earlier owner-supplied ELF archive. This corroborates file identities; live kernel binary equality still unproved.
- Source correction made in [ghostlock-root-test/native/tas_batch_probe.c](ghostlock-root-test/native/tas_batch_probe.c) changes misleading baked-in `scope=app_context_preconditions_only` text to `scope=actual_process_context_preconditions_only` **for FUTURE builds only**. Existing, pinned diagnostic binary and its run remain valid because actual UID/domain were explicitly logged.
- Root remains **NOT achieved**, GhostLock exploit not triggered; the prior owner objective was verification of prerequisites without activating Root. There is no need to rerun the identical 33+13 tests. No operational exploit APK or host-side injection was developed.

**Next safe investigation:** compare legitimate read-only Android shell / Binder service visibility with MRX published outcome claims and the owner’s exact firmware artifacts. If privileges are needed to read `dumpstate`, do not equate access denial with absence. Do not claim verified Root based on Binder discovery or the original Mali app-owned cache test.



> **Windows ADB bundle upgraded to v2 (2026-11-12).** This supersedes the v1 ZIP recommendation below. The owner can now run TWO separate one-click Windows batch launchers:
> - [`Run_TAS_ADB_Shell_Inventory.cmd`](windows-adb/Run_TAS_ADB_Shell_Inventory.cmd): 33 fixed read-only ADB shell context/service/file-metadata commands, zero on-device writes.
> - [`Run_TAS_ADB_Shell_Perf13.cmd`](windows-adb/Run_TAS_ADB_Shell_Perf13.cmd): **OPTIONAL**, uses SHA256-pinned `tas_batchprobe_arm64` (`f6d1a7d2747b400994d1a54ef1659d6c3fe01e50fd433b652dd8ef4feff3c6d7`) from older verified build 43170972015; uploads only this benign read-only probe to `/data/local/tmp/tas_batchprobe_readonly`, runs 13 isolated diagnostics under `adb shell`, then deletes only that temporary file. Measures whether shell Perf differs from original app's four EACCES outcomes; prints no kernel addresses.
> - Windows workflow [43231631065](https://github.com/lly8666/qairt-sdk-archive/actions/runs/43231631065) **SUCCESS** (PowerShell5.1 parse and dual selftests, exact old diagnostic ELF hash pin, v2 distribution). Verified final ZIP SHA256 `c65d0103918a795e2583b1321965cf1434bee2b36871438f25163d7047620a2a`, all six included SHA256 checks pass. Artifact `TAS-AN00-Windows-ADB-Shell-Batch-v2`.
> - Full two-test walkthrough: [windows-adb/README_CN.md](windows-adb/README_CN.md). Use either `adb.exe` on PATH or put official Windows `platform-tools` directory alongside the scripts. The owner has NOT yet run either batch on the TAS; no live shell result/Root is claimed.
> - This method change also supersedes prior code assumptions: [tools/tas_repro_evidence_gate.py](tools/tas_repro_evidence_gate.py) now has `phone_only=false`, `request_adb=true`, `preferred_host=WINDOWS_ADB_SHELL_READ_ONLY`; [context decision](tools/tas_context_decision.py) no longer advises against ADB. Evidence gate Actions [43230496688](https://github.com/lly8666/qairt-sdk-archive/actions/runs/43230496688) **SUCCESS**.


## LATEST OWNER METHOD CHANGE: Windows authorized ADB shell batch (2026-11-12)

**The owner explicitly changed the previous method constraints**: Windows PC environment, batch execution in an authorized `adb shell` context. **This supersedes earlier "phone-only / APK-only / no PC / no ADB" instructions across historical reports and code.** Root remains the research priority; the owner previously asked to validate pre-Root evidence without finally activating Root. Don't request the old Android app ABI/service surveys again.

**Delivered Windows-native, no-Python, no-WSL, no-Android-Studio batch survey:**
- [PowerShell 5.1 source](windows-adb/TAS_ADB_Shell_Inventory.ps1) — 33 fixed read-only commands; target identity gates `TAS-AN00`, API29; checks authorized `adb devices`, supports `-Serial`; saves per-command exit status and outputs, JSON/summary, ZIP and SHA256 on Windows. Hard read-only command allowlist; no root requests, device file writes, dumpstate service starts, or kernel exploit.
- [ASCII Windows double-click launcher](windows-adb/Run_TAS_ADB_Shell_Inventory.cmd). **Use the ASCII filename**, not the old Chinese launcher prototype, to avoid Windows PowerShell 5.1 runner encoding issues.
- [Chinese README / Windows setup](windows-adb/README_CN.md); requires official Platform-Tools `adb.exe` in PATH or `platform-tools\adb.exe` next to script.
- [Windows CI v1 PASS](https://github.com/lly8666/qairt-sdk-archive/actions/runs/43230293883): PowerShell 5.1 parse, read-only allowlist selftests and verified ZIP artifact `TAS-AN00-Windows-ADB-Shell-ReadOnly-v1`; GitHub Action workflow [.github/workflows/tas-windows-adb-shell-bundle.yml](../.github/workflows/tas-windows-adb-shell-bundle.yml). Verified distributed ZIP SHA256 `33bda86c99a0279e29df4bdf1ff1f196525044f4dbcf9251a26ea633d065dc73` with all embedded SHA256 entries checked.
- Updated [tools/tas_repro_evidence_gate.py](tools/tas_repro_evidence_gate.py) constraints `phone_only=false`, `request_adb=true`, `preferred_host=WINDOWS_ADB_SHELL_READ_ONLY`. Updated [tools/tas_context_decision.py](tools/tas_context_decision.py) text to recommend authorized Windows ADB comparison, rather than erroneously asserting no PC.

**What this will and won't show:** ADB shell usually runs as UID 2000 `u:r:shell:s0`, different from prior app `untrusted_app_27`; shell file metadata, `perf_event_paranoid`, service visibility may differ. Reading a sysctl or making metadata queries does NOT prove `perf_event_open` succeeds, does not demonstrate a privileged dumpstate executable actually ran, and does not mean Root. **No phone was actually connected or measured in this development round**; the owner has the Windows bundle to run manually. The original 13-case read-only perf probe and host collector remain in the repo separately if the owner's next result warrants it.

**Privacy handling:** survey does not collect private app data and does not upload automatically; owner must review log ZIP before sharing. No new Android APK, no exploit, no UID0 was produced.



## LATEST DEEP RE-AUDIT: earlier MRX→TAS privilege blockers overstated (2026-11-12)

Owner's latest message challenges the earlier inference that MRX EMUI11.0.0.235 success does not transfer to TAS EMUI11.0.0.185, and requests a **deeper investigation of our missed work**. We independently identified **two overly strong negatives** (not a Root success); see the [primary-source corrective audit](validation/TAS_MRX_PRESTAGE_ASSUMPTION_REAUDIT_20261112.md).

1. **`bugreportz` client is NOT a categorical full prestage blocker.** The BKL README simplifying MRX as a unified-`bugreportz` target differs from the original MRX `FACTS.md` describing a **dumpstate libc-page-cache prerequisite** with `bugreportz` in the trigger sequence (FACTS lines 24-27, 1045-1079, 4837-4849). Additionally, [historical AOSP `bugreportz.cpp`](https://android.googlesource.com/platform/frameworks/native/+/324b700b4b0669683efff3d696324dc0d4e24ec5/cmds/bugreportz/bugreportz.cpp) demonstrates the normal socket-client → `dumpstatez` architecture. TAS's actual `bugreportz` ELF is indeed an 11,632B client, but **that alone cannot rule out a separate common-library process interaction**. The TAS APEX libc SHA is known; neither runtime elevated use nor a protected-code alteration was demonstrated. Do not infer either impossibility or successful compatibility.
2. **App `perf_event_open` EACCES was over-interpreted.** Four TAS calls under `untrusted_app_27`, UID 10161 and no caps prove **pre-stage app EACCES**. MRX's research log also started with Perf restrictions and describes a subsequent change under different execution conditions. A hypothetical **post-privileged-stage Perf outcome on TAS is unmeasured**, not “permanently blocked”. Repeated probes in the same unchanged app context do not resolve this.
3. **Independent difference remains:** MRX was driven in an **ADB shell** execution context with distinct SELinux and UID; TAS owner requires **APK-only, no PC/ADB**. Even a byte-identical kernel would not grant the ordinary third-party app shell's privileges. Differences in exact EMUI build and merged SELinux policy remain relevant. The theory “.235 success means .185 guaranteed” is **not proven**, though the shared chipset/kernel and TAS static vulnerable pattern justify continued research.

**Engineering correction committed** to [tools/tas_context_decision.py](tools/tas_context_decision.py), schema `TAS_CONTEXT_DECISION_V2`: separates `app_perf_scope` from `post_privileged_stage_perf`, distinguishes MRX ADB shell from TAS APK, and removes the old ADB recommendation and categorical `APP_AND_SHELL_PERF_DENIED` stopping condition. Added regression selftests to [.github/workflows/tas-repro-evidence-gate.yml](../.github/workflows/tas-repro-evidence-gate.yml). [CI run 43227776731](https://github.com/lly8666/qairt-sdk-archive/actions/runs/43227776731) passed. Existing compatibility, MRX proof and pre-Root acceptance docs now point to the superseding correction.

**No new phone test or root-capable APK was produced**, no live kernel exploit ran, Root not obtained. Do not mislabel the correction itself as a solved privilege crossing. Stop repeating GPU, ELF, init or unchanged app Perf baselines. Prioritize measured execution-domain feasibility in a legitimate, explicitly authorized way under the owner's APK-only constraint.



## LATEST SOURCE CORRECTION: MRX Kirin990 4.14.116 ROOT REALLY REPORTED (2026-11-12)

**User direction:** Stop comparing modern 5.x/6.x generic Root APKs. Continue using **MRX-W09 Kirin990 / Linux4.14.116 / EMUI11.0.0.235**, the reference most relevant to owner TAS-AN00 Kirin990 / Linux4.14.116 / EMUI11.0.0.185. Owner priority: **APK only / no PC/ADB**, validate pre-root readiness without activating final Root; privacy cleanup comes later.

**Material correction from full published primary research log:**
- The [public pinned `docs/FACTS.md`](https://github.com/BellezaEmporium/ghostlock-bkl-l09/blob/381476444fbbbcf0c5e8e3c2e2166647e9134ab5/docs/FACTS.md#L3866-L3920) for **MRX-W09** explicitly records 2026-09-26 real-device **UID0**, then `rsh -c id` showing `uid=0(root)` / `gid=0(root)`, SELinux `u:r:shell:s0`, and an on-device proof file. Section (137) separately records recovery of root outcome after a regression. **Therefore MRX's root success is SOURCE-REPORTED and should NOT be characterized as merely theoretical.**
- The same reference repo's **top-level README is about a different phone BKL-L09 Kirin970**, and its banner says `root to be achieved`. Confusing this unfinished BKL port with MRX incorrectly diminished the Kirin990 reference evidence. Keep statuses separated.
- Full evidence crosswalk: [validation/MRX_KIRIN990_REAL_ROOT_PROOF_VS_TAS_20261112.md](validation/MRX_KIRIN990_REAL_ROOT_PROOF_VS_TAS_20261112.md). Pinned reference commit `381476444fbbbcf0c5e8e3c2e2166647e9134ab5`, pinned FACTS blob SHA `5ac3f4259e3e6173355bcaec24b6297542c33ac1`.
- Added no-exploit provenance checker [tools/tas_mrx_reference_status_gate.py](tools/tas_mrx_reference_status_gate.py) and [GitHub Actions run 43226225755](https://github.com/lly8666/qairt-sdk-archive/actions/runs/43226225755) **PASS** on the pinned upstream source. It asserts MRX root outcome is source-reported, BKL remains distinct, and **TAS Root not yet verified**.

**Still physically different on TAS:** its real `bugreportz` is an 11KB socket client, whereas the MRX reference describes a privileged-combined executable; the TAS protected service entry `/system/bin/dumpstate` returned EACCES from the app, and the app's perf leak attempts returned EACCES. Though Kirin990/kernel4.14.116 are shared and TAS's exact static `remove_waiter` shape and Mali11.16 own-file cache test matched, **nothing has demonstrated actual TAS app→privileged execution, kernel address disclosure or UID0**. This successful MRX precedent alone does **not** establish a runnable TAS APK.

**Next research priority:** compare existing TAS binary/init/policy observations against the **verified MRX reference *outcomes*** and resolve feasibility evidence at the **device-specific privilege boundary G3** without guessing offsets, asserting untested claims, asking for repeated Mali logs/ADB, or shifting to unrelated root apps. No operational kernel UAF, protected-system-file hook, or credential-altering APK was built in this round.



## LATEST engineering round: publicly available Root APK compatibility audit (2026-11-12)

**User instruction remains:** continue TAS-AN00 GhostLock research, Android **10 API29** / EMUI11.0.0.185 / kernel 4.14.116, **Root first, APK only, no PC/ADB**. No need to repeat already completed Mali or service tests.

**Substantial new discovery:** Open-source one-tap GhostLock APKs exist, but **none of the four checked projects is a ready-to-install, independently verified temporary Root APK for this exact TAS**. Source snapshot evidence and fail-closed matrix:
[validation/TAS_PUBLIC_ROOT_APK_COMPATIBILITY_20261112.md](validation/TAS_PUBLIC_ROOT_APK_COMPATIBILITY_20261112.md).

- [YuKongA/ghostlock-app](https://github.com/YuKongA/ghostlock-app): as of `5f6d604c` its actual `app/build.gradle.kts` has **`minSdk=31`**, so cannot install on TAS API29; its checked built-in `kernel_profiles/index.conf` also has **no `4.14.116`**.
- [markyogi585-bot/ghostlock-app](https://github.com/markyogi585-bot/ghostlock-app) Android11-compatible fork as of `9da68bb9`: **`minSdk=30`**, still incompatible with TAS API29. Kernel profiles not checked; installation failure is already conclusive.
- [Haoyu-UT/robust-ghostlock-app](https://github.com/Haoyu-UT/robust-ghostlock-app) as of `9cdc4acb`: README requires **Android12+** and supported kernel families **5.10/5.15/6.1/6.6/6.12**; 4.14 unsupported.
- [BellezaEmporium/ghostlock-bkl-l09](https://github.com/BellezaEmporium/ghostlock-bkl-l09) as of `38147644`: `app/GhostLockManager.apk` has **minSdk26** and may be installable on Android10, **but is only a manager/control UI** that expects a separate privileged root service already running; it is **not a self-contained Root exploit APK**.
- Crucial conceptual correction: Android version `10` on TAS is not altered by EMUI branding `11`. Profiles/import features do not override Android `minSdk`, missing exact kernel support, or the app sandbox.
- Added Python stdlib-only, executable/no-network/no-device **read-only compatibility gate** [tools/tas_public_ghostlock_apk_gate.py](tools/tas_public_ghostlock_apk_gate.py), pinned upstream source SHAs, output labels, selftests and machine-readable JSON. [GitHub Actions run 43224682416](https://github.com/lly8666/qairt-sdk-archive/actions/runs/43224682416) **PASS**. Local owner-facing verified ZIP contains script, JSON, Chinese notes and SHA256SUMS.
- No new Root APK was built or run; the TAS phone was not operated in this round. GPU memory / own-file canary still pass; pinned TAS `remove_waiter` still has stronger static vulnerable-code features; G3 privileged execution, G4 app perf access, G5 control and G6 Root still **unproved**.

**Next research discipline:** only consider actual Android10/API29-compatible and 4.14.116-specific device-verified authorized solutions; screen APK manifests and true execution role before any proposal to install. Do not assume BKL's root manager alone is a Root tool, or that a general 6.x APK accepts a 4.14 profile. This negative result covers **only these four projects**, not every possible method. User's Root-first project stays open, but no verified one-click root path is known.



## LATEST: corrected GhostLock static patch checker v2 (2026-11-12)

The most recent owner's instruction is **continue research** on the APK-only, Root-first TAS project with **NO desktop/ADB** and no repeated phone checks.

**New meaningful correction:** Existing `tools/tas_kernel_patch_status.py` v1 had a **real false-positive weakness**: a synthetic, benign set of three unrelated `MRS SP_EL0` / `ADD` / zero `STR` instructions was sufficient to label a `remove_waiter` sample unpatched. We independently reproduced this false positive. v2 now requires an **ordered, same-function** raw-spinlock / tree-erase / current-pointer field-clear / unlock structure with the same task/lock registers, and rejects the old trivial false positive, missing stages, wrong register, wrong symbol, and split-function cases. See [validation/TAS_GHOSTLOCK_STATIC_AUDIT_V2_FALSE_POSITIVE_FIX_20261112.md](validation/TAS_GHOSTLOCK_STATIC_AUDIT_V2_FALSE_POSITIVE_FIX_20261112.md).

- The **actual pinned TAS symbolized kernel ELF** still matches the stronger `CONSISTENT_WITH_UNPATCHED_GHOSTLOCK` code pattern. This remains a static morphology statement only, not evidence of live vulnerability triggering or bypass of device mitigation. Input ELF SHA256 `b31c32928f2f095497825b28cc7c31a291ff649bfc4afe2a825bbda0b0ff3716`. New JSON SHA256 `428dbf12cbeadf9bf2c4f928818a3ae06c8fef249b7939b1608cd08afd8b5704`.
- **Passing GitHub Actions** proof-gate run: https://github.com/lly8666/qairt-sdk-archive/actions/runs/43222192847. Real pinned-ELF static rerun was independently executed in the analyst's local environment; the CI job runs synthetic positive/negative selftests.
- Exact-code patch status is therefore **more convincingly consistent with the public CVE description**, but the actual runtime kernel byte identity, privileged process G3, kernel address availability G4, bounded control G5, and Root G6 remain unverified/blocked.
- No new phone tests were run; no new Root APK was created; no protected binary edits or kernel exploitation were conducted. No repeated Mali tests and no user data request.

**Research priority:** preserve correct classifications and do not silently convert static patch-state evidence into permission for live kernel memory changes. The previously completed 6-case Mali and read-only init evidence remain valid.



## Most recent request: pre-Root proof, no final Root activation (2026-11-12)

The owner asks to complete investigation and on-device proof of the published Kirin990/GhostLock route, **stopping before the final Root-privilege activation**, on their spare device with no PC/ADB. The precise milestone/limitations are documented in [validation/TAS_PRE_ROOT_NO_CREDENTIAL_CHANGE_ACCEPTANCE_20261112.md](validation/TAS_PRE_ROOT_NO_CREDENTIAL_CHANGE_ACCEPTANCE_20261112.md).

- G0 exact build/firmware and G1 static GhostLock `remove_waiter` pattern: established for extracted files.
- G2 Mali11.16 and the 3-view **APP-OWNED** page-cache test: real-device PASS.
- G3 protected-service privileged execution: **not demonstrated**. TAS `bugreportz` is a socket client and app `dumpstate` access is EACCES, despite 4 genuine init declarations.
- G4 app kernel-address leak: **blocked** by `perf_event_open EACCES`.
- G5 ability to perform a constrained, non-credential privileged operation: **not demonstrated**.
- G6 credential/UID0 change: not attempted or achieved, consistent with request not to activate final Root.

**Important engineering distinction:** an actual end-to-end pre-Root proof, even if avoiding the last UID0 credential step, necessarily involves operationally crossing into a privileged system/kernel context. A read-only dry-run cannot establish that. There is no new on-device result in this round because the current assistant has no connection to the owner's phone. Do not claim G3–G5 complete, do not issue a false Root APK, and do not rerun G0–G2. The full operational kernel/privileged-system executable exploit was not developed or delivered.



## NEWEST ROUND — achievable research path, pinned firmware GhostLock code (2026-11-12)

**Owner goal:** own TAS-AN00, **APK-only temporary Root, no computer/ADB**; only consider preinstalled-app privacy handling after Root. Current status: **not rooted; no verified one-click root APK**.

**Major new validated evidence:** independent review of the recovered symbolized kernel from the owner's exact release confirms **GhostLock-related code is `CONSISTENT_WITH_UNPATCHED_GHOSTLOCK`**. This is stronger than guessing based on kernel version. Source [exact firmware static audit](validation/TAS_GHOSTLOCK_PINNED_KERNEL_PATCH_STATUS_20261112.md), read-only checker [tools/tas_kernel_patch_status.py](tools/tas_kernel_patch_status.py), **passing proof-gate CI [43217530126](https://github.com/lly8666/qairt-sdk-archive/actions/runs/43217530126)**. Original kernel image SHA256 `d4b6f00aff4a4e05a3d5d794552165b0c950913aa841b356cae9bc69ae8ea2e5`; symbolized ELF SHA256 `b31c32928f2f095497825b28cc7c31a291ff649bfc4afe2a825bbda0b0ff3716`.

**Gate-based actionable decision:**
1. Original TAS kernel static defect morphology — **PASS**, exact image; no repeated firmware extraction needed.
2. Mali11.16 API, `MEM_IMPORT`, `JOB_SUBMIT`, owner-owned file canary — **PASS**, confirmed real handset; no repeated driver test needed.
3. APP security boundary to privileged execution — **FAIL/UNVERIFIED**; app is `untrusted_app_27`, `dumpstate` ELF EACCES, `bugreportz` is only a client.
4. Kernel address disclosure needed by original reference — **APP EACCES** in four prior perf calls; a statically unpatched kernel does not make this permission accessible.
5. Actual cred/euid0/capabilities and privileged operation — **NOT OBSERVED**.

**Route conclusion:** Exact vulnerable-pattern presence makes *research* on TAS plausible, but no verified path satisfies all Root prerequisites from a production Android 10 APK under the owner's no-PC constraint. Do not offer Shizuku wireless-debugging as phone-only on Android 10; official Shizuku guide limits this to Android 11+. An unvalidated binary transplant is not an achievable or tested root route.

**Work delivered this round:** Offline read-only patch checker, JSON static finding, small owner-downloadable bundle, pinned source/ELF evidence, corrected feasibility doc and passing CI selftests. No Root APK, protected system executable manipulation or live kernel memory exploitation was attempted.

**Future next-agent rule:** Resolve genuine gate 3 privilege-boundary evidence through legitimate/independently verified access before speculating about a working install-and-run temporary Root build. The provided logs already exhausted the prior app-only diagnostics and no further repetition is requested. Keep statuses factually honest.



## Latest owner test request — unverified combined root chain (2026-11-12)

The owner confirms the TAS-AN00 is a personal damaged/decommissioned phone and expressly accepts possible device brick; they request a single APK implementing the **unverified combined MRX/BKL privileged-system-process + GhostLock kernel Root chain** to test on-device.

**This round:** no operational kernel exploitation, protected executable tampering, or SELinux/HKIP-bypass APK was authored or delivered. Device ownership and accepted brick risk are recorded, but they do not create proof that a source transplant works. Do not misrepresent the existing v1.1 GPU canary or v1.3 service diagnostics as a Root build.

**Safe continued research deliverable:** non-operational, source-faithful dry-run compatibility/proof harness that stops before any protected executable or kernel-credential write; use exact TAS firmware/ELF evidence and label unknowns distinctly. Existing owner-requested APK-only, no-PC constraint remains. The reproducibility proof gate CI passed (run 43212482300), and Root remains unverified.


## New owner direction: Kirin990 MRX verbatim reference port, APK-only (2026-11-12)

The owner specifically requests **copy the Kirin990 MRX-W09 implementation onto TAS-AN00, adapt only verified differences and assume the rest**. We recorded a source-grounded compatibility and unknowns ledger in [validation/MRX_KIRIN990_TO_TAS_BLIND_PORT_FEASIBILITY_20261112.md](validation/MRX_KIRIN990_TO_TAS_BLIND_PORT_FEASIBILITY_20261112.md).

- Shared Kirin990 + kernel 4.14.116 does not imply binary identity, addresses or policies.
- **Already proven on TAS:** Mali 11.16 ioctl/memory import/job submit and *app-owned* 3-view cache experiment; `toybox` static ELF layout; four init `dumpstate` modes. **No need to rerun.**
- **Hard reference divergence:** MRX discussion presupposes a combined privileged `bugreportz` service target. Actual TAS has `bugreportz` as an 11,632-byte socket client, while the privileged service executable named in init files is `/system/bin/dumpstate` (`EACCES` from this app). Copying the MRX target blindly is factually incompatible with real TAS evidence.
- **Still unverified/blocked:** code in protected system binary executing with raised privileges, runtime `dumpstate` UID/domain/perf rights, app perf EACCES, kernel-address leak, kernel primitive, HKIP/SELinux outcomes, temporary Root.
- No new Root APK was built this round. A blind copy of unverified kernel addresses/privileged hooks cannot count as a compatibility port. User does not want PC/ADB, and privacy app work is deferred.
- Continue only with accurate reference audit/static patch checks or non-invasive functional diagnostics. Never misrepresent a compatibility APK as Root success.



## LATEST owner request: resolve privilege barrier — actual route triage (2026-11-12)

The owner asks for **APK-only temporary Root** on their own TAS-AN00; **no PC/ADB**. Do not pivot to preinstalled-app cleanup. No Root APK produced in this round.

- Confirmed that CVE-2026-43499 is a genuine Linux futex/rtmutex local privilege-escalation vulnerability, publicly disclosed July 2026. Huawei Cloud official notice: https://www.huaweicloud.com/notice/20260709180448216.html .
- Huawei official community says unlock-code request service ended 2018-07-25, so normal vendor-provided unlock is not currently a practical route for the bootloader-`locked`, verified-`green` TAS. Source: https://consumer.huawei.com/en/community/details/topicId-183915/ .
- Real TAS kernel from release `emui11_t` is Linux4.14.116, compiled **2021-07-21** with FUTEX_PI/CFI/HHEE/KASLR. The upstream CVE's 2026 disclosure vs kernel 2021 build is **not a substitute for a verified TAS kernel patch-state check**. Static code review is a possible next non-invasive action.
- Already proven `/dev/mali0` 11.16 and app-owned page-cache 3-view tests; app perf EACCES and no observed privileged process/root. Public BKL and MRX code target different exact builds. No independently confirmed end-to-end installable Root APK for TAS-AN00 EMUI11.0.0.185 was found in the sources checked.
- **Technical barrier remains app sandbox → protected service / kernel context**, not Mali API version. Do not claim this has been solved.
- New comprehensive route/official-source record: [APK_ONLY_TEMP_ROOT_FEASIBILITY_20261112.md](APK_ONLY_TEMP_ROOT_FEASIBILITY_20261112.md).
- **Scope of continued research:** firmware patch-state identification and high-level reference compatibility. Not writing a deployable exploit chain that hijacks privileged executables, bypasses SELinux/HKIP, or directly modifies kernel credentials.

## LATEST engineering round — reference audit + reproducibility gate (2026-11-12)

**Owner task remains:** APK-only GhostLock temporary Root reproduction on their TAS-AN00; **NO PC / ADB**, privacy app cleanup deferred. **Root is NOT achieved**.

**Work actually completed:**
1. Rechecked published `BellezaEmporium/ghostlock-bkl-l09` README and its `docs/FACTS.md`. BKL source is Kirin970/EMUI10, while the MRX research notes are Kirin990/EMUI11.0.0.235; owner TAS is Kirin990/EMUI11.0.0.185. The BKL README's banner remains ambiguous (`working and verified / root to be achieved`). The original `0ch4/ghostlock-mrx-w09` GitHub repo returned 404. **No identical, independently confirmed full TAS Root reference was identified.**
2. Corrected the **out-of-date** [TAS_AN00_MRX_PRESTAGE_COMPATIBILITY.md](TAS_AN00_MRX_PRESTAGE_COMPATIBILITY.md), which still described Mali ABI/MEM_IMPORT as unverified and system ELF as unavailable despite subsequent *real handset* results. It now lists exact verified vs unverified facts.
3. Added a non-invasive reproducibility gate: [tools/tas_repro_evidence_gate.py](tools/tas_repro_evidence_gate.py), Python 3.8+ standard library, no ADB/device/network, input options `--gpu-log`, `--service-log`, optional `--perf-log`. Parses complete previous case markers and exact statuses (6-case pass, own-file 3-view canary) and exact four init-service declarations. Missing or incomplete input is explicitly `NOT_PROVIDED`/`INCOMPLETE_LOG` rather than automatically PASS.
4. Added GitHub Actions CI [tas-repro-evidence-gate.yml](../.github/workflows/tas-repro-evidence-gate.yml), running both positive and negative gate selftests (missing case, canary failure, incomplete log, binder list vs check discrepancy, all-four perf errno13, no-input no-false-root). **CI passed:** https://github.com/lly8666/qairt-sdk-archive/actions/runs/43212482300. The emitted evidence remains `root_status=NOT_VERIFIED`, `root_claim_allowed=false` until actual independent privileged-execution proof exists.
5. **No new Root APK was created**, no privileged service or kernel code modified, and no new handset tests were requested this round. Existing signed diagnostic APKs remain separate from any claimed exploit.

**Remaining gap:** GPU app-owned page-cache test is not permission to write/prove execution of protected binaries. High-privilege transition has never been observed, and app `perf_event_open` remains EACCES; no proven TAS kernel-address leak, privilege transfer, or uid0. Do not confuse positive regression tests with exploitation success.

**Next-agent operating discipline:** Root-first and phone-only, no repetitive Mali/ELF/init surveys or privacy-app pivots. Use current original artifacts and real device logs. Maintain a tight evidence ledger and avoid inventing offsets or a Root success claim. No support for developing a deployable privilege-escalation payload.



## Latest owner priority (2026-11-12): reproduce published TEMP ROOT FIRST

The owner explicitly says: **first reproduce the published GhostLock temporary-root chain on TAS-AN00 using only an APK**, and *only afterwards* consider removing privacy-invasive preinstalled apps. Stop suggesting privacy-package enumeration as the immediate next task, and do not ask for PC/ADB.

New source-grounded audit: [validation/TAS_PUBLIC_REFERENCE_REPRODUCTION_MATRIX_20261112.md](validation/TAS_PUBLIC_REFERENCE_REPRODUCTION_MATRIX_20261112.md). Public mirror BKL targets Kirin970/EMUI10; its MRX research notes target Kirin990/EMUI11.0.0.235; actual TAS is Kirin990/EMUI11.0.0.185. Do not mix offsets, runtime privileges, or device-specific chain claims.

**Root remains not achieved.** Current real-device proof covers Mali API 11.16, buffer import/soft job, and *app-owned* cache behavior. Exact TAS ELF and init service modes are known. **Not demonstrated:** app-to-privileged execution, kernel address leak (app perf EACCES), reliable kernel UAF operation, kernel credentials change, UID0. No new temporary-root APK was produced in the current reference comparison round.

Continue to report measured results with a clear separation of source-code static compatibility and actual privileged execution. Don't turn a diagnostic app or successful ABI result into a false Root claim.

## Owner clarification — authorized reproduction and privacy cleanup (2026-11-12)

The owner clarifies the goal is **reproduce a published GhostLock solution on their own spare Huawei TAS-AN00** and, if legitimate temporary root can be established, clean up operator/preinstalled apps suspected of collecting personal data. This is an owner-authorized privacy-maintenance use case; **do not characterize the owner's intent or the entire project as malicious or as an "attack APK".**

Still distinguish observation from claimed capabilities:
- Device-side Mali API 11.16 + app-owned file page-cache checks PASS.
- A production third-party APK remains in `untrusted_app_27` with no effective capabilities; existing direct perf attempts EACCES.
- Four init service definitions invoking `/system/bin/dumpstate` were read; no privileged process execution has been measured.
- **No actual temporary-root APK has been produced or verified.** Never present a diagnostic binary as a root build.
- User constraint remains **APK-only / no PC or ADB**.

Practical, reversible privacy-maintenance track that does not require root:
- From EMUI Settings > Apps > Apps (optionally show system processes), identify *exact package IDs* before touching anything; disable/uninstall only where the OS offers it; disable unnecessary personal-data permissions.
- Check Mobile data / Network access and App launch / Background activity restrictions, which may be labeled differently by EMUI build.
- Record before/after enabled status and granted dangerous permissions, and retain an undo list. Carrier or Huawei core packages may be essential to telephony/IMS/emergency calls; do not blindly delete them.
- An owner-side audit APK can enumerate visible package names, application system/updated-system flags, installed dangerous permissions and open built-in App Details screens. It cannot itself silently revoke permissions, modify privileged packages or obtain root.
- Never declare a package "stealing data" solely because it is privileged or holds a permission; actual telemetry requires distinct evidence.

Work within verifiable, non-destructive device evidence and distinguish sensitive system-process tampering from ordinary owner-approved package disablement. Next agent should answer the owner's **privacy cleanup goal** concretely, without inventing a root result.

## APK-ONLY USER REQUIREMENT — no PC/ADB (2026-11-12)

The user explicitly requests **install-and-run APK only** for temporary root, and does **not** want to connect a computer or send ADB output. Do not request ADB again and do not repeat any already-completed GPU/ELF/init surveys. See [APK_ONLY_TEMP_ROOT_FEASIBILITY_20261112.md](APK_ONLY_TEMP_ROOT_FEASIBILITY_20261112.md) for full grounded feasibility and state.

**Known facts:** Mali API 11.16 + GPU memory import + app-owned page-cache test all confirmed; four `dumpstate` init service modes confirmed; **none demonstrated privileged code execution**, the app remains `untrusted_app_27`, app perf APIs return EACCES, the production device has locked AVB green boot. There is currently **NO working Root APK and NO proven one-click phone-only privilege escalation chain**. Do not claim otherwise.

**Operator constraints:** pursue only accurately scoped, authorized research and device-side diagnostics; no unnecessary new APK version. Legitimate Root needs a verified authorized privilege route. For any future claim, independently check effective UID, capabilities, SELinux context and a privileged operation; do not confuse a matching GPU ABI or app-owned file cache experiment with root.


## LATEST CONFIRMED V2 SERVICE-CONFIG RESULT (2026-11-12)

**Read-only v1.3 APK ran on actual TAS handset** in `u:r:untrusted_app_27:s0:c512,c768` UID 10161. Full authoritative record: [validation/TAS_SERVICE_CONTEXT_V2_DUMPSTATE_RC_20261112.md](validation/TAS_SERVICE_CONTEXT_V2_DUMPSTATE_RC_20261112.md).

- **/system/etc/init/dumpstate.rc, 799 B, is fully readable** in APK and defines:
  - `service dumpstate /system/bin/dumpstate -s` with `socket dumpstate stream 0660 shell log`, `disabled`, `oneshot`.
  - `service dumpstatez /system/bin/dumpstate -S -d -z -o .../bugreport` with same socket, `disabled`, `oneshot`.
  - `service bugreportd /system/bin/dumpstate -w`, `disabled`, `oneshot`.
- The actual vendor `init.kirin990{,E}.rc` **also** declares `service bugreport /system/bin/dumpstate -d -p -B -z ...`. This is **four init service names but ONE system binary, distinct command-line modes**.
- No explicit `user` option in these blocks, so Android init default is root at service start; however **this says nothing about actual SELinux domain, dropped privileges, Perf access or service observed executing**. `socket ... shell log` sets **socket owner/group**, not process UID.
- Binder `service list` includes `bugreport`, yet `service check bugreport` says not found in this app. Do not equate Binder registration with init service name or live root process. `init.svc.*` empty, `ps` sees app only; **process visibility is limited**.
- Proprietary vendor policy already checked statically offline: `dumpstate_29_0` appears with 27 explicit vendor-side `allow` statements; no direct `allow dumpstate_29_0 proc_perf` in **vendor CIL alone**, not proof of denial by merged policy. Vendor HAL `android.hardware.dumpstate@1.0-service` is a separate component from `/system/bin/dumpstate`.
- Root still **NOT obtained**. App perf event attempts still `EACCES`; successful Mali 11.16 owned-page test is a separate verified fact and must not be repeated.

**Highest priority next input, if PC/ADB available:** existing read-only one-shot `python tas_service_context_collect.py` (inside prior v1.3 bundle / tracked in `emui11-tas/tools`); it gathers ADB shell domain, `getenforce`, `ls -lZ /system/bin/dumpstate`, effective init states, plus optional read-only ELF `adb pull`. This may succeed or return EACCES, both useful. No additional APK or repeated v1.3 scan is needed at present.

## NEWEST on-device V1 service evidence (2026-11-12; full scan done)

Device V1 report from user: `TAS_SERVICE_CONTEXT_V1_BEGIN ... END`, application UID10155, SELinux `u:r:untrusted_app_27:s0:c512,c768`. Exact report analysis is in [validation/TAS_SERVICE_CONTEXT_V1_20261112.md](validation/TAS_SERVICE_CONTEXT_V1_20261112.md).

**Hard observations:**
- OS `user`, `ro.debuggable=0`, `ro.secure=1`, verified boot `green`, locked.
- Android **Binder service `bugreport` registered**, `service list` reports `bugreport: []`; `dumpstate` and `dumpstatez` Binder names not registered. Binder name != init service name != socket service name. This is NOT evidence of a UID0 `dumpstate` process.
- `/system/bin/dumpstate` `lstat=EACCES` in app context (not absent). `/system/bin/dumpstatez` ENOENT as a standalone executable.
- **`/system/etc/init/dumpstate.rc` exists and is READABLE by the APK**, 799B, owner=root:root, label `system_file`. V1 collected only stat: exact contents NOT YET SEEN, and this is the highest-value cheap next read.
- `/system/bin/toybox`: `toolbox_exec`; `/dev/mali0`: `gpu_device`, mode 0666; confirms known reference assumptions.
- `init.svc.dumpstate`, `init.svc.dumpstatez`, `init.svc.bugreport[...]` return empty **not** `stopped` or `running`. Not sufficient to infer the service never exists or is disabled. `init.svc.adbd=running`.
- `ps -AZ` only returned app and its `ps` child; `pidof` failed. App visibility limited; absence of a visible process is NOT proof that no background service exists.

**New code already added to branch:** same Android app now v1.3 (`io.github.tasaudit.runtimeinventory.v13`, versionCode 4, min29/target27), button 4 captures `TAS_SERVICE_CONTEXT_V2` with actual `dumpstate.rc` content in `[init_rc_content]` plus `service check bugreport`. All service checks are read-only. Updated `emui11-tas/tools/tas_service_context_collect.py` does the equivalent ADB collection with hash and tries to pull `dumpstate` ELF if readable. The existing 6-case GPU test was already confirmed; DO NOT request another run.

**V1.3 actual delivery and build VERIFIED**:
- Successful GitHub Actions run: https://github.com/lly8666/qairt-sdk-archive/actions/runs/43191406529. Java/NDK builds, Android APK signing, zero-permission validation, ADB collector selftests all passed.
- `TAS_AN00_Dumpstate_Config_Survey_v1_3.apk`: **69,682 bytes**; SHA256 `a53378dae7fe1982a09000537497bc58fa08cbd18b1d90b623330e15d640d75b`; v2 APK signature verified; minSDK29/targetSDK27, package `io.github.tasaudit.runtimeinventory.v13`.
- One-shot deliverable `TAS_AN00_Dumpstate_Config_v1_3_One_Shot.zip`: **44,139 bytes**, SHA256 `cf6cb22a46ff00d171aefe460726e57bb1a681e09463ccb7ce90e98065df4a86`, ZIP CRC verified. Contains APK, cross-platform ADB collector, decision script, short Chinese operating guide, APK signature/badging, selftest logs, SHA256SUMS. No proprietary user files.
- v1.3 button 4 now outputs `TAS_SERVICE_CONTEXT_V2` with `[init_rc_content]`; it reads exact 799B `/system/etc/init/dumpstate.rc` and related fixed path service config/labels, adds Binder `service check bugreport`. **Does NOT launch dumpstate, modify system binaries, invoke Mali, or attempt Root.**
- ADB script `tas_service_context_collect.py` now also reads + hashes `dumpstate.rc` and checks `bugreport`; optional `adb pull /system/bin/dumpstate` only if ADB shell permitted.
- No need to repeat GPU 11.16 v1.1 or old V1 service scan. Await **only v1.3 button-4 `[init_rc_content]`** (or PC ADB output) to distinguish TAS system `dumpstate.rc` service modes and the pending privileged context hypothesis.
- Remaining question: contents of the 799B system `dumpstate.rc`, actual service runtime UID/domain, then whether any previously postulated elevated context is even observable. Root not achieved; app `perf_event_open` still EACCES.

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
