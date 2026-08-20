# REV46 host-only live snapshot — phase_kgroup_v2

Date: 2026-08-21 (project timezone Asia/Tokyo)
QAIRT/QNN: 2.44.0 / 2.44.0.260225
ORT semantic oracle: 1.27.0
No APK/device test performed; device gate remains blocked.

## Frozen gate
- max_abs <= 3e-4
- mean_abs <= 1e-5
- rmse <= 2e-5
- cosine >= 0.99999

## Current-best before this matrix
- model: block4 decanonicalized + block5 monomial-Horner + block6 hi->lo + block7 lo->hi
- warm18 QNN-vs-ORT max_abs: 0.000499725341796875
- peak: spec_imag[0,18,4]

## phase_kgroup_v2 candidates
Mathematically equivalent phase FC K=320 partition/reduction variants on current-best:
- contig8
- contig16
- rr4
- rr8
- rr16

All five pass ORT1.27 semantic gate versus decanonicalized reference.

QNN2.44 block18 results, sorted best to worst:
- contig8: max_abs 0.0005104541778564453; peak spec_imag[0,18,4]; worse than current-best by 2.1469%.
- contig16: max_abs 0.0005118846893310547; peak spec_imag[0,18,4]; worse by 2.4332%.
- rr4: max_abs 0.0005130767822265625; peak spec_imag[0,18,4]; worse by 2.6718%.
- rr8: max_abs 0.0005133152008056641; peak spec_imag[0,18,4]; worse by 2.7195%.
- rr16: max_abs 0.0005145072937011719; peak spec_imag[0,18,4]; worse by 2.9580%.

Conclusion: deeper fixed contiguous/round-robin partial-dot partitioning with pairwise reduction does not reduce the dominant phase bias. Close this branch; do not promote to full47.

## Candidate hashes
7242b1c5ec803e1a4173b56debe5decd3baeb86593e7abe5efa8a5988cad3aef  contig16.onnx

a4e035638e16056fb9cec808933f3012dc9f46dc39feaeda75bceaa44a8214b1  contig8.onnx

3fbdf0413728bb3e56d98f4e54f8b13f8209eebd5cb222294b290c10c0e03501  rr16.onnx

5cb8d63b3dfba9218ef685ced7dcc2fdac10e93cd2ef5203a33cab46b6cf7bc6  rr4.onnx

15427f5a9ef6d6670eb2ca0995d40216de65fd2dd9a72008c30bd303ed749910  rr8.onnx

ce29d8d6c8ae6fefbc30034693f24a2e9cb854f9e1323cf214994ee1c4e096df  MANIFEST.json

## Evidence/result hashes
837b81559c9a82280f51eb6ce5bc932cce9e213fab2d47375a27648cedb15165  ORT_SEMANTIC_BLOCK18.json

824fc0950fbb73c66d6d53ba427e15b7be5bd9135e2c52b9cb566fc08eb02fc3  BLOCK18_QNN_RANK.json

689c80045e1e3f597a288fcef5b7be929fac68be1b4340580340af6a0a7a03dd  run_semantic.py

c0e30ef6c650b688720c23c0cd6471ea01311f938c3b8159cd6e7ee4f292c945  run_qnn_block18.sh

b10e8a5066f64c2b2fecdb4f36cc8cbec31115f3f9cdf0af103088dc2c2e5aaa  score_block18.py
