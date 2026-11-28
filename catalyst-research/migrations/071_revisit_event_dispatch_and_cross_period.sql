PRAGMA foreign_keys=ON;
BEGIN;
INSERT INTO sources(source_id,title,url,source_type,document_date,scope,access_date) VALUES
('S071-01','浙江德创环保2023年年度报告','https://vip.stock.finance.sina.com.cn/corp/view/vCB_AllBulletinDetail.php?id=10088517','WEB_COMPANY','2024-04','2023报告期母厂排口及排污信息','2026-11-28'),
('S071-02','浙江德创环保2024年年度报告','https://money.finance.sina.com.cn/corp/view/vCB_AllBulletinDetail.php?id=11037175&stockid=603177','WEB_COMPANY','2025-04-29','2024报告期母厂排口及排污信息','2026-11-28'),
('S071-03','德创环保官网新闻中心2026年第三季度监测报告索引','https://www.zj-tuna.com/index.php?z=%2Fnews%2Findex.html','WEB_COMPANY','2026-10-20','仅确认第三季度报告索引；附件未取得','2026-11-28');
INSERT INTO site_sources VALUES ('CN0062','S071-01'),('CN0062','S071-02'),('CN0062','S071-03');
INSERT INTO wastewater(water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES
('W071-01','CN0062','德创DW001（年报列催化剂生产装置）','2023报告期',NULL,NULL,NULL,'COD、氨氮',NULL,'连续纳管',NULL,'S071-01','WEB_COMPANY','排口表口径；非2026当前状态；无实测水量'),
('W071-02','CN0062','德创DW001（年报列生活废水）','2024报告期',NULL,NULL,NULL,'COD、氨氮','生活水化粪池','连续纳管',NULL,'S071-02','WEB_COMPANY','2024排口描述变化；同报告另述生产废水隔油沉淀后纳管；不能据此认定工艺废水消失或将生活水量当生产水量');
INSERT INTO water_metrics(metric_id,site_id,water_id,point,metric,value_num,unit,result_kind,statistic,period,standard_max,source_id,notes) VALUES
('M071-001','CN0062','W071-01','德创DW001','COD',40,'mg/L','年报实际排放浓度','报告表列','2023',500,'S071-01','浓度统计方式未披露'),
('M071-002','CN0062','W071-01','德创DW001','氨氮',10.6,'mg/L','年报实际排放浓度','报告表列','2023',35,'S071-01','浓度统计方式未披露'),
('M071-003','CN0062','W071-01','德创DW001','COD年排放量',0.87,'t/a','年报实际排放量','年度','2023',1.6,'S071-01','许可量作为标准上限；不得倒算水量'),
('M071-004','CN0062','W071-01','德创DW001','氨氮年排放量',0.11,'t/a','年报实际排放量','年度','2023',0.2,'S071-01','不得倒算水量'),
('M071-005','CN0062','W071-02','德创DW001','COD',102,'mg/L','年报实际排放浓度','报告表列','2024',500,'S071-02','生活废水口径'),
('M071-006','CN0062','W071-02','德创DW001','氨氮',31.2,'mg/L','年报实际排放浓度','报告表列','2024',35,'S071-02','生活废水口径'),
('M071-007','CN0062','W071-02','德创DW001','COD年排放量',1.1,'t/a','年报实际排放量','年度','2024',1.6,'S071-02','不得倒算水量'),
('M071-008','CN0062','W071-02','德创DW001','氨氮年排放量',0.13,'t/a','年报实际排放量','年度','2024',0.2,'S071-02','不得倒算水量');
INSERT INTO evidence_notes VALUES
('N071-01','CN0062','S071-02','跨期排口范围冲突','2023、2024年报环境信息章节','2023排口称催化剂生产装置，2024排口称生活废水；2024正文另述模具清洗、冷凝、冲洗生产水隔油沉淀纳管及氨吸收液回混料。不得直接比较两个时期工业污染负荷，飞乐和越信设施不归母厂。','WEB_COMPANY','WEB_TEXT','2026-11-28'),
('N071-02','CN0062','S071-03','新监测报告入口','官网新闻中心索引','2026年10月20日第三季度环境监测报告索引，正文复开未获得附件，下一次定向查新报告路径；不把索引当实测。','WEB_COMPANY','WEB_TEXT','2026-11-28');
INSERT INTO search_log VALUES
('L071-01','CN0062','071跨期核证','德创2023/2024年报排口及官网2026Q3监测索引','S071-02','新增两个时期8项排放记录；排口范围变化；2026附件未取','定向查2026年实际监测附件及厂区分流','2026-11-28'),
('L071-02','CN0279','071原文核证','2023验收意见分股水量','S035-01','原验收意见pp2-4截图和正文复核，20项指标均已记录；意见未给流量','只查独立验收监测报告正文、排污许可或新验收，不重复打开意见','2026-11-28');
INSERT INTO research_revisit_attempts VALUES
('A071-001','CN0062','site_current','补测点及水质','annual_report','L071-01','S071-02','2026-11-28','engineering_gain','跨期排口浓度、年度负荷、范围变化','W071-01/02; M071-001—008; N071-01/02',NULL,'2026-12-12','2026Q3原监测附件或新季度发布','历史年报数据非当前；下一次仅查新附件'),
('A071-002','CN0279','site_current','补分股水量/站能力','document:S035-01','L071-02','S035-01','2026-11-28','duplicate','无新增','M035-001—020已存在',NULL,NULL,'完整验收监测报告或许可水量','意见已读完，不再重开同一意见');
INSERT INTO research_document_review VALUES ('CN0279','S035-01','site_current','补分股水量/站能力','2026-11-28','section_done','验收意见第3、4节','意见无流量，完整监测报告为独立文件',NULL,'A071-002');
-- New events stand alone, including tracks never attempted. Do not auto-lift existing site/gap holds.
CREATE UNIQUE INDEX uq_research_reopen_event_identity ON research_reopen_events(site_id,scope_key,gap,route_key,event_kind,source_id);
CREATE VIEW v_research_pending_events AS
SELECT e.*,s.name,a.attempt_id AS prior_attempt_id,a.next_check_on,
q.public_disposition,
CASE WHEN q.public_disposition IN ('core_public','bounded_public') THEN 'review_event'
ELSE 'review_hold_before_reopen' END AS event_action
FROM research_reopen_events e JOIN sites s USING(site_id)
LEFT JOIN v_research_revisit_latest a ON a.site_id=e.site_id AND a.scope_key=e.scope_key AND a.gap=e.gap AND a.route_key=e.route_key
LEFT JOIN v_public_research_queue q ON q.site_id=e.site_id WHERE e.consumed_by_attempt IS NULL;
CREATE TRIGGER research_event_consume_insert BEFORE INSERT ON research_reopen_events
WHEN NEW.consumed_by_attempt IS NOT NULL AND NOT EXISTS(SELECT 1 FROM research_revisit_attempts a WHERE a.attempt_id=NEW.consumed_by_attempt AND a.site_id=NEW.site_id AND a.scope_key=NEW.scope_key AND a.gap=NEW.gap AND a.route_key=NEW.route_key AND a.checked_on>=NEW.observed_on)
BEGIN SELECT RAISE(ABORT,'event consumption track/date mismatch'); END;
CREATE TRIGGER research_event_consume_update BEFORE UPDATE ON research_reopen_events
WHEN NEW.consumed_by_attempt IS NOT NULL AND NOT EXISTS(SELECT 1 FROM research_revisit_attempts a WHERE a.attempt_id=NEW.consumed_by_attempt AND a.site_id=NEW.site_id AND a.scope_key=NEW.scope_key AND a.gap=NEW.gap AND a.route_key=NEW.route_key AND a.checked_on>=NEW.observed_on)
BEGIN SELECT RAISE(ABORT,'event consumption track/date mismatch'); END;
INSERT INTO research_reopen_events VALUES
('E071-01','CN0062','site_current','补测点及水质','monitoring_attachment','新监测报告索引','S071-03','2026-11-28','官网2026Q3监测索引已发现；仅需定向核附件及范围，不作通用搜索',NULL),
('E071-02','CN0063','19000t_recovery','污水设备采购节点','tender_index','中标候选公示索引','S070-02','2026-11-28','索引已处理，后续官方结果另建事件','A070-004'),
('E071-03','CN0093','flexible_catalyst','项目审批及采购节点','regulator_and_tender','正式审批目录','S070-03','2026-11-28','正式审批目录已处理，全文另行查','A070-005');
DROP VIEW v_research_dispatch;
CREATE VIEW v_research_dispatch AS
SELECT q.*,a.checked_on AS last_structured_review,a.outcome AS last_outcome,a.next_check_on,a.reopen_trigger AS revisit_trigger,
(SELECT count(*) FROM v_research_pending_events e WHERE e.site_id=q.site_id) AS pending_event_count,
CASE WHEN q.public_disposition NOT IN ('core_public','bounded_public') THEN 'preserve_'||q.public_disposition
WHEN EXISTS(SELECT 1 FROM v_research_pending_events e WHERE e.site_id=q.site_id AND e.scope_key='site_current' AND e.gap=q.next_gap AND e.route_key='general_public') THEN 'review_new_event'
WHEN a.revisit_status='event_ready' THEN 'review_new_event'
WHEN a.revisit_status='cooldown' THEN 'pause_generic_search'
WHEN a.revisit_status='event_only' THEN 'await_event'
WHEN a.revisit_status='due' THEN 'bounded_new_path'
ELSE 'unassessed_use_original_queue' END AS dispatch_action
FROM v_public_research_queue q LEFT JOIN v_research_revisit_due a ON a.site_id=q.site_id AND a.scope_key='site_current' AND a.gap=q.next_gap AND a.route_key='general_public';
COMMIT;
