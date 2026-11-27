BEGIN;
INSERT INTO sites VALUES('CN0247','中海油天化高科化工有限公司新材料基地','天津','天津','南港工业区西中环延长线东、华昌街西、富港路北、裕港路南','重油催化转化/FCC相关','2026-11-20官方披露一期建成，投用/验收待核','基地/项目','一期5000吨/年设计；非产量','招标有污水处理单元/站；工艺、实际流量未披露','部分信息/流程待查','P1',NULL,'政府和企业资料','2026-11-27','独立制造基地；中心坐标117.543004E,38.690199N，2024首次环评选址；不计为已确认运行');
INSERT INTO sources VALUES('S016-001','中海油天化高科一期建成','https://www.teda.gov.cn/contents/14/117783.html','政府园区报道','2026-11-20','一期建成、规模及产品','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0247','S016-001');
INSERT INTO sources VALUES('S016-002','中海油天化高科一期首次环评','https://www.trici.com.cn/xwzx/gsxx/202405/t20240521_15310.html','企业首次公示','2024-04-02','厂址、股权关系及一期规模','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0247','S016-002');
INSERT INTO sources VALUES('S016-003','中海油天化高科一期EPC招标','https://buy.cnooc.com.cn/cbjyweb/001/001001/20241217/1318511139396452352-zhy.html','企业采购公告','2024-12-17','建设规模及污水处理单元','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0247','S016-003');
INSERT INTO capacity VALUES('C016-001','CN0247','重油催化转化催化剂',5000,'吨/年','一期建成项目设计','2026-11','单厂一期','S016-001','未披露产量');
INSERT INTO projects VALUES('P016-001','CN0247','新材料基地一期','建成，投用待核','2026-11-20','5000吨/年','招标配套污水处理站，实际工艺待核','S016-001');
INSERT INTO tasks VALUES('T016-001','CN0247','P1','废水分流、站规模及工艺、实际投运、许可与运行成本','项目完整名称+污水处理设备/验收/许可','部分完成');
INSERT OR IGNORE INTO site_sources VALUES('CN0247','S016-003');
INSERT INTO wastewater VALUES('W016-001','CN0247','一期配套污水处理','2024 EPC设计',NULL,NULL,NULL,NULL,'污水处理单元及站（未披露具体工艺）',NULL,NULL,'S016-003','WEB_COMPANY','招标建设内容，不能据2026项目建成推断环保验收');
INSERT OR IGNORE INTO site_sources VALUES('CN0247','S016-002');
INSERT INTO evidence_notes VALUES('N016-001','CN0247','S016-002','厂址与建设规模','项目概要','天津院全资子公司；中心坐标117.543004E、38.690199N，总地166779.95m²、一期约48061.2m²；总投资29616.92万元为项目投资非水站。2024招标一期规划用地42589.6m²与首次公示口径不同，保留；2026园区称约4.8万m²。','WEB_COMPANY','关键内容提取；来源见索引','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0247','S016-001');
INSERT INTO claims VALUES('CL016-001','CN0247','建成状态','2026-11-20一期建成，5000吨/年设计','WEB_PRIMARY','S016-001','投用及环保验收待核','2026-11-27');
INSERT INTO search_log VALUES('L016-001','CN0247','W01-B6/W11-B7','中海油天化高科 新材料 5000吨 2026 污水','S016-001','新增基地，项目建成与EPC水站证据','许可、实际水站工艺','2026-11-27');
INSERT INTO sources VALUES('S016-004','中石化天津新材料基地投产','https://www.teda.gov.cn/contents/14/70124.html','政府园区报道','2024','基地投产及总体规划','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0013','S016-004');
INSERT INTO sources VALUES('S016-005','天津含银废催化剂1200吨回收项目开工','https://www.teda.gov.cn/contents/14/110586.html','政府园区报道','2026-06-15','现有厂区新增项目开工；2027计划投产','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0013','S016-005');
INSERT INTO sources VALUES('S016-006','中石化天津含银回收项目工艺披露','https://finance.sina.com.cn/roll/2026-06-25/doc-inieqnay1050525.shtml','行业报道','2026-06-25','地址及回收分项','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0013','S016-006');
INSERT INTO capacity VALUES('C016-002','CN0013','含银废催化剂回收',1200,'吨/年','在建项目设计','2026-06','新增回收项目','S016-005','含废剂1140、落地废料60；非新剂');
INSERT INTO capacity VALUES('C016-003','CN0013','回收银',342.18,'吨/年','在建项目设计','2026-06','回收产品','S016-006','纯度99.99%，非催化剂成品');
INSERT INTO projects VALUES('P016-002','CN0013','含银废催化剂综合回收装置','开工建设','2026-06-15','1200吨/年废剂及废料；2027计划投产','处理工艺及水量待核','S016-005');
INSERT OR IGNORE INTO site_sources VALUES('CN0013','S016-006');
INSERT INTO evidence_notes VALUES('N016-002','CN0013','S016-006','回收项目边界','报道项目内容','现有厂区安建路8号；浸出、络合、还原、电解系统，银铈变价循环提银。1140吨废剂及60吨落地废料包含于1200；回收银342.18吨，不计新剂产能。未披露污水路线，电解不等于电渗析。','WEB_SECONDARY','关键内容提取；来源见索引','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0013','S016-004');
INSERT INTO claims VALUES('CL016-002','CN0013','投产及规划','政府披露基地已投产，规划银2000、聚烯烃1250、球形PP200、载体500、POE试验3吨/年','WEB_PRIMARY','S016-004','2024报道规划并非各装置实绩','2026-11-27');
UPDATE sites SET address='天津经开区南港工业区安建路8号',capacity_summary=capacity_summary||'；2026在建1200吨/年含银废剂回收，2027计划投产' WHERE site_id='CN0013';
INSERT INTO search_log VALUES('L016-002','CN0013','W01-B6/W11-B7','天津南港 含银废催化剂 2026 开工 废水','S016-005','补回收项目，水站尚无具体资料','新增项目排污许可及回收废水','2026-11-27');
INSERT INTO sources VALUES('S016-007','惠城环保2025年报','https://money.finance.sina.com.cn/corp/view/vCB_AllBulletinDetail.php?id=12151021&stockid=300779','上市公司年度报告','2026-04','董家口排污与危废许可续期','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0020','S016-007');
INSERT INTO sources VALUES('S016-008','惠城环保2024年报','https://money.finance.sina.com.cn/corp/view/vCB_AllBulletinDetail.php?id=10891250&stockid=300779','上市公司年度报告','2025-04','董家口水排放与氨氮指标','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0020','S016-008');
INSERT OR IGNORE INTO site_sources VALUES('CN0020','S016-007');
INSERT INTO claims VALUES('CL016-003','CN0020','最新许可证','排污91370200783724899J002V、危废青环西新危37021108号；2025-07-29至2030-07-28','WEB_COMPANY','S016-007','2025年报披露','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0020','S016-008');
INSERT INTO wastewater VALUES('W016-002','CN0020','董家口污水处理站排水','2024年度报告期运行',NULL,NULL,NULL,'氨氮','厂内污水处理站，内部工艺未披露','达到一级A，经董家口中法水务尾水管排海',NULL,'S016-008','WEB_COMPANY','非送中法水务再次生化；年报连续排放、一个污水站排口');
INSERT INTO water_metrics VALUES('M016-001','CN0020','W016-002','董家口污水站排口','氨氮',1.03,NULL,'mg/L','年度披露均值',NULL,'2024',NULL,NULL,'S016-008','非设计值');
INSERT INTO water_metrics VALUES('M016-002','CN0020','W016-002','董家口污水站排口','氨氮排放量',0.59,NULL,'t/a','年度披露实际排放',NULL,'2024',NULL,NULL,'S016-008','未核定总量，不倒推废水量');
INSERT INTO process_diagrams VALUES('D016-001','CN0020','dongjiakou_discharge','operating','2024年报',1,'partial','flowchart TD
 A[董家口生产废水] --> B[厂内污水站 内部单元待核] --> C[一级A排放]
 C --> D[中法水务尾水管] --> E[排海]','S016-008','报告期厂区排水；非淮河路厂区','水站各单元/实际流量/膜待核','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0020','S016-008');
INSERT OR IGNORE INTO site_sources VALUES('CN0020','S016-008');
INSERT INTO process_diagram_evidence VALUES('DE016-001','D016-001','W016-002','S016-008','环保披露','A,B,C,D,E','对应来源及流股');
INSERT INTO membrane_reviews VALUES('MR016-001','CN0020','D016-001','dongjiakou_discharge','operating','2024年报',1,'not_identified','S016-008','报告期厂区排水；非淮河路厂区','水站各单元/实际流量/膜待核','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA016-001','MR016-001','CN0020','dongjiakou_discharge','screening',1,'分质回用/资源化与改造筛选','先取得处理单元和实际进出水；如有回用需求比较末端UF/RO与原排海路线','conditional','先核实际工艺、兼容性、回用需求与浓水合规；推断非事实','INFERRED；D016-001及图证据','以已查到的范围为基础，不推断未查单元','实际流量、盐度、回用需求、浓水合规','核多时段流量水质、膜性能及CIP、物料平衡、盐泥去向、真实能耗与费用','比较维持现有工艺及源头减量；非膜方案',NULL,NULL,NULL,NULL,NULL,NULL,'实际工程参数不齐；不虚构难度','2026-11-27');
INSERT INTO search_log VALUES('L016-003','CN0020','W01-B6/W11-B7','惠城环保 董家口 2025年报 许可 2024氨氮','S016-007','补最新许可及历史实绩','污水站设备及水盐平衡','2026-11-27');
INSERT INTO sources VALUES('S016-009','中触媒2024年报','https://vip.stock.finance.sina.com.cn/corp/view/vCB_AllBulletinDetail.php?id=10964583&stockid=688267','上市公司年度报告','2025-04','含盐废水低温干燥年度处理与节能','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0026','S016-009');
INSERT INTO sources VALUES('S016-010','中触媒2024半年报','https://money.finance.sina.com.cn/corp/view/vCB_AllBulletinDetail.php?id=10394634&stockid=688267','上市公司定期报告','2024-08','松木岛厂区污水站单元组合','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0026','S016-010');
INSERT OR IGNORE INTO site_sources VALUES('CN0026','S016-010');
INSERT INTO wastewater VALUES('W016-003','CN0026','现有综合生产及生活废水','2024H1公司披露运行',NULL,NULL,NULL,NULL,'沉降、絮凝、生化、气浮、电化学、MBR组合；具体顺序未披露','松木岛园区污水厂',NULL,'S016-010','WEB_COMPANY','报告期设施披露');
INSERT OR IGNORE INTO site_sources VALUES('CN0026','S016-009');
INSERT INTO wastewater VALUES('W016-004','CN0026','低温干燥含盐废水','2024年度披露实绩',5633.75,'t/a','年度处理质量','盐','低温干燥装置','去向未披露','盐/残余物去向未披露','S016-009','WEB_COMPANY','节能量是公司报告的降低能耗，不是实际总能耗；厂区分项需核');
INSERT INTO water_metrics VALUES('M016-003','CN0026','W016-004','低温干燥装置','报告降低能耗',1650.6,NULL,'tce','公司披露节能量',NULL,'2024',NULL,NULL,'S016-009','不等于耗能');
INSERT INTO water_metrics VALUES('M016-004','CN0026','W016-004','低温干燥装置','报告减排CO2',4390.7,NULL,'t','公司披露减排量',NULL,'2024',NULL,NULL,'S016-009','非实测排放量');
INSERT INTO process_diagrams VALUES('D016-002','CN0026','existing_mbr_combination','operating','2024H1',1,'partial','flowchart TD
 A[生产及生活废水] --> B[综合污水站：沉降、絮凝、生化、气浮、电化学、MBR；次序未披露] --> C[松木岛园区污水厂]','S016-010','2024H1现有站；不与拟建5200t/d或2025改建串接','单元连接、MBR规格、污水实际流量待核','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0026','S016-010');
INSERT OR IGNORE INTO site_sources VALUES('CN0026','S016-010');
INSERT INTO process_diagram_evidence VALUES('DE016-002','D016-002','W016-003','S016-010','污染防治设施','A,B,C','对应来源及流股');
INSERT INTO membrane_reviews VALUES('MR016-002','CN0026','D016-002','existing_mbr_combination','operating','2024H1',1,'confirmed_present','S016-010','2024H1现有站；不与拟建5200t/d或2025改建串接','单元连接、MBR规格、污水实际流量待核','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0026','S016-010');
INSERT INTO membrane_units VALUES('MU016-001','MR016-002','MBR','MBR','综合污水生化固液分离','综合水',NULL,NULL,'未披露膜材/面积/通量','S016-010','报告期设施','仅该时期及范围');
INSERT INTO membrane_retrofits VALUES('RA016-002','MR016-002','CN0026','existing_mbr_combination','screening',1,'分质回用/资源化与改造筛选','核实原MBR及低温干燥边界，评估适合的低盐出水回用或分盐，避免高盐/金属冲击MBR','conditional','先核实际工艺、兼容性、回用需求与浓水合规；推断非事实','INFERRED；D016-002及图证据','以已查到的范围为基础，不推断未查单元','实际水质、各支路去向、现有站余量、盐处理和电汽费用','核多时段流量水质、膜性能及CIP、物料平衡、盐泥去向、真实能耗与费用','比较维持现有工艺及源头减量；非膜方案',NULL,NULL,NULL,NULL,NULL,NULL,'实际工程参数不齐；不虚构难度','2026-11-27');
INSERT INTO process_diagrams VALUES('D016-003','CN0026','nickel_acceptance','historical','2025-05验收',1,'partial','flowchart TD
 A[含镍生产废水] --> B[车间沉淀] --> C[车间排口监控] --> D[厂区污水站] --> E[松木岛园区污水厂]
 F[其他生产及公用废水] --> D','W01S01','2025改建7750吨/年验收范围；非全厂新增，污水站内部连接未明','总镍实测、分质水量、现有站实际单元及浓水去向','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0026','W01S01');
INSERT OR IGNORE INTO site_sources VALUES('CN0026','W01S01');
INSERT INTO process_diagram_evidence VALUES('DE016-003','D016-003','W0096','W01S01','验收第3页','A,B,C,D,E','对应来源及流股');
INSERT OR IGNORE INTO site_sources VALUES('CN0026','W01S01');
INSERT INTO process_diagram_evidence VALUES('DE016-004','D016-003','W0097','W01S01','验收意见','F,D,E','对应来源及流股');
INSERT INTO membrane_reviews VALUES('MR016-003','CN0026','D016-003','nickel_acceptance','historical','2025-05验收',1,'not_identified','W01S01','2025改建7750吨/年验收范围；非全厂新增，污水站内部连接未明','总镍实测、分质水量、现有站实际单元及浓水去向','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA016-003','MR016-003','CN0026','nickel_acceptance','screening',1,'分质回用/资源化与改造筛选','含镍先回收或沉淀，测上清盐度和镍残留后评UF/NF，不与其他支流混合','conditional','先核实际工艺、兼容性、回用需求与浓水合规；推断非事实','INFERRED；D016-003及图证据','以已查到的范围为基础，不推断未查单元','镍回收价值、实际水质、污泥处置','核多时段流量水质、膜性能及CIP、物料平衡、盐泥去向、真实能耗与费用','比较维持现有工艺及源头减量；非膜方案',NULL,NULL,NULL,NULL,NULL,NULL,'实际工程参数不齐；不虚构难度','2026-11-27');
INSERT INTO process_diagrams VALUES('D016-004','CN0026','future_5200_station','design','重新报批',1,'partial','flowchart TD
 A[生产、生活、公用废水及初雨] --> B[拟建5200t/d全厂站] --> C[拟新排口] --> D[松木岛污水厂]','turn699489search7','拟建站替代/承担全厂处理，非既有能力','新站单元、审批/建设/投运待核','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0026','turn699489search7');
INSERT OR IGNORE INTO site_sources VALUES('CN0026','turn699489search7');
INSERT INTO process_diagram_evidence VALUES('DE016-005','D016-004','W0024','turn699489search7','二次重新报批公示','A,B,C,D','对应来源及流股');
INSERT INTO membrane_reviews VALUES('MR016-004','CN0026','D016-004','future_5200_station','design','重新报批',1,'not_identified','turn699489search7','拟建站替代/承担全厂处理，非既有能力','新站单元、审批/建设/投运待核','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA016-004','MR016-004','CN0026','future_5200_station','screening',1,'分质回用/资源化与改造筛选','先核设计实际工艺及新站建设状态，再按高盐/含镍分质评估膜，避免重复项目','conditional','先核实际工艺、兼容性、回用需求与浓水合规；推断非事实','INFERRED；D016-004及图证据','以已查到的范围为基础，不推断未查单元','设计细节、实际水量、浓水处置','核多时段流量水质、膜性能及CIP、物料平衡、盐泥去向、真实能耗与费用','比较维持现有工艺及源头减量；非膜方案',NULL,NULL,NULL,NULL,NULL,NULL,'实际工程参数不齐；不虚构难度','2026-11-27');
INSERT INTO process_diagrams VALUES('D016-005','CN0026','low_temperature_drying','historical','2024年度报告',1,'partial','flowchart TD
 A[含盐废水 2024处理5633.75t] --> B[低温干燥装置] --> C[产物与水去向待核]','S016-009','公司年度实绩披露；未披露具体厂区分摊或与其他站的连接','实际进水/盐品/残余物及能耗基线待核','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0026','S016-009');
INSERT OR IGNORE INTO site_sources VALUES('CN0026','S016-009');
INSERT INTO process_diagram_evidence VALUES('DE016-006','D016-005','W016-004','S016-009','年度节能披露','A,B,C','对应来源及流股');
INSERT INTO membrane_reviews VALUES('MR016-005','CN0026','D016-005','low_temperature_drying','historical','2024年度报告',1,'not_identified','S016-009','公司年度实绩披露；未披露具体厂区分摊或与其他站的连接','实际进水/盐品/残余物及能耗基线待核','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA016-005','MR016-005','CN0026','low_temperature_drying','screening',1,'分质回用/资源化与改造筛选','核低温干燥进水和盐品，比较分质NF/ED预浓缩减干燥负荷','conditional','先核实际工艺、兼容性、回用需求与浓水合规；推断非事实','INFERRED；D016-005及图证据','以已查到的范围为基础，不推断未查单元','实际设备能耗、进水盐种及剩余水分、处理成本','核多时段流量水质、膜性能及CIP、物料平衡、盐泥去向、真实能耗与费用','比较维持现有工艺及源头减量；非膜方案',NULL,NULL,NULL,NULL,NULL,NULL,'实际工程参数不齐；不虚构难度','2026-11-27');
INSERT INTO search_log VALUES('L016-004','CN0026','W01-B6/W11-B7','中触媒 2024 年报 含盐废水 低温干燥 MBR','S016-009','补年度处理和节能、既有MBR与设计站分图','实际各股水量、当前膜及新站','2026-11-27');
INSERT INTO sources VALUES('S016-011','齐鲁综合污水近零排放项目开工','https://www.membranes.com.cn/xingyedongtai/gongyexinwen/2019-03-15/35759.html','行业协会转载中石化新闻','2019-03-15','齐鲁周村200m³/h项目开工及三单元','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0001','S016-011');
INSERT OR IGNORE INTO site_sources VALUES('CN0001','S016-011');
INSERT INTO wastewater VALUES('W016-005','CN0001','综合污水近零排放项目','2019开工设计',200,'m³/h','设计处理能力','综合污水','预处理、膜浓缩、蒸发结晶','近零排放设计，回用细节待核','结晶盐去向待核','S016-011','WEB_SECONDARY','明确为齐鲁周村项目；不将匿名技术案例或专利当作该厂实际膜类型');
INSERT INTO process_diagrams VALUES('D016-006','CN0001','near_zero_2019','design','2019开工',1,'partial','flowchart TD
 A[综合污水] --> B[预处理] --> C[膜浓缩] --> D[蒸发结晶]
 C --> E[产水去向待核]
 D --> F[结晶盐去向待核]','S016-011','2019开工200m³/h，未核验收；不与长岭标定混同','膜具体类型及投运、盐水衡算待核','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0001','S016-011');
INSERT OR IGNORE INTO site_sources VALUES('CN0001','S016-011');
INSERT INTO process_diagram_evidence VALUES('DE016-007','D016-006','W016-005','S016-011','项目开工报道','A,B,C,D','对应来源及流股');
INSERT INTO membrane_reviews VALUES('MR016-006','CN0001','D016-006','near_zero_2019','design','2019开工',1,'confirmed_present','S016-011','2019开工200m³/h，未核验收；不与长岭标定混同','膜具体类型及投运、盐水衡算待核','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0001','S016-011');
INSERT INTO membrane_units VALUES('MU016-002','MR016-006','膜浓缩','UNSPECIFIED','减量浓缩','预处理后',NULL,NULL,'具体膜型未披露','S016-011','开工报道','仅该时期及范围');
INSERT INTO membrane_retrofits VALUES('RA016-006','MR016-006','CN0001','near_zero_2019','screening',1,'分质回用/资源化与改造筛选','优先确认2019工程实施及膜组合，比较NF分盐、RO/ED浓缩优化而非新建重复系统','conditional','先核实际工艺、兼容性、回用需求与浓水合规；推断非事实','INFERRED；D016-006及图证据','以已查到的范围为基础，不推断未查单元','实测盐种、硅、氨、膜设备、盐纯度、成本','核多时段流量水质、膜性能及CIP、物料平衡、盐泥去向、真实能耗与费用','比较维持现有工艺及源头减量；非膜方案',NULL,NULL,NULL,NULL,NULL,NULL,'实际工程参数不齐；不虚构难度','2026-11-27');
INSERT INTO search_log VALUES('L016-005','CN0001','W01-B6/W11-B7','齐鲁分公司 综合污水近零排放 200 竣工','S016-011','开工报道确认膜浓缩，未取得验收','按工程名查投运和膜招标','2026-11-27');
INSERT INTO sources VALUES('S016-012','鼎际得100吨高端聚烯烃催化剂环评公示','https://www.djdsh.com/news/580.html','企业环评公示','2025','分质站、罐车转运及地址','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0109','S016-012');
INSERT OR IGNORE INTO site_sources VALUES('CN0109','S016-012');
INSERT INTO wastewater VALUES('W016-006','CN0109','100吨项目生产工艺排水','环评设计',NULL,NULL,NULL,NULL,'依托现有生产污水站','总排口后罐车运大石桥有色园污水处理厂',NULL,'S016-012','WEB_COMPANY','项目公示废水段；末尾误称润滑脂，保留冲突；非验收');
INSERT OR IGNORE INTO site_sources VALUES('CN0109','S016-012');
INSERT INTO wastewater VALUES('W016-007','CN0109','100吨项目生活污水','环评设计',NULL,NULL,NULL,NULL,'化粪池、既有地埋设施','总排口后罐车运大石桥有色园污水处理厂',NULL,'S016-012','WEB_COMPANY','循环冷却排水去向未分述');
INSERT INTO process_diagrams VALUES('D016-007','CN0109','high_end_100','design','2025公示',1,'partial','flowchart TD
 A[生产工艺水] --> B[既有生产污水站] --> D[厂总排口]
 C[生活污水] --> E[化粪池及地埋处理] --> D
 D --> F[罐车] --> G[大石桥有色园污水厂]','S016-012','100吨扩建设计；125m³/d为历史站能力，不直接归入本项目','实际流量、站内单元、转运费用、冷却排水待核','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0109','S016-012');
INSERT OR IGNORE INTO site_sources VALUES('CN0109','S016-012');
INSERT INTO process_diagram_evidence VALUES('DE016-008','D016-007','W016-006','S016-012','废水段','A,B,D,F,G','对应来源及流股');
INSERT OR IGNORE INTO site_sources VALUES('CN0109','S016-012');
INSERT INTO process_diagram_evidence VALUES('DE016-009','D016-007','W016-007','S016-012','废水段','C,E,D,F,G','对应来源及流股');
INSERT INTO membrane_reviews VALUES('MR016-007','CN0109','D016-007','high_end_100','design','2025公示',1,'not_identified','S016-012','100吨扩建设计；125m³/d为历史站能力，不直接归入本项目','实际流量、站内单元、转运费用、冷却排水待核','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA016-007','MR016-007','CN0109','high_end_100','screening',1,'分质回用/资源化与改造筛选','核运输量及费用，分质低盐处理出水评回用，避免溶剂或高盐直接进膜','conditional','先核实际工艺、兼容性、回用需求与浓水合规；推断非事实','INFERRED；D016-007及图证据','以已查到的范围为基础，不推断未查单元','溶剂/氯盐/石油类、实际运输量、现有站单元及回用','核多时段流量水质、膜性能及CIP、物料平衡、盐泥去向、真实能耗与费用','比较维持现有工艺及源头减量；非膜方案',NULL,NULL,NULL,NULL,NULL,NULL,'实际工程参数不齐；不虚构难度','2026-11-27');
UPDATE sites SET water_summary=COALESCE(water_summary||'；','')||'100吨扩建设计生产及生活经各自站后罐车运大石桥有色园污水厂',water_level='有工艺线索',source_status='已取得分范围证据',as_of='2026-11-27' WHERE site_id='CN0109';
UPDATE tasks SET state='部分完成',next_query='实际转运台账、污水站设备及运行' WHERE site_id='CN0109';
INSERT INTO search_log VALUES('L016-006','CN0109','W01-B6/W11-B7','鼎际得 100吨 聚烯烃 催化剂 环评 罐车','S016-012','明确设计处置边界，结论文字冲突','许可、转运台账','2026-11-27');
INSERT INTO sources VALUES('S016-013','广东思凯瑞2万吨项目最终批复','https://www.jiangmen.gov.cn/bmpd/jmssthjj/zdlyxxgk/jsxmhjyxpjxx/content/post_3509635.html','政府批复','2026-06-22','生产回用、生活纳管、事故池及粗钛料鉴别','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0067','S016-013');
INSERT OR IGNORE INTO site_sources VALUES('CN0067','S016-013');
INSERT INTO wastewater VALUES('W016-008','CN0067','生活污水','2026最终批复设计',NULL,NULL,NULL,NULL,'三级化粪池','新财富环保产业园污水厂',NULL,'S016-013','WEB_PRIMARY','生产不外排不等于全厂不外排');
INSERT INTO water_metrics VALUES('M016-005','CN0067',NULL,'事故池','最低池容',250,NULL,'m³','批复最低容积',NULL,'2026',NULL,NULL,'S016-013','非处理能力');
INSERT OR IGNORE INTO site_sources VALUES('CN0067','S016-013');
INSERT INTO evidence_notes VALUES('N016-003','CN0067','S016-013','批复要点','第一及三（三）、（五）、（七）','20000t/a废剂处置线批准，生产水经预处理或深度处理回用；粗钛料固废鉴别前按危废，事故池≥250m³，生活污水纳园区。','WEB_PRIMARY','关键内容提取；来源见索引','2026-11-27');
INSERT INTO projects VALUES('P016-003','CN0067','2万吨废脱硝催化剂综合利用','环评批复','2026-06-22','20000t/a处置','生产回用，生活纳管','S016-013');
INSERT INTO process_diagrams VALUES('D016-008','CN0067','scr_zero_discharge','design','2026批复及环评',1,'partial','flowchart TD
 A[含重金属生产废水] --> B[混凝絮凝沉淀 10m³/h设计]
 B --> C[合格水回用]
 B --> D[不能直接回用部分] --> E[砂滤 碳滤 UF 2m³/h深度系统] --> F[MVR] --> C
 F --> G[蒸发残渣危废]
 H[生活污水] --> I[三级化粪池] --> J[园区污水厂]','S016-013','设计生产不外排，生活另线；10及2m³/h为系统能力','实际投运及回用率、重金属和危废盐','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0067','S016-013');
INSERT OR IGNORE INTO site_sources VALUES('CN0067','turn699489search10');
INSERT INTO process_diagram_evidence VALUES('DE016-010','D016-008','W0021','turn699489search10','环评设计','A,B,C,D,F,G','对应来源及流股');
INSERT OR IGNORE INTO site_sources VALUES('CN0067','turn245404search9');
INSERT INTO process_diagram_evidence VALUES('DE016-011','D016-008','W0022','turn245404search9','旧设计摘录','B','对应来源及流股');
INSERT OR IGNORE INTO site_sources VALUES('CN0067','turn245404search9');
INSERT INTO process_diagram_evidence VALUES('DE016-012','D016-008','W0023','turn245404search9','旧设计摘录','E,F','对应来源及流股');
INSERT OR IGNORE INTO site_sources VALUES('CN0067','S016-013');
INSERT INTO process_diagram_evidence VALUES('DE016-013','D016-008','W016-008','S016-013','批复','H,I,J','对应来源及流股');
INSERT INTO membrane_reviews VALUES('MR016-008','CN0067','D016-008','scr_zero_discharge','design','2026批复及环评',1,'confirmed_present','S016-013','设计生产不外排，生活另线；10及2m³/h为系统能力','实际投运及回用率、重金属和危废盐','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0067','turn245404search9');
INSERT INTO membrane_units VALUES('MU016-003','MR016-008','深度UF','UF','MVR前处理','砂碳滤后',NULL,NULL,'2m³/h为深度处理站能力','turn245404search9','设计摘录','仅该时期及范围');
INSERT INTO membrane_retrofits VALUES('RA016-008','MR016-008','CN0067','scr_zero_discharge','screening',1,'分质回用/资源化与改造筛选','核已有设计UF/MVR投用，若高盐适宜可对2m³/h支路试NF/RO预浓缩','conditional','先核实际工艺、兼容性、回用需求与浓水合规；推断非事实','INFERRED；D016-008及图证据','以已查到的范围为基础，不推断未查单元','盐度、金属、药耗、蒸发余量、危废成本','核多时段流量水质、膜性能及CIP、物料平衡、盐泥去向、真实能耗与费用','比较维持现有工艺及源头减量；非膜方案',NULL,NULL,NULL,NULL,NULL,NULL,'实际工程参数不齐；不虚构难度','2026-11-27');
UPDATE sites SET status='2026-06-22环评批复；投运待核' WHERE site_id='CN0067';
INSERT INTO search_log VALUES('L016-007','CN0067','W01-B6/W11-B7','思凯瑞 2026 最终批复 2万吨','S016-013','新增最终批复及设计图','验收与实际运行','2026-11-27');
INSERT INTO sources VALUES('S016-014','绿园华泰2018环评批复','https://sthjt.xinjiang.gov.cn/xjepd/gwwjhh/201804/c281bb48263c4278888c517b325a2d12.shtml','政府批复','2018-04','再生及处置线ED、RO、蒸发；危废与生活分流','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0069','S016-014');
INSERT INTO sources VALUES('S016-015','绿园华泰2022危废经营许可','https://sthjt.xinjiang.gov.cn/xjepd/gtfwwxsp/202201/81d5d8badc9c4b09af3515cfed1c081a.shtml','政府许可','2022-01','再生与处置各5000m³/年，合计10000m³/年','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0069','S016-015');
INSERT OR IGNORE INTO site_sources VALUES('CN0069','S016-014');
INSERT INTO wastewater VALUES('W016-009','CN0069','再生处置生产废水','2018批复设计',NULL,NULL,NULL,'金属、盐','加药三联箱+ED+RO+蒸发反应釜','全部生产回用','污泥、蒸馏残渣、废ED与RO膜危废','S016-014','WEB_PRIMARY','批复第二（二）、（五）');
INSERT OR IGNORE INTO site_sources VALUES('CN0069','S016-014');
INSERT INTO wastewater VALUES('W016-010','CN0069','生活污水','2018批复设计',NULL,NULL,NULL,NULL,'隔油池','五彩湾生产服务区污水厂',NULL,'S016-014','WEB_PRIMARY','非全厂零排放');
INSERT INTO water_metrics VALUES('M016-006','CN0069',NULL,'事故池','容积',300,NULL,'m³','批复设计容积',NULL,'2018',NULL,NULL,'S016-014','非水量');
INSERT OR IGNORE INTO site_sources VALUES('CN0069','S016-015');
INSERT INTO evidence_notes VALUES('N016-004','CN0069','S016-015','许可规模','许可公告','10000m³/年（6000t/a）总规模，废催化剂再生5000m³/年（3000t/a）及处置5000m³/年（3000t/a）；同一许可两种单位，不相加。非当前许可有效性确认。','WEB_PRIMARY','关键内容提取；来源见索引','2026-11-27');
INSERT INTO capacity VALUES('C016-004','CN0069','废SCR再生',5000,'m³/年','2022危废许可分项','2022','许可处理量','S016-015','合计10000；非成品');
INSERT INTO capacity VALUES('C016-005','CN0069','废SCR处置',5000,'m³/年','2022危废许可分项','2022','许可处理量','S016-015','合计10000；非成品');
INSERT INTO process_diagrams VALUES('D016-009','CN0069','scr_ed_ro','design','2018批复',1,'partial','flowchart TD
 A[再生、处置线废水] --> B[加药三联箱] --> C[ED] --> D[RO] --> E[蒸发反应釜]
 D --> F[生产回用]
 E --> F
 E --> G[蒸馏残渣危废]
 H[生活污水] --> I[隔油池] --> J[五彩湾污水厂]','S016-014','批复列组合顺序，具体串并联待核；生产回用非全厂不外排','各段产浓水连接、膜面积/运行及实际盐泥成本','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0069','S016-014');
INSERT OR IGNORE INTO site_sources VALUES('CN0069','S016-014');
INSERT INTO process_diagram_evidence VALUES('DE016-014','D016-009','W016-009','S016-014','批复第二（二）（五）','A,B,C,D,E,F,G','对应来源及流股');
INSERT OR IGNORE INTO site_sources VALUES('CN0069','S016-014');
INSERT INTO process_diagram_evidence VALUES('DE016-015','D016-009','W016-010','S016-014','批复第二（二）','H,I,J','对应来源及流股');
INSERT INTO membrane_reviews VALUES('MR016-009','CN0069','D016-009','scr_ed_ro','design','2018批复',1,'confirmed_present','S016-014','批复列组合顺序，具体串并联待核；生产回用非全厂不外排','各段产浓水连接、膜面积/运行及实际盐泥成本','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0069','S016-014');
INSERT INTO membrane_units VALUES('MU016-004','MR016-009','ED','ED','分盐/浓缩','加药预处理后',NULL,NULL,'设计，连接待核','S016-014','批复','仅该时期及范围');
INSERT OR IGNORE INTO site_sources VALUES('CN0069','S016-014');
INSERT INTO membrane_units VALUES('MU016-005','MR016-009','RO','RO','回用/脱盐',NULL,'生产回用',NULL,'设计，连接待核','S016-014','批复','仅该时期及范围');
INSERT INTO membrane_retrofits VALUES('RA016-009','MR016-009','CN0069','scr_ed_ro','screening',1,'分质回用/资源化与改造筛选','先核实际ED/RO运行和蒸发反应釜负荷，比较现有分盐性能及预处理改造','conditional','先核实际工艺、兼容性、回用需求与浓水合规；推断非事实','INFERRED；D016-009及图证据','以已查到的范围为基础，不推断未查单元','实际流量、金属、离子、膜更换、废盐处置','核多时段流量水质、膜性能及CIP、物料平衡、盐泥去向、真实能耗与费用','比较维持现有工艺及源头减量；非膜方案',NULL,NULL,NULL,NULL,NULL,NULL,'实际工程参数不齐；不虚构难度','2026-11-27');
UPDATE sites SET water_summary=COALESCE(water_summary||'；','')||'2018批复ED+RO+蒸发，生活隔油纳管；2022许可再生/处置各5000m³/年',water_level='有工艺线索',source_status='已取得分范围证据',as_of='2026-11-27' WHERE site_id='CN0069';
UPDATE tasks SET state='部分完成',next_query='三期改扩建与现行许可、膜运行' WHERE site_id='CN0069';
INSERT INTO search_log VALUES('L016-008','CN0069','W01-B6/W11-B7','绿园华泰 2018 批复 ED RO 2022 许可证','S016-014','明确废膜与盐泥危废、生活分流、许可','现行许可及三期实际','2026-11-27');
INSERT INTO sources VALUES('S016-016','中自科技2024年半年报','https://vip.stock.finance.sina.com.cn/corp/view/vCB_AllBulletinDetail.php?id=10450967&stockid=688737','上市公司定期报告','2024-08','古楠及安泰污水工艺','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0044','S016-016');
INSERT OR IGNORE INTO site_sources VALUES('CN0045','S016-016');
INSERT INTO sources VALUES('S016-017','中自科技2025募集资金专项报告','https://money.finance.sina.com.cn/corp/view/vCB_AllBulletinDetail.php?id=12033682','上市公司专项报告','2026-03','安泰2023年11月底正式投产','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0045','S016-017');
INSERT OR IGNORE INTO site_sources VALUES('CN0044','S016-016');
INSERT INTO wastewater VALUES('W016-011','CN0044','生产废水','2024H1报告期已建站',NULL,NULL,NULL,'工业浓水、氨','氨蒸发、两级A/O','最终去向未披露',NULL,'S016-016','WEB_COMPANY','古楠街基地，非安泰');
INSERT OR IGNORE INTO site_sources VALUES('CN0045','S016-016');
INSERT INTO wastewater VALUES('W016-012','CN0045','生产废水','2024H1报告期已建站',160,'m³/d','设施设计能力','工业浓水','前段硝化调节、缺氧、好氧、沉淀、BAF、氧化稳定','去向待核',NULL,'S016-016','WEB_COMPANY','半年报；原表硝化/钠化表述需核；非实际负荷');
INSERT OR IGNORE INTO site_sources VALUES('CN0045','S016-017');
INSERT INTO claims VALUES('CL016-004','CN0045','投产','安泰2023年11月底正式投产','WEB_COMPANY','S016-017','2025专项报告','2026-11-27');
INSERT INTO process_diagrams VALUES('D016-010','CN0044','old_plant','built','2024H1披露',1,'partial','flowchart TD
 A[生产工业浓水] --> B[氨蒸发] --> C[两级A/O] --> D[去向待核]','S016-016','古楠独立基地，不与安泰合并','实际水量、氨回收及排口待核','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0044','S016-016');
INSERT OR IGNORE INTO site_sources VALUES('CN0044','S016-016');
INSERT INTO process_diagram_evidence VALUES('DE016-016','D016-010','W016-011','S016-016','半年报','A,B,C','对应来源及流股');
INSERT INTO membrane_reviews VALUES('MR016-010','CN0044','D016-010','old_plant','built','2024H1披露',1,'not_identified','S016-016','古楠独立基地，不与安泰合并','实际水量、氨回收及排口待核','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA016-010','MR016-010','CN0044','old_plant','screening',1,'分质回用/资源化与改造筛选','保留蒸发脱氨，核生化出水是否适于深度回用','conditional','先核实际工艺、兼容性、回用需求与浓水合规；推断非事实','INFERRED；D016-010及图证据','以已查到的范围为基础，不推断未查单元','氨、盐、COD、膜浓水、实际用水','核多时段流量水质、膜性能及CIP、物料平衡、盐泥去向、真实能耗与费用','比较维持现有工艺及源头减量；非膜方案',NULL,NULL,NULL,NULL,NULL,NULL,'实际工程参数不齐；不虚构难度','2026-11-27');
INSERT INTO process_diagrams VALUES('D016-011','CN0045','antai_160','built','2024H1披露',1,'partial','flowchart TD
 A[生产废水] --> B[前段硝化调节] --> C[缺氧] --> D[好氧] --> E[沉淀] --> F[BAF] --> G[氧化稳定] --> H[去向待核]','S016-016','安泰160m³/d设计能力，2023年底投产；报告期站已建','实际流量、出水和膜设备','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0045','S016-016');
INSERT OR IGNORE INTO site_sources VALUES('CN0045','S016-016');
INSERT INTO process_diagram_evidence VALUES('DE016-017','D016-011','W016-012','S016-016','半年报','A,B,C,D,E,F,G','对应来源及流股');
INSERT INTO membrane_reviews VALUES('MR016-011','CN0045','D016-011','antai_160','built','2024H1披露',1,'not_identified','S016-016','安泰160m³/d设计能力，2023年底投产；报告期站已建','实际流量、出水和膜设备','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA016-011','MR016-011','CN0045','antai_160','screening',1,'分质回用/资源化与改造筛选','以BAF/氧化后水质评估UF/RO回用，比较无膜纳管','conditional','先核实际工艺、兼容性、回用需求与浓水合规；推断非事实','INFERRED；D016-011及图证据','以已查到的范围为基础，不推断未查单元','盐度、金属、氨、产水需求及浓水','核多时段流量水质、膜性能及CIP、物料平衡、盐泥去向、真实能耗与费用','比较维持现有工艺及源头减量；非膜方案',NULL,NULL,NULL,NULL,NULL,NULL,'实际工程参数不齐；不虚构难度','2026-11-27');
INSERT INTO search_log VALUES('L016-009','CN0044','W01-B6/W11-B7','中自 古楠街 安泰 2024 半年报','S016-016','两厂分图','监测及实际水量','2026-11-27');
INSERT INTO search_log VALUES('L016-010','CN0045','W01-B6/W11-B7','中自 安泰 2025募集资金报告 2023投产','S016-017','更新投产时点','实际运行','2026-11-27');
INSERT INTO sources VALUES('S016-018','鲁西集团园区零排放分盐运行','https://liaocheng.iqilu.com/lcsh/cjsx/2021/0405/4841327.shtml','媒体现场报道','2021-04-05','园区共享ED、RO、NF、MVR及盐产品，二期2019投用','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0138','S016-018');
INSERT OR IGNORE INTO site_sources VALUES('CN0138','W07S23');
INSERT INTO wastewater VALUES('W016-013','CN0138','分子筛项目低浓/高盐洗涤及硝酸雾吸收水','2026-11拟审批转载设计',NULL,NULL,NULL,'盐','园区废水零排放系统','共享系统，出水去向按园区',NULL,'W07S23','WEB_SECONDARY','Ti-MOR初级过滤洗涤/脱铝后洗涤、沸石交换过滤、硝酸雾吸收；非焚烧流股');
INSERT OR IGNORE INTO site_sources VALUES('CN0138','W07S23');
INSERT INTO wastewater VALUES('W016-014','CN0138','地面冲洗及生活污水','2026-11拟审批转载设计',NULL,NULL,NULL,NULL,'园区第三污水处理厂一期','共享设施',NULL,'W07S23','WEB_SECONDARY','非零排放系统专用流量');
INSERT OR IGNORE INTO site_sources VALUES('CN0138','S016-018');
INSERT INTO wastewater VALUES('W016-015','CN0138','关联园区零排放站','2021历史报道',NULL,NULL,NULL,'高盐水、循环排污及生化出水','化学除硬、絮凝沉淀、ED、RO、NF、MVR及冷冻结晶','水回用、NaCl供烧碱、硫酸钠芒硝','钙镁沉淀压滤作脱硫剂','S016-018','WEB_SECONDARY','共享设施，不能分配为催化剂工艺水，具体串并联待核');
INSERT INTO process_diagrams VALUES('D016-012','CN0138','sieve_project_water','design','2026-11拟审批',1,'partial','flowchart TD
 A[Ti-MOR碱处理、TS-1洗涤、沸石晶化、含氨/附钛废气处理及设备清洗] --> B[鲁西聚酰胺废液废气综合利用 焚烧]
 C[Ti-MOR初级及脱铝洗涤、沸石交换过滤、硝酸雾吸收] --> D[园区零排放站]
 E[地面冲洗、生活水] --> F[园区第三污水厂一期]','W07S23','2026拟审批转载，三条分质去向；共享站不等于本项目自有膜','实际投运、各股水量、接管水质','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0138','W07S23');
INSERT OR IGNORE INTO site_sources VALUES('CN0138','W07S23');
INSERT INTO process_diagram_evidence VALUES('DE016-018','D016-012','W0270','W07S23','拟审批转载','A,B','对应来源及流股');
INSERT OR IGNORE INTO site_sources VALUES('CN0138','W07S23');
INSERT INTO process_diagram_evidence VALUES('DE016-019','D016-012','W016-013','W07S23','同上','C,D','对应来源及流股');
INSERT OR IGNORE INTO site_sources VALUES('CN0138','W07S23');
INSERT INTO process_diagram_evidence VALUES('DE016-020','D016-012','W016-014','W07S23','同上','E,F','对应来源及流股');
INSERT INTO membrane_reviews VALUES('MR016-012','CN0138','D016-012','sieve_project_water','design','2026-11拟审批',1,'not_identified','W07S23','2026拟审批转载，三条分质去向；共享站不等于本项目自有膜','实际投运、各股水量、接管水质','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA016-012','MR016-012','CN0138','sieve_project_water','screening',1,'分质回用/资源化与改造筛选','优先高浓水与零排放支路分质，评估低盐洗涤液直接回用；不擅自改变焚烧路线','conditional','先核实际工艺、兼容性、回用需求与浓水合规；推断非事实','INFERRED；D016-012及图证据','以已查到的范围为基础，不推断未查单元','有机胺、盐种、接管标准、共享费用','核多时段流量水质、膜性能及CIP、物料平衡、盐泥去向、真实能耗与费用','比较维持现有工艺及源头减量；非膜方案',NULL,NULL,NULL,NULL,NULL,NULL,'实际工程参数不齐；不虚构难度','2026-11-27');
INSERT INTO process_diagrams VALUES('D016-013','CN0138','shared_zld_park','historical','2021报道',1,'partial','flowchart TD
 A[园区高盐及生化出水等] --> B[化学除硬 絮凝沉淀]
 B --> C[ED、RO、NF、MVR及冷冻结晶组合]
 C --> D[水回用]
 C --> E[NaCl供离子膜烧碱]
 C --> F[芒硝]
 B --> G[钙镁沉淀压滤作脱硫剂]','S016-018','共享园区站历史分盐运行，非催化剂专线；不猜膜连接顺序','实际分配、水量、进水标准和各段成本待核','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0138','S016-018');
INSERT OR IGNORE INTO site_sources VALUES('CN0138','S016-018');
INSERT INTO process_diagram_evidence VALUES('DE016-021','D016-013','W016-015','S016-018','现场报道','A,B,C,D,E,F,G','对应来源及流股');
INSERT INTO membrane_reviews VALUES('MR016-013','CN0138','D016-013','shared_zld_park','historical','2021报道',1,'confirmed_present','S016-018','共享园区站历史分盐运行，非催化剂专线；不猜膜连接顺序','实际分配、水量、进水标准和各段成本待核','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0138','S016-018');
INSERT INTO membrane_units VALUES('MU016-006','MR016-013','ED','ED','浓缩',NULL,NULL,NULL,'共享站','S016-018','报道','仅该时期及范围');
INSERT OR IGNORE INTO site_sources VALUES('CN0138','S016-018');
INSERT INTO membrane_units VALUES('MU016-007','MR016-013','RO','RO','水回用',NULL,NULL,NULL,'共享站','S016-018','报道','仅该时期及范围');
INSERT OR IGNORE INTO site_sources VALUES('CN0138','S016-018');
INSERT INTO membrane_units VALUES('MU016-008','MR016-013','NF','NF','分盐',NULL,NULL,NULL,'共享站','S016-018','报道','仅该时期及范围');
INSERT INTO membrane_retrofits VALUES('RA016-013','MR016-013','CN0138','shared_zld_park','screening',1,'分质回用/资源化与改造筛选','核共享站分配与剩余能力，优先现有分盐优化，不重复建专线','conditional','先核实际工艺、兼容性、回用需求与浓水合规；推断非事实','INFERRED；D016-013及图证据','以已查到的范围为基础，不推断未查单元','实际水量、盐水去向、膜压力和费用','核多时段流量水质、膜性能及CIP、物料平衡、盐泥去向、真实能耗与费用','比较维持现有工艺及源头减量；非膜方案',NULL,NULL,NULL,NULL,NULL,NULL,'实际工程参数不齐；不虚构难度','2026-11-27');
INSERT INTO search_log VALUES('L016-011','CN0138','W01-B6/W11-B7','鲁西 新型分子筛 2026-11-19 拟审批 分股','W07S23','旧源补低浓零排放及生活去向，另查园区共享系统','项目投产及水量','2026-11-27');
INSERT INTO process_diagrams VALUES('D016-014','CN0095','ruthenium_recovery','design','2026拟审批',1,'partial','flowchart TD
 A[酸浸液及渣洗水] --> B[危废委外]
 C[酸冷凝及旋蒸残液] --> D[工艺回用]
 E[过滤、制备、喷淋、地洗] --> F[45m³收集池 分批检测]
 F -->|检出金属| D
 F -->|其他| G[酸碱中和] --> H[可门园区污水厂]','W07S04','钌再生与制造项目，45m³为容积；旧证据结构化','实际水量、金属浓度、回用标准','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0095','W07S04');
INSERT OR IGNORE INTO site_sources VALUES('CN0095','W07S04');
INSERT INTO process_diagram_evidence VALUES('DE016-022','D016-014','W0229','W07S04','拟审批','A,B','对应来源及流股');
INSERT OR IGNORE INTO site_sources VALUES('CN0095','W07S04');
INSERT INTO process_diagram_evidence VALUES('DE016-023','D016-014','W0230','W07S04','拟审批','C,D','对应来源及流股');
INSERT OR IGNORE INTO site_sources VALUES('CN0095','W07S04');
INSERT INTO process_diagram_evidence VALUES('DE016-024','D016-014','W0231','W07S04','拟审批','E,F,G,H,D','对应来源及流股');
INSERT INTO membrane_reviews VALUES('MR016-014','CN0095','D016-014','ruthenium_recovery','design','2026拟审批',1,'not_identified','W07S04','钌再生与制造项目，45m³为容积；旧证据结构化','实际水量、金属浓度、回用标准','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA016-014','MR016-014','CN0095','ruthenium_recovery','screening',1,'分质回用/资源化与改造筛选','先按钌检测及回收分流，低金属中和后如有回用需求测试耐酸NF/RO；禁止混入高价值钌液','conditional','先核实际工艺、兼容性、回用需求与浓水合规；推断非事实','INFERRED；D016-014及图证据','以已查到的范围为基础，不推断未查单元','钌回收价值、盐/酸、膜材料、浓水处置','核多时段流量水质、膜性能及CIP、物料平衡、盐泥去向、真实能耗与费用','比较维持现有工艺及源头减量；非膜方案',NULL,NULL,NULL,NULL,NULL,NULL,'实际工程参数不齐；不虚构难度','2026-11-27');
INSERT INTO process_diagrams VALUES('D016-015','CN0100','no_process_water_design','design','2025批复',1,'no_production_wastewater','flowchart TD
 A[设计无工艺生产废水]
 B[地面清洗水] --> C[资质单位委外]
 D[冷却排污及纯水浓水] --> F[南岳水务]
 E[生活污水] --> G[化粪池] --> F','turn347204search32','仅批复拟建项目，无工艺生产废水；地洗委外、公用水另行处理','实际验收及是否产生工艺水待核','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0100','turn347204search32');
INSERT OR IGNORE INTO site_sources VALUES('CN0100','turn347204search32');
INSERT INTO process_diagram_evidence VALUES('DE016-025','D016-015','W0003','turn347204search32','批复','A','对应来源及流股');
INSERT OR IGNORE INTO site_sources VALUES('CN0100','turn347204search32');
INSERT INTO process_diagram_evidence VALUES('DE016-026','D016-015','W0004','turn347204search32','批复','B,C','对应来源及流股');
INSERT OR IGNORE INTO site_sources VALUES('CN0100','turn347204search32');
INSERT INTO process_diagram_evidence VALUES('DE016-027','D016-015','W0005','turn347204search32','批复','D,E,F,G','对应来源及流股');
INSERT INTO membrane_reviews VALUES('MR016-015','CN0100','D016-015','no_process_water_design','design','2025批复',1,'not_applicable','turn347204search32','仅批复拟建项目，无工艺生产废水；地洗委外、公用水另行处理','实际验收及是否产生工艺水待核','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA016-015','MR016-015','CN0100','no_process_water_design','screening',1,'分质回用/资源化与改造筛选','生产污水膜不适用；如公用排水有回用需求另立范围','not_applicable','先核实际工艺、兼容性、回用需求与浓水合规；推断非事实','INFERRED；D016-015及图证据','以已查到的范围为基础，不推断未查单元','实际投产核实、地洗委外量','核多时段流量水质、膜性能及CIP、物料平衡、盐泥去向、真实能耗与费用','比较维持现有工艺及源头减量；非膜方案',NULL,NULL,NULL,NULL,NULL,NULL,'实际工程参数不齐；不虚构难度','2026-11-27');
INSERT INTO sources VALUES('S016-019','南化湖北15000吨项目安全预评价','https://safety.zagy.com.cn/nd.jsp?id=199','安全评价机构公示','2026','仙桃龙华山街道新材料产业园、94亩、总投资7.88亿元及设计15000吨','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0040','S016-019');
INSERT OR IGNORE INTO site_sources VALUES('CN0040','S016-019');
INSERT INTO evidence_notes VALUES('N016-005','CN0040','S016-019','项目选址与投资','公示项目概要','仙桃龙华山街道新材料产业园，94亩、投资7.88亿元为总项目投资；尚无污水工艺及验收。','WEB_SECONDARY','关键内容提取；来源见索引','2026-11-27');
INSERT INTO search_log VALUES('L016-012','CN0040','W01-B6/W11-B7','南化湖北 15000 沸石分子筛 仙桃','S016-019','取得安全预评价，水措施未披露','查审批、污水站设备','2026-11-27');
INSERT INTO sources VALUES('S016-020','北京奥达现场调研','https://scc.sinopec.com/scc/news/qyxw/2026/9/I1552499422682677248.shtml','企业报道','2026-09','联合一/二车间生产与聚烯烃催化剂','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0006','S016-020');
INSERT OR IGNORE INTO site_sources VALUES('CN0006','S016-020');
INSERT INTO claims VALUES('CL016-005','CN0006','生产状态','2026年9月企业报道查看联合一、二车间生产运行','WEB_COMPANY','S016-020','报告期生产线证据；水站未查','2026-11-27');
INSERT INTO search_log VALUES('L016-013','CN0006','W01-B6/W11-B7','奥达 聚烯烃 催化剂 2026 生产','S016-020','取得生产状态，水处理缺失','许可执行和废水设施','2026-11-27');
INSERT INTO sources VALUES('S016-021','上海基本有机催化剂一期节能审查','https://www.scip.gov.cn/govxxgk/jjfzc/2025-04-18/a02d74a6-b446-4e03-9a76-2585c2108eaf.html','政府节能审查','2025-04-18','B5-8环氧丙烷1200及丙烯腈600吨/年','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0009','S016-021');
INSERT OR IGNORE INTO site_sources VALUES('CN0009','S016-021');
INSERT INTO evidence_notes VALUES('N016-006','CN0009','S016-021','分项产能','节能审查','B5-8地块，一期1200吨/年环氧丙烷、600吨/年丙烯腈催化剂；总1800既有，分项不叠加；非投产。','WEB_PRIMARY','关键内容提取；来源见索引','2026-11-27');
INSERT INTO capacity VALUES('C016-006','CN0009','环氧丙烷催化剂',1200,'吨/年','节能审查设计','2025','一期分项','S016-021','合计1800，非新增总量');
INSERT INTO capacity VALUES('C016-007','CN0009','丙烯腈催化剂',600,'吨/年','节能审查设计','2025','一期分项','S016-021','合计1800，非新增总量');
INSERT INTO search_log VALUES('L016-014','CN0009','W01-B6/W11-B7','上海基本有机催化剂 1800 节能审查 废水','S016-021','补产品分项，未查具体水站','查环评及验收','2026-11-27');
INSERT INTO search_log VALUES('L016-015','CN0023','W01-B6/W11-B7','西南化工 泸州 新津 催化剂 污水 设施',NULL,'仅集团合计4000既有，未得厂级工艺','园区许可、旧名','2026-11-27');
INSERT INTO search_log VALUES('L016-016','CN0031','W01-B6/W11-B7','铜川凯立 催化剂 废水 2025 年报',NULL,'危废转移仅身份线索，未取得水站','铜川园区许可及验收','2026-11-27');
COMMIT;
