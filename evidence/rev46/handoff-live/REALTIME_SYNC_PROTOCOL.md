# REV46 handoff as a realtime task

Handoff maintenance is a **first-class concurrent task** of the development process. It is not deferred until the end of a chat or experiment.

## Invariant
No new scientific branch may begin from a state that has not first been synchronized into the live handoff.

## Transaction A — before any long or interruptible science operation
Before conversion, QNN execution, multi-candidate inference, device work (when eventually authorized), or any operation whose partial completion matters:

1. Update `LIVE_STATE.json` with an `operation` object:
   - unique `operation_id`;
   - `status=IN_PROGRESS`;
   - exact family/stage/hypothesis;
   - expected units/candidates/blocks;
   - already-complete units that must not be rerun;
   - expected output locations and validation rule;
   - idempotent resume rule;
   - whether scoring/selection is forbidden until all units finish.
2. Update the exact-next meaning to `RESUME_OR_VALIDATE_CURRENT_OPERATION`, not a later branch.
3. Publish the synchronized live state before starting the long operation.

If the chat dies after this point, a fresh agent knows an operation may be partial and must resume only missing units.

## Transaction B — during an interruptible operation
After each independently durable unit finishes, synchronize only facts that are safe to know without violating preregistration:

- completed unit IDs;
- output existence and SHA where appropriate;
- whether the unit is structurally complete;
- **do not publish or use comparative candidate scores early if preregistration forbids mid-run selection**.

A completed unit is never counted twice. Re-execution caused by a broken resume script is recorded as a duplicate execution and receives zero additional statistical weight.

## Transaction C — after an operation completes
Before beginning the next scientific action:

1. Validate completeness, provenance, observer-effect/semantic gates where applicable.
2. Score only at the preregistered boundary.
3. Update current best or close the family as dictated by the frozen rule.
4. Update all three scales:
   - NOW (`LIVE_STATE.json` / versioned `CURRENT_STATE.json`);
   - exact next;
   - NEXT HORIZON if the decision tree changed.
5. Append the experiment/decision ledger with valid, invalid, duplicate and non-authoritative evidence labels.
6. Update artifact identities, layout changes, recovery anchors if any.
7. Refresh external resume snapshot and integrity manifest.
8. Set `operation.status=IDLE` only after the state above is externally recoverable.

## Anti-staleness rule
If filesystem/results indicate work later than the published live handoff, **do not continue science**. Reconcile and publish handoff first.

If the live handoff claims a unit is unstarted but validated result artifacts already exist, the validator must return stale/invalid rather than silently continuing.

## Anti-rabbit-hole rule
Every candidate family must carry:
- causal mechanism;
- plausible leverage toward the remaining gate gap;
- material success threshold;
- preregistered closure rule;
- protected data boundary;
- what diagnostic or route switch follows failure.

The exact-next command does not grant permission to keep optimizing the same mechanism after its closure rule fires.

## Cross-sandbox rule
External live state is restoration/audit authority only. Science execution is authorized only after a reconstructed local state and science artifacts pass the validator marker named in `LIVE_STATE.json`.