-- 021: 既有主体补证及流程图、技术成本基准
BEGIN;
INSERT INTO sources VALUES('S021-001','天津南化催化剂企业简介','https://www.nkcatalyst.com/gy','企业官网',NULL,'天津近5000t/a、30余晶化釜、3套焙烧炉；湖北15000t/a建设规模','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0039','S021-001');
INSERT OR IGNORE INTO site_sources VALUES('CN0040','S021-001');
INSERT INTO capacity VALUES('C021-001','CN0039','沸石分子筛催化剂',5000,'t/a','企业披露近5000（约数）','官网未注明日期','天津厂区','S021-001','不是实际产量，也不是湖北产能');
INSERT OR IGNORE INTO site_sources VALUES('CN0039','S021-001');
INSERT INTO evidence_notes VALUES('N021-001','CN0039','S021-001','天津厂区生产规模','官网企业简介','30余台反应晶化釜，3套焙烧炉，近5000t/a各类沸石分子筛催化剂；废水处理未披露。','WEB_COMPANY','关键内容提取；来源见索引','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0040','S021-001');
INSERT INTO evidence_notes VALUES('N021-002','CN0040','S021-001','湖北新基地规模','官网企业简介','2024设立湖北分公司，建设占地约5.5万m²、15000t/a沸石分子筛催化剂基地；与天津近5000t/a分厂记录，实际投产待核。与既有安全评价94亩征地不是同一面积口径。','WEB_COMPANY','关键内容提取；来源见索引','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0039','S021-001');
INSERT INTO claims VALUES('CL021-001','CN0039','产能','近5000t/a','WEB_COMPANY','S021-001','官网，非实际产量','2026-11-27');
UPDATE sites SET capacity_summary='企业官网近5000t/a沸石分子筛催化剂（天津）；30余台晶化釜、3套焙烧炉',source_status='本轮企业补证' WHERE site_id='CN0039';
INSERT INTO sources VALUES('S021-002','湖北2026重点项目清单转载','https://www.chemall.com.cn/news/show-241881.html','行业媒体转载','2026','南化15000t/a，2026—2028新开工重点项目','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0040','S021-002');
INSERT OR IGNORE INTO site_sources VALUES('CN0040','S021-002');
INSERT INTO evidence_notes VALUES('N021-003','CN0040','S021-002','计划建设期','重点项目清单','项目列为新开工，建设计划2026—2028，总投资7.88亿元为整厂非水站；不证明已经投产。','WEB_SECONDARY','关键内容提取；来源见索引','2026-11-27');
INSERT INTO search_log VALUES('L021-001','CN0039','W01-B11/W11-B12','天津南化官网 产能 晶化釜','S021-001','核实母厂规模，污水缺口仍在','武清许可/验收及招标','2026-11-27');
INSERT INTO search_log VALUES('L021-002','CN0040','W01-B11/W11-B12','仙桃 南化 15000吨 2026 项目','S021-002','补建设期线索，环评受理索引未得详细水处理','仙桃审批正文及设备招标','2026-11-27');
INSERT INTO sources VALUES('S021-003','安徽海螺废SCR中钒钼钨提取环评拟报批稿公示','https://profile.conch.cn/tzzgx/ggth/202611/t20261116_81326.html','企业公示检索摘要','2026-10-29','现有厂区内湿法及火法滤液进入新增离子交换树脂提取','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0122','S021-003');
INSERT OR IGNORE INTO site_sources VALUES('CN0122','S021-003');
INSERT INTO evidence_notes VALUES('N021-004','CN0122','S021-003','提取升级','2026-10-29公示摘要','现有厂区位于芜湖经济技术开发区江北片区福州路东侧、龙湾西路北侧。湿法、火法处理形成的滤液进入新增离子交换树脂提取；这是工艺物料处理，不能据此认定废水末端处理或膜。网页复开404，保留索引文本。','WEB_COMPANY','关键内容提取；来源见索引','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0122','S021-003');
INSERT INTO claims VALUES('CL021-002','CN0122','新项目提取路线','湿法和火法滤液→离子交换树脂提取','WEB_COMPANY','S021-003','拟报批稿公示，非污水站处理或膜','2026-11-27');
UPDATE sites SET address='芜湖经济技术开发区江北片区福州路东侧、龙湾西路北侧（提取项目现有厂区）',source_status='本轮企业公示补证' WHERE site_id='CN0122';
INSERT INTO search_log VALUES('L021-003','CN0122','W01-B11/W11-B12','海螺资源钒钼钨提取拟报批公示 2026','S021-003','取得滤液提取路线与地址，未取得污水站','查审批和水处理设备','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0203','W06S17');
INSERT INTO wastewater VALUES('W021-001','CN0203','湿法回收过程Wc1-1','2026环评表158设计',7292.711,'t/a','设计产生量','COD、TN、Zn、Cu、Ni、Cr、盐','中和＋三效蒸发','冷凝水回生产，不外排','浓缩残物去向待核','W06S17','WEB_PRIMARY','既有B6-N04摘要结构化；非新独立事实。盐分表列30mg/L虽与高盐描述不一致，作为待核原表口径记录于摘要。');
INSERT INTO water_metrics VALUES('M021-001','CN0203','W021-001','Wc1-1产生浓度','COD',800,NULL,'mg/L','环评设计源强',NULL,'2026',NULL,NULL,'W06S17','既有B6-N04结构化，非实测');
INSERT INTO water_metrics VALUES('M021-002','CN0203','W021-001','Wc1-1产生浓度','TN',1000,NULL,'mg/L','环评设计源强',NULL,'2026',NULL,NULL,'W06S17','既有B6-N04结构化，非实测');
INSERT INTO water_metrics VALUES('M021-003','CN0203','W021-001','Wc1-1产生浓度','锌',80,NULL,'mg/L','环评设计源强',NULL,'2026',NULL,NULL,'W06S17','既有B6-N04结构化，非实测');
INSERT INTO water_metrics VALUES('M021-004','CN0203','W021-001','Wc1-1产生浓度','铜',7,NULL,'mg/L','环评设计源强',NULL,'2026',NULL,NULL,'W06S17','既有B6-N04结构化，非实测');
INSERT INTO water_metrics VALUES('M021-005','CN0203','W021-001','Wc1-1产生浓度','镍',0.004,NULL,'mg/L','环评设计源强',NULL,'2026',NULL,NULL,'W06S17','既有B6-N04结构化，非实测');
INSERT INTO water_metrics VALUES('M021-006','CN0203','W021-001','Wc1-1产生浓度','铬',7,NULL,'mg/L','环评设计源强',NULL,'2026',NULL,NULL,'W06S17','既有B6-N04结构化，非实测');
INSERT INTO water_metrics VALUES('M021-007','CN0203',NULL,'Wc1-2催化剂制备过程','盐分',200,NULL,'mg/L','环评设计源强',NULL,'2026',NULL,NULL,'W06S17','表158；仅制备支路');
INSERT INTO water_metrics VALUES('M021-008','CN0203',NULL,'Wc1-2催化剂制备过程','盐分产生量',1.323,NULL,'t/a','环评设计源强',NULL,'2026',NULL,NULL,'W06S17','表158；仅制备支路');
INSERT INTO water_metrics VALUES('M021-009','CN0203',NULL,'外排环境（非企业厂区总排口）','COD',50,NULL,'mg/L','环评设计限值',NULL,'2026',NULL,NULL,'W06S17','表158外排环境列；不得当厂界实测');
INSERT INTO water_metrics VALUES('M021-010','CN0203',NULL,'外排环境（非企业厂区总排口）','氨氮',5,NULL,'mg/L','环评设计限值',NULL,'2026',NULL,NULL,'W06S17','表158外排环境列；不得当厂界实测');
INSERT INTO water_metrics VALUES('M021-011','CN0203',NULL,'外排环境（非企业厂区总排口）','SS',10,NULL,'mg/L','环评设计限值',NULL,'2026',NULL,NULL,'W06S17','表158外排环境列；不得当厂界实测');
INSERT INTO water_metrics VALUES('M021-012','CN0203',NULL,'外排环境（非企业厂区总排口）','TN',15,NULL,'mg/L','环评设计限值',NULL,'2026',NULL,NULL,'W06S17','表158外排环境列；不得当厂界实测');
INSERT OR IGNORE INTO site_sources VALUES('CN0203','W06S17');
INSERT INTO evidence_notes VALUES('N021-005','CN0203','W06S17','表158双口径','湿法回收及企业总排口','湿法回收7292.711t/a回用，制备过程6615.17t/a为独立支路。企业总排口设计1.42万t/a；外排环境列COD50、氨氮5、SS10、TN15mg/L，设计负荷分别0.71、0.071、0.142、0.213t/a；区别厂界设计限值，未披露处理单元，不能把制备水归入湿法蒸发。','WEB_PRIMARY','关键内容提取；来源见索引','2026-11-27');
INSERT INTO process_diagrams VALUES('D021-001','CN0203','wet_recovery_evaporation','design','2026环评',1,'partial','flowchart TD
 A[湿法回收废水 7292.711t/a] --> B[中和] --> C[三效蒸发] -->|冷凝水| D[生产回用]
 C --> E[浓缩残物去向待核]','W06S17','湿法回收支路，非全厂总排口或催化剂新制备水','实际设备参数、残液去向、浓度及回用量','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0203','W06S17');
INSERT OR IGNORE INTO site_sources VALUES('CN0203','W06S17');
INSERT INTO process_diagram_evidence VALUES('DE021-001','D021-001','W021-001','W06S17','表158','A,B,C,D,E','按已披露范围建图；未知单元不推断');
INSERT INTO membrane_reviews VALUES('MR021-001','CN0203','D021-001','wet_recovery_evaporation','design','2026环评',1,'not_identified','W06S17','湿法回收支路，非全厂总排口或催化剂新制备水','实际设备参数、残液去向、浓度及回用量','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA021-001','MR021-001','CN0203','wet_recovery_evaporation','screening',1,'工艺回用、分质减量及优化','先验证金属回收与高盐真实浓度，再研究膜预浓缩替代蒸发负荷','conditional','需核实际水质、运行与合法残余物去向','INFERRED；D021-001及对应来源','仅对应设计/历史范围','盐/金属形态、温度、pH、蒸发余量、成本及残物去向','核验现场，连续采样，衡算水盐，试验相容性和污染，评估费用及排放','源头回用、非膜及现有工艺优化',NULL,NULL,NULL,NULL,NULL,NULL,'实际参数不足，不评级','2026-11-27');
INSERT INTO search_log VALUES('L021-004','CN0203','W01-B11/W11-B12','昕立 环评 表158 湿法回收和制备过程','W06S17','同一原报告摘要补结构化和外排限值，不增加重复来源','查批复、具体制备水支路及投运','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0192','W07S18');
INSERT INTO wastewater VALUES('W021-002','CN0192','纯水制备系统排水','2026批复设计',NULL,NULL,NULL,NULL,'直接回用于三厂区原料用水','三厂区现有工程',NULL,'W07S18','WEB_PRIMARY','独立公用水支路，非污水膜处理');
INSERT INTO process_diagrams VALUES('D021-002','CN0192','third_plant_evaporation','historical','2026批复所述既有',1,'partial','flowchart TD
 A[含氯化钠高盐水] --> B[80t/d多效蒸发器] -->|冷凝水| C[工艺回用]
 B --> D[废盐鉴别前按危废管理]','W07S18','三厂工艺系统配套蒸发器；批准文件所述设施，不代表新增1500吨中试已投运','实际水量、盐、能耗和中试运行','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0192','W07S18');
INSERT OR IGNORE INTO site_sources VALUES('CN0192','W07S18');
INSERT INTO process_diagram_evidence VALUES('DE021-002','D021-002','W0261','W07S18','辽环函2026 34号第二条','A,B,C,D','按已披露范围建图；未知单元不推断');
INSERT INTO membrane_reviews VALUES('MR021-002','CN0192','D021-002','third_plant_evaporation','historical','2026批复所述既有',1,'not_identified','W07S18','三厂工艺系统配套蒸发器；批准文件所述设施，不代表新增1500吨中试已投运','实际水量、盐、能耗和中试运行','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA021-002','MR021-002','CN0192','third_plant_evaporation','screening',1,'工艺回用、分质减量及优化','查盐水浓度和杂质，评估膜预浓缩与现有蒸发兼容性','conditional','需核实际水质、运行与合法残余物去向','INFERRED；D021-002及对应来源','仅对应设计/历史范围','高盐水实际性质、盐危废鉴别及能耗','核验现场，连续采样，衡算水盐，试验相容性和污染，评估费用及排放','源头回用、非膜及现有工艺优化',NULL,NULL,NULL,NULL,NULL,NULL,'实际参数不足，不评级','2026-11-27');
INSERT INTO process_diagrams VALUES('D021-003','CN0192','fourth_plant_station','design','2026批复',1,'partial','flowchart TD
 A[四钼酸铵尾液 喷淋水 锅炉排水 初雨 生活水] --> B[四厂在建200t/d污水站 单元待核] --> C[全部回用设计]
 D[纯水制备排水] --> E[三厂原料用水]','W07S18','四厂站在建；与三厂80t/d蒸发分开，不叠加为当前运行280t/d','站详细单元、建成及回用对象','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0192','W07S18');
INSERT OR IGNORE INTO site_sources VALUES('CN0192','W07S18');
INSERT INTO process_diagram_evidence VALUES('DE021-003','D021-003','W0262','W07S18','第二条水污染防治','A,B,C','按已披露范围建图；未知单元不推断');
INSERT OR IGNORE INTO site_sources VALUES('CN0192','W07S18');
INSERT INTO process_diagram_evidence VALUES('DE021-004','D021-003','W021-002','W07S18','第二条纯水排水','D,E','按已披露范围建图；未知单元不推断');
INSERT INTO membrane_reviews VALUES('MR021-003','CN0192','D021-003','fourth_plant_station','design','2026批复',1,'not_identified','W07S18','四厂站在建；与三厂80t/d蒸发分开，不叠加为当前运行280t/d','站详细单元、建成及回用对象','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA021-003','MR021-003','CN0192','fourth_plant_station','screening',1,'工艺回用、分质减量及优化','查在建设计并避免将全厂混水直接上膜；优先分质及重金属去除','conditional','需核实际水质、运行与合法残余物去向','INFERRED；D021-003及对应来源','仅对应设计/历史范围','实际各股流量、站处理流程、回用指标','核验现场，连续采样，衡算水盐，试验相容性和污染，评估费用及排放','源头回用、非膜及现有工艺优化',NULL,NULL,NULL,NULL,NULL,NULL,'实际参数不足，不评级','2026-11-27');
INSERT INTO search_log VALUES('L021-005','CN0192','W01-B11/W11-B12','铁岭贵鑫 1500吨中试 2026批复','W07S18','复用原批复建两幅边界图，增加纯水排水回用','四厂实际建成和技术','2026-11-27');
INSERT INTO process_diagrams VALUES('D021-004','CN0216','nonferrous_workshop_2021','historical','2021部分验收',1,'partial','flowchart TD
 A[设备清洗水] --> B[工艺稀释回用]
 C[地面清洗水] --> D[地槽收集泵送] --> E[浸出工序]
 F[废气治理废水] --> G[中和] --> H[沉淀] --> I[槽车送园区污水厂]','W05S07','2021既有有色车间及废气水；不含尚未建成贵金属线','实际水量、当前纳管状态和金属去向','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0216','W05S07');
INSERT OR IGNORE INTO site_sources VALUES('CN0216','W05S07');
INSERT INTO process_diagram_evidence VALUES('DE021-005','D021-004','W0182','W05S07','2.2.2','A,B','按已披露范围建图；未知单元不推断');
INSERT OR IGNORE INTO site_sources VALUES('CN0216','W05S07');
INSERT INTO process_diagram_evidence VALUES('DE021-006','D021-004','W0183','W05S07','2.2.2','C,D,E','按已披露范围建图；未知单元不推断');
INSERT OR IGNORE INTO site_sources VALUES('CN0216','W05S07');
INSERT INTO process_diagram_evidence VALUES('DE021-007','D021-004','W0184','W05S07','2.2.2','F,G,H,I','按已披露范围建图；未知单元不推断');
INSERT INTO membrane_reviews VALUES('MR021-004','CN0216','D021-004','nonferrous_workshop_2021','historical','2021部分验收',1,'not_identified','W05S07','2021既有有色车间及废气水；不含尚未建成贵金属线','实际水量、当前纳管状态和金属去向','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA021-004','MR021-004','CN0216','nonferrous_workshop_2021','screening',1,'工艺回用、分质减量及优化','保留浸出回用，查外运水回用与膜脱盐可行性','conditional','需核实际水质、运行与合法残余物去向','INFERRED；D021-004及对应来源','仅对应设计/历史范围','分股盐、重金属、运输费用、纳管条件','核验现场，连续采样，衡算水盐，试验相容性和污染，评估费用及排放','源头回用、非膜及现有工艺优化',NULL,NULL,NULL,NULL,NULL,NULL,'实际参数不足，不评级','2026-11-27');
INSERT INTO process_diagrams VALUES('D021-005','CN0216','precious_deferred_and_domestic','design','2021技改及缓建',1,'partial','flowchart TD
 A[缓建贵金属车间高氨水] --> B[负压加热蒸氨回收] --> C[厂站] --> D[园区污水厂]
 E[生活污水] --> F[15t/d集成生物化粪池] --> G[待排池监测] --> D','W05S07','贵金属缓建线和生活水技改均为设计，不认定已实施','后续验收和实际蒸氨/生活水去向','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0216','W05S07');
INSERT OR IGNORE INTO site_sources VALUES('CN0216','W05S07');
INSERT INTO process_diagram_evidence VALUES('DE021-008','D021-005','W0185','W05S07','贵金属缓建设计','A,B,C,D','按已披露范围建图；未知单元不推断');
INSERT OR IGNORE INTO site_sources VALUES('CN0216','W05S07');
INSERT INTO process_diagram_evidence VALUES('DE021-009','D021-005','W0186','W05S07','生活水技改','E,F,G,D','按已披露范围建图；未知单元不推断');
INSERT INTO membrane_reviews VALUES('MR021-005','CN0216','D021-005','precious_deferred_and_domestic','design','2021技改及缓建',1,'not_identified','W05S07','贵金属缓建线和生活水技改均为设计，不认定已实施','后续验收和实际蒸氨/生活水去向','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA021-005','MR021-005','CN0216','precious_deferred_and_domestic','screening',1,'工艺回用、分质减量及优化','核缓建线后续状态，先回收氨并测盐，再比选膜回用','conditional','需核实际水质、运行与合法残余物去向','INFERRED；D021-005及对应来源','仅对应设计/历史范围','氨、盐、蒸氨负荷、实际回用目标','核验现场，连续采样，衡算水盐，试验相容性和污染，评估费用及排放','源头回用、非膜及现有工艺优化',NULL,NULL,NULL,NULL,NULL,NULL,'实际参数不足，不评级','2026-11-27');
INSERT INTO search_log VALUES('L021-006','CN0216','W01-B11/W11-B12','泉州丰鹏 历史验收工艺回填','W05S07','旧证据图谱补齐，不重复统计调查来源','查现行验收、纳管与高氨线','2026-11-27');
INSERT INTO process_diagrams VALUES('D021-006','CN0217','historical_metal_catalyst_water','design','2017环评',1,'partial','flowchart TD
 A[全项目废水 不含初雨 4370t/a] --> B[厂内处理站 单元未披露] --> C[遂昌县第二污水处理厂]
 D[冷却循环水] --> E[循环回用]','W05S08','2017设计，非现行运行；COD、氨氮、盐为合计设计源强','高盐工艺支路、实际站单元及产水','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0217','W05S08');
INSERT OR IGNORE INTO site_sources VALUES('CN0217','W05S08');
INSERT INTO process_diagram_evidence VALUES('DE021-010','D021-006','W0187','W05S08','2017源强表及水系统','A,B,C,D,E','按已披露范围建图；未知单元不推断');
INSERT INTO membrane_reviews VALUES('MR021-006','CN0217','D021-006','historical_metal_catalyst_water','design','2017环评',1,'not_identified','W05S08','2017设计，非现行运行；COD、氨氮、盐为合计设计源强','高盐工艺支路、实际站单元及产水','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA021-006','MR021-006','CN0217','historical_metal_catalyst_water','screening',1,'工艺回用、分质减量及优化','高盐高氨水分质、贵金属截留后研究ED/RO前处理及浓缩；不在未知工艺直接上膜','conditional','需核实际水质、运行与合法残余物去向','INFERRED；D021-006及对应来源','仅对应设计/历史范围','实际金属和盐、氨、分股流量、回用目标与费用','核验现场，连续采样，衡算水盐，试验相容性和污染，评估费用及排放','源头回用、非膜及现有工艺优化',NULL,NULL,NULL,NULL,NULL,NULL,'实际参数不足，不评级','2026-11-27');
INSERT INTO search_log VALUES('L021-007','CN0217','W01-B11/W11-B12','浙江微通历史源强回填','W05S08','旧图谱补齐；未确认2026运行','查600吨回收技改及许可','2026-11-27');
INSERT INTO sources VALUES('S021-004','浙江微通600吨担载类催化剂技改环评重新报批采购索引','https://www.bidcenter.com.cn/zhaobiao/zbkeyw-8825-331100-1.html','招标索引',NULL,'600t/a担载类催化剂回收技改重新报批报告编制','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0217','S021-004');
INSERT OR IGNORE INTO site_sources VALUES('CN0217','S021-004');
INSERT INTO evidence_notes VALUES('N021-006','CN0217','S021-004','回收技改线索','采购索引','600吨/年担载类催化剂回收技改环评重新报批编制采购，非已获批准或已运行，不当新剂产能。','WEB_SECONDARY','关键内容提取；来源见索引','2026-11-27');
INSERT INTO process_diagrams VALUES('D021-007','CN0220','mixed_plant_biological','design','2024拟审批',1,'partial','flowchart TD
 A[催化剂制备及活化水] --> B[项目分质系统 具体支路未知]
 C[其他高浓度水] --> D[不同支路预处理 零价铁氧化或破酚三效或苯胺回收]
 D --> E[低浓水及高浓预处理出水]
 F[全厂其他低浓水] --> E
 E --> G[生化调节] --> H[生物筛选氨化塔] --> I[梯级AO-HL] --> J[高效分离] --> K[催化氧化] --> L[胜海水务]','W05S16','6万吨苯二胺项目混合水处理；催化剂支路未知，B不推断接入E','催化剂实际产能及水量、各支路连接、现行运行','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0220','W05S16');
INSERT OR IGNORE INTO site_sources VALUES('CN0220','W05S16');
INSERT INTO process_diagram_evidence VALUES('DE021-011','D021-007','W0189','W05S16','拟审批催化剂水','A,B','按已披露范围建图；未知单元不推断');
INSERT OR IGNORE INTO site_sources VALUES('CN0220','W05S16');
INSERT INTO process_diagram_evidence VALUES('DE021-012','D021-007','W0190','W05S16','全厂混合站','C,D,E,F,G,H,I,J,K,L','按已披露范围建图；未知单元不推断');
INSERT INTO membrane_reviews VALUES('MR021-007','CN0220','D021-007','mixed_plant_biological','design','2024拟审批',1,'not_identified','W05S16','6万吨苯二胺项目混合水处理；催化剂支路未知，B不推断接入E','催化剂实际产能及水量、各支路连接、现行运行','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA021-007','MR021-007','CN0220','mixed_plant_biological','screening',1,'工艺回用、分质减量及优化','先查催化剂水单独性质与接入点，避免重复混合水工程','conditional','需核实际水质、运行与合法残余物去向','INFERRED；D021-007及对应来源','仅对应设计/历史范围','催化剂分股水、盐、酚胺及回用目标','核验现场，连续采样，衡算水盐，试验相容性和污染，评估费用及排放','源头回用、非膜及现有工艺优化',NULL,NULL,NULL,NULL,NULL,NULL,'实际参数不足，不评级','2026-11-27');
INSERT INTO search_log VALUES('L021-008','CN0220','W01-B11/W11-B12','江苏绿合安 既有拟审批图谱回填','W05S16','催化剂活化水单列，避免归因全厂共享站','实际投运和独立水处理','2026-11-27');
INSERT INTO process_diagrams VALUES('D021-008','CN0193','expansion_ro_reuse','design','2025批复',1,'partial','flowchart TD
 A[工艺水 喷淋水 化验室水 循环水排水] --> B[铁还原] --> C[中和] --> D[低温蒸发] --> E[RO] --> F[生产及公辅回用]
 E --> G[浓水去向待核]
 H[初期雨水] --> I[pH调节及絮凝沉淀] --> J[洒水抑尘]
 K[生活污水] --> L[防渗化粪池] --> M[定期清掏 园区站投运后纳管]','W03S09','2025扩能4m³/d设计；不把厂区全流量归于催化剂；浓水连接未明','扩能验收，实际RO浓水及能耗','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0193','W03S09');
INSERT OR IGNORE INTO site_sources VALUES('CN0193','W03S09');
INSERT INTO process_diagram_evidence VALUES('DE021-013','D021-008',NULL,'W03S09','辽环函2025 37号第二条','A,B,C,D,E,F,G,H,I,J,K,L,M','按已披露范围建图；未知单元不推断');
INSERT INTO membrane_reviews VALUES('MR021-008','CN0193','D021-008','expansion_ro_reuse','design','2025批复',1,'confirmed_present','W03S09','2025扩能4m³/d设计；不把厂区全流量归于催化剂；浓水连接未明','扩能验收，实际RO浓水及能耗','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0193','W03S09');
INSERT INTO membrane_units VALUES('MU021-001','MR021-008','反渗透膜','RO','深度脱盐回用','低温蒸发后','生产及公辅回用',NULL,'膜型号及回收率未披露','W03S09','水污染防治','仅该时期及范围');
INSERT INTO membrane_retrofits VALUES('RA021-008','MR021-008','CN0193','expansion_ro_reuse','screening',1,'工艺回用、分质减量及优化','核蒸发—RO实际运行次序及回流、残盐与金属回收，优化膜及热负荷','conditional','需核实际水质、运行与合法残余物去向','INFERRED；D021-008及对应来源','仅对应设计/历史范围','实际流量、金属、浓水处置和成本','核验现场，连续采样，衡算水盐，试验相容性和污染，评估费用及排放','源头回用、非膜及现有工艺优化',NULL,NULL,NULL,NULL,NULL,NULL,'实际参数不足，不评级','2026-11-27');
INSERT INTO search_log VALUES('L021-009','CN0193','W01-B11/W11-B12','锦州宏亚扩建批复图谱','W03S09','同源复用，补4m³/d扩能范围图，非新实际数据','查验收与浓水去向','2026-11-27');
INSERT INTO sources VALUES('S021-005','催化剂生产过程重金属废水处理研究及工业试验','https://www.scljs1975.com/CN/10.16796/j.cnki.1000-3770.2023.06.025','同行评议期刊论文','2023','水处理技术49(6):133–136；匿名上海催化剂企业工业试验；成本','2026-11-27');
CREATE TABLE technical_benchmarks (benchmark_id TEXT PRIMARY KEY,source_id TEXT NOT NULL REFERENCES sources(source_id),case_label TEXT NOT NULL,industry TEXT NOT NULL,period TEXT NOT NULL,stage TEXT NOT NULL,process TEXT NOT NULL,metric TEXT NOT NULL,value REAL NOT NULL,unit TEXT NOT NULL,basis TEXT NOT NULL,limitations TEXT NOT NULL,access_date TEXT NOT NULL);
INSERT INTO technical_benchmarks VALUES('TB021-001','S021-005','上海匿名催化剂生产企业','催化剂生产重金属废水','2023发表','工业试验','化学还原—分步沉淀；调pH或增沉淀剂破镍氨络合，酸化去碳酸根；混合不同pH废水并用生石灰调pH提高压滤效率','运行费用',30,'元/t废水','论文披露工业试验运行费用','未公开企业名、处理量、成本分项和价格基期；不可匹配具体工厂，不是膜处理报价或当前全厂费用','2026-11-27');
CREATE VIEW v_technical_benchmarks AS SELECT b.*,s.title,s.url FROM technical_benchmarks b JOIN sources s USING(source_id);
COMMIT;
