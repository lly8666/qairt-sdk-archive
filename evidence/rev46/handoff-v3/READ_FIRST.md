# READ FIRST — REV46 handoff v3

**Main project repository / production authority: `lly8666/SimAdmin-Android`.**
Supporting host/evidence/recovery repository: `lly8666/qairt-sdk-archive`.

Handoff v3 is designed to survive both chat loss and sandbox loss.

## Three mandatory navigation scales
1. **NORTH STAR** — recover project mission, full causal fault evolution, closed branches, host→device plan and contingency.
2. **NEXT HORIZON** — recover the next 2–4 decision nodes, including pass/fail exits and route-switch conditions.
3. **NOW** — recover the single exact authorized action.

A fresh agent is not restored if it knows only NOW. It is also not restored if it knows only the high-level roadmap but cannot identify the unique current action.

## External read order
1. `REPOSITORY_MAP.md`
2. `PROJECT_GLOBAL_CONTEXT.md`
3. `ROADMAP_AND_DECISION_TREE.md`
4. `NEXT_HORIZON.json`
5. `ANTI_RABBIT_HOLE.md`
6. `EXTERNAL_RESUME_SNAPSHOT.json`
7. `TEST_AGENT_PROTOCOL.md` when doing handoff QA

If a matching local `/mnt/data/rev46_sandbox/handoff_v3` exists, its `CURRENT_STATE.json` plus `validate_handoff.py` is the execution-time NOW authority. If the sandbox is absent, the external snapshot is sufficient for exact state restoration/audit but **does not authorize science execution**. Rebuild the local environment/artifacts and require `HANDOFF_V3_VALID` before science resumes.

## Current strategic snapshot
Current host best is block5-PW2 contiguous K8 with the static weight-balanced reduction tree `[0,5,1,4,2,7,3,6]`, SHA256 `a584d4c8e7a05bc36fb06b653c398547b525e15d5a996fc4d7f3dd612db5b774`. Full47 max_abs is `0.0004115104675292969`; the frozen max gate is `0.0003`, so about `27.097845%` relative max reduction is still required. APK/device remains BLOCKED.

The active partial-guided A/B/C family has completed ORT1.27 Stage1 semantic qualification and has **not** started QNN2.44 CPU Stage1. Exact next is A/B/C QNN Stage1 only.

The current reduction-tree mechanism is bounded. If it cannot transfer to staged final-spectrum material improvement, close it rather than inventing more tree selectors. After it closes, do a fresh causal diagnostic; by default allow at most one further causally distinct exact/equivalent family before switching to the preserved learned-residual / wider-student / surrogate contingency if material progress stalls.