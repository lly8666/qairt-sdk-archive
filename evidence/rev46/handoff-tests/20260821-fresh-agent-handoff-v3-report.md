# REV46 Fresh-Agent Handoff-v3 Recovery Audit — 2026-08-21

## Verdict

**PASS WITH MINOR STRUCTURAL RISKS — 98/100.**

This audit was performed as a pure fresh-agent handoff restoration test, not as development. The first and only entry point was `lly8666/SimAdmin-Android/CURRENT_REV46_HANDOFF.md`, after which only current handoff-v3 pointers were followed. No model inference, ORT/QNN science run, QAIRT conversion/build, APK build, device test, resume script, or existing handoff/model/workflow/experiment modification was performed.

The local `/mnt/data/rev46_sandbox` is absent in this environment. Per handoff-v3 policy, this was **not** treated as a handoff failure. Exact state was restored read-only from `lly8666/qairt-sdk-archive/evidence/rev46/handoff-v3/EXTERNAL_RESUME_SNAPSHOT.json` and its explicitly linked v3 files. The external package repeatedly and unambiguously states that it is restoration/audit authority only: science execution remains blocked until the local environment/artifacts are reconstructed and a local validator prints `HANDOFF_V3_VALID`.

## Score — TEST_AGENT_PROTOCOL.md 100-point rubric

| Category | Score | Audit result |
|---|---:|---|
| Main/support repositories + authority roles | 8/8 | Fully recovered and unambiguous. |
| Project mission + full causal fault map | 16/16 | Full bootstrap → block4 → block5 PW2 → K8 → downstream direction amplification → reduction-tree conditioning → partial-guided family evolution recovered. |
| Current best + gate + remaining gap | 10/10 | Exact construction, path, SHA, full47 metrics, failing max gate and 27.097845% remaining reduction recovered. |
| Exact active experiment + candidate SHA/stage boundary | 14/14 | Hypothesis, A/B/C IDs/SHA, protected selection boundary, ORT-complete/QNN-not-started state recovered. |
| Exact-next uniqueness and safety | 10/10 | Exactly one logical next action recovered, plus explicit forbidden actions and the stronger sandbox-absent execution block. |
| NEXT_HORIZON H1–H4 + anti-rabbit-hole reasoning | 18/18 | All four nodes and distinct pass/fail exits recovered, including tree-family closure and route-switch logic. |
| Roadmap + contingency route switch | 10/10 | Host numerical → structural → device → production route and learned/student/surrogate contingency recovered. |
| Layout/provenance/recovery/disaster behavior | 9/9 | ORT/QNN physical/logical layout, invalid evidence, recovery anchors, sandbox-loss rules and validator boundary recovered. |
| Ambiguity/staleness detection | 3/5 | No scientific-state contradiction found, but several structural clarity/integrity risks remain; detailed below. |
| **Total** | **98/100** | **Pass; no hard cap triggered.** |

---

# NORTH STAR — global restoration

## Repository authority and mission

The **main project / production authority is `lly8666/SimAdmin-Android`**. It owns the Android app and `MeanVc2QnnLab`, Java/native runtime, manifests/native-library declarations, QNN provider policy, strict CPU-fallback disablement, platform/device/partition probes, product model/fixture contracts, APK construction, target-phone evidence, integration and release decisions.

The **supporting host-science/evidence/recovery authority is `lly8666/qairt-sdk-archive`**. It stores the QAIRT/ORT host foundation, reproducible host experiments, numerical evidence, recovery metadata, and handoff QA. It is not Android production authority.

`/mnt/data/rev46_sandbox` is disposable execution-time host state. A matching SHA-verified handoff-v3 sandbox can become the execution-time NOW authority only after its validator succeeds; it never supersedes the main repository for product/device authority.

REV46’s mission is to qualify a **full Vocos cold4/warm6 path under strict QNN ownership/no CPU fallback**, first against the frozen host numerical gate, then through host structural qualification, and only then through final phone/HTP qualification before production integration in `lly8666/SimAdmin-Android`.

Frozen host numerical gate:

- `max_abs <= 3e-4`
- `mean_abs <= 1e-5`
- `rmse <= 2e-5`
- `cosine >= 0.99999`
- host changes require at least **3% tracked improvement** to count as material

The **phone/HTP is final numerical truth**. **QNN CPU is only a host diagnostic/ranking proxy**, not an HTP simulator and not a substitute for target-device truth. This separation prevents a host-only numerical win from being misrepresented as device qualification.

