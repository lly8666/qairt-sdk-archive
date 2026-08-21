# REV46 fresh-agent handoff QA protocol — global + local restoration

The tester must **not run models, compile QAIRT, build APKs, run devices, or continue development**. Its only task is to measure handoff restoration quality.

Start from `/mnt/data/rev46_sandbox/handoff_v2/READ_FIRST.md` and pretend there is no conversation history. Follow the mandatory read order. Run `python3 /mnt/data/rev46_sandbox/handoff_v2/validate_handoff.py`; do not run `resume_A_B_C_qnn_stage1.sh`.

## The report must reconstruct BOTH levels

### A. Global project restoration
- Primary/main repository: exact name and authority role.
- Supporting repository: exact name and role.
- Project north-star objective and frozen numerical gate.
- Why QNN CPU is diagnostic instead of HTP truth.
- Causal failure evolution from bootstrap -> focused block4 -> block4 numerical lowering -> block5 PW2 -> downstream error direction -> reduction-tree conditioning.
- At least five major closed/invalidated branches and why they are closed.
- Current primary route, later host-qualification/device phases, and contingency wider-student/surrogate route plus conditions for re-enabling it.
- Why APK/device is currently blocked and which repository owns eventual Android production integration.

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
- repositories + authority roles: 10
- project mission + full causal fault map: 20
- roadmap/decision tree + route-switch conditions: 15
- current best + frozen gate: 10
- active experiment + stage boundary: 15
- exact-next uniqueness: 10
- safety/no-rerun/layout constraints: 10
- provenance/hash/recovery validation: 5
- ambiguity/staleness detection: 5

A report that recovers the exact next action but cannot explain the global fault evolution or long-term roadmap is capped at **79/100** regardless of local correctness.

Write exactly one new report in `lly8666/qairt-sdk-archive` at `evidence/rev46/handoff-tests/20260821-fresh-agent-handoff-v2-report.md`. Include score, reconstructed global state, reconstructed local state, validator output, ambiguities/missing information, and concrete handoff changes. Do not edit any model, workflow, experiment evidence, or existing handoff file.