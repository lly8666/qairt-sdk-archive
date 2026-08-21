# REV46 live checkpoint — ensemble validation closed

Date: 2026-08-21 (Asia/Tokyo)
QAIRT/QNN: 2.44.0 / 2.44.0.260225
Device/APK gate: BLOCKED.

Only the preregistered discovery winner `avg_orig_k8` was opened on the frozen 16-block validation set.

Validation candidate-own QNN-vs-ORT aggregate:
- prior-best: max `0.000499725341796875`, rmse `4.4674185608978195e-06`
- standalone K8: max `0.0004279613494873047`, rmse `4.05162453859969e-06`
- `avg_orig_k8`: max `0.0005002021789550781`, rmse `4.422228917235637e-06`

All peak at warm18 `spec_imag[0,18,4]`.

`avg_orig_k8` semantic vs decanonicalized PASS: max `0.00006580352783203125`.

Preregistered validation promotion rule FAIL: winner regresses 16.88% vs standalone K8 max (>3% allowed). No full47 winner run is authorized; this family is closed.

QAIRT generated graph inspection confirms the original MatMul path, eight K8 partial MatMuls, pairwise reduction, PathAdd and Average all remain present. The failure is therefore not converter collapse/common-subexpression fusion. It demonstrates graph-context-sensitive/non-compositional QNN numerical behavior: combining two individually useful lowerings can change their numerical behavior and does not preserve standalone K8's critical-direction advantage.

Local validation result SHA256: `464b00e163b8de2c62bc03500ef6a0a21607b0f92131a01ea61f3e4b8858259d`.

Next: quantify standalone K8 improvement/regression distribution over all 47 real warm blocks against prior-best, then preregister a single-path block5-PW2 partition-order family. No APK/device action.