## Complete causal fault evolution

1. **Bootstrap/runtime uncertainty was separated from graph truth.** Recovery Matrix v3 re-established platform/QNN bootstrap health with strict CPU fallback disabled. Historical full Vocos and standalone canonical GELU executed successfully, so old activation/Q16 negatives were reclassified as bootstrap-contaminated rather than durable graph-capability evidence.

2. **Focused block4 remained a real graph-specific rejection.** The exact focused block4 graph saw unsupported `Erf` plus shape-info failures. That did not prove GELU itself unsupported because standalone canonical GELU had passed. Separately, QAIRT 2.44’s `MATMUL_TO_FC KeyError` was identified as a host converter limitation, not target HTP capability evidence.

3. **Full-Vocos localization identified block4 as the first major numerical injection.** QNN-CPU residual/tap analysis showed the first material end-to-end drift jump at block4. A mathematically equivalent decanonicalized activation nearly removed that large drift while preserving ORT semantics, demonstrating that graph representation/lowering can materially change QNN floating-point behavior even under real-arithmetic equivalence.

4. **The final head was exonerated and blocks 5–7 were traced backward.** Head isolation showed the final spectrum head was clean relative to its input. Block7 PW2 and much of block6 were primarily amplifying an upstream sensitive error direction rather than creating the first intrinsic residual.

5. **Block5 PW2 became the first actionable remaining intrinsic source.** Clean-downstream propagation and intrinsic-QNN attribution isolated block5 PW2 accumulation as the earliest clearly actionable remaining backend source in the final-sensitive direction.

6. **Contiguous K8 validated the block5 diagnosis.** Block5 PW2 was split along K into eight 192-wide partial MatMuls. This materially reduced the dominant local error while preserving semantics. Nonperturbing full47 `/Add_22` taps later showed K8 improved block5-local RMSE on **47/47** real warm blocks. Because final output still regressed on a minority, K8 was established as a robust local source reduction, not a complete end-to-end solution or a warm18-specific patch.

7. **Downstream anisotropic error-direction amplification became central.** The 47/47 local improvement plus mixed final-spectrum behavior proved that downstream layers amplify the residual’s **direction**, not merely its norm. K8-conditioned block6 topology could look good in discovery/validation yet failed the protected warm18 challenge; block7 interaction did not rescue it.

8. **Reduction-tree association became the successful exact/equivalent lever.** With the same eight K8 partial MatMuls fixed, changing only the seven Add associations changed QNN residual direction. The preregistered static weight-norm-balanced leaf order `[0,5,1,4,2,7,3,6]` survived Stage1 → Stage2 → Stage3 and became the current host best.

9. **Current family: partial-guided balanced-tree transfer.** An 8-partial internal QNN tap passed the observer-effect gate: adding the taps left final outputs bit-exact. Using those real QNN partials, all 315 balanced eight-leaf trees were ranked only on intermediate Add22 error on a protected discovery subset, without using final spectrum or warm18. Three distinct A/B/C candidates were materialized. All passed ORT1.27 Stage1 semantics; QNN2.44 CPU Stage1 has not begun. The family tests whether intermediate partial-error conditioning transfers end-to-end rather than merely improving a local proxy.

The best-supported causal chain is therefore:

`bootstrap/runtime contamination separation → block4 representation/lowering major injection → block4 recovery → block5 PW2 intrinsic accumulation source → contiguous K8 robust local reduction → downstream direction-sensitive amplification → K8 reduction association conditions residual direction → partial-guided balanced-tree transfer test`.

## Closed / invalid branches that must not be casually reopened

At least the following are explicitly closed or non-authoritative unless new causal evidence invalidates the closure reason:

- **Bootstrap-contaminated activation/Q16 negatives:** closed because later bootstrap recovery showed they were contaminated by runtime/platform state.
- **Final-head rewrite families:** closed because head isolation exonerated the final spectrum head as the primary source.
- **Block7 PW2 as primary intrinsic source:** closed because tracing showed it mainly amplifies an upstream sensitive direction.
- **Block5 K2/K4/K16 width variants:** closed relative to K8; K8 is the evidence-backed robust local configuration.
- **Block5 channel permutations:** closed after failure to provide the needed causal/material leverage.
- **`orig+K8` / redundant multipath averaging:** closed as an unsuccessful exact/equivalent branch.
- **K8-conditioned block6 activation topology:** closed after Stage3/protected warm18 failure; discovery success does not override challenge failure.
- **Block6×block7 activation interaction:** closed because block7 interaction did not rescue the mechanism.
- **Extracted-suffix propagation metrics:** non-authoritative because graph cutting changed ORT downstream optimization context, producing about `6.58e-5` reference drift.
- **Synthetic Holdout A:** stress-only, off-manifold evidence; not a promotion judge. Holdout B remains sealed/unexecuted.
- **Recovery-only missing-c15 Horner run (`max ~0.0007061958`):** invalid.
- **Historical full47 semantic result around `24.879`:** invalid due mismatched provenance.
- **Focused block4 `MATMUL_TO_FC KeyError`:** host converter evidence only, not HTP capability truth.

