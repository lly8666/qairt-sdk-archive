# REV46 fresh-agent handoff-v2 restoration report

Date: 2026-08-21
Mode: pure handoff restoration QA only; no development, model inference, QAIRT compile, APK build, or device test performed.

## Result

**Score: 86 / 100**

**Global restoration: PASS.** The main/production authority, project mission, frozen gates, causal failure evolution, closed branches, exact/equivalent roadmap, host qualification requirements, target-device phase, and wider-student/surrogate contingency conditions are recoverable from the published main-repo-first handoff.

**Exact local resume restoration: FAIL in this test environment.** The local handoff root `/mnt/data/rev46_sandbox/handoff_v2` is unavailable, the only permitted validator invocation cannot open `validate_handoff.py`, and the GitHub `evidence/rev46/handoff-v2` package does not contain repository copies of `CURRENT_STATE.json`, `EXACT_NEXT.json`, `EXPERIMENT_LEDGER.jsonl`, `ENVIRONMENT_AND_LAYOUT.md`, or `RECOVERY_ANCHORS.md`. Therefore this agent can reconstruct the published NOW summary and exact-next boundary, but cannot validate the complete local authority, A/B/C SHA set, current layout contract, current invalid-evidence ledger, or current recovery-anchor manifest.

This is **not qualified to resume science execution** because the required validator did not print `HANDOFF_V2_VALID`. No resume script or science command was run.

The protocol hard cap for “only exact-next but no global restoration” does **not** apply: the complete global failure evolution and long-term roadmap were successfully reconstructed.

## Score breakdown

| Category | Score | Reason |
|---|---:|---|
| Main/support repositories + authority roles | 10/10 | Exact roles and precedence recovered. |
| Project mission + full causal fault map | 20/20 | Full bootstrap -> block4 -> block5 -> K8 -> downstream direction -> reduction tree -> partial-guided chain recovered. |
| Roadmap/decision tree + contingency route switch | 15/15 | Exact/equivalent route, host qualification, final device phase, and wider-student/surrogate re-enable conditions recovered. |
| Current best + frozen gate | 10/10 | Path, model SHA, full47 metrics, and failing max gate recovered from published handoff-v2 index and corroborating evidence. |
| Active experiment + stage boundary | 10/15 | Experiment ID, hypothesis, A/B/C IDs, ORT Stage1 completion, and QNN Stage1 breakpoint recovered; candidate SHA values are not externally recoverable from the published handoff package. |
| Exact-next uniqueness | 10/10 | Exactly one science next action is recoverable, and it was not executed by this test agent. |
| Safety/no-rerun/layout constraints | 5/10 | Safety/no-rerun boundary is clear; exact current ORT/QNN layout distinction is trapped in the missing local file. |
| Provenance/hash/recovery validation | 1/5 | Host-best SHA and older durable recovery anchors exist, but current recovery manifest is missing and validator cannot run to validity. |
| Ambiguity/staleness detection | 5/5 | Missing local authority, missing published fallback files, and stale/ambiguous entrypoint naming were detected rather than guessed through. |

## A. Global project restoration

### Repository authority

1. **Main / production authority: `lly8666/SimAdmin-Android`.** It owns the MeanVC2 Android app, `MeanVc2QnnLab`, Java/native runtime, manifests, QNN provider and no-CPU-fallback policy, platform/device/partition probes, APK build/integration, target-phone evidence, product-side fixtures/model contracts, and release decisions.
2. **Supporting host/evidence/recovery repository: `lly8666/qairt-sdk-archive`.** It owns QAIRT/QNN archival, ORT/QAIRT host foundations, reproducible host experiments, numerical evidence, handoff QA, and recovery metadata. It is not the production Android repository.
3. Local `/mnt/data/rev46_sandbox` is ephemeral host-only science state. When present, `handoff_v2/CURRENT_STATE.json` is the host-science NOW pointer; production/device policy still belongs to the main repository.

### Mission and frozen numerical gates

REV46 is the Vocos/QNN HTP numerical-qualification and recovery path for the MeanVC2 Android project. The goal is not to make a sliced graph execute; the north-star is a full cold4/warm6 Vocos model under strict QNN/HTP ownership, no CPU fallback, and frozen numerics before production APK/device qualification.

