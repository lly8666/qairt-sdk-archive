# TAS-AN00 / EMUI 11.0.0.185: APK-only temporary root feasibility and handoff

Updated: 2026-11-12 (UTC). User constraint: **NO COMPUTER / NO ADB / install-and-run APK only**. Do not request desktop ADB logs again.

## Required outcome versus current evidence

Target: expendable, owner-authorized Huawei Mate 30 TAS-AN00, Kirin 990, Android 10, EMUI 11.0.0.185(C00E180R7P11), bootloader locked, Android Verified Boot green, `ro.debuggable=0`, `ro.secure=1`.

Requested final outcome: **temporary root** from an installable APK. **NOT ACHIEVED**. No command has ever run with effective UID 0 or elevated capabilities, and nothing established a transition into a privileged SELinux domain.

### Real-device PASS (do not repeat)

- Ordinary app opens `/dev/mali0`, version-check ioctl reports Bifrost API **11.16**.
- `SET_FLAGS`, GPU tracking mapping, `MEM_ALLOC` + mapped CPU roundtrip, `MEM_IMPORT`, and `JOB_SUBMIT` returned success.
- Test of a **new, app-private, expendable file** showed the expected modified page content via same fd, another fd, and independent mapping.
- Owner-supplied `system-elfs.zip` established exact ELF hashes and Build IDs for `toybox`, `bugreportz`, `app_process64`, APEX `libc`; no need to request them again.

### Actual privilege boundary still present

- Application context `u:r:untrusted_app_27:s0:c512,c768`, zero effective capabilities, seccomp=2.
- Earlier direct app `perf_event_open` requests all returned `EACCES`; direct app KASLR leak failed.
- `/system/bin/dumpstate` is `EACCES` for the untrusted app. **Do not misreport this as absent.**
- Real `/system/etc/init/dumpstate.rc` (799B) defines **three** `disabled`, `oneshot` service names (`dumpstate`, `dumpstatez`, `bugreportd`) all invoking `/system/bin/dumpstate`; Vendor init also defines `bugreport` using that binary.
- No user specified in the init records means default init UID at start (normally root), but it does not establish a running process, effective SELinux rights, or app-controlled execution.
- `service list` includes `bugreport`, while `service check bugreport` says not found, and app process visibility is restricted. The presence of a Binder name is **not** proof that a UID0 service can be influenced by a normal APK.
- No on-device evidence proves that the app-file page-cache canary extends to a protected system executable, or yields persistent code changes, privileged execution, or root.

## Revised workflow — phone-only

1. **Stop asking the user for ADB / USB / PC**. Keep the v1.3 signed read-only survey APK as the installed baseline; its data was already delivered and analyzed, so don't ask user to rerun it.
2. There is **no general Android SDK/Java or NDK API** that makes a third-party app root on this locked AVB-green production build. Any claim of an APK-only one-click temporary root needs independent, repeatable proof of a security vulnerability enabling a privilege boundary crossing; success in app-controlled memory tests is not enough.
3. Safety-preserving, non-invasive optional phone-only follow-up: package already collected OS release identifiers, app context and kernel restrictions into a single user-shareable report if needed. Do not create endless diagnostic APK versions; only collect previously unavailable evidence when it can resolve an actual uncertainty.
4. For legitimate temporary root, establish a **vendor-supported authorized elevated execution route** or authorized bootloader-unlock/engineering environment. Without one, say **not verified / not possible to promise**, not "root working".
5. No code or instructions in this handoff should be interpreted as permission to patch privileged system executables, defeat SELinux/HKIP, or deploy a live kernel escalation chain. Future agents must distinguish legitimate research and compatibility measurements from a working privilege-escalation exploit.

## NEW — exact TAS kernel patch-state rechecked (2026-11-12)

The previous tentative statement in this document — "TAS kernel CVE patch state not independently determined" — **has been superseded**.

