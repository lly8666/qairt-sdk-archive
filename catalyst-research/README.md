# 催化剂工厂与废水数据库

**新 Agent 从 [AGENTS.md](AGENTS.md) 开始。不要从头调查，不依赖聊天记忆。** 本目录是中国催化剂厂商、生产规模、地理位置和详细工业废水研究的唯一接续入口。

- [完整施工方法论](METHODOLOGY.md)：调查路径、去重、证据、入库、验证、施工验收。
- [逐厂流程图和膜技术/改造评估规范](PROCESS_MEMBRANE.md)：新增必做工作、数据结构及难度口径。
- [原工作包计划](WORKPLAN.md)、[资料保全规范](EVIDENCE_POLICY.md)、[最新施工进度](PROGRESS.md)。

**资料交付口径：** 用户最新指示（2026-11-27）：以有效资料内容入库为交付，不以取得原始PDF、附件、截图、下载或哈希为前置条件。已查到、可明确归属厂区及时期的网页正文、检索摘录、转载、公告、报告文本、供应商案例等均直接作为相应类型的证据处理，及时提取关键细节、数值、单位、工艺、去向和状态，保存来源标题、URL、日期及可获得的定位（没有页码就用章节/检索摘录）。不因无法下载或复开而将已取得的有效事实降为无证据；只对尚未取得的实质信息或来源冲突留待核。原始文件归档不属于必交项，不为下载、截图或反复打开已知来源耗费主要施工时间。证据类型、事实阶段、来源局限仍如实区分；不虚构原文、数据、运行状态或将模型推断当作已查事实。

源数据为 schema.sql + data/八张基线 CSV + migrations/有序 SQL，基线193主体/项目并非当前数量。当前研究进度以 PROGRESS.md 和最新编号迁移的实际验证为准，009 为结构扩展而非新增调查成果。不要覆盖已生成的 SQLite；不要改历史迁移。

在仓库根目录运行：
```sh
python catalyst-research/build.py /tmp/catalyst-new.sqlite
python catalyst-research/audit_process_membrane.py /tmp/catalyst-new.sqlite
python catalyst-research/export_dossiers.py /tmp/catalyst-new.sqlite /tmp/catalyst-dossiers
```

公开仓库只保存公开产业信息和明确标注的待核线索。所有研究只提交 catalyst-wastewater 分支，不修改 main 或其他项目。图表/档案派生物以最新可重建数据为准。
