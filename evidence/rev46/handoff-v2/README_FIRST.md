# REV46 handoff v2 external index

Date: 2026-08-21.

**Main / production repository: `lly8666/SimAdmin-Android`.**
Supporting host/evidence/recovery repository: `lly8666/qairt-sdk-archive`.

For a truly fresh-agent restoration test, start from **`lly8666/SimAdmin-Android/CURRENT_REV46_HANDOFF.md`**. That main-repository pointer deliberately leads into this handoff-v2 package and then to the local NOW state if the sandbox exists.

Local authoritative handoff root: `/mnt/data/rev46_sandbox/handoff_v2`.

## Mandatory restoration order
A fresh agent must restore the **whole project first**, then the local breakpoint:
1. `REPOSITORY_MAP.md` — repository roles and authority precedence.
2. `PROJECT_GLOBAL_CONTEXT.md` — mission and causal fault evolution from bootstrap/block4 through block5/downstream/reduction-tree conditioning.
3. `ROADMAP_AND_DECISION_TREE.md` — north-star plan, host/device phases and contingency wider-student/surrogate branch.
4. `CURRENT_STATE.json` — sole authoritative NOW pointer.
5. `validate_handoff.py` must print `HANDOFF_V2_VALID` before science resumes.
6. `EXACT_NEXT.json` — exactly one allowed next action.

Do not use legacy append-only `handoff/LIVE_HANDOFF.md`, old `CURRENT_AGENT_BOOTSTRAP.md`, or old `HANDOFF_NEXT_AGENT.md` to decide what to run next. They remain historical context only unless current handoff v2 explicitly cites them.

Current host best: `current_host_best/vocos_warm6_rev46_hostbest_weight_balanced.onnx`, SHA256 `a584d4c8e7a05bc36fb06b653c398547b525e15d5a996fc4d7f3dd612db5b774`; full47 QNN-vs-ORT max_abs `0.0004115104675292969`, mean_abs `3.777641009158933e-07`, rmse `3.096381567930808e-06`, cosine `0.9999999999856087`. Frozen host max gate `3e-4` still fails; APK/device remains BLOCKED.

Active experiment: `k8_partial_guided_tree_family_stage1_final_qnn`. The 315-tree proxy search is complete; A/B/C models are materialized; A/B/C ORT1.27 Stage1 semantic gate is already complete and all-pass. A/B/C QNN Stage1 has NOT started. Correct exact next action is QNN2.44 CPU Stage1 for exactly `A_local_max`, `B_local_rmse`, and `C_p90_blockmax`; do not rerun ORT, do not open Stage2/Stage3, do not expose warm18, and do not build/run an APK.

A handoff restoration that can repeat only the exact next action but cannot explain the global fault evolution and long-term roadmap is incomplete.