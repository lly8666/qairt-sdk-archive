# TAS-AN00 — public GhostLock APK compatibility check (2026-11-12)

**Target:** Huawei TAS-AN00 / Kirin990 / EMUI 11.0.0.185 / **Android 10 SDK29** / kernel **4.14.116** / locked bootloader. Owner's priority is temporary Root from an APK only, no PC/ADB, prior to preinstalled-app privacy cleanup. **No Root obtained**.

## New upstream research: four actual GitHub source snapshots

| Project | Public source pinned at SHA | Minimum OS / role | TAS install? | TAS kernel / Root readiness |
|---|---|---|---|---|
| [YuKongA/ghostlock-app](https://github.com/YuKongA/ghostlock-app) | `5f6d604c0ae66b28530af40bf9b540eeb311b141` | `app/build.gradle.kts` **minSdk=31**, Android 12+ | **No**, TAS API29 | Public [kernel profile index](https://github.com/YuKongA/ghostlock-app/blob/5f6d604c0ae66b28530af40bf9b540eeb311b141/app/src/main/assets/kernel_profiles/index.conf) has **no `4.14.116`** profile; profiles cover newer 5.x/6.x |
| [markyogi585-bot/ghostlock-app](https://github.com/markyogi585-bot/ghostlock-app) | `9da68bb938af158d8b3f1a67ba7b3445267e748d` | [Gradle minSdk=30](https://github.com/markyogi585-bot/ghostlock-app/blob/9da68bb938af158d8b3f1a67ba7b3445267e748d/app/build.gradle.kts), Android 11+ | **No**, TAS API29 | Profile index not independently evaluated; unnecessary after installation failure |
| [Haoyu-UT/robust-ghostlock-app](https://github.com/Haoyu-UT/robust-ghostlock-app) | `9cdc4acbc283a1d1c84a3eb10379f7c9a960fb02` | [README requires Android 12+](https://github.com/Haoyu-UT/robust-ghostlock-app/blob/9cdc4acbc283a1d1c84a3eb10379f7c9a960fb02/README.md) | **No**, TAS Android10 | Supported families 5.10 / 5.15 / 6.1 / 6.6 / 6.12, **not 4.14** |
| [BellezaEmporium/ghostlock-bkl-l09](https://github.com/BellezaEmporium/ghostlock-bkl-l09) bundled `GhostLockManager.apk` | `381476444fbbbcf0c5e8e3c2e2166647e9134ab5` | [App README](https://github.com/BellezaEmporium/ghostlock-bkl-l09/blob/381476444fbbbcf0c5e8e3c2e2166647e9134ab5/app/README.md) says **minSdk26** | **Version-compatible only** | This is a **control-panel / root manager** talking to a separately running privileged service; it **does not independently obtain Root**. Reference devices BKL/MRX are not TAS |

**Major distinction:** EMUI 11 is an OEM shell name. TAS actually reports **Android 10 API29**. An APK targeted to Android 11 or Android 12 is **not supported merely because "EMUI 11" appears in Settings**.

The `YuKongA` README offers device-specific configuration import but the [porting guide](https://github.com/YuKongA/ghostlock-app/blob/5f6d604c0ae66b28530af40bf9b540eeb311b141/docs/kernel_profiles/README.md) says the profile must match the **full exact kernel release**, and a generated profile is only an *unverified candidate*. Generating or importing a profile does not remove the APK's **minSdk gate**, give TAS a verified root chain, or imply a privilege crossing.

## Reproducible, non-operational check

Source: [`tools/tas_public_ghostlock_apk_gate.py`](../tools/tas_public_ghostlock_apk_gate.py), Python 3 standard library only. It is a read-only, **snapshot-based compatibility validator**: no exploit code, device access, permissions, downloaded binary, SELinux changes or credential modifications. Each result stores the source SHA and the evidence path.

```sh
python3 emui11-tas/tools/tas_public_ghostlock_apk_gate.py --selftest
python3 emui11-tas/tools/tas_public_ghostlock_apk_gate.py --out TAS_Public_APK_Gate.json
```

Output labels distinguish `BLOCKED_MIN_SDK`, `BLOCKED_ANDROID_REQUIREMENT`, `NO_EXACT_TAS_KERNEL_PROFILE`, and `NEEDS_ALREADY_RUNNING_PRIVILEGED_SERVICE`. Unit tests include correct detection of Gradle minSdk, kernel profile entry parsing, all four source classifications, and rejecting a Root claim.

**Scope:** these are snapshots of a reviewed set of 4 public projects as of November 12; they do **not** prove other root methods do not exist. The actual handset has not installed any new APK, and no on-device operation or temporary Root was performed in this round.

## Engineering decision

- **Do not spend owner time installing these particular upstream binaries on TAS as if they were ready-to-root**. Three have an OS installation blocker, the fourth is a manager requiring an already functional privileged backend.
- Continue preserving the strong evidence already acquired: exact TAS firmware/ELF, GhostLock-like static `remove_waiter` defect, Mali11.16 six-case compatibility and app-owned cache tests.
- The unresolved problem is not packaging or the GPU ABI. A **verified Android10-compatible, TAS-specific, owner-authorized elevated execution path** is still absent. A remote static audit cannot honestly claim it has been created or phone-tested.
- Do not request another Mali run, init survey, or desktop ADB log. The user has repeatedly stipulated **APK only**.

This report distinguishes **installability**, **kernel configuration support**, **privileged-service availability** and **Root proof**, which are four different requirements. No deployable local privilege escalation chain was built here.
