-- 107: practical full-market screening, not a claim of demand or current operation.
PRAGMA foreign_keys=ON;
BEGIN;
INSERT INTO sources VALUES
('S107-01','齐鲁华信关于授权公司为全资子公司提供担保额度的公告','https://money.finance.sina.com.cn/corp/view/vCB_AllBulletinDetail.php?id=12680941&stockid=920832','上市公告转载','2026-10-29','全资子公司山东齐鲁华信高科有限公司，注册地址及企业类型','2026-11-28'),
('S107-02','润和催化2026年半年度报告','https://xinsanban.eastmoney.com/Article/NoticeContent?id=AN202608261828478024','挂牌公司报告转载','2026-08-26','释义、公司概况、实际控制人；浙江润和子公司关系','2026-11-28'),
('S107-03','三美股份控股股东及其一致行动人权益变动暨减持结果公告','https://paper.cnstock.com/html/2026-03/03/content_2183966.htm','上市公司公告转载','2026-03-03','自然人控股股东、实际控制人披露','2026-11-28');
INSERT INTO site_sources VALUES
('CN0027','S107-01'),
('CN0028','S107-01'),
('CN0019','S107-02'),
('CN0214','S107-03');
INSERT INTO market_entities VALUES
('MO0031','organization','山东齐鲁华信实业股份有限公司',NULL,NULL,NULL,'historical','2026H1','CN0027','turn127831search10','实际控制人章节','母公司法人；不分摊子公司水量'),
('MO0032','organization','山东齐鲁华信高科有限公司',NULL,NULL,NULL,'historical','2026-10-29','CN0028','S107-01','被担保人基本情况','全资子公司；注册地不直接等同生产地址'),
('MO0033','organization','润和催化剂股份有限公司',NULL,NULL,NULL,'historical','2026H1','CN0019','S107-02','释义、实际控制人','浙江项目母公司；非项目具体采购主体'),
('MO0034','organization','润和催化材料（浙江）有限公司',NULL,NULL,NULL,'historical','2026H1','CN0019','S107-02','释义浙江润和','子公司；投运及实际控制链细节待核'),
('MO0035','organization','浙江三美化工股份有限公司',NULL,NULL,NULL,'historical','2026-03-03','CN0214','S107-03','控股股东及实际控制人公告','项目关联法人；采购主体待核');
INSERT INTO market_identity_links VALUES
('ML0055','CN0027','MO0031','legal_subject','evidence_linked','2026H1','turn127831search10','实际控制人章节','母公司法人'),
('ML0056','CN0028','MO0032','legal_subject','evidence_linked','2026-10-29','S107-01','被担保人基本情况','全资子公司法人'),
('ML0057','CN0028','MO0031','group_scope','evidence_linked','2026-10-29','S107-01','全资子公司担保','集团归属；不合并水量'),
('ML0058','CN0019','MO0033','group_scope','evidence_linked','2026H1','S107-02','释义','母公司'),
('ML0059','CN0019','MO0034','legal_subject','evidence_linked','2026H1','S107-02','释义','浙江项目法人'),
('ML0060','CN0214','MO0035','legal_subject','evidence_linked','2026-03-03','S107-03','公告主体','法人及项目范围独立');
INSERT INTO market_ownership_observations VALUES
('OW0013','MO0003','private_controlled','unlisted',NULL,'2025年报','evidence_linked','CN0082','W07S14','公司概况/实际控制人','自然人控制，全国股转系统挂牌，不等于交易所上市'),
('OW0014','MO0031','private_controlled','listed',NULL,'2026H1','evidence_linked','CN0027','turn127831search10','实际控制人章节','十名自然人一致行动；报告期控制权'),
('OW0015','MO0032','private_controlled','unlisted','MO0031','2026-10-29','evidence_linked','CN0028','S107-01','被担保人及全资关系，结合2026H1','全资子公司，母公司控制证据来自turn127831search10；非采购授权'),
('OW0016','MO0033','private_controlled','unlisted',NULL,'2026H1','evidence_linked','CN0019','S107-02','控股股东及实际控制人','自然人控制，股转系统挂牌'),
('OW0017','MO0035','private_controlled','listed',NULL,'2026-03-03','evidence_linked','CN0214','S107-03','实际控制人','自然人控制；催化剂项目不是独立法人');
CREATE VIEW v_workbench_subjects AS
SELECT a.*,CASE WHEN record_type LIKE '%候选%' THEN 'candidate' WHEN record_type='退出' THEN 'inactive' WHEN record_type IN ('企业','集团/待拆分','销售/集团主体') THEN 'organization' WHEN record_type IN ('研发项目') THEN 'research' WHEN record_type LIKE '%项目%' THEN 'project_scope' WHEN record_type IN ('基地','厂区','载体基地','纯回收','回收利用') THEN 'facility_scope' ELSE 'unresolved' END AS subject_scope,
 (SELECT count(*) FROM business_contacts b WHERE b.site_id=a.site_id) AS contact_count,
 (SELECT count(*) FROM water_economics e WHERE e.site_id=a.site_id) AS cost_count
