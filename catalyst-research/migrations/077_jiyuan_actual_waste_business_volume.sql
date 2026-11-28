PRAGMA foreign_keys=ON;
BEGIN;
INSERT INTO sources(source_id,title,url,source_type,document_date,scope,access_date) VALUES ('S077-01','济源产城融合示范区2024年度固体废物污染环境防治信息公告','https://xxgk.www.jiyuan.gov.cn/swj/xxgk_swj/fdzdgk/gggs/t979619.html','WEB_PRIMARY','2025','表6，2024实际收集利用处置贮存量及许可能力','2026-11-28');
INSERT INTO sites(site_id,name,province,city,category,status,record_type,capacity_summary,water_level,priority,source_status,as_of,notes) VALUES ('CN0335','济源市显扬金属科技有限公司','河南','济源','废催化剂利用候选','2024年度官方许可及实际经营记录','候选','HW50许可1850t/a，2024实际经营27t，许可有效期表列2028-05-11','缺失','P1','部分复核','2026-11-28','实际量为收集利用处置贮存综合口径，非实际再生产品产量；厂址、工艺待核');
INSERT INTO site_sources(site_id,source_id) VALUES ('CN0332','S077-01'),('CN0335','S077-01');
UPDATE sites SET status='2024官方实际经营记录，现行运行待核',capacity_summary='20000t/a设计及2024许可；2024实际经营478t，许可表列有效期2028-01-13',as_of='2026-11-28' WHERE site_id='CN0332';
INSERT INTO capacity(capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES
('C077-01','CN0332','772-007-50废SCR',20000,'t/a','2024年度公告许可能力','2024','许可经营','S077-01','与设计2万吨相同口径，不叠加；有效期表列2028-01-13'),
('C077-02','CN0332','772-007-50废SCR',478,'t','官方年度实际经营量','2024','收集利用处置贮存合计','S077-01','原表0.0478万吨；不当作新剂产量、实际污水流量或当前负荷'),
('C077-03','CN0335','HW50废催化剂多代码',1850,'t/a','2024年度公告许可能力','2024','许可经营','S077-01','原表0.185万吨/年；有效期2028-05-11'),
('C077-04','CN0335','271-006-50废催化剂',27,'t','官方年度实际经营量','2024','收集利用处置贮存合计','S077-01','原表0.0027万吨；非实际新剂产量');
INSERT INTO evidence_notes(note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES
('N077-01','CN0332','S077-01','实际年度经营量','表6青骐骥行及表头','2024许可2万吨/年，772-007-50实际经营0.0478万吨=478t，许可有效期表列2028-01-13；该量是收集利用处置贮存合计，不能推导实际污水或膜运行量。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N077-02','CN0335','S077-01','许可与实际经营量','表6显扬行及表头','HW50多代码许可0.185万吨/年；2024实际271-006-50 0.0027万吨=27t；有效期表列2028-05-11；待查是否为专项再生及工艺，非新剂。','WEB_PRIMARY','WEB_TEXT','2026-11-28');
INSERT INTO tasks(task_id,site_id,priority,missing,next_query,state) VALUES ('T0335','CN0335','P1','厂址、利用工艺、水处理、现行许可','查济源生态环境局环评、许可、验收','部分完成');
INSERT INTO search_log(log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES
('L077-01','CN0332','077官方年度经营量','济源2024固废公告表6青骐骥','S077-01','新增历史实际经营量与许可期限','新年度公告及验收监测','2026-11-28'),
('L077-02','CN0335','077官方年度经营量','济源2024固废公告表6显扬','S077-01','新增候选及历史经营量','环评、许可和实际工艺','2026-11-28');
INSERT INTO research_revisit_attempts(attempt_id,site_id,scope_key,gap,route_key,search_log_id,source_id,checked_on,outcome,gained_fields,evidence_refs,effort_minutes,next_check_on,reopen_trigger,rationale) VALUES
('A077-01','CN0332','site_current','年度实际经营量','official_annual_waste_report','L077-01','S077-01','2026-11-28','context_gain','2024实际经营量478t及期限','C077-01–02/N077-01',NULL,'2027-02-28','新年度报告/验收','非实际生产或水量'),
('A077-02','CN0335','site_current','许可与年度实际经营量','official_annual_waste_report','L077-02','S077-01','2026-11-28','context_gain','新增候选及2024实际经营量27t','C077-03–04/N077-02',NULL,'2027-02-28','新年度报告/许可变更','仅经营边界，不添加无证据流程');
COMMIT;
