# REV46 live recovery — block6 sensitive-direction attribution

Date: 2026-08-21 (Asia/Tokyo)
QAIRT/QNN: 2.44.0 / 2.44.0.260225
Device/APK gate: still BLOCKED until host numerical gates pass.

## Current best
- `b5mh_b6hi_b7lo.onnx`
- SHA256 `a0a64c3af5e2acfa2e4f872642352efcebbb82858af82bbc7982a94d3ffaced7`
- authoritative warm18 final max_abs `0.000499725341796875`

## Nonperturbing block6 taps
All single-tap probes preserve final QNN `spec_real/spec_imag` bit-exact.

- `/Add_23`: `1.9073486328125e-05`
- `/LayerNormalization_7`: `7.152557373046875e-06`
- `/Add_24`: `1.9788742065429688e-05`
- `/Mul_19`: `1.5676021575927734e-05`
- `/Add_26`: `6.628036499023438e-05`
- `/Mul_20`: `0.0001227855682373047`
- `/Add_27`: `0.00012230873107910156`

## Exact stage attribution
Block6 PW2 (`/Mul_19 -> /Add_26`):
- QNN Mul19 propagated through clean ORT PW2: max `6.651878356933594e-05`.
- intrinsic QNN PW2 on same QNN Mul19: global max `1.239776611328125e-05`.
- at dominant Add26 `[0,4,255]`, intrinsic signed contribution is only `+2.384185791015625e-07`; dominant error is propagated.

Gamma (`/Add_26 -> /Mul_20`):
- clean ORT gamma propagates error to exactly `0.0001227855682373047`.
- intrinsic QNN gamma error: exactly `0`.

Residual add:
- actual QNN `/Add_27` is bit-exact to clean ORT residual add on the same QNN branch+skip inputs.
- intrinsic residual add error: exactly `0`.

## Critical correction
Although `/Add_23` has only `1.907e-05` scalar max error, feeding QNN `/Add_23` through the entire CLEAN ORT block6 produces `/Add_27` max_abs `0.00012993812561035156`.

Therefore the sensitive-direction error already exists at block5 residual `/Add_23`; block6 mainly amplifies it. Earlier wording based only on scalar max that block6 'injects' the dominant error is superseded.

## Recovery hashes
- `BLOCK6_STAGE_ATTRIBUTION.json`: `8a7f4773395d9a96784591173f1693e2e26fab45d2d3fdf56395f02a968409ea`
- attribution script: `6a0f0fec7e9980d1bc853a96e41b28742887c5f5a6a6fb9ee909e8b889f2ef46`

## Exactly next
Trace the sensitive direction backward through block5 residual `/Add_23` to `/Add_19` (block4 residual) and the block5 branch. Do not build or run an APK/device test yet.
