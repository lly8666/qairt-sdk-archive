-- 018: 基地补漏、设备合同、共享站及厂区排口事实
BEGIN;
INSERT INTO water_metrics VALUES('M018-001','CN0031','W0124','铜川污水处理站排口','总镉',0,NULL,'mg/L','年报披露浓度（表头误写mg/标立方米，以限值列单位判断）',NULL,'2024',NULL,0.05,'W01B2S15','报告零值，非无水、非检出限；报告未列实测流量');
INSERT INTO water_metrics VALUES('M018-002','CN0031','W0124','铜川污水处理站排口','总镍',0,NULL,'mg/L','年报披露浓度（表头误写mg/标立方米，以限值列单位判断）',NULL,'2024',NULL,1,'W01B2S15','报告零值，非无水、非检出限；报告未列实测流量');
INSERT INTO water_metrics VALUES('M018-003','CN0031','W0124','铜川污水处理站排口','总镉排放量',0,NULL,'t/a','年报披露全年排放量',NULL,'2024',NULL,NULL,'W01B2S15','报告零值，非无水、非检出限；报告未列实测流量');
INSERT INTO water_metrics VALUES('M018-004','CN0031','W0124','铜川污水处理站排口','总镍排放量',0,NULL,'t/a','年报披露全年排放量',NULL,'2024',NULL,NULL,'W01B2S15','报告零值，非无水、非检出限；报告未列实测流量');
INSERT OR IGNORE INTO site_sources VALUES('CN0031','W01B2S15');
INSERT INTO evidence_notes VALUES('N018-001','CN0031','W01B2S15','报告期排放','2024年报第五节环境信息','铜川独立站1个间歇排放口，镉镍报告浓度及全年总量均为0，限值0.05及1mg/L；公司称环保设施正常运行。西安第八污水厂是母厂描述，不能给铜川套用。','WEB_PRIMARY','关键内容提取；来源见索引','2026-11-27');
INSERT INTO search_log VALUES('L018-001','CN0031','W01-B8/W11-B9','铜川凯立 2024年报 废水 镉 镍','W01B2S15','复用已有来源补四项结构化指标，不虚增来源或工艺图','铜川单独站工艺和许可执行','2026-11-27');
INSERT INTO sources VALUES('S018-001','德创环保2024半年报','https://money.finance.sina.com.cn/corp/view/vCB_AllBulletinDetail.php?id=10447342&stockid=603177','上市公司半年报','2024-08','环境信息：德创母厂、越信、飞乐分别披露','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0062','S018-001');
INSERT INTO sources VALUES('S018-002','浙江德创土壤隐患排查报告','https://www.zj-tuna.com/ueditor/php/upload/file/20231117/%E5%BE%B7%E5%88%9B%E5%9C%9F%E5%A3%A4%E9%9A%90%E6%82%A3%E6%8E%92%E6%9F%A5%E6%8A%A5%E5%91%8A.pdf','企业公开报告','2023','2.6.2、2.6.4，现有综合站及设计改扩建污泥','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0062','S018-002');
INSERT INTO sources VALUES('S018-003','浙江德创新增1万吨废催化剂资源化再生环评公示','https://www.zj-tuna.com/ueditor/php/upload/file/20230323/123111111123132123.pdf','企业环评公示','2023-03','原址扩建，处理量、产品与铁框架分项','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0062','S018-003');
INSERT OR IGNORE INTO site_sources VALUES('CN0062','S018-001');
INSERT INTO wastewater VALUES('W018-001','CN0062','挤出模具清洗、冷凝及车间地面冲洗','2024H1报告期运行',NULL,NULL,NULL,NULL,'隔油、沉淀','市政污水管网',NULL,'S018-001','WEB_COMPANY','母厂原文；飞乐120m³/d MBR是独立填埋场，不归属德创催化剂');
INSERT OR IGNORE INTO site_sources VALUES('CN0062','S018-001');
INSERT INTO wastewater VALUES('W018-002','CN0062','生活污水','2024H1报告期运行',NULL,NULL,NULL,NULL,'化粪池','市政污水管网',NULL,'S018-001','WEB_COMPANY','母厂');
INSERT OR IGNORE INTO site_sources VALUES('CN0062','S018-001');
INSERT INTO wastewater VALUES('W018-003','CN0062','原料混合氨气喷淋吸收液','2024H1报告期运行',NULL,NULL,NULL,'氨','喷淋吸收液','回混料工序',NULL,'S018-001','WEB_COMPANY','废气净化吸收液内部回用；非全厂废水');
INSERT OR IGNORE INTO site_sources VALUES('CN0062','S018-002');
INSERT INTO wastewater VALUES('W018-004','CN0062','纯水制备排水、喷淋水、洗地及生活水','2023隐患排查现有设施',NULL,NULL,NULL,NULL,'粪便污水化粪池、食堂水隔油；其他与综合水系统汇合物化沉淀','三江路管网→绍兴水处理发展有限公司',NULL,'S018-002','WEB_COMPANY','2.6.2历史报告；2024半年报生活污水纳管描述不判定完全相同连接');
INSERT OR IGNORE INTO site_sources VALUES('CN0062','S018-002');
INSERT INTO evidence_notes VALUES('N018-002','CN0062','S018-002','现有站及边界','2.6.2、表2.6-2','现有综合站1套物化沉淀；改扩建表预测处理污泥240t/a、清洗槽渣57.6t/a，按原报告HW49管理，非实际称量。厂区危废许可3500t/a为该历史时点口径；2023新扩建另列。','WEB_COMPANY','关键内容提取；来源见索引','2026-11-27');
INSERT INTO water_metrics VALUES('M018-005','CN0062',NULL,'改扩建设计','废水处理污泥',240,NULL,'t/a','报告预测',NULL,'2023',NULL,NULL,'S018-002','非实际；HW49原表');
INSERT INTO water_metrics VALUES('M018-006','CN0062',NULL,'改扩建设计','清洗槽渣',57.6,NULL,'t/a','报告预测',NULL,'2023',NULL,NULL,'S018-002','非实际；HW49原表');
INSERT INTO capacity VALUES('C018-001','CN0062','废催化剂',10000,'t/a','拟扩建处置量','2023','再生资源化扩建','S018-003','不与新剂m³产能合计');
INSERT INTO capacity VALUES('C018-002','CN0062','催化剂产品',6300,'t/a','达产设计','2023','再生资源化扩建','S018-003','不与新剂m³产能合计');
INSERT INTO capacity VALUES('C018-003','CN0062','铁框架回收',3020,'t/a','达产副产品','2023','再生资源化扩建','S018-003','不与新剂m³产能合计');
INSERT INTO projects VALUES('P018-001','CN0062','新增1万吨/年废催化剂资源化再生利用','2023环评公示','2023-03','废剂10000t/a、催化剂产品6300t/a','改扩建污水具体单元未核','S018-003');
INSERT OR IGNORE INTO site_sources VALUES('CN0062','S018-001');
INSERT INTO claims VALUES('CL018-001','CN0062','母厂水工艺','挤出模具清洗等生产水隔油沉淀纳管；氨喷淋液回混料','WEB_COMPANY','S018-001','2024H1；排除飞乐120m³/d内置MBR','2026-11-27');
INSERT INTO process_diagrams VALUES('D018-001','CN0062','dechuang_manufacturing_water','operating','2024H1',1,'partial','flowchart TD
 A[挤出模具洗水 冷凝水 地面冲洗] --> B[隔油 沉淀] --> C[市政污水管网]
 D[生活污水] --> E[化粪池] --> C
 F[原料混合氨喷淋液] --> G[混料回用]','S018-001','母厂报告期；非飞乐填埋站；未取得再生新线独立处理证据','实际水量、钒钨/氨/盐浓度、再生线独立工艺','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0062','S018-001');
INSERT OR IGNORE INTO site_sources VALUES('CN0062','S018-001');
INSERT INTO process_diagram_evidence VALUES('DE018-001','D018-001','W018-001','S018-001','母厂废水','A,B,C','来源支持的节点与流向');
INSERT OR IGNORE INTO site_sources VALUES('CN0062','S018-001');
INSERT INTO process_diagram_evidence VALUES('DE018-002','D018-001','W018-002','S018-001','母厂生活水','D,E,C','来源支持的节点与流向');
INSERT OR IGNORE INTO site_sources VALUES('CN0062','S018-001');
INSERT INTO process_diagram_evidence VALUES('DE018-003','D018-001','W018-003','S018-001','氨吸收液','F,G','来源支持的节点与流向');
INSERT INTO membrane_reviews VALUES('MR018-001','CN0062','D018-001','dechuang_manufacturing_water','operating','2024H1',1,'not_identified','S018-001','母厂报告期；非飞乐填埋站；未取得再生新线独立处理证据','实际水量、钒钨/氨/盐浓度、再生线独立工艺','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA018-001','MR018-001','CN0062','dechuang_manufacturing_water','screening',1,'分质回用、资源化、既有工艺优化','生产水与氨吸收液分开；核物化澄清水的金属和盐，若需回用再试UF或NF/RO','conditional','实际进水、回用需求及合法残余物去向需明确','INFERRED；D018-001及图证据','只基于已查到的事实范围；候选方案非已建','实际回用需求、盐、钒钨、SS、浓水去向和费用','连续多工况采样及水盐物料衡算，核膜相容性与CIP、实测能耗和处置费；必要时中试','与现有工艺和源头分流、非膜路线比较',NULL,NULL,NULL,NULL,NULL,NULL,'缺实际工程参数不打分','2026-11-27');
INSERT INTO process_diagrams VALUES('D018-002','CN0062','existing_combined_station','historical','2023隐患排查',1,'partial','flowchart TD
 A[纯水排水 喷淋水 洗地水] --> D[综合收集 物化沉淀]
 B[粪便污水] --> C[化粪池] --> D
 E[食堂污水] --> F[隔油] --> D
 D --> G[三江路污水管网] --> H[绍兴水处理发展有限公司]','S018-002','2023报告的现有混合厂站；非2024报告同一期流向确认','水量、现行设施和膜待核','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0062','S018-002');
INSERT OR IGNORE INTO site_sources VALUES('CN0062','S018-002');
INSERT INTO process_diagram_evidence VALUES('DE018-004','D018-002','W018-004','S018-002','2.6.2','A,B,C,D,E,F,G,H','来源支持的节点与流向');
INSERT INTO membrane_reviews VALUES('MR018-002','CN0062','D018-002','existing_combined_station','historical','2023隐患排查',1,'not_identified','S018-002','2023报告的现有混合厂站；非2024报告同一期流向确认','水量、现行设施和膜待核','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA018-002','MR018-002','CN0062','existing_combined_station','screening',1,'分质回用、资源化、既有工艺优化','先核各支路和现有物化水质，再评低盐水直接回用或膜深度回用','conditional','实际进水、回用需求及合法残余物去向需明确','INFERRED；D018-002及图证据','只基于已查到的事实范围；候选方案非已建','水质波动、药耗、排水量、回用及浓水限制','连续多工况采样及水盐物料衡算，核膜相容性与CIP、实测能耗和处置费；必要时中试','与现有工艺和源头分流、非膜路线比较',NULL,NULL,NULL,NULL,NULL,NULL,'缺实际工程参数不打分','2026-11-27');
UPDATE sites SET water_summary=COALESCE(water_summary||'；','')||'2024H1母厂隔油沉淀及氨吸收液回混料；2023现有综合物化站纳绍兴水处理；飞乐120m³/d MBR不属于本厂',water_level='有工艺线索',source_status='本轮证据补充',as_of='2026-11-27' WHERE site_id='CN0062';
UPDATE tasks SET state='部分完成',next_query='查再生扩建验收、金属和水量、实际成本' WHERE site_id='CN0062';
UPDATE sites SET address='绍兴市越城区袍江新区三江路以南' WHERE site_id='CN0062';
INSERT INTO search_log VALUES('L018-002','CN0062','W01-B8/W11-B9','浙江德创 挤出模具清洗废水 2024半年报','S018-001','取得母厂实际工艺并澄清120m³/d MBR归属','再生线独立水量、设备及验收','2026-11-27');
INSERT INTO sources VALUES('S018-004','昊华西南院眉山清洁能源催化材料基地投产报道','https://hzeyun.com/detail/2582123','行业报道','2023-12-05','一期投产、七条生产线计划规模、含盐水资源化','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0202','S018-004');
INSERT INTO sources VALUES('S018-005','眉山基地安装工程施工招标公告转载','https://www.bidcenter.com.cn/newscontent-191904595-1.html','企业招标转载','2022','4980吨/年总设计、新建装置分项及工艺水循环、硝酸钠结晶EPC、搬迁','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0202','S018-005');
INSERT INTO sources VALUES('S018-006','眉山工艺水循环EPC中标快讯','https://www.cbi360.net/hyzx/70260819968925.html','中标信息转载','2026-08-19','杭州水处理技术研究开发中心联合体中标；金额1000万元以上','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0202','S018-006');
INSERT INTO sources VALUES('S018-007','眉山EPC招标中标索引','https://m.bidcenter.com.cn/enterprise/xnhgmsyxgs/','中标索引','2026-08-24','二次招标0747-2660SCCZUP32；索引显示约1640万元','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0202','S018-007');
INSERT INTO sources VALUES('S018-008','眉山扩产项目土建招标','https://www.tujianzhaobiao.com/news-d28e4b66634f6949d67decfa0f37e2de/','招标转载','2026-09-28','38t/h、1400t/a、计划2027-04-30前投产','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0202','S018-008');
INSERT OR IGNORE INTO site_sources VALUES('CN0202','S018-004');
INSERT INTO wastewater VALUES('W018-005','CN0202','含盐废水','2023一期投产报道',NULL,NULL,NULL,'盐','高效含盐废水处理装置','副产品回收利用','副产品类别及对应装置见2022招标硝酸钠结晶，连接未知','S018-004','WEB_SECONDARY','2023一期已投产；不能确认七条均达产或膜设备');
INSERT OR IGNORE INTO site_sources VALUES('CN0202','S018-005');
INSERT INTO wastewater VALUES('W018-006','CN0202','工艺废水循环处理与硝酸钠结晶设施','2022安装招标设计',NULL,NULL,NULL,'硝酸盐','工艺废水循环EPC、硝酸钠结晶EPC；具体连接未披露','循环利用/硝酸钠产品','独立污水处理EPC','S018-005','WEB_SECONDARY','招标列装置，不构造无证据箭头');
INSERT OR IGNORE INTO site_sources VALUES('CN0202','S018-007');
INSERT INTO water_economics VALUES('E018-001','CN0202',NULL,'38t/h工艺水循环处理EPC中标金额（索引约数）',1640,'万元','中标索引显示1.64千万元','2026-08-24','S018-007','约数，非结算、非纯膜设备；二次EPC编号0747-2660SCCZUP32；与快讯>1000万元相容');
INSERT OR IGNORE INTO site_sources VALUES('CN0202','S018-006');
INSERT INTO evidence_notes VALUES('N018-003','CN0202','S018-006','承包单位','中标快讯','杭州水处理技术研究开发中心有限公司联合体中标，快讯8月18日中标，8月19日发布；不因供应商有膜业务就认定本项目使用膜。','WEB_SECONDARY','关键内容提取；来源见索引','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0202','S018-008');
INSERT INTO evidence_notes VALUES('N018-004','CN0202','S018-008','扩产工期','土建招标','原500吨/年改为1400，新增38t/h工艺水循环装置，2027-04-30前计划投产；计划非现状。','WEB_SECONDARY','关键内容提取；来源见索引','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0202','S018-005');
INSERT INTO evidence_notes VALUES('N018-005','CN0202','S018-005','搬迁及规模','2.2招标范围','4980t/a总设计，新建铜系1600、浸渍镍1200、沉淀镍600、贵金属30；招标另列从新津搬迁装置，既有新津产能不能与眉山无条件相加；2023投产报道约5000t/a为基地项目规模。','WEB_SECONDARY','关键内容提取；来源见索引','2026-11-27');
INSERT INTO capacity VALUES('C018-004','CN0202','基地全部催化剂',4980,'t/a','2022施工招标设计','2022','基地总量与新建分项','S018-005','分项包含在总量中；另有搬迁装置，实际达产待核');
INSERT INTO capacity VALUES('C018-005','CN0202','新建铜系',1600,'t/a','2022施工招标设计','2022','基地总量与新建分项','S018-005','分项包含在总量中；另有搬迁装置，实际达产待核');
INSERT INTO capacity VALUES('C018-006','CN0202','浸渍法镍系',1200,'t/a','2022施工招标设计','2022','基地总量与新建分项','S018-005','分项包含在总量中；另有搬迁装置，实际达产待核');
INSERT INTO capacity VALUES('C018-007','CN0202','沉淀法镍系',600,'t/a','2022施工招标设计','2022','基地总量与新建分项','S018-005','分项包含在总量中；另有搬迁装置，实际达产待核');
INSERT INTO capacity VALUES('C018-008','CN0202','贵金属',30,'t/a','2022施工招标设计','2022','基地总量与新建分项','S018-005','分项包含在总量中；另有搬迁装置，实际达产待核');
INSERT OR IGNORE INTO site_sources VALUES('CN0202','S018-004');
INSERT INTO claims VALUES('CL018-002','CN0202','投产状态','2023年一期正式投产，铜系产出合格产品；基地约5000吨/年设计','WEB_SECONDARY','S018-004','非全部七条实际达产','2026-11-27');
INSERT INTO projects VALUES('P018-002','CN0202','清洁能源催化材料产业化基地一期','正式投产报道','2023-12-05','4980t/a设计基地；一期投产范围待核','含盐废水副产品回收与工艺水循环','S018-004');
INSERT INTO projects VALUES('P018-003','CN0202','铜系500吨扩至1400吨技改','EPC中标、土建招标','2026-09-28','计划2027-04-30前投产','38t/h工艺水循环；EPC中标约1640万元','S018-008');
INSERT INTO process_diagrams VALUES('D018-003','CN0202','meishan_saline_recovery','historical','2023一期投产',1,'partial','flowchart TD
 A[含盐废水] --> B[含盐废水高效处理装置] --> C[副产物回收]
 D[工艺废水] --> E[循环利用技术]
 F[2022招标硝酸钠结晶装置]','S018-004','2023报道已用水循环和副产品回收；2022设计装置单列不推定串联','实际膜与结晶连接、分股水质及能耗','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0202','S018-004');
INSERT OR IGNORE INTO site_sources VALUES('CN0202','S018-004');
INSERT INTO process_diagram_evidence VALUES('DE018-005','D018-003','W018-005','S018-004','投产报道','A,B,C,D,E','来源支持的节点与流向');
INSERT OR IGNORE INTO site_sources VALUES('CN0202','S018-005');
INSERT INTO process_diagram_evidence VALUES('DE018-006','D018-003','W018-006','S018-005','安装招标','F','来源支持的节点与流向');
INSERT INTO membrane_reviews VALUES('MR018-003','CN0202','D018-003','meishan_saline_recovery','historical','2023一期投产',1,'not_identified','S018-004','2023报道已用水循环和副产品回收；2022设计装置单列不推定串联','实际膜与结晶连接、分股水质及能耗','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA018-003','MR018-003','CN0202','meishan_saline_recovery','screening',1,'分质回用、资源化、既有工艺优化','先核含盐装置、硝酸钠回收与水循环的实际连接；若既有结晶前缺适用浓缩，可比较ED/RO预浓缩','conditional','实际进水、回用需求及合法残余物去向需明确','INFERRED；D018-003及图证据','只基于已查到的事实范围；候选方案非已建','水量、离子组成、硝酸钠纯度、回用指标、既有膜与能耗','连续多工况采样及水盐物料衡算，核膜相容性与CIP、实测能耗和处置费；必要时中试','与现有工艺和源头分流、非膜路线比较',NULL,NULL,NULL,NULL,NULL,NULL,'缺实际工程参数不打分','2026-11-27');
INSERT INTO process_diagrams VALUES('D018-004','CN0202','copper_upgrade_38tph','design','2026EPC',1,'partial','flowchart TD
 A[扩产铜系工艺水] --> B[新建38t/h工艺水循环处理成套装置，单元未知] --> C[工艺循环]','W03S11','2026EPC，38t/h设计非全厂排水；杭州水处理中心联合体中标','技术协议、实际进水、膜与计划投产','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0202','W03S11');
INSERT OR IGNORE INTO site_sources VALUES('CN0202','W03S11');
INSERT INTO process_diagram_evidence VALUES('DE018-007','D018-004',NULL,'W03S11','EPC招标','A,B,C','来源支持的节点与流向');
INSERT OR IGNORE INTO site_sources VALUES('CN0202','S018-008');
INSERT INTO process_diagram_evidence VALUES('DE018-008','D018-004',NULL,'S018-008','土建招标','B','来源支持的节点与流向');
INSERT INTO membrane_reviews VALUES('MR018-004','CN0202','D018-004','copper_upgrade_38tph','design','2026EPC',1,'not_identified','W03S11','2026EPC，38t/h设计非全厂排水；杭州水处理中心联合体中标','技术协议、实际进水、膜与计划投产','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA018-004','MR018-004','CN0202','copper_upgrade_38tph','screening',1,'分质回用、资源化、既有工艺优化','优先与现EPC承包范围协调，核是否已含膜及硝酸钠资源化，避免重复建设','conditional','实际进水、回用需求及合法残余物去向需明确','INFERRED；D018-004及图证据','只基于已查到的事实范围；候选方案非已建','EPC技术方案、回收率、运行保证值、成本、实际验收','连续多工况采样及水盐物料衡算，核膜相容性与CIP、实测能耗和处置费；必要时中试','与现有工艺和源头分流、非膜路线比较',NULL,NULL,NULL,NULL,NULL,NULL,'缺实际工程参数不打分','2026-11-27');
UPDATE sites SET water_summary=COALESCE(water_summary||'；','')||'2023一期投产含盐水处理/副产物回收，2026新增38t/h循环装置中标约1640万元（索引）',water_level='有工艺线索',source_status='本轮证据补充',as_of='2026-11-27' WHERE site_id='CN0202';
UPDATE tasks SET state='部分完成',next_query='核EPC技术协议、具体膜型、成本、2027投产' WHERE site_id='CN0202';
UPDATE sites SET address='四川眉山东坡区高新技术产业园区',status='2023一期投产；2026扩产EPC中标、拟2027投产',capacity_summary='4980t/a基地设计，2023一期投产；铜系500t/a线2026拟扩至1400t/a（非额外全厂产能）' WHERE site_id='CN0202';
INSERT INTO search_log VALUES('L018-003','CN0202','W01-B8/W11-B9','西南化工眉山 工艺水循环 38 中标 2026','S018-006','补承包商、EPC索引约数、2023一期与新津搬迁边界','中标完整金额和具体技术','2026-11-27');
INSERT INTO sources VALUES('S018-009','天辰绿能己二腈废催化剂减量项目环评','https://epb.zibo.gov.cn/gongkai/channel_c_5f9fa491ab327f36e4c13066_n_1605682663.2363/doc_657fe79951e1465e7208e229_a247fb04be857995e3ce8056364c3a29.pdf','政府公开环评','2023','3.11.2及表3.11-15/16；共享站工艺与在线监测','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0083','S018-009');
INSERT INTO sources VALUES('S018-010','天辰齐翔污水站外包运维采购','https://bid.cncecyc.com/cms/channel/ywgg3jt3/574158.htm','企业采购公告','2026-07','项目概况：330m³/h，两系列、8400h，分质预处理及生化、污泥','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0083','S018-010');
INSERT OR IGNORE INTO site_sources VALUES('CN0083','S018-009');
INSERT INTO wastewater VALUES('W018-007','CN0083','关联天辰齐翔污水站综合水','2023环评既有',NULL,NULL,NULL,'高COD、高氨、氟','芬顿或除氟分质预处理→均质→水解酸化→改良A/O→混凝沉淀→前臭氧→两级A/O/MBR→后臭氧→活性炭（达标旁路）','园区接管','高压板框，泥含水率<60%，委托资质处置','S018-009','WEB_PRIMARY','非天辰绿能专线；2026运维范围另列，不能直接推断现行膜状态');
INSERT OR IGNORE INTO site_sources VALUES('CN0083','S018-010');
INSERT INTO wastewater VALUES('W018-008','CN0083','关联天辰齐翔综合站','2026运维采购既有范围',330,'m³/h','共享站设计处理能力','高COD、含氰废水、高浓度等','高浓度预处理/破氰预处理、综调、水解酸化、缺氧、好氧、二沉、高效沉淀及过滤','达标排放；具体受纳待核','5套板框污泥脱水','S018-010','WEB_COMPANY','采购明确接收绿能废水；不是催化剂厂独立规模；2026公告未明确MBR，不认定拆除');
INSERT INTO water_metrics VALUES('M018-007','CN0083','W018-008','共享站','单系列设计能力',165,NULL,'m³/h','采购设计',NULL,'2026',NULL,NULL,'S018-010','非厂独立或实测');
INSERT INTO water_metrics VALUES('M018-008','CN0083','W018-008','共享站','年连续运行时间',8400,NULL,'h/a','采购设计',NULL,'2026',NULL,NULL,'S018-010','非厂独立或实测');
INSERT INTO water_metrics VALUES('M018-009','CN0083','W018-008','共享站','操作弹性下限',50,NULL,'%','采购设计',NULL,'2026',NULL,NULL,'S018-010','非厂独立或实测');
INSERT INTO water_metrics VALUES('M018-010','CN0083','W018-008','共享站','操作弹性上限',110,NULL,'%','采购设计',NULL,'2026',NULL,NULL,'S018-010','非厂独立或实测');
INSERT INTO water_metrics VALUES('M018-011','CN0083','W018-008','共享站','综调池氰化物要求',0.5,NULL,'mg/L','采购要求小于该值',NULL,'2026',NULL,NULL,'S018-010','非厂独立或实测');
INSERT INTO water_metrics VALUES('M018-012','CN0083','W018-008','共享站','板框数量',5,NULL,'套','采购设备数量',NULL,'2026',NULL,NULL,'S018-010','非厂独立或实测');
INSERT INTO water_metrics VALUES('M018-013','CN0083','W018-007','减量项目接管协议进水指标','COD',10250,NULL,'mg/L','协议限值',NULL,'2023',NULL,10250,'S018-009','表3.11-15；全盐与TDS按原表不同口径保留，非实测');
INSERT INTO water_metrics VALUES('M018-014','CN0083','W018-007','减量项目接管协议进水指标','氨氮',110,NULL,'mg/L','协议限值',NULL,'2023',NULL,110,'S018-009','表3.11-15；全盐与TDS按原表不同口径保留，非实测');
INSERT INTO water_metrics VALUES('M018-015','CN0083','W018-007','减量项目接管协议进水指标','全盐量',1900,NULL,'mg/L','协议限值',NULL,'2023',NULL,1900,'S018-009','表3.11-15；全盐与TDS按原表不同口径保留，非实测');
INSERT INTO water_metrics VALUES('M018-016','CN0083','W018-007','减量项目接管协议进水指标','SS',10,NULL,'mg/L','协议限值',NULL,'2023',NULL,10,'S018-009','表3.11-15；全盐与TDS按原表不同口径保留，非实测');
INSERT INTO water_metrics VALUES('M018-017','CN0083','W018-007','减量项目接管协议进水指标','溶解性总固体',26100,NULL,'mg/L','协议限值',NULL,'2023',NULL,26100,'S018-009','表3.11-15；全盐与TDS按原表不同口径保留，非实测');
INSERT INTO water_metrics VALUES('M018-018','CN0083','W018-007','共享站排口在线监测','COD',NULL,'6.58–26.9','mg/L','历史实测范围',NULL,'2023-01',NULL,NULL,'S018-009','表3.11-16；非2026同一排口标准或催化剂专线');
INSERT INTO water_metrics VALUES('M018-019','CN0083','W018-007','共享站排口在线监测','氨氮',NULL,'0.0114–0.0247','mg/L','历史实测范围',NULL,'2023-01',NULL,NULL,'S018-009','表3.11-16；非2026同一排口标准或催化剂专线');
INSERT INTO water_metrics VALUES('M018-020','CN0083','W018-007','共享站排口在线监测','COD',NULL,'9.02–28.6','mg/L','历史实测范围',NULL,'2023-02',NULL,NULL,'S018-009','表3.11-16；非2026同一排口标准或催化剂专线');
INSERT INTO water_metrics VALUES('M018-021','CN0083','W018-007','共享站排口在线监测','氨氮',NULL,'0.0110–0.3160','mg/L','历史实测范围',NULL,'2023-02',NULL,NULL,'S018-009','表3.11-16；非2026同一排口标准或催化剂专线');
INSERT INTO water_metrics VALUES('M018-022','CN0083','W018-007','共享站排口在线监测','COD',NULL,'11.7–30.6','mg/L','历史实测范围',NULL,'2023-03',NULL,NULL,'S018-009','表3.11-16；非2026同一排口标准或催化剂专线');
INSERT INTO water_metrics VALUES('M018-023','CN0083','W018-007','共享站排口在线监测','氨氮',NULL,'0.0106–0.8150','mg/L','历史实测范围',NULL,'2023-03',NULL,NULL,'S018-009','表3.11-16；非2026同一排口标准或催化剂专线');
INSERT INTO water_metrics VALUES('M018-024','CN0083','W018-007','共享站排口在线监测','COD',NULL,'0.2160–29.1','mg/L','历史实测范围',NULL,'2023-04',NULL,NULL,'S018-009','表3.11-16；非2026同一排口标准或催化剂专线');
INSERT INTO water_metrics VALUES('M018-025','CN0083','W018-007','共享站排口在线监测','氨氮',NULL,'0.011–0.611','mg/L','历史实测范围',NULL,'2023-04',NULL,NULL,'S018-009','表3.11-16；非2026同一排口标准或催化剂专线');
INSERT INTO water_metrics VALUES('M018-026','CN0083','W018-007','共享站排口在线监测','COD',NULL,'0.221–28.1','mg/L','历史实测范围',NULL,'2023-05',NULL,NULL,'S018-009','表3.11-16；非2026同一排口标准或催化剂专线');
INSERT INTO water_metrics VALUES('M018-027','CN0083','W018-007','共享站排口在线监测','氨氮',NULL,'0.0112–0.111','mg/L','历史实测范围',NULL,'2023-05',NULL,NULL,'S018-009','表3.11-16；非2026同一排口标准或催化剂专线');
INSERT INTO water_metrics VALUES('M018-028','CN0083','W018-007','共享站排口在线监测','COD',NULL,'0.375–27.6','mg/L','历史实测范围',NULL,'2023-06',NULL,NULL,'S018-009','表3.11-16；非2026同一排口标准或催化剂专线');
INSERT INTO water_metrics VALUES('M018-029','CN0083','W018-007','共享站排口在线监测','氨氮',NULL,'0.0109–0.155','mg/L','历史实测范围',NULL,'2023-06',NULL,NULL,'S018-009','表3.11-16；非2026同一排口标准或催化剂专线');
INSERT INTO water_metrics VALUES('M018-030','CN0083','W018-007','共享站排口在线监测','COD',30.6,NULL,'mg/L','2023H1监测最大值',NULL,'2023H1',NULL,40,'S018-009','表3.11-16；2026验收转载口径不同，不能直接比较');
INSERT INTO water_metrics VALUES('M018-031','CN0083','W018-007','共享站排口在线监测','氨氮',0.815,NULL,'mg/L','2023H1监测最大值',NULL,'2023H1',NULL,2,'S018-009','表3.11-16；2026验收转载口径不同，不能直接比较');
INSERT OR IGNORE INTO site_sources VALUES('CN0083','S018-009');
INSERT INTO evidence_notes VALUES('N018-006','CN0083','S018-009','共享站工艺及监测边界','3.11.2.3、表3.11-15/16','历史芬顿/除氟后均质、水解酸化、改良AO、混凝、前臭氧、两级A/O至MBR、后臭氧与活性炭备用；泥高压板框含水率<60%。接管COD10250、氨110、全盐1900、SS10、TDS26100均为协议指标，2023H1排口在线COD及氨范围分月入库。2026外包采购明确330m³/h和破氰等，未明确膜状态；不能自动沿用历史图为2026实际。','WEB_PRIMARY','关键内容提取；来源见索引','2026-11-27');
INSERT INTO process_diagrams VALUES('D018-005','CN0083','tianchen_shared_historical','historical','2023环评既有',1,'partial','flowchart TD
 A[高浓水] --> B[芬顿]
 C[含氟水] --> D[除氟]
 B --> E[均质] 
 D --> E
 F[其他污水] --> E
 E --> G[水解酸化] --> H[改良AO] --> I[混凝沉淀] --> J[前臭氧] --> K[两级AO与MBR] --> L[后臭氧]
 L -->|达标| M[排放]
 L -->|必要时| N[活性炭] --> M','S018-009','天辰齐翔共享站，2023历史资料；非绿能独占，活性炭为保险旁路','2026是否同配置、膜规格、负荷、回用与排放口径','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0083','S018-009');
INSERT OR IGNORE INTO site_sources VALUES('CN0083','S018-009');
INSERT INTO process_diagram_evidence VALUES('DE018-009','D018-005','W018-007','S018-009','3.11.2.3','A,B,C,D,E,F,G,H,I,J,K,L,M,N','来源支持的节点与流向');
INSERT INTO membrane_reviews VALUES('MR018-005','CN0083','D018-005','tianchen_shared_historical','historical','2023环评既有',1,'confirmed_present','S018-009','天辰齐翔共享站，2023历史资料；非绿能独占，活性炭为保险旁路','2026是否同配置、膜规格、负荷、回用与排放口径','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0083','S018-009');
INSERT INTO membrane_units VALUES('MU018-001','MR018-005','MBR膜池','MBR','两级AO末端固液分离','改良AO及臭氧等后续两级AO','后臭氧',NULL,'未披露膜材/通量','S018-009','3.11.2.3','仅该时期及范围');
INSERT INTO membrane_retrofits VALUES('RA018-005','MR018-005','CN0083','tianchen_shared_historical','screening',1,'分质回用、资源化、既有工艺优化','先核现行MBR是否保留；若可优化盐和难降解支路，优先分质及现有站负荷管理','conditional','实际进水、回用需求及合法残余物去向需明确','INFERRED；D018-005及图证据','只基于已查到的事实范围；候选方案非已建','实际水质、膜规格、共享站计费/回用、浓水许可','连续多工况采样及水盐物料衡算，核膜相容性与CIP、实测能耗和处置费；必要时中试','与现有工艺和源头分流、非膜路线比较',NULL,NULL,NULL,NULL,NULL,NULL,'缺实际工程参数不打分','2026-11-27');
INSERT INTO process_diagrams VALUES('D018-006','CN0083','tianchen_shared_2026_tender','built','2026运维采购',1,'partial','flowchart TD
 A[高浓度废水] --> B[高浓度预处理] --> E[综合调节]
 C[含氰废水] --> D[破氰预处理] --> E
 F[其他水含绿能废水] --> E
 E --> G[两系列生化 水解酸化 缺氧 好氧 二沉] --> H[高效沉淀及过滤] --> I[达标排放]
 G --> J[污泥系统 5套板框]','S018-010','共享330m³/h运维采购，设施清单边界；非当前监测或专线膜','2026具体膜、预处理单元、实际排放与分配水量','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0083','S018-010');
INSERT OR IGNORE INTO site_sources VALUES('CN0083','S018-010');
INSERT INTO process_diagram_evidence VALUES('DE018-010','D018-006','W018-008','S018-010','项目概况及内容','A,B,C,D,E,F,G,H,I,J','来源支持的节点与流向');
INSERT INTO membrane_reviews VALUES('MR018-006','CN0083','D018-006','tianchen_shared_2026_tender','built','2026运维采购',1,'not_identified','S018-010','共享330m³/h运维采购，设施清单边界；非当前监测或专线膜','2026具体膜、预处理单元、实际排放与分配水量','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA018-006','MR018-006','CN0083','tianchen_shared_2026_tender','screening',1,'分质回用、资源化、既有工艺优化','优先核现有站改良AO/MBR历史与采购现状差异；独立催化剂水若有回用需求先核盐氰及接管','conditional','实际进水、回用需求及合法残余物去向需明确','INFERRED；D018-006及图证据','只基于已查到的事实范围；候选方案非已建','绿能分股水量、危废成本、共享站实际计费与膜状态','连续多工况采样及水盐物料衡算，核膜相容性与CIP、实测能耗和处置费；必要时中试','与现有工艺和源头分流、非膜路线比较',NULL,NULL,NULL,NULL,NULL,NULL,'缺实际工程参数不打分','2026-11-27');
INSERT INTO process_diagrams VALUES('D018-007','CN0083','green_energy_acceptance_boundary','historical','2026-10验收转载',1,'partial','flowchart TD
 A[610及630部分设备洗水] --> B[天辰齐翔共享站]
 C[610特定晶化釜清洗废液 约20m³/a] --> D[资质单位]
 E[废气治理废水 约200m³/a] --> D','W03S16','验收转载范围；两种委外废液不进共享站；数值为约数非排水实绩','项目实际流量、委外费用、现有专线设备','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0083','W03S16');
INSERT OR IGNORE INTO site_sources VALUES('CN0083','W03S16');
INSERT INTO process_diagram_evidence VALUES('DE018-011','D018-007',NULL,'W03S16','验收转载废水段','A,B,C,D,E','来源支持的节点与流向');
INSERT INTO membrane_reviews VALUES('MR018-007','CN0083','D018-007','green_energy_acceptance_boundary','historical','2026-10验收转载',1,'not_identified','W03S16','验收转载范围；两种委外废液不进共享站；数值为约数非排水实绩','项目实际流量、委外费用、现有专线设备','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA018-007','MR018-007','CN0083','green_energy_acceptance_boundary','screening',1,'分质回用、资源化、既有工艺优化','核委外废液成分与处置费；先分质回收可回收胺或溶剂，再比较膜/蒸发与现有委外','conditional','实际进水、回用需求及合法残余物去向需明确','INFERRED；D018-007及图证据','只基于已查到的事实范围；候选方案非已建','实际废液成分、量、接管限值、危险属性、费用','连续多工况采样及水盐物料衡算，核膜相容性与CIP、实测能耗和处置费；必要时中试','与现有工艺和源头分流、非膜路线比较',NULL,NULL,NULL,NULL,NULL,NULL,'缺实际工程参数不打分','2026-11-27');
UPDATE sites SET water_summary=COALESCE(water_summary||'；','')||'共享站2023芬顿/除氟+改良AO+臭氧+两级AO/MBR；2026运维采购330m³/h，明确含绿能来水，膜现行状态未明',water_level='有工艺线索',source_status='本轮证据补充',as_of='2026-11-27' WHERE site_id='CN0083';
UPDATE tasks SET state='部分完成',next_query='绿能专线分股实绩、共享站实际运行/膜与委外价格' WHERE site_id='CN0083';
INSERT INTO search_log VALUES('L018-004','CN0083','W01-B8/W11-B9','天辰齐翔 污水处置外包运维 330 2026 芬顿 MBR','S018-010','历史站工艺、12月指标及2026采购边界补证；旧2026验收指标不重复','共享站中标与分配水量','2026-11-27');
INSERT INTO sites VALUES('CN0248','新疆德创环保有限公司','新疆','克拉玛依','白碱滩区高新区再生资源循环经济产业园','SCR再生/资源化','2023-12环评批复；投运待核','再生/项目','废剂10000t/a设计处置量','废水储罐、压滤、一级RO、三效蒸发，冷凝回清洗；生活纳园区','有工艺线索','P1',NULL,'政府批复','2026-11-27','不同于浙江德创CN0062，设计处置量不是新剂产量');
INSERT INTO sources VALUES('S018-011','新疆德创新增1万吨废催化剂资源化再生项目批复','https://sthjt.xinjiang.gov.cn/xjepd/gwwjhpyb/202402/b38de948975647398578b93ee80d6583.shtml','政府批复','2023-12-29','新环审〔2023〕315号，废水、固废及投资','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0248','S018-011');
INSERT INTO tasks VALUES('T018-001','CN0248','P1','核投运、许可、实际水量、RO参数、产品产量、成本','项目名+验收、危废许可、污水设备','部分完成');
INSERT INTO capacity VALUES('C018-009','CN0248','废SCR催化剂资源化再生',10000,'t/a','批准设计处置量','2023','项目','S018-011','非成品量');
INSERT INTO projects VALUES('P018-004','CN0248','新增1万吨/年废催化剂资源化再生利用','环评批复','2023-12-29','10000t/a处置','一级RO＋三效蒸发回用','S018-011');
INSERT OR IGNORE INTO site_sources VALUES('CN0248','S018-011');
INSERT INTO wastewater VALUES('W018-009','CN0248','生产废水','2023环评批准设计',NULL,NULL,NULL,'重金属、盐','储罐、压滤、一级RO、三效蒸发','冷凝水回清洗，严禁外排','污泥、废盐、废RO膜危废','S018-011','WEB_PRIMARY','第三（三）（五）；产水具体连接未披露');
INSERT OR IGNORE INTO site_sources VALUES('CN0248','S018-011');
INSERT INTO wastewater VALUES('W018-010','CN0248','生活污水','2023环评批准设计',NULL,NULL,NULL,NULL,'园区管网','园区污水厂',NULL,'S018-011','WEB_PRIMARY','非全厂零排放');
INSERT OR IGNORE INTO site_sources VALUES('CN0248','S018-011');
INSERT INTO evidence_notes VALUES('N018-007','CN0248','S018-011','项目及成本边界','第一条、第三条','项目总投资3000万元、环保投资398万元，占13.27%，均非污水单项。租2栋标准厂房约3846.5m²；生产水冷凝回清洗、生活水纳管；废盐、污泥、废RO膜委外。','WEB_PRIMARY','关键内容提取；来源见索引','2026-11-27');
INSERT INTO process_diagrams VALUES('D018-008','CN0248','scr_regeneration_ro','design','2023-12批复',1,'partial','flowchart TD
 A[生产废水] --> B[废水储罐] --> C[压滤] --> D[一级RO] --> E[三效蒸发]
 E --> F[冷凝水回清洗]
 D --> G[RO产水去向待核]
 E --> H[废盐危废]
 C --> I[污泥危废]
 J[生活污水] --> K[园区污水厂]','S018-011','环评批复设计，生产水不得外排；RO产水具体回用途径未明','实际投运、流量及膜参数、盐泥费用','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0248','S018-011');
INSERT OR IGNORE INTO site_sources VALUES('CN0248','S018-011');
INSERT INTO process_diagram_evidence VALUES('DE018-012','D018-008','W018-009','S018-011','第三（三）（五）','A,B,C,D,E,F,G,H,I','来源支持的节点与流向');
INSERT OR IGNORE INTO site_sources VALUES('CN0248','S018-011');
INSERT INTO process_diagram_evidence VALUES('DE018-013','D018-008','W018-010','S018-011','第三（三）','J,K','来源支持的节点与流向');
INSERT INTO membrane_reviews VALUES('MR018-008','CN0248','D018-008','scr_regeneration_ro','design','2023-12批复',1,'confirmed_present','S018-011','环评批复设计，生产水不得外排；RO产水具体回用途径未明','实际投运、流量及膜参数、盐泥费用','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0248','S018-011');
INSERT INTO membrane_units VALUES('MU018-002','MR018-008','一级RO','RO','浓缩与回用','压滤后',NULL,'三效蒸发','设计；实际压力/回收率未披露','S018-011','第三（三）','仅该时期及范围');
INSERT INTO membrane_retrofits VALUES('RA018-008','MR018-008','CN0248','scr_regeneration_ro','screening',1,'分质回用、资源化、既有工艺优化','优先核原设计RO及三效投运，测钒钨及盐后评预处理或分盐，比较危废盐处置','conditional','实际进水、回用需求及合法残余物去向需明确','INFERRED；D018-008及图证据','只基于已查到的事实范围；候选方案非已建','实际进水、RO回收、蒸发热耗、盐去向、许可及成本','连续多工况采样及水盐物料衡算，核膜相容性与CIP、实测能耗和处置费；必要时中试','与现有工艺和源头分流、非膜路线比较',2,1,2,NULL,NULL,NULL,'已查到高盐/重金属及预处理或危废约束；其他维度缺实测留空','2026-11-27');
INSERT INTO search_log VALUES('L018-005','CN0248','W01-B8/W11-B9','新疆德创 克拉玛依 1万吨 批复 验收','S018-011','新增异地再生项目；取得最终批复工艺','现行许可与验收','2026-11-27');
INSERT INTO sources VALUES('S018-012','湖南先导废贵金属催化剂综合回收利用拟审批','https://sthjt.hunan.gov.cn/sthjt/xxgk/xzgs/jsxm/hpgs/spyjgk_2/202611/t20261116_34102463.html','政府拟审批','2026-11-16','现有厂区拟增4500t/a处置，金属盐分项、废水分质','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0185','S018-012');
INSERT OR IGNORE INTO site_sources VALUES('CN0185','S018-012');
INSERT INTO wastewater VALUES('W018-011','CN0185','回收生产废水','2026拟审批设计',NULL,NULL,NULL,'重金属、盐','pH调节、金属捕捉沉淀、絮凝、压滤；既有站压滤、五级串联还原、压滤、三级中和、压滤、MVR蒸干','蒸发冷凝回生产','固体残渣按鉴别及危废要求','S018-012','WEB_PRIMARY','既有设施被拟项目依托；非新项目已运行');
INSERT OR IGNORE INTO site_sources VALUES('CN0185','S018-012');
INSERT INTO wastewater VALUES('W018-012','CN0185','废气吸收及地面拖洗','2026拟审批设计',NULL,NULL,NULL,NULL,'直接回用','生产',NULL,'S018-012','WEB_PRIMARY','不外排设计');
INSERT OR IGNORE INTO site_sources VALUES('CN0185','S018-012');
INSERT INTO wastewater VALUES('W018-013','CN0185','初期雨水','2026拟审批设计',NULL,NULL,NULL,NULL,'既有站絮凝沉淀→循环池','生产补水',NULL,'S018-012','WEB_PRIMARY','不外排设计');
INSERT OR IGNORE INTO site_sources VALUES('CN0185','S018-012');
INSERT INTO wastewater VALUES('W018-014','CN0185','生活污水','2026拟审批设计',NULL,NULL,NULL,NULL,'化粪池','园区污水厂',NULL,'S018-012','WEB_PRIMARY','生活外排，非全厂零排放');
INSERT INTO capacity VALUES('C018-010','CN0185','外购废贵金属催化剂',4500,'t/a','拟审批设计处置量','2026-11','拟建','S018-012','非催化剂产品');
INSERT INTO capacity VALUES('C018-011','CN0185','氯化银',24.04,'t/a','拟审批设计产品','2026-11','金属盐/副产物','S018-012','纯回收，非成品催化剂');
INSERT INTO capacity VALUES('C018-012','CN0185','氯金酸',0.697,'t/a','拟审批设计产品','2026-11','金属盐/副产物','S018-012','纯回收，非成品催化剂');
INSERT INTO capacity VALUES('C018-013','CN0185','氯铂酸',14.878,'t/a','拟审批设计产品','2026-11','金属盐/副产物','S018-012','纯回收，非成品催化剂');
INSERT INTO capacity VALUES('C018-014','CN0185','二氯二氨钯',20.347,'t/a','拟审批设计产品','2026-11','金属盐/副产物','S018-012','纯回收，非成品催化剂');
INSERT INTO capacity VALUES('C018-015','CN0185','氯铑酸铵',1.051,'t/a','拟审批设计产品','2026-11','金属盐/副产物','S018-012','纯回收，非成品催化剂');
INSERT INTO capacity VALUES('C018-016','CN0185','氯铱酸铵',0.752,'t/a','拟审批设计产品','2026-11','金属盐/副产物','S018-012','纯回收，非成品催化剂');
INSERT INTO capacity VALUES('C018-017','CN0185','三氯化钌',4.566,'t/a','拟审批设计产品','2026-11','金属盐/副产物','S018-012','纯回收，非成品催化剂');
INSERT INTO capacity VALUES('C018-018','CN0185','副产品硫酸铝',3158.84,'t/a','拟审批设计产品','2026-11','金属盐/副产物','S018-012','纯回收，非成品催化剂');
INSERT OR IGNORE INTO site_sources VALUES('CN0185','S018-012');
INSERT INTO evidence_notes VALUES('N018-008','CN0185','S018-012','拟建项目界限','项目概况及（三）（四）','现有厂区拟投资9134.4万元为总项目投资，4500t/a处置，产金属盐和硫酸铝；未披露膜。熔渣、氧化铝渣、脱硫石膏渣鉴别前按危废；生产水、初雨回用与生活纳管分开。','WEB_PRIMARY','关键内容提取；来源见索引','2026-11-27');
INSERT INTO projects VALUES('P018-005','CN0185','废贵金属催化剂综合回收利用','拟审批','2026-11-16','4500t/a废剂处置','依托既有分质处理站及MVR','S018-012');
INSERT INTO process_diagrams VALUES('D018-009','CN0185','precious_metal_recovery_4500','design','2026-11拟审批',1,'partial','flowchart TD
 A[生产废水] --> B[pH调节 金属捕捉沉淀 絮凝 压滤] --> C[既有站压滤] --> D[五级还原槽] --> E[压滤] --> F[三级中和槽] --> G[压滤] --> H[MVR蒸干] --> I[冷凝水回生产]
 J[废气吸收及拖洗] --> I
 K[初雨] --> L[絮凝沉淀 循环池] --> I
 M[生活污水] --> N[化粪池] --> O[园区污水厂]','S018-012','拟建纯回收项目，既有站为依托；生产及初雨回用，生活外排','实际投运、分股水质、水量、MVR能耗及残盐去向','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0185','S018-012');
INSERT OR IGNORE INTO site_sources VALUES('CN0185','S018-012');
INSERT INTO process_diagram_evidence VALUES('DE018-014','D018-009','W018-011','S018-012','第三（三）','A,B,C,D,E,F,G,H,I','来源支持的节点与流向');
INSERT OR IGNORE INTO site_sources VALUES('CN0185','S018-012');
INSERT INTO process_diagram_evidence VALUES('DE018-015','D018-009','W018-012','S018-012','同上','J,I','来源支持的节点与流向');
INSERT OR IGNORE INTO site_sources VALUES('CN0185','S018-012');
INSERT INTO process_diagram_evidence VALUES('DE018-016','D018-009','W018-013','S018-012','同上','K,L,I','来源支持的节点与流向');
INSERT OR IGNORE INTO site_sources VALUES('CN0185','S018-012');
INSERT INTO process_diagram_evidence VALUES('DE018-017','D018-009','W018-014','S018-012','同上','M,N,O','来源支持的节点与流向');
INSERT INTO membrane_reviews VALUES('MR018-009','CN0185','D018-009','precious_metal_recovery_4500','design','2026-11拟审批',1,'not_identified','S018-012','拟建纯回收项目，既有站为依托；生产及初雨回用，生活外排','实际投运、分股水质、水量、MVR能耗及残盐去向','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA018-009','MR018-009','CN0185','precious_metal_recovery_4500','screening',1,'分质回用、资源化、既有工艺优化','先保留贵金属捕捉与分质回收，测后端盐、残金属及酸碱，评NF/ED/RO预浓缩减少MVR能耗；不将浓水金属损失算作收益','conditional','实际进水、回用需求及合法残余物去向需明确','INFERRED；D018-009及图证据','只基于已查到的事实范围；候选方案非已建','金属回收率、废盐性质、盐度、膜耐受、实际流量和费用','连续多工况采样及水盐物料衡算，核膜相容性与CIP、实测能耗和处置费；必要时中试','与现有工艺和源头分流、非膜路线比较',2,1,NULL,NULL,NULL,NULL,'已查到高盐/重金属及预处理或危废约束；其他维度缺实测留空','2026-11-27');
UPDATE sites SET water_summary=COALESCE(water_summary||'；','')||'2026拟批4500t/a纯回收，五级还原＋三级中和及MVR蒸干；初雨和生产回用、生活纳管',water_level='有工艺线索',source_status='本轮证据补充',as_of='2026-11-27' WHERE site_id='CN0185';
UPDATE tasks SET state='部分完成',next_query='最终批复及投运后金属、盐、费用' WHERE site_id='CN0185';
UPDATE sites SET city='衡阳',address='耒阳市大市循环经济产业园',capacity_summary='2026拟审批4500t/a废贵金属催化剂处置，产金属盐及硫酸铝（非催化剂成品）' WHERE site_id='CN0185';
INSERT INTO search_log VALUES('L018-006','CN0185','W01-B8/W11-B9','湖南先导 2026年11月 废贵金属催化剂 废水','S018-012','既有主体补最新拟审批分质工艺和产物','最终批复、验收及实际成本','2026-11-27');
INSERT INTO sources VALUES('S018-013','大连智源伟业客户案例','https://www.dlzywy.com/a/kehu/index.html','供应商案例',NULL,'中科催化化工生产用纯水二级反渗透','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0029','S018-013');
INSERT OR IGNORE INTO site_sources VALUES('CN0029','S018-013');
INSERT INTO evidence_notes VALUES('N018-009','CN0029','S018-013','膜用途辨析','客户清单','中科催化新技术（大连）股份有限公司化工生产用纯水为二级反渗透，不能据此确认生产废水膜；仍缺污水处理资料。','WEB_COMPANY','关键内容提取；来源见索引','2026-11-27');
INSERT INTO search_log VALUES('L018-007','CN0029','W01-B8/W11-B9','中科催化新技术 大连 污水 反渗透 供应商','S018-013','识别纯水RO，不填污水膜或虚增工艺图','按污水工程名称和许可执行检索','2026-11-27');
INSERT INTO search_log VALUES('L018-008','CN0032','W01-B8/W11-B9','彬州凯立 2940吨 高端功能催化材料 废水 2026',NULL,'首次公示无新增水站细节','按本厂工程采购/许可及实际运行证据查','2026-11-27');
INSERT INTO search_log VALUES('L018-009','CN0036','W01-B8/W11-B9','贵研工业催化剂 安宁 草铺 970 废水',NULL,'仅既有投资公告','按本厂工程采购/许可及实际运行证据查','2026-11-27');
INSERT INTO search_log VALUES('L018-010','CN0034','W01-B8/W11-B9','宁波康纳 贵金属 催化剂 废水',NULL,'未见该厂新处理资料','按本厂工程采购/许可及实际运行证据查','2026-11-27');
INSERT INTO search_log VALUES('L018-011','CN0023','W01-B8/W11-B9','西南化工 泸州 催化剂 污水',NULL,'排除西南院为其他客户设计的污水站','按本厂工程采购/许可及实际运行证据查','2026-11-27');
COMMIT;
