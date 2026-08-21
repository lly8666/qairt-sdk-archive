# REV46 roadmap and decision tree

## North-star outcome
Qualify a full Vocos cold4/warm6 implementation for the MeanVC2 Android project under strict QNN/HTP ownership and the frozen numerical gate, then complete host structural qualification, then perform final target-device qualification, and only then integrate/release from `lly8666/SimAdmin-Android`.

## Three-scale control
- `EXACT_NEXT` = one currently authorized action.
- `NEXT_HORIZON` = next 2–4 decision nodes, why they exist, and pass/fail exits.
- this roadmap = project north star and route-switch policy.

A new agent must understand all three. The roadmap never authorizes skipping the exact-next stage; exact-next never authorizes forgetting the longer route.

## Phase A — active host numerical recovery
Current mechanism: block5 PW2 contiguous-K8 partial accumulation plus reduction-tree conditioning.

Every family must follow:
1. freeze hypothesis/candidates/splits before final QNN scoring;
2. ORT1.27 semantic qualification first;
3. QNN2.44 CPU discovery only;
4. unique winner-only validation;
5. unique validation-winner-only challenge/warm18;
6. assemble full47 from preregistered staged outputs without silently reusing protected data for selection;
7. promote only on semantic PASS plus the frozen material-improvement rule.

Current host best max is `0.0004115104675292969`; target is `0.0003`, so ~27.1% relative max reduction remains. Therefore repeated <3% micro-tuning is not a strategic substitute for a causal mechanism.

### Current bounded mechanism
The active A/B/C partial-guided family is a bounded test of whether an intermediate Add22 proxy can select a reduction association that transfers to final-spectrum improvement.

- If A/B/C Stage1 produces no unique material winner: close this selector/tree mechanism. Do not add more selectors after seeing results.
- If Stage1 yields a unique winner: only it may run Stage2.
- If Stage2 fails: close the candidate/family; do not tune against Stage2.
- If Stage2 passes: only that winner may run Stage3/warm18 and then full47 assembly.
- If full47 passes `max_abs <= 3e-4`: leave search mode immediately and enter Phase B.
- If full47 is materially better but still fails the gate: promote it, then perform a **fresh nonperturbing causal localization** before proposing another family. Do not simply continue tree enumeration.
- If the tree mechanism closes: perform one fresh causal diagnostic and require the next family to test a genuinely distinct mechanism with plausible leverage toward the remaining gap.

### Anti-rabbit-hole route-switch rule
After the current tree mechanism, allow by default at most **one** further causally distinct exact/equivalent family supported by new localization evidence. Do not reopen already-closed K-width, channel-permutation, redundant multipath, block6 activation, block6×block7 activation, final-head, or block7-primary-source families without new evidence that invalidates their closure reason.

If no credible distinct exact/equivalent mechanism is found, or that additional family also fails the material-improvement gate, declare the exact/equivalent route causally exhausted and activate the preserved contingency rather than continuing micro-tuning.

## Phase B — host qualification after numerical gate passes
Crossing max `3e-4` on one warm sample is not enough. The promoted full model must qualify:
- cold4 semantics and numerics;
- full warm47 aggregate;
- graph contract;
- QAIRT converter/model-lib;
- QNN CPU and Saver/compiled structural evidence;
- ownership/fusion/no-fallback invariants;
- required nonfinal heldout/stress checks;
- no use of final device A/B/C or seed 20260814 for fitting/search.

## Phase C — final target-device qualification
Only after Phase B:
- return to the **main repository** `lly8666/SimAdmin-Android`;
- build the minimal strict diagnostic/integration APK;
- preserve platform/partition probes, model/dependency SHA locks, JSON export, and strict CPU-fallback disablement;
- run the frozen target-device A/B/C protocol;
- phone/HTP decides final numerical truth.

No threshold relaxation or CPU fallback may turn a host failure into a device run.

## Contingency — learned residual / wider student / qualified surrogate
Historical planning in `SimAdmin-Android/HANDOFF_NEXT_AGENT.md` preserved a wider learned residual-correction or multi-block/full-Vocos student path. This route is not forgotten; it is intentionally dormant while exact/equivalent mechanisms remain causally productive.

Re-enable it when:
- causally distinct exact/equivalent mechanisms are exhausted under the rule above;
- remaining residual appears irreducible under supported compiled-QNN exact topology;
- or later HTP evidence reveals a mechanism host exact topology cannot control.

If re-enabled:
- final device A/B/C stay out of training/search;
- seed 20260814 stays excluded;
- QNN CPU remains diagnostic, not HTP truth;
- historical negative revisions must qualify any surrogate before positive selection;
- device remains the last gate.

## Stop conditions
Stop rather than improvise when state, SHA, stage boundary, repository authority or exact-next becomes ambiguous. If the sandbox is absent, use the external v3 snapshot to restore exact state, but do not execute science until a reconstructed local validator prints `HANDOFF_V3_VALID`.