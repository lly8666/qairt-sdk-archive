# B0000 — 2026-11-28：正式转段与接续机制重构
- task_ids: 治理/架构确认（A01尚未开始）
- base_head: 75cc2f26ae77116fb2e70d8a434c017b15bb7de7
- migrations: 无；保留001–103及全部基线
- changed: 用户确认技术商务App方向。新增APP_DESIGN、LONG_TERM_PROMPT、HISTORY、独立B编号日志及滚动PROGRESS；更新六份原入口与README；封存14份历史Markdown原始blob、删除退役根路径，保留可按需阅读的历史政策。新增check_handoff.py及专属CI检查。无事实增删、无新应用数据库/实际App。
- decisions: 分开公开事实、标准化市场、私有技术、多流股商机及协同；所有制/控制权/采购方式独立；小公司按现金流/履约/准入/人员决策；未来技术版本重匹配。保留旧30商机、旧检索机制及历史源ID。公开仓库不得保存真实内部业务关系或核心技术成本。采用独立B编号，SQL编号只用于真实迁移；PROGRESS只保留当前快照。
- validation: 103专项CI 46140912954 success；实际下载15261856607，SHA256 1184206eb5fbddc30b8b7a8c4422bcf2d0ac83d6fdd28f43f4af94cab387120a一致，ZIP无坏项，SQLite integrity ok/FK0；实查31表/38视图及当前计数见PROGRESS。此批不改数据；新专项CI待实际查询。归档通过原Git blob SHA复制，提交后回读树验证；不碰无关APK工作流。
- blockers: 未取得公司内部授权技术参数、私有环境与实际采购准入数据；不影响A01结构审计及匿名样例。当前尚无可运行App。
- next: B0001/A01，完成数据字典、现存site_id映射契约/异常队列、可复跑审计与A02实施准备；验收见WORKPLAN/PROGRESS。
