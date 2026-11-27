-- 015: corporate disclosure triangulation; period and shared boundaries
BEGIN;
INSERT INTO sources VALUES('W15S01','宇新股份2024年半年度报告（全文）','https://vip.stock.finance.sina.com.cn/corp/view/vCB_AllBulletinDetail.php?id=10388333&stockid=002986','上市公司定期报告','2024-08','博科混合生产厂环保设施、排放口污染物总量、建设状态','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0104','W15S01');
INSERT INTO sources VALUES('W15S02','宇新股份2025年年度报告（全文）','https://vip.stock.finance.sina.com.cn/corp/view/vCB_AllBulletinDetail.php?id=12227347','上市公司定期报告','2026-04','主要控股参股公司情况说明：博科顺酐催化剂闲置、铜系停产','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0104','W15S02');
INSERT INTO sources VALUES('W15S03','宇新股份2026年半年度报告（全文）','https://vip.stock.finance.sina.com.cn/corp/view/vCB_AllBulletinDetail.php?id=12549003&stockid=002986','上市公司定期报告','2026-08-27','产品描述及风险，未见铜系复产证据；不以集团化工装置投产代替催化剂复产','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0104','W15S03');
INSERT INTO sources VALUES('W15S04','淄博生态环境局齐鲁科力翔力8000吨催化材料项目拟审批公示','https://epb.zibo.gov.cn/gongkai/channel_c_5f9fa491ab327f36e4c13066_n_1605682664.7259/doc_68da4ce4007883bc74a39abe.html','政府环评拟审批','2025','政府页面检索摘录；复开超时；公用水与工艺废水分流，非验收','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0022','W15S04');
INSERT INTO sources VALUES('W15S05','齐翔腾达关于控股子公司8000吨高性能催化新材料项目建成投产公告','https://money.finance.sina.com.cn/corp/view/vCB_AllBulletinDetail.php?id=11950549&stockid=002408','上市公司临时公告','2026-02-04','建成并进入试运行、未证明达产或环保验收','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0022','W15S05');
INSERT INTO sources VALUES('W15S06','山东能源新材料：齐翔腾达绿色工厂建设','https://sdnyxcl.shandong-energy.com/232085/232095/2026/04/43343504.html','集团官方报道','2026-04-24','园区共用800m³/h UF/RO设施及2025回用量；不归属催化剂厂独占','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0022','W15S06');
INSERT INTO sources VALUES('W15S07','齐翔腾达3万吨/年异丙醇新材料技改环评','https://epb.zibo.gov.cn/gongkai/channel_c_5f9fa491ab327f36e4c13066_n_1605682663.2363/doc_69830ec6f84e0d9db0c7a810_59fd7529345513ec35493308cc9ea553.pdf','政府公开环评','2026','同园区异丙醇项目对共享站现有设施的描述；检索全文可见，复开超时，未复核PDF图页','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0022','W15S07');
INSERT INTO wastewater VALUES('W015-001','CN0104','混合化工厂生产废水预处理','2024H1报告期运行',NULL,NULL,'非催化剂独立流量','COD、氨氮、THF','电催化芬顿与电化学催化膜反应器耦合氧化、水解酸化、接触氧化、臭氧氧化','惠州新材料产业园区污水处理厂',NULL,'W15S01','WEB_COMPANY','2023年3月调试，5月组织环保验收；报告期称COD稳定达标，不能据此认定催化剂线验收或2026现况');
INSERT INTO wastewater VALUES('W015-002','CN0104','全厂厂界间接排放口','2024H1报告期',NULL,NULL,'无实际流量','COD、氨氮、THF','经厂区污水预处理','园区污水处理厂',NULL,'W15S01','WEB_COMPANY','一处厂界水排口，报告期排放量为全厂，非独立催化剂');
INSERT INTO water_metrics VALUES('M015-001','CN0104','W015-002','厂界','COD排放总量',0.0219,NULL,'t','报告期实际披露总量',NULL,'2024H1',NULL,NULL,'W15S01','厂区总量非浓度；核定9.2989t，接管500mg/L');
INSERT INTO water_metrics VALUES('M015-002','CN0104','W015-002','厂界','氨氮排放总量',0.0001,NULL,'t','报告期实际披露总量',NULL,'2024H1',NULL,NULL,'W15S01','厂区总量；核定1.2399t，接管45mg/L');
INSERT INTO water_metrics VALUES('M015-003','CN0104','W015-002','厂界','COD核定总量',9.2989,NULL,'t','报告核定总量',NULL,'2024H1',NULL,NULL,'W15S01','核定周期原表未细分，不作实测');
INSERT INTO water_metrics VALUES('M015-004','CN0104','W015-002','厂界','氨氮核定总量',1.2399,NULL,'t','报告核定总量',NULL,'2024H1',NULL,NULL,'W15S01','核定周期原表未细分，不作实测');
INSERT INTO water_metrics VALUES('M015-005','CN0104','W015-002','厂界','COD接管限值',500,NULL,'mg/L','接管标准',NULL,'2024H1',NULL,500,'W15S01','非实测浓度');
INSERT INTO water_metrics VALUES('M015-006','CN0104','W015-002','厂界','氨氮接管限值',45,NULL,'mg/L','接管标准',NULL,'2024H1',NULL,45,'W15S01','非实测浓度');
INSERT INTO claims VALUES('CL015-001','CN0104','催化剂装置状态','500t/a顺酐催化剂装置已建但因市场原因暂未开工；1500t/a铜系装置2025年4月停产','WEB_COMPANY','W15S02','2025年报；2026H1未取得明确复产证据；300t/a贵金属项目现状待查','2026-11-27');
INSERT INTO claims VALUES('CL015-002','CN0104','混合厂污水膜类型','电化学催化膜反应器耦合氧化，非UF/RO等压力驱动分离膜','WEB_COMPANY','W15S01','2024H1全厂预处理报告，非催化剂专线','2026-11-27');
INSERT INTO evidence_notes VALUES('N015-001','CN0104','W15S01','历史工艺与报告排放边界','环境和社会部分','2023年3月设施建成调试、5月组织环保验收，2024H1披露运行稳定；铜1500、贵金属300项目仍建设中，拟配污水/中水设施，不能将该项目设想标为已建膜。厂界COD、氨氮总量已分项入库；表内浓度范围为接管控制值，不认作实测。','WEB_COMPANY','事实摘录；非原件全文','2026-11-27');
INSERT INTO evidence_notes VALUES('N015-002','CN0104','W15S02','停产与未开工更正','主要控股参股公司情况说明','2025年末披露顺酐催化剂500t/a暂未开工、铜系1500t/a于2025-04停产，保留名义规模但不作为当前产量。2026年半年报复查未确认铜系复产或贵金属投运。','WEB_COMPANY','事实摘录；非原件全文','2026-11-27');
INSERT INTO capacity VALUES('C015-001','CN0104','顺酐催化剂',500,'t/a','建成装置规模；2025年报暂未开工','2025年报','非产量','W15S02','市场原因，现行状态待核');
INSERT INTO capacity VALUES('C015-002','CN0104','铜系催化剂',1500,'t/a','建成规模；2025-04停产','2025年报','非产量','W15S02','复产待核');
INSERT INTO capacity VALUES('C015-003','CN0104','贵金属催化剂',300,'t/a','2024H1建设中项目','2024H1','非投产','W15S01','2025/26项目最新状态未知');
UPDATE sites SET status='催化剂线停产/未开工（2025年报；复产待核）',capacity_summary='顺酐500t/a暂未开工；铜系1500t/a于2025-04停产；贵金属300t/a项目状态待核',water_summary='2024H1混合厂预处理：电催化膜耦合芬顿、水解酸化、接触氧化、臭氧；纳园区，催化剂专线待核',water_level='有工艺线索',source_status='公司报告分期核实；2026现场待核',as_of='2026-11-27' WHERE site_id='CN0104';
INSERT INTO process_diagrams VALUES('D015-001','CN0104','mixed_plant_electrochemical','operating','2024H1',1,'partial','flowchart TD
A[混合厂生产废水] --> B[电催化芬顿及电化学催化膜耦合氧化]
B --> C[水解酸化]
C --> D[接触氧化]
D --> E[臭氧氧化]
E --> F[厂界间接排口]
F --> G[园区污水处理厂]','W15S01','历史报告期混合厂；非催化剂专线及2026现状','实际水量、催化膜材料/功能、铜/贵金属项目新增设施及复产待核','2026-11-27');
INSERT INTO process_diagram_evidence VALUES('DE015-001','D015-001','W015-001','W15S01','环境和社会；设施段','A,B,C,D,E,F,G','报告期工艺链与间接排放；非催化剂专属');
INSERT INTO process_diagram_evidence VALUES('DE015-002','D015-001','W015-002','W15S01','污染物排放表','F,G','全厂一处水排口；不推算流量');
INSERT INTO membrane_reviews VALUES('MR015-001','CN0104','D015-001','mixed_plant_electrochemical','operating','2024H1',1,'confirmed_present','W15S01','披露电化学催化膜反应器用于氧化；不是已证实的分离膜','膜规格、是否另设UF/RO、中水回用及现行工艺待核','2026-11-27');
INSERT INTO membrane_units VALUES('MU015-001','MR015-001','电化学催化膜反应器','OTHER','耦合氧化反应；非压力分离','混合生产污水',NULL,NULL,'未披露膜材/通量/截留','W15S01','环保设施段','不认作UF/RO/MBR');
INSERT INTO membrane_retrofits VALUES('RA015-001','MR015-001','CN0104','mixed_plant_electrochemical','screening',1,'既有设施核实/分质回用优化','先查催化剂线复产与独立废水；混合厂已氧化/生化出水若确有回用需求再评UF/RO，不以电化学膜替代除盐','conditional','实际负荷、兼容性、接管及浓水合规前不得确认技术可行','INFERRED；D015-001；对应来源及流股','现有披露不是当前实测；方案非已建','复产状态、专线水量、金属/盐/有机物、现有中水设备、浓水与成本','现场核实设备/接口，连续采样和水盐衡算；小试、CIP、重金属及浓水处置验证；核成本与回用收益','维持现有工艺、源头分流，停产线不建议预先投资',NULL,NULL,NULL,NULL,NULL,NULL,'资料不足不打分','2026-11-27');
INSERT INTO search_log VALUES('L015-001','CN0104','W01-B5/W11-B6','宇新股份 2024H1 2025年报 2026H1 博科 催化剂 电催化膜','W15S01','确认混合厂历史工艺和年报停产状态；2026复产未明确','复产公告、项目验收、专线水量及成本','2026-11-27');
INSERT INTO wastewater VALUES('W015-003','CN0022','翔力项目循环冷却/脱盐水公用排水','2025环评设计',NULL,NULL,'项目支流未披露；800m³/h为共享设施','盐','依托800m³/h共享回用装置；设计75%回用，余浓水送金山','锅炉/循环水及金山污水场',NULL,'W15S04','WEB_PRIMARY','仅拟审批检索摘录，复开超时；实际接管、回用率待验收，不将共享规模算为翔力水量');
INSERT INTO wastewater VALUES('W015-004','CN0022','翔力项目工艺洗涤及地面清洁等废水','2025环评设计',NULL,NULL,'未取得独立水量',NULL,'集中收集纳管','金山污水处理场',NULL,'W15S04','WEB_PRIMARY','生产水、生活及初雨接管边界据检索摘要；实际待验收');
INSERT INTO wastewater VALUES('W015-005','CN0022','关联园区共享污水回用装置','2026-04官方报道',800,'m³/h','共享站设计/标称处理能力','公用排水及部分园区污水出水','UF、RO','循环水回用','浓水至金山按共享站环评','W15S06','WEB_COMPANY','整个齐翔腾达园区，不是催化剂项目独占设备/流量；2025回用量早于8000项目试运行');
INSERT INTO wastewater VALUES('W015-006','CN0022','关联园区金山污水场','2026-04官方报道',30000,'m³/d','共享园区设施处理能力',NULL,'园区集中处理','园区排放',NULL,'W15S06','WEB_COMPANY','非翔力专属；另有2026环评520+720m³/h口径，不重复求和');
INSERT INTO water_metrics VALUES('M015-007','CN0022','W015-003','共享回用设计','回用率',75,NULL,'%','环评设计',NULL,'2025',NULL,NULL,'W15S04','设计口径非实测');
INSERT INTO water_metrics VALUES('M015-008','CN0022','W015-005','全园区共享站','回用污水量',3950000,NULL,'t/a','公司披露历史全年回用量',NULL,'2025',NULL,NULL,'W15S06','不能分配给2026新项目；质量不折算体积');
INSERT INTO water_metrics VALUES('M015-009','CN0022','W015-006','金山污水场','外排水质达标率',100,NULL,'%','公司披露历史全年达标率',NULL,'2025',NULL,NULL,'W15S06','非独立第三方检测');
INSERT INTO claims VALUES('CL015-003','CN0022','项目投运阶段','8000t/a高性能催化新材料项目已建成，2026-02-04公告进入试运行','WEB_COMPANY','W15S05','关联主体公告，非环保验收及稳定达产','2026-11-27');
INSERT INTO claims VALUES('CL015-004','CN0022','共享膜装置','关联园区UF+RO回用装置800m³/h；2025年度回用污水395万吨','WEB_COMPANY','W15S06','共享设施，不能证明翔力催化剂专线膜或2026项目实际回用','2026-11-27');
INSERT INTO evidence_notes VALUES('N015-003','CN0022','W15S04','设计分股及原旧项目','拟审批检索正文','8000t/a拟建项目含尾气加氢3000、混捏4000及浸渍1000吨分项，旧4000批复废止不叠加；工艺/生活/初雨纳管与公用回用分流。政府页面复开超时，等待完整原件。','WEB_PRIMARY','事实摘录；非原件全文','2026-11-27');
INSERT INTO evidence_notes VALUES('N015-004','CN0022','W15S07','关联园区共享站原有工艺','800m³/h污水回用改造项目、园区污水处理场小节','环评检索正文显示调节、高密度沉淀、V型过滤、UF、RO；浓水经调节入金山。园区金山一期520、二期720m³/h；均属共享设施。复开超时，原图未核；与2026报道800m³/h及3万m³/d能力相互支持，不把异丙醇厂废水归为催化剂水。','WEB_PRIMARY','事实摘录；非原件全文','2026-11-27');
INSERT INTO capacity VALUES('C015-004','CN0022','高性能催化新材料',8000,'t/a','2026-02公告建成进入试运行','2026-02','非稳定产量','W15S05','旧4000项目不叠加');
INSERT INTO projects VALUES('P015-001','CN0022','8000吨/年高性能催化新材料项目','建成试运行','2026-02-04','8000t/a装置规模','2025拟审批有共享站设计，实际水处理验收待查','W15S05');
UPDATE sites SET status='2026-02公告建成试运行；环保验收待核',capacity_summary='8000t/a建成试运行；原4000批复废止不叠加',water_summary='2025设计：公用排水共享回用，工艺水纳金山；关联园区800m³/h UF/RO与本厂独立膜区分',water_level='有工艺线索',source_status='项目试运行公告和园区工艺已核；环评复开超时',as_of='2026-11-27' WHERE site_id='CN0022';
INSERT INTO process_diagrams VALUES('D015-002','CN0022','xiangli_project_water_boundary','design','2025拟审批',1,'partial','flowchart TD
A[项目公用冷却及脱盐排水] --> B[依托园区800m³/h回用设施]
B --> C[回用至锅炉及循环水]
B --> D[浓水至金山]
E[项目生产废水及其他纳管流股] --> D','W15S04','项目环评设计分流；共享站非独占；非试运行废水验收','项目环评原件、分股水量与实际接管、是否另设膜待核','2026-11-27');
INSERT INTO process_diagram_evidence VALUES('DE015-003','D015-002','W015-003','W15S04','拟审批检索正文','A,B,C,D','公用支路设计依托共享站');
INSERT INTO process_diagram_evidence VALUES('DE015-004','D015-002','W015-004','W15S04','拟审批检索正文','E,D','工艺与其他纳管流股');
INSERT INTO membrane_reviews VALUES('MR015-002','CN0022','D015-002','xiangli_project_water_boundary','design','2025拟审批',1,'not_identified','W15S04','项目自身膜未识别；依托共享站不等于独立膜','实际接管及专线设施待核','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA015-002','MR015-002','CN0022','xiangli_project_water_boundary','screening',1,'既有设施核实/分质回用优化','先查现行分质及接管；共享公用回用优先，不假定工艺废水可送共享RO；有高盐或重金属分流证据后评估膜','conditional','实际负荷、兼容性、接管及浓水合规前不得确认技术可行','INFERRED；D015-002；对应来源及流股','现有披露不是当前实测；方案非已建','生产废水源强、金属/盐、接管条件、共享站剩余能力、回用需求和浓水费用','现场核实设备/接口，连续采样和水盐衡算；小试、CIP、重金属及浓水处置验证；核成本与回用收益','既有共享处理、分质预处理或合规纳管比较',NULL,NULL,NULL,NULL,NULL,NULL,'资料不足不打分','2026-11-27');
INSERT INTO process_diagrams VALUES('D015-003','CN0022','shared_qixiang_utility_reuse','operating','2026-04报道/2026环评既有',1,'partial','flowchart TD
A[全园区公用水及部分金山处理出水] --> B[调节及高密度沉淀]
B --> C[V型滤池]
C --> D[UF]
D --> E[RO]
E --> F[园区回用]
E --> G[RO浓水经调节入金山]
H[其他园区废水] --> I[金山污水场]
G --> I','W15S06','关联园区现有运行设施；独立于翔力专线；800m³/h为共享能力','报告期来源为公司披露；2026环评既有工艺文本复开超时；具体回用比例/实际催化剂进水待核','2026-11-27');
INSERT INTO process_diagram_evidence VALUES('DE015-005','D015-003','W015-005','W15S06','2026-04官方报道','D,E,F','共享膜UF/RO及回用');
INSERT INTO process_diagram_evidence VALUES('DE015-006','D015-003',NULL,'W15S07','800m³/h回用改造项目检索正文','A,B,C,D,E,G,I','环评既有共享设施流程；不归属异丙醇项目水量');
INSERT INTO process_diagram_evidence VALUES('DE015-007','D015-003','W015-006','W15S06','2026-04官方报道','I','共享处理场规模');
INSERT INTO membrane_reviews VALUES('MR015-003','CN0022','D015-003','shared_qixiang_utility_reuse','operating','2026-04报道/2026环评既有',1,'confirmed_present','W15S06','共享站UF、RO；不等于催化剂专线已运行膜','分配流量、装置压力/回收率、浓水实测及剩余能力','2026-11-27');
INSERT INTO membrane_units VALUES('MU015-002','MR015-003','共享回用UF','UF','RO预处理','共享预处理出水','RO',NULL,'共享800m³/h非UF独立额定量','W15S06','集团报道','共享设施非翔力专线');
INSERT INTO membrane_units VALUES('MU015-003','MR015-003','共享回用RO','RO','除盐回用','UF产水','园区回用','金山（环评既有说明）','实际压力/回收率待核','W15S07','800m³/h既有装置检索正文','共享设施非翔力专线');
INSERT INTO membrane_retrofits VALUES('RA015-003','MR015-003','CN0022','shared_qixiang_utility_reuse','screening',1,'既有设施核实/分质回用优化','优化现有共享膜负荷与高密度沉淀，先核浓水接管；不重复建设专线RO或把园区回用收益算作催化剂收益','conditional','实际负荷、兼容性、接管及浓水合规前不得确认技术可行','INFERRED；D015-003；对应来源及流股','现有披露不是当前实测；方案非已建','回用需求、各厂分配、实际流量和水质、药剂/电耗、浓水接管及成本','现场核实设备/接口，连续采样和水盐衡算；小试、CIP、重金属及浓水处置验证；核成本与回用收益','现有站优化、清洁水直接回用和独立高盐分流比较',NULL,NULL,NULL,NULL,NULL,NULL,'资料不足不打分','2026-11-27');
INSERT INTO search_log VALUES('L015-002','CN0022','W01-B5/W11-B6','齐鲁科力翔力 8000吨 试运行 齐翔腾达 800m3/h UF RO 金山','W15S05','试运行公告；园区膜与本厂专线区分，拟审批及PDF复开超时','验收监测、环评完整版及共享设施实际接管','2026-11-27');
UPDATE sites SET address='大连长兴岛经济区化工园区（首次公示转载）' WHERE site_id='CN0246';
INSERT INTO claims VALUES('CL015-005','CN0246','厂址','大连长兴岛经济区化工园区，三期位于现有厂区北侧预留地','WEB_SECONDARY','W13S05','首次公示转载，非坐标或不动产权确认','2026-11-27');
INSERT INTO search_log VALUES('L015-003','CN0246','W01-B5/W11-B6','延长中科大连三期首次公示 厂区位置','W13S05','原已登记来源中补核厂址；不新增主体/来源','三期正式环评及批复','2026-11-27');
COMMIT;
