BEGIN;
INSERT OR IGNORE INTO site_sources VALUES('CN0030','turn127831search4');
INSERT INTO wastewater VALUES('W017-001','CN0030','非酸综合废水','2021招股书披露',NULL,NULL,NULL,'COD、SS、氨氮、重金属等','组合滤床、混凝、沉淀、水解酸化、调节、UASB、接触氧化、二沉','末端园区去向依原披露；非酸支路具体排口待核','污泥脱水后有资质单位处置','turn127831search4','WEB_COMPANY','报告期历史工艺；不外推至当前');
INSERT OR IGNORE INTO site_sources VALUES('CN0030','turn127831search4');
INSERT INTO wastewater VALUES('W017-002','CN0030','含氨废水','2021招股书披露',NULL,NULL,NULL,'氨氮','吹氨','废水处理池',NULL,'turn127831search4','WEB_COMPANY','吹氨后具体接入单元未披露');
INSERT OR IGNORE INTO site_sources VALUES('CN0030','turn127831search4');
INSERT INTO evidence_notes VALUES('N017-001','CN0030','turn127831search4','环保费用边界','招股说明书1-1-121','截至2020-06-30环保设施原值772.97万元；2017、2018、2019、2020H1全公司环保费用分别58.55、102.81、112.66、45.44万元（含摊销及当期费用）；非污水专属成本，不计入水处理吨成本。','WEB_COMPANY','关键内容提取；来源见索引','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0030','turn127831search4');
INSERT INTO process_diagrams VALUES('D017-001','CN0030','acid_wastewater_2021','historical','2021招股书报告期',1,'partial','flowchart TD
A[含酸废水] --> B[微电解] --> C[芬顿] --> D[两级吹脱] --> E[园区管网]','turn127831search4','酸性支路，历史披露','流量、进出水、药耗及现状','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0030','turn127831search4');
INSERT INTO process_diagram_evidence VALUES('DE017-001','D017-001','W0028','turn127831search4','环保防治措施','A,B,C,D,E','对应来源及流股');
INSERT INTO membrane_reviews VALUES('MR017-001','CN0030','D017-001','acid_wastewater_2021','historical','2021招股书报告期',1,'not_identified','turn127831search4','酸性支路，历史披露','流量、进出水、药耗及现状','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA017-001','MR017-001','CN0030','acid_wastewater_2021','screening',1,'分质回用/资源化与改造筛选','优先验证酸性废水除重金属和吹氨效果；如需回用，评估稳定预处理后NF/RO及浓液处置','conditional','先核实际工艺、兼容性、回用需求与浓水合规；推断非事实','INFERRED；D017-001及图证据','仅按已查流股判断，不推断其他未查单元','金属形态、pH、盐度、膜污染与危废成本','分时采样与物料衡算；验证膜通量、CIP、浓水去向、能耗和费用','维持原分质工艺与源头减量；非膜方案',NULL,NULL,NULL,NULL,NULL,NULL,'实际工程参数不齐；不虚构难度','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0030','turn127831search4');
INSERT INTO process_diagrams VALUES('D017-002','CN0030','other_and_ammonia_2021','historical','2021招股书报告期',1,'partial','flowchart TD
A[其他废水] --> B[组合滤床] --> C[混凝沉淀] --> D[水解酸化] --> E[调节] --> F[UASB] --> G[接触氧化] --> H[二沉]
I[含氨废水] --> J[吹氨] --> K[废水处理池，接入点待核]','turn127831search4','其他与含氨支路，接入点不假设','现有水量、盐和排口','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0030','turn127831search4');
INSERT INTO process_diagram_evidence VALUES('DE017-002','D017-002','W017-001','turn127831search4','环保防治措施','A,B,C,D,E,F,G,H','对应来源及流股');
INSERT OR IGNORE INTO site_sources VALUES('CN0030','turn127831search4');
INSERT INTO process_diagram_evidence VALUES('DE017-003','D017-002','W017-002','turn127831search4','环保防治措施','I,J,K','对应来源及流股');
INSERT INTO membrane_reviews VALUES('MR017-002','CN0030','D017-002','other_and_ammonia_2021','historical','2021招股书报告期',1,'not_identified','turn127831search4','其他与含氨支路，接入点不假设','现有水量、盐和排口','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA017-002','MR017-002','CN0030','other_and_ammonia_2021','screening',1,'分质回用/资源化与改造筛选','二沉后若有回用需求，比较UF/RO与原排水；氨支路先控制残余氨与盐','conditional','先核实际工艺、兼容性、回用需求与浓水合规；推断非事实','INFERRED；D017-002及图证据','仅按已查流股判断，不推断其他未查单元','排口与回用要求、流量、水质、浓水许可','分时采样与物料衡算；验证膜通量、CIP、浓水去向、能耗和费用','维持原分质工艺与源头减量；非膜方案',NULL,NULL,NULL,NULL,NULL,NULL,'实际工程参数不齐；不虚构难度','2026-11-27');
UPDATE sites SET water_summary=coalesce(water_summary||'；','')||'2021招股书分酸、非酸、含氨三类；历史全厂环保费用单列，非水专属',source_status='本轮证据补充',as_of='2026-11-27' WHERE site_id='CN0030';
INSERT INTO search_log VALUES('L017-001','CN0030','W01-B7/W11-B8','凯立 招股说明书 废水 环保费用','turn127831search4','回填另两支路及历史环保费用边界','查2025/2026厂区分项许可和水处理成本','2026-11-27');
INSERT INTO sources VALUES('S017-001','河南神马3000吨特种分子筛技改拟批准公示','https://sthjj.pds.gov.cn/contents/11426/709198.html','政府拟审批公示','2025-06-06','依托现有污水设施，分质路径、产品结构调整','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0144','S017-001');
INSERT OR IGNORE INTO site_sources VALUES('CN0144','S017-001');
INSERT INTO wastewater VALUES('W017-003','CN0144','一般浓度与氨预处理出水','2025技改设计',NULL,NULL,NULL,'氨氮等','压滤分离交换水洗盐析废水、设备洗水及氨预处理水进入厂站','尼龙新材料开发区市第三污水处理厂',NULL,'S017-001','WEB_PRIMARY','厂站具体单元未披露；依托现有设施');
INSERT OR IGNORE INTO site_sources VALUES('CN0144','S017-001');
INSERT INTO wastewater VALUES('W017-004','CN0144','循环冷却和纯水制备排水','2025技改设计',NULL,NULL,NULL,NULL,'总排口','管网',NULL,'S017-001','WEB_PRIMARY','纯水RO不是污水处理膜');
INSERT OR IGNORE INTO site_sources VALUES('CN0144','S017-001');
INSERT INTO evidence_notes VALUES('N017-002','CN0144','S017-001','产品结构与设施依托','项目概况及废水措施','技改保持特种分子筛3000t/a，其中无模板2450、有模板450、芳腈100；原钌10与负载贵金属110t/a另列，不因改造重复增计；投资6700万元为整个技改；水站依托既有。纯水废RO膜不算废水处理膜；生化污泥待鉴别。','WEB_PRIMARY','关键内容提取；来源见索引','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0144','S017-001');
INSERT INTO process_diagrams VALUES('D017-003','CN0144','high_salt_recovery_2025','design','2025-06拟批',1,'partial','flowchart TD
A[水合分子筛晶化及交换压滤高盐水] --> B[高效沉淀回收分子筛] --> C[硫酸中和] --> D[MVR蒸发] --> E[冷凝水全回生产]
D --> F[浓缩盐暂按危废，待鉴别]','S017-001','高盐流股闭路设计；不是全厂零排放','水盐平衡、实际盐品质、蒸汽/电耗和处理量','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0144','turn699489search9');
INSERT INTO process_diagram_evidence VALUES('DE017-004','D017-003','W0019','turn699489search9','设计高盐支路','A,B,C,D,E,F','对应来源及流股');
INSERT OR IGNORE INTO site_sources VALUES('CN0144','S017-001');
INSERT INTO process_diagram_evidence VALUES('DE017-005','D017-003',NULL,'S017-001','废水措施','A,B,C,D,E,F','对应来源及流股');
INSERT INTO membrane_reviews VALUES('MR017-003','CN0144','D017-003','high_salt_recovery_2025','design','2025-06拟批',1,'not_identified','S017-001','高盐流股闭路设计；不是全厂零排放','水盐平衡、实际盐品质、蒸汽/电耗和处理量','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA017-003','MR017-003','CN0144','high_salt_recovery_2025','screening',1,'分质回用/资源化与改造筛选','在充分回收分子筛后比较NF/RO或ED预浓缩与原MVR负荷，先核结垢和浓盐危废性质','conditional','先核实际工艺、兼容性、回用需求与浓水合规；推断非事实','INFERRED；D017-003及图证据','仅按已查流股判断，不推断其他未查单元','实测硅、盐、硬度、pH、蒸发负荷、盐处置费用','分时采样与物料衡算；验证膜通量、CIP、浓水去向、能耗和费用','维持原分质工艺与源头减量；非膜方案',NULL,NULL,NULL,NULL,NULL,NULL,'实际工程参数不齐；不虚构难度','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0144','S017-001');
INSERT INTO process_diagrams VALUES('D017-004','CN0144','ammonia_and_general_2025','design','2025-06拟批',1,'partial','flowchart TD
A[无模板高氨水] --> B[氨水回收] --> E[厂污水站]
C[有模板高氨水] --> D[循环吹脱] --> E
D --> F[氨气酸吸收制硫酸铵]
G[一般生产及洗水] --> E --> H[市第三污水厂]
I[冷却排水和纯水排水] --> J[总排口至管网]','S017-001','拟技改水路径；厂污水站内部未披露','氨回收浓度、站内单元、实际流量','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0144','turn699489search9');
INSERT INTO process_diagram_evidence VALUES('DE017-006','D017-004','W0020','turn699489search9','氨支路','A,B,C,D,F','对应来源及流股');
INSERT OR IGNORE INTO site_sources VALUES('CN0144','S017-001');
INSERT INTO process_diagram_evidence VALUES('DE017-007','D017-004','W017-003','S017-001','一般水','E,G,H','对应来源及流股');
INSERT OR IGNORE INTO site_sources VALUES('CN0144','S017-001');
INSERT INTO process_diagram_evidence VALUES('DE017-008','D017-004','W017-004','S017-001','公用水','I,J','对应来源及流股');
INSERT INTO membrane_reviews VALUES('MR017-004','CN0144','D017-004','ammonia_and_general_2025','design','2025-06拟批',1,'not_identified','S017-001','拟技改水路径；厂污水站内部未披露','氨回收浓度、站内单元、实际流量','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA017-004','MR017-004','CN0144','ammonia_and_general_2025','screening',1,'分质回用/资源化与改造筛选','氨先资源化，检测模板剂和盐分后评估分盐/回用；不将吹脱等同膜','conditional','先核实际工艺、兼容性、回用需求与浓水合规；推断非事实','INFERRED；D017-004及图证据','仅按已查流股判断，不推断其他未查单元','氨浓度、模板剂种类、一般废水水质和实际负荷','分时采样与物料衡算；验证膜通量、CIP、浓水去向、能耗和费用','维持原分质工艺与源头减量；非膜方案',NULL,NULL,NULL,NULL,NULL,NULL,'实际工程参数不齐；不虚构难度','2026-11-27');
UPDATE sites SET water_summary=coalesce(water_summary||'；','')||'2025技改高盐MVR与高氨回收/吹脱分图；公用水总排口；纯水RO非污水膜',source_status='本轮证据补充',as_of='2026-11-27' WHERE site_id='CN0144';
INSERT INTO search_log VALUES('L017-002','CN0144','W01-B7/W11-B8','神马 3000吨 分子筛 升级改造 高盐 氨回收','S017-001','分质流程与产品结构，旧源互证','取得技改验收、流量、硫酸铵及盐台账','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0198','W01B2S21');
INSERT INTO wastewater VALUES('W017-005','CN0198','含油污水预处理','2023环评设计',20,'m³/h','混合系统设计能力','油','除油、气浮','混合达接管要求后园区污水厂',NULL,'W01B2S21','WEB_PRIMARY','非催化剂专属');
INSERT OR IGNORE INTO site_sources VALUES('CN0198','W01B2S21');
INSERT INTO wastewater VALUES('W017-006','CN0198','循环冷却水排水预处理','2023环评设计',30,'m³/h','混合系统设计能力','结垢盐','流化床结晶','出水65%进回用单元；35%混合纳管','结晶盐危废综合利用','W01B2S21','WEB_PRIMARY','非催化剂专属；百分比不等于膜回收率');
INSERT OR IGNORE INTO site_sources VALUES('CN0198','W01B2S21');
INSERT INTO wastewater VALUES('W017-007','CN0198','混合回用水系统','2023环评设计',60,'m³/h','设计能力',NULL,'调节、高负荷生物流化床、高效沉淀、生物流化床、纤维束过滤、保安过滤、UF、RO','循环水补水；浓水混合纳管','污水站污泥按危废处置','W01B2S21','WEB_PRIMARY','与20/30/5m³/h支路有交叠，不相加；非催化剂专属');
INSERT OR IGNORE INTO site_sources VALUES('CN0198','W01B2S21');
INSERT INTO evidence_notes VALUES('N017-003','CN0198','W01B2S21','回用装置边界','拟批公示废水措施','催化剂工艺和碱洗、磺化及乙氧基化高浓水共用5m³/h预处理；混合回用设施60m³/h处理冷却预处理出水65%及其他雨水、地面洗水、磺化凝结水；RO浓水与三预处理排水合并纳管。65%是冷却支路比例，非RO回收率。','WEB_PRIMARY','关键内容提取；来源见索引','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0198','W01B2S21');
INSERT INTO process_diagrams VALUES('D017-005','CN0198','daily_chemical_shared_water_design','design','2023拟批',1,'partial','flowchart TD
A[催化剂工艺及碱洗与其他高浓水] --> B[混凝-气浮-电解芬顿-三效蒸发-干化 5m³/h]
C[含油水] --> D[除油气浮 20m³/h]
E[冷却排水] --> F[流化床结晶 30m³/h]
F -->|65%| G[回用单元60m³/h]
H[其他雨水地面洗水及磺化凝结水] --> G
G --> I[调节-高负荷生物流化床-高效沉淀-生物流化床]
I --> J[纤维束及保安过滤] --> K[UF] --> L[RO] --> M[循环水补水]
L -->|浓水| N[混合接管]
F -->|35%| N
B --> N
D --> N
N --> O[园区污水厂]','W01B2S21','综合日化项目共享系统；不是200t/a自用催化剂专线','投运、实测流量、膜材和回收率、浓水合规','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0198','W01B2S21');
INSERT INTO process_diagram_evidence VALUES('DE017-009','D017-005','W0130','W01B2S21','高浓预处理','A,B,N','对应来源及流股');
INSERT OR IGNORE INTO site_sources VALUES('CN0198','W01B2S21');
INSERT INTO process_diagram_evidence VALUES('DE017-010','D017-005','W017-005','W01B2S21','含油预处理','C,D,N','对应来源及流股');
INSERT OR IGNORE INTO site_sources VALUES('CN0198','W01B2S21');
INSERT INTO process_diagram_evidence VALUES('DE017-011','D017-005','W017-006','W01B2S21','冷却预处理','E,F,G,N','对应来源及流股');
INSERT OR IGNORE INTO site_sources VALUES('CN0198','W01B2S21');
INSERT INTO process_diagram_evidence VALUES('DE017-012','D017-005','W017-007','W01B2S21','回用水及混合纳管','G,H,I,J,K,L,M,N,O','对应来源及流股');
INSERT INTO membrane_reviews VALUES('MR017-005','CN0198','D017-005','daily_chemical_shared_water_design','design','2023拟批',1,'confirmed_present','W01B2S21','综合日化项目共享系统；不是200t/a自用催化剂专线','投运、实测流量、膜材和回收率、浓水合规','2026-11-27');
INSERT INTO membrane_units VALUES('MU017-001','MR017-005','超滤','UF','RO前颗粒去除','生化和过滤出水','RO进水',NULL,'未披露膜材面积通量','W01B2S21','回用单元','仅该时期及范围');
INSERT INTO membrane_units VALUES('MU017-002','MR017-005','反渗透','RO','回用除盐','UF出水','循环水补水','混合接园区污水厂','未披露实际回收率','W01B2S21','回用单元','仅该时期及范围');
INSERT INTO membrane_retrofits VALUES('RA017-005','MR017-005','CN0198','daily_chemical_shared_water_design','screening',1,'分质回用/资源化与改造筛选','核现有设计实施情况；优先按膜前有机物、盐负荷和浓水接管条件优化回用，避免重建已设计单元','conditional','先核实际工艺、兼容性、回用需求与浓水合规；推断非事实','INFERRED；D017-005及图证据','仅按已查流股判断，不推断其他未查单元','膜实际回收率、CIP、产水/浓水盐度、催化剂独立水量与成本','分时采样与物料衡算；验证膜通量、CIP、浓水去向、能耗和费用','维持原分质工艺与源头减量；非膜方案',NULL,NULL,NULL,NULL,NULL,NULL,'实际工程参数不齐；不虚构难度','2026-11-27');
UPDATE sites SET water_summary=coalesce(water_summary||'；','')||'共享5/20/30/60m³/h分系统与UF/RO设计详列，不累计为催化剂处理能力',source_status='本轮证据补充',as_of='2026-11-27' WHERE site_id='CN0198';
INSERT INTO search_log VALUES('L017-003','CN0198','W01-B7/W11-B8','金陵石化 高端日化 回用 UF RO 60','W01B2S21','回填共享分流、两膜和去向','查投用、验收、分装置流量','2026-11-27');
INSERT INTO sources VALUES('S017-002','山东虹彩32000吨新型石化助剂项目拟审批','https://epb.zibo.gov.cn/gongkai/channel_c_5f9fa491ab327f36e4c13066_n_1605682664.7259/doc_67c5712d5fd8f7e3b87172a6.html','政府拟审批','2025-03-03','项目分项及污水分质','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0099','S017-002');
INSERT INTO sources VALUES('S017-003','山东虹彩二期危险化学品行政许可通告','https://ajj.zibo.gov.cn/gongkai/channel_6181f249e122a9130cc002d2/doc_6a4374fae54729a2dab794d0.html','政府安全许可','2026-06-12','二期设计状态及新氨水提浓装置','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0099','S017-003');
INSERT OR IGNORE INTO site_sources VALUES('CN0099','S017-002');
INSERT INTO wastewater VALUES('W017-008','CN0099','高氨氮废水','2025拟批设计',NULL,NULL,NULL,'氨氮','氨水提浓','综合污水站',NULL,'S017-002','WEB_PRIMARY','未披露氨水产品去向');
INSERT OR IGNORE INTO site_sources VALUES('CN0099','S017-002');
INSERT INTO wastewater VALUES('W017-009','CN0099','高浓度难降解废水','2025拟批设计',NULL,NULL,NULL,'难降解有机物','芬顿、一体化生化','综合污水站',NULL,'S017-002','WEB_PRIMARY','设计而非实测');
INSERT OR IGNORE INTO site_sources VALUES('CN0099','S017-002');
INSERT INTO wastewater VALUES('W017-010','CN0099','混合预处理与其他工艺及公用水','2025拟批设计',NULL,NULL,NULL,NULL,'酸碱中和、混凝沉淀','园区污水处理厂深度处理',NULL,'S017-002','WEB_PRIMARY','多产品共享，非独立催化剂流量');
INSERT OR IGNORE INTO site_sources VALUES('CN0099','S017-003');
INSERT INTO evidence_notes VALUES('N017-004','CN0099','S017-003','二期设计状态','第27项','2026-06-12安全设计许可包含新建氨水提浓装置，不能据此认定污水装置已投运；主要为硫化氢及叔十二碳硫醇生产线。','WEB_PRIMARY','关键内容提取；来源见索引','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0099','S017-002');
INSERT INTO evidence_notes VALUES('N017-005','CN0099','S017-002','产品分项','项目概况','改质催化剂4950t/a、铑系50t/a（1+49）、纳米分子筛3000t/a；32000t/a为混合化工项目，不作催化剂产能相加；硅钛分子筛文字前后2000与200不一致，保留冲突待核。','WEB_PRIMARY','关键内容提取；来源见索引','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0099','S017-002');
INSERT INTO process_diagrams VALUES('D017-006','CN0099','mixed_high_ammonia_refractory_2025','design','2025拟批',1,'partial','flowchart TD
A[高氨氮] --> B[氨水提浓] --> E[综合污水站]
C[高浓难降解] --> D[芬顿及一体化生化] --> E
F[其他工艺及公用水] --> E --> G[酸碱中和] --> H[混凝沉淀] --> I[园区污水厂]','S017-002','32000t/a混合化工项目设计','各产品分流、实测水质、氨水去向、运行','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0099','S017-002');
INSERT INTO process_diagram_evidence VALUES('DE017-013','D017-006','W017-008','S017-002','废水措施','A,B,E','对应来源及流股');
INSERT OR IGNORE INTO site_sources VALUES('CN0099','S017-002');
INSERT INTO process_diagram_evidence VALUES('DE017-014','D017-006','W017-009','S017-002','废水措施','C,D,E','对应来源及流股');
INSERT OR IGNORE INTO site_sources VALUES('CN0099','S017-002');
INSERT INTO process_diagram_evidence VALUES('DE017-015','D017-006','W017-010','S017-002','废水措施','F,E,G,H,I','对应来源及流股');
INSERT INTO membrane_reviews VALUES('MR017-006','CN0099','D017-006','mixed_high_ammonia_refractory_2025','design','2025拟批',1,'not_identified','S017-002','32000t/a混合化工项目设计','各产品分流、实测水质、氨水去向、运行','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA017-006','MR017-006','CN0099','mixed_high_ammonia_refractory_2025','screening',1,'分质回用/资源化与改造筛选','高氨先回收，难降解先氧化生化；在确认出水及回用需求后比较UF/RO，不建议直接对复杂原水上膜','conditional','先核实际工艺、兼容性、回用需求与浓水合规；推断非事实','INFERRED；D017-006及图证据','仅按已查流股判断，不推断其他未查单元','COD及氨、溶剂、盐、可生化性、浓水合规','分时采样与物料衡算；验证膜通量、CIP、浓水去向、能耗和费用','维持原分质工艺与源头减量；非膜方案',NULL,NULL,NULL,NULL,NULL,NULL,'实际工程参数不齐；不虚构难度','2026-11-27');
UPDATE sites SET water_summary=coalesce(water_summary||'；','')||'2025正式政府拟批补证分质路径；2026二期安全设计含新氨水提浓，投运未核',source_status='本轮证据补充',as_of='2026-11-27' WHERE site_id='CN0099';
INSERT INTO search_log VALUES('L017-004','CN0099','W01-B7/W11-B8','山东虹彩 32000 环评 氨水提浓 芬顿','S017-002','旧无URL历史线索获政府网页确认；分三流股','核项目验收及分产品实测','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0093','W03S17');
INSERT INTO evidence_notes VALUES('N017-006','CN0093','W03S17','不增废水排放量','2026-06-25拟审批','600t/a铜系总能力不变，工艺、设备洗水、废气治理、地面冲洗依托既有预处理后与冷却水合并送南化污水站；不增加外排量，不等于无废水；污泥危废。','WEB_PRIMARY','关键内容提取；来源见索引','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0093','W03S17');
INSERT INTO process_diagrams VALUES('D017-007','CN0093','copper_upgrade_2026','design','2026-06拟批',1,'partial','flowchart TD
A[工艺设备洗水废气治理地面冲洗] --> B[既有预处理，单元未披露] --> D[混合]
C[循环冷却定排] --> D --> E[南化公司污水处理站]','W03S17','600t/a技改拟批；非南化全站','预处理单元、实际水量和验收','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0093','W03S17');
INSERT INTO process_diagram_evidence VALUES('DE017-016','D017-007',NULL,'W03S17','废水措施','A,B,C,D,E','对应来源及流股');
INSERT INTO membrane_reviews VALUES('MR017-007','CN0093','D017-007','copper_upgrade_2026','design','2026-06拟批',1,'not_identified','W03S17','600t/a技改拟批；非南化全站','预处理单元、实际水量和验收','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA017-007','MR017-007','CN0093','copper_upgrade_2026','screening',1,'分质回用/资源化与改造筛选','先查既有预处理和南化接管要求；独立含铜分流如有回收价值再做膜分离试验','conditional','先核实际工艺、兼容性、回用需求与浓水合规；推断非事实','INFERRED；D017-007及图证据','仅按已查流股判断，不推断其他未查单元','铜形态、盐和pH、回用需求、实际负荷','分时采样与物料衡算；验证膜通量、CIP、浓水去向、能耗和费用','维持原分质工艺与源头减量；非膜方案',NULL,NULL,NULL,NULL,NULL,NULL,'实际工程参数不齐；不虚构难度','2026-11-27');
UPDATE sites SET water_summary=coalesce(water_summary||'；','')||'2026拟批明确不新增外排量；既有站预处理后冷却水混合纳南化',source_status='本轮证据补充',as_of='2026-11-27' WHERE site_id='CN0093';
INSERT INTO search_log VALUES('L017-005','CN0093','W01-B7/W11-B8','南京化工研究院 铜系 600 柔性 技改 废水','W03S17','拟批确认不新增排水量，补设计范围图','查技改验收及现有预处理设备','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0098','turn127831search84');
INSERT INTO process_diagrams VALUES('D017-008','CN0098','copper_historical_stream','historical','2024扩建环评既有源强',1,'partial','flowchart TD
A[铜系工艺废水] --> B[蒸氨] --> C[三效蒸发]
C --> D[后续去向待核]','turn127831search84','既有铜系工艺摘要；107320.778m³/a源强不当蒸发进水','各单元连接与回收水、盐、实绩','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0098','turn127831search84');
INSERT INTO process_diagram_evidence VALUES('DE017-017','D017-008','W0029','turn127831search84','既有工程摘录','A,B,C,D','对应来源及流股');
INSERT INTO membrane_reviews VALUES('MR017-008','CN0098','D017-008','copper_historical_stream','historical','2024扩建环评既有源强',1,'not_identified','turn127831search84','既有铜系工艺摘要；107320.778m³/a源强不当蒸发进水','各单元连接与回收水、盐、实绩','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA017-008','MR017-008','CN0098','copper_historical_stream','screening',1,'分质回用/资源化与改造筛选','先核高氨分流回收、蒸发水盐平衡；对预处理后可兼容支路比较膜浓缩','conditional','先核实际工艺、兼容性、回用需求与浓水合规；推断非事实','INFERRED；D017-008及图证据','仅按已查流股判断，不推断其他未查单元','蒸氨效率、盐度、金属、真实蒸发量及成本','分时采样与物料衡算；验证膜通量、CIP、浓水去向、能耗和费用','维持原分质工艺与源头减量；非膜方案',NULL,NULL,NULL,NULL,NULL,NULL,'实际工程参数不齐；不虚构难度','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0098','turn127831search84');
INSERT INTO process_diagrams VALUES('D017-009','CN0098','expansion_a_o_mbr','design','2024扩建环评',1,'partial','flowchart TD
A[扩建部分废水] --> B[A/O] --> C[MBR] --> D[南通能达化工污水处理]','turn127831search84','扩建部分水，不代表全厂所有废水','具体进水、设计/实际处理量、膜规格、验收','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0098','turn127831search84');
INSERT INTO process_diagram_evidence VALUES('DE017-018','D017-009','W0030','turn127831search84','扩建处理表','A,B,C,D','对应来源及流股');
INSERT INTO membrane_reviews VALUES('MR017-009','CN0098','D017-009','expansion_a_o_mbr','design','2024扩建环评',1,'confirmed_present','turn127831search84','扩建部分水，不代表全厂所有废水','具体进水、设计/实际处理量、膜规格、验收','2026-11-27');
INSERT INTO membrane_units VALUES('MU017-003','MR017-009','膜生物反应器','MBR','生化固液分离','A/O出水','接管',NULL,'未披露膜面积材质通量','turn127831search84','扩建处理表','仅该时期及范围');
INSERT INTO membrane_retrofits VALUES('RA017-009','MR017-009','CN0098','expansion_a_o_mbr','screening',1,'分质回用/资源化与改造筛选','先查MBR是否已实施及盐负荷，比较优化生化/膜运行与后续回用，不假设需要新增MBR','conditional','先核实际工艺、兼容性、回用需求与浓水合规；推断非事实','INFERRED；D017-009及图证据','仅按已查流股判断，不推断其他未查单元','验收、CIP、膜更换、实际流量及接管浓度','分时采样与物料衡算；验证膜通量、CIP、浓水去向、能耗和费用','维持原分质工艺与源头减量；非膜方案',NULL,NULL,NULL,NULL,NULL,NULL,'实际工程参数不齐；不虚构难度','2026-11-27');
INSERT INTO search_log VALUES('L017-006','CN0098','W01-B7/W11-B8','高化学 分子筛铜系 2024 环评 A/O MBR','turn127831search84','已有摘录分既有与扩建范围回填','验收、铜系盐和蒸氨实际运行','2026-11-27');
COMMIT;
