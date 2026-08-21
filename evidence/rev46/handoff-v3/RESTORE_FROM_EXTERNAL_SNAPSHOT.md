# Restore from external handoff-v3 snapshot

Use this procedure only when the local `/mnt/data/rev46_sandbox` state is unavailable.

The external v3 package is an **exact state-restoration authority**, not an execution authorization. Science remains stopped until a local sandbox is reconstructed and its validator prints `HANDOFF_V3_VALID`.

## Recovery order
1. Read `REPOSITORY_MAP.md`, `PROJECT_GLOBAL_CONTEXT.md`, `ROADMAP_AND_DECISION_TREE.md`, `NEXT_HORIZON.json`, and `ANTI_RABBIT_HOLE.md` so the recovery agent understands both project direction and current route-switch rules.
2. Read `EXTERNAL_RESUME_SNAPSHOT.json`, `CURRENT_STATE.json`, `EXACT_NEXT.json`, `CANDIDATE_MANIFEST.json`, `ENVIRONMENT_AND_LAYOUT.md`, `INVALID_AND_CLOSED_SUMMARY.md`, and `RECOVERY_ANCHORS.md`.
3. Recover QAIRT/QNN 2.44 foundation using the pinned release asset and SHA in `RECOVERY_ANCHORS.md`.
4. Recover the exact ORT1.27 portable authority runtime from the pinned workflow commit/version set.
5. Recover authority Vocos assets and reproduce rev25 warm6 SHA256 `e2b7ab608a6b37a6dd9896589719cab446edf95287f59dfc7b5693da6ec98f6c`.
6. Reproduce the authority warm18 QNN physical input SHA256 `5b425b7e31a80d33dfb135059593549781fdccd56ff1691f1965255d888b5dea`.
7. Reconstruct contiguous K8 and current weight-balanced host best. Require the current best model SHA256 `a584d4c8e7a05bc36fb06b653c398547b525e15d5a996fc4d7f3dd612db5b774` and full47 max fingerprint `0.0004115104675292969`.
8. Reconstruct/materialize A/B/C and require exact SHA values from `CANDIDATE_MANIFEST.json`.
9. Recreate a local `handoff_v3` package from the external files and verify current stage state: ORT Stage1 complete/all-pass, QNN Stage1 not started.
10. Run the local v3 validator. Only `HANDOFF_V3_VALID` permits returning to `EXACT_NEXT.json`.

If any artifact SHA, input SHA, model fingerprint, layout contract or stage boundary cannot be reproduced, stop. Do not substitute a semantically near model, regenerate inputs with a different layout, or skip directly to later stages/device testing.