PRAGMA foreign_keys=ON;
BEGIN;
INSERT INTO sources(source_id,title,url,source_type,document_date,scope,access_date) VALUES
('S091-01','烟台市生态环境局2026年10月26日环评审批决定','https://www.yantai.gov.cn/col/col43294/art/2026/art_2f030704966b447881a42baa09970d2e.html','政府审批决定目录','2026-10-26','第2项液态锗催化剂200吨项目，批复正文下载超时','2026-11-28'),
('S091-02','中触媒高性能催化新材料项目（一阶段）环保设施竣工及调试公示','https://cn.china-catalyst.com/%E4%B8%AD%E8%A7%A6%E5%AA%92%E6%96%B0%E6%9D%90%E6%96%99%E8%82%A1%E4%BB%BD%E6%9C%89%E9%99%90%E5%85%AC%E5%8F%B8%E9%AB%98%E6%80%A7%E8%83%BD%E5%82%AC%E5%8C%96%E6%96%B0%E6%9D%90%E6%96%99%E9%A1%B9%E7%9B%AE/','企业环保公示',NULL,'2026年9月竣工、9月至11月调试，非验收意见','2026-11-28'),
('S091-03','铜陵2024年固体废物污染防治信息公告','https://sthjj.tl.gov.cn/tlssthjj/c00039/pc/content/content_1930551641721593856.html','政府年度公告检索摘录','2025','铜陵欣诺科表项，正文重开超时，索引提供0.003但未核表头','2026-11-28');
INSERT INTO sites(site_id,name,province,city,address,category,status,record_type,capacity_summary,water_summary,water_level,priority,permit_id,source_status,as_of,notes) VALUES
('CN0362','爱思开环保材料（烟台）有限公司','山东','烟台',NULL,'液态锗催化剂','2026-10环评审批决定；未核投运','项目','200t/a液态锗催化剂项目',NULL,'缺失','P2',NULL,'政府审批目录','2026-11-28','企业既有其他产品不计作催化剂产能；批复附件超时，具体厂址和废水待核');
INSERT INTO site_sources(site_id,source_id) VALUES
('CN0362','S091-01'),
('CN0026','S091-02'),
('CN0035','S091-03');
INSERT INTO capacity(capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES
('C091-01','CN0362','液态锗催化剂',200,'t/a','环评审批目录项目名义规模','2026-10-26','新项目','S091-01','非实际产量；成品锗含量未核'),
('C091-02','CN0026','甲醛催化剂',300,'t/a','一阶段拟验收范围名义规模','2026-09至11','高性能催化新材料一阶段','S091-02','非验收通过或实际产量；现有B3车间'),
('C091-03','CN0026','ZSM-12分子筛',240,'t/a','一阶段拟验收范围名义规模','2026-09至11','高性能催化新材料一阶段','S091-02','非验收通过或实际产量；晶化依托B1'),
('C091-04','CN0035','HW50(261-152-50)实际经营量',0.001,'万吨/年','政府年度公告实际收集利用处置贮存统计','2025','危废持证单位第5行','S027-16','即10吨/年；不等于新剂实际产量或单纯完成再生量；旧N027-17单位缺口闭合');
INSERT INTO projects(project_id,site_id,project,status,date,capacity_note,water_change,source_id) VALUES
('P091-01','CN0362','200吨/年液态锗催化剂项目','烟环审〔2026〕81号审批决定；附件正文待核','2026-10-26','200t/a项目名称','未知','S091-01'),
('P091-02','CN0026','高性能催化新材料项目一阶段','公司公示环保设施2026-09竣工，9–11月调试；拟验收，非验收通过','2026-09','300t/a甲醛催化剂、240t/a ZSM-12','2025报告在建工程依托二期站；本阶段实际分股待核','S091-02');
INSERT INTO wastewater(water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES
('W091-01','CN0026','2025高性能催化新材料在建工程各类废水','2025报告在建工程设计',NULL,NULL,NULL,NULL,'依托厂内二期污水站处理','DW001',NULL,'S059-01','WEB_COMPANY','§2.3.2.2；全项目还含非催化剂产品，不是2026一阶段实际排水；旧W059-04共享站能力不重复');
INSERT INTO process_diagrams(diagram_id,site_id,scope_key,stage,period,revision,coverage,mermaid,source_id,boundaries,gaps,updated_on) VALUES
('D091-01','CN0026','high_performance_2025_shared','design','2025环评回顾在建',1,'partial','flowchart TD
 A["在建工程各类废水"] --> B["厂内二期共享污水站"]
 B --> C["DW001"]
 D["车间高热值液体废物"] --> E["管廊泵送 焚烧计量罐"]
 E --> F["厂内焚烧"]
 G["待焚烧液废暂存罐30m³"] -. "储存边界" .-> E','S059-01','§2.3.2.2–3，在建全项目含其他产品；虚线仅示储存边界；高热值液废非水量；不与2026一阶段调试当作同一实际阶段','两条催化剂线分股水量、水质、实际共享站及焚烧边界','2026-11-28');
INSERT INTO process_diagram_evidence(evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES
('DE091-01','D091-01','W091-01','S059-01','§2.3.2.2','A,B,C','在建工程各类废水依托二期站及DW001'),
('DE091-02','D091-01',NULL,'S059-01','§2.3.2.3','D,E,F,G','高热值液废管输计量焚烧，30m³暂存、3个3m³计量罐；非污水处理能力');
INSERT INTO membrane_reviews(review_id,site_id,diagram_id,scope_key,stage,period,revision,presence,source_id,evidence_basis,gaps,updated_on) VALUES
('R091-01','CN0026','D091-01','high_performance_2025_shared','design','2025环评回顾在建',1,'confirmed_present','S059-01','设计依托二期共享站；同报告既有二期MBR已见D059-3/MR059-3；不是新增专线膜设备或2026实际运行','一阶段实际接管和共享站是否切换、分股水质和量','2026-11-28');
INSERT INTO membrane_units(unit_id,review_id,unit_label,technology,role,feed,permeate_destination,concentrate_destination,specification,source_id,locator,notes) VALUES
('MU091-01','R091-01','二期共享站MBR（依托）','MBR','生化后固液分离','二期共享站生化水','后续NaClO、电吸附及DW001（旧D059-3）',NULL,NULL,'S059-01','§2.3.2.2及图2-13','复用既有设备证据，非新增装机；新项目设计依托，实际切换待核');
INSERT INTO membrane_retrofits(assessment_id,review_id,site_id,scope_key,option_key,revision,objective,proposed_route,feasibility,hard_constraints,evidence_basis,assumptions,missing_inputs,validation_plan,alternatives,feed_risk,pretreatment_risk,concentrate_risk,integration_risk,operational_risk,compliance_economics_risk,score_basis,updated_on) VALUES
('A091-R1','R091-01','CN0026','high_performance_2025_shared','shared_mbr_optimization',1,'新增负荷下稳定运行与回用筛查','核实新线分质进水与二期MBR余量；仅在低盐澄清出水及浓液去向闭合时筛选NF/RO，比较共享站优化及三期切换','conditional','现行接管和三期切换、浓液合法去向、实际水质和负荷','S059-01 §2.3.2.2、D059-3及D091-01','INFERRED；非新增膜或运行成本事实','分股流量、盐分、金属、COD、氨氮、MBR TMP/通量及能药耗','采样、现有膜运行数据复核、负荷和回用需求核算、必要时膜小试','优化分质与现有MBR或后续非膜站',NULL,NULL,NULL,NULL,NULL,NULL,'无六维实际参数，不评分','2026-11-28');
INSERT INTO evidence_notes(note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES
('N091-01','CN0362','S091-01','新增厂商项目线索','审批决定表第2项','2026-10-26烟环审〔2026〕81号，爱思开环保材料（烟台）有限公司200吨/年液态锗催化剂项目；正式审批目录可读，附件点击超时。尚不知详细厂址、实际产量、废水流量和膜技术。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N091-02','CN0026','S091-02','一阶段调试公示','企业公示正文','环保设施2026年9月竣工，9月至11月调试，拟开展300t/a甲醛催化剂及240t/a ZSM-12分子筛一阶段验收；未取得验收意见或实际运行水量。','WEB_COMPANY','WEB_TEXT','2026-11-28'),
('N091-03','CN0026','S059-01','在建项目污水与液废边界','§2.3.2.2–3及附件19','2025-04-22批复，松木岛现有厂区B3新增两线，ZSM-12晶化依托B1；全在建项目各类废水设计依托二期站DW001。高热值液废经管廊泵送焚烧计量罐，设30m³暂存罐和3个3m³计量罐，非处理量；全项目含非催化剂产品，不把设施按一阶段单线分摊。PDF截图超时、正文可读。','WEB_COMPANY','WEB_TEXT','2026-11-28'),
('N091-04','CN0035','S027-16','2025经营量单位纠正','年度公告危废经营单位表第5行及表头','旧N027-17未得单位；本轮表头为万吨/年，HW50(261-152-50)实际收集利用处置贮存量0.001万吨/年（10t/a），不是实际再生产量或许可。旧0.3万吨/年混合许可已录不重复。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N091-05','CN0035','S091-03','2024经营量待核','政府年度公告检索摘录','索引列HW50实际量0.003，正文重开超时，未见该年表头，不按2025单位直接换算；待核原表。','WEB_PRIMARY','WEB_TEXT','2026-11-28');
INSERT INTO tasks(task_id,site_id,priority,missing,next_query,state) VALUES
('T091-01','CN0362','P2','详细厂址、产品工艺、分股废水、膜、验收和成本','烟环审〔2026〕81号原报告及排污许可/验收','待调查');
INSERT INTO search_log(log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES
('L091-01','CN0362','091 search:recent_approval','liquid_ge_200 审批与身份','S091-01','审批目录；附件点击超时','原报告及验收','2026-11-28'),
('L091-02','CN0026','091 event:company_notice','high_performance_phase1 一阶段调试','S091-02','企业官网正文','实际验收意见','2026-11-28'),
('L091-03','CN0026','091 document:2.3.2','high_performance_2025_shared 在建项目水处理及液废边界','S059-01','正文§2.3.2；截图超时','一阶段分股及实际接管','2026-11-28'),
('L091-04','CN0035','091 document:2025_table_header','hw50_2025 经营量单位','S027-16','官方正文表头及第5行','新验收或分股','2026-11-28'),
('L091-05','CN0035','091 document:2024_table_header','hw50_2024 经营量表头','S091-03','索引可读、原文超时','可读原表及单位','2026-11-28'),
('L091-06','CN0272','091 search:recent_approval_discovery','site_current 近期审批与设备包','S033-07','发现旧拟审批与采购，已录','新正式批复','2026-11-28'),
('L091-07','CN0138','091 search:recent_approval_discovery','site_current 近期分子筛项目','S041-13','旧拟批与分股已录','独立新报告','2026-11-28'),
('L091-08','CN0083','091 search:recent_acceptance_discovery','site_current 二期验收','W03S16','旧验收转载已录','原始报告新章节','2026-11-28'),
('L091-09','CN0230','091 search:recent_procurement_discovery','site_current 废水工程中标','S030-10','既有575.18万元中标','新施工/验收','2026-11-28'),
('L091-10','CN0093','091 search:recent_procurement_discovery','site_current B塔设备采购','S030-12','旧采购索引已录','独立技术协议','2026-11-28'),
('L091-11','CN0087','091 search:recent_approval_discovery','site_current 近期正式批复','turn106948search5','旧批复已录','新验收','2026-11-28'),
('L091-12','CN0183','091 search:recent_approval_discovery','site_current 近期正式批复','turn106948search0','旧批复已录','新验收','2026-11-28'),
('L091-13','CN0193','091 search:recent_approval_discovery','site_current 扩建批复','W03S09','旧批复已录','新验收','2026-11-28');
INSERT INTO research_revisit_attempts(attempt_id,site_id,scope_key,gap,route_key,search_log_id,source_id,checked_on,outcome,gained_fields,evidence_refs,effort_minutes,next_check_on,reopen_trigger,rationale) VALUES
('A091-01','CN0362','liquid_ge_200','审批与身份','search:recent_approval','L091-01','S091-01','2026-11-28','context_gain','新主体及项目规模','CN0362/C091-01/P091-01',NULL,NULL,'原报告及验收','首次发现；附件另待核'),
('A091-02','CN0026','high_performance_phase1','一阶段调试','event:company_notice','L091-02','S091-02','2026-11-28','context_gain','新增项目和调试节点','P091-02/C091-02–03',NULL,NULL,'实际验收意见','非已验收'),
('A091-03','CN0026','high_performance_2025_shared','在建项目水处理及液废边界','document:2.3.2','L091-03','S059-01','2026-11-28','engineering_gain','共享站依托及高热值液废处置','W091-01/D091-01/R091-01',NULL,NULL,'一阶段分股及实际接管','未重录二期站能力'),
('A091-04','CN0035','hw50_2025','经营量单位','document:2025_table_header','L091-04','S027-16','2026-11-28','context_gain','核实历史经营量10t/a','C091-04/N091-04',NULL,NULL,'新验收或分股','原单位缺口闭合'),
('A091-05','CN0035','hw50_2024','经营量表头','document:2024_table_header','L091-05','S091-03','2026-11-28','access_blocked','仅未定量线索','N091-05',NULL,'2026-12-28','可读原表及单位','不假设与2025同单位'),
('A091-06','CN0272','site_current','近期审批与设备包','search:recent_approval_discovery','L091-06','S033-07','2026-11-28','duplicate','无','S033-07',NULL,'2026-12-28','新正式批复','旧两站与膜已录，不重开原轨道'),
('A091-07','CN0138','site_current','近期分子筛项目','search:recent_approval_discovery','L091-07','S041-13','2026-11-28','duplicate','无','S041-13',NULL,'2026-12-28','独立新报告','同源设计重复'),
('A091-08','CN0083','site_current','二期验收','search:recent_acceptance_discovery','L091-08','W03S16','2026-11-28','duplicate','无','W03S16',NULL,'2026-12-28','原始报告新章节','非新增实测'),
('A091-09','CN0230','site_current','废水工程中标','search:recent_procurement_discovery','L091-09','S030-10','2026-11-28','duplicate','无','S030-10',NULL,'2026-12-28','新施工/验收','不重新入库合同金额'),
('A091-10','CN0093','site_current','B塔设备采购','search:recent_procurement_discovery','L091-10','S030-12','2026-11-28','duplicate','无','S030-12',NULL,'2026-12-28','独立技术协议','不推断实际UASB'),
('A091-11','CN0087','site_current','近期正式批复','search:recent_approval_discovery','L091-11','turn106948search5','2026-11-28','duplicate','无','turn106948search5',NULL,'2026-12-28','新验收','不重录设计'),
('A091-12','CN0183','site_current','近期正式批复','search:recent_approval_discovery','L091-12','turn106948search0','2026-11-28','duplicate','无','turn106948search0',NULL,'2026-12-28','新验收','不重录设计'),
('A091-13','CN0193','site_current','扩建批复','search:recent_approval_discovery','L091-13','W03S09','2026-11-28','duplicate','无','W03S09',NULL,'2026-12-28','新验收','不重录设计');
INSERT INTO research_document_review(site_id,source_id,scope_key,gap,reviewed_on,state,locator,remaining_work,next_check_on,attempt_id) VALUES
('CN0026','S059-01','high_performance_2025_shared','在建项目水处理及液废边界','2026-11-28','section_done','§2.3.2.2–3','一阶段实际验收、分股水质和负荷',NULL,'A091-03'),
('CN0035','S027-16','hw50_2025','经营量单位','2026-11-28','section_done','表头及第5行','新年度实际统计',NULL,'A091-04'),
('CN0035','S091-03','hw50_2024','经营量表头','2026-11-28','blocked','索引可读、原文超时','原表单位','2026-12-28','A091-05');
COMMIT;