Frozen numerical gate:

- `max_abs <= 3e-4`
- `mean_abs <= 1e-5`
- `rmse <= 2e-5`
- `cosine >= 0.99999`
- frozen material-improvement threshold: `>= 3%`

QNN CPU is host diagnostic/reference evidence. It is useful for semantic/integration control and ranking mathematically equivalent lowerings, but it is **not an HTP simulator and not final numerical truth**. The target phone/HTP is final numerical truth, deliberately used as the last debugger/gate rather than as fitting/search data.

### Full causal failure evolution

1. **Bootstrap/runtime contamination separated from graph truth.** Recovery Matrix v3 re-established strict runtime/platform health. Historical full Vocos and canonical activation/GELU passed strict QNN, and stale activation/Q16 negatives were rechecked and closed as bootstrap-contaminated rather than valid operator-support failures.
2. **Focused block4 remained a real graph-specific rejection.** Exact focused-v2 block4 showed unsupported `Erf` plus surrounding shape-info failures. This did not prove GELU itself unsupported because canonical GELU had already executed under QNN ownership. Separately, QAIRT 2.44 host conversion hit `MATMUL_TO_FC` `KeyError`; that SDK converter bug must not be mistaken for HTP capability truth.
3. **Block4 numerical lowering became the first large host drift injection.** Full-Vocos QNN-CPU localization found block4 as the first major numerical divergence. A mathematically equivalent/decanonicalized activation expression nearly removed the drift while preserving ORT semantics, showing that graph representation/lowering topology materially changes QNN floating-point behavior.
4. **Head isolation moved the fault upstream.** Final-head isolation showed the output head itself was clean relative to its input. Block7 PW2 and much of block6 primarily amplified an upstream sensitive direction rather than creating the first intrinsic error.
5. **Block5 PW2 became the first actionable remaining intrinsic backend source.** Exact propagation attribution isolated block5 PW2 accumulation (`/MatMul_11 + /Add_22` in the published host audit) as the first clear remaining backend source after block4 recovery.
6. **K8 validated the block5 attribution.** Contiguous K-axis splitting into eight partial MatMuls materially reduced the local error. Nonperturbing `/Add_22` taps later showed K8 local RMSE improved on 47/47 real warm blocks even though final-spectrum results worsened on a minority. This separated stable local improvement from downstream anisotropic amplification.
7. **Downstream error-direction amplification became central.** Block6 topology changes could look good on discovery/validation but fail warm18; block7 interaction did not rescue the winner. The evidence therefore points to downstream layers amplifying the **direction**, not merely scalar magnitude, of the remaining FP residual.
8. **Reduction-tree conditioning became the exact/equivalent lever.** Holding the same eight K8 partial MatMuls fixed while changing only the seven Add reduction edges changed the QNN residual direction. A preregistered static weight-norm-balanced reduction tree survived Stage1 -> Stage2 -> Stage3 and became the current host best.
9. **Current partial-guided A/B/C family.** A nonperturbing 8-partial QNN tap enabled an exhaustive search over 315 balanced reduction trees using intermediate proxy objectives without reading final spectrum or warm18. Three proxy-selected A/B/C candidates passed ORT1.27 Stage1 semantic gates. Their QNN2.44 CPU Stage1 is the current exact breakpoint.

Best-supported causal model:

`block4 representation/lowering major injection -> structural/numerical block4 recovery -> block5 PW2 accumulation intrinsic source -> K8 robust local source reduction -> downstream direction-sensitive amplification -> K8 partial reduction association controls residual direction -> partial-guided balanced-tree search is the active exact/equivalent family`.

### Major closed/invalidated branches and why

The following are explicitly closed or non-authoritative and must not be casually reopened without new causal evidence:

