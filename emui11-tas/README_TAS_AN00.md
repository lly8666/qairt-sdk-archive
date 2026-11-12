# TAS-AN00 / HWTAS EMUI 11.0.0.185

## Current device identity
The actual Huawei Mate 30 uses `ro.product.model=TAS-AN00`, `ro.product.device=HWTAS`, and `ro.product.board=TAS`.
The initial Android v1.1 diagnostic misclassified the device because it recognized only `TAS-AL00`/`TAS-TL00` and assumed the device codename started with `TAS`.

This has been corrected in the `emui11-tas/android-diag/` v1.2 Android 10 app. Match also checks:
- ARM64, Linux `4.14.116`, Android 10/API 29
- `11.0.0.185` firmware/build identifiers
- Huawei TAS-AN00 fingerprint family and cross-field consistency
- kernel compilation timestamp `Wed Jul 21 19:39:33 CST 2021`

A matching result means **identity consistency only**, never a declaration of root or runtime kernel hash identity.

## Static kernel evidence (release emui11_t)
Firmware SHA256: `fb4cec6aa905416ede031cca602783bc1e59fdd89ee96ba1aaa54dbdaf351b0f`.
BOOT ARM64 Image SHA256: `d4b6f00aff4a4e05a3d5d794552165b0c950913aa841b356cae9bc69ae8ea2e5`.
Read-only disassembly of `remove_waiter` is consistent with the unpatched CVE-2026-43499 `current` / `waiter::task` issue.
No live exploitation, UID 0, KernelSU or persistent root has been proven on TAS-AN00.

Original reference: https://github.com/BellezaEmporium/ghostlock-bkl-l09
Kernel CVE advisory: https://lists.openwall.net/linux-cve-announce/2026/05/21/7

## APK v1.2, confirmed CI
GitHub Actions build: https://github.com/lly8666/qairt-sdk-archive/actions/runs/43164590853
Artifact: `TAS-AN00-EMUI11-Diagnostic-v1_2`
APK: `TAS_AN00_EMUI11_Diagnostic_v1_2-debug.apk`
Package: `io.github.tasaudit.diag.tasan00`; min/target SDK 29.
APK SHA256: `86645babe8366b88475416fa51a00ade1908251ee2678959fb66de3840ee2e11`.
The APK has no declared permissions or automatic upload and does not execute an exploit. Its separate package ID lets it coexist with v1.1 without debug-key signature conflicts.

## Research boundaries
- Runtime KASLR, CFI/LTO, Huawei HKIP/HHEE, SECcomp and SELinux constraints remain unresolved.
- Static symbols must not be copied from MRX-W09 to TAS.
- Bootloader is reported locked with verified boot state green; no boot/system partition modification was performed.
- Avoid running unverified kernel-memory write experiments, guessing offsets or flashing patched boot images.

The actual user log was processed locally for regression testing, **not committed to this public repo**.
