# TAS-AN00 EMUI 11.0.0.185 — dumpstate services verified from the handset (V2)

Date: 2026-11-12 (UTC). Source: owner-supplied **TAS_SERVICE_CONTEXT_V2** read-only APK v1.3 report, 2026-11-12. **No root operation or service start was performed.**

## New decisive finding: the exact system dumpstate.rc was read on the handset

Target file: `/system/etc/init/dumpstate.rc`, 799 bytes, owner root:root, mode `0644`, SELinux `u:object_r:system_file:s0`. Full relevant contents:

```rc
on boot
    # Allow bugreports access to eMMC 5.0 stats
    chown root mount /sys/kernel/debug/mmc0/mmc0:0001/ext_csd
    chmod 0440 /sys/kernel/debug/mmc0/mmc0:0001/ext_csd

service dumpstate /system/bin/dumpstate -s
    class main
    socket dumpstate stream 0660 shell log
    disabled
    oneshot

service dumpstatez /system/bin/dumpstate -S -d -z \
    -o /data/user_de/0/com.android.shell/files/bugreports/bugreport
    socket dumpstate stream 0660 shell log
    class main
    disabled
    oneshot

service bugreportd /system/bin/dumpstate -w
    class main
    disabled
    oneshot
```

The user's `V2` report used `|` as escaped newline separators; the above only restores layout, no new directives or values.

These are **three Android init service names that execute ONE binary `/system/bin/dumpstate` in different modes**:
1. `dumpstate` `-s` for socket-mode.
2. `dumpstatez` `-S -d -z` for a zipped report and socket notification.
3. `bugreportd` `-w` for the Binder service listener mode.

Additionally, actual `vendor/etc/init/hw/init.kirin990.rc` and `init.kirin990E.rc` both declare `service bugreport /system/bin/dumpstate -d -p -B -z ...` (see [TAS_INITRC_TOYBOX_STATIC_20261112.md](TAS_INITRC_TOYBOX_STATIC_20261112.md)).

All four declared init services have `disabled` and `oneshot`. **No `user` directive in the quoted blocks.** In Android 10 init's documented semantics, default user is root; `disabled` means a named start is required instead of a class automatic start, and `oneshot` means no automatic restart. The **init-service UID default is not evidence of an observed live process, SELinux domain or actual task capabilities**, nor does it prove the ability to change `perf_event_paranoid`.

`socket dumpstate stream 0660 shell log` configures the Unix socket's **owner shell, group log, mode 0660** when that service starts, **not** the process UID. The `dumpstate` socket did not exist at the time of this read-only V2 scan; that is consistent with an idle `disabled/oneshot` service, not evidence that the executable does not exist.

The user-run application is still `u:r:untrusted_app_27:s0:c512,c768` UID 10161, Android user build, bootloader locked/AVB green, `ro.debuggable=0`, `ro.secure=1`. Its `lstat("/system/bin/dumpstate")` returns EACCES. It can read `dumpstate.rc`, but it cannot establish the executable's actual process label from this APK.

## Important Binder distinction

In the same V2 report:
- `service list` shows `bugreport: []` and `incidentcompanion: []`.
- `service check bugreport` reports `Service bugreport: not found` and `service check dumpstate`, `dumpstatez`, `incident` also report not found.
- This apparent inconsistency is not proof of any init service's runtime state, failure or UID; `service list` and `service check` are separate IPC operations and can differ by permissions/visibility and time.
- `init.svc.dumpstate`, `init.svc.dumpstatez`, `init.svc.bugreportd`, `init.svc.bugreport` are all empty strings in the app. Do not misinterpret an empty/inaccessible property as `stopped`.
- `pidof dumpstate[z]` exited 1, and `ps -AZ` returned only the app and its child; app process visibility is restricted.
- **No currently running elevated `dumpstate` process was observed.**

## Vendor SELinux static cross-check from exact owner-supplied system-elfs.zip

`vendor_sepolicy.cil` SHA256 `48edac67678f02e7b953afa8582862a3d53ee3dfa0ac8bdf3409dfc058dc5431` (same as device read and extracted `SUPER.img`).

- `dumpstate_29_0` appears in vendor-side type attribute and allow rules.
- In this file alone, 27 explicit `(allow dumpstate_29_0 ...)` rules reference modem files, block/sysfs and debugfs access, etc. There is **no direct `(allow dumpstate_29_0 proc_perf ...)`** in the vendor-only text; that cannot establish denial in the complete compiled platform+vendor SELinux policy.
- The vendor `file_contexts` marks `android.hardware.dumpstate@1.0-service` under `hal_dumpstate_default_exec`, which is a different **HAL dumpstate** service; do not conflate it with `/system/bin/dumpstate`.
- The actual platform policy and `/system/bin/dumpstate` security label remain unreadable to the untrusted APK. No root or perf bypass may be inferred from these vendor-only findings.

## What to do next (no duplicate handset probing)

1. **Do not re-run the six Mali 11.16 compatibility tests, the app-owned cache canary, v1.2 context survey, or v1.3 init config survey. All their evidence is conclusive for their limited scopes.**
2. The existing cross-platform read-only ADB collector `emui11-tas/tools/tas_service_context_collect.py` is the next highest-value single action *if ADB shell is authorized*. It reads metadata, `getenforce`, the exact init service config, proc perf sysctl and tries `adb pull /system/bin/dumpstate` (recording EACCES if denied). The optional existing read-only perf probe can compare shell and app contexts without triggering GhostLock.
3. Distinguish three separate questions: (i) whether ADB shell can *read* `dumpstate` binary and its ELF Build ID, (ii) the *actual process* SELinux/UID/capability state if normally triggered, and (iii) whether the relevant perf operations are permitted. None is answered by merely parsing `init.rc`.
4. Future source comparison should use the real TAS `toybox` ELF Build ID and its already-verified static layout. **No privileged code execution or Root has been achieved.**
5. Record the next measured outcome in `emui11-tas/HANDOFF_LATEST.md` and link the new source/CI as appropriate. Do not publish proprietary raw ELF bytes in a public GitHub repo.

## Sources

- Android 10 init README (default root when `user` omitted, `socket` signature, `disabled` and `oneshot` semantics):
  https://android.googlesource.com/platform/system/core/+/refs/heads/android10-release/init/README.md
- TAS exact vendor service evidence:
  [TAS_INITRC_TOYBOX_STATIC_20261112.md](TAS_INITRC_TOYBOX_STATIC_20261112.md)
- TAS earlier owner-supplied device V1 and GPU checks:
  [TAS_SERVICE_CONTEXT_V1_20261112.md](TAS_SERVICE_CONTEXT_V1_20261112.md), [TAS_DEVICE_MALI_V2_ELF_20261112.md](TAS_DEVICE_MALI_V2_ELF_20261112.md)
