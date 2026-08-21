# REV46 live checkpoint — block5 PW2 redundant accumulation discovery winner

Date: 2026-08-21 (Asia/Tokyo)
QAIRT/QNN: 2.44.0 / 2.44.0.260225
Device/APK gate: BLOCKED.

## Methodology hardening
Synthetic Holdout A was retained as an off-manifold stress test after PCA manifold audit showed excess high-order residual energy. Synthetic B remains SEALED and unused.

A real warm47 split was frozen outcome-independently by lexicographic SHA256 rank of each authority warm input: `rank % 3 == 0` is validation, otherwise discovery.
- discovery: 31 blocks
- validation: 16 blocks `[2,3,5,7,10,11,16,18,22,24,28,29,37,40,46,47]`
- warm18 is validation-only for this family.
- split manifest SHA256: `be2788da28cab620ce23fee2cc4394234ff3a98de7f4cbbbc893eb9b4ec2cdb7`

## Preregistered candidate family
Family SHA256: `5980fc075741c9bff9e97d3167418d80b3bf2a1a49d432d9a77b9a523adbc3a8`
Equal-weight mathematically equivalent block5 PW2 redundant accumulation paths:
- `avg_orig_k2`
- `avg_orig_k8`
- `avg_k2_k8`
- `avg_orig_k2_k8`

No candidate may be added after discovery results. Primary discovery selection metric is aggregate candidate-own QNN-vs-ORT max_abs; if candidates are within 1% relative max, lower RMSE wins. Every candidate must pass the frozen ORT semantic gate vs decanonicalized reference.

## Discovery results
All four semantic gates PASS.

QNN2.44 candidate-own discovery metrics:
- `avg_orig_k8`: max `0.0001354217529296875`, mean `3.526316403006316e-07`, rmse `2.54931140019665e-06` — **WINNER**
- `avg_k2_k8`: max `0.00016689300537109375`, mean `3.5102362358038606e-07`, rmse `2.4699738000672746e-06`
- `avg_orig_k2`: max `0.00017690658569335938`, mean `3.615019990827882e-07`, rmse `2.5584476188467493e-06`
- `avg_orig_k2_k8`: max `0.00018966197967529297`, mean `3.6214447282030367e-07`, rmse `2.620906859495263e-06`

Winner is unique by >1%, so tie-break was not used.

`avg_orig_k8.onnx` SHA256: `ea197a7d42adaf4dd7863e316b8770ca4036eb215d9ac216965d95ba554f7910`.

## Exactly next
Open the frozen 16-block validation exactly once for `avg_orig_k8` plus frozen prior-best/K8 baselines. No other ensemble candidate may see validation. No APK/device action yet.
