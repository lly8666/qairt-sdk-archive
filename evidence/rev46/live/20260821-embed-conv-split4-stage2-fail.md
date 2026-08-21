# REV46 embed-Conv split4 Stage2 FAIL — exact/equivalent route closes

Host-only. No APK/device execution. warm18 remained sealed and was never exposed to split4.

Stage1 had selected split4 without warm18 exposure (max improvement 23.6364%). Only split4 was allowed to enter the frozen Stage2 validation set `[46,41,10,21,27,33,15,37,38,23,17,40,4,9,43]`.

Stage2 candidate-own ORT semantic PASS:
- max_abs `7.2479248046875e-05`
- mean_abs `2.4663319413126356e-07`
- rmse `1.8762234121561287e-06`
- cosine `0.9999999999955358`
- report SHA256 `568946c729817632e32b1ca037efebf82f43e9f212be956a9879d9ca73ddf3b7`

Stage2 QNN2.44 CPU vs candidate-own ORT:

Current host-best baseline:
- max_abs `0.00014352798461914062`
- mean_abs `3.830376917789177e-07`
- rmse `2.8538671266533583e-06`
- cosine `0.9999999999896318`

split4:
- max_abs `0.00014400482177734375`
- mean_abs `3.350087129077047e-07`
- rmse `2.629311347181103e-06`
- cosine `0.9999999999912036`

Changes vs baseline:
- aggregate max: **+0.3322259% regression**
- aggregate RMSE: `-7.86847%` improvement
- aggregate mean: `-12.53897%` improvement
- per-block max regressions >25%: exactly 3 (`warm10 +28.125%`, `warm23 +28.205%`, `warm17 +74.566%`)

Frozen Stage2 rule required all three:
1. aggregate max_abs must not regress — **FAIL**
2. aggregate RMSE must not regress — PASS
3. at most 3 per-block max regressions >25% — PASS

Therefore Stage2 decision is **FAIL_CLOSE_EXACT_ROUTE**. The near-miss is not grounds for threshold relaxation. split4 must not see Stage3 or warm18. No additional embed-Conv split counts, adjacent PW/LN rewrites, or other exact/equivalent micro-variants may be created by default.

Stage2 score report SHA256: `033a308500e3fd9e08b65537e6d4f394418987a92bde93e660b391a2aef1dc8d`.

Current host best remains unchanged at full47 max_abs `0.0004115104675292969` (gate `<=0.0003`).

By the preregistered task-stack zoom-out rule, return to L1/L0 and activate the preserved learned-residual / wider-student / qualified-surrogate contingency. This is a route transition, not permission to reopen exact micro-tuning.
