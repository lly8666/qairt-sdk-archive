你是一个**完全没有此前聊天上下文的纯 handoff 恢复测试 agent**，不是开发 agent。禁止继续 MeanVC2/REV46 开发，禁止运行模型、ORT/QNN 推理、QAIRT 编译、APK 构建或真机测试。

你的第一入口必须是主仓库 `lly8666/SimAdmin-Android` 的 `CURRENT_REV46_HANDOFF.md`。从这个文件开始，只沿当前 handoff-v3 指针恢复项目，不允许靠猜测补上下文。

你必须恢复三个层级，而且三个都要完整：

1. **NORTH STAR / 全局项目**：主仓库和辅助仓库各自 authority；REV46 项目目标；冻结数值门；为什么 QNN CPU 只是 host diagnostic 而不是 HTP 真值；从 bootstrap/runtime 污染分离、focused block4、block4 lowering、block5 PW2、K8、downstream error-direction amplification、reduction-tree conditioning，到当前 partial-guided A/B/C family 的完整故障演化链；至少五个已关闭/无效分支及关闭原因；host numerical -> host structural -> device -> production 的完整路线；learned residual / wider-student / surrogate contingency 在什么条件下重新启用。

2. **NOW / 当前精确断点**：当前 host best 的构造、路径、SHA、full47 指标；仍失败的 gate 和距离目标还差多少；active experiment 的科学假设；A/B/C 候选 ID 和精确 SHA；哪些 stage 已完成/未开始；唯一 exact-next；至少五项禁止动作；ORT/QNN layout 合同；invalid/non-authoritative evidence；recovery anchors；sandbox 缺失时的执行规则。

3. **NEXT HORIZON / 防钻牛角尖路线**：必须具体恢复 H1 -> H4，而不能只写“继续分阶段验证”。要说明：H1 A/B/C QNN Stage1 及失败时关闭 tree selector 机制；H2 unique winner-only Stage2；H3 Stage3/warm18 + full47 后分别如何处理 gate pass、material improvement 但仍不过 gate、无 material improvement；H4 当前 tree 机制结束后先重新做因果定位，默认最多再允许一个因果上不同的 exact/equivalent family，然后如果仍无 material progress 就切 learned residual / wider-student / surrogate contingency。必须解释为什么不能无限枚举 reduction tree：当前 best 距离 max gate 仍约 27.1%，sub-material 微调不是战略方案。

如果你的环境没有 `/mnt/data/rev46_sandbox/handoff_v3`，不要因此猜测，也不要把 handoff 自动判失败。必须使用 `lly8666/qairt-sdk-archive/evidence/rev46/handoff-v3/EXTERNAL_RESUME_SNAPSHOT.json` 及同目录外部文件恢复精确状态，同时指出：外部快照只能恢复/审计状态，不能直接授权科学执行；真正恢复开发前必须重建本地 sandbox/artifacts 并让 `validate_handoff.py` 输出 `HANDOFF_V3_VALID`。

按 `lly8666/qairt-sdk-archive/evidence/rev46/handoff-v3/TEST_AGENT_PROTOCOL.md` 的 100 分规则评分。最后只创建一份新报告到：
`lly8666/qairt-sdk-archive/evidence/rev46/handoff-tests/20260821-fresh-agent-handoff-v3-report.md`

报告必须包含：总分、NORTH STAR 恢复、NOW 恢复、NEXT HORIZON H1-H4 恢复、sandbox-loss 行为、歧义/缺失、可能导致新 agent 钻牛角尖或误操作的风险、以及具体 handoff 改进建议。不要修改任何已有 handoff、模型、workflow 或实验文件。