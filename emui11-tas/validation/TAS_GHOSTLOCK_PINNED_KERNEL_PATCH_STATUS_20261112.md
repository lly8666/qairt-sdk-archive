# TAS-AN00 GhostLock read-only kernel patch-status audit — independently rechecked

> **Update 2026-11-12 — classifier v2 supersedes v1 signature method.** The original v1 checker could falsely classify an unrelated three-instruction sample as unpatched. The [v2 correction and real-kernel rerun](TAS_GHOSTLOCK_STATIC_AUDIT_V2_FALSE_POSITIVE_FIX_20261112.md) requires an ordered, same-function current-task lock / tree-erase / field-clear / unlock sequence. v2 still classifies the exact pinned TAS ELF as `CONSISTENT_WITH_UNPATCHED_GHOSTLOCK`, but it does **not** prove exploitability or a working Root chain. Use the v2 checker and its current output schema for future research; the v1-specific JSON field names below are historical only.


Date: 2026-11-12. **This is a static defect audit, not an exploit or proof of Root**.

## Source provenance (exact owner-supplied release)

- Target handset `TAS-AN00`, Kirin990, EMUI 11.0.0.185(C00E180R7P11), Android10 (API29), production user/AVB green/locked.
- Original kernel `Image` extracted from `BOOT.img` inside owner's pinned `emui11_t` `UPDATE.APP.zip`.
- Kernel Image SHA256: `d4b6f00aff4a4e05a3d5d794552165b0c950913aa841b356cae9bc69ae8ea2e5`.
- Successfully recovered kallsyms into symbolic ELF with `vmlinux-to-elf` from passing [2026-11-12 CI run #43215710221](https://github.com/lly8666/qairt-sdk-archive/actions/runs/43215710221). `vmlinux_to_elf_exit_status=0`.
- Symbolized ELF SHA256: `b31c32928f2f095497825b28cc7c31a291ff649bfc4afe2a825bbda0b0ff3716`.
- Auditor independently downloaded that run's *symbolized ELF and report*, verified both pinned file SHA256s, and disassembled `remove_waiter` without any device interaction. No system or app file was modified on the handset.

## Official CVE definition and code comparison

Linux kernel CVE team: [CVE-2026-43499: rtmutex: Use waiter::task instead of current in remove_waiter()](https://lists.openwall.net/linux-cve-announce/2026/05/21/7) (published **2026-05-21**).

The official description says the defect arises when `remove_waiter()` is used during proxy-lock rollback while the waiting task is different from `current`; using the wrong task to clean priority-inheritance state can leave a dangling pointer. The fix uses `waiter::task` for the corresponding bookkeeping operations.

**Verified in this exact TAS kernel image** (summary of disassembly findings; no exploit addresses or code bytes):
1. Recovered ELF has a real `remove_waiter` function symbol in its code section.
2. The function reads the current task from `SP_EL0`.
3. Its early lock/bookkeeping path computes pointers from that current-task register.
4. The function's clear of the PI-blocked state is performed via that **current-task register**, rather than an independently obtained waiter-task pointer.
5. These combined facts **match the public vulnerable `current`-based pattern** described by the CVE, and independently corroborate the project README's older read-only assessment.

**Result:** `CONSISTENT_WITH_UNPATCHED_GHOSTLOCK` for the **pinned extracted kernel**, not merely an inference from the kernel version or original compile date.

**Limitations:** This does not prove the actual running handset loaded byte-identical kernel code, that the vulnerability can be successfully triggered on its mitigated build, that any arbitrary-memory access is possible, or that SELinux/HKIP/CFI permit Root.

## Safe one-command reproducibility

Local read-only Python audit code: `tas_kernel_patch_status.py` (tested independently).
- Selftest prints `TAS_GHOSTLOCK_READONLY_KERNEL_AUDIT_SELFTEST_PASS`.
- Running against the pinned symbolized ELF (no phone, no root) emits JSON:
  `pinned_elf_match=true`, `reads_current_task_from_sp_el0=true`,
  `clears_task_state_through_current_pointer=true`,
  `uses_current_based_task_lock=true`,
  `classification=CONSISTENT_WITH_UNPATCHED_GHOSTLOCK`,
  `root_observed=false`, `live_exploitation_performed=false`.
- A different ELF is rejected as `INPUT_NOT_PINNED`; synthetic patched/absent patterns are `INDETERMINATE`, not falsely marked vulnerable.
- Audit produced the local JSON `TAS_GhostLock_Kernel_Static_Patch_Check_v1.json`, SHA256 `e44510e873ea6281f5edb25ed9096ba36080fc8c28faee632b8ec574612a9917`.

## Root-first, APK-only feasibility gate

| Stage | Status from *owner's* device / exact firmware |
|---|---|
| Target build identity & kernel file | Exact version/hash pinned, offline |
| GhostLock vulnerable-code morphology | **Static confirmed** in exact extracted kernel |
| Mali Bifrost 11.16 GPU memory import + job submit | **Six-case real-device PASS** |
| App-owned 4KiB file cache canary | **Three-view real-device PASS** |
| App-accessible system-executable privileged transition | **NOT PROVEN** |
| Privileged process with effective rights useful for next stage | **NOT OBSERVED** |
| Kernel address disclosure from the app | **Four perf probes returned EACCES** |
| GhostLock kernel-memory corruption / credentials transition | **NOT TESTED/SUCCEEDED** |
| Temporary Root euid0 / capabilities / privileged operation | **NOT ACHIEVED** |

**Route decision:** Researching the GhostLock defect on TAS is justified by static firmware evidence, but **no verified phone-only, install-and-run Root path has been established**. The app-to-elevated execution barrier and the address-disclosure blocker are independent of whether `remove_waiter` is unpatched. Do not generate a root APK by copying unverified MRX/BKL offsets or claiming a canary is an exploit.

**Phone-only alternative assessment:** Shizuku's [official setup manual](https://shizuku.rikka.app/guide/setup/) says Android 11+ may start through wireless debugging without a computer, whereas **Android 10 and below require a computer** in the non-root flow. TAS **EMUI 11 still runs Android 10**, so the no-PC Shizuku shortcut is not an available assumed route.

## Recommended next condition (no repeat testing)

The decisive missing evidence is an independently observed, *authorized* privilege-bearing execution context compatible with this phone and build. Neither the GPU memory operations nor parsing `init.rc` proves one exists. Continue with careful read-only kernel/service compatibility analysis and independently verified legitimate entrypoints; do not re-run the Mali/API/ELF/service surveys or ask the owner for ADB. A Root success requires measured euid0, capabilities, appropriate SELinux domain and a privileged operation.

Public sources: [Linux CVE announcement](https://lists.openwall.net/linux-cve-announce/2026/05/21/7), [Shizuku original setup documentation](https://shizuku.rikka.app/guide/setup/).

*No kernel exploit, protected-system-file patch, or credential mutation code is provided by this report.*
