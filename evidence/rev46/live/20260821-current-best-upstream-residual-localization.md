# REV46 current-best upstream residual localization — block0 residual already carries dangerous direction

Date: 2026-08-21
Host-only. APK/device remains blocked.

Upstream residual tap model SHA256: `5d150ffbef8623874629c9fbad7c7168ed06c8f4ef6fab9058dfb96defdd5b0c`.
Observer effect passed 12/12 final outputs bit-exact against the reused untapped current-best reference.
Frozen diagnostic blocks remained `[18,1,8,19,32,45]`.

## Warm18 residual boundaries
Candidate-own QNN2.44 vs ORT1.27:
- block0 residual Add3: `8.58306885e-06`
- block1 residual Add7: `8.10623169e-06`
- block2 residual Add11: `8.10623169e-06`
- block3 residual Add15: `7.62939453e-06`
- block4 residual Add19: `8.58306885e-06`
- final spectrum max: `0.000411510468`

The residual magnitude remains tiny and nearly flat, but its direction is extremely final-sensitive. Clean ORT suffix propagation on warm18 gives:
- Add3 -> final `0.000576257706` (1.40x observed)
- Add7 -> final `0.000664472580` (1.61x observed)
- Add11 -> final `0.000510931015` (1.24x observed)
- Add15 -> final `0.000442028046` (1.07x observed)
- Add19 -> final `0.000335931778` (0.82x observed)

Therefore the dangerous residual direction is present no later than block0 residual Add3; blocks1-4 transport, rotate and partially cancel/amplify it rather than being the first source.

## Block1-4 intrinsic closure on warm18
Each block was decomposed into propagated input error vs intrinsic backend error, with clean ORT downstream impact:
- block1 intrinsic boundary max `1.31130219e-06`; intrinsic-only final impact `0.000289678574`
- block2 intrinsic max `1.07288361e-06`; intrinsic-only final impact `0.000221967697`
- block3 intrinsic max `2.86102295e-06`; intrinsic-only final impact `4.43458557e-05`
- block4 intrinsic max `2.86102295e-06`; intrinsic-only final impact `0.000309467316`

These small intrinsic terms can be highly leveraged by downstream conditioning and contribute cancellation/rotation, but none can be the earliest source because Add3 already carries a sufficiently dangerous residual. No block1-4 optimization family is opened by this diagnostic.

## Next
Move one level earlier and distinguish embed/stem error from block0 intrinsic error. Expose, in one nonperturbing graph, embed Conv, stem LayerNorm/block0 input, block0 DWConv, block0 LayerNorm, PW1/pre-activation, activation, PW2, gamma and Add3. Reuse the same frozen six inputs and untapped reference; require a fresh bit-exact observer gate before interpreting these internal taps.

## Local evidence identities
- `UPSTREAM_BOUNDARY_QNN_VS_ORT_REPORT.json` SHA256 `69ffe58c82f82b75d55a2a9b5e27476924c0cee97aa9122795501ae69ca7f075`
- `UPSTREAM_CLEAN_SUFFIX_PROPAGATION_REPORT.json` SHA256 `1cbf07bcb662c8c4d364875c4269aa310d372f5162c3b84e687320dad057c3b8`
- `UPSTREAM_STAGE_INTRINSIC_CLOSURE_REPORT.json` SHA256 `c12ba8a97fe382c1364c575e241dcf91647d97fefd4eabea0967a47897d34d86`
- upstream suffix manifest SHA256 `4c7155af85965a345c36525eba0278f27a75efd8ab7bb3dae0998733cd1491a4`
- upstream stage manifest SHA256 `cc9c6621fa19ee1634a2e331953b284e7b3afc3dc8d2612e7c1c2073fcf0fa24`