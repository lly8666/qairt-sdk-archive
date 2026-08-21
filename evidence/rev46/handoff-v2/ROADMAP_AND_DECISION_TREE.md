# REV46 roadmap and decision tree

## North-star outcome
Qualify a full Vocos cold4/warm6 model for the MeanVC2 Android project in **`lly8666/SimAdmin-Android`** under strict QNN/HTP ownership and no CPU fallback, satisfy the frozen numerical gate, then perform final target-device qualification and only after that production integration.

## Current route — exact/equivalent numerical topology recovery

### Phase A — host numerical search (ACTIVE)
Every family follows: preregister candidates/splits -> ORT1.27 semantic gate -> QNN2.44 CPU discovery -> unique winner-only validation -> unique validation winner-only challenge/warm18 -> assemble full47 from staged outputs -> promote only on semantic PASS plus required >=3% material improvement.

The roadmap never overrides `EXACT_NEXT.json`.

### Phase B — host qualification after numerical max gate passes
Crossing max_abs 3e-4 on one warm case is not enough. The promoted full model must pass cold4 semantics/numerics, full warm47 aggregate, graph contract, QAIRT converter/model-lib, QNN CPU and Saver/compiled structural evidence, ownership/fusion/no-fallback invariants, and required nonfinal heldout/stress checks without using final device A/B/C for fitting/search.

### Phase C — target-device qualification
Only after host qualification may a minimal strict diagnostic/integration APK be built from the **main repository `lly8666/SimAdmin-Android`**. Preserve platform/partition probes, SHA locks, JSON export and strict CPU fallback disablement. Frozen device A/B/C is final numerical truth. No threshold relaxation or CPU fallback may convert a host failure into a phone run.

## Contingency route — wider residual/student/surrogate redesign
Historical REV46 planning in `SimAdmin-Android/HANDOFF_NEXT_AGENT.md` proposed learned residual correction or wider multi-block/full-Vocos student if equivalent graph rewrites could not solve deterministic HTP residuals. Re-enable only with documented evidence that causally distinct exact/equivalent topology mechanisms are exhausted, the residual is irreducible under supported compiled QNN topology, or target HTP evidence reveals a mechanism not controllable by exact host topology changes.

If re-enabled: final device A/B/C are never training/search data; seed 20260814 remains excluded; QNN CPU remains diagnostic rather than HTP truth; historical negative revisions must qualify any surrogate before positive selection; phone remains the last gate.

## Repository integration rule
Host science/evidence can live in `lly8666/qairt-sdk-archive`, but production Android model/runtime integration, APK authorization, device probe contracts and release decisions belong to **`lly8666/SimAdmin-Android`**.

## Fresh-agent stop conditions
Stop rather than improvise if validator fails, CURRENT_STATE disagrees with disk, SHA-pinned authority cannot be reproduced, multiple exact-next actions appear, a proposed action exposes validation/challenge/device data early, or a closed family would be reopened without new causal evidence.