FROM v_market_app_catalog a;
CREATE VIEW v_workbench_relations AS
SELECT r.*,CASE WHEN status LIKE '%待%' OR status LIKE '%需核%' THEN 'review' ELSE 'dated_evidence' END AS review_hint FROM v_market_legacy_relations r;
-- Keyword classification is a navigation aid only, never a claim of concentration, applicability or verified process.
CREATE TABLE market_screen_terms (direction TEXT NOT NULL,field_scope TEXT NOT NULL CHECK(field_scope IN ('water','process')),term TEXT NOT NULL,PRIMARY KEY(direction,field_scope,term));
INSERT INTO market_screen_terms VALUES
('high_salt','water','高盐'),
('high_salt','water','含盐'),
('high_salt','water','盐水'),
('high_salt','water','硫酸钠'),
('high_salt','water','硝酸钠'),
('high_salt','water','氯化钠'),
('high_salt','water','盐分'),
('high_salt','water','母液'),
('ammonia','water','高氨'),
('ammonia','water','氨氮'),
('ammonia','water','铵盐'),
('ammonia','water','氯化铵'),
('ammonia','water','硫酸铵'),
('ammonia','water','氨水'),
('metal_recovery','water','贵金属'),
('metal_recovery','water','重金属'),
('metal_recovery','water','含铬'),
('metal_recovery','water','含镍'),
('metal_recovery','water','含铜'),
('metal_recovery','water','含钒'),
('metal_recovery','water','含钨'),
('metal_recovery','water','含钼'),
('metal_recovery','water','含钯'),
('metal_recovery','water','含铂'),
('metal_recovery','water','金属离子'),
('organic','water','高浓有机'),
('organic','water','高有机'),
('organic','water','有机废水'),
('organic','water','高COD'),
('organic','water','高浓度COD'),
('organic','water','溶剂'),
('evaporation','process','蒸发'),
('evaporation','process','MVR'),
('evaporation','process','多效'),
('evaporation','process','三效'),
('evaporation','process','浓缩结晶'),
('reuse','process','回用'),
('reuse','process','回收水'),
('reuse','process','中水'),
('reuse','process','零排放'),
('external_disposal','process','委外'),
('external_disposal','process','外委'),
('external_disposal','process','危废'),
('external_disposal','process','委托处置'),
('membrane_optimization','process','反渗透'),
('membrane_optimization','process','纳滤'),
('membrane_optimization','process','超滤'),
('membrane_optimization','process','膜浓缩'),
('membrane_optimization','process','CFRO'),
('membrane_optimization','process','MBR'),
('membrane_optimization','process','电渗析'),
('membrane_optimization','process','双极膜'),
('membrane_optimization','process','RO膜');
CREATE VIEW v_workbench_water_signals AS
SELECT w.site_id,w.water_id,t.direction,w.source_id,w.stage,w.stream,w.flow,w.flow_unit,w.flow_basis,w.pollutants,w.process,w.destination,w.residuals,group_concat(t.term,'、') AS matched_terms
FROM wastewater w JOIN market_screen_terms t ON
 CASE t.field_scope WHEN 'water' THEN instr(lower(coalesce(w.stream,'')||' '||coalesce(w.pollutants,'')),lower(t.term))
 ELSE instr(lower(coalesce(w.process,'')||' '||coalesce(w.destination,'')||' '||coalesce(w.residuals,'')),lower(t.term)) END>0
