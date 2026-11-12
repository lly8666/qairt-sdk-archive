# TAS-AN00 GhostLock static audit v2 — reproducible false-positive correction

Date: 2026-11-12. Source inputs: pinned owner-supplied `emui11_t` kernel Image, recovered symbolized ELF. **Read-only static analysis only; no phone exploit, no privileged execution, no Root.**

## New finding: v1's classification was insufficiently discriminating

Previous [kernel patch audit](TAS_GHOSTLOCK_PINNED_KERNEL_PATCH_STATUS_20261112.md) reported `CONSISTENT_WITH_UNPATCHED_GHOSTLOCK`, but its classifier accepted any `MRS SP_EL0` plus a current-task derived `ADD` and current-pointer zero `STR`, even when the instructions were unrelated to the rtmutex waiter-dequeue critical section. These patterns can appear in legitimate current-task accounting too.

**Independent negative control:** a synthetic input containing only those three independent operations under a `remove_waiter` symbol was labeled `CONSISTENT_WITH_UNPATCHED_GHOSTLOCK` by v1. This is an actual confirmed false-positive *test case*, **not** evidence that the real TAS binary was patched.

## The new v2 classifier

Updated [tools/tas_kernel_patch_status.py](../tools/tas_kernel_patch_status.py) to classify only **within the symbolized `remove_waiter` function**, and require a coherent ordered code sequence:

1. obtains the current-task pointer from `SP_EL0`;
2. derives a lock pointer from that same register;
3. passes it to raw spinlock acquisition;
4. performs the red-black-tree erase within that critical region;
5. clears a task-owned state field **via the original current-task register**;
6. releases the lock.

This is a structural corroboration of the [kernel CVE advisory](https://lists.openwall.net/linux-cve-announce/2026/05/21/7), which says the erroneous code processes `current` instead of `waiter::task` in proxy-lock rollback.

The v2 checker also rejects input if its SHA256 differs from the pinned recovered ELF, and avoids using any disassembly outside the relevant function. It is not a complete formal verification of every control-flow path; status remains **`CONSISTENT_WITH_UNPATCHED_GHOSTLOCK`, not definitively exploitable**.

## Test result on exact user's firmware

- Original `Image` SHA256: `d4b6f00aff4a4e05a3d5d794552165b0c950913aa841b356cae9bc69ae8ea2e5`.
- Recovered ELF SHA256: `b31c32928f2f095497825b28cc7c31a291ff649bfc4afe2a825bbda0b0ff3716`.
- v2 selftest: `TAS_GHOSTLOCK_READONLY_KERNEL_AUDIT_V2_SELFTEST_PASS`.
- v2 *real pinned-ELF* run:
  - `pinned_elf_match=true`
  - `remove_waiter_symbolized=true`
  - `sp_el0_current_task_read=true`
  - `complete_current_based_critical_section=true`
  - `classification=CONSISTENT_WITH_UNPATCHED_GHOSTLOCK`
  - `patch_proven=false`; `exploitability_proven=false`; `root_observed=false`
- Negative tests: missing tree-erase, wrong task register, missing unlock, unrelated symbol, split-function code, wrong control-flow ordering, and *the v1 false-positive input* all return `INDETERMINATE`.
- Local JSON SHA256: `428dbf12cbeadf9bf2c4f928818a3ae06c8fef249b7939b1608cd08afd8b5704`.
- [GitHub Actions regression run 43222192847](https://github.com/lly8666/qairt-sdk-archive/actions/runs/43222192847): **success**, after the v2 checker was committed.

## Effect on Root-first research

The research hypothesis **survives** a stronger static integrity check: the recovered TAS kernel shows a code structure consistent with the unpatched publicly disclosed bug. This rules out a simplistic false positive due to coincidentally occurring opcodes, but not a hidden downstream mitigation or a vendor change outside the inspected function.

**This does not make a phone-only temporary Root chain feasible by itself.** The existing four app `perf_event_open` requests are still `EACCES`; privileged-system execution G3, effective address disclosure G4, kernel control G5 and credential transition G6 are **not demonstrated**. No device tests were performed in this new round, and no root-capable APK was created.

**No repeat user action needed.** Keep using original v1.1 Mali, v1.3 service, supplied exact ELFs and firmware as completed evidence. Do not ask for a PC, ADB or redundant logs.

Source: [CVE-2026-43499 Linux disclosure](https://lists.openwall.net/linux-cve-announce/2026/05/21/7), [TAS current handoff](../HANDOFF_LATEST.md).
