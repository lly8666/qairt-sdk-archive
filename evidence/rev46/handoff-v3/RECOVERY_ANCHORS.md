# REV46 handoff-v3 external recovery anchors

Use only if the local sandbox is lost. External state restoration does **not** authorize science execution until local recovery finishes and `HANDOFF_V3_VALID` is obtained.

## QAIRT 2.44 host foundation
- repository: `lly8666/qairt-sdk-archive`
- release: `20260820.1`
- asset: `qairt244-native-host-foundation-v4.tar.gz`
- bytes: `377592420`
- SHA256: `44753f03f7b2c0a21ff751258137a3673321bbd10aaa8817ebf1f00badb17b22`

## focused-v2 payload
- release: `20260820.1`
- asset: `rev46-block4-focused-payload-v2.tar.gz`
- bytes: `4176967`
- SHA256: `42493454ece1060a5100f28e5bf35a15d09bb48f8b46f82c5b69a12fd0f6a1c9`

## ORT 1.27 portable authority runtime
- workflow commit: `e636bbe153b40d4f58c40cfd66657f11220af316`
- issue: `qairt-sdk-archive#105`
- successful run: `32380173792`
- artifact: `9410680465` (ephemeral; if expired, rerun the exact workflow at the pinned commit rather than changing versions)
- required versions: Python 3.11 / numpy 1.26.4 / onnx 1.17.0 / onnxruntime 1.27.0

## Authority Vocos assets after reset
- source public release: `20260820.2`
- source APK asset id: `522156340`
- source APK SHA256: `f0041f9994413b3fac496612bd15e3da922c4b6ff3712da51d81326b717dc86c`
- staging workflow commit: `7a091c6a3e546c9e26f42fe0a3e11dc39d7cd37b`
- issue: `qairt-sdk-archive#106`
- successful run: `32429883214`
- staging artifact: `9428693945` (ephemeral)
- reconstructed rev25 warm6 MUST end at SHA256 `e2b7ab608a6b37a6dd9896589719cab446edf95287f59dfc7b5693da6ec98f6c`

## Deterministic reconstruction chain
Current local scripts are SHA-pinned in the external resume snapshot:
1. `tools/rebuild_rev46_best.py`
2. `tools/make_k8_reduce_tree_family.py`
3. `tools/rank_partial_guided_trees.py`
4. `tools/materialize_partial_guided_tree_candidates.py`

After a full reset, do not resume new science until these fingerprints reproduce:
- warm18 QNN physical input SHA256 `5b425b7e31a80d33dfb135059593549781fdccd56ff1691f1965255d888b5dea`
- contiguous K8 warm18 QNN-vs-ORT max `0.0004279613494873047` at `spec_imag[0,18,4]`
- current weight-balanced host-best full47 max `0.0004115104675292969`
- current host-best model SHA256 `a584d4c8e7a05bc36fb06b653c398547b525e15d5a996fc4d7f3dd612db5b774`
- A/B/C model SHA values exactly as published in `CANDIDATE_MANIFEST.json`

If any fingerprint or SHA cannot be reproduced, stop rather than substituting a near-equivalent model.