# REV46 K8 weight-balanced reduction tree — Stage2 PASS

Host-only; APK/device blocked.

Only the preregistered Stage1 winner `weight_balanced` was opened on the salted 15-block Stage2 validation set.

Frozen K8 baseline:
- max_abs `0.00014972686767578125`
- rmse `2.7400152520314413e-06`

Weight-balanced winner:
- max_abs `0.00014352798461914062`
- rmse `2.7023160654517448e-06`
- max improvement **4.1401%**
- RMSE improvement **1.3759%**

Blocks with >25% relative per-block max regression: `5,21,40` = exactly 3/15, at prereg limit. Semantic vs decanonicalized authority PASS: max `9.608268737792969e-05`, rmse `1.5000106725987398e-06`.

Stage2 report SHA256: `36018716409e4fef06482b29fce06b3e18248b6ee22c792bfb2614ea5097bc20`
Winner model SHA256: `a584d4c8e7a05bc36fb06b653c398547b525e15d5a996fc4d7f3dd612db5b774`

Decision: Stage2 PASS. Winner-only Stage3 (17 blocks, includes warm18) is now authorized. No other reduction tree may see Stage3.
