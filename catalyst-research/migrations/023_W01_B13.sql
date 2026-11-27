-- 023: 两个新制造项目及批量证据图补齐
BEGIN;
INSERT INTO sites VALUES('CN0253','南通泰禾化工股份有限公司IPN催化剂装置','江苏','南通','如东县洋口化学工业园西区','IPN催化剂/新材料配套','12t/a已建装置；150t/a拟替换，二期单独环评','厂区/项目','12t/a既有设计；150t/a改扩建拟替换','拟车间化学还原混凝沉淀去铬后进共享污水站','有工艺线索','P1',NULL,'企业环评与政府批复','2026-11-27','150与12不相加；一期批复排除150吨催化剂，不能当已批或在产');
INSERT INTO sources VALUES('S023-001','南通泰禾年产150吨IPN催化剂项目环境影响报告书（送审稿）','https://www.cacch.com/ueditor/php/upload/file/20251208/1765174078278584.pdf','企业公开环评','2025-12','1.1、1.2、3.4.5.2及图3.4-4；旧装置、改扩建和既有共享站','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0253','S023-001');
INSERT INTO sources VALUES('S023-002','江苏省生态环境厅南通泰禾改扩建一期批复','https://sthjt.jiangsu.gov.cn/art/2026/10/14/art_83568_11841917.html','政府批复','2026-10-14','一期排除150吨IPN催化剂项目，另行环评；保留12吨口径','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0253','S023-002');
INSERT INTO capacity VALUES('C023-001','CN0253','IPN催化剂',12,'t/a','既有设计；一期批复保留','2026','装置','S023-002','不是实际产量');
INSERT INTO capacity VALUES('C023-002','CN0253','IPN催化剂',150,'t/a','拟拆旧建新，二期另评','2025-12','项目','S023-001','不得与12叠加');
INSERT INTO projects VALUES('P023-001','CN0253','150吨IPN催化剂替换扩建','2025送审；2026一期排除，二期待核','2026','150t/a','新增车间去铬设施；共享污水站','S023-002');
INSERT INTO tasks VALUES('T023-001','CN0253','P1','二期审批与投运、实际产能、分股水量、铬去除实测、成本','泰禾IPN二期批复及许可、车间验收','部分完成');
INSERT OR IGNORE INTO site_sources VALUES('CN0253','S023-001');
INSERT INTO wastewater VALUES('W023-001','CN0253','150t/a拟建车间含铬废水','2025送审设计',NULL,NULL,NULL,'总铬、六价铬','化学还原→混凝沉淀','厂区共享污水站',NULL,'S023-001','WEB_PRIMARY','1.2；车间新增设施，未证实投运；分股量待核');
INSERT OR IGNORE INTO site_sources VALUES('CN0253','S023-001');
INSERT INTO wastewater VALUES('W023-002','CN0253','现有厂区共享物化系统','2025环评既有',400,'m³/d','共享设计能力','高浓有机废水','芬顿氧化→混凝絮凝→初沉','共享生化',NULL,'S023-001','WEB_PRIMARY','3.4.5.2；不是催化剂车间专属能力');
INSERT OR IGNORE INTO site_sources VALUES('CN0253','S023-001');
INSERT INTO wastewater VALUES('W023-003','CN0253','现有厂区共享生化系统','2025环评既有',1200,'m³/d','共享设计能力','综合废水','调节→水解酸化→UASB→A/O→斜管沉淀→A/O→混凝沉淀→二沉','达标纳管','污泥浓缩压滤委外','S023-001','WEB_PRIMARY','图3.4-4；高浓经物化汇入，低浓直接汇入');
INSERT OR IGNORE INTO site_sources VALUES('CN0253','S023-001');
INSERT INTO evidence_notes VALUES('N023-001','CN0253','S023-001','建设边界','1.1及1.2','旧12t/a装置拟拆除后原厂房建150t/a；催化剂用于间苯二甲胺及1,3-BAC配套，不得将主产品及整体项目20493.96万元投资当作单独催化剂投资。','WEB_PRIMARY','关键内容提取；来源见索引','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0253','S023-002');
INSERT INTO claims VALUES('CL023-001','CN0253','审批边界','2026-10-14一期批复明确150吨IPN催化剂不在本次批准范围，二期另评','WEB_PRIMARY','S023-002','一期建成后仍列12t/a','2026-11-27');
INSERT INTO process_diagrams VALUES('D023-001','CN0253','ipn_150_design','design','2025-12送审',1,'partial','flowchart TD
 A[含铬车间废水] --> B[化学还原] --> C[混凝沉淀] --> D[厂区共享污水站]','S023-001','仅150吨扩建设计；二期审批及实际建设待核','铬源强、分股量、沉渣去向、二期许可','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0253','S023-001');
INSERT OR IGNORE INTO site_sources VALUES('CN0253','S023-001');
INSERT INTO process_diagram_evidence VALUES('DE023-001','D023-001','W023-001','S023-001','1.2','A,B,C,D','证据对应节点或边；未知不补');
INSERT INTO membrane_reviews VALUES('MR023-001','CN0253','D023-001','ipn_150_design','design','2025-12送审',1,'not_identified','S023-001','仅150吨扩建设计；二期审批及实际建设待核','铬源强、分股量、沉渣去向、二期许可','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA023-001','MR023-001','CN0253','ipn_150_design','screening',1,'分质回用、既有系统优化及减量','先保证铬还原沉淀与分质；有回用需求时筛选后续膜，不将共享站当专线','conditional','需核实际水质、运行及合法浓水/残余物去向','INFERRED；D023-001及对应来源','仅对应历史/设计或报告期范围','实测Cr价态、盐分、COD、流量、残渣与回用目标','核现场、连续取样、水盐衡算；评膜污染、清洗、回用需求和总成本','源头回用、非膜及原工艺优化',NULL,NULL,NULL,NULL,NULL,NULL,'实际参数不足，不评级','2026-11-27');
INSERT INTO process_diagrams VALUES('D023-002','CN0253','shared_station_2025','historical','2025报告所述既有',1,'partial','flowchart TD
 A[高浓废水] --> B[芬顿氧化] --> C[混凝絮凝与初沉] --> D[调节池]
 E[低浓废水] --> D
 D --> F[水解酸化] --> G[UASB] --> H[A/O] --> I[斜管沉淀] --> J[A/O] --> K[混凝沉淀] --> L[二沉] --> M[尾水与达标排放]','S023-001','全厂共享设施，400与1200m³/d不可相加；非IPN专用','具体催化剂接入位置和运行量','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0253','S023-001');
INSERT OR IGNORE INTO site_sources VALUES('CN0253','S023-001');
INSERT INTO process_diagram_evidence VALUES('DE023-002','D023-002','W023-002','S023-001','3.4.5.2图3.4-4','A,B,C,D','证据对应节点或边；未知不补');
INSERT OR IGNORE INTO site_sources VALUES('CN0253','S023-001');
INSERT INTO process_diagram_evidence VALUES('DE023-003','D023-002','W023-003','S023-001','3.4.5.2图3.4-4','D,E,F,G,H,I,J,K,L,M','证据对应节点或边；未知不补');
INSERT INTO membrane_reviews VALUES('MR023-002','CN0253','D023-002','shared_station_2025','historical','2025报告所述既有',1,'not_identified','S023-001','全厂共享设施，400与1200m³/d不可相加；非IPN专用','具体催化剂接入位置和运行量','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA023-002','MR023-002','CN0253','shared_station_2025','screening',1,'分质回用、既有系统优化及减量','先核分质和现有生化负荷，再筛选末端回用膜','conditional','需核实际水质、运行及合法浓水/残余物去向','INFERRED；D023-002及对应来源','仅对应历史/设计或报告期范围','共享站实际水质水量、污泥、回用要求','核现场、连续取样、水盐衡算；评膜污染、清洗、回用需求和总成本','源头回用、非膜及原工艺优化',NULL,NULL,NULL,NULL,NULL,NULL,'实际参数不足，不评级','2026-11-27');
INSERT INTO search_log VALUES('L023-001','CN0253','W01-B13/W11-B14','泰禾 IPN 催化剂 含铬废水 150吨 环评','S023-001','取得车间及共享站路线；另核一期批复不含150吨','二期单独批复、实际流量与铬','2026-11-27');
INSERT INTO sites VALUES('CN0254','山东尚正新材料科技股份有限公司催化剂中试','山东','淄博','桓台马桥化工产业园','自制/绿色有机与DMC','2024获批；后续技改环评列在建未验收','项目','绿色有机2t/a；DMC2t/a中试','绿色有机压滤水电化学原位产酸与电芬顿；共享生化','有工艺线索','P1',NULL,'政府公开环评','2026-11-27','中试自用不外售，不计已确认在产产能；混合中试水量不等于催化剂水量');
INSERT INTO sources VALUES('S023-003','山东尚正可降解新材料、特种胺及催化剂中试项目环评','https://epb.zibo.gov.cn/gongkai/channel_c_5f9fa491ab327f36e4c13066_n_1605682663.2363/doc_65dc3fde352d28845055db10_fd1d4299226026196ba902070af1da37.pdf','政府公开环评','2024','4.8.2.2与表4.8.2-2至8；分质水量、设计水质、处理系统','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0254','S023-003');
INSERT INTO sources VALUES('S023-004','山东尚正10万吨聚氨酯及配套产品技改环评','https://epb.zibo.gov.cn/gongkai/channel_c_5f9fa491ab327f36e4c13066_n_1605682663.2363/doc_69391b3d9fc11bd813c32d94_2d207590775c649d70452b0f0006a3ba.pdf','政府公开环评',NULL,'2-4页现有及在建项目表，淄环审[2024]9号，未验收/在建','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0254','S023-004');
INSERT INTO sources VALUES('S023-005','山东尚正900吨特种胺及下游新材料中试环评','https://epb.zibo.gov.cn/gongkai/channel_c_5f9fa491ab327f36e4c13066_n_1605682663.2363/doc_68302d3a8940ec8b687179f1_99fc2d25bb305457fded289fff68add8.pdf','政府公开环评','2025','表3.1-3 两类催化剂中试规模及自用范围','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0254','S023-005');
INSERT INTO capacity VALUES('C023-003','CN0254','绿色有机催化剂',2,'t/a','中试批准规模','2024','项目','S023-005','用于集团下游试验，不外售；非实际产量');
INSERT INTO capacity VALUES('C023-004','CN0254','DMC双金属氰化物络合催化剂',2,'t/a','中试批准规模','2024','项目','S023-005','用于集团下游试验，不外售；非实际产量');
INSERT INTO projects VALUES('P023-002','CN0254','可降解新材料、特种胺及催化剂中试','2024-03-19批复；后续环评列在建未验收','2024','绿色有机2t/a、DMC2t/a','依托共享站，绿色有机压滤水电芬顿预处理','S023-004');
INSERT INTO tasks VALUES('T023-002','CN0254','P1','投运验收、DMC独立废水、实际流量水质、膜适用性','尚正中试验收、废水许可及正坤厂区关系','部分完成');
INSERT OR IGNORE INTO site_sources VALUES('CN0254','S023-003');
INSERT INTO wastewater VALUES('W023-004','CN0254','绿色有机催化剂W3-1压滤废水','2024环评设计',3.583,'m³/a','单股产生及预处理后水量','COD、SS、TN、TP、间二甲苯、全盐量','调节池2→电化学原位产酸（内循环）→电芬顿','共享综合生化',NULL,'S023-003','WEB_PRIMARY','表4.8.2-5；设计估算非实际；电芬顿非膜');
INSERT OR IGNORE INTO site_sources VALUES('CN0254','S023-003');
INSERT INTO wastewater VALUES('W023-005','CN0254','混合中试项目进入综合站废水','2024环评设计',1018.943,'m³/a','项目综合站处理水量','COD、氨氮、TN、TP、SS、盐','pH调节絮凝沉淀→综合调节→水解酸化→配水→PRO-UASB→厌氧沉淀→两级A/O→二沉','桓台马桥化工产业园污水处理厂',NULL,'S023-003','WEB_PRIMARY','表4.8.2-6；含其他中试产品，非催化剂专属');
INSERT OR IGNORE INTO site_sources VALUES('CN0254','S023-003');
INSERT INTO wastewater VALUES('W023-006','CN0254','中试项目总排口','2024环评设计',5033.703,'m³/a','综合站加纯水站及循环水排水','COD、氮、磷、盐','分流汇合纳管','桓台马桥化工产业园污水处理厂',NULL,'S023-003','WEB_PRIMARY','表4.8.2-7；含3726.76m³/a纯水站排水及288m³/a循环水排水，避免重加');
INSERT OR IGNORE INTO site_sources VALUES('CN0254','S023-003');
INSERT INTO wastewater VALUES('W023-007','CN0254','厂区共享综合污水站','2024环评设计',800,'m³/d','设计处理能力','综合废水','预处理分流加综合生化','园区污水厂',NULL,'S023-003','WEB_PRIMARY','4.8.2.2；电芬顿能力450m³/d为其中单元，不可相加');
INSERT INTO water_metrics VALUES('M023-001','CN0254','W023-004','W3-1预处理进水','COD',26031,NULL,'mg/L','环评设计浓度',NULL,'2024',NULL,NULL,'S023-003','表4.8.2-5');
INSERT INTO water_metrics VALUES('M023-002','CN0254','W023-004','W3-1预处理出水','COD',20824.8,NULL,'mg/L','环评设计浓度',NULL,'2024',NULL,NULL,'S023-003','表4.8.2-5；非实测');
INSERT INTO water_metrics VALUES('M023-003','CN0254','W023-004','W3-1预处理进水','SS',2233,NULL,'mg/L','环评设计浓度',NULL,'2024',NULL,NULL,'S023-003','表4.8.2-5');
INSERT INTO water_metrics VALUES('M023-004','CN0254','W023-004','W3-1预处理出水','SS',2233,NULL,'mg/L','环评设计浓度',NULL,'2024',NULL,NULL,'S023-003','表4.8.2-5；非实测');
INSERT INTO water_metrics VALUES('M023-005','CN0254','W023-004','W3-1预处理进水','TN',1999,NULL,'mg/L','环评设计浓度',NULL,'2024',NULL,NULL,'S023-003','表4.8.2-5');
INSERT INTO water_metrics VALUES('M023-006','CN0254','W023-004','W3-1预处理出水','TN',1999,NULL,'mg/L','环评设计浓度',NULL,'2024',NULL,NULL,'S023-003','表4.8.2-5；非实测');
INSERT INTO water_metrics VALUES('M023-007','CN0254','W023-004','W3-1预处理进水','TP',1196,NULL,'mg/L','环评设计浓度',NULL,'2024',NULL,NULL,'S023-003','表4.8.2-5');
INSERT INTO water_metrics VALUES('M023-008','CN0254','W023-004','W3-1预处理出水','TP',1196,NULL,'mg/L','环评设计浓度',NULL,'2024',NULL,NULL,'S023-003','表4.8.2-5；非实测');
INSERT INTO water_metrics VALUES('M023-009','CN0254','W023-004','W3-1预处理进水','间二甲苯',2791,NULL,'mg/L','环评设计浓度',NULL,'2024',NULL,NULL,'S023-003','表4.8.2-5');
INSERT INTO water_metrics VALUES('M023-010','CN0254','W023-004','W3-1预处理出水','间二甲苯',279.1,NULL,'mg/L','环评设计浓度',NULL,'2024',NULL,NULL,'S023-003','表4.8.2-5；非实测');
INSERT INTO water_metrics VALUES('M023-011','CN0254','W023-004','W3-1预处理进水','全盐量',5303,NULL,'mg/L','环评设计浓度',NULL,'2024',NULL,NULL,'S023-003','表4.8.2-5');
INSERT INTO water_metrics VALUES('M023-012','CN0254','W023-004','W3-1预处理出水','全盐量',5303,NULL,'mg/L','环评设计浓度',NULL,'2024',NULL,NULL,'S023-003','表4.8.2-5；非实测');
INSERT INTO water_metrics VALUES('M023-013','CN0254','W023-005','综合站混合中试进水','COD',1839.6,NULL,'mg/L','环评预测浓度',NULL,'2024',NULL,NULL,'S023-003','表4.8.2-6；含其他产品');
INSERT INTO water_metrics VALUES('M023-014','CN0254','W023-005','综合站混合中试出水','COD',91.98,NULL,'mg/L','环评预测浓度',NULL,'2024',NULL,500,'S023-003','表4.8.2-6；非实测');
INSERT INTO water_metrics VALUES('M023-015','CN0254','W023-005','综合站混合中试进水','氨氮',31.7,NULL,'mg/L','环评预测浓度',NULL,'2024',NULL,NULL,'S023-003','表4.8.2-6；含其他产品');
INSERT INTO water_metrics VALUES('M023-016','CN0254','W023-005','综合站混合中试出水','氨氮',9.51,NULL,'mg/L','环评预测浓度',NULL,'2024',NULL,45,'S023-003','表4.8.2-6；非实测');
INSERT INTO water_metrics VALUES('M023-017','CN0254','W023-005','综合站混合中试进水','TN',49.8,NULL,'mg/L','环评预测浓度',NULL,'2024',NULL,NULL,'S023-003','表4.8.2-6；含其他产品');
INSERT INTO water_metrics VALUES('M023-018','CN0254','W023-005','综合站混合中试出水','TN',14.93,NULL,'mg/L','环评预测浓度',NULL,'2024',NULL,70,'S023-003','表4.8.2-6；非实测');
INSERT INTO water_metrics VALUES('M023-019','CN0254','W023-005','综合站混合中试进水','TP',8.1,NULL,'mg/L','环评预测浓度',NULL,'2024',NULL,NULL,'S023-003','表4.8.2-6；含其他产品');
INSERT INTO water_metrics VALUES('M023-020','CN0254','W023-005','综合站混合中试出水','TP',4.07,NULL,'mg/L','环评预测浓度',NULL,'2024',NULL,8,'S023-003','表4.8.2-6；非实测');
INSERT INTO water_metrics VALUES('M023-021','CN0254','W023-005','综合站混合中试进水','SS',302.3,NULL,'mg/L','环评预测浓度',NULL,'2024',NULL,NULL,'S023-003','表4.8.2-6；含其他产品');
INSERT INTO water_metrics VALUES('M023-022','CN0254','W023-005','综合站混合中试出水','SS',120.91,NULL,'mg/L','环评预测浓度',NULL,'2024',NULL,400,'S023-003','表4.8.2-6；非实测');
INSERT INTO water_metrics VALUES('M023-023','CN0254','W023-005','综合站混合中试进水','全盐量',779.2,NULL,'mg/L','环评预测浓度',NULL,'2024',NULL,NULL,'S023-003','表4.8.2-6；含其他产品');
INSERT INTO water_metrics VALUES('M023-024','CN0254','W023-005','综合站混合中试出水','全盐量',701.31,NULL,'mg/L','环评预测浓度',NULL,'2024',NULL,1600,'S023-003','表4.8.2-6；非实测');
INSERT INTO water_metrics VALUES('M023-025','CN0254','W023-007','电芬顿单元','设计处理能力',450,NULL,'m³/d','环评设计',NULL,'2024',NULL,NULL,'S023-003','共享预处理，非专线');
INSERT INTO water_metrics VALUES('M023-026','CN0254','W023-006','中试项目总排口','COD',172.44,NULL,'mg/L','环评预测浓度',NULL,'2024',NULL,500,'S023-003','表4.8.2-7');
INSERT INTO water_metrics VALUES('M023-027','CN0254','W023-006','中试项目总排口','全盐量',1560.51,NULL,'mg/L','环评预测浓度',NULL,'2024',NULL,1600,'S023-003','表4.8.2-7');
INSERT OR IGNORE INTO site_sources VALUES('CN0254','S023-003');
INSERT INTO evidence_notes VALUES('N023-002','CN0254','S023-003','设计水质区别','表4.8.2-5至7','3.583m³/a是单股压滤废水；1018.943m³/a是混合中试项目处理量；5033.703m³/a含公用工程；800m³/d与450m³/d为共享设施及单元能力。电化学原位产酸和电芬顿没有膜型证据，不标电渗析。表4.8.2-6间二甲苯后段存在数值口径疑点，未结构化该段。','WEB_PRIMARY','关键内容提取；来源见索引','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0254','S023-004');
INSERT INTO claims VALUES('CL023-002','CN0254','项目状态','淄环审[2024]9号（2024-03-19）；后续技改报告列在建未验收','WEB_PRIMARY','S023-004','报告时点，非现行验收','2026-11-27');
INSERT INTO process_diagrams VALUES('D023-003','CN0254','green_pilot_design','design','2024环评',1,'partial','flowchart TD
 A[绿色有机压滤水] --> B[调节池2] --> C[电化学原位产酸内循环] --> D[电芬顿] --> E[共享综合处理]
 F[其他中试废水] --> E
 E --> G[pH调节絮凝沉淀] --> H[综合调节水解酸化配水] --> I[PRO-UASB及厌氧沉淀] --> J[两级A/O及二沉] --> K[汇合纳管]
 L[纯水站及循环水排水] --> K','S023-003','3.583m³/a单股，其他均共享；未验收报告不等同现行实际','DMC水、现场水量、盐、排放与成本','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0254','S023-003');
INSERT OR IGNORE INTO site_sources VALUES('CN0254','S023-003');
INSERT INTO process_diagram_evidence VALUES('DE023-004','D023-003','W023-004','S023-003','4.8.2.2与表4.8.2-5','A,B,C,D,E','证据对应节点或边；未知不补');
INSERT OR IGNORE INTO site_sources VALUES('CN0254','S023-003');
INSERT INTO process_diagram_evidence VALUES('DE023-005','D023-003','W023-005','S023-003','表4.8.2-6','F,E,G,H,I,J,K','证据对应节点或边；未知不补');
INSERT OR IGNORE INTO site_sources VALUES('CN0254','S023-003');
INSERT INTO process_diagram_evidence VALUES('DE023-006','D023-003','W023-006','S023-003','表4.8.2-7','K,L','证据对应节点或边；未知不补');
INSERT INTO membrane_reviews VALUES('MR023-003','CN0254','D023-003','green_pilot_design','design','2024环评',1,'not_identified','S023-003','3.583m³/a单股，其他均共享；未验收报告不等同现行实际','DMC水、现场水量、盐、排放与成本','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA023-003','MR023-003','CN0254','green_pilot_design','screening',1,'分质回用、既有系统优化及减量','保留高COD高盐分股；电芬顿与生化先核实际效率，有明确回用需求再测试膜','conditional','需核实际水质、运行及合法浓水/残余物去向','INFERRED；D023-003及对应来源','仅对应历史/设计或报告期范围','实际水质、毒性、流量、膜试验、浓水去向和成本','核现场、连续取样、水盐衡算；评膜污染、清洗、回用需求和总成本','源头回用、非膜及原工艺优化',NULL,NULL,NULL,NULL,NULL,NULL,'实际参数不足，不评级','2026-11-27');
INSERT INTO search_log VALUES('L023-002','CN0254','W01-B13/W11-B14','尚正绿色有机催化剂 中试 电芬顿','S023-003','新增分股、共享能力、设计浓度及中试状态','验收、DMC水、实际成本','2026-11-27');
INSERT INTO process_diagrams VALUES('D023-004','CN0175','2020_expansion_design','design','2020环评',1,'partial','flowchart TD
 A[扩建后厂区废水] --> B[自建污水站 具体流程未知] --> C[淄博南岳水务]
 D[铝酸钠废液] --> E[资源化]','W01B2S17','2020设计；不补2026安全审查项目路线','站内流程、实际量、铝酸钠回收边界','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0175','W01B2S17');
INSERT OR IGNORE INTO site_sources VALUES('CN0175','W01B2S17');
INSERT INTO process_diagram_evidence VALUES('DE023-007','D023-004','W0127','W01B2S17','已有2020公示废水摘录','A,B,C,D,E','证据对应节点或边；未知不补');
INSERT INTO membrane_reviews VALUES('MR023-004','CN0175','D023-004','2020_expansion_design','design','2020环评',1,'not_identified','W01B2S17','2020设计；不补2026安全审查项目路线','站内流程、实际量、铝酸钠回收边界','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA023-004','MR023-004','CN0175','2020_expansion_design','screening',1,'分质回用、既有系统优化及减量','先查铝酸钠分流与站内实际工艺；明确含镍等水质后再试回用','conditional','需核实际水质、运行及合法浓水/残余物去向','INFERRED；D023-004及对应来源','仅对应历史/设计或报告期范围','实际流量、金属、盐、现行站、回用','核现场、连续取样、水盐衡算；评膜污染、清洗、回用需求和总成本','源头回用、非膜及原工艺优化',NULL,NULL,NULL,NULL,NULL,NULL,'实际参数不足，不评级','2026-11-27');
INSERT INTO process_diagrams VALUES('D023-005','CN0222','yimen_2015_design','design','2015环评',1,'partial','flowchart TD
 A[钯活化滤液 钯黑洗水 两级碱吸收液 真空机组水 钌洗水] --> B[分类收集] --> C[蒸发] --> D[浓盐液委外回收]
 E[纯水浓水] --> F[雨水系统]
 G[生活水] --> H[依托绿化回用]','W06S04','易门历史设计；非安宁新厂及资源回收主体','是否实施、实际量、蒸发条件和浓盐液接收','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0222','W06S04');
INSERT OR IGNORE INTO site_sources VALUES('CN0222','W06S04');
INSERT INTO process_diagram_evidence VALUES('DE023-008','D023-005','W0201','W06S04','既有分股与环评摘录','A,B,C,D,E,F,G,H','证据对应节点或边；未知不补');
INSERT INTO membrane_reviews VALUES('MR023-005','CN0222','D023-005','yimen_2015_design','design','2015环评',1,'not_identified','W06S04','易门历史设计；非安宁新厂及资源回收主体','是否实施、实际量、蒸发条件和浓盐液接收','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA023-005','MR023-005','CN0222','yimen_2015_design','screening',1,'分质回用、既有系统优化及减量','先核贵金属回收及蒸发前分质，试验选择性分离并评估金属损失','conditional','需核实际水质、运行及合法浓水/残余物去向','INFERRED；D023-005及对应来源','仅对应历史/设计或报告期范围','金属形态、盐度、有机物、浓缩物回收条件','核现场、连续取样、水盐衡算；评膜污染、清洗、回用需求和总成本','源头回用、非膜及原工艺优化',NULL,NULL,NULL,NULL,NULL,NULL,'实际参数不足，不评级','2026-11-27');
INSERT INTO process_diagrams VALUES('D023-006','CN0225','historical_comparator','historical','2016同行环评转述',1,'partial','flowchart TD
 A[SCR再生生产水] --> B[沉淀压滤] --> C[RO] --> D[清洗回用]
 C --> E[浓水三效蒸发]','W06S02','仅同行环评历史转述；2015验收转载对浓水另有说法；不可证实现行','原验收全文、浓水实际去向及当前工艺','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0225','W06S02');
INSERT OR IGNORE INTO site_sources VALUES('CN0225','W06S02');
INSERT INTO process_diagram_evidence VALUES('DE023-009','D023-006','W0205','W06S02','同行环评类比段','A,B,C,D,E','证据对应节点或边；未知不补');
INSERT INTO membrane_reviews VALUES('MR023-006','CN0225','D023-006','historical_comparator','historical','2016同行环评转述',1,'confirmed_present','W06S02','仅同行环评历史转述；2015验收转载对浓水另有说法；不可证实现行','原验收全文、浓水实际去向及当前工艺','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0225','W06S02');
INSERT INTO membrane_units VALUES('MU023-001','MR023-006','反渗透（历史转述）','RO','回用','沉淀压滤后','清洗','三效蒸发（转述）','型号未知','W06S02','同行环评类比','仅该时期及范围');
INSERT INTO membrane_retrofits VALUES('RA023-006','MR023-006','CN0225','historical_comparator','screening',1,'分质回用、既有系统优化及减量','优先验证原有RO是否实施及浓水处置，不能把转述当现行工程','conditional','需核实际水质、运行及合法浓水/残余物去向','INFERRED；D023-006及对应来源','仅对应历史/设计或报告期范围','实际投运、膜参数、水盐衡算、浓水去向','核现场、连续取样、水盐衡算；评膜污染、清洗、回用需求和总成本','源头回用、非膜及原工艺优化',NULL,NULL,NULL,NULL,NULL,NULL,'实际参数不足，不评级','2026-11-27');
INSERT INTO process_diagrams VALUES('D023-007','CN0225','permit_2025','historical','2025许可变更索引',1,'partial','flowchart TD
 A[许可排水] --> B[处理流程未披露] --> C[城镇污水厂]','W06S08','2025索引；不与2016历史转述合并','许可正文、实际流量、排口及工艺','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0225','W06S08');
INSERT OR IGNORE INTO site_sources VALUES('CN0225','W06S08');
INSERT INTO process_diagram_evidence VALUES('DE023-010','D023-007','W0206','W06S08','2025-11-18许可变更索引','A,B,C','证据对应节点或边；未知不补');
INSERT INTO membrane_reviews VALUES('MR023-007','CN0225','D023-007','permit_2025','historical','2025许可变更索引',1,'not_identified','W06S08','2025索引；不与2016历史转述合并','许可正文、实际流量、排口及工艺','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA023-007','MR023-007','CN0225','permit_2025','screening',1,'分质回用、既有系统优化及减量','核排水范围后再筛选回用，不能推定旧RO仍在','conditional','需核实际水质、运行及合法浓水/残余物去向','INFERRED；D023-007及对应来源','仅对应历史/设计或报告期范围','许可正文、当前站内流程、流量','核现场、连续取样、水盐衡算；评膜污染、清洗、回用需求和总成本','源头回用、非膜及原工艺优化',NULL,NULL,NULL,NULL,NULL,NULL,'实际参数不足，不评级','2026-11-27');
INSERT INTO process_diagrams VALUES('D023-008','CN0226','scr_peer_2016','historical','2016同行环评类比',1,'partial','flowchart TD
 A[喷淋废水] --> B[絮凝沉淀] --> C[回用及部分排放]
 D[漂洗废水] --> E[去向未知]
 F[地面冲洗水] --> G[污水站]','W06S02','同行表历史转述，非本厂现行实际；原表合并单元格不复原','实际路线及水量','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0226','W06S02');
INSERT OR IGNORE INTO site_sources VALUES('CN0226','W06S02');
INSERT INTO process_diagram_evidence VALUES('DE023-011','D023-008','W0207','W06S02','同行表2.4-1','A,B,C','证据对应节点或边；未知不补');
INSERT OR IGNORE INTO site_sources VALUES('CN0226','W06S02');
INSERT INTO process_diagram_evidence VALUES('DE023-012','D023-008','W0208','W06S02','同行表2.4-1','D,E','证据对应节点或边；未知不补');
INSERT OR IGNORE INTO site_sources VALUES('CN0226','W06S02');
INSERT INTO process_diagram_evidence VALUES('DE023-013','D023-008','W0209','W06S02','同行表2.4-1','F,G','证据对应节点或边；未知不补');
INSERT INTO membrane_reviews VALUES('MR023-008','CN0226','D023-008','scr_peer_2016','historical','2016同行环评类比',1,'not_identified','W06S02','同行表历史转述，非本厂现行实际；原表合并单元格不复原','实际路线及水量','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA023-008','MR023-008','CN0226','scr_peer_2016','screening',1,'分质回用、既有系统优化及减量','查现行清洗回用及排放支流，必要时中和后测试膜','conditional','需核实际水质、运行及合法浓水/残余物去向','INFERRED；D023-008及对应来源','仅对应历史/设计或报告期范围','实际水质、流量、合法浓水去向','核现场、连续取样、水盐衡算；评膜污染、清洗、回用需求和总成本','源头回用、非膜及原工艺优化',NULL,NULL,NULL,NULL,NULL,NULL,'实际参数不足，不评级','2026-11-27');
INSERT INTO process_diagrams VALUES('D023-009','CN0227','scr_peer_2016','historical','2016同行环评类比',1,'partial','flowchart TD
 A[清洗废水] --> B[中和沉淀] --> C[回用及部分排放]
 D[地面冲洗水] --> E[污水站]','W06S02','仅同行环评历史数据；不代表2025许可或2026厂房状态','是否搬迁停产、实际流程与水量','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0227','W06S02');
INSERT OR IGNORE INTO site_sources VALUES('CN0227','W06S02');
INSERT INTO process_diagram_evidence VALUES('DE023-014','D023-009','W0210','W06S02','同行类比表','A,B,C','证据对应节点或边；未知不补');
INSERT OR IGNORE INTO site_sources VALUES('CN0227','W06S02');
INSERT INTO process_diagram_evidence VALUES('DE023-015','D023-009','W0211','W06S02','同行类比表','D,E','证据对应节点或边；未知不补');
INSERT INTO membrane_reviews VALUES('MR023-009','CN0227','D023-009','scr_peer_2016','historical','2016同行环评类比',1,'not_identified','W06S02','仅同行环评历史数据；不代表2025许可或2026厂房状态','是否搬迁停产、实际流程与水量','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA023-009','MR023-009','CN0227','scr_peer_2016','screening',1,'分质回用、既有系统优化及减量','先查厂址与实际生产；若在产，再评现有重金属预处理及回用','conditional','需核实际水质、运行及合法浓水/残余物去向','INFERRED；D023-009及对应来源','仅对应历史/设计或报告期范围','状态、金属、盐、水量、浓水','核现场、连续取样、水盐衡算；评膜污染、清洗、回用需求和总成本','源头回用、非膜及原工艺优化',NULL,NULL,NULL,NULL,NULL,NULL,'实际参数不足，不评级','2026-11-27');
INSERT INTO process_diagrams VALUES('D023-010','CN0228','solvent_pilot_2026','design','2026征求意见稿',1,'partial','flowchart TD
 A[含有机溶剂废水] --> B[蒸馏] --> C[后续流程未知]
 B --> D[冷凝废液及釜残 危废]','W06S12','中试设计；废液残渣固废量非废水量','蒸馏后废水量、溶剂成分、污水站接口','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0228','W06S12');
INSERT OR IGNORE INTO site_sources VALUES('CN0228','W06S12');
INSERT INTO process_diagram_evidence VALUES('DE023-016','D023-010','W0212','W06S12','86-87页既有摘要','A,B,C,D','证据对应节点或边；未知不补');
INSERT INTO membrane_reviews VALUES('MR023-010','CN0228','D023-010','solvent_pilot_2026','design','2026征求意见稿',1,'not_identified','W06S12','中试设计；废液残渣固废量非废水量','蒸馏后废水量、溶剂成分、污水站接口','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA023-010','MR023-010','CN0228','solvent_pilot_2026','screening',1,'分质回用、既有系统优化及减量','先评溶剂回收和水相性质；避免未经验证直接进膜','conditional','需核实际水质、运行及合法浓水/残余物去向','INFERRED；D023-010及对应来源','仅对应历史/设计或报告期范围','溶剂浓度、盐、流量、膜相容性、处置','核现场、连续取样、水盐衡算；评膜污染、清洗、回用需求和总成本','源头回用、非膜及原工艺优化',NULL,NULL,NULL,NULL,NULL,NULL,'实际参数不足，不评级','2026-11-27');
INSERT INTO process_diagrams VALUES('D023-011','CN0230','amine_shared_expansion','design','2025批复',1,'partial','flowchart TD
 A[高浓设备清洗及喷淋水] --> B[微电解] --> C[催化氧化] --> D[中和混凝沉淀] --> E[综合调节]
 F[地洗初雨生活质检水] --> E
 E --> G[水解酸化] --> H[接触氧化] --> I[二沉] --> J[气浮] --> K[淮安盐化园区污水厂]','W07S05','共享100t/d新站设计，含聚醚等；采购不等于投运','实际建成验收、催化剂分股流量和运行数据','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0230','W07S05');
INSERT OR IGNORE INTO site_sources VALUES('CN0230','W07S05');
INSERT INTO process_diagram_evidence VALUES('DE023-017','D023-011','W0232','W07S05','2025批复','A,B,C,D,E','证据对应节点或边；未知不补');
INSERT OR IGNORE INTO site_sources VALUES('CN0230','W07S05');
INSERT INTO process_diagram_evidence VALUES('DE023-018','D023-011','W0233','W07S05','2025批复','E,F,G,H,I,J,K','证据对应节点或边；未知不补');
INSERT INTO membrane_reviews VALUES('MR023-011','CN0230','D023-011','amine_shared_expansion','design','2025批复',1,'not_identified','W07S05','共享100t/d新站设计，含聚醚等；采购不等于投运','实际建成验收、催化剂分股流量和运行数据','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA023-011','MR023-011','CN0230','amine_shared_expansion','screening',1,'分质回用、既有系统优化及减量','先核有机胺预处理效率与真实回用要求；再评生化后膜','conditional','需核实际水质、运行及合法浓水/残余物去向','INFERRED；D023-011及对应来源','仅对应历史/设计或报告期范围','实际COD、胺、盐、膜试验、浓水处置','核现场、连续取样、水盐衡算；评膜污染、清洗、回用需求和总成本','源头回用、非膜及原工艺优化',NULL,NULL,NULL,NULL,NULL,NULL,'实际参数不足，不评级','2026-11-27');
INSERT INTO search_log VALUES('L023-003','CN0175','W01-B13/W11-B14','既有证据图谱批量整理',NULL,'仅依据已有废水记录和关联来源绘制范围图；不计为新现场调查','核实际状态、量与工艺','2026-11-27');
INSERT INTO search_log VALUES('L023-004','CN0222','W01-B13/W11-B14','既有证据图谱批量整理',NULL,'仅依据已有废水记录和关联来源绘制范围图；不计为新现场调查','核实际状态、量与工艺','2026-11-27');
INSERT INTO search_log VALUES('L023-005','CN0225','W01-B13/W11-B14','既有证据图谱批量整理',NULL,'仅依据已有废水记录和关联来源绘制范围图；不计为新现场调查','核实际状态、量与工艺','2026-11-27');
INSERT INTO search_log VALUES('L023-006','CN0226','W01-B13/W11-B14','既有证据图谱批量整理',NULL,'仅依据已有废水记录和关联来源绘制范围图；不计为新现场调查','核实际状态、量与工艺','2026-11-27');
INSERT INTO search_log VALUES('L023-007','CN0227','W01-B13/W11-B14','既有证据图谱批量整理',NULL,'仅依据已有废水记录和关联来源绘制范围图；不计为新现场调查','核实际状态、量与工艺','2026-11-27');
INSERT INTO search_log VALUES('L023-008','CN0228','W01-B13/W11-B14','既有证据图谱批量整理',NULL,'仅依据已有废水记录和关联来源绘制范围图；不计为新现场调查','核实际状态、量与工艺','2026-11-27');
INSERT INTO search_log VALUES('L023-009','CN0230','W01-B13/W11-B14','既有证据图谱批量整理',NULL,'仅依据已有废水记录和关联来源绘制范围图；不计为新现场调查','核实际状态、量与工艺','2026-11-27');
COMMIT;