1. **Bootstrap-contaminated activation/Q16 negatives** — strict Recovery Matrix v3 rechecks passed; old failures are invalid as operator-support evidence.
2. **Final-head rewrites** — head isolation showed the head is clean relative to its input; it is not the first intrinsic source.
3. **Block7 PW2 local rewrite family** — attribution showed block7 primarily amplifies upstream error rather than being the first actionable source.
4. **Losing block5 K2/K4/K16 branches** — K8 won the K-splitting attribution experiment; losers do not justify reopening absent new mechanism evidence.
5. **Block5 permutation family** — failed to provide the required general improvement; closed in current global context.
6. **Redundant orig+K8 / multipath averaging** — closed after not providing a durable exact/equivalent win.
7. **K8-conditioned block6 activation winner** — passed earlier discovery/validation but failed preregistered Stage3/warm18 challenge.
8. **Block6 x block7 activation interaction** — did not rescue the Stage3 failure; closed.
9. **Synthetic Holdout A as promotion judge** — stress evidence only, not a promotion authority.
10. **Extracted suffix propagation as authoritative evidence** — cut-graph ORT drift makes it non-authoritative for final promotion.
11. **Historical rev45 gamma-fold/device branch** — valid strict-device negative, already closed; do not rerun as a way back into REV46.

### Current roadmap

**Phase A — ACTIVE host numerical search:** preregister candidate family/splits -> ORT1.27 semantic gate -> QNN2.44 CPU discovery -> unique winner-only validation -> unique validation-winner-only challenge/warm18 -> assemble full47 from staged outputs -> promote only on semantic PASS plus required >=3% material improvement. `EXACT_NEXT.json` is supposed to override generic roadmap sequencing when locally available.

**Phase B — host qualification after numerical max gate passes:** crossing `max_abs <= 3e-4` on one warm case is insufficient. The promoted full model must qualify cold4 semantics/numerics, full warm47 aggregate, graph contract, QAIRT converter/model-lib, QNN CPU and Saver/compiled structural evidence, ownership/fusion/no-fallback invariants, and required nonfinal heldout/stress checks without using final device A/B/C for fitting/search.

**Phase C — target-device qualification:** only after host qualification may a minimal strict diagnostic/integration APK be built from `lly8666/SimAdmin-Android`. Preserve platform/partition probes, SHA locks, JSON export, and strict CPU-fallback disablement. Frozen device A/B/C are final numerical truth. Host failure may not be bypassed by threshold relaxation or CPU fallback.

**Production integration:** any eventual Android model/runtime integration, APK authorization, device probe contract, and release decision returns to `lly8666/SimAdmin-Android`, not the supporting evidence repository.

### Wider-student / learned-residual / surrogate contingency

Historical REV46 planning proposed learned residual correction and progressively wider multi-block/full-Vocos students, beginning around the joint `PW1 -> activation -> PW2 -> residual/downstream` sensitive region. That route remains preserved but is not current because exact/equivalent topology work is still causally productive.

Re-enable the wider residual/student/surrogate route only with documented evidence that one of these conditions is met:

- causally distinct exact/equivalent topology mechanisms are exhausted;
- the residual is irreducible under supported compiled-QNN topology; or
- target HTP evidence reveals a mechanism that exact host-topology changes cannot control.

If re-enabled: final device A/B/C remain excluded from training/search; seed `20260814` remains excluded; QNN CPU remains diagnostic rather than HTP truth; historical negative revisions must qualify the surrogate before positive selection; phone remains the last gate.

## B. Exact local restoration

### Current host best

Published handoff-v2 index identifies:

- path: `current_host_best/vocos_warm6_rev46_hostbest_weight_balanced.onnx`
- SHA256: `a584d4c8e7a05bc36fb06b653c398547b525e15d5a996fc4d7f3dd612db5b774`
- full47 candidate-own QNN2.44 vs ORT1.27:
  - `max_abs = 0.0004115104675292969`
  - `mean_abs = 3.777641009158933e-07`
  - `rmse = 3.096381567930808e-06`
  - `cosine = 0.9999999999856087`

Frozen gate status: **FAIL max only**, because `0.0004115104675292969 > 0.0003`; mean/rmse/cosine satisfy their frozen bounds. APK/device remains **BLOCKED**.

Published durable evidence additionally records parent contiguous-K8 SHA256 `6666708bc3c507dec52da7c452f8618d2c0c64d594f465891e8511cb6696407c`, full47 report SHA256 `23d13c948fd0102cc93d6490f1b7983aa723a586b0c0d4c35d4caf05cd5342bb`, generator SHA256 `9c2e1c66d1f29e38d9a5c6cc56ea706924a5af2f27d87e26a89262be100d5c0d`, and split SHA256 `dab847439dbf2e7f77423b3b7fe18eabc43ecf6a5855de111ca76fb91a73d2b0` for the current weight-balanced host best.

