PRAGMA foreign_keys=ON;
BEGIN;
INSERT INTO sources(source_id,title,url,source_type,document_date,scope,access_date) VALUES
('S092-01','辽宁众力催化剂科技有限公司企业及产品介绍','https://www.cnreagent.com/show1000212/index.php','行业平台企业介绍',NULL,'历史名称、铝镍催化剂产能及地址线索','2026-11-28'),
('S092-02','辽宁众力催化剂科技有限公司项目公告索引','https://www.bidcenter.com.cn/enterprise/lnzlchjkjyxgs/','招标平台索引','2026-08','3500t/a项目二次环评公示线索，未见原件','2026-11-28'),
('S092-03','晋城市颁发首张废催化剂综合利用危废经营许可证','https://www.jcgov.gov.cn/mljc/jcgk/jcys/202504/t20250418_2131105.shtml','政府新闻','2025-04-18','山西铧美获证','2026-11-28'),
('S092-04','废剂里掘宝 循环中生金','https://news.sina.com.cn/zx/gj/2026-05-27/doc-inhzkfvc1460793.shtml','媒体采访','2026-05-27','铧美项目企业受访陈述，非现场验收','2026-11-28'),
('S092-05','太化股份2023年半年度报告','https://money.finance.sina.com.cn/corp/view/vCB_AllBulletinDetail.php?id=9442718&stockid=600281','上市公司定期报告','2023','华盛丰旧工艺问题及火法改造方案','2026-11-28'),
('S092-06','太化股份2025年年度报告','https://paper.cnstock.com/html/2026-04/30/content_2212158.htm','上市公司定期报告','2026-04-30','华盛丰产能及经营披露','2026-11-28'),
('S092-07','山西危险废物经营许可证名单历史索引','https://www.lvliang.gov.cn/llxxgk/zfxxgk/xxgkml/gbmwj/hbj/fdzdgknr_55371/zcwjjjd_55375/202109/t20210917_1558750.html','政府名单检索摘录','2021-09-17','晋明通历史许可，原网页重开重定向失败','2026-11-28'),
('S092-08','风陵渡废SCR催化剂处置成交结果索引','https://www.yfbzb.com/winbid/detail/20261120_649508006.html','采购结果转载索引','2026-11-20','晋明通候选经营活动线索，不是实际处理','2026-11-28'),
('S092-09','吕梁市危废经营许可证历史名单','https://www.lvliang.gov.cn/llxxgk/zfxxgk/xxgkml/gbmwj/hbj/fdzdgknr_55371/gggs_55380/202303/t20230309_1742882.html','政府名单检索摘录','2023-03-09','京汇中历史许可，原网页重开重定向失败','2026-11-28'),
('S092-10','南通泰禾2025年年度报告','https://money.finance.sina.com.cn/corp/view/vCB_AllBulletinDetail.php?id=12202414&stockid=301665','上市公司定期报告','2026','全厂共享污水站改造线索，非IPN单线','2026-11-28');
INSERT INTO sites(site_id,name,province,city,address,category,status,record_type,capacity_summary,water_summary,water_level,priority,permit_id,source_status,as_of,notes) VALUES
('CN0363','辽宁众力催化剂科技有限公司','辽宁','鞍山',NULL,'铝镍/加氢催化剂','历史企业介绍；2026项目公示索引待核','厂区候选','历史3000t/a；拟3500t/a项目线索',NULL,'缺失','P2',NULL,'行业平台及公告索引','2026-11-28','腾鳌园区与汤岗子老虎屯地址线索冲突，未确认现厂址；鞍山市众力催化剂厂名称关联待核'),
('CN0364','山西铧美环保科技有限公司','山西','晋城','沁水经济技术开发区','废催化剂贵金属回收','2025获证；2026媒体称规模生产','纯回收','一期2000t/a企业受访陈述',NULL,'缺失','P1',NULL,'政府获证新闻及媒体采访','2026-11-28','火法湿法组合，未得污水工程证据'),
('CN0365','太原华盛丰贵金属材料有限公司','山西','太原','清徐县（注册地/实际厂址待区分）','废催化剂回收/贵金属加工','上市公司年度披露；改造投运待核','厂区','1000t/a废催化剂；贵金属净量2500kg/a口径待细分','2023半年报披露旧工艺废水量较大，未得定量及处理路线','有工艺线索','P1',NULL,'上市公司报告','2026-11-28','回收量、贵金属净量与产品产量不相加'),
('CN0366','山西晋明通环保科技有限公司','山西','晋中','平遥县朱坑乡西善信村（历史许可地址）','废SCR催化剂经营','历史许可到期；2026采购结果线索','纯回收','历史许可条目12500立方，年单位未核',NULL,'缺失','P2','HW省1407280036','政府名单索引及采购转载','2026-11-28','2019-01-04至2024-01-03许可；当前许可与是否再生待核'),
('CN0367','交城京汇中环保科技有限公司','山西','吕梁','交城县经济开发区（历史许可）','废催化剂经营','历史许可期满；当前续证待核','纯回收','历史许可条目2500吨，表头待核',NULL,'缺失','P2','HW省1411220053','政府名单索引','2026-11-28','2021-09-15至2026-09-14历史许可，未确认现行资格');
INSERT INTO site_sources(site_id,source_id) VALUES
('CN0363','S092-01'),
('CN0363','S092-02'),
('CN0364','S092-03'),
('CN0364','S092-04'),
('CN0365','S092-05'),
('CN0365','S092-06'),
('CN0366','S092-07'),
('CN0366','S092-08'),
('CN0367','S092-09'),
('CN0253','S092-10'),
('CN0301','turn787991search0');
INSERT INTO capacity(capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES
('C092-01','CN0363','非晶态铝镍催化剂',3000,'t/a','历史行业平台企业介绍',NULL,'历史企业介绍','S092-01','非现行实际产量；旧名及地址待核'),
('C092-02','CN0363','高端催化剂',3500,'t/a','项目公告索引名义规模','2026-08','拟建项目','S092-02','未见原公示及批复；不与历史能力相加'),
('C092-03','CN0364','废催化剂处理',2000,'t/a','企业受访陈述一期规模','2026-05','一期','S092-04','不等于实绩或许可上限'),
('C092-04','CN0365','废催化剂处理',1000,'t/a','年度报告产能口径','2025','贵金属回收','S092-06','非实际处理量'),
('C092-05','CN0365','贵金属催化剂（净贵金属口径）',2500,'kg/a','年度报告产能口径','2025','贵金属加工','S092-06','不与废催化剂进料吨数相加'),
('C092-06','CN0366','废SCR催化剂',12500,'m³','历史许可证索引条目','2019-01-04至2024-01-03','HW50 772-007-50','S092-07','原表头未核，不擅补年度时间单位，非当前许可'),
('C092-07','CN0367','废催化剂经营',2500,'t','历史许可证索引条目','2021-09-15至2026-09-14','历史许可','S092-09','原表头未核，不擅补年度时间单位，非当前许可'),
('C092-08','CN0301','HW46与HW50合计',41400,'t/a','正式经营许可名录','2026-08-07至2031-08-06','混合类别总量','turn787991search0','原拟许可C043-06保留，不相加或全归HW50；非实际经营量');
INSERT INTO projects(project_id,site_id,project,status,date,capacity_note,water_change,source_id) VALUES
('P092-01','CN0363','3500吨/年高端催化剂项目','二次公示索引待核','2026-08','3500t/a项目名义规模','原报告待取','S092-02'),
('P092-02','CN0365','废催化剂火法工艺改造','2023半年报方案，投运待核','2023','1000t/a方案口径，不与旧线相加','针对旧湿法废水量大、流程长等问题；实际改造效果未知','S092-05'),
('P092-03','CN0003','废乙醇资源化制碳源项目','2025环评设计','2025-05','3000t/a碳源，非催化剂产能','该辅助项目设计无生产及清洗废水，不代表HTS装置无废水','W06S18');
INSERT INTO wastewater(water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES
('W092-01','CN0003','HTS生产废水','2025环评回顾已整改',NULL,NULL,NULL,'高浓度有机废水（历史）','原电渗析改为低温减压蒸发','现行冷凝液去向待核','浓缩液去向待核','W06S18','WEB_PRIMARY','p86；回引2024-11环评；非2026独立现场核实；历史ED证据保留'),
('W092-02','CN0003','废乙醇制碳源辅助项目生产废水','2025环评设计',0,'t/a','报告明确不产生生产及设备/地面清洗废水',NULL,NULL,NULL,NULL,'W06S18','WEB_PRIMARY','p89，仅辅助项目设计边界；不外推HTS生产装置');
INSERT INTO process_diagrams(diagram_id,site_id,scope_key,stage,period,revision,coverage,mermaid,source_id,boundaries,gaps,updated_on) VALUES
('D092-01','CN0003','hts_evaporation_rectification','historical','2025环评回顾（引2024-11）',1,'partial','flowchart TD
 A["HTS生产废水"] --> B["低温减压蒸发（报告称已整改）"]
 B --> C["冷凝液去向待核"]
 B --> D["浓缩液去向待核"]','W06S18','仅HTS原电渗析改造范围；冷凝及浓液节点为待核占位而非确认处置路径','实际流量、进出水、蒸发器参数、能耗、浓液处置、2026运行状态','2026-11-28'),
('D092-02','CN0003','ethanol_carbon_auxiliary','design','2025-05',1,'no_production_wastewater','flowchart TD
 A["废乙醇制碳源辅助项目"] --> B["设计无生产及清洗废水"]
 C["初期雨水"] --> D["依托现有收集池"]
 E["后期雨水"] --> F["园区雨水管网"] --> G["松杨湖"]','W06S18','辅助项目非HTS生产装置；雨水单列','建成验收、实际运行与初期雨水最终处置','2026-11-28');
INSERT INTO process_diagram_evidence(evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES
('DE092-01','D092-01','W092-01','W06S18','p86','A,B','报告明确原ED改低温减压蒸发；C/D为待核非事实'),
('DE092-02','D092-02','W092-02','W06S18','p89','A,B,C,D,E,F,G','项目无生产及清洗废水，初雨依托现有收集，后雨经园区入松杨湖');
INSERT INTO membrane_reviews(review_id,site_id,diagram_id,scope_key,stage,period,revision,presence,source_id,evidence_basis,gaps,updated_on) VALUES
('R092-01','CN0003','D092-01','hts_evaporation_rectification','historical','2025环评回顾（引2024-11）',1,'not_identified','W06S18','原ED已被低温减压蒸发替换；不是全厂无膜结论，亦不确认其他膜设施状态','2026现场状态与其他膜系统边界','2026-11-28'),
('R092-02','CN0003','D092-02','ethanol_carbon_auxiliary','design','2025-05',1,'not_applicable','W06S18','辅助项目设计无生产及清洗废水','投运后是否与设计一致','2026-11-28');
INSERT INTO membrane_retrofits(assessment_id,review_id,site_id,scope_key,option_key,revision,objective,proposed_route,feasibility,hard_constraints,evidence_basis,assumptions,missing_inputs,validation_plan,alternatives,feed_risk,pretreatment_risk,concentrate_risk,integration_risk,operational_risk,compliance_economics_risk,score_basis,updated_on) VALUES
('A092-R1','R092-01','CN0003','hts_evaporation_rectification','ed_reintroduction_screen',1,'比较现有蒸发与膜减量的可靠性及全生命周期费用','先取得现行分股水质和蒸发能耗；仅在相容性、回收价值及可靠性可证明时小试NF/ED或组合，暂不推荐直接恢复原ED','conditional','必须解决历史膜故障及更换成本、浓缩残液处置','W06S18 p86；历史ED退出原因','INFERRED，不代表改造决策或实际费用','流量、盐、有机物、膜寿命、停机率、蒸发电汽耗、残液费用','取样、小试、膜污染和寿命测试、同边界成本对比','维持并优化低温蒸发；源头分质及回用',NULL,NULL,NULL,NULL,NULL,NULL,'历史有明确可靠性问题，但缺定量及新路线参数，不赋分','2026-11-28'),
('A092-R2','R092-02','CN0003','ethanol_carbon_auxiliary','no_new_wastewater',1,'避免将辅助项目误列为膜改造对象','不提出独立生产废水膜站','not_applicable','仅限报告设计范围','W06S18 p89','INFERRED；设计与现场需核','实际运行及初雨处理','取得验收资料','依托现有雨水管理',NULL,NULL,NULL,NULL,NULL,NULL,'无生产废水设计，不适用独立膜站','2026-11-28');
INSERT INTO evidence_notes(note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES
('N092-01','CN0003','W06S18','ED退出与蒸发替换','p86 4.1废气可行性段落','2025报告回引2024-11报告，说明原HTS废水ED存在故障频繁、膜片昂贵易损及维护繁琐等经济可靠性问题，报告称整改完成并改低温减压蒸发；V311A/B空置。旧ED历史证据保留；不外推全厂或2026状态。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N092-02','CN0003','W06S18','废乙醇辅助项目边界','表2-8、p89','HTS赶醇冷凝精制废乙醇参考量1522.27t/a，HW06 900-402-06；企业质检组成乙醇30–62.8%、水30–60%、丁醇低于6%、有机胺总氮低于0.015%；为废溶剂物料非生产废水实测量。拟制碳源3000t/a，报告设计无生产及清洗废水，初雨依托收集。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N092-03','CN0363','S092-01','历史产能与名称线索','企业介绍','历史铝镍催化剂3000t/a；与鞍山市众力催化剂厂关系及现厂址待核，不能以平台资料认定当前生产。','WEB_SECONDARY','WEB_TEXT','2026-11-28'),
('N092-04','CN0363','S092-02','高端催化剂项目线索','企业项目索引','2026年3500t/a项目二次公示索引；原环评未取得，不确定项目获批及投产。','WEB_SECONDARY','WEB_TEXT','2026-11-28'),
('N092-05','CN0364','S092-03','正式获证','政府新闻正文','2025年4月晋城市首张废催化剂综合利用危废经营许可证发给山西铧美；具体分项许可量、证号及当前执行报告待取。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N092-06','CN0364','S092-04','回收工艺及产能线索','媒体采访正文','受访企业称一期规模2000t/a，采用火法和湿法结合回收铂钯铑及铜锌；铂钯铑回收率98.8%、纯度99.99%以上为企业陈述；非独立检测，订单额非水处理成本。污水系统未知。','WEB_SECONDARY','WEB_TEXT','2026-11-28'),
('N092-07','CN0365','S092-05','旧工艺废水问题与方案','2023年半年报','旧工艺废水量大、流程长、能力小、效率低；披露1000t/a火法改造方案，不代表已建或旧水处理系统停用；实际水量及膜未知。','WEB_COMPANY','WEB_TEXT','2026-11-28'),
('N092-08','CN0365','S092-06','年度产能边界','2025年度报告','废催化剂处理量能力与贵金属净量口径分开；需核工程验收及实际产量。','WEB_COMPANY','WEB_TEXT','2026-11-28'),
('N092-09','CN0366','S092-07','历史许可证','政府名单搜索摘录','历史许可HW省1407280036，772-007-50，2019-01-04至2024-01-03，条目12500立方；原站重定向失败，年度表头未核。不能当现行许可。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N092-10','CN0366','S092-08','采购结果线索','2026-11-20转载索引','出现风陵渡废SCR催化剂处置结果线索，不能据此推定实际处置量、续证或生产工艺。','WEB_SECONDARY','WEB_TEXT','2026-11-28'),
('N092-11','CN0367','S092-09','历史许可证','政府名单搜索摘录','历史许可HW省1411220053，2021-09-15至2026-09-14，条目2500吨；原站重定向失败；续证、分项及表头待核。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N092-12','CN0301','turn787991search0','正式许可补证','2026-11-06持证名单','LN2110040039，2026-08-07至2031-08-06，HW46+HW50合计41400t/a；原拟许可不相加，不当实际经营量。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N092-13','CN0253','S092-10','共享站背景线索','年度报告','公司级污水处理升级线索，需确认二级A/O设施实际验收、是否承接IPN催化剂装置及含铬专线负荷；不把全厂数据归单线。','WEB_COMPANY','WEB_TEXT','2026-11-28');
UPDATE sites SET status='2026正式经营许可（实际经营待核）',permit_id='LN2110040039',source_status='正式持证名单及历史拟许可',as_of='2026-11-28' WHERE site_id='CN0301';
UPDATE sites SET water_summary=water_summary||'；2025环评p86回顾HTS原ED已整改为低温减压蒸发，其他膜与2026实际状态待核' WHERE site_id='CN0003';
INSERT INTO tasks(task_id,site_id,priority,missing,next_query,state) VALUES
('T092-01','CN0363','P2','旧名/实际厂址、3500t/a原报告及水处理','鞍山生态环境审批公告及项目原环评','待调查'),
('T092-02','CN0364','P1','分项许可、验收、湿法废水及处理站、膜','沁水经开区铧美环评验收与执行报告','待调查'),
('T092-03','CN0365','P1','火法改造验收、实际厂址、水量与污水处理','太化股份华盛丰2025/2026报告、清徐环评与验收','待调查'),
('T092-04','CN0366','P2','现行许可、经营类别、实际厂址与工艺','平遥晋明通现行许可证及处置验收','待调查'),
('T092-05','CN0367','P2','续证、实际生产与水处理','吕梁交城京汇中现行许可及项目环评','待调查');
INSERT INTO search_log(log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES
('L092-01','CN0003','092 document:p86','技术路线调整及退出原因','W06S18','原报告正文','实际蒸发及ED停用情况','2026-11-28'),
('L092-02','CN0003','092 document:table2-8_p89','辅助项目产污边界','W06S18','原报告正文','实际验收','2026-11-28'),
('L092-03','CN0363','092 search:alni_supplier','新增企业及历史能力','S092-01','企业介绍','现厂址及原环评','2026-11-28'),
('L092-04','CN0363','092 search:recent_eia','项目公示','S092-02','项目索引','原报告','2026-11-28'),
('L092-05','CN0364','092 search:regional_permit','新增回收企业正式获证','S092-03','政府正文','许可分项与验收','2026-11-28'),
('L092-06','CN0364','092 search:enterprise_interview','工艺及一期规模','S092-04','媒体正文','原环评及实绩','2026-11-28'),
('L092-07','CN0365','092 document:2023_interim','旧线废水及改造问题','S092-05','公司报告','改造验收及水处理','2026-11-28'),
('L092-08','CN0365','092 document:2025_annual','年度产能口径','S092-06','公司报告','现场产量及运行','2026-11-28'),
('L092-09','CN0366','092 search:regional_roster','历史许可','S092-07','索引可读原站重定向失败','现行许可及完整表头','2026-11-28'),
('L092-10','CN0366','092 search:recent_contract','处置结果','S092-08','转载索引','正式结果及履约','2026-11-28'),
('L092-11','CN0367','092 search:regional_roster','历史许可','S092-09','索引可读原站重定向失败','现行续证及完整表头','2026-11-28'),
('L092-12','CN0301','092 document:roster_new_row','拟许可转正式许可','turn787991search0','政府持证名单','实际运营及环评','2026-11-28'),
('L092-13','CN0253','092 document:2025_annual','共享站更新线索','S092-10','公司报告','单线接入及验收','2026-11-28'),
('L092-14','CN0137','092 search:parallel_discovery','万华拟批环评','W03S08','已有来源或项目口径命中','新独立报告或新事件','2026-11-28'),
('L092-15','CN0087','092 search:parallel_discovery','怡新项目环评','turn106948search5','已有来源或项目口径命中','新独立报告或新事件','2026-11-28'),
('L092-16','CN0183','092 search:parallel_discovery','抚顺贵金属项目','turn106948search0','已有来源或项目口径命中','新独立报告或新事件','2026-11-28'),
('L092-17','CN0193','092 search:parallel_discovery','锦州宏亚项目','W03S09','已有来源或项目口径命中','新独立报告或新事件','2026-11-28'),
('L092-18','CN0192','092 search:parallel_discovery','铁岭贵鑫项目','W07S18','已有来源或项目口径命中','新独立报告或新事件','2026-11-28'),
('L092-19','CN0002','092 search:parallel_discovery','长岭药剂采购','S029-04','已有来源或项目口径命中','新独立报告或新事件','2026-11-28'),
('L092-20','CN0083','092 search:parallel_discovery','天辰绿能项目','W03S16','已有来源或项目口径命中','新独立报告或新事件','2026-11-28'),
('L092-21','CN0344','092 search:parallel_discovery','营口申东项目','S081-01','已有来源或项目口径命中','新独立报告或新事件','2026-11-28'),
('L092-22','CN0138','092 search:parallel_discovery','鲁西分子筛项目','W07S23','已有来源或项目口径命中','新独立报告或新事件','2026-11-28'),
('L092-23','CN0218','092 search:parallel_discovery','四川明宏项目','W05S14','已有来源或项目口径命中','新独立报告或新事件','2026-11-28'),
('L092-24','CN0265','092 search:parallel_discovery','甘肃宏鑫项目','S031-05','已有来源或项目口径命中','新独立报告或新事件','2026-11-28'),
('L092-25','CN0106','092 search:parallel_discovery','营口向阳项目','S068-04','已有来源或项目口径命中','新独立报告或新事件','2026-11-28'),
('L092-26','CN0010','092 search:parallel_discovery','江北基地项目','W03S01','已有来源或项目口径命中','新独立报告或新事件','2026-11-28'),
('L092-27','CN0216','092 document:original_pdf','环评正文','W05S07','原链接404','合法新入口或验收','2026-11-28'),
('L092-28','CN0223','092 document:original_pdf','项目原文','W06S05','原件不可访问','合法新入口或验收','2026-11-28');
INSERT INTO research_revisit_attempts(attempt_id,site_id,scope_key,gap,route_key,search_log_id,source_id,checked_on,outcome,gained_fields,evidence_refs,effort_minutes,next_check_on,reopen_trigger,rationale) VALUES
('A092-01','CN0003','hts_evaporation_rectification','技术路线调整及退出原因','document:p86','L092-01','W06S18','2026-11-28','engineering_gain','ED替换及原因','W092-01/D092-01/R092-01/N092-01',NULL,NULL,'实际蒸发及ED停用情况','原报告正文'),
('A092-02','CN0003','ethanol_carbon_auxiliary','辅助项目产污边界','document:table2-8_p89','L092-02','W06S18','2026-11-28','engineering_gain','辅助项目零生产废水设计','P092-03/W092-02/N092-02',NULL,NULL,'实际验收','原报告正文'),
('A092-03','CN0363','site_current','新增企业及历史能力','search:alni_supplier','L092-03','S092-01','2026-11-28','context_gain','历史企业线索及产能','CN0363/C092-01',NULL,NULL,'现厂址及原环评','企业介绍'),
('A092-04','CN0363','high_end_3500','项目公示','search:recent_eia','L092-04','S092-02','2026-11-28','context_gain','拟建名义规模','P092-01/C092-02',NULL,NULL,'原报告','项目索引'),
('A092-05','CN0364','site_current','新增回收企业正式获证','search:regional_permit','L092-05','S092-03','2026-11-28','context_gain','新主体及获证','CN0364/N092-05',NULL,NULL,'许可分项与验收','政府正文'),
('A092-06','CN0364','phase1','工艺及一期规模','search:enterprise_interview','L092-06','S092-04','2026-11-28','context_gain','企业工艺及能力陈述','C092-03/N092-06',NULL,NULL,'原环评及实绩','媒体正文'),
('A092-07','CN0365','old_wet_fire_upgrade','旧线废水及改造问题','document:2023_interim','L092-07','S092-05','2026-11-28','engineering_gain','废水问题和改造方案','P092-02/N092-07',NULL,NULL,'改造验收及水处理','公司报告'),
('A092-08','CN0365','site_current','年度产能口径','document:2025_annual','L092-08','S092-06','2026-11-28','context_gain','新主体产能','C092-04/C092-05',NULL,NULL,'现场产量及运行','公司报告'),
('A092-09','CN0366','historical_permit','历史许可','search:regional_roster','L092-09','S092-07','2026-11-28','context_gain','新主体历史许可','C092-06/N092-09',NULL,NULL,'现行许可及完整表头','索引可读原站重定向失败'),
('A092-10','CN0366','procurement','处置结果','search:recent_contract','L092-10','S092-08','2026-11-28','context_gain','新经营线索','N092-10',NULL,NULL,'正式结果及履约','转载索引'),
('A092-11','CN0367','historical_permit','历史许可','search:regional_roster','L092-11','S092-09','2026-11-28','context_gain','新主体历史许可','C092-07/N092-11',NULL,NULL,'现行续证及完整表头','索引可读原站重定向失败'),
('A092-12','CN0301','formal_permit','拟许可转正式许可','document:roster_new_row','L092-12','turn787991search0','2026-11-28','context_gain','正式许可补证','C092-08/N092-12',NULL,NULL,'实际运营及环评','政府持证名单'),
('A092-13','CN0253','shared_station','共享站更新线索','document:2025_annual','L092-13','S092-10','2026-11-28','context_gain','共享工程背景','N092-13',NULL,NULL,'单线接入及验收','公司报告'),
('A092-14','CN0137','site_current','万华拟批环评','search:parallel_discovery','L092-14','W03S08','2026-11-28','duplicate','无','W03S08',NULL,'2026-12-28','新独立报告或新事件','已有来源或项目口径命中'),
('A092-15','CN0087','site_current','怡新项目环评','search:parallel_discovery','L092-15','turn106948search5','2026-11-28','duplicate','无','turn106948search5',NULL,'2026-12-28','新独立报告或新事件','已有来源或项目口径命中'),
('A092-16','CN0183','site_current','抚顺贵金属项目','search:parallel_discovery','L092-16','turn106948search0','2026-11-28','duplicate','无','turn106948search0',NULL,'2026-12-28','新独立报告或新事件','已有来源或项目口径命中'),
('A092-17','CN0193','site_current','锦州宏亚项目','search:parallel_discovery','L092-17','W03S09','2026-11-28','duplicate','无','W03S09',NULL,'2026-12-28','新独立报告或新事件','已有来源或项目口径命中'),
('A092-18','CN0192','site_current','铁岭贵鑫项目','search:parallel_discovery','L092-18','W07S18','2026-11-28','duplicate','无','W07S18',NULL,'2026-12-28','新独立报告或新事件','已有来源或项目口径命中'),
('A092-19','CN0002','site_current','长岭药剂采购','search:parallel_discovery','L092-19','S029-04','2026-11-28','duplicate','无','S029-04',NULL,'2026-12-28','新独立报告或新事件','已有来源或项目口径命中'),
('A092-20','CN0083','site_current','天辰绿能项目','search:parallel_discovery','L092-20','W03S16','2026-11-28','duplicate','无','W03S16',NULL,'2026-12-28','新独立报告或新事件','已有来源或项目口径命中'),
('A092-21','CN0344','site_current','营口申东项目','search:parallel_discovery','L092-21','S081-01','2026-11-28','duplicate','无','S081-01',NULL,'2026-12-28','新独立报告或新事件','已有来源或项目口径命中'),
('A092-22','CN0138','site_current','鲁西分子筛项目','search:parallel_discovery','L092-22','W07S23','2026-11-28','duplicate','无','W07S23',NULL,'2026-12-28','新独立报告或新事件','已有来源或项目口径命中'),
('A092-23','CN0218','site_current','四川明宏项目','search:parallel_discovery','L092-23','W05S14','2026-11-28','duplicate','无','W05S14',NULL,'2026-12-28','新独立报告或新事件','已有来源或项目口径命中'),
('A092-24','CN0265','site_current','甘肃宏鑫项目','search:parallel_discovery','L092-24','S031-05','2026-11-28','duplicate','无','S031-05',NULL,'2026-12-28','新独立报告或新事件','已有来源或项目口径命中'),
('A092-25','CN0106','site_current','营口向阳项目','search:parallel_discovery','L092-25','S068-04','2026-11-28','duplicate','无','S068-04',NULL,'2026-12-28','新独立报告或新事件','已有来源或项目口径命中'),
('A092-26','CN0010','site_current','江北基地项目','search:parallel_discovery','L092-26','W03S01','2026-11-28','duplicate','无','W03S01',NULL,'2026-12-28','新独立报告或新事件','已有来源或项目口径命中'),
('A092-27','CN0216','site_current','环评正文','document:original_pdf','L092-27','W05S07','2026-11-28','access_blocked','无','W05S07',NULL,'2026-12-28','合法新入口或验收','原链接404'),
('A092-28','CN0223','site_current','项目原文','document:original_pdf','L092-28','W06S05','2026-11-28','access_blocked','无','W06S05',NULL,'2026-12-28','合法新入口或验收','原件不可访问');
INSERT INTO research_document_review(site_id,source_id,scope_key,gap,reviewed_on,state,locator,remaining_work,next_check_on,attempt_id) VALUES
('CN0003','W06S18','hts_evaporation_rectification','技术路线调整及退出原因','2026-11-28','section_done','p86','实际运行与浓缩液去向',NULL,'A092-01'),
('CN0003','W06S18','ethanol_carbon_auxiliary','辅助项目产污边界','2026-11-28','section_done','表2-8、p89','项目验收',NULL,'A092-02'),
('CN0365','S092-05','old_wet_fire_upgrade','旧线废水及改造问题','2026-11-28','partial','2023半年报','原报告与工程验收',NULL,'A092-07');
COMMIT;
