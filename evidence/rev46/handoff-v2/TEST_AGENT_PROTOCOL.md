# REV46 fresh-agent handoff QA protocol — main-repo-first global + local restoration

The tester must **not run models, compile QAIRT, build APKs, run devices, or continue development**. Its only task is to measure handoff restoration quality.

## Start point
Pretend there is no conversation history. Start from the **main repository entrypoint**:
- repository: `lly8666/SimAdmin-Android`
- file: `CURRENT_REV46_HANDOFF.md`

Follow only the pointers discovered from that file. This should lead to the supporting repository handoff-v2 global documents and then, when the local sandbox exists, to `/mnt/data/rev46_sandbox/handoff_v2/READ_FIRST.md` and `CURRENT_STATE.json`.

Run `python3 /mnt/data/rev46_sandbox/handoff_v2/validate_handoff.py` if the sandbox exists. Do **not** run `resume_A_B_C_qnn_stage1.sh`.

## The report must reconstruct BOTH levels

### A. Global project restoration
- Exact primary/main repository and its authority role.
- Exact supporting repository and its role.
- What the project/workstream is trying to achieve, not merely the next experiment.
- Frozen numerical gate and why QNN CPU is diagnostic rather than HTP truth.
- Causal fault evolution: bootstrap/runtime separation -> focused block4 graph rejection -> block4 numerical lowering drift/recovery -> block5 PW2 intrinsic source -> K8 local improvement -> downstream error-direction amplification -> reduction-tree conditioning -> current partial-guided tree family.
- At least five major closed/invalidated branches and why they are closed.
- Current primary roadmap, host qualification phase, final target-device phase, and contingency wider-student/surrogate route with route-switch conditions.
- Why APK/device is blocked and why eventual Android integration must return to `lly8666/SimAdmin-Android`.

### B. Exact local restoration
- Current host-best path/SHA/metrics and failed gate.
- Active experiment ID/hypothesis.
- A/B/C IDs/SHA.
- Which stages are complete vs not started.
- The one exact next action.
- At least five forbidden/re-run actions.
- ORT/QNN input/output layout distinction.
- Invalid/non-authoritative recent evidence.
- External recovery anchors and validator result.
- Any contradictions or stale pointers.

## Score out of 100
- main/support repositories + authority roles: 10
- project mission + full causal fault map: 20
- roadmap/decision tree + contingency route-switch conditions: 15
- current best + frozen gate: 10
- active experiment + stage boundary: 15
- exact-next uniqueness: 10
- safety/no-rerun/layout constraints: 10
- provenance/hash/recovery validation: 5
- ambiguity/staleness detection: 5

Hard caps:
- If the tester cannot identify `lly8666/SimAdmin-Android` as the main/production authority: score <= 69.
- If it recovers the exact next action but cannot explain the global failure evolution and long-term roadmap: score <= 79.

Write exactly one new report in `lly8666/qairt-sdk-archive` at `evidence/rev46/handoff-tests/20260821-fresh-agent-handoff-v2-report.md`. Include score, reconstructed global state, reconstructed local state, validator output, ambiguities/missing information, and concrete handoff changes. Do not edit any model, workflow, experiment evidence, or existing handoff file.