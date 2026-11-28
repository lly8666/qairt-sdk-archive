-- 111: public evidence for practical sales and engineering workflow.
PRAGMA foreign_keys=ON;
BEGIN;
INSERT INTO sources VALUES
('S111-01','昊华科技关于2026年度对外担保计划的公告','https://money.finance.sina.com.cn/corp/view/vCB_AllBulletinDetail.php?id=12170007&stockid=600378','上市公告转载','2026-04-24','被担保方西南化工（眉山）有限公司基本情况及关联关系：全资子公司','2026-11-28'),
('S111-02','昊华科技2026年第三季度报告','https://money.finance.sina.com.cn/corp/view/vCB_AllBulletinDetail.php?id=12675907&stockid=600378','上市报告转载','2026-10-30','股东变化说明：2026-07-15过户后中国昊华仍为控股股东，国务院国资委仍为实际控制人','2026-11-28');
INSERT INTO site_sources VALUES ('CN0202','S111-01'),('CN0202','S111-02');
INSERT INTO market_entities VALUES
('MO0037','organization','昊华化工科技集团股份有限公司',NULL,NULL,NULL,'historical','2026Q3','CN0202','S111-02','股份转让说明','上市集团；与眉山厂区采购授权独立');
INSERT INTO market_identity_links VALUES
('ML0063','CN0202','MO0037','group_scope','evidence_linked','2026-04-24','S111-01','关联关系','合并范围全资子公司关系；不认定直接持股链或采购权');
INSERT INTO market_ownership_observations VALUES
('OW0022','MO0037','central_state_controlled','listed',NULL,'2026Q3','evidence_linked','CN0202','S111-02','股份转让说明','国务院国资委实际控制'),
('OW0023','MO0021','central_state_controlled','unlisted','MO0037','2026-04-24全资关系；2026Q3集团控制权','evidence_linked','CN0202','S111-01','被担保人关联关系；结合S111-02','上市公司合并范围全资子公司，央企控制链；不推断直接股权比例或采购方式');
CREATE VIEW v_workbench_sales_scope AS
SELECT p.*,
 (SELECT count(*) FROM v_workbench_contact_routes r WHERE r.site_id=p.site_id AND r.public_work_channel IS NOT NULL) AS usable_channels,
 (SELECT count(*) FROM v_workbench_contact_routes r WHERE r.site_id=p.site_id AND r.public_work_channel IS NOT NULL AND r.contact_scope='site') AS site_channels,
 (SELECT group_concat(DISTINCT ownership_class) FROM v_market_ownership_review o WHERE o.site_id=p.site_id AND o.link_role='legal_subject' AND o.evidence_state='evidence_linked') AS legal_ownership,
 (SELECT group_concat(DISTINCT ownership_class) FROM v_market_ownership_review o WHERE o.site_id=p.site_id AND o.link_role='group_scope' AND o.evidence_state='evidence_linked') AS group_ownership
FROM v_workbench_priority p;
CREATE VIEW v_workbench_signal_evidence AS
SELECT s.*,q.quantity_class,
 (SELECT count(*) FROM water_metrics m WHERE m.water_id=s.water_id AND m.site_id=s.site_id AND m.source_id=s.source_id AND m.value_num IS NOT NULL AND m.unit IN ('mg/L','g/L','μg/L','µg/L')) AS same_source_concentration_records,
 (SELECT count(*) FROM water_economics e WHERE e.water_id=s.water_id AND e.site_id=s.site_id) AS linked_cost_records
FROM v_workbench_water_signals s JOIN v_water_quantity_basis_audit q USING(water_id,site_id);
COMMIT;
