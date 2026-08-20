# REV46 live recovery — block5 first actionable intrinsic source

Date: 2026-08-21 (Asia/Tokyo)
QAIRT/QNN: 2.44.0 / 2.44.0.260225
APK/device gate remains BLOCKED.

## Current best
- `b5mh_b6hi_b7lo.onnx`
- SHA256 `a0a64c3af5e2acfa2e4f872642352efcebbb82858af82bbc7982a94d3ffaced7`
- warm18 final max_abs `0.000499725341796875`

## Block5 nonperturbing tap errors
- Add19 `8.58306884765625e-06`
- LN6 `4.1425228118896484e-06`
- Add20 `6.67572021484375e-06`
- Mul16 `6.794929504394531e-06`
- Add22 `4.76837158203125e-05`
- Mul17 `1.811981201171875e-05`
- Add23 `1.9073486328125e-05`

All single taps preserve current-best QNN final outputs bit-exact.

## Exact block5 PW2 attribution
Clean ORT PW2 on QNN Mul16 propagates max error `2.956390380859375e-05`. Intrinsic QNN PW2 on the same QNN Mul16 has global max `4.1961669921875e-05`.

At observed Add22 peak `[0,3,247]`:
- propagated signed error: `-2.288818359375e-05`
- intrinsic QNN PW2 signed error: `-2.47955322265625e-05`
- total: `-4.76837158203125e-05`

Gamma and residual Add are intrinsically clean (both exact on same QNN inputs).

## Final-sensitive propagation to clean ORT Add30
- QNN Add19 only -> `0.0002002716064453125`
- QNN Mul16 with ORT Add19 -> `0.00025081634521484375`
- QNN Add22 with ORT Add19 -> `0.00034999847412109375`
- QNN Mul17 with ORT Add19 -> `0.00034999847412109375`
- QNN Add23 boundary -> `0.00037479400634765625`

Thus block5 PW2 is the first clearly actionable intrinsic backend source in the final-sensitive direction: its lowering pushes clean-downstream Add30 error from ~2.51e-4 to ~3.50e-4, crossing the frozen max gate. This differs from block7 PW2, whose intrinsic contribution at the dominant point was negligible.

## Recovery hashes
- extended attribution JSON: `86094b6f58524d5573dea5795c0ee3c4ae1e041682da36b03793a93f326757a1`
- base attribution JSON: `6a0f29c79f61271d8bfa0bde21a158fa3452c4ed0565ebcdab11f130866a631b`

## Exactly next
Host-only block5 PW2 accumulation/lowering matrix on current-best `b5mh_b6hi_b7lo`; start with K-split 2/4/8/16 because unlike block7 PW2, block5 PW2 has a material adverse intrinsic QNN contribution. No APK/device test yet.