## Host → device → production route

**Phase A — host numerical recovery:** exact/equivalent families must be causally motivated, preregistered, semantic-pass, staged, protected from warm18/final-device fitting, and closed on failed exit rules.

**Phase B — host qualification after numerical gate passes:** qualify cold4 semantics/numerics, full warm47 aggregate, graph contract, QAIRT converter/model-lib, QNN CPU plus Saver/compiled structural evidence, ownership/fusion/no-fallback invariants, and required nonfinal heldout/stress checks. Passing max on one warm sample is not enough.

**Phase C — final target-device qualification:** only after Phase B, return to `lly8666/SimAdmin-Android`, build the minimal strict diagnostic/integration APK, preserve platform/partition probes, model/dependency SHA locks, JSON export, and strict CPU-fallback disablement, then run the frozen target-device A/B/C protocol. The phone/HTP decides final numerical truth.

No threshold relaxation and no CPU fallback may convert a host failure into a device run.

## Preserved contingency

The exact/equivalent route is intentionally bounded, not sacred. A preserved **learned residual / wider multi-block or full-Vocos student / qualified surrogate** route becomes active when causally distinct exact/equivalent mechanisms are exhausted, the remaining residual appears irreducible under supported compiled-QNN exact topology, or later HTP evidence reveals a mechanism host exact topology cannot control.

If that contingency is activated, final device A/B/C and seed `20260814` remain excluded from fitting/search; QNN CPU remains diagnostic rather than HTP truth; historical negative revisions must be used to qualify any surrogate before positive selection; and device remains the final gate.

---

# NOW — exact restored breakpoint

## Current host best

Construction: block5 PW2 contiguous K8 using the same eight 192-wide partial MatMuls, with a static weight-balanced Add reduction leaf order `[0,5,1,4,2,7,3,6]` chosen from static chunk-weight L2 norms.

Model path:

`current_host_best/vocos_warm6_rev46_hostbest_weight_balanced.onnx`

Model SHA256:

`a584d4c8e7a05bc36fb06b653c398547b525e15d5a996fc4d7f3dd612db5b774`

Full47 QNN2.44-vs-ORT1.27 metrics:

- `max_abs = 0.0004115104675292969`
- `mean_abs = 3.777641009158933e-7`
- `rmse = 3.096381567930808e-6`
- `cosine = 0.9999999999856087`
- peak: `warm18 spec_imag[0,18,4]`

Semantic comparison is PASS, including `max_abs = 0.00010180473327636719`, `rmse = 1.450704754473784e-6`, and `cosine = 0.9999999999969523`.

The frozen `max_abs <= 0.0003` gate still **fails**. The remaining relative max reduction required is **27.0978447276941% (~27.1%)**.

## Active experiment

Experiment ID:

`k8_partial_guided_tree_family_stage1_final_qnn`

Hypothesis: with the same eight contiguous-K8 partial MatMuls fixed, reduction association changes QNN residual direction; balanced trees selected only from nonperturbing intermediate Add22 partial-QNN proxy error may improve full-graph final-spectrum error without fitting warm18.

Scientific boundary: A/B/C selection used the intermediate Add22 proxy only. Final spectrum and warm18 were not used for candidate selection, and `warm18_seen_by_candidates = false`.

Frozen Stage1 blocks:

`[1,8,9,10,12,13,19,24,28,32,33,37,38,42,45]`

Candidates and exact SHA256:

- `A_local_max` — `550e82dea9548ed7ec9a2580f493ccaf656b52de578351609ec778adb831782d`
- `B_local_rmse` — `eb6a9f3787216031de9f94165ad6347857e9364ad782060aa7692df5dafcbde5`
- `C_p90_blockmax` — `bbeb2b7a38ed4e30b407268d36fa8b0708dc3899ccfcefb8639bc5187f00306a`

