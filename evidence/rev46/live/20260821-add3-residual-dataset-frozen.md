# REV46 block0 Add3 learned-residual dataset frozen

Host-only. Exact/equivalent route remains closed; no APK/device execution.

The all-warm Add3 dataset was collected only after the 30/8/9 SHA split and immutable collection plan were frozen. QNN all47 and candidate-own ORT1.27 all47 each completed once. No model fitting occurred before DATASET_MANIFEST was written.

Observer/layout regression: the six previously authorized diagnostic blocks `[1,8,18,19,32,45]` reproduce their historical Add3 QNN-vs-ORT max_abs values exactly after QNN physical `[1,6,320]` -> logical `[1,320,6]` conversion.

Dataset canonical layout: `[block,time,channel]=[47,6,320]`.
Residual definition: `ORT Add3 - QNN Add3`.
Corpus-only stats (no fitting): max_abs `8.58306884765625e-06`, mean_abs `1.9654946557058264e-07`, RMSE `3.6102563111922775e-07`.

Identities:
- split SHA256 `261eb07c76ce1d16aa00ee5a36bd1d883b8a8879f52174b3b689ca33571ff08f`
- collection plan SHA256 `7d7c436c623e93efc5032a1290ea51a7e246873e30a8f42264c15f579beddd14`
- DATASET_MANIFEST SHA256 `a99add348a07b092ed094420f6e9e6c171ab1172adf6f655640530ba83a468f2`
- QNN Add3 array SHA256 `719e8dfca07d551b8a0c88b6efac2d271c5145541d784c8935ae8eaa6b9393eb`
- ORT Add3 array SHA256 `282d201f7baee5b042972ac6bd9f8b02c4eb28cb844fa917c098a7661ed2c79d`
- residual array SHA256 `5d6e8e1f9c82114890ea1a1ede78ab6b9ceaf9851a4b1272a4592d896624f011`

Protected selection boundary remains: train only fits; validation selects rank/regularization using Add3 residual metrics only; holdout opens exactly once after winner freeze; warm18 is holdout-only and may not select hyperparameters; final device A/B/C and seed 20260814 remain excluded from fit/search.
