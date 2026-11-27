-- 014: 设计水量水质精细化、现有和技改阶段分图、批复边界校正
BEGIN;
INSERT OR IGNORE INTO site_sources VALUES('CN0037','W07S02');
INSERT INTO wastewater VALUES('W014-001','CN0037','含镍专线合计进水','2021环评设计',3.789,'m³/d','设计日均源强，非5m³/d站规模','Ni、TN、盐、SS','化学沉淀、絮凝、多介质、RO、MVR','清水和蒸发冷凝回用','含镍泥、盐按设计管理','W07S02','WEB_PRIMARY','p182表2.4-4；年1136.7m³/a与W0228的t/a质量不同，勿加总');
INSERT OR IGNORE INTO site_sources VALUES('CN0037','W07S02');
INSERT INTO wastewater VALUES('W014-002','CN0037','非含镍混合水合计进水','2021环评设计',180.755,'m³/d','设计日均源强，非200m³/d站规模','TN、盐、Cu、Zn、SS','调节、中和絮凝沉淀、多介质、RO、MVR','RO产水纳管；浓水蒸发','盐危废','W07S02','WEB_PRIMARY','p181—183；54226.5m³/a；原图截图文件过大失败');
INSERT OR IGNORE INTO site_sources VALUES('CN0037','W07S02');
INSERT INTO wastewater VALUES('W014-003','CN0037','非含镍RO产水','2021环评设计',126.529,'m³/d','环评预测排水量','COD、TN、盐、Cu、Zn、SS','RO后','襄城县第二污水处理厂',NULL,'W07S02','WEB_PRIMARY','p183；37958.7m³/a；非实际排放');
INSERT OR IGNORE INTO site_sources VALUES('CN0037','W07S02');
INSERT INTO wastewater VALUES('W014-004','CN0037','非含镍RO浓水','2021环评设计',54.226,'m³/d','设计浓水量','混合盐','MVR蒸发结晶','冷凝水回用界面待核','结晶盐危废','W07S02','WEB_PRIMARY','p182；16267.8m³/a；非实际排水');
INSERT OR IGNORE INTO site_sources VALUES('CN0037','W07S02');
INSERT INTO wastewater VALUES('W014-005','CN0037','非含镍生产工艺水','2021环评设计',177.635,'m³/d','设计分股流量',NULL,'其他生产污水站','纳管系统',NULL,'W07S02','WEB_PRIMARY','53290.5m³/a；p181—182；与合计不能重复求和');
INSERT OR IGNORE INTO site_sources VALUES('CN0037','W07S02');
INSERT INTO wastewater VALUES('W014-006','CN0037','车间地面清洗水','2021环评设计',1.52,'m³/d','设计分股流量',NULL,'其他生产污水站','纳管系统',NULL,'W07S02','WEB_PRIMARY','456m³/a；p181—182；与合计不能重复求和');
INSERT OR IGNORE INTO site_sources VALUES('CN0037','W07S02');
INSERT INTO wastewater VALUES('W014-007','CN0037','碱吸收塔废水','2021环评设计',1.5,'m³/d','设计分股流量','TN、盐','其他生产污水站','纳管系统',NULL,'W07S02','WEB_PRIMARY','450m³/a；p181—182；与合计不能重复求和');
INSERT OR IGNORE INTO site_sources VALUES('CN0037','W07S02');
INSERT INTO wastewater VALUES('W014-008','CN0037','实验室水','2021环评设计',0.1,'m³/d','设计分股流量',NULL,'其他生产污水站','纳管系统',NULL,'W07S02','WEB_PRIMARY','30m³/a；p181—182；与合计不能重复求和');
INSERT OR IGNORE INTO site_sources VALUES('CN0037','W07S02');
INSERT INTO wastewater VALUES('W014-009','CN0037','生活污水','2021环评设计',2.4,'m³/d','设计分股流量',NULL,'依托80m³化粪池','原报告时抽走堆肥；管网接通后拟纳管',NULL,'W07S02','WEB_PRIMARY','720m³/a；p181—182；与合计不能重复求和');
INSERT INTO water_metrics VALUES('M014-001','CN0037','W014-001','含镍专站混合进水','COD',120,NULL,'mg/L','环评预测/源强',NULL,'2021',NULL,NULL,'W07S02','表2.4-4；非实测；氨氮为报告估值');
INSERT INTO water_metrics VALUES('M014-002','CN0037','W014-001','含镍专站混合进水','SS',600,NULL,'mg/L','环评预测/源强',NULL,'2021',NULL,NULL,'W07S02','表2.4-4；非实测；氨氮为报告估值');
INSERT INTO water_metrics VALUES('M014-003','CN0037','W014-001','含镍专站混合进水','TN',10675,NULL,'mg/L','环评预测/源强',NULL,'2021',NULL,NULL,'W07S02','表2.4-4；非实测；氨氮为报告估值');
INSERT INTO water_metrics VALUES('M014-004','CN0037','W014-001','含镍专站混合进水','盐分',64810,NULL,'mg/L','环评预测/源强',NULL,'2021',NULL,NULL,'W07S02','表2.4-4；非实测；氨氮为报告估值');
INSERT INTO water_metrics VALUES('M014-005','CN0037','W014-001','含镍专站混合进水','总镍',22.8,NULL,'mg/L','环评预测/源强',NULL,'2021',NULL,NULL,'W07S02','表2.4-4；非实测；氨氮为报告估值');
INSERT INTO water_metrics VALUES('M014-006','CN0037','W014-002','其他站混合进水','COD',120.5,NULL,'mg/L','环评预测/源强',NULL,'2021',NULL,NULL,'W07S02','表2.4-4；非实测；氨氮为报告估值');
INSERT INTO water_metrics VALUES('M014-007','CN0037','W014-002','其他站混合进水','SS',595.6,NULL,'mg/L','环评预测/源强',NULL,'2021',NULL,NULL,'W07S02','表2.4-4；非实测；氨氮为报告估值');
INSERT INTO water_metrics VALUES('M014-008','CN0037','W014-002','其他站混合进水','TN',8033.1,NULL,'mg/L','环评预测/源强',NULL,'2021',NULL,NULL,'W07S02','表2.4-4；非实测；氨氮为报告估值');
INSERT INTO water_metrics VALUES('M014-009','CN0037','W014-002','其他站混合进水','盐分',72508.7,NULL,'mg/L','环评预测/源强',NULL,'2021',NULL,NULL,'W07S02','表2.4-4；非实测；氨氮为报告估值');
INSERT INTO water_metrics VALUES('M014-010','CN0037','W014-002','其他站混合进水','总铜',11.3,NULL,'mg/L','环评预测/源强',NULL,'2021',NULL,NULL,'W07S02','表2.4-4；非实测；氨氮为报告估值');
INSERT INTO water_metrics VALUES('M014-011','CN0037','W014-002','其他站混合进水','总锌',6.8,NULL,'mg/L','环评预测/源强',NULL,'2021',NULL,NULL,'W07S02','表2.4-4；非实测；氨氮为报告估值');
INSERT INTO water_metrics VALUES('M014-012','CN0037','W014-002','其他站混合进水','氨氮',1,NULL,'mg/L','环评预测/源强',NULL,'2021',NULL,NULL,'W07S02','表2.4-4；非实测；氨氮为报告估值');
INSERT INTO water_metrics VALUES('M014-013','CN0037','W014-003','其他站预测出水','COD',24.1,NULL,'mg/L','环评预测/源强',NULL,'2021',NULL,NULL,'W07S02','表2.4-4；非实测；氨氮为报告估值');
INSERT INTO water_metrics VALUES('M014-014','CN0037','W014-003','其他站预测出水','SS',8.5,NULL,'mg/L','环评预测/源强',NULL,'2021',NULL,NULL,'W07S02','表2.4-4；非实测；氨氮为报告估值');
INSERT INTO water_metrics VALUES('M014-015','CN0037','W014-003','其他站预测出水','TN',23,NULL,'mg/L','环评预测/源强',NULL,'2021',NULL,NULL,'W07S02','表2.4-4；非实测；氨氮为报告估值');
INSERT INTO water_metrics VALUES('M014-016','CN0037','W014-003','其他站预测出水','盐分',207.2,NULL,'mg/L','环评预测/源强',NULL,'2021',NULL,NULL,'W07S02','表2.4-4；非实测；氨氮为报告估值');
INSERT INTO water_metrics VALUES('M014-017','CN0037','W014-003','其他站预测出水','总铜',0.003,NULL,'mg/L','环评预测/源强',NULL,'2021',NULL,NULL,'W07S02','表2.4-4；非实测；氨氮为报告估值');
INSERT INTO water_metrics VALUES('M014-018','CN0037','W014-003','其他站预测出水','总锌',0.002,NULL,'mg/L','环评预测/源强',NULL,'2021',NULL,NULL,'W07S02','表2.4-4；非实测；氨氮为报告估值');
INSERT INTO water_metrics VALUES('M014-019','CN0037','W014-003','其他站预测出水','氨氮',1,NULL,'mg/L','环评预测/源强',NULL,'2021',NULL,NULL,'W07S02','表2.4-4；非实测；氨氮为报告估值');
INSERT INTO water_metrics VALUES('M014-020','CN0037','W014-002','中和絮凝沉淀','COD去除率',30,NULL,'%','设计计算效率',NULL,'2021',NULL,NULL,'W07S02','非验收去除率');
INSERT INTO water_metrics VALUES('M014-021','CN0037','W014-002','中和絮凝沉淀','SS去除率',90,NULL,'%','设计计算效率',NULL,'2021',NULL,NULL,'W07S02','非验收去除率');
INSERT INTO water_metrics VALUES('M014-022','CN0037','W014-002','中和絮凝沉淀','总铜去除率',90,NULL,'%','设计计算效率',NULL,'2021',NULL,NULL,'W07S02','非验收去除率');
INSERT INTO water_metrics VALUES('M014-023','CN0037','W014-002','中和絮凝沉淀','总锌去除率',90,NULL,'%','设计计算效率',NULL,'2021',NULL,NULL,'W07S02','非验收去除率');
INSERT INTO water_metrics VALUES('M014-024','CN0037','W014-002','多介质+RO','COD去除率',80,NULL,'%','设计计算效率',NULL,'2021',NULL,NULL,'W07S02','组合单元非单膜保证值');
INSERT INTO water_metrics VALUES('M014-025','CN0037','W014-002','多介质+RO','SS去除率',90,NULL,'%','设计计算效率',NULL,'2021',NULL,NULL,'W07S02','组合单元非单膜保证值');
INSERT INTO water_metrics VALUES('M014-026','CN0037','W014-002','多介质+RO','TN去除率',99.8,NULL,'%','设计计算效率',NULL,'2021',NULL,NULL,'W07S02','组合单元非单膜保证值');
INSERT INTO water_metrics VALUES('M014-027','CN0037','W014-002','多介质+RO','盐分去除率',99.8,NULL,'%','设计计算效率',NULL,'2021',NULL,NULL,'W07S02','组合单元非单膜保证值');
INSERT INTO water_metrics VALUES('M014-028','CN0037','W014-002','多介质+RO','总铜去除率',99.8,NULL,'%','设计计算效率',NULL,'2021',NULL,NULL,'W07S02','组合单元非单膜保证值');
INSERT INTO water_metrics VALUES('M014-029','CN0037','W014-002','多介质+RO','总锌去除率',99.8,NULL,'%','设计计算效率',NULL,'2021',NULL,NULL,'W07S02','组合单元非单膜保证值');
INSERT INTO water_metrics VALUES('M014-030','CN0037','W014-002','其他站RO','设计产水率',70,NULL,'%','环评设计',NULL,'2021',NULL,NULL,'W07S02','浓水30%进入MVR；不是当前实际');
INSERT INTO water_metrics VALUES('M014-031','CN0037','W014-002','其他站RO','设计浓水率',30,NULL,'%','环评设计',NULL,'2021',NULL,NULL,'W07S02','与70%合计100%');
INSERT OR IGNORE INTO site_sources VALUES('CN0037','W07S02');
INSERT INTO evidence_notes VALUES('N014-001','CN0037','W07S02','全厂设计水平衡','p181—183表2.4-4','全厂用水191.338m³/d，工艺纯水187.838、回用44.69、新鲜工艺水143.148、其他新鲜水3.5；废水产生186.944m³/d（含生活）；非含镍RO产水126.529m³/d纳管、54.226m³/d浓水蒸发；含镍3.789m³/d独立循环。混合水盐分72508.7mg/L，设计RO产水率70%；均为预测。原图截图过大，文本表读取。水量日/年四舍五入，t/a与m³/a保留原口径。','WEB_PRIMARY','事实摘录；非原件全文','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0037','W07S02');
INSERT INTO claims VALUES('CL014-001','CN0037','高盐分质及回收','非含镍180.755m³/d设计进水，盐分72508.7mg/L，RO产水70%（126.529m³/d），浓水30%（54.226m³/d）MVR；含镍3.789m³/d、Ni22.8mg/L','WEB_PRIMARY','W07S02','2021设计，非运行实绩','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0037','W07S02');
INSERT INTO process_diagrams VALUES('D014-001','CN0037','nickel-line','design','2021',2,'partial','flowchart TD
 A["含镍进水3.789m³/d设计"] --> B["化学沉淀絮凝"] --> C["多介质"] --> D["RO"] --> E["清水回用"]
 D --> F["MVR"] --> G["盐危废"]
 F --> E
 B --> H["含镍泥危废"]','W07S02','5m³/d为站规模；3.789为源强；仅含镍专站设计','验收与实测、Ni残留、浓盐及膜供应商待核','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0037','W07S02');
INSERT INTO process_diagram_evidence VALUES('DE014-001','D014-001','W014-001','W07S02','p182表2.4-4','A,B,C,D,E,F','对应流股及已披露单元；非实际运行推断');
INSERT OR IGNORE INTO site_sources VALUES('CN0037','W07S01');
INSERT INTO process_diagram_evidence VALUES('DE014-002','D014-001','W0219','W07S01','拟审批','B,C,D,E,F,G,H','对应流股及已披露单元；非实际运行推断');
INSERT OR IGNORE INTO site_sources VALUES('CN0037','W07S02');
INSERT INTO process_diagram_evidence VALUES('DE014-003','D014-001','W0228','W07S02','表2.4-4','A','对应流股及已披露单元；非实际运行推断');
INSERT INTO membrane_reviews VALUES('MR014-001','CN0037','D014-001','nickel-line','design','2021',2,'confirmed_present','W07S02','5m³/d为站规模；3.789为源强；仅含镍专站设计','验收与实测、Ni残留、浓盐及膜供应商待核','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0037','W07S02');
INSERT INTO membrane_units VALUES('MU014-001','MR014-001','含镍RO','RO','回用浓缩','多介质后','回用','MVR','站设计5m³/d；进水盐64810mg/L、Ni22.8mg/L为设计','W07S02','p182','仅该时期及支流');
INSERT INTO membrane_retrofits VALUES('RA014-001','MR014-001','CN0037','nickel-line','screening',2,'分质减量/资源化/回用初筛','先核镍沉淀和原RO/MVR投运；分盐或UF保护小试；不让重金属进入低盐水','conditional','须先核设施现状、回用需求及盐/浓水合规，方案非已建','INFERRED；D014-001；对应来源及流股','保留已知预处理和生产回收；不认定现行投运','镍回收率、真实盐度/硬度、膜通量、盐和泥危废处置成本','连续多工况采样与物料衡算；膜小试/CIP、结垢和盐品纯度验证；核真实设备及电汽药耗、处置费、回用收益','原工艺优化、直接分质回用、委外或纳管合规比较',2,1,2,NULL,NULL,NULL,'设计高盐及Ni；已设沉淀；危废盐和镍泥处置是约束','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0037','W07S02');
INSERT INTO process_diagrams VALUES('D014-002','CN0037','other-production','design','2021',2,'partial','flowchart TD
 A["非含镍混合水180.755m³/d设计"] --> B["调节 中和絮凝沉淀"] --> C["多介质"] --> D["RO 设计70%产水"]
 D --> E["产水126.529m³/d 纳襄城第二污水厂"]
 D --> F["浓水54.226m³/d MVR"] --> G["结晶盐危废"]','W07S02','200m³/d是站规模；非含镍盐分72508.7mg/L为设计源强','实际高盐RO能力、压力、回收率与盐去向待核','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0037','W07S02');
INSERT INTO process_diagram_evidence VALUES('DE014-004','D014-002','W014-002','W07S02','p181—183','A,B,C,D','对应流股及已披露单元；非实际运行推断');
INSERT OR IGNORE INTO site_sources VALUES('CN0037','W07S02');
INSERT INTO process_diagram_evidence VALUES('DE014-005','D014-002','W014-003','W07S02','p183','D,E','对应流股及已披露单元；非实际运行推断');
INSERT OR IGNORE INTO site_sources VALUES('CN0037','W07S02');
INSERT INTO process_diagram_evidence VALUES('DE014-006','D014-002','W014-004','W07S02','p182','D,F','对应流股及已披露单元；非实际运行推断');
INSERT OR IGNORE INTO site_sources VALUES('CN0037','W07S01');
INSERT INTO process_diagram_evidence VALUES('DE014-007','D014-002','W0220','W07S01','拟审批','B,C,D,E,F,G','对应流股及已披露单元；非实际运行推断');
INSERT INTO membrane_reviews VALUES('MR014-002','CN0037','D014-002','other-production','design','2021',2,'confirmed_present','W07S02','200m³/d是站规模；非含镍盐分72508.7mg/L为设计源强','实际高盐RO能力、压力、回收率与盐去向待核','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0037','W07S02');
INSERT INTO membrane_units VALUES('MU014-002','MR014-002','其他站RO','RO','脱盐浓缩','多介质后','纳管','MVR','70%设计回收；进水盐分72508.7mg/L（原水，非RO实测进水）','W07S02','p181—183','仅该时期及支流');
INSERT INTO membrane_retrofits VALUES('RA014-002','MR014-002','CN0037','other-production','screening',2,'分质减量/资源化/回用初筛','源头硫酸盐/硝酸盐/氯盐分质，先做NF/ED与RO对比；保留MVR作为盐浓缩终端，评估70%设计回收能否实际达成','conditional','须先核设施现状、回用需求及盐/浓水合规，方案非已建','INFERRED；D014-002；对应来源及流股','保留已知预处理和生产回收；不认定现行投运','水质分布、渗透压、膜压力、盐分离纯度、危废处置费和蒸发热耗','连续多工况采样与物料衡算；膜小试/CIP、结垢和盐品纯度验证；核真实设备及电汽药耗、处置费、回用收益','原工艺优化、直接分质回用、委外或纳管合规比较',2,1,2,NULL,NULL,NULL,'原水盐分7.25万mg/L；现有设计预处理；混盐危废约束','2026-11-27');
INSERT INTO search_log VALUES('L014-001','CN0037','W01-B4/W11-B5','纽迈特6000吨 环评 非含镍 180.755 盐分 RO 出水率','W07S02','补齐设计进出水和水量平衡；原图截图过大','查更名后验收、运行及膜合同','2026-11-27');
UPDATE tasks SET next_query='取得更名后环保验收及许可执行，核高盐RO压力/回收率及混盐危废成本' WHERE site_id='CN0037';
INSERT INTO sources VALUES('W14S01','河南润巍2200吨工程材料和100吨催化剂环评','https://www.yanjin.gov.cn/uploads/ueditor/20240709/0da2c667d3c3417d80245f60121b0315.pdf','政府公开环评','2024-07','3.3.3.2 公用及清洗废水设计水量；部分正文遮蔽，截图超时；标题与个别页眉名称不一致','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0038','W14S01');
INSERT OR IGNORE INTO site_sources VALUES('CN0038','W14S01');
INSERT INTO wastewater VALUES('W014-010','CN0038','碱喷淋更换排水','2024环评设计',10,'m³/d','公用/混合产品设计流量','COD500、SS1000、NH3-N10、TN20','厂区站','延津第二污水厂',NULL,'W14S01','WEB_PRIMARY','3000m³/a；3.3.3.2；非催化剂专属或实绩');
INSERT OR IGNORE INTO site_sources VALUES('CN0038','W14S01');
INSERT INTO wastewater VALUES('W014-011','CN0038','实验室废水','2024环评设计',0.8,'m³/d','公用/混合产品设计流量','COD700、BOD5 150、SS200、NH3-N10、TN30、TP1','厂区站','延津第二污水厂',NULL,'W14S01','WEB_PRIMARY','240m³/a；3.3.3.2；非催化剂专属或实绩');
INSERT OR IGNORE INTO site_sources VALUES('CN0038','W14S01');
INSERT INTO wastewater VALUES('W014-012','CN0038','办公生活废水','2024环评设计',3.84,'m³/d','公用/混合产品设计流量','COD300、BOD5 160、SS120、NH3-N20、TN30、TP3','厂区站','延津第二污水厂',NULL,'W14S01','WEB_PRIMARY','1152m³/a；3.3.3.2；非催化剂专属或实绩');
INSERT OR IGNORE INTO site_sources VALUES('CN0038','W14S01');
INSERT INTO wastewater VALUES('W014-013','CN0038','循环冷却排污水产生','2024环评设计',38.4,'m³/d','公用/混合产品设计流量','COD60、BOD5 15、SS80','分质收集','12.3m³/d清洗回用；26.1m³/d总排口',NULL,'W14S01','WEB_PRIMARY','11520m³/a；3.3.3.2；非催化剂专属或实绩');
INSERT INTO water_metrics VALUES('M014-032','CN0038','W014-013','循环冷却排污水产生','COD',60,NULL,'mg/L','类比设计取值',NULL,'2024',NULL,NULL,'W14S01','非厂实测');
INSERT INTO water_metrics VALUES('M014-033','CN0038','W014-013','循环冷却排污水产生','BOD5',15,NULL,'mg/L','类比设计取值',NULL,'2024',NULL,NULL,'W14S01','非厂实测');
INSERT INTO water_metrics VALUES('M014-034','CN0038','W014-013','循环冷却排污水产生','SS',80,NULL,'mg/L','类比设计取值',NULL,'2024',NULL,NULL,'W14S01','非厂实测');
INSERT OR IGNORE INTO site_sources VALUES('CN0038','W14S01');
INSERT INTO wastewater VALUES('W014-014','CN0038','循环排污回用','2024环评设计',12.3,'m³/d','公用/混合产品设计流量',NULL,'回用','地面清洗',NULL,'W14S01','WEB_PRIMARY','3690m³/a；3.3.3.2；非催化剂专属或实绩');
INSERT OR IGNORE INTO site_sources VALUES('CN0038','W14S01');
INSERT INTO wastewater VALUES('W014-015','CN0038','循环排污外排','2024环评设计',26.1,'m³/d','公用/混合产品设计流量','COD60、SS80','直接总排口','延津第二污水厂',NULL,'W14S01','WEB_PRIMARY','7830m³/a；3.3.3.2；非催化剂专属或实绩');
INSERT OR IGNORE INTO site_sources VALUES('CN0038','W14S01');
INSERT INTO wastewater VALUES('W014-016','CN0038','供热冷凝水','2024环评设计',62.51,'m³/d','公用/混合产品设计流量',NULL,'直接回用','循环冷却补水',NULL,'W14S01','WEB_PRIMARY','仅公用工程；3.3.3.2；非催化剂专属或实绩');
INSERT OR IGNORE INTO site_sources VALUES('CN0038','W14S01');
INSERT INTO wastewater VALUES('W014-017','CN0038','纯水制备浓水','2024环评设计',9.67,'m³/d','公用/混合产品设计流量','COD50、BOD5 10、SS50','纯水制备三级RO浓水','厂区总排口',NULL,'W14S01','WEB_PRIMARY','2708m³/a；280天口径与循环水300天不同；3.3.3.2；非催化剂专属或实绩');
INSERT OR IGNORE INTO site_sources VALUES('CN0038','W14S01');
INSERT INTO evidence_notes VALUES('N014-002','CN0038','W14S01','纯水膜与污水膜区别','3-35—3-37','纯水系统石英砂、活性炭、精滤、三级RO，制水率67%，19.64m³/d产水、29.31m³/d新鲜水、9.67m³/d浓水。约4年更换RO膜0.4t/4a（纯水膜）；非生产污水膜。设计新增污水站污泥25.8t/a（含水60%）；原报告个别页眉名称及产品文字遮蔽，需核正式原图和工艺边界。截图超时。','WEB_PRIMARY','事实摘录；非原件全文','2026-11-27');
INSERT INTO search_log VALUES('L014-002','CN0038','W01-B4/W11-B5','润巍 2200吨 100吨 环评 循环水 三级RO','W14S01','补充公用流股并明确制水RO非污水膜','投运后污水站、独立催化剂水量及许可证','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0087','turn106948search5');
INSERT INTO wastewater VALUES('W014-018','CN0087','污水站处理能力及分质去向','2026-07-24批复设计',24,'t/d','污水站设计能力','母液、洗涤压滤、碱喷淋、冲洗、初雨','母液/滤洗预处理板框+曝气调节；并其他支流MVR→水解酸化→缺氧/好氧→MBR','总排口→抚顺胜利开发区污水厂','生化污泥待危废鉴别，鉴别前按危废','turn106948search5','WEB_PRIMARY','辽环函2026第62号第二（二）款；非实际流量');
INSERT OR IGNORE INTO site_sources VALUES('CN0087','turn106948search5');
INSERT INTO wastewater VALUES('W014-019','CN0087','公用排水及生活污水','2026-07-24批复设计',NULL,NULL,NULL,NULL,'纯水、循环排水及化粪池生活水汇入总排口','抚顺胜利开发区污水厂',NULL,'turn106948search5','WEB_PRIMARY','不经过生产废水站的支路；最终批复');
INSERT OR IGNORE INTO site_sources VALUES('CN0087','turn106948search5');
INSERT INTO evidence_notes VALUES('N014-003','CN0087','turn106948search5','批复产品及处理','第二（二）、（四）款','最终批复：200t/a成品分项100异构、60精制、40脱硫；80t/a分子筛为内部中间料，200t/a含铂废剂是处理量，不叠加为成品。24t/d站出水并公用生活水纳管；第一类污染物按GB8978-1996表1管控。硫酸铝液、氯化亚铁液、余二氧化硅及生化污泥待鉴别；不认定全厂零排放。','WEB_PRIMARY','事实摘录；非原件全文','2026-11-27');
INSERT INTO capacity VALUES('C014-001','CN0087','加氢异构剂',100,'t/a','最终环评批准设计','2026-07','成品200吨分项','turn106948search5','包含于成品200t/a总量，非新增产能');
INSERT INTO capacity VALUES('C014-002','CN0087','加氢精制剂',60,'t/a','最终环评批准设计','2026-07','成品200吨分项','turn106948search5','包含于成品200t/a总量，非新增产能');
INSERT INTO capacity VALUES('C014-003','CN0087','脱硫剂',40,'t/a','最终环评批准设计','2026-07','成品200吨分项','turn106948search5','包含于成品200t/a总量，非新增产能');
INSERT OR IGNORE INTO site_sources VALUES('CN0087','turn106948search5');
INSERT INTO claims VALUES('CL014-002','CN0087','最终批准污水去向','24t/d预处理+MVR+水解酸化+A/O+MBR；总排口纳抚顺胜利开发区污水厂','WEB_PRIMARY','turn106948search5','2026年7月24日批复；非现行运行','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0087','turn106948search5');
INSERT INTO process_diagrams VALUES('D014-003','CN0087','production-regeneration','design','2026批复',2,'partial','flowchart TD
 A["分子筛晶化母液、洗涤压滤水"] --> B["板框压滤 曝气调节"] --> C["MVR"]
 D["碱喷淋、地面冲洗、沉淀初雨"] --> C
 C --> E["水解酸化"] --> F["缺氧/好氧"] --> G["MBR"] --> H["总排口"]
 J["纯水/循环排水、化粪池生活水"] --> H
 H --> K["抚顺胜利开发区污水厂"]','turn106948search5','24t/d站设计；母液滤洗预处理与其他蒸发进水分开；公用及生活水旁路','MVR冷凝分流、MBR膜参数、验收、污泥鉴别待核','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0087','turn106948search5');
INSERT INTO process_diagram_evidence VALUES('DE014-008','D014-003','W014-018','turn106948search5','第二（二）款','A,B,C,D,E,F,G,H,K','对应流股及已披露单元；非实际运行推断');
INSERT OR IGNORE INTO site_sources VALUES('CN0087','turn106948search5');
INSERT INTO process_diagram_evidence VALUES('DE014-009','D014-003','W014-019','turn106948search5','第二（二）款','J,H,K','对应流股及已披露单元；非实际运行推断');
INSERT INTO membrane_reviews VALUES('MR014-003','CN0087','D014-003','production-regeneration','design','2026批复',2,'confirmed_present','turn106948search5','24t/d站设计；母液滤洗预处理与其他蒸发进水分开；公用及生活水旁路','MVR冷凝分流、MBR膜参数、验收、污泥鉴别待核','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0087','turn106948search5');
INSERT INTO membrane_units VALUES('MU014-003','MR014-003','MBR','MBR','生化固液分离','A/O混合液','总排口',NULL,'24t/d是站规模，非MBR额定','turn106948search5','第二（二）款','仅该时期及支流');
INSERT INTO membrane_retrofits VALUES('RA014-003','MR014-003','CN0087','production-regeneration','screening',2,'分质减量/资源化/回用初筛','先核MVR冷凝水负荷和现有MBR实际运行，再评估其产水回用或RO；优先分质脱盐及避免危废浓缩混流','conditional','须先核设施现状、回用需求及盐/浓水合规，方案非已建','INFERRED；D014-003；对应来源及流股','保留已知预处理和生产回收；不认定现行投运','盐及氨、COD、有毒金属、MVR冷凝质量、MBR运行/排泥及鉴别成本','连续多工况采样与物料衡算；膜小试/CIP、结垢和盐品纯度验证；核真实设备及电汽药耗、处置费、回用收益','原工艺优化、直接分质回用、委外或纳管合规比较',NULL,NULL,NULL,NULL,NULL,NULL,'不足以评分，未知留空','2026-11-27');
UPDATE sites SET water_summary=water_summary||'；2026最终批复24t/d站，出水纳抚顺胜利开发区污水厂，公用与生活水总排口汇合' WHERE site_id='CN0087';
INSERT INTO search_log VALUES('L014-003','CN0087','W01-B4/W11-B5','怡新 抚顺 200吨 批复 24吨/天 MBR','turn106948search5','最终批复校正分流、能力与接管，原图保留为版本1','验收及鉴别报告','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0047','turn127831search0');
INSERT INTO process_diagrams VALUES('D014-004','CN0047','automotive_cleaning_reuse','design','2023技改环评',1,'partial','flowchart TD
 A["设备清洗760t/a、水环泵30、实验室30"] --> B["混凝沉淀"] --> C["低温蒸发"] --> D["BAC"] --> E["UF"] --> F["RO"] --> G["喷淋塔回用"]
 F --> H["浓水去向待核"]
 J["冷冻弃水、纯水RO浓水、反冲洗、初雨"] --> K["园区胜科水务"]
 L["生活污水6720t/a"] --> M["A/O"] --> K
 K --> N["长江"]','turn127831search0','2023技改保持600万件/年，820t/a生产清洗支流设计；不等于全厂零排放','RO浓水去向、实际回用率、BAC及膜设备、盐泥处置待核','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0047','turn127831search0');
INSERT INTO process_diagram_evidence VALUES('DE014-010','D014-004','W0011','turn127831search0','水污染防治','A,B,C,D,E,F,G','对应流股及已披露单元；非实际运行推断');
INSERT OR IGNORE INTO site_sources VALUES('CN0047','turn127831search0');
INSERT INTO process_diagram_evidence VALUES('DE014-011','D014-004','W0012','turn127831search0','水污染防治','A,B,C,D,E,F,G','对应流股及已披露单元；非实际运行推断');
INSERT OR IGNORE INTO site_sources VALUES('CN0047','turn127831search0');
INSERT INTO process_diagram_evidence VALUES('DE014-012','D014-004','W0013','turn127831search0','水污染防治','A,B,C,D,E,F,G','对应流股及已披露单元；非实际运行推断');
INSERT OR IGNORE INTO site_sources VALUES('CN0047','turn127831search0');
INSERT INTO process_diagram_evidence VALUES('DE014-013','D014-004','W0014','turn127831search0','公用及初雨','J,K,N','对应流股及已披露单元；非实际运行推断');
INSERT OR IGNORE INTO site_sources VALUES('CN0047','turn127831search0');
INSERT INTO process_diagram_evidence VALUES('DE014-014','D014-004','W0015','turn127831search0','公用及初雨','J,K,N','对应流股及已披露单元；非实际运行推断');
INSERT OR IGNORE INTO site_sources VALUES('CN0047','turn127831search0');
INSERT INTO process_diagram_evidence VALUES('DE014-015','D014-004','W0016','turn127831search0','公用及初雨','J,K,N','对应流股及已披露单元；非实际运行推断');
INSERT OR IGNORE INTO site_sources VALUES('CN0047','turn127831search0');
INSERT INTO process_diagram_evidence VALUES('DE014-016','D014-004','W0017','turn127831search0','公用及初雨','J,K,N','对应流股及已披露单元；非实际运行推断');
INSERT OR IGNORE INTO site_sources VALUES('CN0047','turn127831search0');
INSERT INTO process_diagram_evidence VALUES('DE014-017','D014-004','W0018','turn127831search0','生活水','L,M,K,N','对应流股及已披露单元；非实际运行推断');
INSERT INTO membrane_reviews VALUES('MR014-004','CN0047','D014-004','automotive_cleaning_reuse','design','2023技改环评',1,'confirmed_present','turn127831search0','2023技改保持600万件/年，820t/a生产清洗支流设计；不等于全厂零排放','RO浓水去向、实际回用率、BAC及膜设备、盐泥处置待核','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0047','turn127831search0');
INSERT INTO membrane_units VALUES('MU014-004','MR014-004','UF','UF','保护后续RO','BAC出水','RO',NULL,'规格未知','turn127831search0','水污染防治','仅该时期及支流');
INSERT OR IGNORE INTO site_sources VALUES('CN0047','turn127831search0');
INSERT INTO membrane_units VALUES('MU014-005','MR014-004','RO','RO','回用','UF后','喷淋塔',NULL,'纯水RO另列公用支路，不计本系统','turn127831search0','水污染防治','仅该时期及支流');
INSERT INTO membrane_retrofits VALUES('RA014-004','MR014-004','CN0047','automotive_cleaning_reuse','screening',1,'分质减量/资源化/回用初筛','先核820t/a生产支线实际回用及浓水，避免为低水量重复投资；另核公用冷冻/纯水浓水直接回用可能','conditional','须先核设施现状、回用需求及盐/浓水合规，方案非已建','INFERRED；D014-004；对应来源及流股','保留已知预处理和生产回收；不认定现行投运','实际流量/水质、贵金属泥回收、膜CIP、浓水、蒸发费与水价','连续多工况采样与物料衡算；膜小试/CIP、结垢和盐品纯度验证；核真实设备及电汽药耗、处置费、回用收益','原工艺优化、直接分质回用、委外或纳管合规比较',NULL,NULL,NULL,NULL,NULL,NULL,'不足以评分，未知留空','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0047','turn127831search0');
INSERT INTO evidence_notes VALUES('N014-004','CN0047','turn127831search0','设计支线合计','2023拟审批','三个生产清洗支流合计820t/a；公用及初雨合计19025t/a（3025+4925+275+10800），生活6720t/a；独立分流，不能将纯水制备浓水当污水RO浓水。均为原环评年产生量而非计量实绩。','WEB_PRIMARY','事实摘录；非原件全文','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0066','turn699489search0');
INSERT INTO process_diagrams VALUES('D014-005','CN0066','existing_two_stage_ro','built','2026拟审批所述既有',1,'partial','flowchart TD
 A["再生综合废水"] --> B["混凝 中和 沉淀"] --> C["两级过滤"] --> D["UF"] --> E["两级RO"] --> F["产水回用去向待核"]
 E --> G["MVR蒸发结晶"] --> H["结晶盐/冷凝水去向待核"]','turn699489search0','公示所述既有站240m³/d，原两级RO；不同于拟新增第三段','运行状态、实际进水及盐去向；原页复开超时','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0066','turn699489search0');
INSERT INTO process_diagram_evidence VALUES('DE014-018','D014-005','W0009','turn699489search0','2026拟审批既有设施','A,B,C,D,E,G','对应流股及已披露单元；非实际运行推断');
INSERT INTO membrane_reviews VALUES('MR014-005','CN0066','D014-005','existing_two_stage_ro','built','2026拟审批所述既有',1,'confirmed_present','turn699489search0','公示所述既有站240m³/d，原两级RO；不同于拟新增第三段','运行状态、实际进水及盐去向；原页复开超时','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0066','turn699489search0');
INSERT INTO membrane_units VALUES('MU014-006','MR014-005','既有UF','UF','预过滤','两级过滤后','RO',NULL,'240m³/d为站设计','turn699489search0','既有工程','仅该时期及支流');
INSERT OR IGNORE INTO site_sources VALUES('CN0066','turn699489search0');
INSERT INTO membrane_units VALUES('MU014-007','MR014-005','既有两级RO','RO','浓缩','UF后',NULL,'MVR','两级RO；新增第三段是拟建','turn699489search0','既有工程','仅该时期及支流');
INSERT INTO membrane_retrofits VALUES('RA014-005','MR014-005','CN0066','existing_two_stage_ro','screening',1,'分质减量/资源化/回用初筛','先取得既有两级RO的实际产水/浓水数据及第三段改造验收；比较新增RO减蒸发与浓水结垢风险','conditional','须先核设施现状、回用需求及盐/浓水合规，方案非已建','INFERRED；D014-005；对应来源及流股','保留已知预处理和生产回收；不认定现行投运','真实进水、压力、实际MVR热负荷、盐水罐、膜合同及结晶盐性质','连续多工况采样与物料衡算；膜小试/CIP、结垢和盐品纯度验证；核真实设备及电汽药耗、处置费、回用收益','原工艺优化、直接分质回用、委外或纳管合规比较',NULL,NULL,NULL,NULL,NULL,NULL,'不足以评分，未知留空','2026-11-27');
INSERT INTO water_metrics VALUES('M014-035','CN0066',NULL,'2026拟改造设施','拟新盐水罐',150,NULL,'m³','设计有效容积',NULL,'2026',NULL,NULL,'turn699489search0','容积非处理能力；公示检索摘录，页面复开超时');
INSERT INTO water_metrics VALUES('M014-036','CN0066',NULL,'2026拟改造设施','拟新产水池',200,NULL,'m³','设计有效容积',NULL,'2026',NULL,NULL,'turn699489search0','容积非处理能力；公示检索摘录，页面复开超时');
INSERT INTO water_metrics VALUES('M014-037','CN0066',NULL,'2026拟改造设施','拟新初雨收集池',500,NULL,'m³','设计有效容积',NULL,'2026',NULL,NULL,'turn699489search0','容积非处理能力；公示检索摘录，页面复开超时');
INSERT INTO water_metrics VALUES('M014-038','CN0066',NULL,'2026拟改造设施','拟新事故池',300,NULL,'m³','设计有效容积',NULL,'2026',NULL,NULL,'turn699489search0','容积非处理能力；公示检索摘录，页面复开超时');
INSERT OR IGNORE INTO site_sources VALUES('CN0066','turn699489search0');
INSERT INTO evidence_notes VALUES('N014-005','CN0066','turn699489search0','技改设备差异','2026拟审批项目概况','已有240m³/d站，UF、两级RO、MVR；拟新增一套RO、一套MVR，盐水罐150m³、产水池200m³、初雨池500m³、事故池300m³。原有280m³事故池与拟新增不是同一设施；不认定已经实施。','WEB_PRIMARY','事实摘录；非原件全文','2026-11-27');
INSERT INTO search_log VALUES('L014-004','CN0066','W01-B4/W11-B5','重庆远达 2026 240m³/d 两级三级RO MVR 盐水罐','turn699489search0','既有与拟建分别绘图、补设计容积；页面重开超时','最终批复及改造验收、实际膜段','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0071','turn421284search3');
INSERT INTO process_diagrams VALUES('D014-006','CN0071','six_streams_recovery','design','2024拟审批',1,'partial','flowchart TD
 A["FCC/DCC洗水与酸雾吸收"] --> B["稀硫酸调配回用"]
 C["1号蒸氨水240m³/d设计"] --> D["调pH 絮凝 压滤"] --> K["生产废水深度处理 单元待核"]
 E["2号沉镍50m³/d设计"] --> F["捕集 压滤"] --> K
 G["3号高盐及废滤液10m³/d设计"] --> H["调pH 絮凝 压滤"] --> K
 K --> L["废镍/废加氢压滤回用"]
 M["4号含氨、6号一般重金属"] --> N["车间分质预处理"] --> K
 K --> O["废铂铝酸溶回用"]
 P["5号含氮重金属"] --> Q["独立处理"] --> R["酸溶/废银/三元湿法回用"]
 S["公用及生活"] --> T["综合站"] --> V["龙口市污水厂"]','turn421284search3','2024 6万吨废剂处置设计，分质能力非实际进水，不能直接相加为总量','深度处理单元、终端膜类型、实际验收、危废及盐平衡待核','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0071','turn421284search3');
INSERT INTO process_diagram_evidence VALUES('DE014-019','D014-006','W0086','turn421284search3','拟审批','A,B','对应流股及已披露单元；非实际运行推断');
INSERT OR IGNORE INTO site_sources VALUES('CN0071','turn421284search3');
INSERT INTO process_diagram_evidence VALUES('DE014-020','D014-006','W0087','turn421284search3','拟审批','C,D,K,L','对应流股及已披露单元；非实际运行推断');
INSERT OR IGNORE INTO site_sources VALUES('CN0071','turn421284search3');
INSERT INTO process_diagram_evidence VALUES('DE014-021','D014-006','W0088','turn421284search3','拟审批','E,F,K,L','对应流股及已披露单元；非实际运行推断');
INSERT OR IGNORE INTO site_sources VALUES('CN0071','turn421284search3');
INSERT INTO process_diagram_evidence VALUES('DE014-022','D014-006','W0089','turn421284search3','拟审批','G,H,K,L','对应流股及已披露单元；非实际运行推断');
INSERT OR IGNORE INTO site_sources VALUES('CN0071','turn421284search3');
INSERT INTO process_diagram_evidence VALUES('DE014-023','D014-006','W0090','turn421284search3','拟审批','M,N,K,O','对应流股及已披露单元；非实际运行推断');
INSERT OR IGNORE INTO site_sources VALUES('CN0071','turn421284search3');
INSERT INTO process_diagram_evidence VALUES('DE014-024','D014-006','W0091','turn421284search3','拟审批','P,Q,R','对应流股及已披露单元；非实际运行推断');
INSERT OR IGNORE INTO site_sources VALUES('CN0071','turn421284search3');
INSERT INTO process_diagram_evidence VALUES('DE014-025','D014-006','W0092','turn421284search3','拟审批','S,T,V','对应流股及已披露单元；非实际运行推断');
INSERT INTO membrane_reviews VALUES('MR014-006','CN0071','D014-006','six_streams_recovery','design','2024拟审批',1,'not_identified','turn421284search3','2024 6万吨废剂处置设计，分质能力非实际进水，不能直接相加为总量','深度处理单元、终端膜类型、实际验收、危废及盐平衡待核','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA014-006','MR014-006','CN0071','six_streams_recovery','screening',1,'分质减量/资源化/回用初筛','先核深度处理实际工艺与重金属回收，再比较高盐3号线NF/ED或RO预浓缩及低盐回用；不将不同金属水混合','conditional','须先核设施现状、回用需求及盐/浓水合规，方案非已建','INFERRED；D014-006；对应来源及流股','保留已知预处理和生产回收；不认定现行投运','各线真实流量、Ni/贵金属/氨/盐、pH、已建深度处理设备、膜浓水与盐处置','连续多工况采样与物料衡算；膜小试/CIP、结垢和盐品纯度验证；核真实设备及电汽药耗、处置费、回用收益','原工艺优化、直接分质回用、委外或纳管合规比较',2,1,NULL,NULL,NULL,NULL,'重金属和高盐有明确分质设计；预处理后可行性仍需采样','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0183','turn106948search0');
INSERT INTO wastewater VALUES('W014-020','CN0183','铂钯回收综合生产废水','2026-03最终批复设计',5,'t/h','MVR废水系统设计能力','贵金属母液、酸碱、盐','专用明管收集；中和、沉淀、压滤、MVR','冷凝水全回用不外排（设计）','拟审批明确蒸发混盐危废','turn106948search0','WEB_PRIMARY','辽环函2026第14号第二（二）款；纯回收项目，非催化剂成品');
INSERT OR IGNORE INTO site_sources VALUES('CN0183','turn106948search0');
INSERT INTO wastewater VALUES('W014-021','CN0183','生活污水及预处理后初雨','2026-03最终批复设计',NULL,NULL,NULL,NULL,'化粪池/初雨专项站后汇合','抚顺高新东泽污水处理有限公司',NULL,'turn106948search0','WEB_PRIMARY','生活水及初雨外排，不把生产回用称全厂零排放');
INSERT INTO water_metrics VALUES('M014-039','CN0183',NULL,'拟审批公示设施','初雨池',800,NULL,'m³','设计容积',NULL,'2026-03',NULL,NULL,'turn106948search1','非处理流量；以最终验收为准');
INSERT INTO water_metrics VALUES('M014-040','CN0183',NULL,'拟审批公示设施','事故池',1118,NULL,'m³','设计容积',NULL,'2026-03',NULL,NULL,'turn106948search1','非处理流量；以最终验收为准');
INSERT INTO water_metrics VALUES('M014-041','CN0183',NULL,'拟审批公示设施','应急储罐',60,NULL,'m³','设计容积',NULL,'2026-03',NULL,NULL,'turn106948search1','非处理流量；以最终验收为准');
INSERT OR IGNORE INTO site_sources VALUES('CN0183','turn106948search0');
INSERT INTO evidence_notes VALUES('N014-006','CN0183','turn106948search0','项目性质及回用','最终批复第一、二（二）款','2000t/a含铂和1200t/a含钯废催化剂为处置分项，产物为海绵铂/钯和副产硫酸铝水处理剂；用于内部生产催化剂。5t/h生产废水站、15t/h初雨站分开；生产冷凝水回用；生活及初雨纳管。纯水RO与工艺污水膜不同。','WEB_PRIMARY','事实摘录；非原件全文','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0183','turn106948search0');
INSERT INTO process_diagrams VALUES('D014-007','CN0183','precious_recovery_mvr','design','2026最终批复',1,'partial','flowchart TD
 A["铂钯生产母液/冲洗/软纯水排水"] --> B["中和 沉淀 压滤"] --> C["MVR 5t/h设计站"] --> D["冷凝水回生产"]
 C --> E["混盐危废（拟审批）"]
 F["初期雨水"] --> G["中和 沉淀 压滤 15t/h设计"] --> H["总排口 东泽污水厂"]
 I["生活污水"] --> J["化粪池"] --> H','turn106948search0','纯资源回收；生产回用、初雨生活纳管；5t/h与15t/h不可相加','实际投运、母液酸/盐及贵金属含量、MVR费用、混盐鉴别待核','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0183','turn106948search0');
INSERT INTO process_diagram_evidence VALUES('DE014-026','D014-007','W014-020','turn106948search0','第二（二）款','A,B,C,D','对应流股及已披露单元；非实际运行推断');
INSERT OR IGNORE INTO site_sources VALUES('CN0183','turn106948search1');
INSERT INTO process_diagram_evidence VALUES('DE014-027','D014-007','W0033','turn106948search1','拟审批','F,G,H','对应流股及已披露单元；非实际运行推断');
INSERT OR IGNORE INTO site_sources VALUES('CN0183','turn106948search0');
INSERT INTO process_diagram_evidence VALUES('DE014-028','D014-007','W014-021','turn106948search0','第二（二）款','I,J,H','对应流股及已披露单元；非实际运行推断');
INSERT INTO membrane_reviews VALUES('MR014-007','CN0183','D014-007','precious_recovery_mvr','design','2026最终批复',1,'not_identified','turn106948search0','纯资源回收；生产回用、初雨生活纳管；5t/h与15t/h不可相加','实际投运、母液酸/盐及贵金属含量、MVR费用、混盐鉴别待核','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA014-007','MR014-007','CN0183','precious_recovery_mvr','screening',1,'分质减量/资源化/回用初筛','先核金属回收率和混盐危废；按中和压滤后水质试NF/ED/RO预浓缩以减蒸发，不替代现有金属回收','conditional','须先核设施现状、回用需求及盐/浓水合规，方案非已建','INFERRED；D014-007；对应来源及流股','保留已知预处理和生产回收；不认定现行投运','母液分股、水质波动、膜耐酸、盐危废费用、蒸发运行费、真实产水','连续多工况采样与物料衡算；膜小试/CIP、结垢和盐品纯度验证；核真实设备及电汽药耗、处置费、回用收益','原工艺优化、直接分质回用、委外或纳管合规比较',2,1,2,NULL,NULL,NULL,'贵金属/盐和危废混盐设计约束；已设中和压滤','2026-11-27');
INSERT INTO search_log VALUES('L014-005','CN0183','W01-B4/W11-B5','中石化抚顺 3200吨 贵金属 最终批复 5吨/小时','turn106948search0','最终批复核产物、5t/h站与15t/h初雨，不认作新制造厂','竣工验收及盐危废处置','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0213','W05S02');
INSERT INTO process_diagrams VALUES('D014-008','CN0213','mixed_organic_treatment','design','2025拟审批',1,'partial','flowchart TD
 A["二烯烃及烯醇工艺废水"] --> B["芬顿 pH调节 混凝沉淀"] --> C["综合厌氧"]
 D["催化剂及清洗、化验、公用、生活废水"] --> C
 C --> E["缺氧"] --> F["曝气"] --> G["二沉"] --> H["淮安同方盐化工业污水厂"]','W05S02','混合产品厂；芬顿只属于其他两类产品，不归为催化剂专用','实际工艺投运及催化剂水量、溶剂/盐/芬顿残留待核','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0213','W05S02');
INSERT INTO process_diagram_evidence VALUES('DE014-029','D014-008','W0169','W05S02','拟审批水措施','C,D,E,F,G,H','对应流股及已披露单元；非实际运行推断');
INSERT OR IGNORE INTO site_sources VALUES('CN0213','W05S02');
INSERT INTO process_diagram_evidence VALUES('DE014-030','D014-008','W0170','W05S02','拟审批水措施','A,B,C','对应流股及已披露单元；非实际运行推断');
INSERT INTO membrane_reviews VALUES('MR014-008','CN0213','D014-008','mixed_organic_treatment','design','2025拟审批',1,'not_identified','W05S02','混合产品厂；芬顿只属于其他两类产品，不归为催化剂专用','实际工艺投运及催化剂水量、溶剂/盐/芬顿残留待核','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA014-008','MR014-008','CN0213','mixed_organic_treatment','screening',1,'分质减量/资源化/回用初筛','若有回用需求，在二沉后测试UF/RO；高浓有机溶剂先分质回收，不直接上膜','conditional','须先核设施现状、回用需求及盐/浓水合规，方案非已建','INFERRED；D014-008；对应来源及流股','保留已知预处理和生产回收；不认定现行投运','实测COD、溶剂、盐、芬顿残铁、回用需求、浓水及费用','连续多工况采样与物料衡算；膜小试/CIP、结垢和盐品纯度验证；核真实设备及电汽药耗、处置费、回用收益','原工艺优化、直接分质回用、委外或纳管合规比较',NULL,NULL,NULL,NULL,NULL,NULL,'不足以评分，未知留空','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0043','W07S19');
INSERT INTO process_diagrams VALUES('D014-009','CN0043','precious_refining_reuse','design','2024拟审批',1,'partial','flowchart TD
 A["铑精炼洗水/贵金属母液/喷淋及清洗"] --> B["三效蒸发及膜处理组合"] --> C["回用"]
 B --> D["浓液/残盐去向待核"]
 E["Pt/C制备洗水"] --> F["独立纳管 胜科水务"]','W07S19','贵金属精炼回用与Pt/C制备洗水分别；串并联及膜具体类型待核','膜型、压力、流量、盐及贵金属回收、投运待核','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0043','W07S19');
INSERT INTO process_diagram_evidence VALUES('DE014-031','D014-009','W0264','W07S19','2024拟审批','A,B,C','对应流股及已披露单元；非实际运行推断');
INSERT OR IGNORE INTO site_sources VALUES('CN0043','W07S19');
INSERT INTO process_diagram_evidence VALUES('DE014-032','D014-009','W0263','W07S19','2024拟审批','E,F','对应流股及已披露单元；非实际运行推断');
INSERT INTO membrane_reviews VALUES('MR014-009','CN0043','D014-009','precious_refining_reuse','design','2024拟审批',1,'confirmed_present','W07S19','贵金属精炼回用与Pt/C制备洗水分别；串并联及膜具体类型待核','膜型、压力、流量、盐及贵金属回收、投运待核','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0043','W07S19');
INSERT INTO membrane_units VALUES('MU014-008','MR014-009','精炼废水膜','UNSPECIFIED','回用','贵金属精炼等水','回用',NULL,'具体膜型与三效连接不明','W07S19','2024拟审批','仅该时期及支流');
INSERT INTO membrane_retrofits VALUES('RA014-009','MR014-009','CN0043','precious_refining_reuse','screening',1,'分质减量/资源化/回用初筛','优先确认现有膜类型和贵金属回收，不以未明工艺推荐重复RO；Pt/C独立水测金属后评估回用','conditional','须先核设施现状、回用需求及盐/浓水合规，方案非已建','INFERRED；D014-009；对应来源及流股','保留已知预处理和生产回收；不认定现行投运','实际膜单元、盐、酸碱、铑铂残留、蒸发热耗、浓盐处置','连续多工况采样与物料衡算；膜小试/CIP、结垢和盐品纯度验证；核真实设备及电汽药耗、处置费、回用收益','原工艺优化、直接分质回用、委外或纳管合规比较',NULL,NULL,NULL,NULL,NULL,NULL,'不足以评分，未知留空','2026-11-27');
COMMIT;
