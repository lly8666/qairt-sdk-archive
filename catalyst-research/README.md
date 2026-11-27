# 催化剂工厂与废水数据库

**新 Agent 从 [AGENTS.md](AGENTS.md) 开始。不要从头调查，不依赖聊天记忆。** 本目录是中国催化剂厂商、生产规模、地理位置和详细工业废水研究的唯一接续入口。

- [完整施工方法论](METHODOLOGY.md)：调查路径、去重、证据、入库、验证、施工验收。
- [逐厂流程图和膜技术/改造评估规范](PROCESS_MEMBRANE.md)：新增必做工作、数据结构及难度口径。
- [原工作包计划](WORKPLAN.md)、[资料保全规范](EVIDENCE_POLICY.md)、[最新施工进度](PROGRESS.md)。

源数据为 schema.sql + data/八张基线 CSV + migrations/有序 SQL，基线193主体/项目并非当前数量。最新研究基线 V0.8（244条主体/项目，具体见 PROGRESS），009 为结构扩展而非新增调查成果。不要覆盖已生成的 SQLite；不要改历史迁移。

在仓库根目录运行：
```sh
python catalyst-research/build.py /tmp/catalyst-new.sqlite
python catalyst-research/audit_process_membrane.py /tmp/catalyst-new.sqlite
python catalyst-research/export_dossiers.py /tmp/catalyst-new.sqlite /tmp/catalyst-dossiers
```

公开仓库只保存公开产业信息和明确标注的待核线索。所有研究只提交 catalyst-wastewater 分支，不修改 main 或其他项目。图表/档案派生物以最新可重建数据为准。
