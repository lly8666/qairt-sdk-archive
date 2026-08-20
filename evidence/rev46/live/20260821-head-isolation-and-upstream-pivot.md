# REV46 host-only live snapshot — head isolation and upstream pivot

Date: 2026-08-21 (project timezone Asia/Tokyo)
QAIRT/QNN: 2.44.0 / 2.44.0.260225
ORT oracle: 1.27.0
No APK/device test performed; device gate remains blocked.

## Current-best
- Model: block4 decanonicalized + block5 monomial-Horner + block6 hi->lo + block7 lo->hi
- SHA256: a0a64c3af5e2acfa2e4f872642352efcebbb82858af82bbc7982a94d3ffaced7
- warm18 QNN-vs-ORT max_abs: 0.000499725341796875
- peak: spec_imag[0,18,4]

## Closed branches since previous snapshot
- phase_kgroup_v2 deeper K partitions: all worse, best 0.0005104541778564453.
- explicit phase pairwise tree: 0.0005133152008056641.
- final LayerNorm affine folds: best 0.0005083084106445312.
- bin18 Kahan compensated sum: 0.0005145072937011719. all-phase Kahan intentionally not compiled after diagnostic failure.

## Head isolation result
Extracted a 24-node head-only graph from the current-best model.
- head-only SHA256: 9cb1b175b2ea9c370cd86c904ad6a8e158b2a7b20facd58ec27af13aa56ec0a4
- ORT(head, QNN-LayerNorm-output) versus ORT(head, ORT-LayerNorm-output): max_abs 0.000499725341796875 at spec_imag[0,18,4]. This alone reproduces the dominant current-best final error.
- Head-only QNN physical input layout is [1,320,6], while logical ONNX input is [1,6,320]. An initial ~100-error run with logical raw layout is INVALID and excluded.
- With physical layout corrected per execution_metadata:
  - QNN-head vs ORT-head on ORT-LN input: max_abs 3.62396240234375e-05.
  - QNN-head vs ORT-head on QNN-LN input: max_abs 2.765655517578125e-05.
  - Combined QNN-head(QNN-LN) vs ORT-head(ORT-LN): max_abs 0.0005002021789550781 at spec_imag[0,18,4].

Conclusion: final head backend is already numerically clean relative to its input. Dominant error is upstream and is propagated/amplified by the mathematically correct head. Stop final-head rewrites.

## Upstream pivot
Current-best tap evidence:
- block7 activation /Mul_22 max_abs: 0.00010716915130615234
- block7 PW2+bias /Add_30 max_abs: 0.0003223419189453125
- block7 residual /Add_31 max_abs: 0.0003223419189453125

Next host-only experiment: block7 PW2 accumulation/topology matrix on current-best. No APK/device work before host gates pass.
