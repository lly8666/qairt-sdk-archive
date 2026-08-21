# REV46 K8-conditioned downstream Stage2 PASS

Date: 2026-08-21
Host-only; APK/device remains blocked.

Only the preregistered Stage1 winner `b6_reassoc_b7_lohi` was opened on the frozen 15-block Stage2 validation set. No other family candidate saw Stage2.

## Stage2 candidate-own QNN2.44 vs ORT1.27
Frozen K8 baseline:
- max_abs `0.00014972686767578125`
- rmse `2.8352813533103916e-06`

Winner `K8 + block6 clenshaw_reassoc + block7 lohi`:
- max_abs `0.00013840198516845703`
- rmse `2.560036523475006e-06`
- max improvement **7.5637%**
- RMSE improvement **9.7078%**

Only blocks 33 and 43 exceeded a 25% relative per-block max regression (2/15); prereg limit was <=3 blocks.

Semantic vs decanonicalized ORT authority remains PASS:
- max_abs `6.818771362304688e-05`
- rmse `1.3971743548072231e-06`
- cosine `0.9999999999971715`

Stage2 report SHA256: `1a0c16884063f1c659edee0c24eb5633c44f3d9c06103ef7278262b89a1e7237`
Winner model SHA256: `cd992d6f57dce5b84d27ed732b39d86015fe4b308d89dc53f92ae762f2df7bb7`

## Decision
Preregistered Stage2 rule PASS. Stage3 challenge is now authorized for this winner only. Stage3 includes warm18. No other family alternatives may see Stage3. No APK/device run.