- Downloaded the original kernel-recovery artifacts from **successful Actions run [43215710221](https://github.com/lly8666/qairt-sdk-archive/actions/runs/43215710221)**, recovered from owner's exact release `emui11_t`.
- Original Linux Image pinned SHA256: `d4b6f00aff4a4e05a3d5d794552165b0c950913aa841b356cae9bc69ae8ea2e5`.
- Symbolized ELF pinned SHA256: `b31c32928f2f095497825b28cc7c31a291ff649bfc4afe2a825bbda0b0ff3716`.
- Independently examined `remove_waiter` with `llvm-objdump`: the early bookkeeping still uses the current task derived from `SP_EL0` and clears PI state through that pointer, matching the kernel.org CVE-2026-43499 **unpatched pattern**. Static classification **`CONSISTENT_WITH_UNPATCHED_GHOSTLOCK`**, not definitive live exploitability.
- Added tracked read-only script [tools/tas_kernel_patch_status.py](tools/tas_kernel_patch_status.py), with pinned ELF hash guard, synthetic negative tests and no runtime kernel operations. Proof gate [CI run 43217530126](https://github.com/lly8666/qairt-sdk-archive/actions/runs/43217530126) passed.
- Full measured evidence: [validation/TAS_GHOSTLOCK_PINNED_KERNEL_PATCH_STATUS_20261112.md](validation/TAS_GHOSTLOCK_PINNED_KERNEL_PATCH_STATUS_20261112.md).
- **CVE release date correction:** kernel CVE announcement dated **2026-05-21**, while some vendor advisories were posted in July 2026. The kernel report says the bug can lead to UAF; the specific TAS operational Root chain is **still unproven**.

**Honest decision:** GhostLock is a plausible research target for this firmware due to real static evidence, but owner requires APK-only with no ADB, and the **app-to-privileged process barrier + app perf EACCES** remain. No confirmed root-capable APK was produced. Do not treat this report as device exploitation or a working Root path. Android 10 also lacks Shizuku's phone-only Android 11+ wireless-debugging setup.

## 2026-11-12 verified public-source recheck and route triage

### Source-backed facts

- Huawei Cloud published an alert on 2026-07-09 for **CVE-2026-43499 (GhostLock)**, a real local privilege-escalation vulnerability in the Linux kernel FUTEX / rtmutex path. Source: https://www.huaweicloud.com/notice/20260709180448216.html . This confirms a public vulnerability class, **not** that the precise TAS firmware is exposed in an exploitably reproducible form.
- Huawei's own community support states official bootloader unlock-code requests ceased **2018-07-25** and codes are no longer provided. Source: https://consumer.huawei.com/en/community/details/topicId-183915/ . A normal legitimate end-user unlocked-bootloader / custom boot Root route is therefore not currently available through this OEM service.
- Owner's BOOT/RECOVERY kernel Image extracted from exact release `emui11_t` reports **Linux 4.14.116, compiled 2021-07-21**, SHA256 `d4b6f00aff4a4e05a3d5d794552165b0c950913aa841b356cae9bc69ae8ea2e5`. Extracted kernel config has `CONFIG_FUTEX_PI=y`, `CONFIG_CFI_CLANG=y`, `CONFIG_HISI_HHEE=y`, `CONFIG_RANDOMIZE_BASE=y`. A pre-disclosure build and enabled futex PI make affected-code presence plausible, but **a binary patch-status review is still needed** before calling the device definitely vulnerable.
- Public BKL reference is for Kirin970 EMUI10 and MRX note is for Kirin990 EMUI11.0.0.235, not TAS EMUI11.0.0.185. Source: https://github.com/BellezaEmporium/ghostlock-bkl-l09 . Current published material checked on 2026-11-12 has **not** supplied a device/build-specific independently verified install-and-run TAS-AN00 Root APK. This is a scope-limited search result, not proof that none exists anywhere.

### Practical feasibility outcomes

| Candidate | Result on owner's TAS-AN00 |
|---|---|
| Built-in ordinary APK Root API | Not available on locked production Android |
| Huawei official unlocked bootloader | Unlock-code service ended; handset reports `locked`, `green` |
| Reference Mali 11.16 buffer operations | **Proven** by six-case on-device test |
| Protected service code execution / kernel perf access | **Unproven**; app perf calls EACCES |
| CVE-2026-43499 kernel UAF patch state on exact TAS image | **Static pattern now confirmed consistent with unpatched; live exploitation still unverified**; 2021 build date alone is insufficient |
| Complete phone-only temporary Root | **NOT ACHIEVED**; no published exact-firmware APK verified |

**Next high-value non-invasive analysis (no owner interaction):** perform a read-only, source-to-exact-kernel firmware review to classify `remove_waiter` fix status without creating or executing a kernel exploit. Record uncertainty faithfully. Do **not** keep asking user to rerun GPU canaries or app init surveys; their evidence is complete. A weaponized system-executable tamper, SELinux bypass, or credential UAF payload is outside this audit.

## Progress ledger and source of truth

- On-device ABI / GPU canary: [validation/TAS_DEVICE_MALI_V2_ELF_20261112.md](validation/TAS_DEVICE_MALI_V2_ELF_20261112.md)
- On-device service / init: [validation/TAS_SERVICE_CONTEXT_V2_DUMPSTATE_RC_20261112.md](validation/TAS_SERVICE_CONTEXT_V2_DUMPSTATE_RC_20261112.md)
- On-device Binder / labels: [validation/TAS_SERVICE_CONTEXT_V1_20261112.md](validation/TAS_SERVICE_CONTEXT_V1_20261112.md)
- Verified source hashes: [validation/TAS_INITRC_TOYBOX_STATIC_20261112.md](validation/TAS_INITRC_TOYBOX_STATIC_20261112.md)
- Comprehensive latest handoff: [HANDOFF_LATEST.md](HANDOFF_LATEST.md)

**Success criteria for future claims:** on-device process with euid 0, observed effective capabilities as needed, correct SELinux security context, independently verified privileged operation and stability. No such evidence exists in this project to date. Do not describe an ordinary app-owned GPU memory operation as Root.

## 2026-11-12 action

Recorded APK-only/no-ADB constraint and reconciled earlier diagnostic evidence with the actual temporary-root request. No new Root APK was produced or tested in this round. Existing APKs remain diagnostics, and the reported smartphone stays locked.
