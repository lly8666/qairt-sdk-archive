# 工业废水市场情报与技术商务协同系统

从中国催化剂工业废水调查发展为面向业务、技术及管理的共享应用。原103轮公开证据与SQL迁移无损保留；新增应用结构不覆盖事实层。

**新Agent：从[AGENTS.md](AGENTS.md)开始，然后[PROGRESS.md](PROGRESS.md)、[WORKPLAN.md](WORKPLAN.md)、[APP_DESIGN.md](APP_DESIGN.md)。** 历史按[HISTORY.md](HISTORY.md)定向查找，不默认通读。

- [应用总体设计](APP_DESIGN.md)：数据模型、用户流程、匹配、权限与技术演进。
- [当前开发路线](WORKPLAN.md)：阶段验收与可执行任务。
- [证据与研究规则](METHODOLOGY.md)、[证据政策](EVIDENCE_POLICY.md)、[工艺膜规则](PROCESS_MEMBRANE.md)。
- [接续提示词](LONG_TERM_PROMPT.md)：跨Agent使用。

事实真源：schema.sql + data/八张CSV + migrations/有序SQL。SQLite、Markdown档案与ZIP为可重建派生物。构建（不得覆盖旧库）：
```sh
python catalyst-research/build.py /tmp/catalyst-new.sqlite
python catalyst-research/audit_process_membrane.py /tmp/catalyst-new.sqlite
python catalyst-research/verify_incremental.py /tmp/catalyst-new.sqlite 19
python catalyst-research/test_research_revisit.py /tmp/catalyst-new.sqlite
python catalyst-research/test_document_dispatch.py /tmp/catalyst-new.sqlite
python catalyst-research/export_dossiers.py /tmp/catalyst-new.sqlite /tmp/catalyst-dossiers
python catalyst-research/check_handoff.py
```
专项CI产物仅保留7日，需按最新可用成功运行或从真源重建。公开仓库不保存内部业务/技术秘密。App尚未实现，参见当前进度。
