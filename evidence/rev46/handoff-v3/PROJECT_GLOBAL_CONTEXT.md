# REV46 project global context

## Mission
REV46 is the Vocos/QNN HTP numerical-qualification and recovery workstream for the MeanVC2 Android project in **`lly8666/SimAdmin-Android`**. The goal is a full cold4/warm6 Vocos path under strict QNN ownership/no CPU fallback that satisfies the frozen numerical gate before any final Android/device qualification.

Frozen host numerical gate:
- max_abs <= 3e-4
- mean_abs <= 1e-5
- rmse <= 2e-5
- cosine >= 0.99999
- >=3% tracked improvement is required to call a host change material.

The phone/HTP is final numerical truth but is intentionally the **last** debugger/gate. QNN CPU is a host diagnostic/ranking proxy, not an HTP simulator.

## Why the project reached REV46
Earlier revisions showed deterministic input-dependent numerical residuals under QNN/HTP even for graph rewrites that are mathematically equivalent in real arithmetic. REV46 therefore moved from local point fixes to compiled-topology-aware, provenance-locked, staged numerical science. A wider learned residual/student/surrogate route remains preserved as a contingency if exact/equivalent topology recovery is causally exhausted.

## Causal fault evolution

### 1. Bootstrap/runtime uncertainty was separated from graph truth
Recovery Matrix v3 re-established platform/QNN bootstrap health with strict CPU fallback disabled. Historical full Vocos and standalone canonical GELU executed successfully. Old activation/Q16 failures were rechecked and closed as bootstrap-contaminated.

### 2. Focused block4 was still a real graph-specific rejection
The exact focused block4 graph produced graph-capability rejection with unsupported `Erf` plus surrounding shape-info failures. This did **not** prove GELU itself unsupported because standalone canonical GELU had already passed. Separately QAIRT 2.44 hit a host `MATMUL_TO_FC KeyError`; that converter bug is not target HTP capability evidence.

### 3. Full-Vocos host localization found block4 as the first major numerical injection
QNN-CPU residual/tap diagnostics showed block4 as the first material end-to-end drift jump. A mathematically equivalent decanonicalized activation expression nearly eliminated that large drift while preserving ORT semantics. This established that equivalent graph topology/lowering can materially alter QNN floating-point behavior.

### 4. The final head was exonerated; blocks 5–7 were traced backward
Head isolation showed the final spectrum head was numerically clean relative to its input. Block7 PW2 and much of block6 mainly amplified an upstream sensitive direction rather than creating the first intrinsic error.

### 5. Block5 PW2 became the first actionable remaining intrinsic source
Clean-downstream propagation and intrinsic-QNN attribution isolated block5 PW2 accumulation as the first clearly actionable remaining backend source in the final-sensitive direction.

### 6. Contiguous K8 validated the block5 diagnosis
Splitting block5 PW2 along K into eight 192-wide partial MatMuls materially reduced the dominant error while preserving semantics. Nonperturbing full47 `/Add_22` taps later showed K8 improved block5-local RMSE on **47/47** real warm blocks, even though final output still regressed on a minority. Therefore K8 is a robust local source reduction, not merely a warm18 patch.

### 7. Downstream anisotropic amplification became central
The mismatch between 47/47 local RMSE improvement and mixed final-output behavior showed that downstream layers amplify the **direction**, not simply magnitude, of the residual. K8-conditioned block6 topology could improve discovery/validation but failed the protected warm18 challenge; block7 interaction did not rescue it.

### 8. Reduction-tree association became the successful exact/equivalent lever
Holding the same eight K8 partial MatMuls fixed while changing only the seven Add associations changed QNN residual direction. A preregistered static weight-norm-balanced tree `[0,5,1,4,2,7,3,6]` survived Stage1 -> Stage2 -> Stage3 and became the current host best.

Current host best full47 QNN2.44-vs-ORT1.27:
- max_abs `0.0004115104675292969`
- mean_abs `3.777641009158933e-7`
- rmse `3.096381567930808e-6`
- cosine `0.9999999999856087`
- model SHA256 `a584d4c8e7a05bc36fb06b653c398547b525e15d5a996fc4d7f3dd612db5b774`

It still fails the max gate. About **27.1%** relative max reduction is still needed.

### 9. Active family: partial-guided balanced trees
An 8-partial internal QNN tap passed the observer-effect gate: final outputs remained bit-exact after adding taps. Using those real QNN partials, all 315 balanced eight-leaf reduction trees were ranked only on intermediate Add22 error on a protected discovery subset, without using final spectrum or warm18. Three distinct A/B/C trees were materialized and all passed ORT1.27 Stage1 semantics. Their QNN2.44 full-graph Stage1 has not started.

Best-supported causal model NOW:
`block4 representation/lowering major injection -> block4 structural/numerical recovery -> block5 PW2 accumulation intrinsic source -> K8 robust local reduction -> downstream direction-sensitive amplification -> K8 partial reduction association conditions residual direction -> current intermediate-partial-guided tree family tests whether that conditioning transfers end-to-end`.

## Closed or non-authoritative branches
Do not casually reopen without new causal evidence:
- bootstrap-contaminated activation/Q16 negatives;
- final-head rewrite families;
- block7 PW2 as the primary source;
- block5 K2/K4/K16 width variants relative to K8;
- block5 channel permutations;
- orig+K8/redundant multipath averaging;
- K8-conditioned block6 activation topology after Stage3 failure;
- block6×block7 activation interaction;
- synthetic Holdout A as a promotion judge (stress only);
- extracted-suffix propagation as authoritative evidence (cut-graph ORT drift);
- old mismatched-provenance full47 semantic result and recovery-only missing-c15 run.

## Strategic interpretation
This is **not** arbitrary hyperparameter search. Each family must be causally motivated, preregistered, semantic-pass, staged, and closed if it fails its exit rule. Because the remaining max gap is ~27%, endless sub-material local tweaks are not a viable plan. The current tree mechanism is bounded; if it stops transferring to final-spectrum material improvement, the project must re-localize a distinct mechanism or switch to the preserved learned residual/wider-student/surrogate contingency rather than drill deeper into equivalent-tree enumeration.