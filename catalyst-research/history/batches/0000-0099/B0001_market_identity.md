# B0001 — 2026-11-28：A01全库审计与A02身份层薄切片
- task_ids: A01,A02
- base_head: f14da5478a43a3e272d4c053efa2459bf0555ebc
- migrations: 104_market_identity_foundation.sql
- changed: 核103实际31表38视图/列、375主体24类型、21历史关系、8同省市地址组、71空地址、320空许可；新增market/MAPPING_CONTRACT.md、audit_market.py（全库DDL/列/PK/FK/索引/计数及6文件导出）、test_market_identity.py及CI；104新增4表6视图，动态375映射槽、异常队列、旧关系、30商机种子、4组织4厂址1项目11映射7关系；只复用3条历史来源，6主体有映射，不新添在产厂。旧事实不改。
- decisions: 历史/设计范围分开，庄信万丰同法人两厂、瑞孚南北替代（拟建不算在产）、瑞克母子法人（不认厂址）；天门同址待核不合并。所有制不猜（0观察），采购独立待建。市场层暂采用SQLite可重建增量，不引入后端依赖。
- validation: B0000专项CI 46146080794 success；下载15263318784 SHA256 8fb0719378c22f90d40dac4a758a39591eb4800c3efc6e7b776e66d6d5a8de14 一致，103 SQLite integrity ok/FK0，指标和商机跨厂水引用0。104新结构和测试由新专项CI执行，结果提交后查询，不预宣；本地未全量重建。
- blockers: A02仍需证据断言幂等导入和更多关系、所有制/采购核证；A03尚未实现真实共站/流股拓扑。无内部参数，未构造真实技术/商业匹配。没有进行重复互联网搜集。
- next: B0002/A02，优先现有关系和旧商机身份，完善幂等与冲突约束；按PROGRESS和MAPPING_CONTRACT验收。
