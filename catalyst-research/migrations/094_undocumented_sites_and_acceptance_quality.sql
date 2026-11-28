PRAGMA foreign_keys=ON;
BEGIN;
INSERT INTO sources(source_id,title,url,source_type,document_date,scope,access_date) VALUES
('S094-01','长岭分公司废乙醇资源化项目拟审批公示','https://www.yunxiqu.gov.cn/38965/39034/39035/39063/41965/42378/content_2301879.html','政府拟审批公示','2025-06-26','明确建设单位长岭分公司，云溪基地现有厂区；非批准或验收','2026-11-28'),
('S094-02','雅安光明派特2025-2027年度危废处置服务二次询比采购','https://www.cdgmgd.com/go.htm?id=10458&k=cai_gou_xin_xi&url=details','企业官网采购公告','2025-07-10','公司级危废转运计划，不明确是否独属燃料电池催化剂项目','2026-11-28'),
('S094-03','济源显扬年处理6600吨废催化剂综合回收利用项目一期受理公示','https://hbj.jiyuan.gov.cn/hjpj/hpgs/t739738.html','政府环评受理公示','2021-08-23','一期1600t/a，非实际或当前许可','2026-11-28'),
('S094-04','济源显扬年处理6600吨废催化剂综合回收利用项目一期工程环评报告书','https://hbj.jiyuan.gov.cn/hjpj/hpgs/P020210823569677833389.pdf','政府公示环评报告','2021-08','正文2.2.5.4、2.5.2.2、2.5.2.3；截图请求超时；表中局部文字识别异常，不取单位不明量','2026-11-28'),
('S094-05','贵研资源环保科技东营贵金属二次资源绿色循环利用基地项目环评公示稿','https://zhengxin-pub.cdn.bcebos.com/tender/f3b1c8a24be217c872d141b341854ee0/%E8%B4%B5%E7%A0%94%E8%B5%84%E6%BA%90%E7%8E%AF%E4%BF%9D%E7%A7%91%E6%8A%80%EF%BC%88%E4%B8%9C%E8%90%A5%EF%BC%89%E6%9C%89%E9%99%90%E5%85%AC%E5%8F%B8%E8%B4%B5%E9%87%91%E5%B1%9E%E4%BA%8C%E6%AC%A1%E8%B5%84%E6%BA%90%E7%BB%BF%E8%89%B2%E5%BE%AA%E7%8E%AF%E5%88%A9%E7%94%A8%E5%9F%BA%E5%9C%B0%E9%A1%B9%E7%9B%AE%E7%8E%AF%E5%A2%83%E5%BD%B1%E5%93%8D%E6%8A%A5%E5%91%8A%E4%B9%A6%E5%85%AC%E7%A4%BA%E7%A8%BF.pdf','环评公开索引','2024（项目期，报告日期待核）','搜索索引确认标题，文件33.7MB超过访问限额；仅作取证入口','2026-11-28'),
('S094-06','贵研铂业2025年度ESG报告（中文版）','https://vip.stock.finance.sina.com.cn/corp/view/vCB_AllBulletinDetail.php?id=12201008','公司报告转载','2026-04','东营项目竣工验收及生产运行陈述，非环保验收原件','2026-11-28'),
('S094-07','环氧丙烷行业的创新升级路径','https://chem.jgvogel.cn/c1517856.shtml','行业会议报道','2025','宜昌苏鹏双氧水产品膜处理；非催化剂废水工艺或成本','2026-11-28'),
('S094-08','西中岛2020年首批项目集中签约开工投产','https://dalian.runsky.com/2020-05/29/content_6048690.html','地方媒体报道','2020-05-29','大连众智创新投产项目，非实际经营量或污水验收','2026-11-28'),
('S094-09','象山县南阳实践应急响应方案','https://zjjcmspublic.oss-cn-hangzhou-zwynet-d01-a.internet.cloud.zj.gov.cn/jcms_files/jcms1/web3507/site/attach/0/756669f38e6745f7a7200fc305ea83df.pdf','政府公开应急方案检索摘录','2023（索引）','第30项瑞博宝珞杰；生产废水栏斜线非无废水证明','2026-11-28');
INSERT INTO site_sources(site_id,source_id) VALUES
('CN0003','S094-01'),
('CN0283','S094-02'),
('CN0335','S094-03'),
('CN0335','S094-04'),
('CN0257','S094-05'),
('CN0257','S094-06'),
('CN0281','S094-07'),
('CN0190','S094-08'),
('CN0270','S094-09');
UPDATE sources SET title='中国石化催化剂有限公司长岭分公司废乙醇资源化项目环境影响报告表（云溪基地）',scope=scope||'；094政府拟批S094-01及报告索引明确建设主体与物理厂区；旧标题长岭2025项目环评历史装置表保留于094证据笔记' WHERE source_id='W06S18';
INSERT INTO capacity(capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES
('C094-01','CN0335','含贵金属废催化剂处理',1600,'t/a','一期环评设计','2021-08','一期工程','S094-03','6600t/a总体项目不是一期实际产能；后续1850许可独立'),
('C094-02','CN0335','氧化铝载钯废催化剂',200,'t/a','一期环评设计分项','2021-08','一期1600t/a','S094-04','2.2.5.4；分项合计1600，不与总量重复累计'),
('C094-03','CN0335','炭载钯废催化剂',100,'t/a','一期环评设计分项','2021-08','一期1600t/a','S094-04','2.2.5.4；分项合计1600，不与总量重复累计'),
('C094-04','CN0335','氧化铝载铂废催化剂',250,'t/a','一期环评设计分项','2021-08','一期1600t/a','S094-04','2.2.5.4；分项合计1600，不与总量重复累计'),
('C094-05','CN0335','炭载钌废催化剂',50,'t/a','一期环评设计分项','2021-08','一期1600t/a','S094-04','2.2.5.4；分项合计1600，不与总量重复累计'),
('C094-06','CN0335','废铑催化剂',500,'t/a','一期环评设计分项','2021-08','一期1600t/a','S094-04','2.2.5.4；分项合计1600，不与总量重复累计'),
('C094-07','CN0335','废汽车尾气净化催化剂',500,'t/a','一期环评设计分项','2021-08','一期1600t/a','S094-04','2.2.5.4；分项合计1600，不与总量重复累计');
INSERT INTO projects(project_id,site_id,project,status,date,capacity_note,water_change,source_id) VALUES
('P094-01','CN0335','年处理6600吨废催化剂综合回收利用项目一期工程','2021-08环评受理；原验收待核','2021-08-23','一期1600t/a含贵金属废催化剂，后续1850t/a许可不相加','分质资源化、中和压滤、三效蒸发回用','S094-03'),
('P094-02','CN0257','贵金属二次资源绿色循环利用基地','2025ESG报告称竣工验收；未核具体环保验收类型及日期','2025报告期','4500t/a能力等旧录保留','污水站工艺待取原报告','S094-06'),
('P094-03','CN0190','失活催化剂处置及催化剂加工项目','2020-05地方媒体列入投产项目；不证明连续运行','2020-05-29','未披露该报道口径处理能力','未披露污水站工艺','S094-08');
INSERT INTO wastewater(water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES
('W094-01','CN0353','工艺废水','2026拟批转载设计',NULL,NULL,NULL,'未取浓度','中和→铝置换→共享MVR','冷凝水回用于废气治理','废盐、污泥','S086-06','WEB_SECONDARY','非实测'),
('W094-02','CN0353','废气治理、真空泵定排及地面设备滤布清洗废水','2026拟批转载设计',NULL,NULL,NULL,NULL,'分股收集→合并中和置换→MVR','冷凝水回用于废气治理',NULL,'S086-06','WEB_SECONDARY','各股流量未取得'),
('W094-03','CN0353','共享MVR蒸发系统','2026拟批转载设计',30,'t/d','设计处理能力',NULL,'MVR蒸发','冷凝水回用于废气治理不外排','设计生产污泥20t/a、废盐775.495t/a（项目预测，非实绩）','S086-06','WEB_SECONDARY','不能当实际日水量'),
('W094-04','CN0353','初期雨水预处理','2026拟批转载设计',100,'m³/d','设计处理能力',NULL,'中和→混凝沉淀','与其他允许纳管水合流经广丰城投工业污水厂后入丰溪河',NULL,'S086-06','WEB_SECONDARY','初雨单列，非工业水'),
('W094-05','CN0353','生活污水','2026拟批转载设计',NULL,NULL,NULL,NULL,'化粪池','总排口→广丰城投工业污水厂',NULL,'S086-06','WEB_SECONDARY','生活水单列'),
('W094-06','CN0353','纯水制备排水、冷却定排及锅炉定排','2026拟批转载设计',NULL,NULL,NULL,NULL,'与其他纳管水合流','总排口→广丰城投工业污水厂',NULL,'S086-06','WEB_SECONDARY','公用工程；废RO膜来自纯水制备，不作为污水RO'),
('W094-07','CN0283','公司级无机化工废水处理','2025采购计划（实际设施状态未知）',NULL,NULL,NULL,'高盐残渣','絮凝沉淀、MVR蒸发（相互连接待核）',NULL,'污泥与MVR废液干化渣合计预估50t/a，HW18 772-003-18，要求刚性填埋','S094-02','WEB_COMPANY','2025–2027计划，首次转移预计2026下半年；非实收实处置，不能确定独属燃料电池项目'),
('W094-08','CN0328','东区4000t/a含氟精细化学品扩建项目总排水','2025环评设计',36000,'t/a','预测年排水120t/d','COD、氟离子、AOX','依托扩建共享站','纳管',NULL,'S073-01','WEB_PRIMARY','p241截图；非催化剂线专属，拟拆旧催化剂车间尚未核实'),
('W094-09','CN0328','扩建后全厂生化处理需求','2025环评设计',626.6,'t/d','预测纳入生化处理量',NULL,'原处理工艺不变',NULL,NULL,'S073-01','WEB_PRIMARY','p241；原页显示626.6/d，按语境t/d，非实际'),
('W094-10','CN0328','扩建共享污水站','2025环评设计',800,'t/d','设计扩建后处理能力',NULL,'原有工艺不变','纳管',NULL,'S073-01','WEB_PRIMARY','p241；既有600t/d已录W072-07，不重复'),
('W094-11','CN0328','W1-1水洗废水预处理后','2025环评设计',10126,'t/a','表7.2-1预处理后发生量33.75t/d','COD、AOX、氟、盐分','蒸发脱盐','冷凝水纳入综合站','废盐','S073-01','WEB_PRIMARY','p239–240原文；非现行催化剂线专属'),
('W094-12','CN0328','W1-2碱洗废水','2025环评设计',14099,'t/a','表7.2-1发生量47t/d','COD、AOX、LAS、氟、盐分','纳入共享站','纳管',NULL,'S073-01','WEB_PRIMARY','p240原文；非催化剂线专属'),
('W094-13','CN0328','W5-1气液焚烧炉尾气洗涤废水','2025环评设计',5500,'t/a','表7.2-1发生量18.33t/d',NULL,'纳入共享站','纳管',NULL,'S073-01','WEB_PRIMARY','原表该行浓度列未取完整，不补猜'),
('W094-14','CN0335','酸性废水合计','2021一期环评设计',23.6,'m³/d','酸性废水设计总量','酸性','分流资源化或NaOH中和',NULL,NULL,'S094-04','WEB_PRIMARY','2.5.2.2；p136；与以下分股是上下级，非相加'),
('W094-15','CN0335','氧化铝/炭载铂族贵金属废剂回收酸性废水','2021一期环评设计',16.15,'m³/d','设计分股','pH约4','制备聚合氯化铝铁溶液（原文指氧化铝载铂族）','产品外售',NULL,'S094-04','WEB_PRIMARY','2.5.2.2；报告合计与具体资源化范围文字有差异，待核'),
('W094-16','CN0335','废有机铑催化剂回收酸性废水','2021一期环评设计',0.28,'m³/d','设计分股','pH约4','NaOH曝气中和→板框压滤','滤液送三效蒸发',NULL,'S094-04','WEB_PRIMARY','2.5.2.2；设计'),
('W094-17','CN0335','废三元汽车催化剂回收酸性废水','2021一期环评设计',0.85,'m³/d','设计分股','pH约4','NaOH曝气中和→板框压滤','滤液送三效蒸发',NULL,'S094-04','WEB_PRIMARY','2.5.2.2；设计'),
('W094-18','CN0335','脱硫脱硝废水','2021一期环评设计',6.33,'m³/d','设计分股','pH2–3，含尘2g/L','NaOH曝气中和→板框压滤','滤液送三效蒸发',NULL,'S094-04','WEB_PRIMARY','2.5.2.2；设计'),
('W094-19','CN0335','酸性废水中和后液','2021一期环评设计',25,'m³/d','深度处理设计分项',NULL,'三效蒸发','冷凝水回用',NULL,'S094-04','WEB_PRIMARY','2.5.2.2；与酸性原水23.6及资源化分股关系不明，不强行配平'),
('W094-20','CN0335','一般生产废水','2021一期环评设计',79.3,'m³/d','深度处理设计分项',NULL,'清液池→三效蒸发','冷凝水回用',NULL,'S094-04','WEB_PRIMARY','2.5.2.2；与25合计104.3'),
('W094-21','CN0335','深度处理系统','2021一期环评设计',104.3,'m³/d','设计处理规模',NULL,'清液池→三效蒸发','冷凝水回用',NULL,'S094-04','WEB_PRIMARY','2.5.2.2；结晶盐回转干燥，报告设计一般固废；实际鉴别待核'),
('W094-22','CN0335','地面设备冲洗废水','2021一期环评设计',NULL,NULL,NULL,'SS','澄清池沉淀→清液池→三效蒸发','冷凝水回用',NULL,'S094-04','WEB_PRIMARY','设计；不假定独立量'),
('W094-23','CN0335','生活污水','2021一期环评设计',NULL,NULL,NULL,NULL,'生活排水管道','园区排水系统',NULL,'S094-04','WEB_PRIMARY','非生产废水'),
('W094-24','CN0335','设备间接冷却排水','2021一期环评设计',NULL,NULL,NULL,NULL,'清液池→三效蒸发','冷凝水回用',NULL,'S094-04','WEB_PRIMARY','报告设计路径');
UPDATE wastewater SET notes=notes||'；094同源检索补取具体MVR及初雨能力，见W094-01–06；原接管边界保留' WHERE water_id='W086-25';
INSERT INTO water_metrics(metric_id,site_id,water_id,point,metric,value_num,value_text,unit,result_kind,statistic,period,detection_limit,standard_max,source_id,notes) VALUES
('M094-001','CN0328','W094-11','蒸发脱盐预处理前','CODcr',42827,NULL,'mg/L','设计浓度','设计源强/预测','2025',NULL,NULL,'S073-01','表7.2-2；非实测'),
('M094-002','CN0328','W094-11','蒸发脱盐预处理后','CODcr',2141,NULL,'mg/L','设计浓度','设计源强/预测','2025',NULL,NULL,'S073-01','表7.2-2；非实测'),
('M094-003','CN0328','W094-11','蒸发脱盐预处理前','AOX',6406,NULL,'mg/L','设计浓度','设计源强/预测','2025',NULL,NULL,'S073-01','表7.2-2；非实测'),
('M094-004','CN0328','W094-11','蒸发脱盐预处理后','AOX',64,NULL,'mg/L','设计浓度','设计源强/预测','2025',NULL,NULL,'S073-01','表7.2-2；非实测'),
('M094-005','CN0328','W094-11','蒸发脱盐预处理前','氟离子',4928,NULL,'mg/L','设计浓度','设计源强/预测','2025',NULL,NULL,'S073-01','表7.2-2；非实测'),
('M094-006','CN0328','W094-11','蒸发脱盐预处理后','氟离子',49,NULL,'mg/L','设计浓度','设计源强/预测','2025',NULL,NULL,'S073-01','表7.2-2；非实测'),
('M094-007','CN0328','W094-11','蒸发脱盐预处理前','盐分',50379,NULL,'mg/L','设计浓度','设计源强/预测','2025',NULL,NULL,'S073-01','表7.2-2；非实测'),
('M094-008','CN0328','W094-11','蒸发脱盐预处理后','盐分',504,NULL,'mg/L','设计浓度','设计源强/预测','2025',NULL,NULL,'S073-01','表7.2-2；非实测'),
('M094-009','CN0328','W094-12','预处理后污染源强表','CODcr',2099,NULL,'mg/L','设计浓度','设计源强/预测','2025',NULL,NULL,'S073-01','表7.2-1；非实测'),
('M094-010','CN0328','W094-12','预处理后污染源强表','AOX',170,NULL,'mg/L','设计浓度','设计源强/预测','2025',NULL,NULL,'S073-01','表7.2-1；非实测'),
('M094-011','CN0328','W094-12','预处理后污染源强表','LAS',320,NULL,'mg/L','设计浓度','设计源强/预测','2025',NULL,NULL,'S073-01','表7.2-1；非实测'),
('M094-012','CN0328','W094-12','预处理后污染源强表','氟离子',150,NULL,'mg/L','设计浓度','设计源强/预测','2025',NULL,NULL,'S073-01','表7.2-1；非实测'),
('M094-013','CN0328','W094-12','预处理后污染源强表','盐分',3963,NULL,'mg/L','设计浓度','设计源强/预测','2025',NULL,NULL,'S073-01','表7.2-1；非实测'),
('M094-014','CN0335','W094-15','酸性废水','pH',4,'约4',NULL,'设计浓度','设计源强/预测','2021',NULL,NULL,'S094-04','2.5.2.2'),
('M094-015','CN0335','W094-16','酸性废水','pH',4,'约4',NULL,'设计浓度','设计源强/预测','2021',NULL,NULL,'S094-04','2.5.2.2'),
('M094-016','CN0335','W094-17','酸性废水','pH',4,'约4',NULL,'设计浓度','设计源强/预测','2021',NULL,NULL,'S094-04','2.5.2.2'),
('M094-017','CN0335','W094-18','脱硫脱硝废水','pH',NULL,'2–3',NULL,'设计范围','设计源强/预测','2021',NULL,NULL,'S094-04','2.5.2.2'),
('M094-018','CN0335','W094-18','脱硫脱硝废水','含尘',2,NULL,'g/L','设计浓度','设计源强/预测','2021',NULL,NULL,'S094-04','不擅自等同实验室SS实测'),
('M094-019','CN0335','W094-19','中和池目标','pH',NULL,'8–9',NULL,'设计目标','设计源强/预测','2021',NULL,NULL,'S094-04','控制目标非实测');
INSERT INTO process_diagrams(diagram_id,site_id,scope_key,stage,period,revision,coverage,mermaid,source_id,boundaries,gaps,updated_on) VALUES
('D094-01','CN0353','expansion_2026_water','design','2026拟批',1,'partial','flowchart TD
 A["工艺废水"] --> B["中和 铝置换"]
 C["废气/真空泵定排 地面/设备/滤布清洗"] --> D["分股收集 合并中和置换"]
 B --> E["MVR 30t/d设计"]
 D --> E
 E --> F["冷凝水 回用于废气治理"]
 E --> G["废盐（设计）"]
 B --> H["生产污泥（项目预测）"]
 I["初雨"] --> J["中和 混凝沉淀 100m³/d设计"] --> M["总排口"]
 K["生活污水"] --> L["化粪池"] --> M
 N["纯水制备/冷却/锅炉排水"] --> M
 M --> O["广丰城投工业污水厂"] --> P["丰溪河"]','S086-06','转载拟审批设计；工业MVR支路不外排，不等于全厂零排放；纯水制备废RO膜不纳入生产废水膜','正式批复、现行设备及水量水质、废盐实际处置、冷凝水品质和费用','2026-11-28'),
('D094-02','CN0283','company_waste_procurement_2025','unknown','2025–2027采购计划',1,'partial','flowchart TD
 A["公司无机化工废水"] --> B["絮凝沉淀（采购描述）"]
 A --> C["MVR蒸发（采购描述）"]
 B --> D["污泥"]
 C --> E["废液干化渣"]
 D --> F["合计50t/a预估 HW18"]
 E --> F
 F --> G["要求刚性填埋"]','S094-02','采购明确两种产渣工艺，未披露串并联、装置归属与投运；图中并列仅表示证据关系而非真实管线；不认定新项目独属','验收、废水专线、实际工艺连接、出水及残渣去向、运行成本','2026-11-28'),
('D094-03','CN0328','east_expansion_2025','design','2025',1,'partial','flowchart TD
 A["W1-1水洗废水"] --> B["蒸发脱盐"]
 B --> C["冷凝水入综合站"]
 B --> S["废盐"]
 D["其他项目废水"] --> C
 C --> E["共享站 扩至800t/d设计"]
 E --> F["两级反应沉淀（高氟支路）"]
 F --> G["调节池"]
 H["树脂洗涤及生活水"] --> G
 G --> I["A/O"] --> J["终沉池"] --> K["过滤"] --> L["外排缓冲池"]
 M["树脂洗涤回用浓水及循环排水"] --> L
 L --> N["监控池 纳管"]
 F --> O["污泥浓缩 压滤"]
 J --> O
 O --> P["干泥外运"]
 O --> G','S073-01','扩建报告7.2图7.2-1及p241现有工艺回顾；C/E汇总不表示每股进入高氟支路；具体新增水接入支路待核；非催化剂专线；回用装置类型未披露','实际扩建验收、分质接入、树脂回用设施类型及成本、旧催化剂车间实际状态','2026-11-28'),
('D094-04','CN0335','phase1_2021_wastewater','design','2021-08',1,'partial','flowchart TD
 A["氧化铝/炭载铂族酸性水16.15m³/d（设计）"] --> B["氧化铝载铂族部分 制聚合氯化铝铁外售"]
 C["其余酸性废水"] --> D["储罐 泵送 曝气 NaOH中和 pH8–9"]
 D --> E["板框压滤"]
 E --> F["滤液/清液池"]
 E --> G["污泥 回转干燥"]
 H["一般生产水 79.3m³/d 及冷却排水"] --> F
 I["地面设备冲洗"] --> J["澄清沉淀"] --> F
 F --> K["三效蒸发 深度设计104.3m³/d"]
 K --> L["冷凝水回用"]
 K --> M["结晶盐 回转干燥 设计一般固废"]
 N["生活污水"] --> O["园区排水"]','S094-04','2021一期可研设计；酸性原水23.6与中和后25m³/d及资源化水关系未闭合；资源化具体分股待核；不能认定现场盐属性','正式批复/验收、实际进水和产水、金属及盐、有机物、浓缩物处置及能耗','2026-11-28'),
('D094-05','CN0300','permit_dependent_station','unknown','2026许可条件',1,'partial','flowchart TD
 A["厂区废水"] --> B["依托污水处理厂（单元未知）"]','S043-05','仅回填W043-26旧证据的依托处理边界，非本轮新工程事实；依托站停运时须停止经营','依托厂名及工艺、专线流量、预处理、膜和实际运行','2026-11-28');
INSERT INTO process_diagram_evidence(evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES
('DE094-01','D094-01','W094-01','S086-06','废水防治措施检索正文','A,B','工艺水中和铝置换'),
('DE094-02','D094-01','W094-02','S086-06','废水防治措施','C,D','其他生产水分股合并中和置换'),
('DE094-03','D094-01','W094-03','S086-06','废水及固废防治措施','E,F,G,H','MVR能力冷凝回用及废盐/污泥项目预测'),
('DE094-04','D094-01','W094-04','S086-06','废水防治措施','I,J,M,O,P','初雨处理与接管'),
('DE094-05','D094-01','W094-05','S086-06','废水防治措施','K,L,M','生活化粪池'),
('DE094-06','D094-01','W094-06','S086-06','废水防治措施','N,M','公辅排水接管'),
('DE094-07','D094-02','W094-07','S094-02','技术部分危废种类表','A,B,C,D,E,F,G','两处理工艺、预估合计及处置要求；未证明串并联'),
('DE094-08','D094-03','W094-11','S073-01','图7.2-1及表7.2-2','A,B,C,S','蒸发脱盐及冷凝水'),
('DE094-09','D094-03','W094-10','S073-01','p241截图及p240正文','D,E,F,G,H,I,J,K,L,M,N,O,P','扩建能力及沿用既有工艺，未明确新股接入细节'),
('DE094-10','D094-04','W094-15','S094-04','2.5.2.2 p136','A,B','原文仅明确氧化铝载铂族水资源化'),
('DE094-11','D094-04','W094-19','S094-04','2.5.2.2 p136–137','C,D,E,F,G','NaOH中和、板框压滤和滤液'),
('DE094-12','D094-04','W094-21','S094-04','2.5.2.2 p137','H,F,K,L,M','深度处理及冷凝回用'),
('DE094-13','D094-04','W094-22','S094-04','2.5.2.2 p137','I,J,F','冲洗水澄清'),
('DE094-14','D094-04','W094-23','S094-04','2.5.2.2 p136','N,O','生活污水另排'),
('DE094-15','D094-05','W043-26','S043-05','旧许可条件及N043相关记录','A,B','已知依托站边界；仅回填');
INSERT INTO membrane_reviews(review_id,site_id,diagram_id,scope_key,stage,period,revision,presence,source_id,evidence_basis,gaps,updated_on) VALUES
('R094-01','CN0353','D094-01','expansion_2026_water','design','2026拟批',1,'not_identified','S086-06','生产水设计中和/置换/MVR，纯水RO另列；非全厂明确无膜','实际水处理装机与进水盐分','2026-11-28'),
('R094-02','CN0283','D094-02','company_waste_procurement_2025','unknown','2025–2027采购计划',1,'not_identified','S094-02','采购表仅识别絮凝/MVR，不否定膜存在，不能确认项目专属','实际工程验收及膜类型','2026-11-28'),
('R094-03','CN0328','D094-03','east_expansion_2025','design','2025',1,'not_identified','S073-01','蒸发脱盐及共享站，树脂洗涤回用装置技术未取；纯水不等于污水膜','实际运行及回用技术','2026-11-28'),
('R094-04','CN0335','D094-04','phase1_2021_wastewater','design','2021-08',1,'not_identified','S094-04','一期设计三效蒸发，中和压滤及资源化；未完整核设备清单','实际运行及膜系统','2026-11-28'),
('R094-05','CN0300','D094-05','permit_dependent_station','unknown','2026许可条件',1,'not_identified','S043-05','仅依托站条件，具体单元未知','依托站及膜','2026-11-28');
INSERT INTO membrane_retrofits(assessment_id,review_id,site_id,scope_key,option_key,revision,objective,proposed_route,feasibility,hard_constraints,evidence_basis,assumptions,missing_inputs,validation_plan,alternatives,feed_risk,pretreatment_risk,concentrate_risk,integration_risk,operational_risk,compliance_economics_risk,score_basis,updated_on) VALUES
('A094-R1','R094-01','CN0353','expansion_2026_water','screening',1,'减轻MVR盐负荷','中和置换后取样；必要时进一步除金属/除硬，按盐度筛NF/RO或ED预浓缩，保留MVR及冷凝回用','conditional','贵金属损失、结垢、浓液合规处置、回用水质','D094-01及原来源','INFERRED；非现场证实','实际分股、水质、MVR能耗及盐处置费','金属与盐衡算、小试、连续运行及费用比较','优化现有置换与MVR',NULL,NULL,NULL,NULL,NULL,NULL,'缺六维实证输入，不赋分','2026-11-28'),
('A094-R2','R094-02','CN0283','company_waste_procurement_2025','screening',1,'高盐残渣减量','先核絮凝沉淀与MVR实际连接、分股水量；在回收金属及浓液去向明确后筛选膜预浓缩','conditional','高盐残渣合法处置、膜相容性','D094-02及原来源','INFERRED；非现场证实','实际盐度、金属、流量、残渣含水率及成本','实际取样、膜小试、残渣物料衡算','优化现有蒸发与污泥处理',NULL,NULL,NULL,NULL,NULL,NULL,'缺六维实证输入，不赋分','2026-11-28'),
('A094-R3','R094-03','CN0328','east_expansion_2025','screening',1,'共享站扩建与分质优化','高氟先沉淀/脱盐；比较低盐支路NF/RO回用，不直接处理高AOX高盐原水','conditional','氟及有机物相容性、盐处置、共享站边界及旧催化剂线状态','D094-03及原来源','INFERRED；非现场证实','实际分股浓度/流量、回用需求及处置成本','预处理试验、膜污染及氟/AOX截留、经济性比较','保留分质蒸发和A/O',NULL,NULL,NULL,NULL,NULL,NULL,'缺六维实证输入，不赋分','2026-11-28'),
('A094-R4','R094-04','CN0335','phase1_2021_wastewater','screening',1,'蒸发减量及资源化','核实既有聚合氯化铝铁资源化及酸性水边界，除金属后按离子组成比较NF/RO/ED预浓缩；保留三效蒸发','conditional','高酸高金属、盐/污泥鉴别与处置、回用条件','D094-04及原来源','INFERRED；非现场证实','实际水量、pH、金属、盐、蒸汽及药耗','分股采样、材料相容、金属衡算及全费用','优化资源化、中和、三效蒸发',NULL,NULL,NULL,NULL,NULL,NULL,'缺六维实证输入，不赋分','2026-11-28'),
('A094-R5','R094-05','CN0300','permit_dependent_station','screening',1,'依托处理边界核查','暂不指定膜方案；先查依托站及厂内预处理','unknown','缺实际处理链','D094-05及原来源','INFERRED；非现场证实','实际分股与依托协议、成本','取得验收和处理站资料','依托站优化待核',NULL,NULL,NULL,NULL,NULL,NULL,'缺六维实证输入，不赋分','2026-11-28');
INSERT INTO evidence_notes(note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES
('N094-01','CN0003','S094-01','建设主体与物理厂区归属闭合','项目名称、建设地点及建设单位栏；W06S18索引交叉','长岭分公司法律主体，项目在云溪基地现有厂区；原W06S18简称长岭2025项目环评历史装置表产生歧义，094改为全称并保留双关联历史，不迁移云溪事实到长岭厂区。原PDF复开超时；官方公示证实厂区，不单独证实ED退出日期及现场运行。项目总投资公示写100元与5万元占5%矛盾；报告索引100万元，暂不录经济表。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N094-02','CN0353','S086-06','同源定向补取生产及初雨支路','2026-07-13拟批转载检索正文废水/固废措施','生产工艺水中和铝置换，其他废气/真空泵及各类清洗水合并中和置换，1套MVR设计30t/d冷凝水回废气治理；初雨100m³/d中和混凝沉淀，生活化粪池与公辅水纳管。污泥20t/a、废盐775.495t/a均设计危废HW49；纯水废RO膜0.2t/a属公用系统，不算生产水膜。雨水在线总铊及电导、例行pH/COD/BOD5/氨氮/SS/总磷/石油类/Cu/Zn/Ni/Fe/Ag，均设计要求非实测。网页重开正文受遮挡，索引有完整段落；原正式批复待核。','WEB_SECONDARY','WEB_TEXT','2026-11-28'),
('N094-03','CN0283','S094-02','危废处置计划与工程边界','采购技术表及首次转移时间','公司计划HW18 772-003-18污水站污泥及MVR干化渣合计预估50t/a、高盐、刚性填埋；实验废液0.5t/a为酸性实验/监测废液，不能当工业废水；首次预计2026下半年转移，未见联单、实际吨数及成交单价。公司级公告不能单独证明燃料电池催化剂项目工艺或投运。','WEB_COMPANY','WEB_TEXT','2026-11-28'),
('N094-04','CN0328','S073-01','新增共享站设计水量及高氟处理','图7.2-1、表7.2-1/2、p241截图','项目36000t/a（120t/d）排水；全厂生化需求约626.6t/d，原600扩至800t/d、工艺不变。水洗蒸发脱盐表COD/AOX/氟/盐去除95/99/99/99%均设计；共享站二级沉淀出水入调节A/O、终沉过滤缓冲监控，污泥浓缩压滤，上清液及滤液回调节；树脂回用浓水与循环排水进缓冲池，回用技术未明。预测污泥10t/a、预处理废渣497.6t/a列HW45。4000t/a产品非催化剂，拟拆旧催化剂车间不判已拆。p240截图超时，p241截图成功。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N094-05','CN0335','S094-04','一期分股、回用及口径差异','2.2.5.4、2.5.2.2–3 p135–138','一期1600t/a六类分项；酸性原水合计23.6m³/d，四分股16.15+0.28+0.85+6.33=23.61（四舍五入）；报告另列中和后25、一般79.3、深度104.3m³/d，不能将资源化分流后量强行配平。蒸发盐设计一般固废，污泥34.46t/a列HW48 323-001-48；实际鉴别及去向待核。pH、含尘为设计非实测。PDF正文可读，截图请求超时。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N094-06','CN0257','S094-06','项目竣工验收披露','2025 ESG绿色产业段','公司称东营项目竣工验收进入生产运行阶段；未明确具体环保验收文件及日期，与2026试生产报道并存，不认定污水处理验收通过。S094-05环评索引找到但文件超访问限额。','WEB_COMPANY','WEB_TEXT','2026-11-28'),
('N094-07','CN0281','S094-07','膜应用范围排除','行业会议报道双氧水段','企业披露针对双氧水产品纯化的膜处理技术，4t/h装置、运行费用相对降低30–50%以上、废水量减少90%均为该产品工艺案例陈述，非本厂催化剂污水站或吨水实测，不计污水膜/经济覆盖。','WEB_SECONDARY','WEB_TEXT','2026-11-28'),
('N094-08','CN0190','S094-08','历史投产节点','2020-05-29投产项目段','地方报道失活催化剂处置及催化剂加工项目列入投产项目；区别2023年5万吨项目，不能作为实际废水运行、处理量或现行许可证明。','WEB_SECONDARY','WEB_TEXT','2026-11-28'),
('N094-09','CN0270','S094-09','应急资料范围','第30项搜索索引','政府应急方案列硝酸30%、硅溶胶及事故源生产车间、危废仓库；生产废水类型栏为斜线，非明确无废水证据，亦非膜核查；原件未完整读取。','WEB_PRIMARY','WEB_TEXT','2026-11-28');
UPDATE sites SET address='济源市玉川产业集聚区（2021一期环评，详细厂界及现址待核）',water_summary='2021一期设计酸性水分质资源化、NaOH中和板框压滤及三效蒸发104.3m³/d，冷凝回用；现行运行待核',water_level='有工艺线索',as_of='2026-11-28' WHERE site_id='CN0335';
UPDATE sites SET water_summary='2026拟批转载设计中和置换、MVR30t/d及冷凝水回用；初雨100m³/d预处理，公辅等纳管；实际待核',water_level='有工艺线索',as_of='2026-11-28' WHERE site_id='CN0353';
INSERT INTO search_log(log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES
('L094-01','CN0003','094 search:legal_entity_physical_site','厂区归属专项核对','S094-01','官方拟批及原报告索引明确云溪基地','正式批复及2024 HTS原报告','2026-11-28'),
('L094-02','CN0353','094 document:water_solid_paragraph','拟批原有污水支路','S086-06','同源索引完整段落，重开遮挡','正式批复、实际运行','2026-11-28'),
('L094-03','CN0283','094 search:residue_mvr','危废采购反查污水单元','S094-02','企业官方采购正文','项目验收及工程归属','2026-11-28'),
('L094-04','CN0328','094 document:7.2_p239_241','扩建分股与源强','S073-01','原报告正文及p241截图，p240超时','实际验收及具体接入','2026-11-28'),
('L094-05','CN0335','094 document:2.5.2.2','一期原环评水工艺及能力','S094-04','政府原报告正文，截图超时','正式批复及实际运行','2026-11-28'),
('L094-06','CN0257','094 document:new_report_2024','原环评正文及废水工艺','S094-05','原PDF超过访问限额，索引仅标题及园区通用要求','可访问官方附件或缩小版','2026-11-28'),
('L094-07','CN0257','094 document:esg2025','项目验收节点','S094-06','企业ESG报告','环保验收原件','2026-11-28'),
('L094-08','CN0281','094 search:hydrogen_peroxide_membrane','膜范围核查','S094-07','发现双氧水产品膜案例，排除催化剂废水范围','催化剂车间原环评','2026-11-28'),
('L094-09','CN0190','094 search:industrial_park_project','历史投产节点','S094-08','地方媒体2020投产项目报道','实际许可执行及污水','2026-11-28'),
('L094-10','CN0270','094 search:emergency_plan','生产废水范围','S094-09','索引第30项，斜线非无水证据','厂区环评及许可','2026-11-28'),
('L094-11','CN0327','094 document:alternate_access','新项目逐股源强','S072-01','政府附件无法访问','可读同版本入口','2026-11-28'),
('L094-12','CN0300','094 search:permit_and_station','依托站污水处理',NULL,'许可及既有范围命中，无新站工艺；独立回填旧图','依托站正式报告','2026-11-28'),
('L094-13','CN0271','094 search:approval_design','废水工艺及扩建设计','S033-01','旧20m³/h、RO及分流已录','新环评或验收','2026-11-28'),
('L094-14','CN0336','094 search:reference_scope','污水处理装置跨项目搜索','S078-01','旧10万吨/年共享站已录，不能串给大连公司','独立新报告','2026-11-28'),
('L094-15','CN0262','094 search:water_permit','污水工程与许可','S031-19','旧许可分项已录','可读原环评','2026-11-28'),
('L094-16','CN0275','094 search:station_company','污水站工艺','S034-02','官网车间旧线索，无新工艺','污水站技改验收','2026-11-28'),
('L094-17','CN0329','094 search:upgrade_eia','扩建废水处理',NULL,'旧5000t/a与扩建索引重复','正式批复原件','2026-11-28'),
('L094-18','CN0267','094 search:project_eia','项目环评','S031-08','旧报批前公示及投资信息重复','官方报告正文','2026-11-28'),
('L094-19','CN0290','094 search:design_project','项目废水',NULL,'旧5300t/a及公辅设施报道重复','报告工艺章节','2026-11-28'),
('L094-20','CN0302','094 search:permit_station','废水与许可','S043-05','旧拟许可/正式许可已录','独立污水报告','2026-11-28'),
('L094-21','CN0359','094 search:water_roster','废水及许可','S088-01','旧8万吨综合许可已录','工程原报告','2026-11-28'),
('L094-22','CN0325','094 search:project_water','项目废水',NULL,'核准索引旧项目重复','环评正文','2026-11-28'),
('L094-23','CN0204','094 search:company_water','废水处理系统','W03S22','企业介绍DCS等笼统，未取具体工艺','验收/排污执行报告','2026-11-28'),
('L094-24','CN0333','094 search:water_procurement','污水处理与采购',NULL,'采购及集团关联未提供本厂污水工艺','正式厂区工程资料','2026-11-28'),
('L094-25','CN0360','094 search:water_eia','废水环评',NULL,'本次结果未取得独立可归属水资料','原工程报告','2026-11-28'),
('L094-26','CN0354','094 search:water_eia','废水环评',NULL,'本次未获得厂区废水正文','独立新报告','2026-11-28'),
('L094-27','CN0356','094 search:water_eia','废水环评',NULL,'本次未获得厂区废水正文','独立新报告','2026-11-28'),
('L094-28','CN0361','094 search:water_eia','废水环评',NULL,'本次未获得厂区废水正文','独立新报告','2026-11-28'),
('L094-29','CN0326','094 search:water_eia','配套催化剂废水',NULL,'索引仅除草剂及配套项目，未获专线废水','独立新报告','2026-11-28'),
('L094-30','CN0318','094 search:water_supervision','污水及监管',NULL,'抽查及土壤监管名单不证明污水工艺，邻厂水设施不归本厂','独立新报告','2026-11-28'),
('L094-31','CN0191','094 search:water_eia','废水工程',NULL,'本次未取得独立结果','原环评','2026-11-28'),
('L094-32','CN0255','094 search:water_eia','废水工程',NULL,'本次未取得独立结果','原环评','2026-11-28'),
('L094-33','CN0278','094 search:water_eia','废水工程',NULL,'本次未取得独立结果','原环评','2026-11-28'),
('L094-34','CN0294','094 search:water_eia','废水工程',NULL,'本次未取得独立结果','原环评','2026-11-28');
INSERT INTO research_revisit_attempts(attempt_id,site_id,scope_key,gap,route_key,search_log_id,source_id,checked_on,outcome,gained_fields,evidence_refs,effort_minutes,next_check_on,reopen_trigger,rationale) VALUES
('A094-01','CN0003','ethanol_carbon_auxiliary','厂区归属专项核对','search:legal_entity_physical_site','L094-01','S094-01','2026-11-28','context_gain','厂区归属闭合','N094-01',NULL,NULL,'正式批复及2024 HTS原报告','官方拟批及原报告索引明确云溪基地'),
('A094-02','CN0353','expansion_2026_water','拟批原有污水支路','document:water_solid_paragraph','L094-02','S086-06','2026-11-28','engineering_gain','两站设计能力、分流回用及废盐','W094-01–06/D094-01',NULL,NULL,'正式批复、实际运行','同源索引完整段落，重开遮挡'),
('A094-03','CN0283','company_waste_procurement_2025','危废采购反查污水单元','search:residue_mvr','L094-03','S094-02','2026-11-28','engineering_gain','絮凝/MVR及残渣计划','W094-07/D094-02',NULL,NULL,'项目验收及工程归属','企业官方采购正文'),
('A094-04','CN0328','east_expansion_2025','扩建分股与源强','document:7.2_p239_241','L094-04','S073-01','2026-11-28','engineering_gain','6水量、13预测指标及扩建图','W094-08–13/D094-03',NULL,NULL,'实际验收及具体接入','原报告正文及p241截图，p240超时'),
('A094-05','CN0335','phase1_2021_wastewater','一期原环评水工艺及能力','document:2.5.2.2','L094-05','S094-04','2026-11-28','engineering_gain','7规模、11分股/能力、6设计指标、图','C094-01–07/W094-14–24/D094-04',NULL,NULL,'正式批复及实际运行','政府原报告正文，截图超时'),
('A094-06','CN0257','site_current','原环评正文及废水工艺','document:new_report_2024','L094-06','S094-05','2026-11-28','access_blocked','报告入口','S094-05',NULL,'2026-12-28','可访问官方附件或缩小版','原PDF超过访问限额，索引仅标题及园区通用要求'),
('A094-07','CN0257','site_current','项目验收节点','document:esg2025','L094-07','S094-06','2026-11-28','context_gain','竣工验收陈述','P094-02/N094-06',NULL,NULL,'环保验收原件','企业ESG报告'),
('A094-08','CN0281','site_current','膜范围核查','search:hydrogen_peroxide_membrane','L094-08','S094-07','2026-11-28','context_gain','范围辨析非污水膜','N094-07',NULL,NULL,'催化剂车间原环评','发现双氧水产品膜案例，排除催化剂废水范围'),
('A094-09','CN0190','site_current','历史投产节点','search:industrial_park_project','L094-09','S094-08','2026-11-28','context_gain','历史项目状态','P094-03',NULL,NULL,'实际许可执行及污水','地方媒体2020投产项目报道'),
('A094-10','CN0270','site_current','生产废水范围','search:emergency_plan','L094-10','S094-09','2026-11-28','context_gain','应急资料范围','N094-09',NULL,NULL,'厂区环评及许可','索引第30项，斜线非无水证据'),
('A094-11','CN0327','site_current','新项目逐股源强','document:alternate_access','L094-11','S072-01','2026-11-28','access_blocked','无','S072-01',NULL,'2026-12-28','可读同版本入口','政府附件无法访问'),
('A094-12','CN0300','site_current','依托站污水处理','search:permit_and_station','L094-12',NULL,'2026-11-28','duplicate','无新事实；D094-05旧证据回填','W043-26',NULL,'2026-12-28','依托站正式报告','许可及既有范围命中，无新站工艺；独立回填旧图'),
('A094-13','CN0271','site_current','废水工艺及扩建设计','search:approval_design','L094-13','S033-01','2026-11-28','duplicate','无','S033-01',NULL,'2026-12-28','新环评或验收','旧20m³/h、RO及分流已录'),
('A094-14','CN0336','site_current','污水处理装置跨项目搜索','search:reference_scope','L094-14','S078-01','2026-11-28','duplicate','无','S078-01',NULL,'2026-12-28','独立新报告','旧10万吨/年共享站已录，不能串给大连公司'),
('A094-15','CN0262','site_current','污水工程与许可','search:water_permit','L094-15','S031-19','2026-11-28','duplicate','无','S031-19',NULL,'2026-12-28','可读原环评','旧许可分项已录'),
('A094-16','CN0275','site_current','污水站工艺','search:station_company','L094-16','S034-02','2026-11-28','duplicate','无','S034-02',NULL,'2026-12-28','污水站技改验收','官网车间旧线索，无新工艺'),
('A094-17','CN0329','site_current','扩建废水处理','search:upgrade_eia','L094-17',NULL,'2026-11-28','duplicate','无','旧扩建笔记',NULL,'2026-12-28','正式批复原件','旧5000t/a与扩建索引重复'),
('A094-18','CN0267','site_current','项目环评','search:project_eia','L094-18','S031-08','2026-11-28','duplicate','无','S031-08',NULL,'2026-12-28','官方报告正文','旧报批前公示及投资信息重复'),
('A094-19','CN0290','site_current','项目废水','search:design_project','L094-19',NULL,'2026-11-28','duplicate','无','旧项目笔记',NULL,'2026-12-28','报告工艺章节','旧5300t/a及公辅设施报道重复'),
('A094-20','CN0302','site_current','废水与许可','search:permit_station','L094-20','S043-05','2026-11-28','duplicate','无','S043-05',NULL,'2026-12-28','独立污水报告','旧拟许可/正式许可已录'),
('A094-21','CN0359','site_current','废水及许可','search:water_roster','L094-21','S088-01','2026-11-28','duplicate','无','S088-01',NULL,'2026-12-28','工程原报告','旧8万吨综合许可已录'),
('A094-22','CN0325','site_current','项目废水','search:project_water','L094-22',NULL,'2026-11-28','duplicate','无','旧核准记录',NULL,'2026-12-28','环评正文','核准索引旧项目重复'),
('A094-23','CN0204','site_current','废水处理系统','search:company_water','L094-23','W03S22','2026-11-28','no_new','无具体新工艺','W03S22',NULL,'2026-12-12','验收/排污执行报告','企业介绍DCS等笼统，未取具体工艺'),
('A094-24','CN0333','site_current','污水处理与采购','search:water_procurement','L094-24',NULL,'2026-11-28','no_new','无','无',NULL,'2026-12-12','正式厂区工程资料','采购及集团关联未提供本厂污水工艺'),
('A094-25','CN0360','site_current','废水环评','search:water_eia','L094-25',NULL,'2026-11-28','no_new','无','无',NULL,'2026-12-12','原工程报告','本次结果未取得独立可归属水资料'),
('A094-26','CN0354','site_current','废水环评','search:water_eia','L094-26',NULL,'2026-11-28','no_new','无','无',NULL,'2026-12-12','独立新报告','本次未获得厂区废水正文'),
('A094-27','CN0356','site_current','废水环评','search:water_eia','L094-27',NULL,'2026-11-28','no_new','无','无',NULL,'2026-12-12','独立新报告','本次未获得厂区废水正文'),
('A094-28','CN0361','site_current','废水环评','search:water_eia','L094-28',NULL,'2026-11-28','no_new','无','无',NULL,'2026-12-12','独立新报告','本次未获得厂区废水正文'),
('A094-29','CN0326','site_current','配套催化剂废水','search:water_eia','L094-29',NULL,'2026-11-28','no_new','无','无',NULL,'2026-12-12','独立新报告','索引仅除草剂及配套项目，未获专线废水'),
('A094-30','CN0318','site_current','污水及监管','search:water_supervision','L094-30',NULL,'2026-11-28','no_new','无','无',NULL,'2026-12-12','独立新报告','抽查及土壤监管名单不证明污水工艺，邻厂水设施不归本厂'),
('A094-31','CN0191','site_current','废水工程','search:water_eia','L094-31',NULL,'2026-11-28','no_new','无','无',NULL,'2026-12-12','原环评','本次未取得独立结果'),
('A094-32','CN0255','site_current','废水工程','search:water_eia','L094-32',NULL,'2026-11-28','no_new','无','无',NULL,'2026-12-12','原环评','本次未取得独立结果'),
('A094-33','CN0278','site_current','废水工程','search:water_eia','L094-33',NULL,'2026-11-28','no_new','无','无',NULL,'2026-12-12','原环评','本次未取得独立结果'),
('A094-34','CN0294','site_current','废水工程','search:water_eia','L094-34',NULL,'2026-11-28','no_new','无','无',NULL,'2026-12-12','原环评','本次未取得独立结果');
INSERT INTO research_document_review(site_id,source_id,scope_key,gap,reviewed_on,state,locator,remaining_work,next_check_on,attempt_id) VALUES
('CN0353','S086-06','expansion_2026_water','拟批原有污水支路','2026-11-28','section_done','废水及固废防治措施','正式批复及验收',NULL,'A094-02'),
('CN0328','S073-01','east_expansion_2025','扩建分股与源强','2026-11-28','partial','7.2 p239–241','表7.2-1其余列、设备和原验收',NULL,'A094-04'),
('CN0335','S094-04','phase1_2021_wastewater','一期原环评水工艺及能力','2026-11-28','partial','2.2.5.4及2.5.2.2–3','原表2-53单位核验及实际验收',NULL,'A094-05'),
('CN0257','S094-05','site_current','原环评正文及废水工艺','2026-11-28','blocked','全文超过访问限额','合法可读版本','2026-12-28','A094-06');
-- Non-destructive quality audit: lexical triage only, not verified operating facts.
CREATE VIEW v_water_quantity_basis_audit AS
WITH a AS (SELECT w.*, coalesce(stage,'')||' '||coalesce(flow_basis,'') AS basis_text FROM wastewater w)
SELECT a.*, CASE
 WHEN flow IS NULL THEN 'no_numeric_value'
 WHEN trim(coalesce(flow_unit,'')) IN ('m³','m3','t') THEN 'volume_or_mass_without_time'
 WHEN basis_text LIKE '%能力%' OR basis_text LIKE '%容量%' OR basis_text LIKE '%规模%' OR basis_text LIKE '%池容%' THEN 'capacity_or_storage'
 WHEN basis_text LIKE '%许可%' OR basis_text LIKE '%上限%' OR basis_text LIKE '%限值%' THEN 'permitted_or_limit'
 WHEN basis_text LIKE '%设计%' OR basis_text LIKE '%预测%' OR basis_text LIKE '%估算%' OR basis_text LIKE '%核算%' OR basis_text LIKE '%拟建%' OR basis_text LIKE '%拟批%' THEN 'design_or_estimate'
 WHEN basis_text LIKE '%实际%' OR basis_text LIKE '%实测%' OR basis_text LIKE '%监测%' OR basis_text LIKE '%台账%' THEN 'actual_or_monitoring_candidate'
 ELSE 'unclassified_numeric' END AS quantity_class
FROM a;
CREATE VIEW v_site_quality_audit_094 AS
SELECT s.site_id,s.name,s.record_type,
 (SELECT count(*) FROM v_water_quantity_basis_audit w WHERE w.site_id=s.site_id AND quantity_class='actual_or_monitoring_candidate') AS actual_quantity_candidate_records,
 (SELECT count(*) FROM v_water_quantity_basis_audit w WHERE w.site_id=s.site_id AND quantity_class='capacity_or_storage') AS capacity_records,
 (SELECT count(*) FROM v_water_quantity_basis_audit w WHERE w.site_id=s.site_id AND quantity_class='volume_or_mass_without_time') AS storage_or_undated_mass_records,
 (SELECT count(*) FROM v_water_quantity_basis_audit w WHERE w.site_id=s.site_id AND quantity_class='design_or_estimate') AS design_quantity_records,
 (SELECT count(*) FROM v_water_quantity_basis_audit w WHERE w.site_id=s.site_id AND quantity_class='unclassified_numeric') AS unclassified_numeric_records,
 (SELECT count(*) FROM v_latest_membrane_reviews r WHERE r.site_id=s.site_id AND stage='operating' AND presence IN ('confirmed_present','confirmed_absent')) AS operating_resolved_membrane_scopes,
 (SELECT count(*) FROM v_latest_process_diagrams d WHERE d.site_id=s.site_id AND stage='operating' AND coverage='complete') AS operating_complete_diagrams
 FROM sites s;
COMMIT;
