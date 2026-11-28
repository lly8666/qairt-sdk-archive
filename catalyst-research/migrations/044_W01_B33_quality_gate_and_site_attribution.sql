-- 044: fix source identity and quality-aware closure; no fabricated measurements.
PRAGMA foreign_keys=ON;
BEGIN;
INSERT OR IGNORE INTO site_sources(site_id,source_id) VALUES('CN0190','W01B2S20');
UPDATE sources SET title='众智企业介绍（两家企业分节）',document_date='2024-08-27',scope='众智创新西中岛与众智长兴两家企业分别介绍；建设计划及历史开车自述，非验收' WHERE source_id='W01B2S20';
UPDATE capacity SET site_id='CN0197',source_id='W01B2S20',period='2024-08-27',notes='众智长兴第二项目（精细化工园区）；原文3000吨未标周期；非催化剂产能、非本厂污水处理量' WHERE capacity_id='C043-10';
UPDATE evidence_notes SET site_id='CN0197',source_id='W01B2S20',locator='众智长兴公司介绍第二项目；2024-08-27',detail='同集团不同厂区。众智长兴精细化工园区第二项目拟从恒力石化污水中提取溴用于钴锰溴催化剂，3000吨氢溴酸（钠）装置周期未标；非众智创新西中岛厂，也非众智长兴本厂污水站。' WHERE note_id='N043-09';
UPDATE search_log SET source_id='W01B2S20',result='原URL同时介绍两家企业；043归属修正：提溴装置属于CN0197众智长兴第二项目，不属于CN0190众智创新。保留检索轨迹。' WHERE log_id='L043-08';
DELETE FROM site_sources WHERE source_id='S043-06';
DELETE FROM sources WHERE source_id='S043-06';
INSERT INTO site_relations(relation_id,site_id,other_site_id,relation,status,source_id,notes) VALUES('REL044-01','CN0190','CN0197','同集团不同企业','院校刊载企业自述','W01B2S20','原文分别介绍西中岛众智创新和众智长兴；不合并厂区/许可证，不串用污水及产能。');
INSERT INTO capacity(capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES
('C044-01','CN0190','失活催化剂处置',50000,'t/a','企业介绍项目达产规划','2024-08-27','西中岛第二项目','W01B2S20','企业称2023-09开工；非实际处理量或现行许可；不与2万吨既有许可直接相加'),
('C044-02','CN0197','异辛酸钼',1000,'t/a','企业介绍项目全部建成预计','2024-08-27','医药园区第一项目','W01B2S20','原文预计年产；未核投产'),
('C044-03','CN0197','丁二醇催化剂',6000,'t/a','企业介绍项目全部建成预计','2024-08-27','医药园区第一项目','W01B2S20','原文预计年产；未核投产'),
('C044-04','CN0197','丁二酸催化剂',3000,'t/a','企业介绍项目全部建成预计','2024-08-27','医药园区第一项目','W01B2S20','原文预计年产；未核投产');
INSERT INTO projects(project_id,site_id,project,status,date,capacity_note,water_change,source_id) VALUES
('P044-01','CN0190','西中岛5万吨失活催化剂处置项目','2024企业称2023-09开工','2024-08-27','5万吨/年处置；回收各种产品约4万吨/年；均为规划','污水站及实际运行未披露','W01B2S20'),
('P044-02','CN0197','医药园区有色金属、贵金属催化剂项目','2024企业自述一车间开始生产，三车间即将投产','2024-08-27','各产品规划及历史开车线索，不等于全项目投产','本厂废水站未知','W01B2S20'),
('P044-03','CN0197','精细化工园区钴锰溴三元催化剂及精细化学品项目','2024企业自述规划许可办理、环评同步开展','2024-08-27','氢溴酸（钠）装置3000吨，周期未标','利用上游恒力污水提溴；非厂内污水处理能力','W01B2S20');
INSERT INTO evidence_notes(note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES('N044-01','CN0190','W01B2S20','两期回收项目边界','众智创新公司介绍','企业2024年自述已建2万吨渣油加氢催化剂回收装置，另5万吨失活催化剂处置项目2023-09开工；后者达产规划，不代表核发许可或实际处理。两项目水工艺尚待核。','WEB_SECONDARY','公开正文/索引，未归档原件','2026-11-28');
-- Keep all metric records, but only concentration/property records qualify as preliminary water-quality evidence.
DROP VIEW v_research_evidence_gaps;
CREATE VIEW v_research_evidence_gaps AS
WITH w AS (SELECT site_id,count(*) AS water_records,sum(CASE WHEN flow IS NOT NULL THEN 1 ELSE 0 END) AS numeric_water_records FROM wastewater GROUP BY site_id),
m AS (SELECT site_id,count(*) AS metric_records,sum(CASE WHEN value_num IS NOT NULL THEN 1 ELSE 0 END) AS numeric_metrics,
sum(CASE WHEN (unit IN ('mg/L','ppm','NTU','μS/cm','MPN/L') OR (unit='无量纲' AND metric='pH') OR (unit='倍' AND metric='色度') OR (unit='%' AND metric IN ('盐分','NaCl')) OR (unit='℃' AND metric='水温'))
AND (value_num IS NOT NULL OR length(trim(COALESCE(value_text,'')))>0)
AND result_kind NOT IN ('接管标准','接收限值','协议限值','设计限值','环评设计限值','采购要求小于该值','采购目标上限','设计控制值','设计控制范围')
AND metric NOT LIKE '%接管限值%' THEN 1 ELSE 0 END) AS quality_point_records FROM water_metrics GROUP BY site_id),
c AS (SELECT site_id,count(*) AS economics_records,sum(CASE WHEN item LIKE '%成本%' OR item LIKE '%运行费%' OR item LIKE '%污水处理费%' THEN 1 ELSE 0 END) AS cost_related_records FROM water_economics GROUP BY site_id),
p AS (SELECT site_id,count(*) AS latest_review_scopes,sum(CASE WHEN presence='confirmed_present' THEN 1 ELSE 0 END) AS any_stage_membrane_scopes,sum(CASE WHEN stage='operating' AND presence='confirmed_present' THEN 1 ELSE 0 END) AS operating_membrane_scopes FROM v_latest_membrane_reviews GROUP BY site_id),
l AS (SELECT site_id,count(*) AS logged_searches FROM search_log GROUP BY site_id),
sc AS (SELECT site_id,count(*) AS linked_sources,sum(CASE WHEN s.url IS NOT NULL AND length(trim(s.url))>0 THEN 1 ELSE 0 END) AS linked_url_sources FROM site_sources JOIN sources s USING(source_id) GROUP BY site_id)
SELECT q.site_id,q.name,q.priority,q.record_type,q.status,q.water_level,q.diagram_count,q.operating_complete_diagrams,
COALESCE(t.disposition,'no_task') AS disposition,COALESCE(w.water_records,0) AS water_records,COALESCE(w.numeric_water_records,0) AS numeric_water_records,
COALESCE(m.metric_records,0) AS metric_records,COALESCE(m.numeric_metrics,0) AS numeric_metrics,COALESCE(c.economics_records,0) AS economics_records,COALESCE(c.cost_related_records,0) AS cost_related_records,
COALESCE(p.latest_review_scopes,0) AS latest_review_scopes,COALESCE(p.any_stage_membrane_scopes,0) AS any_stage_membrane_scopes,COALESCE(p.operating_membrane_scopes,0) AS operating_membrane_scopes,
COALESCE(l.logged_searches,0) AS logged_searches,COALESCE(sc.linked_sources,0) AS linked_sources,COALESCE(sc.linked_url_sources,0) AS linked_url_sources,
CASE WHEN COALESCE(t.disposition,'no_task') NOT LIKE 'active%' THEN '暂缓/无任务'
WHEN q.diagram_count=0 AND COALESCE(sc.linked_url_sources,0)=0 THEN '先核厂区身份及可检索原始资料'
WHEN q.diagram_count=0 THEN '先取站工艺及分流证据'
WHEN COALESCE(w.numeric_water_records,0)=0 THEN '补分股水量/站能力'
WHEN COALESCE(m.quality_point_records,0)=0 THEN '补测点及水质'
WHEN COALESCE(p.operating_membrane_scopes,0)=0 THEN '核实际运行阶段及膜/非膜清单'
WHEN COALESCE(c.cost_related_records,0)=0 THEN '补同边界实际成本'
ELSE '复核范围、时间、运行成本及实际改造条件' END AS next_gap,
COALESCE(m.quality_point_records,0) AS quality_point_records
FROM v_process_membrane_queue q LEFT JOIN v_actionable_research_tasks t USING(site_id)
LEFT JOIN w USING(site_id) LEFT JOIN m USING(site_id) LEFT JOIN c USING(site_id) LEFT JOIN p USING(site_id) LEFT JOIN l USING(site_id) LEFT JOIN sc USING(site_id);
COMMIT;
