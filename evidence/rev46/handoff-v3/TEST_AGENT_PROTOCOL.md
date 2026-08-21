# REV46 fresh-agent handoff-v3 QA protocol

The tester is a **handoff restoration auditor only**, not a development agent. It must not run model inference, QAIRT conversion/build, QNN/ORT science, APK builds or device tests.

## Start point
Pretend there is no conversation history. Start from the **main repository**:
- repo: `lly8666/SimAdmin-Android`
- file: `CURRENT_REV46_HANDOFF.md`

Follow only current-v3 pointers from that file.

If `/mnt/data/rev46_sandbox/handoff_v3` exists, the tester may run only `python3 validate_handoff.py` there. It must not run the resume script.

If the sandbox does **not** exist, this is no longer an automatic handoff failure: use `lly8666/qairt-sdk-archive/evidence/rev46/handoff-v3/EXTERNAL_RESUME_SNAPSHOT.json` plus the v3 external files to audit exact restoration. The tester must verify that the handoff explicitly blocks science execution until local reconstruction and `HANDOFF_V3_VALID`.

## The report must reconstruct all three scales

### A. NORTH STAR / global project restoration
- main repository and production authority role;
- supporting repository and role;
- project mission and frozen numerical gates;
- why QNN CPU is diagnostic rather than HTP truth;
- complete causal evolution: bootstrap/runtime separation -> focused block4 -> block4 numerical lowering -> block5 PW2 -> K8 -> downstream error-direction amplification -> reduction-tree conditioning -> current partial-guided family;
- at least five major closed/invalid branches and closure reasons;
- host numerical phase, host structural qualification, final target-device phase, production integration;
- preserved learned-residual / wider-student / surrogate contingency and route-switch conditions.

### B. NOW / exact local restoration
- current host-best construction/path/SHA/full47 metrics;
- exact frozen gate still failing and remaining relative max gap;
- active experiment hypothesis;
- A/B/C IDs and exact SHA256;
- completed vs unstarted stages;
- exactly one authorized next action;
- at least five forbidden/re-run actions;
- exact ORT/QNN layout contract;
- invalid/non-authoritative recent evidence;
- recovery anchors;
- sandbox-absent execution policy.

### C. NEXT HORIZON / anti-rabbit-hole restoration
The tester must reconstruct **H1 -> H4**, not merely say “continue staged testing”:
- H1: A/B/C QNN Stage1 and closure rule if no unique material winner;
- H2: unique winner-only Stage2 and no rescue tuning on failure;
- H3: Stage3/warm18 + full47 assembly, including the distinction between gate-pass, material-but-still-fail, and no-material-improvement outcomes;
- H4: fresh causal localization after the tree mechanism, at most one further causally distinct exact/equivalent family by default, then switch to the learned/student/surrogate contingency if material progress stalls.

The tester must explicitly explain **why** the project should not keep enumerating reduction trees: the current best is still about 27.1% above the frozen max gate and sub-material micro-tuning is not a sufficient strategic plan.

## Score out of 100
- main/support repositories + authority roles: 8
- project mission + full causal fault map: 16
- current best + gate + remaining gap: 10
- exact active experiment + candidate SHA/stage boundary: 14
- exact-next uniqueness and safety: 10
- NEXT_HORIZON H1-H4 + anti-rabbit-hole reasoning: 18
- roadmap + contingency route switch: 10
- layout/provenance/recovery/disaster behavior: 9
- ambiguity/staleness detection: 5

Hard caps:
- cannot identify `lly8666/SimAdmin-Android` as main production authority -> <=69;
- exact next is correct but global fault evolution is missing -> <=79;
- exact next is correct but H1-H4 / route-switch logic is missing or vague -> <=79;
- sandbox is absent and the agent proposes executing science directly from the external snapshot without local validation -> <=69;
- candidate SHA or ORT/QNN layout is guessed rather than recovered -> <=79.

## Output
Write exactly one new report to:
`lly8666/qairt-sdk-archive/evidence/rev46/handoff-tests/20260821-fresh-agent-handoff-v3-report.md`

The report must include score, reconstructed NORTH STAR, reconstructed NOW, reconstructed NEXT HORIZON, sandbox-loss behavior, ambiguities/missing information, and concrete handoff improvements. Do not modify any existing handoff, model, workflow or experiment file.