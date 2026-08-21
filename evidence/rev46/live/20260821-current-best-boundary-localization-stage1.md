# REV46 current-best causal localization — downstream source/amplifier separation

Date: 2026-08-21
Host-only. APK/device remains blocked.

Current execution-authority model SHA256: `d2efac4f266b312024b0e0b59feeeffa04716dbeaf54ad4763c7950ac9c3fb23`.
Diagnostic blocks were frozen as `[18,1,8,19,32,45]`; warm18 is a localization microscope only and no candidate selection occurred.

## Observer and layout gates

The read-only boundary tap model SHA256 is `916a05ebf61e7a90082ababcabe11d6c65d73003ab9f84c1908173b433e03f95`.
Tapped vs untapped QNN2.44 final outputs were 12/12 byte-for-byte identical, so tap interpretation is valid.
QNN physical layout was explicitly validated against ORT1.27 logical outputs; the chosen spatial-first interpretation beat the alternate interpretation by at least four orders of magnitude.

## Warm18 downstream localization

Candidate-own QNN vs candidate-own ORT1.27 max errors:
- block5 input `/Add_19_output_0`: `8.58306885e-06`
- block5 residual `/Add_23_output_0`: `1.14440918e-05`
- block6 residual `/Add_27_output_0`: `9.98973846e-05`
- block7 residual `/Add_31_output_0`: `0.000247955322`
- final LN `/LayerNormalization_9_output_0`: `0.000137329102`
- final spectrum observed max: `0.000409603119`

The small residual direction already present at block5 input is highly dangerous under the clean downstream map. Clean ORT suffix propagation gives:
- QNN-vs-ORT residual at Add19 -> final max `0.000335931778` (~82% of observed)
- Add23 residual -> final `0.000420570374` (~103% of observed)
- Add27 residual -> final `0.000411272049` (~100%)
- Add31 residual -> final `0.000416278839` (~102%)
- LN9 residual -> final `0.000413179398` (~101%)

Therefore later stages primarily preserve/amplify a final-sensitive upstream direction; they do not need to inject a 4e-4 intrinsic error locally.

## Stage intrinsic closure on warm18

Each stage was evaluated as `ORT(stage,QNN input) - ORT(stage,ORT input)` for propagated input error and `QNN stage output - ORT(stage,QNN input)` for intrinsic backend error. Stage extraction reproduced the ORT boundary exactly (`baseline_repro=0`).

- block5 intrinsic boundary error max `5.7220459e-06`; intrinsic-only clean downstream impact `0.000129699707`; propagated Add19 direction impact `0.000335931778`
- block6 intrinsic max `1.74045563e-05`; intrinsic-only impact `5.48362732e-05`; propagated upstream direction impact `0.000420570374`
- block7 intrinsic max `4.57763672e-05`; intrinsic-only impact `3.76701355e-05`; propagated upstream direction impact `0.000411272049`
- final norm intrinsic max `7.62939453e-06`; intrinsic-only impact `1.00135803e-05`; propagated upstream direction impact `0.000416278839`
- final head intrinsic given QNN LN9 max `3.79085541e-05`; clean propagation of LN9 residual `0.000413179398`; observed final `0.000409603119`

The same qualitative separation holds on the five frozen non-warm diagnostic blocks: block6/block7/head intrinsic terms are modest relative to the clean propagation of already-present residual directions.

## Scientific conclusion

The remaining current-best failure is predominantly **upstream residual direction + downstream anisotropic amplification**. Block6, block7, final normalization and head are not supported as a new primary source family. The dangerous direction is already present by `/Add_19_output_0`, before block5. The exact/equivalent search must therefore move upstream; further block5-7 reduction-tree or head micro-tuning is not justified.

Next diagnostic: nonperturbing residual taps at block0-4 outputs `/Add_3_output_0`, `/Add_7_output_0`, `/Add_11_output_0`, `/Add_15_output_0`, `/Add_19_output_0`, with the same six frozen inputs, a fresh observer-effect gate, clean suffix propagation, and per-block intrinsic closure. No candidate generation is authorized yet.

## Local evidence identities
- `BOUNDARY_QNN_VS_ORT_REPORT.json` SHA256 `83300511bc1427097ca10b5d5666c959e7f06d69c32f163ef7409f43058db69c`
- `CLEAN_SUFFIX_PROPAGATION_REPORT.json` SHA256 `f3904b01cdeadb6b671260dd09e6a06256b535b75aaa164661f72f9a0102a714`
- `STAGE_INTRINSIC_CLOSURE_REPORT.json` SHA256 `3500e36ea5a2123cfa7b4019988d04c64d22c97157c3ba7a2637727d3e319418`
- `SUFFIX_MODEL_MANIFEST.json` SHA256 `e66577fd3c94d47c01fd04296327dd75018cadc8863df0c7eb6993ffe2b4cfce`
- `STAGE_MODEL_MANIFEST.json` SHA256 `ef31b346b258521299af007afba900ce410d19d75b104e1d5c35669a1dc626a3`