# TAS-AN00 / EMUI 11.0.0.185 vs. published MRX/BKL — evidence-led compatibility audit

> **2026-11-12 deeper source correction:** This report's binary/client finding remains true, but earlier reasoning incorrectly promoted it to a *categorical MRX prestage blocker*. MRX's detailed `FACTS.md` describes a **dumpstate libc-page-cache stage** involving a `bugreportz` trigger, while BKL's top-level README simplifies the MRX service role. A TAS `bugreportz` socket client does **not alone** exclude the separate shared-library hypothesis. Likewise, ordinary-app `perf_event_open EACCES` only establishes an **untrusted-app pre-stage baseline**; post-privileged-stage Perf has **not been measured**. See [new primary-source re-audit](validation/TAS_MRX_PRESTAGE_ASSUMPTION_REAUDIT_20261112.md). This does NOT prove a TAS exploit is possible, and Android shell-based MRX starting privileges differ from the owner's APK-only requirement.


Updated: 2026-11-12. This document replaces the **stale** first-pass claims that `Mali 11.16`, `MEM_IMPORT`, and actual system ELF identities were unknown. Subsequent device logs proved those capabilities.

**Target:** user-owned Huawei Mate 30 `TAS-AN00`, Kirin990, Android10, EMUI `11.0.0.185(C00E180R7P11)`, Linux4.14.116; bootloader locked/verified boot green. Owner requires installable APK-only workflow, no PC/ADB. Temporary Root **not achieved**.

## Reproducibility and reference provenance

- [Public BKL port](https://github.com/BellezaEmporium/ghostlock-bkl-l09) is **Honor View10 BKL-L09 / Kirin970 / EMUI10**, not TAS. README includes an ambiguous `alpha-1 working and verified / root to be achieved` statement; do not infer a completed TAS root.
- [MRX research mirrored under BKL](https://github.com/BellezaEmporium/ghostlock-bkl-l09/blob/main/docs/FACTS.md) targets **MRX-W09 / Kirin990 / EMUI11.0.0.235**. This is closer technologically to TAS but has a different build and verified binary identities.
- Original MRX GitHub `0ch4/ghostlock-mrx-w09` is currently inaccessible via the connected GitHub API (404 as checked 2026-11-12). A BKL mirror's description of MRX is not the same as an exact original-tree snapshot.
- **No code offsets, addresses, or root outcomes from those different builds should be adopted as measured TAS behavior without independent verification.**

## Exact device and firmware findings (supersede stale notes)

| Question | TAS evidence | Scope |
|---|---|---|
| OTA/kernel | OTA SHA256 `fb4cec6aa905416ede031cca602783bc1e59fdd89ee96ba1aaa54dbdaf351b0f`; kernel Image SHA256 `d4b6f00aff4a4e05a3d5d794552165b0c950913aa841b356cae9bc69ae8ea2e5` | Offline firmware identity |
| Relevant kernel functions | Source paths include Mali Bifrost r18p0; `kbase_ioctl`, `kbase_mem_import`, `rt_mutex_adjust_prio_chain`; `CONFIG_PERF_EVENTS`, `CONFIG_FUTEX_PI`, `CONFIG_CFI_CLANG`, `CONFIG_HISI_HHEE` | Symbol/config presence, not a working kernel exploit |
| Vendor library | Actual `/vendor/lib64/egl/libGLES_mali.so` SHA256 `bddbb8bd643ab9fa3389ee2b368a3f1b299fdb5f41aa76a07bf60d4d23cf61c9`, exact match to parsed owner's `SUPER.img` | Vendor artifact matches handset |
| Mali API version | App `/dev/mali0` `VERSION_CHECK` **11.16 PASS** | Actual handset |
| Memory operations | v1.1 `SET_FLAGS`, tracking `mmap`, `MEM_ALLOC`, `MEM_IMPORT`, CPU map, `JOB_SUBMIT`: **all six subcases exit 0** | Actual handset, app context |
| Page cache effect | App **owns the disposable test file**; same-fd, second-fd, independent map all see expected changed bytes | Not a protected system binary or privilege escalation |
| `toybox` ELF | Real SHA256 `549a1750493b7c2df15798a387ec61fdbed89bb8ee6f7123a9bf91371d3e167b`, BuildID `230b56fefa5048df13b5b128499c7087`; static prologue/layout matches BKL candidate | Exact offline layout, **not** executable-hook proof |
| `bugreportz` | Exact 11,632-byte TAS binary is a **dumpstatez socket client**, not the privileged service | Exact ELF imports/strings |
| Privileged service configuration | Real TAS `/system/etc/init/dumpstate.rc` 799B read on device; `dumpstate`, `dumpstatez`, `bugreportd` invoke `/system/bin/dumpstate`; Vendor `bugreport` uses same binary | Init declaration, not observed privileged process |
| Platform SELinux and dumpstate ELF | App `lstat(/system/bin/dumpstate)` EACCES; merged SELinux policy not obtained | Current untrusted-app visibility boundary |
| Perf kernel address leak | App UID and SELinux `untrusted_app_27`, `perf_event_paranoid=3`, earlier `perf_event_open` EACCES; root attempt stopped at `KASLR leak failed` | **Blocked in app context** |
| Temporary Root | **NOT OBSERVED** | No UID0/capability/SELinux/privileged operation proof |

## Scope and next-agent control

**Root-first, APK-only** is the owner's goal; privacy app cleanup is deferred. The verified six-case Mali test, original OS ELF ZIP, and V2 init service scan already exist; do not request repetition, an ADB cable, or desktop shell. Any future evidence must distinguish actual execution privileges from the existence of an init service declaration or static file offsets.

Source-of-truth: [HANDOFF_LATEST.md](HANDOFF_LATEST.md), [published reference matrix](validation/TAS_PUBLIC_REFERENCE_REPRODUCTION_MATRIX_20261112.md), [Mali and ELF checks](validation/TAS_DEVICE_MALI_V2_ELF_20261112.md), [service definitions](validation/TAS_SERVICE_CONTEXT_V2_DUMPSTATE_RC_20261112.md).

**Important:** This is a compatibility evidence audit. No untrusted-app-to-elevated transition, working kernel write primitive, credential change or Root APK has been produced or verified. The next engineer must not report success based on firmware symbol presence or the app-owned memory experiment.
