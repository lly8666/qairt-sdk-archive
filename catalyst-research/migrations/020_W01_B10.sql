-- 020: 新增两家再生厂、乌海钒钨回收、长汀膜能力冲突
BEGIN;
INSERT INTO sites VALUES('CN0249','山东鹏达生态科技股份有限公司','山东','淄博','临淄经济开发区凤凰大道1188号','催化剂载体再生/活性炭','2023项目核准；环评设计，当前投运待核','再生/项目','废邻苯二甲酸酐催化剂1500t/a；再生载体1392t/a（非成品催化剂）','酸洗废水中和、机滤、UF、ED、RO、三效蒸发；纯水排水独立纳管','有工艺线索','P1',NULL,'政府公开环评文本','2026-11-27','与活性炭酸洗共享水处理；仅载体再生，不计新剂制造产量');
INSERT INTO sources VALUES('S020-001','山东鹏达废催化剂再生利用项目环评','https://epb.zibo.gov.cn/gongkai/channel_c_5f9fa491ab327f36e4c13066_n_1605682663.2363/doc_66068183cbc9b8d285715320_28603f6d26d2c8ad559845099631dfd2.pdf','政府公开环评',NULL,'4.1及4.8：载体再生规模、分质水量、共享UF/ED/RO与蒸发','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0249','S020-001');
INSERT INTO tasks VALUES('T020-001','CN0249','P1','投运、环保验收、独立分股实际流量、膜参数及费用','项目名+许可、验收、污水站运行','部分完成');
INSERT INTO capacity VALUES('C020-001','CN0249','废苯酐催化剂',1500,'t/a','环评设计处置','环评','再生项目','S020-001','再生载体供巴斯夫，不等于成品催化剂');
INSERT INTO capacity VALUES('C020-002','CN0249','再生载体',1392,'t/a','环评设计产品','环评','再生项目','S020-001','再生载体供巴斯夫，不等于成品催化剂');
INSERT INTO projects VALUES('P020-001','CN0249','废催化剂再生利用改扩建','2023核准；环评设计','2023','1500t/a废催化剂→1392t/a载体','利用既有酸洗车间和共享膜站','S020-001');
INSERT OR IGNORE INTO site_sources VALUES('CN0249','S020-001');
INSERT INTO wastewater VALUES('W020-001','CN0249','酸洗、水洗、超声波清洗废水','环评设计',42999.695,'m³/a','项目设计产生量','酸、盐、悬浮物','42%液碱中和→机械过滤→UF→ED；ED淡水→RO；ED浓水→三效蒸发；RO浓水回ED','RO产水、蒸发冷凝水回本项目和现有活性炭酸洗','过滤渣、膜截留残渣及蒸发盐按环评危废管理','S020-001','WEB_PRIMARY','共享既有活性炭酸洗站，100m³/h为设计能力非实际运行量');
INSERT OR IGNORE INTO site_sources VALUES('CN0249','S020-001');
INSERT INTO wastewater VALUES('W020-002','CN0249','共享酸洗废水站','环评既有设施描述',100,'m³/h','设施设计处理能力','含酸盐水','机械过滤、UF、ED、RO、三效蒸发','酸洗回用','废盐、滤渣','S020-001','WEB_PRIMARY','非催化剂专用；实际运行待核');
INSERT OR IGNORE INTO site_sources VALUES('CN0249','S020-001');
INSERT INTO wastewater VALUES('W020-003','CN0249','纯水制备排水W6','环评设计',5837.68,'m³/a','项目设计排水量','盐','依托既有20m³/h混凝处理系统','齐城污水处理厂',NULL,'S020-001','WEB_PRIMARY','不属于酸洗废水回用范围，不能称全厂零排放');
INSERT INTO water_metrics VALUES('M020-001','CN0249','W020-001','项目两股水合计','设计水量合计',48837.375,NULL,'m³/a','计算合计',NULL,'环评',NULL,NULL,'S020-001','42999.695+5837.68，仅上述两股水；非全部厂区');
INSERT INTO water_metrics VALUES('M020-002','CN0249','W020-003','既有混凝设施','设施能力',20,NULL,'m³/h','环评设计',NULL,'环评',NULL,NULL,'S020-001','纯水排水处理依托设施');
INSERT OR IGNORE INTO site_sources VALUES('CN0249','S020-001');
INSERT INTO evidence_notes VALUES('N020-001','CN0249','S020-001','工程身份','4.1及项目概况','核准淄行审项核[2023]1号、淄行审项字[2023]21号；利用500m²酸洗车间，年运行2400h、100d，10人不新增；总投资300万元，环保投资44万元（均非污水单项）；历史报告许可证编号原文373703050507923623U001U，格式待核，不作为现行许可。','WEB_PRIMARY','关键内容提取；来源见索引','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0249','S020-001');
INSERT INTO evidence_notes VALUES('N020-002','CN0249','S020-001','废盐及污泥归属','4.8.3','压滤残渣1.47t/a、三效蒸发废盐128.12t/a为报告预测；报告该段表述活性炭酸洗，尚不能确认是本催化剂项目增量或共享设施量；不填入独立项目实际产生量。表4.8-7摘录部分指标表头缺失，不猜测污染物名称。','WEB_PRIMARY','关键内容提取；来源见索引','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0249','S020-001');
INSERT INTO claims VALUES('CL020-001','CN0249','水处理设计','UF—ED—RO—三效蒸发；RO浓水回ED，产水及冷凝水回酸洗','WEB_PRIMARY','S020-001','共享活性炭酸洗设施；环评非运行实绩','2026-11-27');
INSERT INTO process_diagrams VALUES('D020-001','CN0249','acid_wash_shared_membranes','design','项目环评',1,'partial','flowchart TD
 A[酸洗 水洗 超声清洗] --> B[中和 42%液碱] --> C[机械过滤] --> D[UF] --> E[ED]
 E -->|淡水| F[RO] -->|产水| G[酸洗回用]
 F -->|浓水| E
 E -->|浓水| H[三效蒸发] -->|冷凝水| G
 H --> I[蒸发盐危废]
 C --> J[滤渣危废]
 D --> J
 K[纯水制备排水] --> L[既有20m³/h混凝] --> M[齐城污水厂]','S020-001','催化剂再生与活性炭共用100m³/h设计站，不能认定专用或实际投运','膜型号、实际回收率、运行、废盐项目归属及成本','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0249','S020-001');
INSERT OR IGNORE INTO site_sources VALUES('CN0249','S020-001');
INSERT INTO process_diagram_evidence VALUES('DE020-001','D020-001','W020-001','S020-001','4.8废水治理','A,B,C,D,E,F,G,H,I,J','来源支持的范围、单元与流向');
INSERT OR IGNORE INTO site_sources VALUES('CN0249','S020-001');
INSERT INTO process_diagram_evidence VALUES('DE020-002','D020-001','W020-002','S020-001','共享能力','B,C,D,E,F,H','来源支持的范围、单元与流向');
INSERT OR IGNORE INTO site_sources VALUES('CN0249','S020-001');
INSERT INTO process_diagram_evidence VALUES('DE020-003','D020-001','W020-003','S020-001','W6','K,L,M','来源支持的范围、单元与流向');
INSERT INTO membrane_reviews VALUES('MR020-001','CN0249','D020-001','acid_wash_shared_membranes','design','项目环评',1,'confirmed_present','S020-001','催化剂再生与活性炭共用100m³/h设计站，不能认定专用或实际投运','膜型号、实际回收率、运行、废盐项目归属及成本','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0249','S020-001');
INSERT INTO membrane_units VALUES('MU020-001','MR020-001','UF','UF','悬浮物分离','机械过滤后','ED','截留物危废','型号及膜材未知','S020-001','4.8','仅该时期及范围');
INSERT OR IGNORE INTO site_sources VALUES('CN0249','S020-001');
INSERT INTO membrane_units VALUES('MU020-002','MR020-001','ED','ED','分盐浓缩','UF产水','淡水→RO','三效蒸发','具体膜堆未知','S020-001','4.8','仅该时期及范围');
INSERT OR IGNORE INTO site_sources VALUES('CN0249','S020-001');
INSERT INTO membrane_units VALUES('MU020-003','MR020-001','RO','RO','回用脱盐','ED淡水','酸洗回用','回ED','规格及回收率未披露','S020-001','4.8','仅该时期及范围');
INSERT INTO membrane_retrofits VALUES('RA020-001','MR020-001','CN0249','acid_wash_shared_membranes','screening',1,'分质回用、既有系统优化及减量','先核现有膜系统的流量、结垢与回流累盐；优化ED/RO分配及蒸发负荷，不重复建设','conditional','需核实际水质、运行与合法残余物去向','INFERRED；D020-001及对应来源','不推断未经确认的运行或技术','实际酸盐组分、回收率、膜堆能耗及CIP、残盐费用','核实投运和分股流量，连续取样；膜污染/结垢试验、盐衡算、能耗与费用核算','原工艺优化、源头分流及非膜路线比较',2,1,2,NULL,NULL,NULL,'按资料高盐及沉淀预处理、浓水蒸发和残盐约束评估；无据维度留空','2026-11-27');
INSERT INTO search_log VALUES('L020-001','CN0249','W01-B10/W11-B11','废催化剂 酸洗 电渗析 三效蒸发 山东鹏达','S020-001','新主体，定量分股、共享三膜路线','核投运及具体膜设备','2026-11-27');
INSERT INTO sites VALUES('CN0250','新疆润林环保有限公司','新疆','昌吉','准东经济技术开发区中区火烧山产业园区','SCR再生/综合固废资源化','2021二期环评设计；SCR投运待核','再生/项目','SCR再生及处置10000m³/a设计；另有其他固废35万t/a，不相加','再生废水三联箱、管式膜、ED、RO、真空结晶回用','有工艺线索','P1',NULL,'政府公开环评','2026-11-27','原HW48业务历史验收许可不证明SCR已投运；坐标89°04′28.83″E 44°55′41.86″N');
INSERT INTO sources VALUES('S020-002','新疆润林煤电冶固废处理加工二期项目环评公示版','https://sthjt.xinjiang.gov.cn/xjepd/sthjt_hjyxpj/202110/a34591d9df5d42debca442f7366e01ef/files/%E6%96%B0%E7%96%86%E6%B6%A6%E6%9E%97%E7%8E%AF%E4%BF%9D%E6%9C%89%E9%99%90%E5%85%AC%E5%8F%B8%E7%85%A4%E7%94%B5%E5%86%B6%E5%9B%BA%E5%BA%9F%E5%A4%84%E7%90%86%E5%8A%A0%E5%B7%A5%E4%BA%8C%E6%9C%9F%E9%A1%B9%E7%9B%AE%EF%BC%88%E5%85%AC%E7%A4%BA%E7%89%88%EF%BC%89.pdf','政府公开环评','2021-10','二期SCR再生与处置设计；工艺、水站能力及控制参数','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0250','S020-002');
INSERT INTO tasks VALUES('T020-002','CN0250','P1','SCR许可、实际投运及独立水量、膜型号和费用','新疆润林二期验收/危废许可及运行','部分完成');
INSERT INTO capacity VALUES('C020-003','CN0250','废SCR催化剂再生及处置',10000,'m³/a','环评设计','2021','二期SCR','S020-002','非其他煤电冶固废35万t/a');
INSERT INTO projects VALUES('P020-002','CN0250','煤电冶固废处理加工二期','2021环评','2021-10','SCR10000m³/a','50m³/d再生废水站多膜与结晶','S020-002');
INSERT OR IGNORE INTO site_sources VALUES('CN0250','S020-002');
INSERT INTO wastewater VALUES('W020-004','CN0250','SCR再生清洗废水','2021环评设计',50,'m³/d','设计处理能力','COD、SS、TDS、表面活性剂、盐、V、As','三联箱化学沉淀去重金属/Ca/Mg→管式膜→ED；淡水RO，浓水真空蒸发结晶；RO浓水回ED','RO产水及蒸发冷凝水回用','沉淀、结晶残盐的具体处置待核','S020-002','WEB_PRIMARY','未说明管式膜技术类别，非自动判定UF');
INSERT INTO water_metrics VALUES('M020-003','CN0250','W020-004','SCR水系统','预处理硬度',10,NULL,'ppm','设计控制小于该值',NULL,'2021',NULL,NULL,'S020-002','环评参数，非实测');
INSERT INTO water_metrics VALUES('M020-004','CN0250','W020-004','SCR水系统','预处理浊度',5,NULL,'NTU','设计控制小于该值',NULL,'2021',NULL,NULL,'S020-002','环评参数，非实测');
INSERT INTO water_metrics VALUES('M020-005','CN0250','W020-004','SCR水系统','ED浓缩倍数下限',5,NULL,'倍','设计参数',NULL,'2021',NULL,NULL,'S020-002','环评参数，非实测');
INSERT INTO water_metrics VALUES('M020-006','CN0250','W020-004','SCR水系统','ED浓缩倍数上限',10,NULL,'倍','设计参数',NULL,'2021',NULL,NULL,'S020-002','环评参数，非实测');
INSERT INTO water_metrics VALUES('M020-007','CN0250','W020-004','预处理','pH',NULL,'9–10','无量纲','设计控制',NULL,'2021',NULL,NULL,'S020-002','原文范围');
INSERT OR IGNORE INTO site_sources VALUES('CN0250','S020-002');
INSERT INTO evidence_notes VALUES('N020-003','CN0250','S020-002','电导率原文口径','SCR水处理工艺说明','原文电导率记法有“10ms-5ms”“<60ms”“>60ms”“<0.5ms”；大小写、量纲和范围顺序需核实，保留原记法不换算为mS/cm或TDS。真空反应釜为电加热，配真空抽滤结晶。','WEB_PRIMARY','关键内容提取；来源见索引','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0250','S020-002');
INSERT INTO evidence_notes VALUES('N020-004','CN0250','S020-002','既有与二期区分','现有工程和二期概况','既有HW48许可6543270067（2019-02-20至2024-02-19），既有工程2020验收；历史排污91652300399601720M001V（至2023-04-30）。均不能证明二期SCR投运或当前许可证有效。其他固废工艺水9240.09m³/d不归属SCR。','WEB_PRIMARY','关键内容提取；来源见索引','2026-11-27');
INSERT INTO process_diagrams VALUES('D020-002','CN0250','scr_regeneration_water','design','2021环评',1,'partial','flowchart TD
 A[SCR清洗废水] --> B[三联箱 化学沉淀] --> C[管式膜] --> D[ED]
 D -->|淡水| E[RO] -->|产水| F[回用]
 E -->|浓水| D
 D -->|浓水| G[电加热真空反应釜] --> H[真空抽滤结晶]
 G -->|冷凝水| F
 B --> I[沉淀物去向待核]
 H --> J[盐去向待核]','S020-002','二期50m³/d设计，非原HW48设施或其他固废水量','SCR投运、膜型号、实际水盐衡算、残盐及能耗','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0250','S020-002');
INSERT OR IGNORE INTO site_sources VALUES('CN0250','S020-002');
INSERT INTO process_diagram_evidence VALUES('DE020-004','D020-002','W020-004','S020-002','SCR再生废水工艺','A,B,C,D,E,F,G,H,I,J','来源支持的范围、单元与流向');
INSERT INTO membrane_reviews VALUES('MR020-002','CN0250','D020-002','scr_regeneration_water','design','2021环评',1,'confirmed_present','S020-002','二期50m³/d设计，非原HW48设施或其他固废水量','SCR投运、膜型号、实际水盐衡算、残盐及能耗','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0250','S020-002');
INSERT INTO membrane_units VALUES('MU020-004','MR020-002','管式膜','UNSPECIFIED','预处理固液分离','化学沉淀后','ED',NULL,'管式构型，不推断MF/UF','S020-002','SCR水处理','仅该时期及范围');
INSERT OR IGNORE INTO site_sources VALUES('CN0250','S020-002');
INSERT INTO membrane_units VALUES('MU020-005','MR020-002','ED','ED','浓缩','管式膜出水','RO','真空结晶','设计浓缩5–10倍','S020-002','SCR水处理','仅该时期及范围');
INSERT OR IGNORE INTO site_sources VALUES('CN0250','S020-002');
INSERT INTO membrane_units VALUES('MU020-006','MR020-002','RO','RO','脱盐回用','ED淡水','回用','回ED','原电导率单位待核','S020-002','SCR水处理','仅该时期及范围');
INSERT INTO membrane_retrofits VALUES('RA020-002','MR020-002','CN0250','scr_regeneration_water','screening',1,'分质回用、既有系统优化及减量','优先检查管式膜固液分离与钙镁控制；核ED实际浓缩和RO回流，比较蒸发负荷优化','conditional','需核实际水质、运行与合法残余物去向','INFERRED；D020-002及对应来源','不推断未经确认的运行或技术','实际离子、钒砷、污染、膜规格、电耗、废盐处置','核实投运和分股流量，连续取样；膜污染/结垢试验、盐衡算、能耗与费用核算','原工艺优化、源头分流及非膜路线比较',2,1,2,NULL,NULL,NULL,'按资料高盐及沉淀预处理、浓水蒸发和残盐约束评估；无据维度留空','2026-11-27');
INSERT INTO search_log VALUES('L020-002','CN0250','W01-B10/W11-B11','新疆 废脱硝催化剂 管式膜 电渗析 润林','S020-002','新主体；50m³/d及控制参数、三膜工艺','核投运许可及残盐','2026-11-27');
INSERT INTO sources VALUES('S020-003','江苏省危险废物跨省转移实施方案（泰州电厂至国能龙源内蒙古）','https://www.cmc.gov.cn/cms_files/filemanager/1558491259/attach/202610/0a48427935db49189a413431ca8326ea.pdf?fileName=3.%E6%B1%9F%E8%8B%8F%E7%9C%81%E5%8D%B1%E9%99%A9%E5%BA%9F%E7%89%A9%E8%B7%A8%E7%9C%81%E8%BD%AC%E7%A7%BB%E5%AE%9E%E6%96%BD%E6%96%B9%E6%A1%88.pdf','政府公开转移实施方案','2026-10','接收许可证、2025转移实绩及钒钨回收流程','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0060','S020-003');
INSERT OR IGNORE INTO site_sources VALUES('CN0060','S020-003');
INSERT INTO wastewater VALUES('W020-005','CN0060','两级酸浸废水W4-1及洗涤废水W4-2','2026转移方案所述工艺',NULL,NULL,NULL,'酸、钒、钨、盐','球磨浸出压滤，洗涤滤液回用；两级酸浸、二级滤液回一级','进入钒钨提取或废水处理（详细分流未披露）','滤渣外委或按方案处置','S020-003','WEB_PRIMARY','不推断具体污水站工艺');
INSERT OR IGNORE INTO site_sources VALUES('CN0060','S020-003');
INSERT INTO wastewater VALUES('W020-006','CN0060','萃取后废水W5-1','2026转移方案所述工艺',NULL,NULL,NULL,'钒钨回收残液、盐','硫酸铵除杂、萃取、氨反萃及蒸发结晶；萃取残水进污水处理','经厂站后外排接纳污水设施','污泥及灰渣委托处置','S020-003','WEB_PRIMARY','转移实施方案披露，不等于当前实际工况或全厂零排放');
INSERT OR IGNORE INTO site_sources VALUES('CN0060','S020-003');
INSERT INTO evidence_notes VALUES('N020-005','CN0060','S020-003','许可与实际单一客户接收量','转移方案第4节及接收方工艺','危废经营许可证1503020222，许可2万t/a，方案披露有效至2029-07-31；2025泰州电厂向该厂实际转移21批、568.62t，仅一个客户实际转移，不等于工厂全年处理量。','WEB_PRIMARY','关键内容提取；来源见索引','2026-11-27');
INSERT INTO water_metrics VALUES('M020-008','CN0060',NULL,'泰州电厂→国能龙源内蒙古','实际转移量',568.62,NULL,'t','2025单客户实际转移',NULL,'2025',NULL,NULL,'S020-003','非厂总处理量');
INSERT INTO water_metrics VALUES('M020-009','CN0060',NULL,'泰州电厂→国能龙源内蒙古','转移批数',21,NULL,'批','2025单客户实际转移',NULL,'2025',NULL,NULL,'S020-003','非厂总批数');
INSERT OR IGNORE INTO site_sources VALUES('CN0060','S020-003');
INSERT INTO claims VALUES('CL020-002','CN0060','许可','1503020222；2万t/a；有效至2029-07-31','WEB_PRIMARY','S020-003','2026转移方案披露','2026-11-27');
INSERT INTO process_diagrams VALUES('D020-003','CN0060','vanadium_tungsten_transfer_scheme','historical','2026转移方案',1,'partial','flowchart TD
 A[废SCR球磨] --> B[浸出 压滤 洗涤]
 B --> C[一级酸浸] --> D[二级酸浸]
 D -->|二级滤液| C
 B -->|洗涤滤液回用| B
 C --> E[钒钨回收液]
 E --> F[硫酸铵除杂] --> G[萃取] --> H[氨反萃] --> I[蒸发结晶]
 G --> J[萃取废水] --> K[污水处理站 单元未知] --> L[接纳污水设施]
 B --> M[固体残渣处置待核]','S020-003','接收方工艺介绍；未知的W4-1/W4-2具体接入点不补画，外排设施单元未知','实际运行、分股量、水质、污水站工艺、膜、成本','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0060','S020-003');
INSERT OR IGNORE INTO site_sources VALUES('CN0060','S020-003');
INSERT INTO process_diagram_evidence VALUES('DE020-005','D020-003','W020-005','S020-003','接收方钒钨提取工艺','A,B,C,D,E,M','来源支持的范围、单元与流向');
INSERT OR IGNORE INTO site_sources VALUES('CN0060','S020-003');
INSERT INTO process_diagram_evidence VALUES('DE020-006','D020-003','W020-006','S020-003','萃取与废水去向','E,F,G,H,I,J,K,L','来源支持的范围、单元与流向');
INSERT INTO membrane_reviews VALUES('MR020-003','CN0060','D020-003','vanadium_tungsten_transfer_scheme','historical','2026转移方案',1,'not_identified','S020-003','接收方工艺介绍；未知的W4-1/W4-2具体接入点不补画，外排设施单元未知','实际运行、分股量、水质、污水站工艺、膜、成本','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA020-003','MR020-003','CN0060','vanadium_tungsten_transfer_scheme','screening',1,'分质回用、既有系统优化及减量','优先分质保留钒钨回收，查萃余液盐及氨；在证实膜兼容及去向后比选ED/NF/RO浓缩','conditional','需核实际水质、运行与合法残余物去向','INFERRED；D020-003及对应来源','不推断未经确认的运行或技术','实际金属、盐、氨和有机萃取剂、流量、站流程及处置费用','核实投运和分股流量，连续取样；膜污染/结垢试验、盐衡算、能耗与费用核算','原工艺优化、源头分流及非膜路线比较',2,1,NULL,NULL,NULL,NULL,'按资料高盐及沉淀预处理、浓水蒸发和残盐约束评估；无据维度留空','2026-11-27');
UPDATE sites SET water_summary=COALESCE(water_summary||'；','')||'2026转移实施方案：两级酸浸、硫酸铵除杂、萃取/氨反萃及蒸发；萃取废水经站外排',water_level='有工艺线索',source_status='本轮证据补充' WHERE site_id='CN0060';
UPDATE tasks SET state='部分完成',next_query='查实际分质水量、污水站处理单元及膜设备' WHERE site_id='CN0060';
INSERT INTO search_log VALUES('L020-003','CN0060','W01-B10/W11-B11','国能龙源内蒙古 钒钨 提取 废水 跨省转移实施方案 2026','S020-003','补实际单客户转移量与工艺、许可，不当全厂实际量','厂站流程及成本','2026-11-27');
INSERT INTO sources VALUES('S020-004','嘉戎技术长汀催化剂高盐废水案例（企业官网）','https://www.jrt-memos.com/casesdata/49','供应商官网案例',NULL,'凝胶120m³/h、微球30m³/h，UF+DTRO，与2024报道微球20t/h不同','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0015','S020-004');
INSERT OR IGNORE INTO site_sources VALUES('CN0015','S020-004');
INSERT INTO evidence_notes VALUES('N020-006','CN0015','S020-004','微球设计规模冲突','官网案例与W01B2S02','官网列凝胶120m³/h、微球30m³/h，UF+DTRO与蒸发干燥；2024行业报道列凝胶120t/h、微球20t/h，设计膜回收率60%及62%。单位与数值均不一致，不能换算或选一个覆盖；须核设计变更、项目期次、实际进水密度与设备铭牌。','WEB_COMPANY','关键内容提取；来源见索引','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0015','S020-004');
INSERT INTO claims VALUES('CL020-003','CN0015','微球膜线规模冲突','供应商官网30m³/h；既有2024披露20t/h','WEB_COMPANY','S020-004','设计/案例口径，实际和变更待核','2026-11-27');
INSERT INTO water_metrics VALUES('M020-010','CN0015',NULL,'微球膜浓缩线','供应商官网披露设计能力',30,NULL,'m³/h','供应商案例',NULL,'未披露日期',NULL,NULL,'S020-004','与W0103的20t/h冲突，非新增独立线');
INSERT INTO search_log VALUES('L020-004','CN0015','W01-B10/W11-B11','嘉戎 长汀 催化剂 微球 DTRO 案例','S020-004','发现能力冲突，保留两来源，不新增重复流程','核设计变更及实际水量','2026-11-27');
-- 最新评估不重复统计被替代的审查版本

DROP VIEW v_membrane_retrofit_rating;
CREATE VIEW v_membrane_retrofit_rating_history AS SELECT a.*,
 (feed_risk+pretreatment_risk+concentrate_risk+integration_risk+operational_risk+compliance_economics_risk) AS score_total,
 CASE WHEN feasibility='not_applicable' THEN 'not_applicable'
 WHEN feasibility='infeasible' THEN 'blocked'
 WHEN (feed_risk+pretreatment_risk+concentrate_risk+integration_risk+operational_risk+compliance_economics_risk) IS NULL THEN 'unknown'
 WHEN (feed_risk+pretreatment_risk+concentrate_risk+integration_risk+operational_risk+compliance_economics_risk)<=3 THEN 'low'
 WHEN (feed_risk+pretreatment_risk+concentrate_risk+integration_risk+operational_risk+compliance_economics_risk)<=7 THEN 'medium'
 ELSE 'high' END AS difficulty
 FROM membrane_retrofits a WHERE NOT EXISTS (
 SELECT 1 FROM membrane_retrofits n WHERE n.review_id=a.review_id AND n.scope_key=a.scope_key AND n.option_key=a.option_key AND n.revision>a.revision);
CREATE VIEW v_membrane_retrofit_rating AS SELECT a.* FROM v_membrane_retrofit_rating_history a WHERE EXISTS (SELECT 1 FROM v_latest_membrane_reviews r WHERE r.review_id=a.review_id);
COMMIT;
