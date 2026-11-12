# TAS-AN00: 2026-11-12 service context V1 real-device observations

Status: **read-only device log analyzed; no root, no privileged service transition observed**. This is the precise meaning of the checks, not a successful exploit.

## Device / security baseline

- Model `TAS-AN00`, `kirin990`, `TAS-AN00 11.0.0.185(C00E180R7P11)`, Android API 29.
- `ro.build.type=user`, `ro.debuggable=0`, `ro.secure=1`, AVB=`green`, bootloader=`locked`.
- Observed run context `u:r:untrusted_app_27:s0:c512,c768`, UID 10155; the app never transitioned privileges.
- `init.svc.adbd=running`, but other queried `init.svc.dumpstate[...]` / `init.svc.bugreport[...]` keys return **empty strings**. This is *not proof of service absence or shutdown*; property visibility and no-start/idle behavior are unresolved.
- `getenforce` had been blocked for the app in the preceding V1 inventory, so do not assume the app directly verified enforcing/permissive in V1.

## Files / SELinux labeling

- `/system/bin/bugreportz`: 11632B, `u:object_r:system_file:s0`, readable; actual ELF identified as a dumpstatez socket client in earlier analysis.
- `/system/bin/dumpstate`: `lstat EACCES`, **not confirmed absent**.
- `/system/bin/dumpstatez`: ENOENT as a separate executable; AOSP and this vendor's init service may use `dumpstate` for multiple service names.
- `/system/bin/toybox`: 482560B, `u:object_r:toolbox_exec:s0` and previously verified ELF Build ID.
- `/system/lib64/libc.so`: symlink to APEX real libc, `system_lib_file:s0`.
- `/dev/mali0`: mode 0666, UID/GID 1000, `u:object_r:gpu_device:s0`; Mali 11.16 reference memory API and app-owned file canary already independently confirmed.
- **Key new directly accessible file**: `/system/etc/init/dumpstate.rc`: 799B, readable, `u:object_r:system_file:s0`. The v1.2 test read **metadata only**, not its content.
- `/system/etc/selinux/plat_sepolicy.cil`, `/proc/net/unix`: EACCES from app. `/proc/1/attr/current`: ENOENT in app view; does not prove PID 1 absent.

## Service and process reports

- Binder `service list` includes `bugreport: []` (also `incidentcompanion: []`).
- Binder `service check dumpstate`, `dumpstatez`, and `incident` return not found. **Binder service registry names are distinct from Android init service names and socket service names**. The presence of `bugreport` Binder entry does not prove `/system/bin/dumpstate` running as root.
- `pidof dumpstate` / `pidof dumpstatez` exited 1 and `ps -AZ` showed only the untrusted app + its child. App process visibility is SELinux/proc restricted; these results cannot exclude processes hidden from app.
- `/dev/socket/dumpstate{,z,...}` paths ENOENT at this moment. Init `disabled`/`oneshot` services can have no socket until explicitly started by authorized system trigger; no service start attempted in this probe.

## Cross-evidence from exact firmware

The exact user-supplied `SUPER.img` already contains `region_1/etc/init/hw/init.kirin990.rc` and `init.kirin990E.rc`, both declaring the `bugreport` init service `/system/bin/dumpstate -d -p -B -z` with `disabled`, `oneshot`, and keycodes. See [TAS_INITRC_TOYBOX_STATIC_20261112.md](TAS_INITRC_TOYBOX_STATIC_20261112.md).

Official AOSP init documentation (Android 10) says a service without `user` defaults to root **before further SELinux-domain and process-capability restrictions**. This is a description of the service declaration, not a claim of an observed UID-0 process on TAS.

## Next engineering stage: now implemented as read-only v1.3

The previous v1.2 app enumerated the file metadata but did not read the existing 799-byte init config. The next APK version `v1.3` now reads:
- **Exact contents** of `/system/etc/init/dumpstate.rc`, a known readable 799-byte file (full content in the `[init_rc_content]` section).
- Fixed optional related system init rc files and only relevant vendor init rc lines (if accessible).
- Binder `service check bugreport` in addition to existing manager and process diagnostics.
- No service launch, no arbitrary shell command from user input, no root request, no kernel memory modification.

Parallel cross-platform ADB reader: `emui11-tas/tools/tas_service_context_collect.py` now also reads `dumpstate.rc` and its SHA256 and checks `bugreport` Binder service. It can optionally pull `/system/bin/dumpstate` if the caller's shell domain allows it; EACCES is recorded as a blocked read.

**Expected operator input:** the `[init_rc_content]` section from `TAS_SERVICE_CONTEXT_V2`, or one ADB context ZIP. Earlier GPU compatibility, ELF files and V1 context logs do **not** need repeating.

## Status ledger

| Statement | Evidential status |
|---|---|
| Mali 11.16 ABI and app-owned cache experiment | Device-confirmed PASS |
| `bugreportz` is socket client | Actual ELF confirmed |
| `bugreport` Binder name exists | Device-confirmed |
| Vendor init defines `bugreport` service using `dumpstate` | Actual firmware confirmed |
| System `dumpstate.rc` is readable (799B) | Device-confirmed |
| Contents of TAS's `dumpstate.rc` | **Pending v1.3 read** |
| Actual `dumpstate` UID / SELinux context at runtime | **NOT measured** |
| Kernel KASLR leak from app | **EACCES in prior tests** |
| Root obtained | **NO** |
