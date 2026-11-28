PRAGMA foreign_keys=ON;
BEGIN;
INSERT INTO sources(source_id,title,url,source_type,document_date,scope,access_date) VALUES
('S090-01','450吨/年环氧化催化剂连续高效滚球成型示范装置环评报告表','https://app.yunxiqu.gov.cn/uploadfiles/202507/2025070709572277394.pdf','政府公示环评报告','2024','云溪成型项目设计','2026-11-28'),
('S090-02','岳云环评〔2024〕3号项目批复','https://www.yunxiqu.gov.cn/uploadfiles/202507/2025070710100960103.pdf','政府环评批复','2024','云溪450吨成型项目','2026-11-28'),
('S090-03','3000吨/年失活催化剂再生项目机械竣工','https://scc.sinopec.com/scc/news/qygg/2026/9/I1550170268180152320.shtml','企业新闻','2026-09-11','项目机械竣工；厂址由采购交叉推断','2026-11-28'),
('S090-04','大连3000吨/年失活催化剂再生项目火灾报警系统采购','https://ec.sinopec.com/f/supp/notice/bidNotice.do?id=9295851129E91615C0CA3136D9D5BBDA','企业采购','2026-06-29','大连项目名称及采购','2026-11-28');
INSERT INTO site_sources(site_id,source_id) VALUES
('CN0003','S090-01'),
('CN0003','S090-02'),
('CN0004','S090-03'),
('CN0004','S090-04');
INSERT INTO capacity(capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES
('C090-01','CN0003','环氧化催化剂滚球成型',450,'t/a','环评批准设计','2024','成型示范装置','S090-02','原委外成型改为厂内加工；不作为新增成品总产能'),
('C090-02','CN0004','失活催化剂再生',3000,'t/a','采购项目名义规模','2026','再生项目','S090-04','非实际处理量；不得与加氢成品产能简单相加');
INSERT INTO projects(project_id,site_id,project,status,date,capacity_note,water_change,source_id) VALUES
('P090-01','CN0003','450吨/年环氧化催化剂连续高效滚球成型示范装置','2024环评批复；实际投运待核','2024','450t/a成型能力，非净新增成品','清洗水设计送共享低氨氮生化；水封水回用','S090-02'),
('P090-02','CN0004','3000吨/年失活催化剂再生项目','2026年6月采购已证；9月机械竣工报道与该项目疑同一，待厂址核实','2026-09-11','3000t/a项目名义规模','废水设计及实际运行未取得','S090-04');
INSERT INTO wastewater(water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES
('W090-01','CN0268','既有污水站','2018环评回顾设计',300,'t/d','站设计处理能力',NULL,'沉淀→中间池pH调节','水阁污水处理厂',NULL,'S032-01','WEB_PRIMARY','8.2.2 p162–163；不等于实际'),
('W090-02','CN0268','既有污水站','2018报告时点历史',120,'t/d','报告记载当时处理量',NULL,NULL,NULL,NULL,'S032-01','WEB_PRIMARY','非计量台账；不与2022–24 m³/d统计直接比较'),
('W090-03','CN0268','既有污水站','2018报告时点设计余量',180,'t/d','报告所列剩余处理能力',NULL,NULL,NULL,NULL,'S032-01','WEB_PRIMARY','非2026可用余量'),
('W090-04','CN0268','TD-320项目综合排水','2018技改预测',95.7,'t/d','环评预测日排放','COD、氨氮、TN、SS','依托既有站','水阁污水处理厂',NULL,'S032-01','WEB_PRIMARY','8.2.2；非实测'),
('W090-05','CN0003','滚球成型设备清洗废水','2024环评设计',77.4,'t/a','表4-12年产生量；0.258t/d','COD、氨氮、SS','容器转运→共享低氨氮生化','共享站总排口→长江',NULL,'S090-01','WEB_PRIMARY','§4.1另载10.34m³/d与表不一致，待核；非运行量'),
('W090-06','CN0003','水封水','2024环评设计',27,'t/a','文本年回用量',NULL,'回用于溶液调配','生产回用',NULL,'S090-01','WEB_PRIMARY','水平衡图标m³/a，文本t/a；不擅自换算；非排放');
INSERT INTO water_metrics(metric_id,site_id,water_id,point,metric,value_num,value_text,unit,result_kind,statistic,period,detection_limit,standard_max,source_id,notes) VALUES
('M090-001','CN0268','W090-04','项目纳管预测','COD',350,NULL,'mg/L','设计预测','环评预测','2018-12',NULL,500,'S032-01','表8.2-4；非实测'),
('M090-002','CN0268','W090-04','项目纳管预测','氨氮',6.05,NULL,'mg/L','设计预测','环评预测','2018-12',NULL,35,'S032-01','表8.2-4；非实测'),
('M090-003','CN0268','W090-04','项目纳管预测','总氮',7.13,NULL,'mg/L','设计预测','环评预测','2018-12',NULL,70,'S032-01','表8.2-4；非实测'),
('M090-004','CN0268','W090-04','项目纳管预测','SS',0.105,NULL,'mg/L','设计预测','环评预测','2018-12',NULL,400,'S032-01','表8.2-4；非实测'),
('M090-005','CN0003','W090-05','清洗废水产生','COD',60,NULL,'mg/L','设计源强','环评预测','2024',NULL,NULL,'S090-01','表4-12；非实测'),
('M090-006','CN0003','W090-05','共享处理后预测','COD',50,NULL,'mg/L','设计预测','环评预测','2024',NULL,NULL,'S090-01','表4-12；非实测'),
('M090-007','CN0003','W090-05','清洗废水产生','氨氮',5,NULL,'mg/L','设计源强','环评预测','2024',NULL,NULL,'S090-01','表4-12；非实测'),
('M090-008','CN0003','W090-05','共享处理后预测','氨氮',5,NULL,'mg/L','设计预测','环评预测','2024',NULL,NULL,'S090-01','表4-12；非实测'),
('M090-009','CN0003','W090-05','清洗废水产生','SS',150,NULL,'mg/L','设计源强','环评预测','2024',NULL,NULL,'S090-01','表4-12；非实测'),
('M090-010','CN0003','W090-05','共享处理后预测','SS',10,NULL,'mg/L','设计预测','环评预测','2024',NULL,NULL,'S090-01','表4-12；非实测');
INSERT INTO process_diagrams(diagram_id,site_id,scope_key,stage,period,revision,coverage,mermaid,source_id,boundaries,gaps,updated_on) VALUES
('D090-01','CN0268','td320_2018_design','design','2018-12报批稿',2,'partial','flowchart TD
 A["晶化洗涤"] --> E["沉淀池"]
 B["酸化洗涤"] --> E
 C["喷淋废水"] --> E
 D["制纯水废水 图示"] --> E
 E --> F["中间池 在线pH 硫酸/NaOH"]
 F --> G["总排口 pH 6–9"]
 G --> H["市政管网 水阁污水厂"]
 I["晶化母液"] --> J["蒸馏（正文）"] --> E
 K["高浓废液"] --> L["自身焚烧（设计）"]
 M["RO浓水 正文"] --> N["循环冷却补水"]','S032-01','图8.2-3与正文合并标记；制纯水废水图示与RO浓水冷却回用正文边界有差异；历史脱氨膜独立范围不合并','现行分流、沉淀污泥、真实处理量和成本','2026-11-28'),
('D090-02','CN0003','epoxidation_ball_forming_2024','design','2024',1,'partial','flowchart TD
 A["设备清洗水 77.4 t/a"] --> B["容器转运"]
 B --> C["共享低氨氮生化"]
 C --> D["共享总排口"]
 D --> E["长江"]
 F["水封水 27 t/a"] --> G["溶液调配回用"]','S090-01','仅滚球成型项目；共享站其他流股及其他分子筛膜项目不并入','投运、真实水量、共享站衔接和成本','2026-11-28');
INSERT INTO process_diagram_evidence(evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES
('DE090-01','D090-01','W090-01','S032-01','图8.2-3 p163；8.2.2','A,B,C,D,E,F,G,H','四类水入沉淀，中间池调pH后市政纳管'),
('DE090-02','D090-01','W032-10','S032-01','4.3.2及8.2.2','I,J,E','母液蒸馏正文'),
('DE090-03','D090-01',NULL,'S032-01','既有D032-01；正文','K,L','高浓废液焚烧设计'),
('DE090-04','D090-01','W032-11','S032-01','4.3.2','M,N','RO浓水冷却回用，与图中制纯水废水范围不强行等同'),
('DE090-05','D090-02','W090-05','S090-01','表4-12、§4.1','A,B,C,D,E','清洗水容器转运、共享低氨氮处理及排放'),
('DE090-06','D090-02','W090-06','S090-01','水平衡及§4.1','F,G','水封回用于溶液调配');
INSERT INTO membrane_reviews(review_id,site_id,diagram_id,scope_key,stage,period,revision,presence,source_id,evidence_basis,gaps,updated_on) VALUES
('R090-01','CN0268','D090-01','td320_2018_design','design','2018-12报批稿',2,'not_identified','S032-01','该设计末端未识别膜；不否定2017历史脱氨膜及制纯水RO','现行膜及分质运行','2026-11-28'),
('R090-02','CN0003','D090-02','epoxidation_ball_forming_2024','design','2024',1,'not_identified','S090-01','成型项目依托低氨氮生化；不否定基地其他ED/BMED','现行共享站及成型实际运行','2026-11-28');
INSERT INTO membrane_retrofits(assessment_id,review_id,site_id,scope_key,option_key,revision,objective,proposed_route,feasibility,hard_constraints,evidence_basis,assumptions,missing_inputs,validation_plan,alternatives,feed_risk,pretreatment_risk,concentrate_risk,integration_risk,operational_risk,compliance_economics_risk,score_basis,updated_on) VALUES
('A090-R1','R090-01','CN0268','td320_2018_design','screening',2,'减量及回用','分质确认后低盐洗水可筛UF/RO；母液优先有机回收/蒸馏；沉淀后需去除结垢离子、确认浓液去向','conditional','现行水量、盐度、有机物、浓水出路及回用需求','D090-01及历史报告','INFERRED；非现场现状','现行流量、离子、COD、费用、场地','分股采样、膜小试、全成本比较','优化已有沉淀中和与分质回用',NULL,NULL,NULL,NULL,NULL,NULL,'缺六维真实输入，不评分','2026-11-28'),
('A090-R2','R090-02','CN0003','epoxidation_ball_forming_2024','screening',1,'清洗水减量','按设计0.258t/d不优先单建膜；若同质清洗水有足够合并规模，可先筛UF/RO回用','not_recommended','共享站合法接管、水质兼容、回用需求及浓水去向','D090-02；仅单项目预测规模','INFERRED；非成本实测或最终经济结论','真实量、共享站余量、离子、能源与药耗','核实矛盾水量、合并水质及边际处理费，比较回用小试','继续共享生化、源头减量及水封回用',NULL,NULL,NULL,NULL,NULL,NULL,'数据不足，不评分；不否定基地级改造','2026-11-28');
INSERT INTO evidence_notes(note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES
('N090-01','CN0268','S032-01','污水站能力及设备','8.2.2 p162–164；图8.2-3 p163截图','设计300t/d，当时120t/d，余180t/d；项目预测95.7t/d，依托既有站；沉淀、中间池在线pH控制硫酸及NaOH、pH6–9后纳管水阁；300m³事故应急池及480m³消防水池，非处理能力；制纯水废水图示与RO浓水回用正文边界需核。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N090-02','CN0003','S090-01','成型项目设计源强及冲突','表4-12 p61；§4.1 p62','清洗用水86t/a，清洗废水77.4t/a、0.258t/d；另述10.34m³/d存在冲突。水封水27t/a回用，图单位m³/a；无新增生活水。COD/氨氮/SS产生负荷0.005/0.0004/0.012t/a，预测排放负荷0.0004/0.0004/0.0008t/a；COD排放负荷与77.4t/a×50mg/L核算不一致，保留原值不纠改。表7列DW001，与其他年份排口编号不强行合并。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N090-03','CN0003','S090-01','成型项目投资及处理边界','工程概况、§4.1','项目总投资550.18万元、环保投资68万元，非废水单项投资或吨水成本；共享站能力4800m³/d、允许排水4520m³/d为环评口径，非本装置水量；原委外成型改厂内。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N090-04','CN0004','S090-03','机械竣工交叉识别','2026-09-11企业新闻；S090-04采购','企业报道3000t/a失活催化剂再生项目机械竣工，报道未明示大连；6月29日大连同名同规模采购支持关联，仍属待核；机械竣工非试车、验收或实际产量。','WEB_PRIMARY','WEB_TEXT','2026-11-28');
INSERT INTO search_log(log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES
('L090-01','CN0268','090 document:8.2.2','td320_2018_design 站能力与沉淀接管工艺','S032-01','原环评正文和p162–163截图','现行工艺及实际运行','2026-11-28'),
('L090-02','CN0003','090 document:new_project','epoxidation_ball_forming_2024 独立成型项目与清洗水','S090-01','政府报告正文；批复正文交叉核；截图受限','验收、矛盾水量核对','2026-11-28'),
('L090-03','CN0004','090 event:procurement_news','regeneration_3000_2026 新再生项目采购及机械竣工','S090-04','企业采购与同名机械竣工报道','厂址、验收及排水设计','2026-11-28'),
('L090-04','CN0265','090 search:acceptance_discovery','site_current 验收报告索引查重','S031-05','旧来源已收录','独立新报告或未提取章节','2026-11-28'),
('L090-05','CN0170','090 search:acceptance_discovery','site_current 载体项目验收索引查重','S031-14','旧来源已收录','独立新报告或未提取章节','2026-11-28'),
('L090-06','CN0083','090 search:acceptance_discovery','site_current 验收索引查重','W03S16','旧来源已收录','独立新报告或未提取章节','2026-11-28');
INSERT INTO research_revisit_attempts(attempt_id,site_id,scope_key,gap,route_key,search_log_id,source_id,checked_on,outcome,gained_fields,evidence_refs,effort_minutes,next_check_on,reopen_trigger,rationale) VALUES
('A090-01','CN0268','td320_2018_design','站能力与沉淀接管工艺','document:8.2.2','L090-01','S032-01','2026-11-28','engineering_gain','4水量口径、4预测指标、修订图','W090-01–04/M090-001–004/D090-01',NULL,NULL,'现行工艺及实际运行','原报告新章节'),
('A090-02','CN0003','epoxidation_ball_forming_2024','独立成型项目与清洗水','document:new_project','L090-02','S090-01','2026-11-28','engineering_gain','项目、成型规模、2股水、6指标、流程图','P090-01/C090-01/W090-05–06/D090-02',NULL,NULL,'验收、矛盾水量核对','非490t/a再生项目'),
('A090-03','CN0004','regeneration_3000_2026','新再生项目采购及机械竣工','event:procurement_news','L090-03','S090-04','2026-11-28','context_gain','项目及名义规模、待核建设节点','P090-02/C090-02/N090-04',NULL,NULL,'厂址、验收及排水设计','报道厂址尚未明确'),
('A090-04','CN0265','site_current','验收报告索引查重','search:acceptance_discovery','L090-04','S031-05','2026-11-28','duplicate','无','S031-05',NULL,'2026-12-28','独立新报告或未提取章节','广泛发现命中旧源，未重复提取'),
('A090-05','CN0170','site_current','载体项目验收索引查重','search:acceptance_discovery','L090-05','S031-14','2026-11-28','duplicate','无','S031-14',NULL,'2026-12-28','独立新报告或未提取章节','广泛发现命中旧源'),
('A090-06','CN0083','site_current','验收索引查重','search:acceptance_discovery','L090-06','W03S16','2026-11-28','duplicate','无','W03S16',NULL,'2026-12-28','独立新报告或未提取章节','广泛发现命中旧源');
INSERT INTO research_document_review(site_id,source_id,scope_key,gap,reviewed_on,state,locator,remaining_work,next_check_on,attempt_id) VALUES
('CN0268','S032-01','td320_2018_design','站能力与沉淀接管工艺','2026-11-28','section_done','8.2.2 p162–164','现行工艺及实测另查',NULL,'A090-01'),
('CN0003','S090-01','epoxidation_ball_forming_2024','独立成型项目与清洗水','2026-11-28','partial','表4-12及§4.1','矛盾水量及验收',NULL,'A090-02');
COMMIT;
