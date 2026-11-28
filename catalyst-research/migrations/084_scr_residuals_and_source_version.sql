PRAGMA foreign_keys=ON;
BEGIN;
INSERT INTO sources(source_id,title,url,source_type,document_date,scope,access_date) VALUES
('S084-01','新疆绿园华泰催化剂综合利用改扩建项目环境影响报告书（2022公开版）','https://sthjt.xinjiang.gov.cn/xjepd/hjyxpjsl/202212/ae54050f64b340c9a9a82c40bf60c657/files/新疆绿园华泰环保科技有限公司催化剂综合利用改扩建项目环境影响报告书-20221228192830585.pdf','WEB_PRIMARY','2022-12','3.2.8.2及依托表；083取证原版本，2023版本另存','2026-11-28');
INSERT INTO site_sources(site_id,source_id) VALUES
('CN0069','S084-01');
UPDATE wastewater SET source_id='S084-01' WHERE water_id IN ('W083-08','W083-09','W083-10');
UPDATE evidence_notes SET source_id='S084-01' WHERE note_id='N083-03';
INSERT INTO wastewater(water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES
('W084-01','CN0250','SCR再生清洗废水','2021环评设计',3200,'t/a','表3.5-6产生量',NULL,'预处理、管式膜、ED、RO、蒸发结晶','设计回用',NULL,'S020-002','WEB_PRIMARY','子股非处理能力；未证实际投运'),
('W084-02','CN0250','SCR再生冲洗废水','2021环评设计',5826,'t/a','表3.5-6产生量',NULL,'同W020-004','设计回用',NULL,'S020-002','WEB_PRIMARY','非实际量'),
('W084-03','CN0250','SCR再生漂洗废水','2021环评设计',2310,'t/a','表3.5-6产生量',NULL,'同W020-004','设计回用',NULL,'S020-002','WEB_PRIMARY','非实际量');
INSERT INTO water_metrics(metric_id,site_id,water_id,point,metric,value_num,value_text,unit,result_kind,statistic,period,detection_limit,standard_max,source_id,notes) VALUES
('M084-001','CN0250','W020-004','SCR再生水处理','预处理污泥',96.29,NULL,'t/a','环评预测','年产生量','2021设计',NULL,NULL,'S020-002','表3.5-5；HW49 772-006-49，拟委外'),
('M084-002','CN0250','W020-004','SCR再生水处理','蒸发结晶废盐',8.55,NULL,'t/a','环评预测','年产生量','2021设计',NULL,NULL,'S020-002','表3.5-5；报告列HW11 900-013-11，拟委外；实际属性待核'),
('M084-003','CN0250','W020-004','SCR再生水处理','废ED膜及RO膜合计',0.2,NULL,'t/a','环评类比预测','年产生量','2021设计',NULL,NULL,'S020-002','表3.5-5；报告列HW49 900-041-49，非单种膜寿命或实耗');
UPDATE wastewater SET residuals='2021环评预测：预处理污泥96.29t/a、蒸发结晶废盐8.55t/a、废ED与RO膜合计0.2t/a，均拟委有资质单位；实际投运及属性待核' WHERE water_id='W020-004';
INSERT INTO evidence_notes(note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES
('N084-01','CN0250','S020-002','SCR分股及残余物','表3.5-5、3.5-6，pp98–100','三股年产生量3200、5826、2310t/a，合计11336t/a（算术），不与50m³/d设计能力直接换算；设计回用非实际零排放。污泥96.29、废盐8.55、废ED+RO膜0.2t/a均预测，拟委有资质单位。2026 HW48许可不含HW50，仍未核实SCR投运。截图404，正文可读。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N084-02','CN0043','S046-03','硝酸钯扩建水边界','表4.8-2 p73','2019报告拟建360吨硝酸钯项目新增废水排放量列0，建成后全厂接管及最终外排水量列10228.2t/a，非实测、非无生产废水；不重复原项目W046-37的m³/a。废滤芯及杂质0.9t/a属生产工序，不能作废水膜耗；截图超时。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N084-03','CN0069','S084-01','版本边界','3.2.8.2、依托表','083水量对应2022公开版；2023 S046-02保留，未证明两版全部一致；083原检索历史不删除。','WEB_PRIMARY','WEB_TEXT','2026-11-28');
INSERT INTO search_log(log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES
('L084-01','CN0250','084追加定向 document:S020-002','scr_design 分股产生量及污泥废膜','S020-002','旧报告新增段落，截图404','正式SCR验收、实际运行和费用','2026-11-28'),
('L084-02','CN0043','084追加定向 document:S046-03','pd_nitrate_design 硝酸钯项目新增排放边界','S046-03','设计排放0不等于无生产水','正式验收','2026-11-28'),
('L084-03','CN0069','084追加定向 document:S084-01','expansion_design 报告版本来源校正','S084-01','不计新增水量','新批复及验收','2026-11-28'),
('L084-04','CN0099','084追加定向 document:S045-01','site_current 既有原报告生产分流','S045-01','原分流和设施已入库','新验收报告','2026-11-28'),
('L084-05','CN0003','084追加定向 document:W03S41','site_current HTS既有工程','W03S41','2023原文已录；截图超时','新验收或运行实测','2026-11-28');
INSERT INTO research_revisit_attempts(attempt_id,site_id,scope_key,gap,route_key,search_log_id,source_id,checked_on,outcome,gained_fields,evidence_refs,effort_minutes,next_check_on,reopen_trigger,rationale) VALUES
('A084-01','CN0250','scr_design','分股产生量及污泥废膜','document:S020-002','L084-01','S020-002','2026-11-28','engineering_gain','三股年产生量、三类残余物','W084-01–03/M084-001–003/N084-01',NULL,NULL,'正式SCR验收、实际运行和费用','旧报告新增段落，截图404'),
('A084-02','CN0043','pd_nitrate_design','硝酸钯项目新增排放边界','document:S046-03','L084-02','S046-03','2026-11-28','context_gain','新增项目排放边界','N084-02',NULL,NULL,'正式验收','设计排放0不等于无生产水'),
('A084-03','CN0069','expansion_design','报告版本来源校正','document:S084-01','L084-03','S084-01','2026-11-28','context_gain','独立登记2022版、校正三条水量来源','W083-08–10/N084-03',NULL,NULL,'新批复及验收','不计新增水量'),
('A084-04','CN0099','site_current','既有原报告生产分流','document:S045-01','L084-04','S045-01','2026-11-28','duplicate','无','W045-01–13',NULL,NULL,'新验收报告','原分流和设施已入库'),
('A084-05','CN0003','site_current','HTS既有工程','document:W03S41','L084-05','W03S41','2026-11-28','duplicate','无','W013-021–024/W029-04–06',NULL,NULL,'新验收或运行实测','2023原文已录；截图超时');
INSERT INTO research_document_review(site_id,source_id,scope_key,gap,reviewed_on,state,locator,remaining_work,next_check_on,attempt_id) VALUES
('CN0250','S020-002','scr_design','分股产生量及污泥废膜','2026-11-28','section_done','表3.5-5、3.5-6','正式SCR验收、实际运行和费用',NULL,'A084-01'),
('CN0043','S046-03','pd_nitrate_design','硝酸钯项目新增排放边界','2026-11-28','section_done','表4.8-2','正式验收',NULL,'A084-02'),
('CN0069','S084-01','expansion_design','报告版本来源校正','2026-11-28','section_done','3.2.8.2、依托表','新批复及验收',NULL,'A084-03');
COMMIT;
