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

## Progress ledger and source of truth

- On-device ABI / GPU canary: [validation/TAS_DEVICE_MALI_V2_ELF_20261112.md](validation/TAS_DEVICE_MALI_V2_ELF_20261112.md)
- On-device service / init: [validation/TAS_SERVICE_CONTEXT_V2_DUMPSTATE_RC_20261112.md](validation/TAS_SERVICE_CONTEXT_V2_DUMPSTATE_RC_20261112.md)
- On-device Binder / labels: [validation/TAS_SERVICE_CONTEXT_V1_20261112.md](validation/TAS_SERVICE_CONTEXT_V1_20261112.md)
- Verified source hashes: [validation/TAS_INITRC_TOYBOX_STATIC_20261112.md](validation/TAS_INITRC_TOYBOX_STATIC_20261112.md)
- Comprehensive latest handoff: [HANDOFF_LATEST.md](HANDOFF_LATEST.md)

**Success criteria for future claims:** on-device process with euid 0, observed effective capabilities as needed, correct SELinux security context, independently verified privileged operation and stability. No such evidence exists in this project to date. Do not describe an ordinary app-owned GPU memory operation as Root.

## 2026-11-12 action

Recorded APK-only/no-ADB constraint and reconciled earlier diagnostic evidence with the actual temporary-root request. No new Root APK was produced or tested in this round. Existing APKs remain diagnostics, and the reported smartphone stays locked.
