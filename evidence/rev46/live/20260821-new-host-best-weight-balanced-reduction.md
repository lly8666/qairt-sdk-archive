# REV46 NEW HOST BEST — contiguous K8 + weight-balanced partial reduction tree

Date: 2026-08-21
Host-only. APK/device remains BLOCKED.

The preregistered reduction-tree winner `weight_balanced` passed Stage1 and Stage2, then remained positive on Stage3 including warm18. Full47 metrics were assembled from the already executed disjoint Stage1+Stage2+Stage3 outputs; no full47 inference rerun was performed.

## Full47 candidate-own QNN2.44 vs ORT1.27
New host best:
- max_abs `0.0004115104675292969`
- mean_abs `3.777641009158933e-07`
- rmse `3.096381567930808e-06`
- cosine `0.9999999999856087`
- peak warm18 `spec_imag[0,18,4]`

Prior contiguous K8:
- max_abs `0.0004279613494873047`
- mean_abs `3.8338243097525156e-07`
- rmse `3.1831204943364255e-06`

Improvement:
- max_abs **3.8440%** — exceeds frozen 3% material-improvement threshold
- RMSE **2.7250%**

Semantic vs decanonicalized ORT authority:
- max_abs `0.00010180473327636719`
- mean_abs `1.8335789275319064e-07`
- rmse `1.450704754473784e-06`
- cosine `0.9999999999969523`
- PASS

Frozen numerical gate still FAILS max only: `0.0004115105 > 0.0003`. No APK/device action.

## Exact construction
Parent contiguous-K8 SHA256: `6666708bc3c507dec52da7c452f8618d2c0c64d594f465891e8511cb6696407c`
New best model SHA256: `a584d4c8e7a05bc36fb06b653c398547b525e15d5a996fc4d7f3dd612db5b774`
All eight Slice and eight partial MatMul nodes are unchanged. Only seven Add nodes use leaf order `[0,5,1,4,2,7,3,6]`. This order was selected solely from static chunk-weight L2 norms by exhaustive pairing before QNN candidate execution.

Full47 report SHA256: `23d13c948fd0102cc93d6490f1b7983aa723a586b0c0d4c35d4caf05cd5342bb`
Generator SHA256: `9c2e1c66d1f29e38d9a5c6cc56ea706924a5af2f27d87e26a89262be100d5c0d`
Split SHA256: `dab847439dbf2e7f77423b3b7fe18eabc43ecf6a5855de111ca76fb91a73d2b0`

## Robustness note
Per-block max improves 23/47 and worsens 24/47; median per-block max improvement is -5.88%. Therefore the global max/RMSE improvement is real and preregistered, but per-block robustness is still mixed. The next family should improve reduction conditioning without fitting the final warm18 error.

## Exact next
Use only ORT partial-output arithmetic on discovery inputs to select deterministic reduction-tree candidates by numerical-conditioning objectives; do not fit to QNN-vs-ORT final errors. Validate selected candidates through QNN Stage1 -> winner-only Stage2 -> Stage3. Current host best remains this weight-balanced model until a >=3% full47 improvement is demonstrated. APK/device blocked.
