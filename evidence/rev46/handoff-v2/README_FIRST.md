# REV46 handoff v2 external index

Date: 2026-08-21.

Local authoritative handoff root: `/mnt/data/rev46_sandbox/handoff_v2`.

Do not use the legacy append-only `handoff/LIVE_HANDOFF.md` to decide what to run next. The sole NOW pointer is `handoff_v2/CURRENT_STATE.json`; `EXACT_NEXT.json` must contain exactly one allowed action; `validate_handoff.py` must print `HANDOFF_V2_VALID` before any science resumes.

Current host best: `current_host_best/vocos_warm6_rev46_hostbest_weight_balanced.onnx`, SHA256 `a584d4c8e7a05bc36fb06b653c398547b525e15d5a996fc4d7f3dd612db5b774`; full47 QNN-vs-ORT max_abs `0.0004115104675292969`, mean_abs `3.777641009158933e-07`, rmse `3.096381567930808e-06`, cosine `0.9999999999856087`. Frozen host max gate `3e-4` still fails; APK/device remains BLOCKED.

Active experiment: `k8_partial_guided_tree_family_stage1_final_qnn`. The 315-tree proxy search is complete; A/B/C models are materialized; A/B/C ORT1.27 Stage1 semantic gate is already complete and all-pass. A/B/C QNN Stage1 has NOT started. Correct exact next action is QNN2.44 CPU Stage1 for exactly `A_local_max`, `B_local_rmse`, and `C_p90_blockmax`; do not rerun ORT, do not open Stage2/Stage3, do not expose warm18, and do not build/run an APK.

Key handoff-v2 local file SHA256 values at publication:
- `CURRENT_STATE.json`: `faf62718a0b862a972e926bd34af9e98fcd990f4420949e8df51e581d1199b76`
- `READ_FIRST.md`: `03c5bbd25e499ebd42a7261acae5b3c8a2a2973bca2533247ad2a74a8952b002`
- `EXACT_NEXT.json`: `0b2e043c07df4bf829fee1d19755ee8cd72a4ca5b8225f9192ac33b8c02e435e`
- `validate_handoff.py`: `019dbe74a8336029b0d2cba20553d894da5cf336f08c037eef795e5cd7899493`
- `RECOVERY_ANCHORS.md`: `6c3f59f047b57a9c416c51bbec79a3579f0f8b6b89e2e3fc51a1596ccec7bb59`

Self-test result after v2 refinement: 98/100. The remaining two points are withheld only because some disaster-recovery transports are finite-retention GitHub Actions artifacts; pinned workflows/commits are recorded for regeneration.