GROUP BY w.water_id,t.direction;
CREATE VIEW v_workbench_equipment AS
SELECT r.site_id,u.unit_id,u.technology,u.unit_label,u.role,u.specification,r.stage,r.period,r.application_boundary,r.presence,u.source_id,u.locator
FROM v_membrane_evidence_boundaries r JOIN membrane_units u USING(review_id);
CREATE VIEW v_workbench_candidates AS
WITH tags AS (
 SELECT site_id,direction,count(DISTINCT water_id) AS water_records FROM v_workbench_water_signals GROUP BY site_id,direction
), seeds AS (
 SELECT site_id,CASE opportunity_type WHEN 'evaporation_reduction' THEN 'evaporation' WHEN 'ammonia_cost' THEN 'ammonia' WHEN 'metal_resource_recovery' THEN 'metal_recovery' WHEN 'resource_recovery' THEN 'resource_recovery' WHEN 'installed_membrane_optimization' THEN 'membrane_optimization' ELSE opportunity_type END AS direction,priority_band,evidence_signal,qualification_gap FROM commercial_opportunity_screen
), keys AS (SELECT site_id,direction FROM tags UNION SELECT site_id,direction FROM seeds)
SELECT k.site_id||':'||k.direction AS candidate_id,k.site_id,k.direction,coalesce(t.water_records,0) AS water_records,s.priority_band,s.evidence_signal,s.qualification_gap,
 'research_signal_not_confirmed_demand' AS state
FROM keys k LEFT JOIN tags t USING(site_id,direction) LEFT JOIN seeds s USING(site_id,direction);
CREATE VIEW v_workbench_priority AS
SELECT s.*, (SELECT count(*) FROM v_workbench_candidates c WHERE c.site_id=s.site_id) AS direction_count,
 CASE WHEN subject_scope IN ('candidate','inactive','organization','research','unresolved') THEN 'scope_review'
 WHEN seed_count>0 THEN 'seed_review'
 WHEN EXISTS(SELECT 1 FROM v_workbench_candidates c WHERE c.site_id=s.site_id) AND contact_count>0 THEN 'signal_and_channel'
 WHEN EXISTS(SELECT 1 FROM v_workbench_candidates c WHERE c.site_id=s.site_id) THEN 'signal_review'
 ELSE 'water_evidence_gap' END AS research_queue
FROM v_workbench_subjects s;
CREATE VIEW v_workbench_contact_routes AS
SELECT contact_id,site_id,organization,contact_scope,department,channel_type,
 CASE WHEN contact_scope IN ('company','group','site') AND verification_status='official_publication'
 AND channel_type IN ('work_phone','business_email','official_form','supplier_portal')
 AND (department NOT LIKE '%投资者%' AND department NOT LIKE '%披露%' AND department NOT LIKE '%监督%' AND department NOT LIKE '%公众参与%' AND department NOT LIKE '%环评%')
 AND (use_boundary NOT LIKE '%仅投资者%' AND use_boundary NOT LIKE '%公众参与%' AND use_boundary NOT LIKE '%监督用途%' AND use_boundary NOT LIKE '%披露电话%')
 AND (public_name IS NULL OR trim(public_name)='') THEN channel_value ELSE NULL END AS public_work_channel,
 verification_status,use_boundary,source_id FROM business_contacts;
COMMIT;
