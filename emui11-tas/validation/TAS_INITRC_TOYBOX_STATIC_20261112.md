# TAS-AN00 11.0.0.185 — Verified init service and toybox static preflight

Date: 2026-11-12 (UTC). Evidence derived from **actual owner-supplied firmware and ELF**, not a different Kirin990 device.

## 1. Actual vendor init service: authoritative static evidence

Source: `SUPER.img` from `emui11_t` release, Android sparse -> EROFS `region_1`, extracted in passing GitHub Actions:
https://github.com/lly8666/qairt-sdk-archive/actions/runs/43186500899
Artifact: `TAS-AN00-SUPER-EROFS-system-vendor-inspection` / `TAS_INIT_RC_DUMPSTATE_FINDINGS.txt`

**Both** `region_1/etc/init/hw/init.kirin990.rc` and `init.kirin990E.rc`, lines 1238-1244, define:

```rc
# bugreport is triggered by holding down volume down, volume up and power
service bugreport /system/bin/dumpstate -d -p -B -z \
    -o /data/user_de/0/com.android.shell/files/bugreports/bugreport
    class main
    disabled
    oneshot
    keycodes 114 115 116
```

No `user` directive is present in this service block. Android init ordinarily runs a service as UID 0 in the absence of a `user` clause. **This is a configuration finding, not a device runtime observation.** Actual SELinux domain, capabilities, file accessibility, and service execution are unverified.

Vendor `region_1/ueventd.rc` explicitly has `/dev/mali0 0666 system system`, matching the user's observed `/dev/mali0` stat and 11.16 version result.

## 2. Exact TAS /system/bin/toybox ELF static compatibility

Source `system-elfs.zip`, supplied by device owner, **not committed**. File `os/system/bin/toybox`:

- Size 482,560 bytes; SHA256 `549a1750493b7c2df15798a387ec61fdbed89bb8ee6f7123a9bf91371d3e167b`
- Build ID `230b56fefa5048df13b5b128499c7087`
- ELF AArch64 ET_DYN, Android API 29, entry point `0x29000`.
- ELF executable PT_LOAD: `p_offset=0x29000`, `p_filesz=0x42970`, `p_memsz=0x42970`, `p_align=0x1000`, file-backed executable segment end `0x6b970`. Following RW PT_LOAD starts at `0x6c000`.
- At the reference's `main`-prologue candidate `0x29050`, actual TAS bytes start `ff 03 02 d1 fc 6f 02 a9 ...`. First ARM64 instruction word (little endian) is `0xd10203ff`, **exactly matching BKL reference's saved original prologue**.
- Reference points to a padding area beginning `0x6b974`. Actual TAS file bytes from `0x6b970` through `0x6bfff` are **all zero**, leaving **1,680 zero bytes** to the next page; from reference candidate `0x6b974` to next page is **1,676 bytes**. This range lies beyond the file-size portion of executable PT_LOAD, but within its last mapped page after page alignment.
- Thus **static prologue and segment-tail layout match exactly**. These bytes do NOT guarantee that a loader's zero-fill, ELF mapping, user- or privileged-process execution policy will preserve/execute code placed there. No elevated process has been observed running such a region and no system file patch was attempted in these checks.

Reference: https://github.com/BellezaEmporium/ghostlock-bkl-l09/blob/main/README.md (BKL port describes toybox launch and the selected layout, not a byte-identical signed TAS build).

## 3. bugreportz is the client — do not confuse the components

TAS `/system/bin/bugreportz` 11,632B, Build ID `d64becc0edbe4144757a73be2b322d6a`, imports `socket_local_client` and embeds a string about connecting to the `dumpstatez` service. It is a client and **not** the `/system/bin/dumpstate` service executable in the init record.

`/system/bin/dumpstate` is EACCES to ordinary app, **not absent**. Exact dumpstate ELF and live SELinux context should be recovered from an authorized ADB shell if permitted.

## 4. What has and has not been validated

| Condition | Status |
|---|---|
| Mali 11.16 driver ABI | **Real-device PASS** |
| Reference GPU memory import + soft job | **Real-device PASS** |
| App-owned 3-view page-cache canary | **Real-device PASS** |
| Vendor init `bugreport` declaration | **Verified offline** |
| TAS `toybox` prologue and blank segment tail | **Verified offline** |
| `toybox` actually executed by target privileged service | **UNVERIFIED** |
| Actual `dumpstate` process UID, SELinux domain and granted perf rights | **UNVERIFIED** |
| Privileged execution obtained via reference GPU mechanism | **UNVERIFIED** |
| KASLR leak from app | **DENIED EACCES** |
| Root on target | **NOT ACHIEVED** |

## 5. Practical next steps

- Consume one-tap app `TAS_SERVICE_CONTEXT_V1` read-only report from v1.2; capture service properties, labels, accessible socket metadata and visible processes.
- If authorized desktop ADB is available, run `emui11-tas/tools/tas_service_context_collect.py` once; it tries to retrieve exact dumpstate ELF, service states, SELinux labels and filtered process/socket views, plus optional existing shell perf probe. No root or service start.
- Use `emui11-tas/tools/tas_context_decision.py` to classify app vs shell observations, and avoid repeating ABI tests already passed.
- Keep **[HANDOFF_LATEST.md](../HANDOFF_LATEST.md)** authoritative and update on every engineering round.