### Active experiment and hypothesis

- active experiment ID: `k8_partial_guided_tree_family_stage1_final_qnn`
- reconstructed hypothesis: with the same eight contiguous-K8 partial MatMuls held fixed, reduction association conditions the QNN residual direction; intermediate nonperturbing partial-QNN proxy objectives can select balanced Add trees that improve the final-sensitive residual without fitting final-spectrum/warm18 error.
- exhaustive 315-balanced-tree proxy search: complete.
- three A/B/C candidates: materialized.
- ORT1.27 Stage1 semantic gate for A/B/C: complete, all PASS.
- QNN2.44 CPU Stage1: **NOT STARTED**.

Candidate IDs recoverable from the published handoff-v2 index:

- A: `A_local_max`
- B: `B_local_rmse`
- C: `C_p90_blockmax`

**Candidate SHA256 values: NOT RECOVERABLE from the published handoff package in this environment.** They are expected in the missing local `CURRENT_STATE.json` / candidate manifest lineage. They must not be guessed.

### Stage boundary

Completed:

- 315 balanced-tree proxy enumeration/search.
- A/B/C candidate materialization.
- A/B/C ORT1.27 Stage1 semantic gates, all PASS.

Not started / not authorized yet:

- A/B/C QNN2.44 CPU Stage1.
- Stage2 winner-only validation.
- Stage3/challenge/warm18 for this family.
- full47 staged assembly/promotion for this family.
- host qualification of any new winner.
- APK/device qualification.

### The one exact next action

The unique **science** exact-next action is:

> Run QNN2.44 CPU Stage1 for exactly `A_local_max`, `B_local_rmse`, and `C_p90_blockmax`.

This test agent did **not** execute that action because `TEST_AGENT_PROTOCOL.md` explicitly forbids model/QNN/ORT inference during handoff QA and explicitly forbids running `resume_A_B_C_qnn_stage1.sh`.

### Forbidden/re-run actions recovered

At least the following are forbidden at this breakpoint:

1. Do not rerun A/B/C ORT1.27 Stage1 semantic gates; they are already complete and all-pass.
2. Do not open Stage2 before QNN Stage1 produces the preregistered winner boundary.
3. Do not open Stage3/challenge early.
4. Do not expose/use warm18 for the current family before its preregistered stage boundary.
5. Do not build or run an APK/device test while the host max gate still fails and host qualification is incomplete.
6. For this handoff QA test, do not run `resume_A_B_C_qnn_stage1.sh`.
7. For this handoff QA test, do not run any model, ORT, or QNN inference, QAIRT compilation, APK build, or device action.
8. Do not use legacy `handoff/LIVE_HANDOFF.md`, old `CURRENT_AGENT_BOOTSTRAP.md`, or old `HANDOFF_NEXT_AGENT.md` as current execution authority.
9. Do not relax frozen thresholds and do not enable CPU fallback to turn a host failure into a phone run.
10. Do not use final device A/B/C fixtures or excluded seed `20260814` for fitting/search.
11. Do not casually reopen closed families without new causal evidence.

### ORT/QNN layout contract

**Current exact ORT/QNN input/output layout distinction is NOT RECOVERABLE in this environment.** The handoff test prompt says this contract is in local `ENVIRONMENT_AND_LAYOUT.md`, but that file is unavailable and no published copy exists in `evidence/rev46/handoff-v2`.

Historical context only (not a substitute for the current layout contract): the older rev46 host semantic harness identifies cold input `[1,80,4]`, warm input `[1,80,6]`, and outputs `spec_real/spec_imag`. Because the current handoff explicitly requires a distinct ORT/QNN layout restoration, this historical shape/output information must not be promoted to current authority without the missing `ENVIRONMENT_AND_LAYOUT.md`.

This missing layout contract is a material handoff defect because a fresh agent could otherwise mis-bind raw QNN inputs/outputs even while using the right model SHA.

