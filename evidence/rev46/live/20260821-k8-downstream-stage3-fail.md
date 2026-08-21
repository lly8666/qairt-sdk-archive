# REV46 K8-conditioned downstream Stage3 challenge — FAIL

Date: 2026-08-21
Host-only; APK/device remains blocked.

The Stage1 winner `b6_reassoc_b7_lohi` passed the preregistered Stage2 validation and therefore was the only candidate allowed to open Stage3 (16 blocks including warm18).

## Stage3 candidate-own QNN2.44 vs ORT1.27
Candidate:
- max_abs `0.0004425048828125`
- mean_abs `4.3414375037859624e-07`
- rmse `4.147132503973305e-06`
- cosine `0.9999999999745972`
- peak warm18 `spec_imag[0,18,4]`

Frozen contiguous block5-PW2 K8 baseline:
- max_abs `0.0004279613494873047`
- mean_abs `4.323324123997489e-07`
- rmse `4.05162453859969e-06`
- cosine `0.9999999999757578`
- same peak warm18 `spec_imag[0,18,4]`

Candidate regression vs K8:
- max_abs: `-3.3983%` improvement (i.e. 3.3983% worse)
- RMSE: `-2.3573%` improvement (i.e. worse)

Semantic vs decanonicalized authority remains PASS; max_abs `8.821487426757812e-05`.

Stage3 report SHA256: `1de3429a1e2df98a8d8611f2c809cd2e02789403f7690ee44b3206f507d10d9a`
Winner model SHA256: `cd992d6f57dce5b84d27ed732b39d86015fe4b308d89dc53f92ae762f2df7bb7`

## Decision
Do NOT promote `b6_reassoc_b7_lohi`. Current numerical best remains contiguous block5-PW2 K8 (`0.0004279613494873047`).

The original preregistration explicitly allowed a combined b6+b7 interaction family only after a single-coordinate candidate passed Stage2. That condition is now satisfied. Next authorized experiment: fix b6=reassoc and vary b7 topology on Stage1, winner-only Stage2, and only then Stage3. warm18 remains forbidden for selection.
