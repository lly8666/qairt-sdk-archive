# REV46 live recovery — block5 PW2 K8 breakthrough

Date: 2026-08-21 (Asia/Tokyo)
QAIRT/QNN: 2.44.0 / 2.44.0.260225
APK/device gate: still BLOCKED.

## Prior best
- `b5mh_b6hi_b7lo.onnx`
- SHA256 `a0a64c3af5e2acfa2e4f872642352efcebbb82858af82bbc7982a94d3ffaced7`
- warm18 max_abs `0.000499725341796875`

## Evidence-driven target
Exact propagation attribution identified block5 PW2 (`/MatMul_11` + `/Add_22`) as the first actionable intrinsic backend source in the final-sensitive direction.

## K-split matrix
All candidates are exact block5 PW2 K-axis partitions with pairwise partial-sum reduction and all PASS ORT1.27 semantic gates vs the decanonicalized reference.

QNN2.44 warm18 candidate-own QNN vs candidate-own ORT:
- k2: `0.00045561790466308594` (+8.8263% vs prior best)
- k4: `0.00047087669372558594` (+5.7729%)
- k8: `0.0004279613494873047` (+14.3607%) **best**
- k16: `0.0005371570587158203` (-7.4905%, worse)

Every candidate peak remains `spec_imag[0,18,4]`; no failure-point migration.

k8 semantic vs decan:
- max_abs `9.059906005859375e-05`
- mean_abs `2.5837843400309204e-07`
- rmse `2.397565589360466e-06`
- cosine `0.9999999999591253`
- PASS

## Promoted candidate
- path locally: `block5_pw2_ksplit_matrix/models/k8.onnx`
- SHA256 `04c84791423c12f9a73db9611e1adc65f57238ff3c5f4bbcd18facee8238f8a9`
- warm18 max_abs `0.0004279613494873047`
- improvement vs prior best: `14.360687022900764%`

## Scientific conclusion
The attribution was directionally correct: changing block5 PW2 accumulation lowering materially reduces the dominant final-sensitive error. k8 is promoted to full warm47 host validation before any more local search.

## Exactly next
Run ORT1.27 and QNN2.44 full warm47 for block5-PW2-k8. Verify aggregate gate metrics and confirm no other warm block becomes dominant. No APK/device test yet.
