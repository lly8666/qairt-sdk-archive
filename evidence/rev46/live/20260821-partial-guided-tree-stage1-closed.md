# REV46 partial-guided balanced-tree transfer — Stage1 CLOSED

Host-only. APK/device remains blocked.

The three candidates were selected before final-spectrum QNN execution using only the nonperturbing intermediate Add22 partial-QNN proxy. Frozen Stage1 real-warm blocks: `[1,8,9,10,12,13,19,24,28,32,33,37,38,42,45]`; warm18 remained protected.

Cross-sandbox reconstruction first reproduced the frozen prior-best/K8/current-best ORT and QNN warm18 fingerprints exactly. Reconstructed A/B/C also reproduced their frozen Stage1 ORT semantic values; recovery runs carry zero statistical weight.

Frozen current weight-balanced Stage1 baseline from the earlier reduction-tree experiment:
- max_abs `0.00009799003601074219`
- rmse `2.5425899369488124e-06`
Material promotion requires >=3% max improvement; ceiling `0.00009505033493041993`.

QNN2.44 candidate-own Stage1, scored only after all three 15/15 runs were complete:
- A_local_max: max `0.00012159347534179688`, rmse `2.488361314150657e-06`, max improvement `-24.0876%`, FAIL
- B_local_rmse: max `0.0001233518123626709`, rmse `2.762086886750673e-06`, max improvement `-25.8820%`, FAIL
- C_p90_blockmax: max `0.00010091066360473633`, rmse `2.558994775755573e-06`, max improvement `-2.98054%`, FAIL

Ranking by aggregate max: C < A < B, but **none is materially better than the current host best**. There is no Stage1 winner. Stage2 and Stage3/warm18 are NOT opened.

Stage1 score report SHA256: `1938133a60ffd4d8d62640616f12a46813940c693c8bea17bafb4f33fec72b80`.

Decision: close `k8_partial_guided_tree_family`. Do not add more tree selectors, leaf orders, warm18-aware trees, or result-conditioned reduction-tree variants. Current host best remains the static weight-balanced tree.

Mandatory next level per TASK_STACK: return from L3 to L2 and perform a fresh nonperturbing causal localization on the current weight-balanced host best. Any further exact/equivalent family must target a genuinely distinct mechanism with plausible leverage toward the remaining ~27.1% max gap; by default only one such family remains before the learned-residual/wider-student/surrogate contingency is activated.
