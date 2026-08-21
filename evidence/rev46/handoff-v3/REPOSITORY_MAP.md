# REV46 repository authority map

## Primary / main repository
**`lly8666/SimAdmin-Android` is the MeanVC2 Android main project and production authority.**

It owns the Android app and `MeanVc2QnnLab`, Java/native runtime, manifests/native-library declarations, QNN provider policy, strict CPU-fallback disablement, platform/device/partition probes, product-side model/fixture contracts, APK construction, target-phone evidence, integration and release decisions.

Any eventual model/runtime integration, APK authorization, target-device qualification or production decision must return to this repository.

## Supporting repository
`lly8666/qairt-sdk-archive` is the QAIRT/ORT host-science, evidence, recovery and handoff-QA repository. It stores toolchain foundations, reproducible host experiments, numerical evidence and disaster-recovery metadata. It is **not** the Android production authority.

## Ephemeral local host state
`/mnt/data/rev46_sandbox` is disposable host-science state. When a matching handoff-v3 local sandbox exists and validates, its `CURRENT_STATE.json` is the execution-time host-science NOW pointer. It never supersedes the main repository for Android/device/product authority.

## Authority order
- project/product/device authority: `lly8666/SimAdmin-Android`
- host evidence/recovery authority: `lly8666/qairt-sdk-archive`
- execution-time local host state: SHA-verified handoff-v3 sandbox only
- legacy `CURRENT_AGENT_BOOTSTRAP.md`, `HANDOFF_NEXT_AGENT.md`, and old append-only handoffs: historical context only unless handoff-v3 explicitly cites them

If the local sandbox is absent, the support repository's `evidence/rev46/handoff-v3/EXTERNAL_RESUME_SNAPSHOT.json` is the exact fallback **state-restoration** authority. It does not itself authorize science execution; local artifacts/environment must be rebuilt and the v3 validator must pass first.