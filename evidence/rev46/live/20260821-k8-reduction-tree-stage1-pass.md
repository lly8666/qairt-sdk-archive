# REV46 K8 partial-reduction-tree Stage1 PASS

Host-only. APK/device remains blocked.

Family invariant: all 8 contiguous K8 Slice nodes, all 8 192-wide partial MatMuls, K membership and weights are unchanged. Only the seven Add reduction nodes differ. New salted Stage1 set has 15 real warm blocks and excludes warm18.

All five alternatives PASS ORT1.27 semantic gate.

QNN2.44 candidate-own Stage1:
- frozen K8 baseline: max `0.00011673569679260254`, rmse `2.66196105793047e-06`
- **weight_balanced**: max `0.00009799003601074219`, rmse `2.5425899369488124e-06` — WINNER
- stride4: max `0.0001010894775390625`, rmse `2.627665336647017e-06`
- bitreverse: max `0.00011646747589111328`
- extremes: max `0.00011944770812988281`
- stride2: max `0.000148773193359375`

Winner improvement vs frozen K8:
- max_abs **16.0582%**
- RMSE **4.4843%**
Preregistered Stage1 promotion PASS.

Weight-balanced leaf order is `[0,5,1,4,2,7,3,6]`. It was chosen before candidate execution solely from static chunk-weight L2 norms by exhaustive pairing; no input/output diagnostic values were used.

Winner model SHA256: `a584d4c8e7a05bc36fb06b653c398547b525e15d5a996fc4d7f3dd612db5b774`
Stage1 report SHA256: `7ae747e51140d7659af337c943528cc2f7a31d10478266835bf2de65e6e89783`
Prereg SHA256: `a5281e3612da27f960129603985517651941ece9e1540bac482c79bc308edc0c`
Split SHA256: `dab847439dbf2e7f77423b3b7fe18eabc43ecf6a5855de111ca76fb91a73d2b0`

Next: winner-only Stage2 (15 salted validation blocks) vs frozen K8. No other reduction tree may see Stage2. Stage3/warm18 remains sealed until Stage2 pass.
