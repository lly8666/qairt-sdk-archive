# 数据维护与定向研究方法（现行）

目标：公开市场事实准确、可比较、可追溯，支撑真实App使用。原研究目标的全国完整枚举继续低强度补漏，不以形式完整度或固定检索数为开发门槛。

## 恢复和排重
从AGENTS/PROGRESS/WORKPLAN启动，核对远程HEAD、实际库、已完成代码。先查sites/capacity/projects/site_relations/sources/site_sources/wastewater/water_metrics/claims/evidence_notes/water_economics/contacts/tasks/search_log及有关视图。按法律主体、别名、厂址、许可证、园区、项目范围、source_id/URL、流股、测点、时期、阶段去重。集团规模不分摊工厂；候选、研发、销售、回收、载体与在产制造分开。身份冲突用映射或待核，不删证据。

## 调研价值优先
按APP_DESIGN的高价值技术缺口、身份与所有制/采购主体、近期官方环评/验收/采购事件、实际分股和公开业务入口筛查。先查v_research_dispatch、v_research_document_dispatch、v_research_document_tracks、v_research_pending_events、v_public_research_queue与旧search_log。旧报告只补独立未读章节，冷却只针对同轨道；新有效事件可重开，原暂缓须人工复核。低收益不等于客户无价值；私有成本/膜寿命不盲搜。历史详细调度机制见archive/research-001-103/RESEARCH_REVISIT_POLICY.md和PUBLIC_RESEARCH_CLOSURE.md（技术机制参考，旧工作量要求已失效）。记录真实查询、结果、source_id、日期、缺口、下一触发条件；不把检索或重复事实算工程产出。
优先政府验收/监测/许可执行、许可、环评、企业披露、工程采购、供应商案例、转载/索引；阶段与证据类型独立。官方控制权、年报、企业登记等用于所有制核证；上市不代表国有，集团性质不直接等同子公司或采购机制。仅使用公开合法入口。

## 数据工程
保留schema/data/历史迁移；新事实或结构用下一编号SQL迁移，事务、明确字段、稳定ID、外键和唯一性检查。原公开事实为唯一可重建真源；派生应用层与私有数据分离，旧ID映射、幂等同步、版本冲突与回滚验证。新事实尽量结构化，不能归字段的进evidence_notes并关联来源及定位。设计/许可/历史/实际、流量/容量、吨/m³、全厂/分股、回用/排放、上下游、浓水/原水严格区分，不无依据相加；ND与0分开；成本同范围同单位。
数据变更须全量构建、增量等价、完整性/外键、去重、跨厂证据关联、工艺膜审计、导出ZIP与相关回归；代码/文档改动对应测试。使用实际运行结果，不以结构检查代替事实正确。每批按AGENTS提交与HISTORY记录，不在PROGRESS堆叠历史。历史详细搜索模板与范围见归档METHODOLOGY，只有需要时读取。