### INVALID / NON-AUTHORITATIVE evidence

The exact recent local ledger entries are not recoverable because `EXPERIMENT_LEDGER.jsonl` / current local state are unavailable. The following published global non-authoritative/invalid evidence is nevertheless clear:

- QNN CPU: diagnostic/reference only, not HTP truth.
- stale activation-v3/Q16 negatives: invalidated as bootstrap-contaminated after strict rechecks.
- focused block4 QAIRT `MATMUL_TO_FC` KeyError: host converter limitation, not proof of HTP graph capability.
- synthetic Holdout A: stress-only, not promotion judge.
- extracted suffix propagation: non-authoritative because cut-graph ORT drift changes the reference.
- legacy handoff/bootstrap files: historical context only, not current exact-next authority.
- historical learned-residual/student/surrogate plan: contingency only while exact/equivalent topology remains productive.

### External recovery anchors

The current local `RECOVERY_ANCHORS.md` is unavailable, so its exact current anchor list cannot be validated. Published durable host evidence records at least these earlier disaster-recovery anchors:

- QAIRT 2.44 native host foundation v4 payload SHA256 `44753f03f7b2c0a21ff751258137a3673321bbd10aaa8817ebf1f00badb17b22`.
- focused-v2 payload SHA256 `42493454ece1060a5100f28e5bf35a15d09bb48f8b46f82c5b69a12fd0f6a1c9`.
- relocatable Python 3.11 / numpy 1.26.4 / onnx 1.17.0 / ORT 1.27.0 artifact (the cited audit does not publish its SHA in that paragraph).
- private Recovery Matrix v3 APK SHA256 `dcf598e56061aa9cfa6550699a590f36910503fa371d3237a3b36f2b30ff56ca`, for identity/reference recovery only; not executed on device during the host reset recovery.
- one-shot recovery workflow commit `7a091c6a3e546c9e26f42fe0a3e11dc39d7cd37b`, staging SHA-locked original Vocos cold/warm models, rev25 patches, and raw-mel fixture from public release `20260820.2`.

These anchors demonstrate prior disaster-recovery discipline, but they do **not** replace the missing current `RECOVERY_ANCHORS.md` and do not provide the missing A/B/C current candidate hashes.

## Validator result

Only the explicitly permitted command was attempted:

```text
python3 /mnt/data/rev46_sandbox/handoff_v2/validate_handoff.py
```

Raw result:

```text
python3: can't open file '/mnt/data/rev46_sandbox/handoff_v2/validate_handoff.py': [Errno 2] No such file or directory
```

Conclusion: **validator unavailable; `HANDOFF_V2_VALID` was not obtained.** No resume script was run.

## Ambiguities, stale pointers, and missing information

1. `SimAdmin-Android/CURRENT_REV46_HANDOFF.md` correctly makes the main repository the production authority and says the local `CURRENT_STATE.json` is the sole host-science NOW pointer while the sandbox exists. In this environment the sandbox is absent, but the entrypoint does not provide a complete authoritative fallback path for exact local state.
2. The GitHub `evidence/rev46/handoff-v2` directory contains only `PROJECT_GLOBAL_CONTEXT.md`, `README_FIRST.md`, `REPOSITORY_MAP.md`, `ROADMAP_AND_DECISION_TREE.md`, `TEST_AGENT_PROMPT.md`, and `TEST_AGENT_PROTOCOL.md`. It does not contain the local state/ledger/layout/recovery files required by the test protocol.
3. `README_FIRST.md` mirrors enough current summary to recover host best, active experiment, stage boundary, and exact next, but not enough to recover A/B/C SHA, exact current layout, local INVALID/NON-AUTHORITATIVE ledger entries, or current disaster-recovery anchor manifest.
4. `TEST_AGENT_PROMPT.md` is stale relative to the main-repo-first protocol: it instructs a fresh agent to start from local `/mnt/data/rev46_sandbox/handoff_v2/READ_FIRST.md`, whereas `TEST_AGENT_PROTOCOL.md` and the main repository now require starting at `SimAdmin-Android/CURRENT_REV46_HANDOFF.md`.
5. Naming is potentially confusing: the GitHub package has `README_FIRST.md`, while local instructions refer to `READ_FIRST.md`. That may be intentional for local-vs-external roles, but it should be explicitly documented to prevent a fresh agent from treating one as a typo or substituting the wrong authority.
6. The main pointer says active REV46 host-only numerical-science state is maintained in the supporting repository and, while available, the local sandbox; however the supporting repository does not currently expose a complete exact-state fallback snapshot. The public summary and the sole local NOW authority are therefore asymmetric after sandbox loss.
7. The current host best is below all frozen gates except max, but it is still a host failure. Any instruction that jumps to APK/device from the published summary would contradict the roadmap.

