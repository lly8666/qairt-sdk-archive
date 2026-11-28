PRAGMA foreign_keys=ON;
BEGIN;
UPDATE tasks SET priority=(SELECT priority FROM sites WHERE sites.site_id=tasks.site_id) WHERE task_id IN ('T0350','T0351','T0352','T0353','T0354','T0355','T0356','T0357','T0358');
INSERT INTO sources(source_id,title,url,source_type,document_date,scope,access_date) VALUES
('S087-01','贺利氏拟转移至云南铂亚实施方案附件','https://njna.nanjing.gov.cn/njsjbxqglwyh/202604/P020260421539794044459.pdf','WEB_PRIMARY','2026-04','定向检索可见第三部分表1及部分表2，附件13.7MB复开受限，未获完整PDF截图','2026-11-28'),
('S087-02','云南铂亚企业资料页','https://www.innohere.com/ir/137790/general.html','WEB_SECONDARY',NULL,'第三方企业地址，非许可设施地址原件','2026-11-28'),
('S087-03','郑州航空港区涉重金属企业全口径清单','https://m.zzhkgq.gov.cn/2023/10-09/3397509.html','WEB_PRIMARY','2023-10-09','序号5历史已投产及所在地','2026-11-28'),
('S087-04','河南心连心化学工业集团2025年1月公开环境信息','https://www.hnxlx.com/News/content/cid/63/id/2975.html','WEB_COMPANY','2025-01-03','固废清单4.3t年产生量及最终去向，非接收企业联单','2026-11-28');
INSERT INTO site_sources(site_id,source_id) VALUES ('CN0354','S087-01'),('CN0354','S087-02'),('CN0356','S087-03'),('CN0356','S087-04');
INSERT INTO capacity(capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES
('C087-01','CN0354','HW50废催化剂',1050,'t/a','2026转移方案附件索引表1许可','2024-05-27至2029-05-26','综合许可分项','S087-01','3000t/a为18类危废总规模，不是HW50；原PDF受限，定向检索正文可读'),
('C087-02','CN0354','多类别危废综合',3000,'t/a','2026转移方案附件索引表1许可','2024-05-27至2029-05-26','综合许可','S087-01','含1050t/a HW50，不叠加原项目名C086-11');
UPDATE sites SET permit_id='Y5301130180',address='昆明市东川区碧谷四方地工业园区南片区（第三方企业地址）',status='2026转移材料载2024-05-27至2029-05-26许可；实际运行待核',capacity_summary='综合许可3000t/a，其中HW50 1050t/a；非实际处理量',as_of='2026-11-28' WHERE site_id='CN0354';
UPDATE sites SET address='郑州航空港区洧川镇（2023官方清单）',status='2023官方清单列已投产；2026转移批准；现行产线待核',as_of='2026-11-28' WHERE site_id='CN0356';
INSERT INTO evidence_notes(note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES
('N087-01','CN0354','S087-01','许可规模及边界','第三部分表1检索可见原文','Y5301130180，2024-05-27至2029-05-26；综合3000t/a共18类53代码，HW50 1050、HW46 76、HW48 1060、HW17 160t/a等。表2可见热处理炉飞灰回收滤液浓缩结晶的描述，属于飞灰支路，不归入催化剂专线；附件完整读取及截图受限，待原件核验。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N087-02','CN0354','S087-02','地址','企业资料页','第三方资料列昆明东川区碧谷四方地工业园区南片区；未核独立生产设施门牌。','WEB_SECONDARY','WEB_TEXT','2026-11-28'),
('N087-03','CN0356','S087-03','历史在产身份','序号5','官方清单2023列洧川镇，金属废料和碎屑加工处理，涉重金属管理类别铜冶炼，已投产；与同名单郑州豫达为不同主体；不是2026当前负荷。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N087-04','CN0356','S087-04','单客户产废去向','固体废物清单','2025-01-03披露废催化剂261-152-50年产生量4.3t，最终去向永和；为产废方年度清单，不是永和实际接收联单。','WEB_COMPANY','WEB_TEXT','2026-11-28');
INSERT INTO search_log(log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES
('L087-01','CN0354','087附件定向检索','精确附件URL及许可表','S087-01','可读索引正文补HW50 1050及有效期；完整附件仍受限','完整原件及现行污水工艺','2026-11-28'),
('L087-02','CN0354','087厂址核查','企业地址','S087-02','第三方企业地址','官方设施门牌核实','2026-11-28'),
('L087-03','CN0356','087在产身份','郑州航空港区涉重金属清单','S087-03','历史已投产及所在地','现行许可及工程报告','2026-11-28'),
('L087-04','CN0356','087客户去向','心连心固废清单','S087-04','单客户年产废量及最终去向','实际接收联单','2026-11-28');
INSERT INTO research_revisit_attempts(attempt_id,site_id,scope_key,gap,route_key,search_log_id,source_id,checked_on,outcome,gained_fields,evidence_refs,effort_minutes,next_check_on,reopen_trigger,rationale) VALUES
('A087-01','CN0354','site_current','许可分项','indexed_attachment','L087-01','S087-01','2026-11-28','context_gain','HW50许可1050及期限','C087-01–02/N087-01',NULL,NULL,'可读原件/新许可证','索引表1独立许可范围，不重复尝试全文'),
('A087-02','CN0354','site_current','厂址','third_party_address','L087-02','S087-02','2026-11-28','context_gain','企业地址','N087-02',NULL,NULL,'官方设施地址','第三方非许可原件'),
('A087-03','CN0356','site_current','历史在产身份','official_roster','L087-03','S087-03','2026-11-28','context_gain','历史在产及镇址','N087-03',NULL,NULL,'现行许可/验收','2023清单非当前'),
('A087-04','CN0356','site_current','客户废物去向','customer_environment_report','L087-04','S087-04','2026-11-28','context_gain','单客户年度产废去向','N087-04',NULL,NULL,'实际联单','非实际接收量');
INSERT INTO research_document_review(site_id,source_id,scope_key,gap,reviewed_on,state,locator,remaining_work,next_check_on,attempt_id) VALUES ('CN0354','S087-01','site_current','许可分项','2026-11-28','partial','第三部分表1检索正文','完整原件、废催化剂专线及污水章节，非飞灰流程','2026-12-28','A087-01');
COMMIT;
