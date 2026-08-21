# REV46 live resume rules

## Case 1 — live operation is IDLE
Read `LIVE_STATE.json`, then the referenced versioned generation. If `science_execution.execution_authorized_now=false`, restore local state and pass the named validator before science. Before starting the exact-next operation, publish Transaction A from `REALTIME_SYNC_PROTOCOL.md` so the live state becomes `IN_PROGRESS`.

## Case 2 — live operation is IN_PROGRESS
Do not restart the whole experiment. Read the operation object and recover:
- expected units;
- completed units;
- incomplete/missing units;
- output validation rules;
- idempotent resume command/script identity;
- whether comparative scoring is forbidden until all units complete.

Resume **only missing units**. Existing validated units must not be rerun. If a duplicate execution already occurred, record it as duplicate and give it no extra statistical weight.

Do not open a later stage merely because some candidate finished early.

## Case 3 — live state is STALE or filesystem is ahead of published state
Stop science. Reconcile outputs and publish the correct handoff state first. A new experiment cannot start from an unreconciled state.

## Case 4 — local sandbox is absent
Use the stable main-repo entry, then `handoff-live/LIVE_STATE.json`, `LATEST_GENERATION.json`, and `RESTORE_BUNDLE_INDEX.json` to reconstruct exact state.

The external package is restoration/audit authority only. It must explicitly report `science_execution_authorized=false` until a reconstructed local validator returns the expected PASS marker.

## Case 5 — current exact family closes
Follow NEXT HORIZON, not intuition. A failed family is not permission to add variants. The current reduction-tree mechanism has a preregistered closure and anti-rabbit-hole budget. After closure, fresh causal localization is mandatory before any new exact/equivalent family.

## Never infer
Never infer a model SHA, tensor layout, completed stage, candidate winner, or execution authorization from prose when a machine-readable field exists. If machine state and narrative disagree, treat the handoff as stale and reconcile before science.