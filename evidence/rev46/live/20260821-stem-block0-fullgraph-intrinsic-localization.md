# REV46 stem/block0 full-graph intrinsic localization

Host-only. No APK/device execution. Current host best remains max_abs `0.0004115104675292969`; frozen max gate remains `0.0003`.

## Observer and layout validity

The stem/block0 tap graph passed the non-perturbation observer gate: tapped vs untapped QNN final `spec_real/spec_imag` were bit-exact on all 6 frozen diagnostic inputs (`warm18 + [1,8,19,32,45]`).

A first uniform-layout report was INVALID because Conv-family outputs use a different QNN physical layout than surrounding tensors. It is retained only as invalid evidence. Correct per-tensor layout scoring gives warm18 boundary QNN-vs-candidate-own-ORT max_abs:

- embed Conv `/Conv_output_0`: `6.198883056640625e-06`
- stem LN `/LayerNormalization_output_0`: `3.337860107421875e-06`
- block0 DWConv `/Conv_1_output_0`: `1.0728836059570312e-06`
- block0 LN `/LayerNormalization_1_output_0`: `1.0728836059570312e-06`
- block0 PW1 `/Add_output_0`: `3.0994415283203125e-06`
- block0 activation `/Mul_1_output_0`: `2.384185791015625e-06`
- block0 PW2 `/Add_2_output_0`: `4.1961669921875e-05`
- block0 gamma `/Mul_2_output_0`: `8.58306884765625e-06`
- block0 residual `/Add_3_output_0`: `8.58306884765625e-06`

Correct report SHA256: `73702539659220da7fdfef8a33e16371358b02f4bb1b4bf5f675acfbeceaf23c`.
Invalid uniform-layout report SHA256: `f982f5483eba2f656cd9bc090f3bb9ea890236182bab6b186301b36005523d0c`.

## Stage-local intrinsic closure

Stage-local ORT reproductions are exact at each stage boundary. Warm18 decomposition includes:

- embed Conv intrinsic boundary: `6.198883056640625e-06`
- stem LN intrinsic boundary: `9.5367431640625e-07`
- block0 DWConv intrinsic boundary: `1.1920928955078125e-07`
- block0 LN intrinsic boundary: `5.9604644775390625e-07`
- block0 PW1 intrinsic boundary: `3.0994415283203125e-06`
- activation intrinsic boundary: `0`
- block0 PW2 propagated boundary component: `1.9073486328125e-05`
- block0 PW2 intrinsic boundary component: `4.57763671875e-05`
- gamma intrinsic boundary: `0`

Stage closure report SHA256: `2b52f862a89d8e8c6005b2bb0c5200e7f0606044817e4b066ac1a36867889b7c`.

## Default-ORT full-graph delta injection

Cut suffixes were not used as authoritative final-impact estimators because default ORT optimization context changed after the cut. Instead, each tested boundary was given a dynamic diagnostic delta input in the full graph. For all 8 tested stage-injection models × 6 diagnostic inputs, `delta=0` reproduced the original default-ORT `spec_real/spec_imag` bit-exact (48/48 observer PASS). This keeps the full downstream graph and default ORT optimization context intact.

Warm18 intrinsic-only full-graph final max impacts:

- embed Conv: `0.0002434253692626953`
- stem LN: `3.8623809814453125e-05`
- block0 DWConv: `0.00012493133544921875`
- block0 LN: `0.0002582073211669922`
- block0 PW1: `0.0002899169921875`
- activation: `0`
- block0 PW2: `0.00016546249389648438`
- gamma: `0`

Injection report SHA256: `8209c1f852aae511e3cdcd55ffa75c13f2dc82990bb53dcdfba4231a4eae8eea`.

## Direction alignment against observed failure

Warm18 observed final error is `spec_imag[0,18,4] = -0.0004115104675292969` (QNN minus ORT).

Intrinsic-only full-graph error-vector alignment on warm18:

- **embed Conv**: cosine `0.9785121866604324`, projection fraction `0.5340254902931302`; linearized removal reduces observed final-error L2 by about `52.06%`.
- stem LN: cosine `0.7948321301164527`, projection `0.09739287012767181`; about `9.43%` L2 reduction if removed.
- block0 DWConv: cosine `-0.9447331277294188` (mostly compensating).
- block0 LN: cosine `-0.9741295697048744` (strongly compensating).
- block0 PW1: cosine `-0.9717757100307073` (strongly compensating).
- block0 PW2: cosine `-0.9443155517231953` (strongly compensating).

Across the six frozen diagnostics, embed Conv has median alignment cosine about `0.434` and positive median projection; only block8 shows a small negative linearized removal effect. Stem LN is directionally more consistent but has insufficient warm18 leverage by itself to plausibly close the remaining ~27.1% max gap.

Alignment report SHA256: `49331ed8dd50a7bb08bf04b57904c54c2b6634dc78926970f3ada6f4ccab97fe`.

## Causal decision

Do **not** target block0 PW1/PW2 merely because their local boundary errors are larger: on warm18 their intrinsic final vectors are mostly compensating the observed failure. Improving those operators toward ORT could worsen the current max peak.

The only currently identified exact/equivalent target with both correct failure direction and plausible leverage beyond the remaining 27.1% gap is the front-end embed Conv (`80 -> 320`, kernel 7, pad 3).

Next family is intentionally narrow and final-by-default for the exact/equivalent route: split embed-Conv input-channel accumulation into fixed `{2,4,8}` contiguous groups, keep each partial Conv bias-free, combine partials with a fixed balanced Add tree, and add the original bias once at the end. No other split counts or adjacent PW/LN rewrites may be added after seeing results. A fresh outcome-independent real-warm Stage1/2/3 split must be frozen before any candidate QNN run, with warm18 protected in Stage3.

If this causally distinct family does not deliver material full47 progress, return to L1/L0 and activate the learned-residual / wider-student / qualified-surrogate contingency instead of further exact micro-tuning.