Completed stage state:

- A/B/C ORT1.27 Stage1 semantic gate: **complete, all PASS**.
- QNN2.44 CPU Stage1: **not started**.
- Stage2: **not started / unauthorized before a unique Stage1 material winner**.
- Stage3/warm18: **not started / protected**.
- full47 for this family: **not assembled/scored**.
- APK/device: **BLOCKED**.

## Unique logical exact-next

The handoff’s single logical next science action is:

**QNN2.44 CPU full-graph Stage1 for exactly `A_local_max`, `B_local_rmse`, and `C_p90_blockmax` on the frozen 15-block Stage1; do not rerun ORT; compare final spectrum against the current weight-balanced host best; apply the preregistered Stage1 promotion rule; do not open Stage2 unless exactly one material winner passes.**

This audit did **not** execute that action because the local sandbox is absent. Under cross-sandbox recovery rules, `EXACT_NEXT.allowed=true` describes the restored stage state, not permission to execute science directly from the external snapshot.

Explicitly forbidden/re-run actions include:

1. rerun A/B/C ORT Stage1;
2. run Stage2 before Stage1 scoring and unique-winner promotion;
3. run Stage3/warm18 early;
4. build an APK;
5. run a device test;
6. reopen closed families without new causal evidence;
7. regenerate current Stage1 inputs;
8. reinterpret QNN physical input buffers as ORT raw tensors;
9. relax numerical thresholds or enable CPU fallback;
10. execute any science from the external snapshot before local reconstruction and `HANDOFF_V3_VALID`.

## ORT/QNN layout contract

- ONNX/ORT warm input logical shape: **`[1,80,6]`**.
- QNN warm input: use the already-prepared **physical raw buffers** referenced by the frozen QNN input list; do not reinterpret them as ORT raw tensors.
- QNN full-Vocos output physical shape: **`[1,6,321]`**.
- ORT output logical shape: **`[1,321,6]`**.
- Before scoring: reshape QNN output to `[1,6,321]`, then transpose `(0,2,1)` to logical `[1,321,6]`.
- Current Stage1 input list: `k8_reduce_tree_family/split/stage1_qnn_input_list.txt`.
- Current Stage1 inputs must **not** be regenerated.
- Authority warm18 QNN physical-input SHA256: `5b425b7e31a80d33dfb135059593549781fdccd56ff1691f1965255d888b5dea`.

## Recovery anchors

QAIRT/QNN host foundation:

- release `20260820.1`
- asset `qairt244-native-host-foundation-v4.tar.gz`
- SHA256 `44753f03f7b2c0a21ff751258137a3673321bbd10aaa8817ebf1f00badb17b22`

Focused-v2 payload:

- release `20260820.1`
- asset `rev46-block4-focused-payload-v2.tar.gz`
- SHA256 `42493454ece1060a5100f28e5bf35a15d09bb48f8b46f82c5b69a12fd0f6a1c9`

ORT1.27 portable authority runtime:

- workflow commit `e636bbe153b40d4f58c40cfd66657f11220af316`
- successful run `32380173792`
- artifact `9410680465` (ephemeral; if expired, rerun the exact pinned workflow rather than changing versions)
- Python 3.11 / numpy 1.26.4 / onnx 1.17.0 / onnxruntime 1.27.0

Authority Vocos assets:

- source release `20260820.2`
- source APK SHA256 `f0041f9994413b3fac496612bd15e3da922c4b6ff3712da51d81326b717dc86c`
- staging workflow commit `7a091c6a3e546c9e26f42fe0a3e11dc39d7cd37b`
- successful run `32429883214`
- reconstructed rev25 warm6 required SHA256 `e2b7ab608a6b37a6dd9896589719cab446edf95287f59dfc7b5693da6ec98f6c`

Required recovery fingerprints include the warm18 physical input SHA above, contiguous-K8 warm18 max `0.0004279613494873047`, current-best full47 max `0.0004115104675292969`, current-best model SHA, and exact A/B/C SHA values.

---

# NEXT HORIZON — H1 → H4

## H1 — current A/B/C QNN Stage1

After a valid local reconstruction only, run QNN2.44 CPU Stage1 for exactly A/B/C on the frozen 15 blocks. This tests whether the intermediate partial-guided tree selector transfers to full-graph final-spectrum improvement without using warm18.

