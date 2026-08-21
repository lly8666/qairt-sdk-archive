# REV46 block0 Add3 low-rank correction — validation FAIL, holdout remains sealed

Host-only intentional-student foundation. No APK/device execution. Exact/equivalent route remains closed.

Dataset/split were frozen before fitting. Model family was preregistered before fitting: framewise QNN Add3 `[320]` -> rank-r affine correction `[320]`, ranks `{1,2,4,8,16,32}`, fixed ridge-relative grid `{1e-4,1e-3,1e-2,1e-1,1}`. Train only fits; validation only selects. Holdout includes warm18 and was not indexed during fit/selection.

Train target rankability is weak rather than strongly low-rank: cumulative centered target energy is rank1 `15.01%`, rank2 `21.63%`, rank4 `32.28%`, rank8 `45.55%`, rank16 `59.30%`, rank32 `74.43%`.

Validation baseline Add3 residual: RMSE `3.621845257450918e-07`, max_abs `6.198883056640625e-06`, mean_abs `1.9780795170731836e-07`.

No fixed-grid candidate improved validation RMSE. The absolute best / preregistered winner is rank1, ridge-relative 1.0:
- validation RMSE `3.6688961137538953e-07` = **1.2991% regression**
- validation max_abs `6.7831666918261495e-06` = **9.4256% regression**
- validation mean_abs = **1.0434% regression**
- only 1/8 validation blocks improves RMSE; 7/8 regress

Across the entire frozen grid, best RMSE improvement is `-1.2991%`; zero candidates satisfy the preregistered validation promotion rule (`>=3% RMSE improvement` and max regression `<=3%`).

Therefore decision: **CLOSE_SINGLE_BOUNDARY_ADD3_LOWRANK_BEFORE_HOLDOUT**. Holdout/warm18 remains sealed and is not opened because validation already failed. Do not extend rank/lambda grids or try nonlinear variants at the same single boundary by default.

Per task-stack zoom-out rule, escalate the optimization unit to a wider/adjacent-block or prefix/full-Vocos student. First verify that a sufficiently broad nonfinal realistic training corpus exists; if current authority only contains the 47 warm blocks from one sequence, build a broader nonfinal corpus before training to avoid fitting deterministic rounding noise from one trajectory.

Identities:
- FIT_PREREG SHA256 `ee88d9e6fe0dd2515908f4f3846f308a9f1eb11254a52565ea15d8f89bce3b68`
- DATASET_MANIFEST SHA256 `a99add348a07b092ed094420f6e9e6c171ab1172adf6f655640530ba83a468f2`
- validation selection report SHA256 `d83ce917dc44eceac31e4cf5edf868ad3be1408a864162c6e646c41a70b5663e`
- holdout opened: false
