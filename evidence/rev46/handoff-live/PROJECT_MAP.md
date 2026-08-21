# MeanVC2 REV46 — compact project map

Main/production authority: `lly8666/SimAdmin-Android`.
Host-science/evidence/recovery authority: `lly8666/qairt-sdk-archive`.

## North star
Qualify the full Vocos cold4/warm6 path under strict QNN ownership and no CPU fallback. Frozen host numerical gate first; host structural/compiled qualification second; target-phone HTP is final numerical truth; Android integration/release returns to the main repository.

Frozen host gate: `max_abs <= 3e-4`, `mean_abs <= 1e-5`, `rmse <= 2e-5`, `cosine >= 0.99999`; material improvement threshold `>=3%`. Final device A/B/C and seed `20260814` are excluded from fitting/search. QNN CPU is diagnostic/ranking evidence, not HTP truth.

## Causal fault map — only the durable chain
1. Bootstrap/runtime uncertainty was separated from graph truth. Full Vocos and canonical GELU/Q16 controls established a healthy strict-QNN foundation; stale activation/Q16 negatives were closed as bootstrap-contaminated.
2. Focused block4 remained a real graph-specific problem. `Erf` rejection and shape-info failures were distinguished from a separate QAIRT `MATMUL_TO_FC` converter bug; neither proves GELU primitive unsupported.
3. Full-model host localization found block4 as the first major numerical injection. A mathematically equivalent activation lowering nearly removed that large QNN drift while preserving ORT semantics.
4. Final-head isolation exonerated the head; backward clean-propagation showed block7 and much of block6 mainly amplify an upstream sensitive direction.
5. Block5 PW2 became the first actionable intrinsic source. Contiguous K8 split reduced its local error; nonperturbing Add22 taps showed K8 local RMSE improves on 47/47 warm blocks.
6. Mixed final-spectrum behavior despite 47/47 local improvement established downstream anisotropic error-direction amplification.
7. Changing only the 7 Add associations of the same eight K8 partial MatMuls materially changed final error. Static weight-balanced reduction became the current host best.
8. Exact/equivalent embed-Conv split4 produced a Stage1 max gain but failed frozen Stage2 on aggregate max regression; exact route closed without warm18 exposure.
9. Add3 low-rank learned residual failed protected validation before holdout. The route therefore moved up to wider student / prefix representation recovery.
10. Corpus audit found zero promotion-eligible independent realistic nonfinal sequences. Wider-student architecture search is blocked until a deterministic multi-sequence nonfinal export path exists.

Current host best: block5 PW2 contiguous K8 + weight-balanced leaf order `[0,5,1,4,2,7,3,6]`; accepted execution SHA `d2efac4f266b312024b0e0b59feeeffa04716dbeaf54ad4763c7950ac9c3fb23`; full47 max `0.0004115104675292969`. About 27.1% relative max reduction still remains to the frozen gate.

## Closed mechanisms — one line each; raw evidence lives outside live handoff
- Bootstrap-contaminated activation/Q16 negatives: invalidated by strict recovery rechecks.
- Final-head rewrites: head clean relative to its input.
- Block7 PW2 as primary source: mainly amplifies upstream error.
- Block5 K2/K4/K16 width variants: inferior to K8; do not reopen without new mechanism evidence.
- Block5 channel permutations: failed generalization/material leverage.
- Redundant orig+K8 averaging: discovery gain did not survive protected validation.
- K8-conditioned block6 activation topology: Stage1/2 gain failed protected Stage3/warm18.
- Block6×block7 activation interaction: no rescue.
- Extracted-suffix propagation: non-authoritative because graph cut changed ORT reference.
- Synthetic Holdout A: stress-only, not promotion authority; Holdout B remains sealed.
- Embed-Conv split4 exact/equivalent route: Stage2 aggregate max regressed 0.3322259%; closed before warm18/device promotion.
- Add3 low-rank linear correction: protected validation failed; holdout and warm18 remained sealed.

## Route
ACTIVE: `WIDER_STUDENT_FOUNDATION`.
Current exact action is not model training: restore the controlled main-repository sandbox, pass the live science validator, then implement the frozen deterministic multi-sequence nonfinal corpus export contract. Do not train/search architecture until realistic nonfinal source breadth exists and a sequence-family split can be frozen. Final device A/B/C, seed `20260814`, Add3 holdout and warm18 remain excluded.

When the numerical gate eventually passes: stop search, perform cold4 + full warm47 + graph-contract + QAIRT/model-lib + QNN CPU/Saver/compiled ownership/fusion/no-fallback + nonfinal heldout/stress qualification. Only after those pass may a strict diagnostic/integration APK and frozen target-device A/B/C be run from `lly8666/SimAdmin-Android`.
