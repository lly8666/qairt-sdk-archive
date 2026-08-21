# REV46 block0 Add3 learned-residual foundation — split frozen before collection

Host-only intentional-student foundation. Exact/equivalent route remains closed; no APK/device execution.

Before collecting the all-warm Add3 residual corpus, an outcome-independent split was frozen from `sha256(salt | QNN-input-sha)` over warm1..47. warm18 was forcibly assigned to holdout before ranking allocation. No Add3/QNN/ORT output values were read to create this split.

- train (30): `[24,2,37,31,32,11,21,26,12,20,14,27,22,46,10,23,19,13,36,17,29,38,39,6,4,9,33,8,16,34]`
- validation (8): `[45,3,35,28,15,43,1,47]`
- holdout (9): `[44,7,25,5,42,30,41,40,18]`
- warm18: holdout only
- final device A/B/C: excluded from fitting/search
- seed 20260814: excluded from fitting/search

Frozen split SHA256: `261eb07c76ce1d16aa00ee5a36bd1d883b8a8879f52174b3b689ca33571ff08f`.
Immutable pre-collection plan SHA256: `7d7c436c623e93efc5032a1290ea51a7e246873e30a8f42264c15f579beddd14`.
Freeze script SHA256: `a226201de42cb6a8d966473a3c4a5ac5ae67e4482624d5c5ad42c9c030fabec5`.

Target is logical `/Add_3_output_0` `[1,320,6]`; QNN physical output is `[1,6,320]`. Residual is defined as candidate-own `ORT Add3 - QNN Add3` on the unchanged current host best. The existing upstream tap graph is already authorized by the prior 12/12 final-output bit-exact observer gate.

No model fitting is permitted until QNN all47 collection, ORT all47 collection, and a final DATASET_MANIFEST are complete and SHA-locked. Hyperparameter/rank selection may use train + validation Add3 metrics only. Holdout is opened once after selection; warm18 cannot select hyperparameters.