- **Pass:** if exactly one preregistered material winner exists, only that winner may open Stage2.
- **Fail:** if there is no unique material winner, close the partial-guided balanced-tree selector mechanism. Do not add selectors, leaf orders, or extra trees after observing results.

## H2 — unique winner-only Stage2

Only the H1 unique winner may run Stage2 on frozen validation blocks under the preregistered non-regression/material rule.

- **Pass:** that winner may open Stage3 challenge.
- **Fail:** close the candidate/family. Do not rescue it by tuning against Stage2.

## H3 — Stage3/warm18 challenge and full47 assembly

Only the Stage2 winner may enter Stage3 including warm18. Then assemble full47 from the three preregistered stages **without rerunning already-scored blocks**.

Three outcomes have different required handling:

1. **Material improvement + full47 max gate passes (`<= 3e-4`):** promote and immediately leave search mode for Phase B host qualification.
2. **Material improvement but max gate still fails:** promote the new host best, then perform a **fresh nonperturbing causal localization/conditioning diagnostic before proposing any new family**. Do not simply continue reduction-tree enumeration.
3. **No material improvement:** close the current tree mechanism.

## H4 — after the current tree mechanism

If the tree mechanism closes, or if it yields a better model that still remains above `3e-4`, the next action is not “try another tree.” First perform a fresh causal diagnostic on the then-current host best to identify a genuinely distinct remaining intrinsic source or downstream amplification mechanism.

Any subsequent exact/equivalent family must be justified by new evidence, distinguish itself causally from closed mechanisms, preserve protected-data boundaries, define material success and closure criteria in advance, and state plausible leverage toward the remaining gap.

**Default budget after the current tree mechanism: at most ONE further causally distinct exact/equivalent family**, unless new evidence materially changes the causal model. If no credible distinct mechanism is supported, or that additional family fails the material-improvement gate, declare the exact/equivalent route causally exhausted and switch to the preserved learned-residual / wider-student / qualified-surrogate contingency.

## Why reduction trees cannot be enumerated indefinitely

The current host best is still approximately **27.1%** away from the frozen max gate. The project’s own materiality threshold is **3%**. Therefore a sequence of sub-material micro-improvements is not a complete strategy for bridging the remaining gap, even if the equivalent-tree search space is easy to enumerate.

More importantly, the current A/B/C family already asks the scientifically relevant question: whether a protected intermediate partial-error proxy selects reduction association that transfers to the final spectrum. Once that transfer mechanism fails its preregistered exits, adding more selectors or warm18-aware trees changes the activity from causal testing into result-conditioned search, increasing overfitting/protected-data leakage risk without evidence of leverage toward a ~27% max reduction.

The correct anti-rabbit-hole behavior is therefore: **finish the bounded tree mechanism → re-localize causally → allow at most one genuinely distinct exact/equivalent family by default → switch route if material progress stalls.**

---

# Sandbox-loss recovery audit

Observed environment state: `/mnt/data/rev46_sandbox/handoff_v3` and `/mnt/data/rev46_sandbox` are absent.

This does **not** fail the handoff. The main pointer, `READ_FIRST.md`, `REPOSITORY_MAP.md`, `ROADMAP_AND_DECISION_TREE.md`, `EXTERNAL_RESUME_SNAPSHOT.json`, `RESTORE_FROM_EXTERNAL_SNAPSHOT.md`, `EXTERNAL_INTEGRITY_MANIFEST.json`, and `TEST_AGENT_PROTOCOL.md` consistently define the external package as exact restoration/audit authority while explicitly denying execution authorization.

The required recovery sequence is clear: restore the pinned QAIRT/QNN foundation; restore exact ORT1.27 runtime; restore authority Vocos assets; reproduce rev25 warm6/input fingerprints; reconstruct K8/current best; reconstruct A/B/C with exact SHA; restore stage state; recreate local handoff-v3; then run the local validator. **Only `HANDOFF_V3_VALID` permits returning to the logical exact-next.** If any SHA, fingerprint, layout contract, or stage boundary cannot be reproduced, stop rather than substitute a near-equivalent artifact.

The externally published `validate_handoff.py` content hashes to the expected SHA256 `4d7981c2bfff43807d537ae7fe6f354f0e4bc7f715cc47b9f37637b278cf7c42`. Its checks include required v3 files, repository authority, exact-next action ID, H1 identity, ORT-complete/QNN-not-started stage boundary, exact candidate IDs, candidate/model SHA identities, prereg/proxy/ORT/manifest science-artifact SHA identities, and detection of already-existing Stage1 QNN result directories that would make the handoff stale. Because the sandbox is absent, the validator was **read and audited only, not executed**.

