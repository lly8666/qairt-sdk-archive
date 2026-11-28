-- 112: ownership and actual-volume triage, not membrane eligible volume.
PRAGMA foreign_keys=ON;
BEGIN;
INSERT INTO sources VALUES
('S112-01','兄弟科技2026年半年度报告全文','https://money.finance.sina.com.cn/corp/view/vCB_AllBulletinDetail.php?id=12567482&stockid=002562','上市报告转载','2026-08-29','释义及在其他主体中的权益：江西兄弟医药直接全资','2026-11-28'),
('S112-02','兄弟科技2026年半年度报告摘要','https://static.cninfo.com.cn/finalpage/2026-08-29/1225525462.PDF','上市报告','2026-08-29','第3页实际控制人及报告期未变化','2026-11-28'),
('S112-03','大唐环境产业集团2025年年报','https://www1.hkexnews.hk/listedco/listconews/sehk/2026/0430/2026043003139_c.pdf','港交所披露','2026-04-30','年报155页子公司表：大唐江苏直接100%','2026-11-28'),
('S112-04','大唐环境2026年中期业绩公告','https://static.cninfo.com.cn/finalpage/2026-08-28/1225534092.PDF','上市披露','2026-08-28','中期简明合并财务资料附注1：最终控股中国大唐由国务院国资委全资拥有','2026-11-28');
INSERT INTO site_sources VALUES ('CN0207','S112-01'),('CN0207','S112-02'),('CN0063','S112-03'),('CN0063','S112-04');
INSERT INTO market_entities VALUES
('MO0038','organization','江西兄弟医药有限公司',NULL,NULL,NULL,'historical','2026H1','CN0207','S112-01','释义及子公司表','全资子公司法人，采购权限待核'),
('MO0039','organization','兄弟科技股份有限公司',NULL,NULL,NULL,'historical','2026H1','CN0207','S112-01','公司简介及子公司表','上市母公司，不分摊厂区水量'),
('MO0040','organization','大唐（江苏）环保装备有限公司',NULL,NULL,NULL,'historical','2025-12-31','CN0063','S112-03','第155页子公司表','直接全资法人，现有生产状态另看工艺证据'),
('MO0041','organization','大唐环境产业集团股份有限公司',NULL,NULL,NULL,'historical','2026H1','CN0063','S112-04','附注1','上市母公司，最终控制中国大唐集团');
INSERT INTO market_identity_links VALUES
('ML0064','CN0207','MO0038','legal_subject','evidence_linked','2026H1','S112-01','释义及子公司表','法人'),
('ML0065','CN0207','MO0039','group_scope','evidence_linked','2026H1','S112-01','子公司表','直接全资关系'),
('ML0066','CN0063','MO0040','legal_subject','evidence_linked','2025-12-31','S112-03','第155页','法人'),
('ML0067','CN0063','MO0041','group_scope','evidence_linked','2025-12-31','S112-03','第155页','直接全资关系');
INSERT INTO market_ownership_observations VALUES
('OW0024','MO0039','private_controlled','listed',NULL,'2026H1','evidence_linked','CN0207','S112-02','第3页股东及控制权','自然人共同控制'),
('OW0025','MO0038','private_controlled','unlisted','MO0039','2026H1','evidence_linked','CN0207','S112-01','释义及子公司表，结合S112-02','直接全资；民营控制不代表付款能力'),
('OW0026','MO0041','central_state_controlled','listed',NULL,'2026H1','evidence_linked','CN0063','S112-04','附注1','中国大唐最终控股，国务院国资委全资拥有中国大唐'),
('OW0027','MO0040','central_state_controlled','unlisted','MO0041','2025-12-31全资关系；2026H1母公司控制','evidence_linked','CN0063','S112-03','第155页，结合S112-04','历史直接全资关系；不推断当前采购权');
CREATE TABLE market_actual_volume_review(water_id TEXT PRIMARY KEY REFERENCES wastewater(water_id),scope_label TEXT NOT NULL,review_note TEXT NOT NULL);
INSERT INTO market_actual_volume_review VALUES
('W022-006','whole_site','全厂总排水，不作膜进水'),
('W026-01','production_aggregate','生产装置废水汇总，需分股确认'),
('W027-H12023','treatment_unit','重金属预处理1#历史实际处理量'),
('W027-H12024','treatment_unit','重金属预处理1#历史实际处理量'),
('W027-H22023','treatment_unit','重金属预处理2#历史实际处理量'),
('W027-H22024','treatment_unit','重金属预处理2#历史实际处理量'),
('W027-H42023','treatment_unit','高盐处理单元历史实际量'),
('W027-H42024','treatment_unit','高盐处理单元历史实际量；不可与2023相加'),
('W051-16','equipment_rate','三效蒸发小时量，非独立可处理年量'),
('W072-15','shared_or_total_outlet','东区总排口，不作膜进水'),
('W073-02','shared_station','西区共享站日量，不能分摊到厂'),
('W073-03','shared_or_total_outlet','西区共享站总排口'),
('W083-04','domestic','生活排水，不作生产废水商机'),
('W098-01','whole_site','现有项目全厂汇总，需分股');
CREATE VIEW v_workbench_actual_review AS SELECT a.*,w.site_id,w.stream,w.flow,w.flow_unit,w.flow_basis,w.source_id,w.stage FROM market_actual_volume_review a JOIN wastewater w USING(water_id);
COMMIT;
