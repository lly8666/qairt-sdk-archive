# REV46 project global context and fault evolution

## Mission
This MeanVC2 REV46 workstream is the Vocos/QNN HTP numerical-qualification and recovery path for the Android project in **`lly8666/SimAdmin-Android`**. The goal is not merely to make a sliced graph run: it is to obtain full cold4/warm6 Vocos execution under strict QNN/HTP ownership and no CPU fallback, satisfying the frozen numerical gate before production APK/device qualification.

Frozen gate: max_abs <= 3e-4, mean_abs <= 1e-5, rmse <= 2e-5, cosine >= 0.99999; >=3% is the frozen material-improvement threshold. The target phone is final numerical truth but intentionally the last debugger/gate. QNN CPU is host diagnostic/reference evidence, not HTP truth.

## Fault evolution
1. Recovery Matrix v3 separated bootstrap/runtime contamination from real graph failures. Historical full Vocos and standalone canonical GELU passed strict QNN; stale activation/Q16 negatives were closed as bootstrap-contaminated.
2. Exact focused-v2 block4 remained a real graph-specific device rejection: unsupported `Erf` plus shape-info failures. This does not prove GELU unsupported. QAIRT 2.44 also has a separate host converter MATMUL_TO_FC KeyError on that exact graph; do not conflate host SDK failure with HTP capability.
3. Full-Vocos QNN-CPU numerical localization identified block4 as the first major drift injection. An equivalent decanonicalized activation expression nearly removed that drift while preserving ORT semantics, proving graph lowering/topology can materially change QNN floating-point behavior.
4. After block4 recovery, final-head isolation showed the output head itself was clean relative to its input. Block7 PW2 and most of block6 mainly amplified an upstream sensitive direction. Exact propagation attribution identified block5 PW2 as the first clearly actionable remaining intrinsic backend source.
5. Block5 PW2 K-splitting validated the attribution. Contiguous K8 materially reduced the dominant error. Later nonperturbing full47 `/Add_22` taps showed K8 local RMSE improved on 47/47 real warm blocks even though final spectrum worsened on a minority, proving a stable local block5 improvement plus downstream anisotropic error-direction amplification.
6. K8-conditioned block6 topology changes improved discovery/validation subsets but the best activation rewrite failed the final warm18 challenge; block7 interaction did not rescue it.
7. Keeping the same eight K8 partial MatMuls while changing only the seven Add reduction edges showed that reduction association controls the QNN residual direction. A static weight-norm-balanced tree survived preregistered Stage1 -> Stage2 -> Stage3 and became the current host best.
8. A nonperturbing 8-partial QNN tap then enabled an exhaustive 315-balanced-tree intermediate proxy search without reading final spectrum or warm18. Three A/B/C proxy-selected trees have passed ORT1.27 Stage1 semantic gates; their QNN full-graph Stage1 is the current exact breakpoint.

## Current best-supported causal model
`block4 representation/lowering` was the first historical major injection -> block4 was structurally recovered -> `block5 PW2 accumulation` became the first actionable remaining intrinsic source -> K8 reduces that source robustly -> downstream layers amplify the direction, not only magnitude, of the remaining FP residual -> K8 partial reduction association is currently the most evidence-supported exact/equivalent lever.

## Closed/invalidated directions
Do not casually reopen: bootstrap-contaminated activation/Q16 negatives; final-head rewrites after head isolation; block7 PW2 local rewrites after attribution; losing block5 K2/K4/K16 branches; block5 permutation family; redundant orig+K8/multipath averaging; K8-conditioned block6 activation winner after Stage3 failure; b6 x b7 activation interaction; synthetic Holdout A as a promotion judge (stress only); extracted suffix propagation as authoritative evidence (cut-graph ORT drift).

## Historical wider-student/surrogate plan
Earlier `SimAdmin-Android/HANDOFF_NEXT_AGENT.md` proposed learned residual correction / wider multi-block or full-Vocos student if exact structural recovery stalled. That plan remains a contingency and is not forgotten, but later host evidence found a more specific exact/equivalent causal path that is still producing material improvements, so it is not the current primary branch.