# REV46 embed-Conv input-channel split Stage1 PASS

Host-only. APK/device remains blocked. warm18 remained protected and was not used in Stage1 selection.

Causal basis: full-graph default-ORT diagnostic delta injection identified the front-end embed Conv intrinsic residual as the only currently known exact/equivalent target with both strong alignment to the warm18 observed failure (cosine ~0.979, projection ~53.4%) and plausible leverage beyond the remaining ~27.1% host max gap. Block0 PW/LN intrinsic vectors are mostly compensating on warm18 and were intentionally excluded from this family.

Frozen family: exactly contiguous input-channel split counts `{2,4,8}` for the `80 -> 320`, kernel-7 embed Conv. Each partial Conv is bias-free, partial outputs use a fixed balanced Add tree, and the original bias is added once at the end. No post-hoc split counts are allowed.

Frozen split SHA256: `ee65b25c87c7c55965d541a9b39939117a376e65cb1b980936bdc9b0c7a8e80d`.
Prereg SHA256: `407aa7e64aaa37b7437abd7bc050c3edbbb8e45c66b1b2df09138e14da0f905e`.
Manifest SHA256: `809b7f9be6a66d2153863ad0c0942ca8c280dbd69feaf03f18c5d129a133a056`.
ORT Stage1 semantic report SHA256: `58ecd0363e599ce58d0b346cfaa3471077ae4115294900515d0767345e62c794`; all three candidates PASS.

Stage1 blocks: `[36,42,11,5,7,2,3,13,6,34,25,39,19,44,8]`.

QNN2.44 candidate-own Stage1:
- frozen current-best baseline: max `0.0001049041748046875`, rmse `2.1524622614106623e-06`
- split2: max `0.00010633468627929688` (-1.36% max improvement; FAIL promotion)
- **split4: max `0.000080108642578125`, rmse `2.049844954838482e-06` (max improvement `23.6364%`, RMSE improvement `4.7674%`) — WINNER**
- split8: max `0.00008630752563476562`, rmse `1.933199749155159e-06` (max improvement `17.7273%`, RMSE improvement `10.1866%`)

Preregistered ranking is lowest aggregate max_abs, then RMSE, then mean_abs. Therefore split4 is the unique winner and **only split4 may enter Stage2**. split2 and split8 are closed and must not see Stage2/Stage3.

Stage1 QNN score SHA256: `caf302009b0ec149a39c54887ad3b7b1e80fa32ead1f1f61e16637d9f73c99e5`.

Next: winner-only split4 Stage2 on frozen 15 blocks `[46,41,10,21,27,33,15,37,38,23,17,40,4,9,43]`, compared with current-best baseline. Stage2 must not regress aggregate max or RMSE and may have at most 3 per-block max regressions >25%. warm18 remains sealed in Stage3.
