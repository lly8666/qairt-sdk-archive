-- 013: 设备级证据、分盐物料衡算、历史成本、独立厂家。
BEGIN;
INSERT INTO sources VALUES('W13S01','大连瑞克审核问询函回复（原件镜像）','https://qxb-pdf-osscache.qixin.com/AnBaseinfo/23f6ceec93a7ffcd11262c40789564b6.pdf','公司证券申报资料','2024','正文373—377页，CFRO设备资本化及技术参数；PDF文本可读，截图过大未成功','2026-11-27');
INSERT INTO sources VALUES('W13S02','齐鲁华信2025年度报告（全文转载）','https://www.9fzt.com/detail/bj_920832_9_6cc5b7cdf7877b720bf157cddc8ac6aa.html','公司年度报告转载','2026','79—81页环保设备和技术改造，母公司/子公司范围分别记录','2026-11-27');
INSERT INTO sources VALUES('W13S03','兰州石化催化剂废水提质与白泥回收报道','https://www.membranes.com.cn/xingyedongtai/gongyexinwen/2024-06-05/47107.html','行业协会转载企业报道','2024-06-05','微球过滤废水白泥回收，高氨氮预处理建设；非完整设施清单','2026-11-27');
INSERT INTO sources VALUES('W13S04','常州新日2800吨催化剂项目环评','https://sthjj.changzhou.gov.cn/uploadfile/hbj/2025/0529/20250529164848_32489.pdf','政府公开环评','2025-05','检索全文p78、106，复开跳转首页，截图未成功；保留设计与既有描述','2026-11-27');
INSERT INTO sources VALUES('W13S05','延长中科（大连）三期催化剂项目首次环评公示转载','https://m.yfbzb.com/inviteBid/detail/20260109_569295556.html','首次公示转载','2026-01-09','现有产品、废水去向、三期拟建六条生产线；非批复/验收，部分地点遮蔽','2026-11-27');
INSERT INTO sources VALUES('W13S06','中国科学院大连化物所平台企业介绍','https://chpt.dicp.ac.cn/ptjs2/ptjj.htm','科研机构公开介绍',NULL,'分别列中科催化及延长中科，支持独立主体，不支持产能','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0082','W13S01');
INSERT INTO wastewater VALUES('W013-001','CN0082','硝酸钠生产废水CFRO浓缩','2023-12试车/资本化验收',50,'m³/h','设计处理能力','硝酸钠、TDS','超高压膜浓缩系统CFRO；预处理细节待核','浓液作为原料回用；淡水作厂区补水','浓缩盐水回用，最终盐平衡待核','W13S01','WEB_COMPANY','373—377页；资本化验收不等于环保验收；非2026运行流量');
INSERT INTO water_metrics VALUES('M013-001','CN0082','W013-001','CFRO系统','设计压力上限',80,NULL,'bar','设计上限（原文低于此值）',NULL,'2023',NULL,NULL,'W13S01','非实测压力');
INSERT INTO water_metrics VALUES('M013-002','CN0082','W013-001','CFRO浓水','TDS',200000,NULL,'mg/L','设计参数',NULL,'2023',NULL,NULL,'W13S01','非实测；盐组成及回收率待核');
INSERT INTO water_economics VALUES('E013-001','CN0082','W013-001','CFRO预算',8080000,'元','预算','2023-12','W13S01','分项包含于总额；非运行成本');
INSERT INTO water_economics VALUES('E013-002','CN0082','W013-001','CFRO资本化总额',7186786.72,'元','实际会计资本化','2023-12','W13S01','分项包含于总额；非运行成本');
INSERT INTO water_economics VALUES('E013-003','CN0082','W013-001','CFRO设备材料费',7084561.03,'元','资本化分项','2023-12','W13S01','分项包含于总额；非运行成本');
INSERT INTO water_economics VALUES('E013-004','CN0082','W013-001','CFRO安装费',102225.69,'元','资本化分项','2023-12','W13S01','分项包含于总额；非运行成本');
INSERT OR IGNORE INTO site_sources VALUES('CN0082','W13S01');
INSERT INTO evidence_notes VALUES('N013-001','CN0082','W13S01','其他设备不混算','373—377页','2021年A6均相电渗析设备资本化1152093元，2023年B7水处理中心5785807.22元，2022水处理设备2944812.46元；用途边界未明，不能认作污水膜或与CFRO相加。CFRO 2023年9月安装、11月调试、12月试车验收转固。','WEB_COMPANY','事实摘录；非原件全文','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0082','W13S01');
INSERT INTO claims VALUES('CL013-001','CN0082','CFRO历史设备','50m³/h设计、压力<80bar、浓液TDS设计200000mg/L；2023年12月转固7186786.72元','WEB_COMPANY','W13S01','母厂硝酸钠支流；非环保验收及现行实绩','2026-11-27');
INSERT INTO process_diagrams VALUES('D013-001','CN0082','nitrate_cfro','historical','2023-12',1,'partial','flowchart TD
 A["硝酸钠生产废水"] --> B["预处理细节待核"] --> C["CFRO超高压浓缩 50m³/h设计"]
 C --> D["淡水 厂区补水"]
 C --> E["浓液 原料回用"]','W13S01','证券资料披露试车转固，限母厂硝酸钠支流','实际运行、膜供应商、全厂水量、浓液回用标准待核','2026-11-27');
INSERT INTO process_diagram_evidence VALUES('DE013-001','D013-001','W013-001','W13S01','373—377页','A,B,C,D,E','对应流股及其证据；未核节点在图中标明');
INSERT INTO membrane_reviews VALUES('MR013-001','CN0082','D013-001','nitrate_cfro','historical','2023-12',1,'confirmed_present','W13S01','证券资料披露试车转固，限母厂硝酸钠支流','实际运行、膜供应商、全厂水量、浓液回用标准待核','2026-11-27');
INSERT INTO membrane_units VALUES('MU013-001','MR013-001','CFRO','RO','超高压浓缩','硝酸钠废水','厂区补水','生产原料','设计50m³/h、<80bar、浓液TDS 200000mg/L；具体膜型号未核','W13S01','373—377页','仅该范围及时期');
INSERT INTO membrane_retrofits VALUES('RA013-001','MR013-001','CN0082','nitrate_cfro','screening',1,'分质减量/资源化/回用初筛','核实CFRO现行运行后，评估前段ED/NF分盐或现有膜回收率及盐回用优化，避免另建重复设备','conditional','实际水质及处理能力、浓水或盐产品去向、合规及经济性待核','INFERRED；D013-001；依据所连废水及设备证据','保留已有回收或预处理环节；候选路线并非已建','CFRO进水盐组成、实际通量、能耗、结垢、回用纯度、真实替代价值','多时段采样、离子/有机物平衡及膜相容性；必要时连续中试、CIP、盐/污泥鉴别、实际能耗和全成本比较','维持已验证工艺；优化源头分流、回用及回收',2,NULL,NULL,NULL,NULL,NULL,'设计浓液TDS高，渗透压和结垢风险显著；仅初筛','2026-11-27');
UPDATE sites SET water_summary='2023年12月CFRO试车转固，设计50m³/h；硝酸钠浓液原料回用、淡水补水；压力及浓水设计指标已入库',water_level='有工艺线索',source_status='部分本轮复核',as_of='2026-11-27' WHERE site_id='CN0082';
UPDATE tasks SET next_query='现场CFRO运行记录/电耗/膜供应商及盐平衡、环保验收',state='部分完成' WHERE site_id='CN0082';
INSERT INTO search_log VALUES('L013-001','CN0082','W01-B3/W11-B4','瑞克科技 超高压膜浓缩 CFRO 审核问询 50','W13S01','已核设计和资本化表','获取运行日志与环保验收','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0232','W07S11');
INSERT INTO wastewater VALUES('W013-002','CN0232','硝酸钠混合废水处理','2023环评设计',NULL,NULL,NULL,'NaNO3、固体物料','储罐→板框→UF→ED；淡液进一步海阻膜、RO；浓液进硝酸盐罐后三效降膜蒸发离心','淡水回用；蒸发冷凝回用；混合盐拟外供','滤饼回工艺、离心母液回流；盐按设计一般固废','W07S11','WEB_PRIMARY','p193—195文字及图文提取；原图截图过大未成功；具体回流接点待核');
INSERT OR IGNORE INTO site_sources VALUES('CN0232','W07S11');
INSERT INTO wastewater VALUES('W013-003','CN0232','硝酸铵废水蒸氨','2023环评设计',NULL,NULL,NULL,'NH4NO3、NaOH','加碱蒸氨；底液转入硝酸钠浓缩蒸发系统','回收氨水','底液NaNO3','W07S11','WEB_PRIMARY','p193—195，设计');
INSERT OR IGNORE INTO site_sources VALUES('CN0232','W07S11');
INSERT INTO wastewater VALUES('W013-004','CN0232','甲醛线硝酸钠废水','2023物料衡算设计',7568.64,'t/a','图中流股年质量；非体积或实绩','NaNO3','进入相应硝酸盐系统','浓缩或蒸氨',NULL,'W07S11','WEB_PRIMARY','p194—195图中文字提取；上下游勿相加，原图未截图');
INSERT INTO water_metrics VALUES('M013-003','CN0232','W013-004','甲醛线硝酸钠废水','NaNO3质量负荷',259,NULL,'t/a','设计物料衡算',NULL,'2023',NULL,NULL,'W07S11','质量负荷非浓度');
INSERT OR IGNORE INTO site_sources VALUES('CN0232','W07S11');
INSERT INTO wastewater VALUES('W013-005','CN0232','BDOA线硝酸钠废水','2023物料衡算设计',5279.15,'t/a','图中流股年质量；非体积或实绩','NaNO3','进入相应硝酸盐系统','浓缩或蒸氨',NULL,'W07S11','WEB_PRIMARY','p194—195图中文字提取；上下游勿相加，原图未截图');
INSERT INTO water_metrics VALUES('M013-004','CN0232','W013-005','BDOA线硝酸钠废水','NaNO3质量负荷',742.17,NULL,'t/a','设计物料衡算',NULL,'2023',NULL,NULL,'W07S11','质量负荷非浓度');
INSERT OR IGNORE INTO site_sources VALUES('CN0232','W07S11');
INSERT INTO wastewater VALUES('W013-006','CN0232','BDOB线硝酸钠废水','2023物料衡算设计',3306.25,'t/a','图中流股年质量；非体积或实绩','NaNO3','进入相应硝酸盐系统','浓缩或蒸氨',NULL,'W07S11','WEB_PRIMARY','p194—195图中文字提取；上下游勿相加，原图未截图');
INSERT INTO water_metrics VALUES('M013-005','CN0232','W013-006','BDOB线硝酸钠废水','NaNO3质量负荷',454.8,NULL,'t/a','设计物料衡算',NULL,'2023',NULL,NULL,'W07S11','质量负荷非浓度');
INSERT OR IGNORE INTO site_sources VALUES('CN0232','W07S11');
INSERT INTO wastewater VALUES('W013-007','CN0232','环己醇脱氢线硝酸钠废水','2023物料衡算设计',8765.25,'t/a','图中流股年质量；非体积或实绩','NaNO3','进入相应硝酸盐系统','浓缩或蒸氨',NULL,'W07S11','WEB_PRIMARY','p194—195图中文字提取；上下游勿相加，原图未截图');
INSERT INTO water_metrics VALUES('M013-006','CN0232','W013-007','环己醇脱氢线硝酸钠废水','NaNO3质量负荷',260.55,NULL,'t/a','设计物料衡算',NULL,'2023',NULL,NULL,'W07S11','质量负荷非浓度');
INSERT OR IGNORE INTO site_sources VALUES('CN0232','W07S11');
INSERT INTO wastewater VALUES('W013-008','CN0232','蒸氨底液','2023物料衡算设计',6566.4,'t/a','图中流股年质量；非体积或实绩','NaNO3','进入相应硝酸盐系统','浓缩或蒸氨',NULL,'W07S11','WEB_PRIMARY','p194—195图中文字提取；上下游勿相加，原图未截图');
INSERT INTO water_metrics VALUES('M013-007','CN0232','W013-008','蒸氨底液','NaNO3质量负荷',486.4,NULL,'t/a','设计物料衡算',NULL,'2023',NULL,NULL,'W07S11','质量负荷非浓度');
INSERT OR IGNORE INTO site_sources VALUES('CN0232','W07S11');
INSERT INTO wastewater VALUES('W013-009','CN0232','甲醛线硝酸铵废水','2023物料衡算设计',12370.98,'t/a','图中流股年质量；非体积或实绩','NH4NO3','进入相应硝酸盐系统','浓缩或蒸氨',NULL,'W07S11','WEB_PRIMARY','p194—195图中文字提取；上下游勿相加，原图未截图');
INSERT INTO water_metrics VALUES('M013-008','CN0232','W013-009','甲醛线硝酸铵废水','NH4NO3质量负荷',230.8,NULL,'t/a','设计物料衡算',NULL,'2023',NULL,NULL,'W07S11','质量负荷非浓度');
INSERT OR IGNORE INTO site_sources VALUES('CN0232','W07S11');
INSERT INTO wastewater VALUES('W013-010','CN0232','BDOB线硝酸铵废水','2023物料衡算设计',927.25,'t/a','图中流股年质量；非体积或实绩','NH4NO3','进入相应硝酸盐系统','浓缩或蒸氨',NULL,'W07S11','WEB_PRIMARY','p194—195图中文字提取；上下游勿相加，原图未截图');
INSERT INTO water_metrics VALUES('M013-009','CN0232','W013-010','BDOB线硝酸铵废水','NH4NO3质量负荷',227,NULL,'t/a','设计物料衡算',NULL,'2023',NULL,NULL,'W07S11','质量负荷非浓度');
INSERT OR IGNORE INTO site_sources VALUES('CN0232','W07S11');
INSERT INTO wastewater VALUES('W013-011','CN0232','蒸发冷凝水','2023物料衡算设计',22691.26,'t/a','流股质量；非实际排放',NULL,'三效蒸发冷凝','回用比例待核',NULL,'W07S11','WEB_PRIMARY','p194—195图文提取；与上下游及回用水不可重复合计');
INSERT OR IGNORE INTO site_sources VALUES('CN0232','W07S11');
INSERT INTO wastewater VALUES('W013-012','CN0232','标注回用水','2023物料衡算设计',19701,'t/a','流股质量；非实际排放',NULL,'图示回用量','生产回用',NULL,'W07S11','WEB_PRIMARY','p194—195图文提取；与上下游及回用水不可重复合计');
INSERT OR IGNORE INTO site_sources VALUES('CN0232','W07S11');
INSERT INTO wastewater VALUES('W013-013','CN0232','混合盐','2023物料衡算设计',2938,'t/a','流股质量；非实际排放',NULL,'离心结晶','拟外供滔博瑞溪能源','含盐2202.92t/a，原图未截图','W07S11','WEB_PRIMARY','p194—195图文提取；与上下游及回用水不可重复合计');
INSERT INTO water_metrics VALUES('M013-010','CN0232','W013-013','混合盐','盐质量',2202.92,NULL,'t/a','设计物料衡算',NULL,'2023',NULL,NULL,'W07S11','包含于2938t/a混合盐');
INSERT OR IGNORE INTO site_sources VALUES('CN0232','W07S11');
INSERT INTO wastewater VALUES('W013-014','CN0232','水损失','2023物料衡算设计',5856.43,'t/a','流股质量；非实际排放',NULL,'图示损失','不作为排水',NULL,'W07S11','WEB_PRIMARY','p194—195图文提取；与上下游及回用水不可重复合计');
INSERT OR IGNORE INTO site_sources VALUES('CN0232','W07S11');
INSERT INTO wastewater VALUES('W013-015','CN0232','氨水冷凝液','2023物料衡算设计',2022.93,'t/a','流股质量；非实际排放',NULL,'蒸氨回收','氨水回收','NH3 96.33t/a','W07S11','WEB_PRIMARY','p194—195图文提取；与上下游及回用水不可重复合计');
INSERT INTO water_metrics VALUES('M013-011','CN0232','W013-015','氨水冷凝液','NH3质量',96.33,NULL,'t/a','设计物料衡算',NULL,'2023',NULL,NULL,'W07S11','非浓度');
INSERT OR IGNORE INTO site_sources VALUES('CN0232','W07S11');
INSERT INTO evidence_notes VALUES('N013-002','CN0232','W07S11','硝酸钠设计物料衡算','p194—195','四股硝酸钠废水及蒸氨底液合计31485.69t/a；冷凝水22691.26、混合盐2938、水损失5856.43合计同值。19701t/a是图中标注回用量，不重复加入总量；未核冷凝水剩余去向。截图失败，仅文本提取。','WEB_PRIMARY','事实摘录；非原件全文','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0232','W07S11');
INSERT INTO claims VALUES('CL013-002','CN0232','膜和蒸发设计','板框、UF、ED、海阻膜（具体型式待核）、RO、三效降膜蒸发、离心；硝酸铵加碱蒸氨','WEB_PRIMARY','W07S11','2023新增2800吨项目设计；非验收','2026-11-27');
INSERT INTO process_diagrams VALUES('D013-002','CN0232','nitrate_uf_ed_ro','design','2023',1,'partial','flowchart TD
 A["硝酸钠废水储罐"] --> B["板框压滤"] --> C["UF"] --> D["ED"]
 B --> J["滤饼工艺回用"]
 D --> E["淡液 海阻膜"] --> F["RO"] --> G["回用水"]
 D --> H["硝酸盐浓液罐"] --> I["三效降膜蒸发/离心"]
 I --> K["混合盐拟外供；母液回流"]
 I --> G
 L["硝酸铵废水 加碱蒸氨"] --> H
 L --> M["氨水回收"]','W07S11','2800吨新项目环评设计；支流非全厂；图按文字简化','海阻膜种类、详细连接、运行验收及盐合规待核','2026-11-27');
INSERT INTO process_diagram_evidence VALUES('DE013-002','D013-002','W013-002','W07S11','p193—195','A,B,C,D,E,F,G,H,I,J,K','对应流股及其证据；未核节点在图中标明');
INSERT INTO process_diagram_evidence VALUES('DE013-003','D013-002','W013-003','W07S11','p194—195','L,M','对应流股及其证据；未核节点在图中标明');
INSERT INTO membrane_reviews VALUES('MR013-002','CN0232','D013-002','nitrate_uf_ed_ro','design','2023',1,'confirmed_present','W07S11','2800吨新项目环评设计；支流非全厂；图按文字简化','海阻膜种类、详细连接、运行验收及盐合规待核','2026-11-27');
INSERT INTO membrane_units VALUES('MU013-002','MR013-002','UF','UF','去除颗粒','板框后','ED进水',NULL,'规格待核','W07S11','p193—195','仅该范围及时期');
INSERT INTO membrane_units VALUES('MU013-003','MR013-002','ED','ED','分盐浓缩','UF后','淡液进一步膜处理','硝酸盐浓液罐','规格待核','W07S11','p193—195','仅该范围及时期');
INSERT INTO membrane_units VALUES('MU013-004','MR013-002','海阻膜','UNSPECIFIED','淡液进一步处理','ED淡液',NULL,NULL,'名称按原文；不臆定型号','W07S11','p193—195','仅该范围及时期');
INSERT INTO membrane_units VALUES('MU013-005','MR013-002','RO','RO','深度回用','进一步膜处理后','回用水',NULL,'规格待核','W07S11','p193—195','仅该范围及时期');
INSERT INTO membrane_retrofits VALUES('RA013-002','MR013-002','CN0232','nitrate_uf_ed_ro','screening',1,'分质减量/资源化/回用初筛','优先验收已设计UF+ED+RO与蒸发耦合，比较ED浓缩效率及蒸氨/蒸发热集成；非重复建设','conditional','实际水质及处理能力、浓水或盐产品去向、合规及经济性待核','INFERRED；D013-002；依据所连废水及设备证据','保留已有回收或预处理环节；候选路线并非已建','实测盐度、氨及有机物、设备能耗、盐产品销路、浓液循环、实际水量','多时段采样、离子/有机物平衡及膜相容性；必要时连续中试、CIP、盐/污泥鉴别、实际能耗和全成本比较','维持已验证工艺；优化源头分流、回用及回收',2,1,NULL,NULL,NULL,NULL,'设计含高硝酸盐、需压滤及UF；分盐性能待中试','2026-11-27');
UPDATE sites SET water_summary='2023设计铜滤洗回用，硝酸钠支路板框+UF+ED+海阻膜+RO+三效降膜蒸发；硝酸铵加碱蒸氨，底液入浓缩；设计流股质量已入库',water_level='有工艺线索',source_status='部分本轮复核',as_of='2026-11-27' WHERE site_id='CN0232';
UPDATE tasks SET next_query='获取项目竣工环保验收、实测电渗析与蒸发负荷、盐鉴别及回用水',state='部分完成' WHERE site_id='CN0232';
INSERT INTO search_log VALUES('L013-002','CN0232','W01-B3/W11-B4','河北瑞克 2800 吨 环评 4.6.6 硝酸盐 电渗析','W07S11','旧源p185基础上新取p193—195；原图截图失败','验收及原图','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0027','W13S02');
INSERT INTO wastewater VALUES('W013-016','CN0027','母液硅回收','2025年报披露',9,'m³/h','装置能力','硅','酸化调pH、硅胶沉淀、带滤及洗涤','硅胶返结晶',NULL,'W13S02','WEB_COMPANY','年报79—81页；主体归属按年报母公司范围；非实际负荷');
INSERT OR IGNORE INTO site_sources VALUES('CN0027','W13S02');
INSERT INTO wastewater VALUES('W013-017','CN0027','高氨氮废水蒸发结晶','2025年报披露',20,'m³/h','装置能力','氨氮、硫酸盐','高氨氮废水蒸发结晶','硫酸铵、硫酸钠资源化',NULL,'W13S02','WEB_COMPANY','设备能力非实测进水；共享设施边界待核');
INSERT OR IGNORE INTO site_sources VALUES('CN0027','W13S02');
INSERT INTO evidence_notes VALUES('N013-003','CN0027','W13S02','设施清单','79—81页','共享齐鲁石化设施；高氨氮汽提塔1、一级和二级吸收各1、高氨压滤1、收集罐2；另列压滤6、多级沉降。原表混排的270/150/20单位不明，不填。','WEB_COMPANY','事实摘录；非原件全文','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0027','W13S02');
INSERT INTO claims VALUES('CL013-003','CN0027','母液与高氨处理','9m³/h硅胶回收、20m³/h高氨废水蒸发结晶；共享齐鲁石化环保设施','WEB_COMPANY','W13S02','2025年度披露；非实测流量','2026-11-27');
INSERT INTO process_diagrams VALUES('D013-003','CN0027','silica_recovery','historical','2025年报',1,'partial','flowchart TD
 A["母液"] --> B["酸化调pH"] --> C["硅胶沉淀"] --> D["带滤/洗涤"] --> E["硅胶返结晶"]
 D --> F["滤液去向待核"]','W13S02','母液回收9m³/h装置，非厂全水','滤液流向、设备实测、共享设施待核','2026-11-27');
INSERT INTO process_diagram_evidence VALUES('DE013-004','D013-003','W013-016','W13S02','79—81页','A,B,C,D,E,F','对应流股及其证据；未核节点在图中标明');
INSERT INTO membrane_reviews VALUES('MR013-003','CN0027','D013-003','silica_recovery','historical','2025年报',1,'not_identified','W13S02','母液回收9m³/h装置，非厂全水','滤液流向、设备实测、共享设施待核','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA013-003','MR013-003','CN0027','silica_recovery','screening',1,'分质减量/资源化/回用初筛','优先保持硅回收；清液低SS后试UF/RO或ED，比较与现有蒸发系统衔接','conditional','实际水质及处理能力、浓水或盐产品去向、合规及经济性待核','INFERRED；D013-003；依据所连废水及设备证据','保留已有回收或预处理环节；候选路线并非已建','硅胶过滤后SS、硅、盐、pH、浓水去向','多时段采样、离子/有机物平衡及膜相容性；必要时连续中试、CIP、盐/污泥鉴别、实际能耗和全成本比较','维持已验证工艺；优化源头分流、回用及回收',NULL,1,NULL,NULL,NULL,NULL,'硅胶沉淀/过滤已有证据，膜前除胶体仍需验证','2026-11-27');
INSERT INTO process_diagrams VALUES('D013-004','CN0027','high_ammonia_crystallization','historical','2025年报',1,'partial','flowchart TD
 A["高氨氮废水"] --> B["蒸发结晶 20m³/h装置"] --> C["硫酸铵、硫酸钠回收"]
 B --> D["冷凝液及母液去向待核"]','W13S02','高氨氮装置历史年报披露，非共享站全流程','汽提与蒸发具体串联、冷凝去向、盐纯度待核','2026-11-27');
INSERT INTO process_diagram_evidence VALUES('DE013-005','D013-004','W013-017','W13S02','79—81页','A,B,C,D','对应流股及其证据；未核节点在图中标明');
INSERT INTO membrane_reviews VALUES('MR013-004','CN0027','D013-004','high_ammonia_crystallization','historical','2025年报',1,'not_identified','W13S02','高氨氮装置历史年报披露，非共享站全流程','汽提与蒸发具体串联、冷凝去向、盐纯度待核','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA013-004','MR013-004','CN0027','high_ammonia_crystallization','screening',1,'分质减量/资源化/回用初筛','先核脱氨与盐回收边界；评估ED分盐或膜预浓缩能否减少蒸发负荷','conditional','实际水质及处理能力、浓水或盐产品去向、合规及经济性待核','INFERRED；D013-004；依据所连废水及设备证据','保留已有回收或预处理环节；候选路线并非已建','高氨水pH、盐、氨、硅、蒸发热耗及盐产品纯度','多时段采样、离子/有机物平衡及膜相容性；必要时连续中试、CIP、盐/污泥鉴别、实际能耗和全成本比较','维持已验证工艺；优化源头分流、回用及回收',NULL,NULL,NULL,NULL,NULL,NULL,'缺实测/工程输入，不打分','2026-11-27');
UPDATE sites SET water_summary='2025年报：9m³/h母液硅回收（酸化沉淀带滤返结晶）、20m³/h高氨氮蒸发结晶；共享齐鲁石化设施',water_level='有工艺线索',source_status='部分本轮复核',as_of='2026-11-27' WHERE site_id='CN0027';
UPDATE tasks SET next_query='共享污水站水量和盐平衡、母液回收运行/许可、蒸发与汽提关系',state='部分完成' WHERE site_id='CN0027';
INSERT INTO search_log VALUES('L013-003','CN0027','W01-B3/W11-B4','齐鲁华信 2025 年报 废水 9 20 母液 蒸发','W13S02','核对母公司处理设备','运行数据及共享厂界','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0028','turn127831search10');
INSERT INTO wastewater VALUES('W013-018','CN0028','低氨氮废水','2026上半年报告期运行',NULL,NULL,NULL,'低氨氮、SS','中和、沉淀过滤','DW001 周村淦清污水处理有限公司',NULL,'turn127831search10','WEB_COMPANY','2026半年报，报告期运行正常；非当前实时；镜像全文复核');
INSERT OR IGNORE INTO site_sources VALUES('CN0028','turn127831search10');
INSERT INTO wastewater VALUES('W013-019','CN0028','高氨氮废水','2026上半年报告期运行',NULL,NULL,NULL,'氨氮','汽提处理','DW001 周村淦清污水处理有限公司',NULL,'turn127831search10','WEB_COMPANY','2026半年报，报告期运行正常；不推断与老三效系统串联');
INSERT INTO water_metrics VALUES('M013-012','CN0028',NULL,'DW001年报披露污染因子数量','COD',60.6,NULL,'t','报告期披露污染因子数量',NULL,'2026H1',NULL,NULL,'turn127831search10','按原表污染因子及产量口径；非浓度、非全年、非自行推算');
INSERT INTO water_metrics VALUES('M013-013','CN0028',NULL,'DW001年报披露污染因子数量','氨氮',3.12,NULL,'t','报告期披露污染因子数量',NULL,'2026H1',NULL,NULL,'turn127831search10','按原表污染因子及产量口径；非浓度、非全年、非自行推算');
INSERT INTO water_metrics VALUES('M013-014','CN0028',NULL,'DW001年报披露污染因子数量','TN',9.08,NULL,'t','报告期披露污染因子数量',NULL,'2026H1',NULL,NULL,'turn127831search10','按原表污染因子及产量口径；非浓度、非全年、非自行推算');
INSERT INTO water_metrics VALUES('M013-015','CN0028',NULL,'DW001年报披露污染因子数量','TP',0.197,NULL,'t','报告期披露污染因子数量',NULL,'2026H1',NULL,NULL,'turn127831search10','按原表污染因子及产量口径；非浓度、非全年、非自行推算');
INSERT OR IGNORE INTO site_sources VALUES('CN0028','W13S02');
INSERT INTO evidence_notes VALUES('N013-004','CN0028','W13S02','污水收集与压滤技改','79—81页','子公司新增4个污水贮罐、3台压滤机，年报披露投入超过400万元；原文SS单位可疑，未入结构化浓度。','WEB_COMPANY','事实摘录；非原件全文','2026-11-27');
INSERT INTO water_economics VALUES('E013-005','CN0028',NULL,'污水贮罐及压滤技改投入下限',400,'万元','公司称超过该值；非精确投资','2025年报','W13S02','4罐3压滤；不作为单一膜系统成本');
INSERT OR IGNORE INTO site_sources VALUES('CN0028','turn127831search10');
INSERT INTO claims VALUES('CL013-004','CN0028','报告期分质污水','低氨中和沉淀过滤，高氨汽提；DW001接周村淦清','WEB_COMPANY','turn127831search10','2026H1披露运行正常；共享处理边界','2026-11-27');
INSERT INTO process_diagrams VALUES('D013-005','CN0028','ammonia_split_discharge','operating','2026H1',1,'partial','flowchart TD
 A["低氨氮废水"] --> B["中和、沉淀过滤"] --> E["DW001"]
 C["高氨氮废水"] --> D["汽提"] --> E
 E --> F["周村淦清污水处理有限公司"]','turn127831search10','报告期两股处理运行正常；非全厂完整现行图','其他历史蒸发支路及最终厂界未核','2026-11-27');
INSERT INTO process_diagram_evidence VALUES('DE013-006','D013-005','W013-018','turn127831search10','2026H1环保披露','A,B,E,F','对应流股及其证据；未核节点在图中标明');
INSERT INTO process_diagram_evidence VALUES('DE013-007','D013-005','W013-019','turn127831search10','2026H1环保披露','C,D,E,F','对应流股及其证据；未核节点在图中标明');
INSERT INTO membrane_reviews VALUES('MR013-005','CN0028','D013-005','ammonia_split_discharge','operating','2026H1',1,'not_identified','turn127831search10','报告期两股处理运行正常；非全厂完整现行图','其他历史蒸发支路及最终厂界未核','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA013-005','MR013-005','CN0028','ammonia_split_discharge','screening',1,'分质减量/资源化/回用初筛','在低氨沉淀过滤后评估UF/RO回用；高氨支路保留汽提，先核排水盐度与氨浓度','conditional','实际水质及处理能力、浓水或盐产品去向、合规及经济性待核','INFERRED；D013-005；依据所连废水及设备证据','保留已有回收或预处理环节；候选路线并非已建','流量、盐度、氨、膜浓水接收、共享设施及水价','多时段采样、离子/有机物平衡及膜相容性；必要时连续中试、CIP、盐/污泥鉴别、实际能耗和全成本比较','维持已验证工艺；优化源头分流、回用及回收',NULL,NULL,NULL,NULL,NULL,NULL,'缺实测/工程输入，不打分','2026-11-27');
UPDATE sites SET water_summary='2026H1正常运行披露：低氨中和沉淀过滤、高氨汽提，DW001接周村淦清；原历史三效蒸发支路关系待核',water_level='有工艺线索',source_status='部分本轮复核',as_of='2026-11-27' WHERE site_id='CN0028';
UPDATE tasks SET next_query='排污许可执行报告、蒸发装置与汽提界面、排放量/水质实测',state='部分完成' WHERE site_id='CN0028';
INSERT INTO search_log VALUES('L013-004','CN0028','W01-B3/W11-B4','齐鲁华信高科 2026 半年报 DW001 淦清 汽提','turn127831search10','报告期工艺和去向核实','获取执行报告和实测流量','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0002','turn699489search95');
INSERT INTO wastewater VALUES('W013-020','CN0002','高氨氮催化剂废水汽提回收','2010历史运行标定/2015汇编',50,'t/h','历史案例规模','氨氮4000—6000mg/L（案例范围）','预处理、加热调pH、汽提、两级闪蒸、硫酸吸收氨、蒸汽热泵回用','硫酸铵返合成；净水后续去向待核','硫酸铵资源化','turn699489search95','WEB_PRIMARY','p227—228；50t/h案例与75t/h典型装置规模口径不同；跨长岭/齐鲁标定范围不当作长岭独立实测');
INSERT INTO water_metrics VALUES('M013-016','CN0002','W013-020','高氨氮案例进水','氨氮',NULL,'4000—6000','mg/L','案例范围',NULL,'2010历史',NULL,NULL,'turn699489search95','不是单次实测');
INSERT INTO water_economics VALUES('E013-006','CN0002','W013-020','原材料费',16.98,'元/t高氨氮废水','历史标定','2010-05-13至19','turn699489search95','历史标定口径；原料+能耗-收益约16.27；非当前运行价');
INSERT INTO water_economics VALUES('E013-007','CN0002','W013-020','能耗费',7.25,'元/t高氨氮废水','历史标定','2010-05-13至19','turn699489search95','历史标定口径；原料+能耗-收益约16.27；非当前运行价');
INSERT INTO water_economics VALUES('E013-008','CN0002','W013-020','硫酸铵收益',7.96,'元/t高氨氮废水','历史标定抵扣','2010-05-13至19','turn699489search95','历史标定口径；原料+能耗-收益约16.27；非当前运行价');
INSERT INTO water_economics VALUES('E013-009','CN0002','W013-020','净处理成本',16.3,'元/t高氨氮废水','原文取整后历史标定','2010-05-13至19','turn699489search95','历史标定口径；原料+能耗-收益约16.27；非当前运行价');
INSERT INTO water_economics VALUES('E013-010','CN0002','W013-020','案例装置总投资',1830,'万元','历史汇编案例投资','2015汇编','turn699489search95','850设备、628土建、352其他；典型规模75t/h与案例50t/h口径不同，不据此计算单位投资');
INSERT OR IGNORE INTO site_sources VALUES('CN0002','turn699489search95');
INSERT INTO evidence_notes VALUES('N013-005','CN0002','turn699489search95','技术标定边界','227—228页','历史长岭/齐鲁案例联合技术指标：氨氮2500—7500mg/L到低于15mg/L，蒸汽≤50kg/t、电≤4kWh/t；非长岭独立单次实测。成本按长岭历史标定记，未用作当前报价；截图超时。','WEB_PRIMARY','事实摘录；非原件全文','2026-11-27');
INSERT INTO process_diagrams VALUES('D013-006','CN0002','ammonia_recovery_benchmark','historical','2010标定/2015汇编',1,'partial','flowchart TD
 A["高氨废水"] --> B["预处理 加热 调pH"] --> C["蒸汽汽提"] --> D["两级闪蒸"] --> E["净水 后续待核"]
 C --> F["硫酸吸收"] --> G["硫酸铵返合成"]
 D --> H["热泵回收蒸汽"] --> C','turn699489search95','历史高氨专线，不含全厂综合水','现行工艺、实际水量、设备改造待核','2026-11-27');
INSERT INTO process_diagram_evidence VALUES('DE013-008','D013-006','W013-020','turn699489search95','227—228页','A,B,C,D,E,F,G,H','对应流股及其证据；未核节点在图中标明');
INSERT INTO membrane_reviews VALUES('MR013-006','CN0002','D013-006','ammonia_recovery_benchmark','historical','2010标定/2015汇编',1,'not_identified','turn699489search95','历史高氨专线，不含全厂综合水','现行工艺、实际水量、设备改造待核','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA013-006','MR013-006','CN0002','ammonia_recovery_benchmark','screening',1,'分质减量/资源化/回用初筛','保留脱氨和硫酸铵回收，核实汽提出水盐度后再评估深度膜回用；比较历史热泵节能与现行成本','conditional','实际水质及处理能力、浓水或盐产品去向、合规及经济性待核','INFERRED；D013-006；依据所连废水及设备证据','保留已有回收或预处理环节；候选路线并非已建','实测汽提出水、盐度、TDS、蒸汽电价、回收盐质量、全厂去向','多时段采样、离子/有机物平衡及膜相容性；必要时连续中试、CIP、盐/污泥鉴别、实际能耗和全成本比较','维持已验证工艺；优化源头分流、回用及回收',2,NULL,NULL,NULL,NULL,NULL,'案例高氨4000—6000mg/L；膜不直接替代脱氨','2026-11-27');
INSERT INTO search_log VALUES('L013-005','CN0002','W01-B3/W11-B4','长岭 高氨氮 汽提 科技部 节水治污 标定 成本','turn699489search95','补录历史成本、汽提热集成','寻找新许可/改造后实绩','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0003','W03S41');
INSERT INTO wastewater VALUES('W013-021','CN0003','HTS二次改性膜洗液','2023环评设计',1000,'t/a','设计产生量','高COD、SS、有机胺','调节、压滤、絮凝沉淀、低温减压蒸发、ED','总回收800t/a；200t/a进入既有高氨/生化处理','有机胺浓液返回；废膜及污泥按环评分类','W03S41','WEB_PRIMARY','p109表4.4-7、p186；800是总回收而非ED单独回收；与历史W0164不混算');
INSERT INTO water_metrics VALUES('M013-017','CN0003','W013-021','膜洗液进水','COD',30000,NULL,'mg/L','环评设计值',NULL,'2023',NULL,NULL,'W03S41','非实测；TN进水正文30与表3000冲突未取值');
INSERT INTO water_metrics VALUES('M013-018','CN0003','W013-021','膜洗液进水','SS',2000,NULL,'mg/L','环评设计值',NULL,'2023',NULL,NULL,'W03S41','非实测；TN进水正文30与表3000冲突未取值');
INSERT INTO water_metrics VALUES('M013-019','CN0003','W013-021','膜洗液进水','氨氮',18,NULL,'mg/L','环评设计值',NULL,'2023',NULL,NULL,'W03S41','非实测；TN进水正文30与表3000冲突未取值');
INSERT INTO water_metrics VALUES('M013-020','CN0003','W013-021','膜洗液进水','氯化物',100,NULL,'mg/L','环评设计值',NULL,'2023',NULL,NULL,'W03S41','非实测；TN进水正文30与表3000冲突未取值');
INSERT INTO water_metrics VALUES('M013-021','CN0003','W013-021','设计预处理出水','COD',80,NULL,'mg/L','环评设计值',NULL,'2023',NULL,NULL,'W03S41','非实测；TN进水正文30与表3000冲突未取值');
INSERT INTO water_metrics VALUES('M013-022','CN0003','W013-021','设计预处理出水','SS',10,NULL,'mg/L','环评设计值',NULL,'2023',NULL,NULL,'W03S41','非实测；TN进水正文30与表3000冲突未取值');
INSERT INTO water_metrics VALUES('M013-023','CN0003','W013-021','设计预处理出水','氨氮',10,NULL,'mg/L','环评设计值',NULL,'2023',NULL,NULL,'W03S41','非实测；TN进水正文30与表3000冲突未取值');
INSERT INTO water_metrics VALUES('M013-024','CN0003','W013-021','设计预处理出水','TN',15,NULL,'mg/L','环评设计值',NULL,'2023',NULL,NULL,'W03S41','非实测；TN进水正文30与表3000冲突未取值');
INSERT INTO water_metrics VALUES('M013-025','CN0003','W013-021','设计预处理出水','氯化物',10,NULL,'mg/L','环评设计值',NULL,'2023',NULL,NULL,'W03S41','非实测；TN进水正文30与表3000冲突未取值');
INSERT OR IGNORE INTO site_sources VALUES('CN0003','W03S41');
INSERT INTO wastewater VALUES('W013-022','CN0003','一次压滤洗水','2023环评设计',2500,'t/a','设计年产生量','NH3-N400、COD100、SS400、TN600、Cl600mg/L','既有厂内废水处理','按环评厂内系统',NULL,'W03S41','WEB_PRIMARY','表4.4-7；不作为实际排放');
INSERT OR IGNORE INTO site_sources VALUES('CN0003','W03S41');
INSERT INTO wastewater VALUES('W013-023','CN0003','地坪清洗水','2023环评设计',320,'t/a','设计年产生量','COD300、SS400、NH3-N20、TN30、Cl30mg/L','既有厂内废水处理','按环评厂内系统',NULL,'W03S41','WEB_PRIMARY','表4.4-7；不作为实际排放');
INSERT OR IGNORE INTO site_sources VALUES('CN0003','W03S41');
INSERT INTO wastewater VALUES('W013-024','CN0003','喷淋排水','2023环评设计',1541.35,'t/a','设计年产生量','COD800、SS100mg/L','既有厂内废水处理','按环评厂内系统',NULL,'W03S41','WEB_PRIMARY','表4.4-7；不作为实际排放');
INSERT INTO water_metrics VALUES('M013-026','CN0003','W013-021','二次改性支流','总回收量',800,NULL,'t/a','设计合计回收',NULL,'2023',NULL,NULL,'W03S41','非ED专用回收率');
INSERT INTO water_metrics VALUES('M013-027','CN0003','W013-021','二次改性支流','进入既有处理',200,NULL,'t/a','设计剩余量',NULL,'2023',NULL,NULL,'W03S41','非直接外排');
INSERT OR IGNORE INTO site_sources VALUES('CN0003','W03S41');
INSERT INTO evidence_notes VALUES('N013-006','CN0003','W03S41','设计冲突及耗材','p109—110、p186','进水TN正文30与表3000mg/L冲突；不取单值。膜按年更换、废膜约1t/a，按环评危废；压滤沉淀残渣20t/a设计一般固废填埋；需核验实际鉴别。截图超时。','WEB_PRIMARY','事实摘录；非原件全文','2026-11-27');
INSERT INTO process_diagrams VALUES('D013-007','CN0003','hts_secondary_modification','design','2023完善项目',1,'partial','flowchart TD
 A["二次改性膜洗液 1000t/a设计"] --> B["调节 压滤 絮凝沉淀"] --> C["低温减压蒸发"] --> D["ED"]
 D --> E["有机胺返回/总回收800t/a"]
 D --> F["余200t/a 既有高氨/生化"]','W03S41','2023完善项目设计，800t/a是系统总回收非ED单独值','具体回流、原图及投运待核','2026-11-27');
INSERT INTO process_diagram_evidence VALUES('DE013-009','D013-007','W013-021','W03S41','p109表4.4-7、p186','A,B,C,D,E,F','对应流股及其证据；未核节点在图中标明');
INSERT INTO membrane_reviews VALUES('MR013-007','CN0003','D013-007','hts_secondary_modification','design','2023完善项目',1,'confirmed_present','W03S41','2023完善项目设计，800t/a是系统总回收非ED单独值','具体回流、原图及投运待核','2026-11-27');
INSERT INTO membrane_units VALUES('MU013-006','MR013-007','二次改性ED','ED','有机胺/盐回收','预处理后膜洗液',NULL,'有机胺回用','环评设计，废膜约1t/a','W03S41','p109、186','仅该范围及时期');
INSERT INTO membrane_retrofits VALUES('RA013-007','MR013-007','CN0003','hts_secondary_modification','screening',1,'分质减量/资源化/回用初筛','先验证2023设计的ED与蒸发投运情况、药剂用量及胺回用品质；不可重复建设','conditional','实际水质及处理能力、浓水或盐产品去向、合规及经济性待核','INFERRED；D013-007；依据所连废水及设备证据','保留已有回收或预处理环节；候选路线并非已建','原液COD、胺、TN冲突、实际膜进水、膜寿命及回用标准','多时段采样、离子/有机物平衡及膜相容性；必要时连续中试、CIP、盐/污泥鉴别、实际能耗和全成本比较','维持已验证工艺；优化源头分流、回用及回收',2,1,NULL,NULL,NULL,NULL,'设计原液COD30000、SS2000；已有复杂预处理，须核实际','2026-11-27');
INSERT INTO search_log VALUES('L013-006','CN0003','W01-B3/W11-B4','云溪 HTS 2023 环评 4.4-7 二次改性 电渗析','W03S41','扩展旧源设计物料及水质；截图超时','原图和验收','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0014','W13S03');
INSERT INTO wastewater VALUES('W013-025','CN0014','微球过滤废水白泥回收','2024企业报道',NULL,NULL,NULL,'催化剂白泥、SS','药剂沉淀、压滤','白泥回催化剂生产；滤液待核','2024年1—4月回收白泥超200吨','W13S03','WEB_SECONDARY','报道未完整披露液体后续；高氨氮预处理建成但工艺待核');
INSERT INTO water_metrics VALUES('M013-028','CN0014','W013-025','白泥回收','白泥回收量下限',200,NULL,'t','报道超过该值',NULL,'2024年1—4月',NULL,NULL,'W13S03','不是废水量；非全年');
INSERT INTO water_economics VALUES('E013-011','CN0014','W013-025','白泥回收收益下限',200,'万元','报道超过该值','2024年1—4月','W13S03','非污水处理运行费，收益计算细节待核');
INSERT INTO process_diagrams VALUES('D013-008','CN0014','microsphere_white_mud','historical','2024报道',1,'partial','flowchart TD
 A["微球过滤废水"] --> B["药剂沉淀"] --> C["压滤"]
 C --> D["白泥回催化剂生产"]
 C --> E["滤液后续待核"]','W13S03','白泥资源化支线，不代表300t/h全厂站','压滤液处理及膜、实际流量待核','2026-11-27');
INSERT INTO process_diagram_evidence VALUES('DE013-010','D013-008','W013-025','W13S03','2024报道','A,B,C,D,E','对应流股及其证据；未核节点在图中标明');
INSERT INTO membrane_reviews VALUES('MR013-008','CN0014','D013-008','microsphere_white_mud','historical','2024报道',1,'not_identified','W13S03','白泥资源化支线，不代表300t/h全厂站','压滤液处理及膜、实际流量待核','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA013-008','MR013-008','CN0014','microsphere_white_mud','screening',1,'分质减量/资源化/回用初筛','先提高白泥回收及滤液澄清稳定性；再试UF/RO或ED回用，需避开硅铝胶体污染','conditional','实际水质及处理能力、浓水或盐产品去向、合规及经济性待核','INFERRED；D013-008；依据所连废水及设备证据','保留已有回收或预处理环节；候选路线并非已建','滤液SS、胶体、盐及pH、实际回用与收益、浓水去向','多时段采样、离子/有机物平衡及膜相容性；必要时连续中试、CIP、盐/污泥鉴别、实际能耗和全成本比较','维持已验证工艺；优化源头分流、回用及回收',NULL,1,NULL,NULL,NULL,NULL,'已见药剂沉淀及压滤，需验证胶体去除','2026-11-27');
INSERT INTO search_log VALUES('L013-007','CN0014','W01-B3/W11-B4','兰州石化 催化剂 微球 白泥 废水 2024','W13S03','获得回收收益及分质支路；不推断全站MBBR/膜','高氨预处理验收、300t/h历史站现状','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0102','W13S04');
INSERT INTO wastewater VALUES('W013-026','CN0102','既有催化剂清洗、吸收和活化冷凝水','2025环评既有描述',NULL,NULL,NULL,'氮磷、碱','蒸馏、冷却回用','生产/喷淋补水',NULL,'W13S04','WEB_PRIMARY','检索文本p78；原链接复开跳首页，截图未核；按既有边界简化');
INSERT OR IGNORE INTO site_sources VALUES('CN0102','W13S04');
INSERT INTO wastewater VALUES('W013-027','CN0102','既有公用废水及生活污水','2025环评既有描述',NULL,NULL,NULL,'公用排水','集团共享污水站','常州民生污水处理',NULL,'W13S04','WEB_PRIMARY','p78文本；纯水RO浓水不等于生产污水膜');
INSERT OR IGNORE INTO site_sources VALUES('CN0102','W13S04');
INSERT INTO wastewater VALUES('W013-028','CN0102','2800吨项目含氮磷生产废水及相应初雨','2025环评拟建',NULL,NULL,NULL,'氮磷','常压蒸馏、减压精馏','尾气洗涤补水',NULL,'W13S04','WEB_PRIMARY','p106文本；原图未核；非验收');
INSERT OR IGNORE INTO site_sources VALUES('CN0102','W13S04');
INSERT INTO wastewater VALUES('W013-029','CN0102','2800吨项目公用水、生活及其余初雨','2025环评拟建',NULL,NULL,NULL,'公用排水','新阳科技集团共享站','常州民生污水处理',NULL,'W13S04','WEB_PRIMARY','p106；纯水RO浓水、冷却排水属公用边界；未核厂界');
INSERT INTO process_diagrams VALUES('D013-009','CN0102','existing_distillation','historical','2025环评既有',1,'partial','flowchart TD
 A["清洗/吸收/冷凝/碱封水"] --> B["蒸馏 冷却"] --> C["生产回用"]
 D["公用及生活废水"] --> E["集团共享污水站"] --> F["常州民生"]','W13S04','环评既有描述，未核当前运行','原图、实际流量、污染物及共享站工艺待核','2026-11-27');
INSERT INTO process_diagram_evidence VALUES('DE013-011','D013-009','W013-026','W13S04','p78','A,B,C','对应流股及其证据；未核节点在图中标明');
INSERT INTO process_diagram_evidence VALUES('DE013-012','D013-009','W013-027','W13S04','p78','D,E,F','对应流股及其证据；未核节点在图中标明');
INSERT INTO membrane_reviews VALUES('MR013-009','CN0102','D013-009','existing_distillation','historical','2025环评既有',1,'not_identified','W13S04','环评既有描述，未核当前运行','原图、实际流量、污染物及共享站工艺待核','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA013-009','MR013-009','CN0102','existing_distillation','screening',1,'分质减量/资源化/回用初筛','优先核既有蒸馏回用；对适合的低盐冷凝液或共享站出水评估膜深度回用','conditional','实际水质及处理能力、浓水或盐产品去向、合规及经济性待核','INFERRED；D013-009；依据所连废水及设备证据','保留已有回收或预处理环节；候选路线并非已建','溶剂及氮磷、pH、冷凝液质量、废液处置、实际能耗','多时段采样、离子/有机物平衡及膜相容性；必要时连续中试、CIP、盐/污泥鉴别、实际能耗和全成本比较','维持已验证工艺；优化源头分流、回用及回收',NULL,NULL,NULL,NULL,NULL,NULL,'缺实测/工程输入，不打分','2026-11-27');
INSERT INTO process_diagrams VALUES('D013-010','CN0102','expansion_distillation','design','2025环评2800吨',1,'partial','flowchart TD
 A["含氮磷设备洗/废气洗/除雾/冷凝及相应初雨"] --> B["常压蒸馏 减压精馏"] --> C["洗涤塔补水"]
 D["公用及生活/其余初雨"] --> E["集团共享污水站"] --> F["常州民生"]','W13S04','2800吨设计非验收；纯水RO不计生产废水膜','蒸馏残液、实测水量与共享边界待核','2026-11-27');
INSERT INTO process_diagram_evidence VALUES('DE013-013','D013-010','W013-028','W13S04','p106','A,B,C','对应流股及其证据；未核节点在图中标明');
INSERT INTO process_diagram_evidence VALUES('DE013-014','D013-010','W013-029','W13S04','p106','D,E,F','对应流股及其证据；未核节点在图中标明');
INSERT INTO membrane_reviews VALUES('MR013-010','CN0102','D013-010','expansion_distillation','design','2025环评2800吨',1,'not_identified','W13S04','2800吨设计非验收；纯水RO不计生产废水膜','蒸馏残液、实测水量与共享边界待核','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA013-010','MR013-010','CN0102','expansion_distillation','screening',1,'分质减量/资源化/回用初筛','对蒸馏后低盐水评估UF/RO作为深度回用，保留溶剂/氮磷分流','conditional','实际水质及处理能力、浓水或盐产品去向、合规及经济性待核','INFERRED；D013-010；依据所连废水及设备证据','保留已有回收或预处理环节；候选路线并非已建','浓缩残液处置、氮磷负荷、膜相容性、热耗、实际水价','多时段采样、离子/有机物平衡及膜相容性；必要时连续中试、CIP、盐/污泥鉴别、实际能耗和全成本比较','维持已验证工艺；优化源头分流、回用及回收',NULL,NULL,NULL,NULL,NULL,NULL,'缺实测/工程输入，不打分','2026-11-27');
INSERT INTO search_log VALUES('L013-008','CN0102','W01-B3/W11-B4','常州新日 2800吨 2025 环评 蒸馏 除雾','W13S04','原文检索文本p78/106；链接复开跳转','政府附件及验收','2026-11-27');
INSERT INTO sites VALUES('CN0246','延长中科（大连）能源科技股份有限公司','辽宁','大连',NULL,'煤化工/羰基化/加氢','公示称既有正常生产；三期拟建','企业/项目','三期拟建3000吨/年；既有实际产能待核','蒸馏浓缩/蒸发结晶，馏出部分回用，余进综合站；具体边界待核','有工艺线索','P1',NULL,'首次公示转载；科研机构主体交叉证据','2026-11-27','与中科催化新技术（大连）股份有限公司CN0029独立；厂址、项目许可/投产待核');
INSERT OR IGNORE INTO site_sources VALUES('CN0246','W13S05');
INSERT OR IGNORE INTO site_sources VALUES('CN0246','W13S06');
INSERT OR IGNORE INTO site_sources VALUES('CN0029','W13S06');
INSERT INTO tasks VALUES('T013-001','CN0246','P1','核厂址信用代码、实际产能、环评批复及验收、污水设备/流量/水质','按三期3000吨环评项目名查政府原件、既有线许可证、设备及运行','部分完成');
INSERT INTO capacity VALUES('C013-001','CN0246','乙醇脱氢制乙醛催化剂',600,'t/a','首次公示拟建','2026-01','三期六线分项','W13S05','合计3000t/a，非现有产量');
INSERT INTO capacity VALUES('C013-002','CN0246','乙醇脱氢制乙酸乙酯催化剂',300,'t/a','首次公示拟建','2026-01','三期六线分项','W13S05','合计3000t/a，非现有产量');
INSERT INTO capacity VALUES('C013-003','CN0246','乙醛缩合加氢制1,3-丁二醇催化剂',400,'t/a','首次公示拟建','2026-01','三期六线分项','W13S05','合计3000t/a，非现有产量');
INSERT INTO capacity VALUES('C013-004','CN0246','乙醇脱水制乙烯/乙醚催化剂',800,'t/a','首次公示拟建','2026-01','三期六线分项','W13S05','合计3000t/a，非现有产量');
INSERT INTO capacity VALUES('C013-005','CN0246','烯烃羰基化制丙酸酯催化剂',500,'t/a','首次公示拟建','2026-01','三期六线分项','W13S05','合计3000t/a，非现有产量');
INSERT INTO capacity VALUES('C013-006','CN0246','脱氢催化剂',400,'t/a','首次公示拟建','2026-01','三期六线分项','W13S05','合计3000t/a，非现有产量');
INSERT INTO projects VALUES('P013-001','CN0246','三期催化剂生产项目','首次环评公示转载','2026-01-09','3000吨/年拟建','既有蒸馏浓缩/蒸发结晶；三期方案待环评正文','W13S05');
INSERT OR IGNORE INTO site_sources VALUES('CN0246','W13S05');
INSERT INTO wastewater VALUES('W013-030','CN0246','既有工艺废水','2026-01公示现有工程描述',NULL,NULL,NULL,'具体水质待核','精馏浓缩、蒸发结晶','馏出液部分回用，余与公用生活水进综合站','结晶残物去向未核','W13S05','WEB_SECONDARY','首次公示转载，非实测/验收；园区最终去向被遮蔽');
INSERT OR IGNORE INTO site_sources VALUES('CN0246','W13S06');
INSERT INTO claims VALUES('CL013-005','CN0246','独立主体关系','科研机构介绍分别列延长中科与中科催化，不能混并','WEB_PRIMARY','W13S06','法人名称分别独立，股权与厂址待核','2026-11-27');
INSERT OR IGNORE INTO site_sources VALUES('CN0246','W13S05');
INSERT INTO evidence_notes VALUES('N013-007','CN0246','W13S05','主体与项目','公示17—25行','已有二甲醚羰基化、乙酸甲酯加氢、甲醇制二甲醚催化剂等生产；三期六线拟建合计3000吨/年，项目总投资非水处理投资，不录水成本。','WEB_SECONDARY','事实摘录；非原件全文','2026-11-27');
INSERT INTO process_diagrams VALUES('D013-011','CN0246','existing_process_water','historical','2026-01公示',1,'partial','flowchart TD
 A["现有工艺废水"] --> B["精馏浓缩/蒸发结晶"] --> C["馏出液部分回用"]
 B --> D["余水与公用生活水"] --> E["厂内综合污水站"] --> F["园区去向待核"]','W13S05','转载公示现有工程；实际运行状态、园区去向未核','正式环评、验收、膜与盐处置待核','2026-11-27');
INSERT INTO process_diagram_evidence VALUES('DE013-015','D013-011','W013-030','W13S05','公示现有工程段','A,B,C,D,E,F','对应流股及其证据；未核节点在图中标明');
INSERT INTO membrane_reviews VALUES('MR013-011','CN0246','D013-011','existing_process_water','historical','2026-01公示',1,'not_identified','W13S05','转载公示现有工程；实际运行状态、园区去向未核','正式环评、验收、膜与盐处置待核','2026-11-27');
INSERT INTO membrane_retrofits VALUES('RA013-011','MR013-011','CN0246','existing_process_water','screening',1,'分质减量/资源化/回用初筛','先核精馏/蒸发液盐和有机物，评估低盐出水UF/RO回用，浓液优先资源化','conditional','实际水质及处理能力、浓水或盐产品去向、合规及经济性待核','INFERRED；D013-011；依据所连废水及设备证据','保留已有回收或预处理环节；候选路线并非已建','水量、COD、盐组成、膜相容性、浓水合规、能源及处理价格','多时段采样、离子/有机物平衡及膜相容性；必要时连续中试、CIP、盐/污泥鉴别、实际能耗和全成本比较','维持已验证工艺；优化源头分流、回用及回收',NULL,NULL,NULL,NULL,NULL,NULL,'缺实测/工程输入，不打分','2026-11-27');
INSERT INTO search_log VALUES('L013-009','CN0246','W01-B3/W11-B4','延长中科 大连 催化剂 三期 3000吨 废水','W13S05','首次公示转载新建档，科研机构交叉主体','政府附件、许可、验收','2026-11-27');
INSERT INTO search_log VALUES('L013-010','CN0029','W01-B3/W11-B4','中科催化 大连 延长中科 同一企业？','W13S06','研究所分别列名；原厂污水设施仍未取得','按统一社会信用代码及厂址查许可','2026-11-27');
INSERT INTO search_log VALUES('L013-011','CN0079','W01-B3/W11-B4','双雄催化剂 合成氨 变换 环评 污水',NULL,'未找到可归属现有厂的工艺原件','老厂名、园区许可执行报告','2026-11-27');
INSERT INTO search_log VALUES('L013-012','CN0142','W01-B3/W11-B4','多友科技 分子筛 废水 反渗透 环评',NULL,'未获得独立水处理原件','郓城化工园、项目批复及环保验收','2026-11-27');
INSERT INTO search_log VALUES('L013-013','CN0111','W01-B3/W11-B4','西安元创 富平 催化剂 排污 环评',NULL,'仅身份类结果，未新增工艺','富平园区公开许可','2026-11-27');
INSERT INTO search_log VALUES('L013-014','CN0104','W01-B3/W11-B4','惠州博科 催化剂 废水 500 1500',NULL,'既有产能线索重复，无新水处理工艺','验收及园区接管协议','2026-11-27');
INSERT INTO search_log VALUES('L013-015','CN0082','W01-B3/W11-B4','瑞克/瑞科 催化剂 硝酸盐 废水',NULL,'排除江苏瑞科医药非目标工厂','大连母厂实际运行资料','2026-11-27');
COMMIT;