Conclusion for disaster recovery: **cross-sandbox state restoration succeeds, but science remains intentionally blocked in this environment.**

---

# Ambiguities, missing information, and structural rabbit-hole risks

No contradiction was found in the actual scientific breakpoint: main pointer, current state, candidate manifest, external snapshot, exact-next, and next-horizon all agree on the current best, A/B/C identities, ORT-complete/QNN-not-started boundary, and unique logical next action.

However, several structural risks are worth fixing:

1. **Local-vs-external integrity-manifest naming is easy to misread.** `CURRENT_STATE.json` names a local `handoff_v3/HANDOFF_INTEGRITY_MANIFEST.json`, while the published cross-sandbox package contains `EXTERNAL_INTEGRITY_MANIFEST.json`. The current validator does not depend on the local manifest name, so this is not a recovery failure, but a fresh agent could waste time looking for a published file that does not exist under the local name. Improvement: encode explicit `local_integrity_manifest_path` and `external_integrity_manifest_path` fields, with a one-line mapping in the restore document.

2. **`EXACT_NEXT.allowed=true` is locally meaningful but can be misread after sandbox loss.** The surrounding documents clearly override direct execution, but an overly command-oriented agent could cherry-pick `allowed=true` and ignore the reconstruction prerequisite. Improvement: replace or augment it with a machine-readable precondition such as `execution_authorized_only_if: HANDOFF_V3_VALID`, and set an external-snapshot field such as `science_execution_authorized=false`.

3. **The local validator strongly locks science artifacts but does not hash-lock the bytes of critical local handoff documents.** It checks that files such as `ENVIRONMENT_AND_LAYOUT.md` exist, but publication-document integrity is delegated to the external manifest rather than directly compared during local validation. An accidentally edited local layout/forbidden-actions document could therefore coexist with a validator pass if science artifact identities remain intact. Improvement: make the validator verify SHA256 or immutable publication identity for at least `EXACT_NEXT.json`, `CANDIDATE_MANIFEST.json`, `ENVIRONMENT_AND_LAYOUT.md`, `NEXT_HORIZON.json`, and `ANTI_RABBIT_HOLE.md` against a reconstructed local integrity index.

4. **Recovery is exact but multi-hop.** Candidate/prereg/proxy/ORT science artifacts are SHA-locked, yet the external handoff package is metadata/reconstruction authority rather than a complete payload bundle. This is intentional and safe because the validator refuses substitutions, but it raises operational recovery cost. Improvement: add a machine-readable restore bundle index mapping every validator-required artifact to one immutable release/workflow/script source plus expected SHA.

5. **The ORT authority artifact is explicitly ephemeral.** The handoff correctly says to rerun the exact pinned workflow if artifact `9410680465` expires, so correctness is preserved, but recovery has an availability dependency. Improvement: mirror the resulting portable authority runtime to a long-lived immutable release asset while retaining the pinned-workflow fallback.

These are **structural usability/integrity risks, not evidence that the current state is ambiguous**. The anti-rabbit-hole policy itself is unusually explicit: the current tree mechanism is bounded, failed branches have closure rules, a fresh causal re-localization is mandatory afterward, and only one further causally distinct exact/equivalent family is allowed by default before route switch. That structure should materially reduce the chance that a later development agent keeps enumerating reduction trees.

---

# Final assessment

A completely fresh agent can recover more than a single command from handoff-v3. It can reconstruct:

- **NORTH STAR:** authority, mission, frozen gates, CPU-vs-HTP truth hierarchy, full causal history, closed branches, host→device→production route, and contingency;
- **NOW:** exact current best and metrics, candidate identities/SHA, protected stage boundary, layout/provenance, invalid evidence, recovery anchors, and exactly one logical next action;
- **NEXT HORIZON:** H1→H4 with winner-only progression, distinct Stage3/full47 outcomes, mandatory post-tree causal re-localization, one-family default budget, and learned/student/surrogate route-switch conditions;
- **sandbox-loss behavior:** external restoration is sufficient for audit but explicitly insufficient for science execution until local artifacts/environment are rebuilt and `HANDOFF_V3_VALID` is obtained.

The handoff therefore passes the fresh-agent restoration objective. The remaining improvements are primarily about making the already-correct authorization and integrity model harder for a later command-focused agent to misinterpret.