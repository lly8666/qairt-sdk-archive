BEGIN;
-- 025: evidence increment and reversible task triage; no historical records removed.
INSERT INTO sources (source_id,title,url,source_type,document_date,scope,access_date) VALUES ('S025-01','华茂伟业2023年3月招股说明书（申报稿）','https://reportdocs.static.szse.cn/UpFiles/rasinfodisc1/202303/RAS_202303_7B7B7616E8EB48E68A77229425484A7C.pdf','上市披露','2023-03','1-1-84至87；p86截图复核','2026-11-27');
INSERT INTO site_sources (site_id,source_id) VALUES ('CN0119','S025-01');
INSERT INTO sources (source_id,title,url,source_type,document_date,scope,access_date) VALUES ('S025-02','2022年安徽元琛环保科技股份有限公司清洁生产审核公示','https://www.yckjgf.com/news/14/2295','企业清洁生产公示','2022-08-17','废水排放表、危险废物和风险防范措施','2026-11-27');
INSERT INTO site_sources (site_id,source_id) VALUES ('CN0125','S025-02');
INSERT INTO sources (source_id,title,url,source_type,document_date,scope,access_date) VALUES ('S025-03','山西腾茂科技股份有限公司2023年度报告','https://pdf.dfcfw.com/pdf/H2_AN202404291631581292_1.pdf?1714405104000.pdf=','上市披露','2024-04-29','第25至27页，产能及环保；截图超时','2026-11-27');
INSERT INTO site_sources (site_id,source_id) VALUES ('CN0141','S025-03');
INSERT INTO sources (source_id,title,url,source_type,document_date,scope,access_date) VALUES ('S025-04','惠城环保2022年年度报告（新浪转载）','https://money.finance.sina.com.cn/corp/view/vCB_AllBulletinDetail.php?id=9017652','上市披露转载','2023','淮河路污染物处理；不同于既有2024年报','2026-11-27');
INSERT INTO site_sources (site_id,source_id) VALUES ('CN0196','S025-04');
INSERT INTO wastewater (water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES ('W025-01','CN0119','生产工艺废水','2020–2022报告期披露',NULL,NULL,NULL,NULL,'二级膜过滤（膜种未披露）','滤清液入综合站；具体滤清液归属待核',NULL,'S025-01','WEB_COMPANY','不能将二级膜过滤自动认定UF');
INSERT INTO wastewater (water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES ('W025-02','CN0119','树脂再生废水','2020–2022报告期披露',NULL,NULL,NULL,'盐','ED；浓盐水蒸发结晶，淡水送RO','结晶母液回蒸发；RO产水及浓水分别去向待核','氯化钠结晶','S025-01','WEB_COMPANY','淡水进入RO，不猜测具体回收率');
INSERT INTO wastewater (water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES ('W025-03','CN0119','综合污水站','2020–2022报告期披露',80,'m³/d','设施处理能力','COD、氨氮','调节→两级电催化氧化→厌氧→缺氧→好氧→沉淀→深度净化','外排池→园区管网→沧州绿源临港污水厂','生化污泥作为一般固废处置','S025-01','WEB_COMPANY','生活经化粪池、冷却排水及滤清液入站；报告期主要回用，仅2022-01少量外排；非实测日水量');
INSERT INTO wastewater (water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES ('W025-04','CN0119','离心废水及浓缩液','2020–2022报告期披露',10,'t/d','TO设备能力',NULL,'高温焚烧','焚烧',NULL,'S025-01','WEB_COMPANY','设备1套，报告期披露正常；非站总流量');
INSERT INTO wastewater (water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES ('W025-05','CN0119','蒸发冷凝水及SIN设备汲水','2020–2022报告期披露',NULL,NULL,NULL,NULL,NULL,'冷却循环补水',NULL,'S025-01','WEB_COMPANY','SIN原文名称，技术不推定');
INSERT INTO wastewater (water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES ('W025-06','CN0125','企业废水排放','2022-08清洁生产公示',NULL,NULL,NULL,'COD、BOD5、氨氮、SS、总磷、动植物油',NULL,NULL,'污泥（含污盐）HW49','S025-02','WEB_COMPANY','公示未给测点和监测时间；不得用浓度及质量反推流量');
INSERT INTO water_metrics (metric_id,site_id,water_id,point,metric,value_num,value_text,unit,result_kind,statistic,period,detection_limit,standard_max,source_id,notes) VALUES ('M025-1c','CN0125','W025-06','企业废水排放（未标测点）','COD',45,NULL,'mg/L','公示排放浓度','统计期及方法未披露','2022-08公示',NULL,NULL,'S025-02','保持原表口径；浓度/总量不倒推流量');
INSERT INTO water_metrics (metric_id,site_id,water_id,point,metric,value_num,value_text,unit,result_kind,statistic,period,detection_limit,standard_max,source_id,notes) VALUES ('M025-1m','CN0125','W025-06','企业废水排放（未标测点）','COD',0.13786,NULL,'t/a','公示年排放量','统计期及方法未披露','2022-08公示',NULL,NULL,'S025-02','保持原表口径；浓度/总量不倒推流量');
INSERT INTO water_metrics (metric_id,site_id,water_id,point,metric,value_num,value_text,unit,result_kind,statistic,period,detection_limit,standard_max,source_id,notes) VALUES ('M025-2c','CN0125','W025-06','企业废水排放（未标测点）','BOD5',17.7,NULL,'mg/L','公示排放浓度','统计期及方法未披露','2022-08公示',NULL,NULL,'S025-02','保持原表口径；浓度/总量不倒推流量');
INSERT INTO water_metrics (metric_id,site_id,water_id,point,metric,value_num,value_text,unit,result_kind,statistic,period,detection_limit,standard_max,source_id,notes) VALUES ('M025-2m','CN0125','W025-06','企业废水排放（未标测点）','BOD5',0.051354,NULL,'t/a','公示年排放量','统计期及方法未披露','2022-08公示',NULL,NULL,'S025-02','保持原表口径；浓度/总量不倒推流量');
INSERT INTO water_metrics (metric_id,site_id,water_id,point,metric,value_num,value_text,unit,result_kind,statistic,period,detection_limit,standard_max,source_id,notes) VALUES ('M025-3c','CN0125','W025-06','企业废水排放（未标测点）','氨氮',0.218,NULL,'mg/L','公示排放浓度','统计期及方法未披露','2022-08公示',NULL,NULL,'S025-02','保持原表口径；浓度/总量不倒推流量');
INSERT INTO water_metrics (metric_id,site_id,water_id,point,metric,value_num,value_text,unit,result_kind,statistic,period,detection_limit,standard_max,source_id,notes) VALUES ('M025-3m','CN0125','W025-06','企业废水排放（未标测点）','氨氮',0.0281,NULL,'t/a','公示年排放量','统计期及方法未披露','2022-08公示',NULL,NULL,'S025-02','保持原表口径；浓度/总量不倒推流量');
INSERT INTO water_metrics (metric_id,site_id,water_id,point,metric,value_num,value_text,unit,result_kind,statistic,period,detection_limit,standard_max,source_id,notes) VALUES ('M025-4c','CN0125','W025-06','企业废水排放（未标测点）','SS',24,NULL,'mg/L','公示排放浓度','统计期及方法未披露','2022-08公示',NULL,NULL,'S025-02','保持原表口径；浓度/总量不倒推流量');
INSERT INTO water_metrics (metric_id,site_id,water_id,point,metric,value_num,value_text,unit,result_kind,statistic,period,detection_limit,standard_max,source_id,notes) VALUES ('M025-4m','CN0125','W025-06','企业废水排放（未标测点）','SS',0.17202,NULL,'t/a','公示年排放量','统计期及方法未披露','2022-08公示',NULL,NULL,'S025-02','保持原表口径；浓度/总量不倒推流量');
INSERT INTO water_metrics (metric_id,site_id,water_id,point,metric,value_num,value_text,unit,result_kind,statistic,period,detection_limit,standard_max,source_id,notes) VALUES ('M025-5c','CN0125','W025-06','企业废水排放（未标测点）','总磷',3.33,NULL,'mg/L','公示排放浓度','统计期及方法未披露','2022-08公示',NULL,NULL,'S025-02','保持原表口径；浓度/总量不倒推流量');
INSERT INTO water_metrics (metric_id,site_id,water_id,point,metric,value_num,value_text,unit,result_kind,statistic,period,detection_limit,standard_max,source_id,notes) VALUES ('M025-5m','CN0125','W025-06','企业废水排放（未标测点）','总磷',0.00317,NULL,'t/a','公示年排放量','统计期及方法未披露','2022-08公示',NULL,NULL,'S025-02','保持原表口径；浓度/总量不倒推流量');
INSERT INTO water_metrics (metric_id,site_id,water_id,point,metric,value_num,value_text,unit,result_kind,statistic,period,detection_limit,standard_max,source_id,notes) VALUES ('M025-6c','CN0125','W025-06','企业废水排放（未标测点）','动植物油',0.44,NULL,'mg/L','公示排放浓度','统计期及方法未披露','2022-08公示',NULL,NULL,'S025-02','保持原表口径；浓度/总量不倒推流量');
INSERT INTO water_metrics (metric_id,site_id,water_id,point,metric,value_num,value_text,unit,result_kind,statistic,period,detection_limit,standard_max,source_id,notes) VALUES ('M025-6m','CN0125','W025-06','企业废水排放（未标测点）','动植物油',0.00398,NULL,'t/a','公示年排放量','统计期及方法未披露','2022-08公示',NULL,NULL,'S025-02','保持原表口径；浓度/总量不倒推流量');
INSERT INTO wastewater (water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES ('W025-07','CN0141','化学水制备含盐废水及过滤零级、一级滤液','2023年报',NULL,NULL,NULL,'盐类、SS','尾气循环喷淋吸收（原表相邻两行共用或合并处理栏，滤液单独流向需复核）','尾气吸收系统',NULL,'S025-03','WEB_COMPANY','过滤是产品环节；非膜证据；截图超时');
INSERT INTO wastewater (water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES ('W025-08','CN0141','尾气吸收系统废水','2023年报',NULL,NULL,NULL,'SS、无机盐','沉降','循环利用','沉降底料及污泥返回水封罐和反应工序（固废表）','S025-03','WEB_COMPANY','未确认目前运行');
INSERT INTO wastewater (water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES ('W025-09','CN0141','空压机及风机轴承冷却排水','2023年报',NULL,NULL,NULL,'SS','循环使用','循环回用',NULL,'S025-03','WEB_COMPANY','公用水独立于工艺废水');
INSERT INTO wastewater (water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES ('W025-10','CN0196','淮河路含盐生产废水','2022年报',NULL,NULL,NULL,'盐','处理达标；单元未披露','高盐水管道排海',NULL,'S025-04','WEB_COMPANY','DB37/3416.5-2018；非董家口；历史排放方式非现行确认');
INSERT INTO capacity (capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES ('C025-01','CN0141','FCC催化剂',40000,'吨/年','2023年报设计产能','2023','全厂','S025-03','产能利用率90%；不同于2021验收及2025设计25000吨/年，不相加');
INSERT INTO evidence_notes (note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES ('N025-01','CN0119','S025-01','运行状态及费用范围','1-1-86至87','报告期TO一套10t/d、污水站一套80m³/d，企业称正常；2022年1月少量外排。废RO膜为危废；2020、2021、2022日常环保费49.40、136.25、169.15万元，环保设施投入909.00、803.81、24.11万元；危废处置费用0.51、0.37、0.92万元、量1.05、0.58、1.49吨，非污水专用费用，不进入逐厂吨水成本。','WEB_COMPANY','公开正文/披露转述；非原件归档','2026-11-27');
INSERT INTO evidence_notes (note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES ('N025-02','CN0125','S025-02','公示厂址及污水设施安全','第三、四节','合肥新站区站北社区西淝河路；污泥含污盐31.578（原表产生量栏未注明单位），HW49；已建事故池216m³；再生区围堰高0.5m，导流沟集液槽总有效70m³；脱盐装置区为重点防渗区，但未披露具体膜类型，池容不是处理量。','WEB_COMPANY','公开正文/披露转述；非原件归档','2026-11-27');
INSERT INTO evidence_notes (note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES ('N025-03','CN0141','S025-03','规模及年度状态','第25至27页','2023设计4万吨、利用率90%，报告称环保设施正常；过滤沉降及喷淋沉降底料和污泥回焙烧水封罐及反应工序；筛分粗料返磨细罐。与历史2025设计2.5万吨口径差异保留；不据利用率倒填实产量。','WEB_COMPANY','公开正文/披露转述；非原件归档','2026-11-27');
INSERT INTO evidence_notes (note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES ('N025-04','CN0196','S025-04','厂区排放边界','污染物处理1','2022年报淮河路含盐废水经处理按半岛流域标准排入高盐水管道排海；既有2024年报记2021升级验收，非同一报告，不推定零排放或膜。','WEB_COMPANY','公开正文/披露转述；非原件归档','2026-11-27');
INSERT INTO claims (claim_id,site_id,field,value,evidence_class,source_id,scope,observed_date) VALUES ('CL025-01','CN0119','历史污水膜技术','二级膜过滤（类型未知）、ED脱盐、RO；蒸发结晶与TO；综合站80m³/d','WEB_COMPANY','S025-01','沧州临港混合化工厂区，非单一胺催化剂装置','2023-03');
INSERT INTO claims (claim_id,site_id,field,value,evidence_class,source_id,scope,observed_date) VALUES ('CL025-02','CN0141','2023设计产能','40000吨/年，利用率90%','WEB_COMPANY','S025-03','2023年报，非2025现行','2023');
INSERT INTO process_diagrams (diagram_id,site_id,scope_key,stage,period,revision,coverage,mermaid,source_id,boundaries,gaps,updated_on) VALUES ('D025-01','CN0119','mixed-site-water','historical','2020–2022报告期',1,'partial','flowchart TD
 A["生产废水"] --> B["二级膜过滤（膜种未知）"]
 C["树脂再生废水"] --> D["ED脱盐"]
 D -->|浓盐水| E["蒸发结晶"]
 E --> F["NaCl结晶"]
 E -->|母液| E
 D -->|淡水| G["RO"]
 G --> X["RO产浓水单独去向待核"]
 H["滤清液（具体来源待核）"] --> J["综合站 80m³/d"]
 I["生活化粪池及冷却排水"] --> J
 J --> K["调节/两级电催化氧化"]
 K --> L["厌氧/缺氧/好氧"]
 L --> M["沉淀/深度净化"]
 M --> N["外排池/园区管网"]
 N --> O["沧州绿源临港污水厂"]
 P["离心废水和浓缩液"] --> Q["TO 10t/d"]
 E -->|冷凝水| R["冷却循环补水"]
 S["SIN设备汲水"] --> R','S025-01','2023申报稿披露2020–2022全厂混合废水；截图p86。滤清液及浓缩液来源未明确，不臆接RO出水/浓水；2022年1月少量外排','膜过滤类型、膜型号、ED/RO回收率、盐量、能耗、2026现状待核','2026-11-27');
INSERT INTO process_diagram_evidence (evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES ('DE025-01-1','D025-01','W025-01','S025-01','1-1-86','A,B,H','生产废水两级膜；滤清液具体来源未明');
INSERT INTO process_diagram_evidence (evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES ('DE025-01-2','D025-01','W025-02','S025-01','1-1-86','C,D,E,F,G,X','ED浓淡分流及蒸发母液循环');
INSERT INTO process_diagram_evidence (evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES ('DE025-01-3','D025-01','W025-03','S025-01','1-1-86','H,I,J,K,L,M,N,O','综合站流程、能力和纳管');
INSERT INTO process_diagram_evidence (evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES ('DE025-01-4','D025-01','W025-04','S025-01','1-1-86','P,Q','离心液及浓缩液高温焚烧');
INSERT INTO process_diagram_evidence (evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES ('DE025-01-5','D025-01','W025-05','S025-01','1-1-86','E,R,S','冷凝液和SIN水冷却补水');
INSERT INTO membrane_reviews (review_id,site_id,diagram_id,scope_key,stage,period,revision,presence,source_id,evidence_basis,gaps,updated_on) VALUES ('R025-01','CN0119','D025-01','mixed-site-water','historical','2020–2022报告期',1,'confirmed_present','S025-01','2023申报稿披露2020–2022全厂混合废水；截图p86。滤清液及浓缩液来源未明确，不臆接RO出水/浓水；2022年1月少量外排','膜过滤类型、膜型号、ED/RO回收率、盐量、能耗、2026现状待核','2026-11-27');
INSERT INTO membrane_units (unit_id,review_id,unit_label,technology,role,feed,permeate_destination,concentrate_destination,specification,source_id,locator,notes) VALUES ('MU025-01-1','R025-01','二级膜过滤','UNSPECIFIED','生产废水过滤','生产废水',NULL,NULL,'二级；具体膜型未知','S025-01','1-1-86','不推为UF');
INSERT INTO membrane_units (unit_id,review_id,unit_label,technology,role,feed,permeate_destination,concentrate_destination,specification,source_id,locator,notes) VALUES ('MU025-01-2','R025-01','电渗析','ED','树脂再生废水脱盐','树脂再生废水','淡水进入RO','浓盐水蒸发结晶',NULL,'S025-01','1-1-86','已披露历史');
INSERT INTO membrane_units (unit_id,review_id,unit_label,technology,role,feed,permeate_destination,concentrate_destination,specification,source_id,locator,notes) VALUES ('MU025-01-3','R025-01','反渗透','RO','ED淡水后处理','ED淡水',NULL,NULL,NULL,'S025-01','1-1-86','产水/浓水具体去向未知');
INSERT INTO membrane_retrofits (assessment_id,review_id,site_id,scope_key,option_key,revision,objective,proposed_route,feasibility,hard_constraints,evidence_basis,assumptions,missing_inputs,validation_plan,alternatives,feed_risk,pretreatment_risk,concentrate_risk,integration_risk,operational_risk,compliance_economics_risk,score_basis,updated_on) VALUES ('A025-01','R025-01','CN0119','mixed-site-water','screening',1,'分质减量、回用或稳定达标','优先评估现有ED/RO、蒸发及焚烧的能耗和盐分闭合，优化分质及膜回收率；高有机浓缩液保留合规处理','conditional','须核现行状态、进水及浓水合法去向','2023申报稿披露2020–2022全厂混合废水；截图p86。滤清液及浓缩液来源未明确，不臆接RO出水/浓水；2022年1月少量外排','INFERRED工程候选；不将建议视作已建设施','各股日量、盐种、COD、膜型号及回收率、实际能药耗、盐去向','分股采样、盐物料衡算、膜清洗及通量趋势、实际电汽和TO成本比较','原系统运行优化或源头树脂再生减量',NULL,NULL,NULL,NULL,NULL,NULL,'六维资料不足；不以未知判低难度','2026-11-27');
INSERT INTO process_diagrams (diagram_id,site_id,scope_key,stage,period,revision,coverage,mermaid,source_id,boundaries,gaps,updated_on) VALUES ('D025-02','CN0125','production-reuse','historical','历史摘录（年份待核）',1,'partial','flowchart TD
 A["新剂清洗水"] --> B["浓缩（方式待核）"]
 B --> C["混料回用"]
 D["再生酸洗、鼓泡、超声清洗水"] --> E["废水处理（单元待核）"]
 E --> F["喷淋回用"]','turn462160search18','旧W0065历史摘录，2022公示仅证有脱盐装置区和污水站，不证具体连接','旧资料原件未复核；脱盐技术、浓水、各股水量未知','2026-11-27');
INSERT INTO process_diagram_evidence (evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES ('DE025-02-1','D025-02','W0065','turn462160search18','历史摘录','A,B,C,D,E,F','新剂回用和再生废水回喷淋');
INSERT INTO membrane_reviews (review_id,site_id,diagram_id,scope_key,stage,period,revision,presence,source_id,evidence_basis,gaps,updated_on) VALUES ('R025-02','CN0125','D025-02','production-reuse','historical','历史摘录（年份待核）',1,'not_identified','turn462160search18','旧W0065历史摘录，2022公示仅证有脱盐装置区和污水站，不证具体连接','旧资料原件未复核；脱盐技术、浓水、各股水量未知','2026-11-27');
INSERT INTO membrane_retrofits (assessment_id,review_id,site_id,scope_key,option_key,revision,objective,proposed_route,feasibility,hard_constraints,evidence_basis,assumptions,missing_inputs,validation_plan,alternatives,feed_risk,pretreatment_risk,concentrate_risk,integration_risk,operational_risk,compliance_economics_risk,score_basis,updated_on) VALUES ('A025-02','R025-02','CN0125','production-reuse','screening',1,'分质减量、回用或稳定达标','先核现有脱盐装置；评估酸洗水中金属回收和UF保护，盐分累积需要合法排盐；不先假设新装RO','conditional','须核现行状态、进水及浓水合法去向','旧W0065历史摘录，2022公示仅证有脱盐装置区和污水站，不证具体连接','INFERRED工程候选；不将建议视作已建设施','酸洗pH、钒钨、盐种、SS、回用水目标','分流采样、金属与盐衡算及现有脱盐核实','既有回用、物化除固及分质管理',NULL,NULL,NULL,NULL,NULL,NULL,'六维资料不足；不以未知判低难度','2026-11-27');
INSERT INTO process_diagrams (diagram_id,site_id,scope_key,stage,period,revision,coverage,mermaid,source_id,boundaries,gaps,updated_on) VALUES ('D025-03','CN0141','production-reuse','historical','2023年报',1,'partial','flowchart TD
 A["化学水制备含盐废水"] --> B["尾气循环喷淋"]
 B --> C["尾气吸收系统废水"]
 C --> D["沉降"]
 D --> B
 E["空压机/风机轴承冷却排水"] --> F["循环使用"]
 G["过滤零级/一级滤液"] --> H["单独流向待核"]
 I["沉降底料及污泥"] --> J["焙烧水封罐及反应工序回用"]','S025-03','2023年报历史披露，滤液处理栏可能合并，图不强行连接；非当前全厂图','滤液去向、盐累积、真实流量、排放、膜及成本待核；截图超时','2026-11-27');
INSERT INTO process_diagram_evidence (evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES ('DE025-03-1','D025-03','W025-07','S025-03','第27页','A,B,G,H','含盐水喷淋，滤液单独去向待核');
INSERT INTO process_diagram_evidence (evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES ('DE025-03-2','D025-03','W025-08','S025-03','第27页','B,C,D,I,J','吸收水沉降回用及污泥利用');
INSERT INTO process_diagram_evidence (evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES ('DE025-03-3','D025-03','W025-09','S025-03','第27页','E,F','轴承冷却水循环');
INSERT INTO membrane_reviews (review_id,site_id,diagram_id,scope_key,stage,period,revision,presence,source_id,evidence_basis,gaps,updated_on) VALUES ('R025-03','CN0141','D025-03','production-reuse','historical','2023年报',1,'not_identified','S025-03','2023年报历史披露，滤液处理栏可能合并，图不强行连接；非当前全厂图','滤液去向、盐累积、真实流量、排放、膜及成本待核；截图超时','2026-11-27');
INSERT INTO membrane_retrofits (assessment_id,review_id,site_id,scope_key,option_key,revision,objective,proposed_route,feasibility,hard_constraints,evidence_basis,assumptions,missing_inputs,validation_plan,alternatives,feed_risk,pretreatment_risk,concentrate_risk,integration_risk,operational_risk,compliance_economics_risk,score_basis,updated_on) VALUES ('A025-03','R025-03','CN0141','production-reuse','screening',1,'分质减量、回用或稳定达标','现有循环优先，若盐积累限制回用，先核排盐与除固，比较UF/ED或NF；不得推定无膜','conditional','须核现行状态、进水及浓水合法去向','2023年报历史披露，滤液处理栏可能合并，图不强行连接；非当前全厂图','INFERRED工程候选；不将建议视作已建设施','盐和胶体、过滤液真实量、排盐和冷却水目标','循环水物料平衡、过滤及脱盐试验、非膜回用比较','沉降、生产回用及源头减水',NULL,NULL,NULL,NULL,NULL,NULL,'六维资料不足；不以未知判低难度','2026-11-27');
INSERT INTO process_diagrams (diagram_id,site_id,scope_key,stage,period,revision,coverage,mermaid,source_id,boundaries,gaps,updated_on) VALUES ('D025-04','CN0196','saline-discharge','historical','2022年报',1,'partial','flowchart TD
 A["淮河路生产含盐废水"] --> B["处理达标（单元待核）"]
 B --> C["高盐水管道排海"]','S025-04','2022年报仅排放边界；2021升级验收既有记录，不拼接未知处理单元','具体处理、当前许可证执行、流量、盐度、膜未知','2026-11-27');
INSERT INTO process_diagram_evidence (evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES ('DE025-04-1','D025-04','W025-10','S025-04','污染物处理1','A,B,C','历史高盐水去向');
INSERT INTO membrane_reviews (review_id,site_id,diagram_id,scope_key,stage,period,revision,presence,source_id,evidence_basis,gaps,updated_on) VALUES ('R025-04','CN0196','D025-04','saline-discharge','historical','2022年报',1,'not_identified','S025-04','2022年报仅排放边界；2021升级验收既有记录，不拼接未知处理单元','具体处理、当前许可证执行、流量、盐度、膜未知','2026-11-27');
INSERT INTO membrane_retrofits (assessment_id,review_id,site_id,scope_key,option_key,revision,objective,proposed_route,feasibility,hard_constraints,evidence_basis,assumptions,missing_inputs,validation_plan,alternatives,feed_risk,pretreatment_risk,concentrate_risk,integration_risk,operational_risk,compliance_economics_risk,score_basis,updated_on) VALUES ('A025-04','R025-04','CN0196','saline-discharge','screening',1,'分质减量、回用或稳定达标','先核实际高盐管道接收标准及现站，比较膜减量回用与既有合规排放','conditional','须核现行状态、进水及浓水合法去向','2022年报仅排放边界；2021升级验收既有记录，不拼接未知处理单元','INFERRED工程候选；不将建议视作已建设施','TDS、盐种、金属、COD、回用量、合法浓水去向','分股取样、膜与排放路径合规及费用比较','既有处理达标及源头分质',NULL,NULL,NULL,NULL,NULL,NULL,'六维资料不足；不以未知判低难度','2026-11-27');
INSERT INTO process_diagrams (diagram_id,site_id,scope_key,stage,period,revision,coverage,mermaid,source_id,boundaries,gaps,updated_on) VALUES ('D025-05','CN0211','shared-site-water','historical','2023公开环境报告',1,'partial','flowchart TD
 A["载钯洗涤/含油/喷淋/实验及公辅水"] --> B["全厂沉淀"]
 B --> C["气浮"]
 C --> D["活性炭吸附"]
 D --> E["市政管网"]
 E --> F["涧西污水处理厂"]','W03S34','既有W0163证据；全厂共享站非载钯专站，非新增调查','实际金属流股、处理量、膜、现行状态未知','2026-11-27');
INSERT INTO process_diagram_evidence (evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES ('DE025-05-1','D025-05','W0163','W03S34','4.5节既有摘录','A,B,C,D,E,F','共享站处理和纳管');
INSERT INTO membrane_reviews (review_id,site_id,diagram_id,scope_key,stage,period,revision,presence,source_id,evidence_basis,gaps,updated_on) VALUES ('R025-05','CN0211','D025-05','shared-site-water','historical','2023公开环境报告',1,'not_identified','W03S34','既有W0163证据；全厂共享站非载钯专站，非新增调查','实际金属流股、处理量、膜、现行状态未知','2026-11-27');
INSERT INTO membrane_retrofits (assessment_id,review_id,site_id,scope_key,option_key,revision,objective,proposed_route,feasibility,hard_constraints,evidence_basis,assumptions,missing_inputs,validation_plan,alternatives,feed_risk,pretreatment_risk,concentrate_risk,integration_risk,operational_risk,compliance_economics_risk,score_basis,updated_on) VALUES ('A025-05','R025-05','CN0211','shared-site-water','screening',1,'分质减量、回用或稳定达标','先回收钯及去油，评估深度UF/RO回用的必要性','conditional','须核现行状态、进水及浓水合法去向','既有W0163证据；全厂共享站非载钯专站，非新增调查','INFERRED工程候选；不将建议视作已建设施','各股钯、油、COD、盐及实际量','金属回收、除油与膜污染试验，浓水核查','既有沉淀气浮炭吸附，分流金属回收',NULL,NULL,NULL,NULL,NULL,NULL,'六维资料不足；不以未知判低难度','2026-11-27');
INSERT INTO process_diagrams (diagram_id,site_id,scope_key,stage,period,revision,coverage,mermaid,source_id,boundaries,gaps,updated_on) VALUES ('D025-06','CN0207','shared-site-design','design','2026环评转载',1,'partial','flowchart TD
 A["全厂综合废水（催化材料分股待核）"] --> B["共享站 6000t/d"]
 B --> C["UASB"]
 C --> D["水解"]
 D --> E["A/O"]
 E --> F["沉淀"]
 F --> G["出水去向待核"]','W03S29','旧W0162环评转载设计，6000t/d为全厂共享站，不是催化剂处理量','环评原文、实际站、分股、出水去向及膜待核','2026-11-27');
INSERT INTO process_diagram_evidence (evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES ('DE025-06-1','D025-06','W0162','W03S29','既有环评转载','A,B,C,D,E,F,G','共享站能力和序列');
INSERT INTO membrane_reviews (review_id,site_id,diagram_id,scope_key,stage,period,revision,presence,source_id,evidence_basis,gaps,updated_on) VALUES ('R025-06','CN0207','D025-06','shared-site-design','design','2026环评转载',1,'not_identified','W03S29','旧W0162环评转载设计，6000t/d为全厂共享站，不是催化剂处理量','环评原文、实际站、分股、出水去向及膜待核','2026-11-27');
INSERT INTO membrane_retrofits (assessment_id,review_id,site_id,scope_key,option_key,revision,objective,proposed_route,feasibility,hard_constraints,evidence_basis,assumptions,missing_inputs,validation_plan,alternatives,feed_risk,pretreatment_risk,concentrate_risk,integration_risk,operational_risk,compliance_economics_risk,score_basis,updated_on) VALUES ('A025-06','R025-06','CN0207','shared-site-design','screening',1,'分质减量、回用或稳定达标','有机高浓分股先回收或厌氧处理；生化出水视回用需求测试UF/RO','conditional','须核现行状态、进水及浓水合法去向','旧W0162环评转载设计，6000t/d为全厂共享站，不是催化剂处理量','INFERRED工程候选；不将建议视作已建设施','催化剂单独分流水量、盐/COD、毒性、共享站及浓水','进水及生化出水样、膜污染与经济比较','原设计共享站、源头分质',NULL,NULL,NULL,NULL,NULL,NULL,'六维资料不足；不以未知判低难度','2026-11-27');
INSERT INTO search_log (log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES ('L025-01','CN0119','W01-B15/W11-B16','华茂伟业 绿色科技 污水处理 反渗透 蒸发 环评','S025-01','取得不同版本2023年3月正式申报稿并截图；原摘要的膜与分流缺口获得明确证据','现行许可、实际流量、膜型号及成本','2026-11-27');
INSERT INTO search_log (log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES ('L025-02','CN0125','W01-B15/W11-B16','安徽元琛 环保 招股说明书 废水 浓缩 膜 再生','S025-02','企业清洁生产公示6项浓度及年量、池容；早期招股书搜索摘录未获完整表，不重复旧流程','脱盐装置技术及实际回用量','2026-11-27');
INSERT INTO search_log (log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES ('L025-03','CN0141','W01-B15/W11-B16','山西腾茂 科技 催化剂 废水 污水 2025 年报','S025-03','2023年报补分流与设计产能；2025摘要无污水细节；2023 PDF截图超时','按2025/26报告、许可及滤液去向查','2026-11-27');
INSERT INTO search_log (log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES ('L025-04','CN0196','W01-B15/W11-B16','青岛惠城 淮河路 污水处理升级 竣工 验收 反渗透','S025-04','2024年报已入库不重复；2022年报新增高盐管道排海；未取得升级验收工艺','按91370200783724899J001C及青环黄审2017-373查','2026-11-27');
UPDATE sites SET water_summary='2023招股披露历史：生产二级膜过滤、树脂再生ED脱盐/蒸发结晶/RO；综合站80m³/d，TO10t/d；2022年1月少量纳管；现行及实际流量待核',source_status='上市披露原文及截图补证' WHERE site_id='CN0119';
UPDATE sites SET water_summary=water_summary||'；2022公示6项浓度及年量、216m³事故池、脱盐装置区，膜型未知' WHERE site_id='CN0125';
UPDATE sites SET water_summary=water_summary||'；2023年报复核含盐水喷淋、吸收水沉降循环、冷却回用；2023设计4万吨/年，利用率90%' WHERE site_id='CN0141';
UPDATE sites SET water_summary=water_summary||'；2022年报历史含盐水处理后经高盐管道排海' WHERE site_id='CN0196';
UPDATE tasks SET missing='2026现行膜型号、实际分股水量、盐去向、成本',next_query='按沧州临港排污许可、设备运维和膜采购',state='部分完成' WHERE site_id='CN0119';
UPDATE tasks SET missing='实际脱盐技术、回用量、工艺与费用',next_query='按西淝河路清洁生产及脱盐装置采购',state='部分完成' WHERE site_id='CN0125';
UPDATE tasks SET missing='现行滤液去向、水量、膜和成本',next_query='2025/26年报及排污许可，查循环排盐',state='部分完成' WHERE site_id='CN0141';
UPDATE tasks SET missing='2021升级验收工艺、2026实测水量、膜',next_query='按91370200783724899J001C和青环黄审2017-373',state='部分完成' WHERE site_id='CN0196';
CREATE TABLE task_triage(site_id TEXT PRIMARY KEY REFERENCES sites(site_id),disposition TEXT NOT NULL CHECK(disposition IN ('scope_hold','weak_identity_hold','stalled_hold')),reason TEXT NOT NULL,reopen_trigger TEXT NOT NULL,reviewed_on TEXT NOT NULL);
INSERT INTO task_triage VALUES ('CN0008','scope_hold','集团/潜在重复、销售或退出主体；不独立计厂级污水任务，保留身份与历史','明确独立物理生产厂区、独立生产证据或恢复生产','2026-11-27');
INSERT INTO task_triage VALUES ('CN0074','scope_hold','集团/潜在重复、销售或退出主体；不独立计厂级污水任务，保留身份与历史','明确独立物理生产厂区、独立生产证据或恢复生产','2026-11-27');
INSERT INTO task_triage VALUES ('CN0075','scope_hold','集团/潜在重复、销售或退出主体；不独立计厂级污水任务，保留身份与历史','明确独立物理生产厂区、独立生产证据或恢复生产','2026-11-27');
INSERT INTO task_triage VALUES ('CN0091','scope_hold','集团/潜在重复、销售或退出主体；不独立计厂级污水任务，保留身份与历史','明确独立物理生产厂区、独立生产证据或恢复生产','2026-11-27');
INSERT INTO task_triage VALUES ('CN0096','scope_hold','集团/潜在重复、销售或退出主体；不独立计厂级污水任务，保留身份与历史','明确独立物理生产厂区、独立生产证据或恢复生产','2026-11-27');
INSERT INTO task_triage VALUES ('CN0150','scope_hold','集团/潜在重复、销售或退出主体；不独立计厂级污水任务，保留身份与历史','明确独立物理生产厂区、独立生产证据或恢复生产','2026-11-27');
INSERT INTO task_triage VALUES ('CN0167','scope_hold','集团/潜在重复、销售或退出主体；不独立计厂级污水任务，保留身份与历史','明确独立物理生产厂区、独立生产证据或恢复生产','2026-11-27');
INSERT INTO task_triage VALUES ('CN0188','scope_hold','集团/潜在重复、销售或退出主体；不独立计厂级污水任务，保留身份与历史','明确独立物理生产厂区、独立生产证据或恢复生产','2026-11-27');
INSERT INTO task_triage VALUES ('CN0053','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0054','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0055','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0056','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0105','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0107','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0112','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0113','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0123','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0126','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0128','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0136','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0148','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0149','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0151','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0152','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0153','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0155','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0160','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0161','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0163','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0165','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0168','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0169','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0171','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0172','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0177','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0178','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0179','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0180','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0181','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0182','weak_identity_hold','旧名录、身份或独立制造证据薄弱，可能仅封装/销售/研发；未充分检索者不称多次失败','新环评/许可、具体厂址及制造产品、独立产能证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0023','stalled_hold','旧日志反复未取得可归属本厂的新增水处理细节；高价值厂也暂不重复通用检索','新验收、许可执行、实际厂区污水设备采购、独立园区原文或其他实质性新证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0024','stalled_hold','旧日志反复未取得可归属本厂的新增水处理细节；高价值厂也暂不重复通用检索','新验收、许可执行、实际厂区污水设备采购、独立园区原文或其他实质性新证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0029','stalled_hold','旧日志反复未取得可归属本厂的新增水处理细节；高价值厂也暂不重复通用检索','新验收、许可执行、实际厂区污水设备采购、独立园区原文或其他实质性新证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0033','stalled_hold','旧日志反复未取得可归属本厂的新增水处理细节；高价值厂也暂不重复通用检索','新验收、许可执行、实际厂区污水设备采购、独立园区原文或其他实质性新证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0034','stalled_hold','旧日志反复未取得可归属本厂的新增水处理细节；高价值厂也暂不重复通用检索','新验收、许可执行、实际厂区污水设备采购、独立园区原文或其他实质性新证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0079','stalled_hold','旧日志反复未取得可归属本厂的新增水处理细节；高价值厂也暂不重复通用检索','新验收、许可执行、实际厂区污水设备采购、独立园区原文或其他实质性新证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0097','stalled_hold','旧日志反复未取得可归属本厂的新增水处理细节；高价值厂也暂不重复通用检索','新验收、许可执行、实际厂区污水设备采购、独立园区原文或其他实质性新证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0101','stalled_hold','旧日志反复未取得可归属本厂的新增水处理细节；高价值厂也暂不重复通用检索','新验收、许可执行、实际厂区污水设备采购、独立园区原文或其他实质性新证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0142','stalled_hold','旧日志反复未取得可归属本厂的新增水处理细节；高价值厂也暂不重复通用检索','新验收、许可执行、实际厂区污水设备采购、独立园区原文或其他实质性新证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0088','stalled_hold','旧日志反复未取得可归属本厂的新增水处理细节；高价值厂也暂不重复通用检索','新验收、许可执行、实际厂区污水设备采购、独立园区原文或其他实质性新证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0111','stalled_hold','旧日志反复未取得可归属本厂的新增水处理细节；高价值厂也暂不重复通用检索','新验收、许可执行、实际厂区污水设备采购、独立园区原文或其他实质性新证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0039','stalled_hold','旧日志反复未取得可归属本厂的新增水处理细节；高价值厂也暂不重复通用检索','新验收、许可执行、实际厂区污水设备采购、独立园区原文或其他实质性新证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0157','stalled_hold','旧日志反复未取得可归属本厂的新增水处理细节；高价值厂也暂不重复通用检索','新验收、许可执行、实际厂区污水设备采购、独立园区原文或其他实质性新证据','2026-11-27');
INSERT INTO task_triage VALUES ('CN0159','stalled_hold','旧日志反复未取得可归属本厂的新增水处理细节；高价值厂也暂不重复通用检索','新验收、许可执行、实际厂区污水设备采购、独立园区原文或其他实质性新证据','2026-11-27');
CREATE VIEW v_actionable_research_tasks AS SELECT t.*,s.name,s.record_type,s.water_level,q.diagram_count,COALESCE(x.disposition,CASE WHEN q.diagram_count=0 THEN 'active_first_diagram' ELSE 'active_depth' END) AS disposition,x.reason AS hold_reason,x.reopen_trigger FROM tasks t JOIN sites s USING(site_id) JOIN v_process_membrane_queue q USING(site_id) LEFT JOIN task_triage x USING(site_id);
CREATE VIEW v_actionable_research_counts AS SELECT disposition,count(*) AS task_count FROM v_actionable_research_tasks GROUP BY disposition;
CREATE TEMP TABLE assert025(ok INTEGER CHECK(ok=1));
INSERT INTO assert025 SELECT count(*)=0 FROM pragma_foreign_key_check;
INSERT INTO assert025 SELECT count(*)=54 FROM task_triage;
INSERT INTO assert025 SELECT count(*)=53 FROM v_actionable_research_tasks WHERE disposition LIKE '%hold';
INSERT INTO assert025 SELECT count(*)=201 FROM v_actionable_research_tasks WHERE disposition LIKE 'active%';
DROP TABLE assert025;
COMMIT;
