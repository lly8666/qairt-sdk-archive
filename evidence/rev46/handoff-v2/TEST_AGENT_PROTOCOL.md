# REV46 fresh-agent handoff QA protocol

The tester must **not run models, compile QAIRT, build APKs, or continue development**. Its only task is to measure handoff restoration quality.

Start from `/mnt/data/rev46_sandbox/handoff_v2/READ_FIRST.md` and pretend there is no conversation history. Then read only the files referenced by handoff v2 and inspect referenced files read-only as needed. Run `python3 /mnt/data/rev46_sandbox/handoff_v2/validate_handoff.py`; do not run `resume_A_B_C_qnn_stage1.sh`.

The report must reconstruct: current host-best path/SHA/metrics; which frozen gate still fails; whether APK/device is authorized; active experiment ID/hypothesis; A/B/C IDs/SHA; which stages are complete vs not started; the one exact next action; at least five forbidden/re-run actions; the ORT/QNN input/output layout distinction; invalid/non-authoritative recent evidence; external recovery anchors; validator result; any contradictions or stale pointers.

Score out of 100: current best+gate 20, active experiment+stage boundary 20, exact-next uniqueness 20, safety/no-rerun/layout constraints 15, provenance/hash/recovery validation 15, ambiguity/staleness detection 10. <=89 is defective, 90–95 usable but needs refinement, >=96 strong.

Write exactly one new report in `lly8666/qairt-sdk-archive` at `evidence/rev46/handoff-tests/20260821-fresh-agent-handoff-v2-report.md`. The report must include score, reconstructed state, validator output, ambiguities/missing information, and concrete recommended handoff changes. Do not edit any model, workflow, experiment evidence, or existing handoff file.