## Risks to a fresh agent

- A fresh agent can recover the correct global mechanism and exact-next concept, yet still bind QNN inputs/outputs incorrectly because the exact layout file is missing.
- It can select the correct A/B/C IDs but cannot verify their model SHA values, creating a wrong-artifact risk.
- It cannot prove the local state is self-consistent or SHA-pinned because the validator cannot run.
- It may mistake the external `README_FIRST.md` summary for a fully authoritative replacement for `CURRENT_STATE.json` after sandbox loss.
- It may follow the stale local-first `TEST_AGENT_PROMPT.md` rather than the newer main-repo-first protocol.
- It may overuse older `evidence/rev46/live` records as execution authority, even though current handoff explicitly makes them historical/non-authoritative for exact next.

## Concrete handoff improvements

1. **Publish a sanitized immutable fallback snapshot** in `evidence/rev46/handoff-v2` containing at minimum `CURRENT_STATE.json`, `EXACT_NEXT.json`, `ENVIRONMENT_AND_LAYOUT.md`, `RECOVERY_ANCHORS.md`, and a compact current experiment/candidate manifest. If local paths cannot be published verbatim, publish a redacted schema-equivalent snapshot with SHA-pinned artifact identities.
2. **Publish A/B/C candidate SHA256 values externally** next to `A_local_max`, `B_local_rmse`, and `C_p90_blockmax`, plus the manifest SHA that binds those candidates to the active experiment/stage.
3. **Add an explicit sandbox-absent branch** to `SimAdmin-Android/CURRENT_REV46_HANDOFF.md`: exact GitHub commit/release/workflow-artifact IDs, expected SHA values, reconstruction order, and the point at which the restored local validator must return `HANDOFF_V2_VALID`.
4. **Mirror the current ORT/QNN layout contract** into the external handoff package. This should include exact tensor names, dimensions/order, raw QNN input-list/binary layout, output layout, and any reshape/transpose rules that must never be inferred.
5. **Mirror the current INVALID/NON-AUTHORITATIVE ledger summary** externally so a reset cannot silently resurrect a closed or observer-perturbed branch.
6. **Make the validator recoverable**: publish the validator script itself or a SHA-pinned recovery artifact plus expected validation scope and expected output marker.
7. **Normalize entrypoint naming and ordering**: update `TEST_AGENT_PROMPT.md` to main-repo-first; explicitly explain `READ_FIRST.md` (local) versus `README_FIRST.md` (external) if both names are intentional.
8. **Clarify authority after sandbox loss**: either make the supporting-repo snapshot a formal fallback NOW authority when local state is absent, or state that science must stop until a SHA-verified local state is reconstructed. The present materials imply the latter but do not state it sharply enough.
9. **Include a single signed/hash-bound recovery manifest** linking main pointer SHA, global handoff SHAs, current-state SHA, exact-next SHA, candidate manifest SHA, layout SHA, ledger head hash, and recovery-anchor hash. This would let a fresh agent distinguish “summary is readable” from “resume state is reproducible.”

## Final QA judgment

The handoff v2 succeeds at its most important global design goal: a fresh agent can identify the correct repository authority, explain the entire REV46 failure evolution and closed branches, understand why QNN CPU is not HTP truth, reconstruct the exact/equivalent roadmap and the delayed APK/device boundary, and preserve the historical wider-student/surrogate contingency conditions.

It does **not** currently provide a complete disaster-recoverable exact local resume state in this environment. Because the sole local NOW authority and validator are absent and the external package does not contain equivalent SHA-pinned state/layout/recovery files, a responsible fresh agent must stop before science execution rather than run the recovered exact-next action.
