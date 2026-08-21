# REV46 repository authority map

## Primary / production authority
**Main repository: `lly8666/SimAdmin-Android`**

This is the MeanVC2 Android project authority. It owns the Android app and `MeanVc2QnnLab` integration, Java/native runtime, manifests, QNN provider/no-CPU-fallback policy, platform/device/partition probes, APK build/integration, target-phone evidence, product-side fixture/model contracts and long-lived project checkpoints.

Do **not** treat `qairt-sdk-archive` as the production app repository.

## Supporting host/evidence/recovery workspace
**Repository: `lly8666/qairt-sdk-archive`**

This repository supports the main project with QAIRT/QNN SDK archival, ORT/QAIRT host foundations, reproducible host experiments, public/reusable rev46 numerical evidence, handoff QA reports and disaster-recovery metadata. It does not supersede `SimAdmin-Android` for Android production integration or device policy.

## Local science workspace
`/mnt/data/rev46_sandbox` is the current ephemeral host-only science workspace. Its important state must remain reproducible from SHA-pinned assets/scripts and GitHub checkpoints.

## Authority precedence
1. Production/product/device policy: `lly8666/SimAdmin-Android`.
2. Current host numerical NOW pointer while the sandbox exists: `/mnt/data/rev46_sandbox/handoff_v2/CURRENT_STATE.json`.
3. Host SDK/evidence/recovery: `lly8666/qairt-sdk-archive`.
4. Legacy bootstrap/handoff documents are historical unless explicitly referenced by current handoff v2.