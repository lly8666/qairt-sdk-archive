PRAGMA foreign_keys=ON;
BEGIN;
INSERT INTO sources(source_id,title,url,source_type,document_date,scope,access_date) VALUES
('S080-01','鄂尔多斯市2026-03-30环评报告书受理公示','https://sthjj.ordos.gov.cn/ywgz_6642/hpyxpj_6651/jsxmbgbgs_161699/xmsl/202603/t20260330_1782192.html','WEB_PRIMARY','2026-03-30','官方表第2项；附件33.4MB读取受限','2026-11-28'),
('S080-02','中科合成首次公开发行股票并上市补充法律意见书（二）','https://qxb-pdf-osscache.qixin.com/AnBaseinfo/28079775c660aeda204b85478e98100a.pdf','WEB_SECONDARY','2023','8-3-77及79–80，p77截图核；律师核查批复','2026-11-28'),
('S080-03','陕西环保新能源有限公司官网','https://www.sxhbxny.com/','WEB_PRIMARY',NULL,'企业自述既有再生线、厂址；索引摘要，复开超时','2026-11-28'),
('S080-04','陕西环保新能源环评拟报批稿公示栏目','https://sxhbxny.com/col.jsp?id=104','WEB_PRIMARY','2026-08-14','企业公示索引，正文附件未读','2026-11-28'),
('S080-05','张掖启杭高端聚烯烃助催化剂中试首次环评公示','https://www.zhangye.gov.cn/jjkfq/gzdt/tzgg/202610/t20261022_1598174.html','WEB_PRIMARY','2026-10-22','政府公示正文','2026-11-28');
INSERT INTO sites(site_id,name,province,city,address,category,status,record_type,capacity_summary,water_summary,water_level,priority,source_status,as_of,notes) VALUES
('CN0341','中科合成油内蒙古有限公司','内蒙古','鄂尔多斯','准格尔旗大路工业园区','煤制油催化剂','2023二期批复；2026辅助工程受理','制造候选','48000t/a项目名，二期增量及现行能力待核','附件已定位未读','未取得','P1','部分复核','2026-11-28','不将批复当投产'),
('CN0342','陕西环保新能源有限公司','陕西','榆林','神木市锦界工业园区','SCR再生及拟建新剂','企业称已建再生线；2026-08拟报批','制造及再生候选','自述20000t/a再生；拟5000m³/a新剂','两类水线均待核','未取得','P1','企业公示索引','2026-11-28','官网及栏目摘要可见，原页超时'),
('CN0343','张掖启杭新材料科技有限公司','甘肃','张掖','张掖经开区循环经济示范园化工产业集中区','聚烯烃助催化剂中试','2026-10首次环评公示','制造候选','100kg/批次，不年化','拟事故及初雨池非处理能力','未取得','P2','部分复核','2026-11-28','非审批或投产');
INSERT INTO site_sources(site_id,source_id) VALUES
('CN0341','S080-01'),
('CN0341','S080-02'),
('CN0342','S080-03'),
('CN0342','S080-04'),
('CN0343','S080-05');
INSERT INTO capacity(capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES
('C080-01','CN0341','煤制油催化剂',48000,'t/a','批复所引项目名','2023-04-24','二期工程','S080-02','非二期净增量或现行实际'),
('C080-02','CN0342','废SCR再生利用',20000,'t/a','企业自述既有线规模','官网索引2026-11','既有','S080-03','非现行许可及实际量'),
('C080-03','CN0342','SCR脱硝催化剂',5000,'m³/a','拟报批设计','2026-08-14','新剂','S080-04','非批准产能'),
('C080-04','CN0343','聚烯烃助催化剂',100,'kg/批次','首次环评公示','2026-10-22','中试','S080-05','不年化');
INSERT INTO projects(project_id,site_id,project,status,date,capacity_note,water_change,source_id) VALUES
('P080-01','CN0341','48000吨/年煤制油催化剂二期','历史批复经律师核查','2023-04-24','项目名规模，净增未知','批复原文待取','S080-02'),
('P080-02','CN0341','煤制油催化剂辅助工程','官方受理','2026-03-30','现有厂区内','33.4MB附件受限','S080-01'),
('P080-03','CN0342','年产5000m³SCR脱硝催化剂','企业拟报批索引','2026-08-14','拟建新剂','正文未取','S080-04'),
('P080-04','CN0343','高端聚烯烃助催化剂中试','首次公示','2026-10-22','100kg/批次','事故及初雨池非处理能力','S080-05');
INSERT INTO evidence_notes(note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES
('N080-01','CN0341','S080-01','厂址与新事件','表第2项','现有大路园区厂区；2026-03-30辅助工程受理。附件P020260724372082127259.pdf超读取限制，水段未核。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N080-02','CN0341','S080-02','历史批复','8-3-77；截图核','2023-04-24鄂环审字〔2023〕95号，48000t/a项目二期；非二期净增或实际量。','WEB_SECONDARY','WEB_TEXT','2026-11-28'),
('N080-03','CN0342','S080-03','既有线','官网索引摘要','2015成立，三秦环保下属；神木锦界园区，企业称既有20000t/a再生线。原页超时，集团污水统计不能归此厂。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N080-04','CN0342','S080-04','新剂项目','2026-08-14栏目索引','5000m³/a拟报批；复开超时，审批及水段未知。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N080-05','CN0343','S080-05','中试边界','项目概况','100kg/批次高端聚烯烃助催化剂拟建，事故及初雨池；无生产污水工艺或水量。','WEB_PRIMARY','WEB_TEXT','2026-11-28');
INSERT INTO tasks(task_id,site_id,priority,missing,next_query,state) VALUES
('T0341','CN0341','P1','二期与辅助工程规模、废水分股/流程、许可验收','原环评或审批正文、许可验收','部分完成'),
('T0342','CN0342','P1','现行许可、再生和新剂水线、实际量','政府环评及验收','部分完成'),
('T0343','CN0343','P2','中试环评正文、成分、处理及审批','受理、批准或验收','待核');
INSERT INTO search_log(log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES
('L080-01','CN0341','080追加 legal_opinion','phase2_2023 生产规模','S080-02','截图核','原批复及验收','2026-11-28'),
('L080-02','CN0341','080追加 official_notice','auxiliary_2026 厂址及受理','S080-01','受理表','正式批复','2026-11-28'),
('L080-03','CN0341','080追加 official_attachment','auxiliary_2026 污水正文','S080-01','33.4MB受限','可读附件','2026-11-28'),
('L080-04','CN0342','080追加 company_index','existing_regeneration 既有线','S080-03','非实际','许可证验收','2026-11-28'),
('L080-05','CN0342','080追加 company_notice_index','new_scr_2026 拟建项目','S080-04','非现行','正式批复','2026-11-28'),
('L080-06','CN0342','080追加 company_attachment','new_scr_2026 水段','S080-04','超时','可读报告或政府附件','2026-11-28'),
('L080-07','CN0343','080追加 official_first_notice','pilot_2026 中试边界','S080-05','无水量','受理审批','2026-11-28'),
('L080-08','CN0265','080追加 recent_acceptance_search','site_current 阶段验收','S031-05','旧转载','新原始验收','2026-11-28');
INSERT INTO research_revisit_attempts(attempt_id,site_id,scope_key,gap,route_key,search_log_id,source_id,checked_on,outcome,gained_fields,evidence_refs,effort_minutes,next_check_on,reopen_trigger,rationale) VALUES
('A080-01','CN0341','phase2_2023','生产规模','legal_opinion','L080-01','S080-02','2026-11-28','context_gain','历史批复及项目名规模','C080-01/P080-01/N080-02',NULL,NULL,'原批复及验收','截图核'),
('A080-02','CN0341','auxiliary_2026','厂址及受理','official_notice','L080-02','S080-01','2026-11-28','context_gain','厂址及辅助工程受理','P080-02/N080-01',NULL,NULL,'正式批复','受理表'),
('A080-03','CN0341','auxiliary_2026','污水正文','official_attachment','L080-03','S080-01','2026-11-28','access_blocked','无','N080-01',NULL,'2026-12-28','可读附件','33.4MB受限'),
('A080-04','CN0342','existing_regeneration','既有线','company_index','L080-04','S080-03','2026-11-28','context_gain','自述规模及地址','C080-02/N080-03',NULL,NULL,'许可证验收','非实际'),
('A080-05','CN0342','new_scr_2026','拟建项目','company_notice_index','L080-05','S080-04','2026-11-28','context_gain','拟5000m³/a','C080-03/P080-03/N080-04',NULL,NULL,'正式批复','非现行'),
('A080-06','CN0342','new_scr_2026','水段','company_attachment','L080-06','S080-04','2026-11-28','access_blocked','无','N080-04',NULL,'2026-12-28','可读报告或政府附件','超时'),
('A080-07','CN0343','pilot_2026','中试边界','official_first_notice','L080-07','S080-05','2026-11-28','context_gain','100kg/批次及厂址','C080-04/P080-04/N080-05',NULL,NULL,'受理审批','无水量'),
('A080-08','CN0265','site_current','阶段验收','recent_acceptance_search','L080-08','S031-05','2026-11-28','duplicate','无','P031-02/N031-05/06',NULL,NULL,'新原始验收','旧转载');
COMMIT;
