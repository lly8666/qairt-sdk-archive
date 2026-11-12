# MRX-W09 11.0.0.235 → TAS-AN00 11.0.0.185: evidence-led two-CVE and system-image gap audit

**Date:** 2026-11-12. This round followed owner's explicit instruction to continue the **successful MRX Kirin990/Linux4.14.116 case** using their existing TAS firmware and Windows ADB results. **Offline/read-only study only: no code injection, kernel memory corruption, privileged context takeover or credential change was attempted. Root remains NOT_OBSERVED on TAS.**

## The previously under-appreciated *two distinct defects*

The actual published MRX primary record is the [pinned `docs/FACTS.md`](https://github.com/BellezaEmporium/ghostlock-bkl-l09/blob/381476444fbbbcf0c5e8e3c2e2166647e9134ab5/docs/FACTS.md):

- **MRX prerequisite (separate from GhostLock):** [lines 997–1009](https://github.com/BellezaEmporium/ghostlock-bkl-l09/blob/381476444fbbbcf0c5e8e3c2e2166647e9134ab5/docs/FACTS.md#L997-L1009) describe a **Mali GPU page-cache interaction affecting `/system/lib64/libc.so`** rather than a kernel-text patch. [Lines 1903–1906](https://github.com/BellezaEmporium/ghostlock-bkl-l09/blob/381476444fbbbcf0c5e8e3c2e2166647e9134ab5/docs/FACTS.md#L1903-L1906) specifically call the GPU stage **CVE-2021-44828** and report read-only shared-memory effects on the MRX phone, followed by privileged process observations. These claims are *MRX research records*, not TAS validation.
- **Later GhostLock/futex stage:** [lines 24–31](https://github.com/BellezaEmporium/ghostlock-bkl-l09/blob/381476444fbbbcf0c5e8e3c2e2166647e9134ab5/docs/FACTS.md#L24-L31) attribute kernel address observations to perf sampling *after* the previous stage. [Lines 3905–3920](https://github.com/BellezaEmporium/ghostlock-bkl-l09/blob/381476444fbbbcf0c5e8e3c2e2166647e9134ab5/docs/FACTS.md#L3905-L3920) report completed UID0 on **MRX**, not on TAS.
- This distinction explains why **four EACCES perf opens before any privileged interaction on both TAS APK and ADB shell are insufficient to disprove the MRX research result**. They do decisively establish that *merely changing to ADB shell* does not grant the desired kernel perf sampling right in the TAS baseline.

**Independent public vulnerability record:** [CVE-2021-44828](https://nvd.nist.gov/vuln/detail/CVE-2021-44828) concerns Arm Mali drivers; the reported affected Bifrost range includes **r0p0–r34p0**, and the failure mode allows nonprivileged access to otherwise read-only memory. TAS source was earlier identified as **Bifrost r18p0 family**, inside the *public version range*. That is a **version-exposure indicator only**: we have **not** examined all Huawei backports, proved this exact vendor build lacks a fix, or reproduced CVE-2021-44828 against protected memory on TAS. The successful app-owned-file cache canary is not a substitute.

## Additional original kernel binary confirmation (same round)

The exact **decompressed BOOT kernel Image** from the owner's `emui11_t` release was independently SHA256-checked as:

`d4b6f00aff4a4e05a3d5d794552165b0c950913aa841b356cae9bc69ae8ea2e5`

A read-only bytes/strings scan of this exact **52,439,052B** kernel found **each of the following once**:
- Embedded module/version line `K:r18p0-01bet0(GPL)`.
- Embedded driver ABI line `r18p0-01bet0 (UK version ((__u16)11).((__u16)16))`.
- Compiled source location `bifrost-r18p0-01rel0/mali_kbase_mem.c`.

**Improved confidence:** r18p0 is now **confirmed from the actual shipped BOOT kernel binary** — not simply inferred from an accompanying source-tree directory or `/dev/mali0` ABI. These embedded strings corroborate the phone's runtime UK ABI 11.16 observation and the public affected-family range for CVE-2021-44828.

**Strict limit:** An embedded module version string does not prove the entire GPU driver is *unpatched*. The Huawei vendor could have selectively backported a fix without changing the version string. The actual protected-memory weakness is **NOT VERIFIED on TAS**.

The updated offline audit script now optionally accepts `--kernel-image` and requires the kernel's exact SHA256 plus all three embedded strings, before it can label `BIFROST_R18P0_DIRECT_KERNEL_STRINGS_CONFIRMED`. The real pinned kernel was audited successfully along with both original ZIPs; there was **no on-device operation**.

## New pinned-file comparison of the actual data available

The owner already supplied `system-elfs.zip` SHA256 **`1e92d7a89d33063b4040beb25b774472c81c821ef12aaa59990eb9ff6ded19e0`**; its actual TAS Bionic libc bytes are from:

`os/apex/com.android.runtime/lib64/bionic/libc.so` — SHA256 **`ecdaf9a20bafd6659649d755023c34137a2788d6fdedb543c10dd20ad2b77ecd`**, previously confirmed by direct shell `sha256sum`. The `/system/lib64/libc.so` path on TAS is a symlink to the APEX runtime. The MRX **`/system/lib64/libc.so`** description and TAS APEX underlying binary are NOT proof of matching build ID, loader mappings, executable code or shared page cache identity. This is an **important compatibility gate**, not evidence of an effective protected-memory modification.

Also verified: `os/system/bin/bugreportz` SHA256 **`b85051d0eb7717ed2509c76440f48ec16608b83af3e79efb29d7662f40aee47d`**, a socket client. Being a client does **not** categorically contradict the MRX record's separate `dumpstate` shared-library execution hypothesis.

## New reason the prior firmware scan could not obtain `/system/bin/dumpstate`

We independently re-parsed `SPARSE_LAYOUT.json` from the owner's previously successful `SUPER.img` EROFS audit artifact (the pinned report archive SHA256 is **`b2ff32a3d1ff8c7185122f8d0afafc9c5934feed8bf58302c2d30041bb845579`**).

- `SUPER.img` file size **1,435,996,536 bytes**, but its declared logical image is **7,121,928,192 bytes**.
- The **FIRST 5,093,982,208 logical bytes are explicitly `DONTCARE`** in its Android sparse layout — not an extractable representation of full `/system`.
- The three previously extracted EROFS regions are useful (vendor, build props and service init files), but the artifact's eight target inventory entries do **not** include the needed `/system/bin/dumpstate` ELF.
- Thus the prior offline absence of `dumpstate` is a **source coverage limitation**, not evidence the phone lacks the service executable. On the actual handset, both app and now ADB shell received EACCES for `/system/bin/dumpstate`; EACCES is not ENOENT. Our earlier init declarations remain real.

The separate user's `UPDATE.APP.zip` (49 pre-extracted partitions) also lacks a normal `SYSTEM.img`. **Repeatedly examining the same two incomplete images cannot recover missing system bytes**.

## Actual TAS Windows ADB outcomes that remain true

[Real-device two-ZIP findings](TAS_WINDOWS_ADB_SHELL_REAL_DEVICE_RESULTS_20261112.md):
- shell UID 2000 `u:r:shell:s0`, CapEff0, SELinux enforcing; Android10 API29, EMUI11.0.0.185, kernel4.14.116;
- all FOUR original app and all FOUR shell Perf calls **EACCES**, paranoid3;
- `service check bugreport` is found in shell but invisible to app; neither observation proves a privileged `dumpstate` process;
- runtime `dumpstate` ELF unreadable under both tested contexts.

## Corrected research gates and next useful decision

| Stage | Current TAS status | What is *not* implied |
|---|---|---|
| Identical SoC and kernel version string | SAME FAMILY | Not byte-identical system/kernel code |
| GhostLock `remove_waiter` | Pinned old static analyzer: CONSISTENT_WITH_UNPATCHED | Not runtime exploitation |
| GPU ioctls/import/job submit | Six cases real-device PASS | **Not CVE-2021-44828 confirmed on protected pages** |
| Bifrost driver revision | r18p0 reference family, **in public affected range** | Not proof vendor backport lacks fix |
| MRX vs TAS libc path | MRX `/system/lib64/libc.so` vs TAS underlying APEX libc, exact TAS hash pinned | Not matching loader/page-cache mapping |
| `dumpstate` full system executable | Not in supplied partial `SUPER.img`; app and shell EACCES | Not absent on device |
| App + ADB shell Perf | EACCES in both | Not evidence of a hypothetical later privileged-context outcome |
| TAS high-privilege action or root | NOT OBSERVED | MRX success cannot be copied as a claim |

**New highest-priority research question:** whether the exact *TAS* Mali kernel driver/patch state and actual protected-library execution context match the **MRX prerequisite**, which is a **separate question from** GhostLock `remove_waiter` being unpatched. Pure API compatibility is already established; rerunning it will not resolve this. Future work may use read-only driver change history and safely obtained OS build metadata; don't request the owner to rerun completed 33+13 ADB batches.

An *end-to-end* confirmation of the MRX exploit chain (even if stopping short of final UID0 activation) would require actual high-privilege/kernel exploit operation; **no such executable chain was developed or delivered**.

**Reproduction artifact:** [`tools/tas_mrx235_to_tas185_static_gate.py`](../tools/tas_mrx235_to_tas185_static_gate.py) accepts only the already provided, SHA256-pinned OS ELF and EROFS report ZIPs. The script outputs scope-conscious JSON with no device interaction or executable payload.
