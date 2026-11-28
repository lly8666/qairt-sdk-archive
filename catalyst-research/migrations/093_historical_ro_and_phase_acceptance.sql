PRAGMA foreign_keys=ON;
BEGIN;
INSERT INTO sources(source_id,title,url,source_type,document_date,scope,access_date) VALUES
('S093-01','山西华阳新材料股份有限公司2021年年度报告（修订版）','https://static.cninfo.com.cn/finalpage/2022-06-07/1213621840.PDF','上市公司定期报告','2022-06-07','华盛丰2019–2021年污水设施及设备，p40原页截图核','2026-11-28'),
('S093-02','山西华阳新材料股份有限公司2024年年度报告','https://static.cninfo.com.cn/finalpage/2025-04-26/1223319374.PDF','上市公司定期报告','2025-04-26','华盛丰验收、许可证、设施运行陈述，p43截图','2026-11-28'),
('S093-03','华阳新材2026年半年度报告','https://vip.stock.finance.sina.com.cn/corp/view/vCB_AllBulletinDetail.php?id=12558822&stockid=600281','上市公司定期报告转载','2026','华盛丰2026H1运营与技改；未披露膜型号及现行工艺','2026-11-28'),
('S093-04','万华化学集团股份有限公司固废站改造提升项目环评公示稿','https://www.yeda.gov.cn/cms_files/filemanager/48749/attach/202611/b7e5423df79a4973bf8ca58750fb87ae.pdf?fileName=%E5%85%AC%E7%A4%BA%E7%A8%BF-%E4%B8%87%E5%8D%8E%E5%8C%96%E5%AD%A6%E9%9B%86%E5%9B%A2%E8%82%A1%E4%BB%BD%E6%9C%89%E9%99%90%E5%85%AC%E5%8F%B8%E5%9B%BA%E5%BA%9F%E7%AB%99%E6%94%B9%E9%80%A0%E6%8F%90%E5%8D%87%E9%A1%B9%E7%9B%AE%281%29.pdf','政府公开环评报告','2026-11','既有项目审批/验收清单第76、78、109项，p32截图核第78项','2026-11-28'),
('S093-05','太原华盛丰贵金属材料有限公司销售生产废渣招标二次变更公告','https://www.sxxindian.com/xmxx/001001/001001004/001001004002/20221021/a6cdebc9-3e0b-4506-a284-eba5a5f3faf6.html','公开采购公告检索摘录','2022-10-21','生产废渣分类及承包方资质要求，正文重开超时','2026-11-28');
INSERT INTO site_sources(site_id,source_id) VALUES
('CN0365','S093-01'),
('CN0365','S093-02'),
('CN0365','S093-03'),
('CN0137','S093-04'),
('CN0365','S093-05');
INSERT INTO capacity(capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES
('C093-01','CN0365','铂钯铑系列催化剂加工',5000,'kg/a','2017环评项目规模（2021年报回顾）','2017','2017批准项目','S093-01','非实际生产量，与C092-05净贵金属2500kg/a口径和年份不同，不相加；废催化剂1000t/a旧录不重复');
INSERT INTO projects(project_id,site_id,project,status,date,capacity_note,water_change,source_id) VALUES
('P093-01','CN0365','1000t/a煤化工废催化剂处置及5000kg/a铂钯铑系列催化剂加工','2017批准；公司2024年报称2021完成环保验收','2021','1000t/a处置及5000kg/a加工；不与2025产能相加','2019建成运行污水装置，2020蒸发、2021浓缩等另见S093-01；2026具体路线待核','S093-02'),
('P093-02','CN0137','催化剂一期技改（一期）','2026公示环评回顾2024-10-17自主验收','2024-10-17','WHX生产能力未披露','依托WHH喷雾干燥、焙烧、筛分、包装；新增配料罐及反应釜；污水系统待取验收','S093-04'),
('P093-03','CN0137','催化剂制备三期工程','2026公示环评回顾2024-10-30自主验收','2024-10-30','WHC、WHR单元；无定量产能','蒸发浓缩单元属于项目建设内容，废水/工艺物料用途未明确','S093-04'),
('P093-04','CN0137','催化剂一期技改（二期）','2026公示环评回顾2025-11-28自主验收','2025-11-28','WHX项目二期，不与一期重复累计','同批复烟环审〔2022〕39号，阶段性验收；污水设施尚未取得','S093-04');
INSERT INTO wastewater(water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES
('W093-01','CN0365','自建生活及生产污水处理装置','2019-06建成运行（2021年报）',NULL,NULL,NULL,NULL,'氧化→反渗透→蒸发',NULL,NULL,'S093-01','WEB_COMPANY','年报合述生活和生产设施；不证明生活水全部同路；各股及产水/浓水去向未披露'),
('W093-02','CN0365','生产废水蒸发装置','2020-02建成（2021年报）',4,'t/h','设备处理能力',NULL,'蒸发',NULL,NULL,'S093-01','WEB_COMPANY','非实际流量；与2019蒸发是否同系统未明，不相加'),
('W093-03','CN0365','生产污水浓缩装置','2021-12建成（2021年报）',2.5,'m³/h','装置处理能力',NULL,'浓缩（技术类型未披露）',NULL,NULL,'S093-01','WEB_COMPANY','建设目的减少蒸发负荷、生产补水及运行成本；不推断具体膜或物料路径'),
('W093-04','CN0365','初期雨水收集池','2021-08建成（2021年报）',600,'m³','池有效性口径未披露的容积',NULL,'收集',NULL,NULL,'S093-01','WEB_COMPANY','非日处理量，去向未披露');
INSERT INTO process_diagrams(diagram_id,site_id,scope_key,stage,period,revision,coverage,mermaid,source_id,boundaries,gaps,updated_on) VALUES
('D093-01','CN0365','historical_wastewater_2019_2021','historical','2019–2021（2021年报）',1,'partial','flowchart TD
 A["自建污水装置（生活/生产合述，分流未披露）"] --> B["氧化"]
 B --> C["RO反渗透"]
 C --> D["蒸发"]
 C -. "去向未披露" .-> E["膜产水待核"]
 D -. "去向未披露" .-> F["冷凝水及残液待核"]
 G["2020生产废水蒸发装置 4t/h"]
 H["2021生产污水浓缩装置 2.5m³/h"]
 I["2021初雨收集池 600m³"]','S093-01','历史运行事实；G/H/I为新增设施清单，接入点未披露故不画连接；不推定浓缩装置为膜；不判2026运行状态','分股、实际流量、水质、膜型号及寿命、浓水和盐去向、火法改造后的变化','2026-11-28');
INSERT INTO process_diagram_evidence(evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES
('DE093-01','D093-01','W093-01','S093-01','2021年报p40截图','A,B,C,D','2019年6月建成运行及氧化、反渗透、蒸发顺序；E/F未核'),
('DE093-02','D093-01','W093-02','S093-01','2021年报p40','G','2020建成4t/h生产废水蒸发装置'),
('DE093-03','D093-01','W093-03','S093-01','2021年报p40','H','2021建成2.5m³/h浓缩装置，目的减量降本'),
('DE093-04','D093-01','W093-04','S093-01','2021年报p40','I','2021年初雨池600m³');
INSERT INTO membrane_reviews(review_id,site_id,diagram_id,scope_key,stage,period,revision,presence,source_id,evidence_basis,gaps,updated_on) VALUES
('R093-01','CN0365','D093-01','historical_wastewater_2019_2021','historical','2019–2021（2021年报）',1,'confirmed_present','S093-01','公司披露2019-06装置投运并明确RO；2024及2026H1只说明环保设施运行，不能证明原膜仍运行','现行分质处理、RO回收率/膜材/能耗及蒸发接口','2026-11-28');
INSERT INTO membrane_units(unit_id,review_id,unit_label,technology,role,feed,permeate_destination,concentrate_destination,specification,source_id,locator,notes) VALUES
('MU093-01','R093-01','2019污水装置RO','RO','污水处理','氧化后污水（分股不详）',NULL,NULL,NULL,'S093-01','p40截图','年报工艺顺序为氧化、RO、蒸发；未明示浓水连接，未核2026是否保留');
INSERT INTO membrane_retrofits(assessment_id,review_id,site_id,scope_key,option_key,revision,objective,proposed_route,feasibility,hard_constraints,evidence_basis,assumptions,missing_inputs,validation_plan,alternatives,feed_risk,pretreatment_risk,concentrate_risk,integration_risk,operational_risk,compliance_economics_risk,score_basis,updated_on) VALUES
('A093-R1','R093-01','CN0365','historical_wastewater_2019_2021','ro_evap_optimization',1,'同边界比较既有膜与蒸发负荷及贵金属损失','核实火法/湿法改造后各股进水，评估分质金属回收、既有氧化/RO优化及NF选择性分盐减量；仅在材料相容及浓液合规去向确认后小试','conditional','酸碱/贵金属回收、浓液合法处置、既有系统实际接入和可靠性','S093-01 p40历史投运与减量目标；S093-02/03后续运营背景','INFERRED；非现场确认或报价','分股流量、离子/金属、COD、酸度、膜通量/回收率、蒸发电汽耗、污泥和盐处置费用','取样、金属衡算、膜兼容性和污染小试、连续运行及同边界总费用对比','优化既有蒸发及源头回收；比较非膜减量',NULL,NULL,NULL,NULL,NULL,NULL,'缺六维实际参数，难度未知','2026-11-28');
INSERT INTO evidence_notes(note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES
('N093-01','CN0365','S093-01','历史真实污水设施及膜','2021年报p40截图','2019年6月自建生活和生产污水装置运行，工艺顺序氧化/RO/蒸发；2020年2月建成生产废水蒸发4t/h，2021年8月建初雨池600m³，2021年12月建生产污水浓缩2.5m³/h，目的减少蒸发处理、补水及运行费；无实测节省金额及浓缩设备类型。2021事故池未清空被罚10万元、公司称6月底整改；罚款非吨水费用。','WEB_COMPANY','WEB_TEXT','2026-11-28'),
('N093-02','CN0365','S093-02','2021验收及许可更新','2024年报p43截图','2017批准并环审评书〔2017〕014号，2021完成环保验收。排污证91140121MA0HDL4N4B001V有效期2025-01-23至2030-01-22；危废证HW省1401210058有效期2025-01-24至2030-01-23；公司称环保设施正常，2处危废贮存场所。并非独立核证2026膜工艺。','WEB_COMPANY','WEB_TEXT','2026-11-28'),
('N093-03','CN0365','S093-03','2026半年运营及后续取证路径','管理层讨论、环境披露索引','2026上半年报告称原料车间实施技改提升精制能力、环保装置稳定运行，未披露废水站单元及水质、能耗。环境信息披露系统索引http://221.204.12.149:8001/login#/；未获取报告，不假设可公开读。','WEB_COMPANY','WEB_TEXT','2026-11-28'),
('N093-04','CN0365','S093-05','历史固废外委招标分类','2022-10-21检索摘录；网页重开超时','招标要求承包方有相应资质处置含铂废催化剂浸出渣、歧化浸出渣、原料生产废盐及尾气活性炭；并非实际处置联单或污水蒸发盐定量，不认定生产废盐均来源于污水站。','WEB_SECONDARY','WEB_TEXT','2026-11-28'),
('N093-05','CN0137','S093-04','三项既有工程阶段验收','公示稿既有项目清单p31–32第76、78项及第109项；p32截图核78','2022-07-14烟环审〔2022〕39号一期技改两阶段分别2024-10-17、2025-11-28自主验收；2021-01-27烟环审〔2021〕15号制备三期2024-10-30自主验收，列WHC、WHR及蒸发浓缩单元。非原始验收监测；蒸发用途及真实处理量未披露，不与2026 WHC-D/E设计混同。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N093-06','CN0192','W07S18','正式批复残余物管理边界','批复第二条（四）及第三条','对中试水浸渣、多效蒸发废盐和焙烧脱硫产物，要求投产后鉴别，鉴别前按危废管理；产品钨酸、偏钒酸铵、四钼酸铵须在验收前完成环境风险评价并备案。旧80t/d、200t/d及1500t/a已录，不重复。批复设计非实际处置。','WEB_PRIMARY','WEB_TEXT','2026-11-28');
UPDATE sites SET permit_id='91140121MA0HDL4N4B001V',water_summary='2019–2021历史氧化/RO/蒸发；2020蒸发4t/h、2021浓缩2.5m³/h；2026H1公司称环保装置运行稳定，现行膜及分流待核；2023旧线火法改造方案保留',source_status='上市公司年报及历史运行证据',as_of='2026-11-28' WHERE site_id='CN0365';
INSERT INTO search_log(log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES
('L093-01','CN0365','093 document:annual2021_p40','历史实际膜工艺及能力','S093-01','2021年报p40截图','现行膜、分股、能耗','2026-11-28'),
('L093-02','CN0365','093 document:annual2024_p43','历史验收和许可更新','S093-02','2024年报p43截图','验收原件、许可执行报告','2026-11-28'),
('L093-03','CN0365','093 document:interim2026','2026运营与环境披露路径','S093-03','2026半年报正文','环境披露及现行工艺','2026-11-28'),
('L093-04','CN0365','093 search:2022_waste_residue','生产废盐及残渣采购','S093-05','检索摘录；正文超时','实际转移联单、污水盐来源','2026-11-28'),
('L093-05','CN0137','093 document:waste_station_2026_table','既有项目验收节点及蒸发单元','S093-04','p32截图；其他行正文可读','三期原验收及蒸发用途','2026-11-28'),
('L093-06','CN0192','093 document:approval_II4_III','废盐管理及风险评价要求','W07S18','正式批复正文；已录能力不重录','废盐鉴别结果及运行验收','2026-11-28'),
('L093-07','CN0289','093 search:permit','苏港2026拟许可','S039-03','原拟许可已录','正式核发及验收','2026-11-28'),
('L093-08','CN0338','093 search:permit','恒孚许可分项','S079-02','旧35000分项已录；有效期仍未核','许可原件','2026-11-28'),
('L093-09','CN0127','093 search:procurement_discovery','浙能膜浓缩采购','S022-010','既有中标金额和采购已录','正式验收','2026-11-28'),
('L093-10','CN0230','093 search:procurement_discovery','斯德瑞克废水工程中标','S030-10','已有中标金额','施工和验收','2026-11-28'),
('L093-11','CN0002','093 search:procurement_discovery','长岭废水药剂框架采购',NULL,'库中已有采购；未见实际药耗','实际消耗与成本','2026-11-28'),
('L093-12','CN0083','093 search:acceptance_discovery','天辰二期验收','W03S16','旧验收转载命中','原报告独立新章节','2026-11-28'),
('L093-13','CN0095','093 search:approval_discovery','福建恒申拟批及核准','W07S04','同源拟批已录','正式批复及验收','2026-11-28'),
('L093-14','CN0253','093 search:approval_discovery','南通泰禾一期批复及二期受理','S023-002','既有12吨及150吨边界和受理已录','二期正式批复/可读报告','2026-11-28'),
('L093-15','CN0031','093 search:acceptance_discovery','铜川凯立二阶段验收','S051-01','旧验收摘录已录，原文仍受阻','完整实际列','2026-11-28'),
('L093-16','CN0066','093 search:approval_discovery','重庆远达改造',NULL,'旧RO/MVR设计已录','正式验收','2026-11-28'),
('L093-17','CN0363','093 search:recent_eia_discovery','辽宁众力新项目','S092-02','旧3500公示索引命中，未得原报告','官方报告正文','2026-11-28');
INSERT INTO research_revisit_attempts(attempt_id,site_id,scope_key,gap,route_key,search_log_id,source_id,checked_on,outcome,gained_fields,evidence_refs,effort_minutes,next_check_on,reopen_trigger,rationale) VALUES
('A093-01','CN0365','historical_wastewater_2019_2021','历史实际膜工艺及能力','document:annual2021_p40','L093-01','S093-01','2026-11-28','engineering_gain','4废水记录、历史图、RO核查及设备','W093-01–04/D093-01/R093-01/MU093-01',NULL,NULL,'现行膜、分股、能耗','2021年报p40截图'),
('A093-02','CN0365','site_current','历史验收和许可更新','document:annual2024_p43','L093-02','S093-02','2026-11-28','context_gain','验收及许可有效期、项目','P093-01/N093-02',NULL,NULL,'验收原件、许可执行报告','2024年报p43截图'),
('A093-03','CN0365','site_current','2026运营与环境披露路径','document:interim2026','L093-03','S093-03','2026-11-28','context_gain','运行陈述及披露入口','N093-03',NULL,NULL,'环境披露及现行工艺','2026半年报正文'),
('A093-04','CN0365','historical_residuals','生产废盐及残渣采购','search:2022_waste_residue','L093-04','S093-05','2026-11-28','context_gain','残渣和生产废盐外委招标分类','N093-04',NULL,NULL,'实际转移联单、污水盐来源','检索摘录；正文超时'),
('A093-05','CN0137','historical_catalyst_phases','既有项目验收节点及蒸发单元','document:waste_station_2026_table','L093-05','S093-04','2026-11-28','context_gain','三个项目及验收期次','P093-02–04/N093-05',NULL,NULL,'三期原验收及蒸发用途','p32截图；其他行正文可读'),
('A093-06','CN0192','pilot_1500','废盐管理及风险评价要求','document:approval_II4_III','L093-06','W07S18','2026-11-28','engineering_gain','废盐鉴别与暂管边界','N093-06',NULL,NULL,'废盐鉴别结果及运行验收','正式批复正文；已录能力不重录'),
('A093-07','CN0289','site_current','苏港2026拟许可','search:permit','L093-07','S039-03','2026-11-28','duplicate','无','S039-03',NULL,'2026-12-28','正式核发及验收','原拟许可已录'),
('A093-08','CN0338','site_current','恒孚许可分项','search:permit','L093-08','S079-02','2026-11-28','duplicate','无','S079-02',NULL,'2026-12-28','许可原件','旧35000分项已录；有效期仍未核'),
('A093-09','CN0127','site_current','浙能膜浓缩采购','search:procurement_discovery','L093-09','S022-010','2026-11-28','duplicate','无','S022-010',NULL,'2026-12-28','正式验收','既有中标金额和采购已录'),
('A093-10','CN0230','site_current','斯德瑞克废水工程中标','search:procurement_discovery','L093-10','S030-10','2026-11-28','duplicate','无','S030-10',NULL,'2026-12-28','施工和验收','已有中标金额'),
('A093-11','CN0002','site_current','长岭废水药剂框架采购','search:procurement_discovery','L093-11',NULL,'2026-11-28','duplicate','无','历史采购',NULL,'2026-12-28','实际消耗与成本','库中已有采购；未见实际药耗'),
('A093-12','CN0083','site_current','天辰二期验收','search:acceptance_discovery','L093-12','W03S16','2026-11-28','duplicate','无','W03S16',NULL,'2026-12-28','原报告独立新章节','旧验收转载命中'),
('A093-13','CN0095','site_current','福建恒申拟批及核准','search:approval_discovery','L093-13','W07S04','2026-11-28','duplicate','无','W07S04',NULL,'2026-12-28','正式批复及验收','同源拟批已录'),
('A093-14','CN0253','site_current','南通泰禾一期批复及二期受理','search:approval_discovery','L093-14','S023-002','2026-11-28','duplicate','无','S023-002/S041-04',NULL,'2026-12-28','二期正式批复/可读报告','既有12吨及150吨边界和受理已录'),
('A093-15','CN0031','site_current','铜川凯立二阶段验收','search:acceptance_discovery','L093-15','S051-01','2026-11-28','duplicate','无','S051-01',NULL,'2026-12-28','完整实际列','旧验收摘录已录，原文仍受阻'),
('A093-16','CN0066','site_current','重庆远达改造','search:approval_discovery','L093-16',NULL,'2026-11-28','duplicate','无','历史设计',NULL,'2026-12-28','正式验收','旧RO/MVR设计已录'),
('A093-17','CN0363','high_end_3500','辽宁众力新项目','search:recent_eia_discovery','L093-17','S092-02','2026-11-28','duplicate','无','S092-02',NULL,'2026-12-28','官方报告正文','旧3500公示索引命中，未得原报告');
INSERT INTO research_document_review(site_id,source_id,scope_key,gap,reviewed_on,state,locator,remaining_work,next_check_on,attempt_id) VALUES
('CN0365','S093-01','historical_wastewater_2019_2021','历史实际膜工艺及能力','2026-11-28','section_done','2021年报p40截图','现行水质及运行成本',NULL,'A093-01'),
('CN0365','S093-02','site_current','历史验收和许可更新','2026-11-28','section_done','2024年报p43截图','验收原件与许可执行',NULL,'A093-02'),
('CN0137','S093-04','historical_catalyst_phases','既有项目验收节点及蒸发单元','2026-11-28','section_done','p31–32及第109项','原验收/蒸发用途',NULL,'A093-05'),
('CN0192','W07S18','pilot_1500','废盐管理及风险评价要求','2026-11-28','section_done','第二条（四）及第三条','实际鉴别结果',NULL,'A093-06');
COMMIT;
