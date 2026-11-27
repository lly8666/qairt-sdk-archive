BEGIN;
-- Batch 024: new disclosure facts and evidence-only diagram backfill. No historical migration changes.
INSERT INTO sites (site_id,name,province,city,address,category,status,record_type,capacity_summary,water_summary,water_level,priority,permit_id,source_status,as_of,notes) VALUES ('CN0255','陕西璟邑科技有限公司','陕西','宝鸡','凤翔区长青工业园化工园区','贵金属催化剂/配套回收','2023环评批复、2025募投披露；实际投运待核','基地/项目','2025募投316t/a催化剂；2021一期首次公示364.8t/a，口径不同','募投披露污水站建筑面积2160m²，工艺未知','部分信息/流程待查','P1',NULL,'企业披露/监管批复转述','2026-11-27','异地子公司，不与宝鸡科技新城母厂合计在产；早期公示与募投规模不能相加');
INSERT INTO sources (source_id,title,url,source_type,document_date,scope,access_date) VALUES ('S024-01','陕西瑞科2023年招股说明书（申报稿）','https://reportdocs.static.szse.cn/UpFiles/rasinfodisc1/202306/RAS_202306_0D1670A6AF4F49E7AE5CA807905AA6D3.pdf','上市披露','2023-06','1-1-178至180；200吨/日和污水处理费用；PDF正文及截图','2026-11-27');
INSERT INTO site_sources (site_id,source_id) VALUES ('CN0132','S024-01');
INSERT INTO sources (source_id,title,url,source_type,document_date,scope,access_date) VALUES ('S024-02','陕西瑞科2025年招股说明书申报稿（东方财富转载）','https://xinsanban.eastmoney.com/Article/NoticeContent?id=AN202506301700473601&pageIndex=31','上市披露转载','2025-06-30','主要产品产能产量表，kg','2026-11-27');
INSERT INTO site_sources (site_id,source_id) VALUES ('CN0132','S024-02');
INSERT INTO sources (source_id,title,url,source_type,document_date,scope,access_date) VALUES ('S024-03','宝审服环字〔2024〕29号高纯贵金属新材料项目环评批复','https://www.baoji.gov.cn/col9816/col9818/col9846/col9853/202405/t20240509_324715.html','政府批复','2024-05-09','一、二（四）（五）等；政府网页正文','2026-11-27');
INSERT INTO site_sources (site_id,source_id) VALUES ('CN0132','S024-03');
INSERT INTO sources (source_id,title,url,source_type,document_date,scope,access_date) VALUES ('S024-04','陕西瑞科及开源证券第一轮问询回复（东方财富转载）','https://xinsanban.eastmoney.com/Article/NoticeContent?id=AN202510161763297363&pageIndex=113','上市披露转载','2025-10-16','设备、现有与募投产能及建设面积表','2026-11-27');
INSERT INTO site_sources (site_id,source_id) VALUES ('CN0132','S024-04');
INSERT INTO site_sources (site_id,source_id) VALUES ('CN0255','S024-04');
INSERT INTO sources (source_id,title,url,source_type,document_date,scope,access_date) VALUES ('S024-05','陕西璟邑科技贵金属催化剂新材料生产基地一期首次环评公示','https://www.bjrock.com/news_detail/typeid/1/id/42.html','企业环评公示','2021','项目基本情况；早期方案','2026-11-27');
INSERT INTO site_sources (site_id,source_id) VALUES ('CN0255','S024-05');
INSERT INTO sources (source_id,title,url,source_type,document_date,scope,access_date) VALUES ('S024-06','陕西瑞科2025招股说明书申报稿（东方财富转载，募投审批）','https://xinsanban.eastmoney.com/Article/NoticeContent?id=AN202506301700473601&pageIndex=91','上市披露转载','2025-06-30','璟邑环评批复宝审服环字〔2023〕12号与节能审查','2026-11-27');
INSERT INTO site_sources (site_id,source_id) VALUES ('CN0255','S024-06');
INSERT INTO sources (source_id,title,url,source_type,document_date,scope,access_date) VALUES ('S024-07','海新能科2024年年度报告（新浪转载）','https://vip.stock.finance.sina.com.cn/corp/view/vCB_AllBulletinDetail.php?CompanyCode=80127750&gather=1&id=10938918','上市披露转载','2025','环境与社会责任、沈阳总排口七项污染物','2026-11-27');
INSERT INTO site_sources (site_id,source_id) VALUES ('CN0110','S024-07');
INSERT INTO sources (source_id,title,url,source_type,document_date,scope,access_date) VALUES ('S024-08','宝鸡高新区高纯贵金属新材料项目8栋单体建筑完成建设','https://www.baoji.gov.cn/bmpd/bjgxq/ztzl/mqfc/202512/t20251204_1231676.html','政府报道','2025-12-04','计划2026年3月投产；计划非验收','2026-11-27');
INSERT INTO site_sources (site_id,source_id) VALUES ('CN0132','S024-08');
INSERT INTO capacity (capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES ('C024-01a','CN0132','非均相贵金属催化剂',132000,'kg/年','常规班次产能','2024','科技新城新厂','S024-02','按300天；非环评许可');
INSERT INTO capacity (capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES ('C024-01b','CN0132','非均相贵金属催化剂',110723.73,'kg','年度产量','2024','科技新城新厂','S024-02',NULL);
INSERT INTO capacity (capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES ('C024-02a','CN0132','均相贵金属催化剂',20000,'kg/年','常规班次产能','2024','科技新城新厂','S024-02','按300天；非环评许可');
INSERT INTO capacity (capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES ('C024-02b','CN0132','均相贵金属催化剂',24281.04,'kg','年度产量','2024','科技新城新厂','S024-02',NULL);
INSERT INTO capacity (capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES ('C024-03a','CN0132','非均相贵金属催化剂',132000,'kg/年','常规班次产能','2023','科技新城新厂','S024-02',NULL);
INSERT INTO capacity (capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES ('C024-03b','CN0132','非均相贵金属催化剂',97958.16,'kg','年度产量','2023','科技新城新厂','S024-02',NULL);
INSERT INTO capacity (capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES ('C024-04a','CN0132','均相贵金属催化剂',20000,'kg/年','常规班次产能','2023','科技新城新厂','S024-02',NULL);
INSERT INTO capacity (capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES ('C024-04b','CN0132','均相贵金属催化剂',17765.09,'kg','年度产量','2023','科技新城新厂','S024-02',NULL);
INSERT INTO capacity (capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES ('C024-05','CN0132','贵金属渣精炼',150,'t/a','2024批复设计','2024','新高纯项目','S024-03','不增加原已批危废处置类别和精炼规模；非成品催化剂');
INSERT INTO capacity (capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES ('C024-06','CN0255','炭载贵金属催化剂',135,'t/a','2025募投设计','2025','长青工业园项目','S024-04','配体和氢化产品不计催化剂');
INSERT INTO capacity (capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES ('C024-07','CN0255','重质载体贵金属催化剂',161,'t/a','2025募投设计','2025','长青工业园项目','S024-04','配体和氢化产品不计催化剂');
INSERT INTO capacity (capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES ('C024-08','CN0255','均相贵金属催化剂',20,'t/a','2025募投设计','2025','长青工业园项目','S024-04','配体和氢化产品不计催化剂');
INSERT INTO capacity (capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES ('C024-09','CN0255','配体',15,'t/a','2025募投设计','2025','长青工业园项目','S024-04','配体和氢化产品不计催化剂');
INSERT INTO capacity (capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES ('C024-10','CN0255','氢化产品',300,'t/a','2025募投设计','2025','长青工业园项目','S024-04','配体和氢化产品不计催化剂');
INSERT INTO capacity (capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES ('C024-11','CN0255','贵金属催化剂制备',364.8,'t/a','早期首次公示设计','2021','一期早期方案','S024-05','与2025募投非可加口径');
INSERT INTO capacity (capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES ('C024-12','CN0255','贵金属催化剂再生',8000,'t/a','早期首次公示设计','2021','一期早期方案','S024-05','与2025募投非可加口径');
INSERT INTO capacity (capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES ('C024-13','CN0255','贵金属催化剂应用产品',110,'t/a','早期首次公示设计','2021','一期早期方案','S024-05','与2025募投非可加口径');
INSERT INTO wastewater (water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES ('W024-01','CN0132','生产回收、洗涤分离、清洗、喷淋水','2023招股披露既有',200,'t/d','表列废水处理能力；非实测流量','pH、COD、氨氮、SS','分质收集→预处理→生化','园区污水厂','生化泥入危废贮存后资质处置','S024-01','WEB_COMPANY','历史200m³/d摘要W0081单位未经核实，保留不换算；报告设备运行陈述非连续实测');
INSERT INTO wastewater (water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES ('W024-02','CN0132','生活污水','2023招股披露既有',NULL,NULL,NULL,NULL,'化粪池','园区污水厂',NULL,'S024-01','WEB_COMPANY','生活水与生产分流');
INSERT INTO wastewater (water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES ('W024-03','CN0132','高纯项目吸收塔高浓废水','2024批复设计',NULL,NULL,NULL,'高浓盐','蒸发浓缩脱盐预处理','后续液流向未明','结晶杂盐外运处理','S024-03','WEB_PRIMARY','不推定MVR或与新站明确串联');
INSERT INTO wastewater (water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES ('W024-04','CN0132','高纯项目工艺及综合废水','2024批复设计',NULL,NULL,NULL,NULL,'工艺/综合分池；pH调整→混凝物化→生化','宝鸡高新科技新城污水处理厂',NULL,'S024-03','WEB_PRIMARY','批复要求分质收集回用、污水管道流量计；回用具体点未披露');
INSERT INTO wastewater (water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES ('W024-05','CN0110','全厂污水总排口','2024年报披露',NULL,NULL,NULL,'SS、COD、总镍、总锌、钼、氨氮、石油类',NULL,'污水处理厂',NULL,'S024-07','WEB_SECONDARY','不能据排水指标证明2024膜仍运行');
INSERT INTO water_metrics (metric_id,site_id,water_id,point,metric,value_num,value_text,unit,result_kind,statistic,period,detection_limit,standard_max,source_id,notes) VALUES ('M024-01','CN0110','W024-05','污水总排口','SS',16,NULL,'mg/L','报告期披露浓度','统计口径未披露','2024',NULL,400,'S024-07','年报列GB8978-1996限值；未许可总量，ND不作0');
INSERT INTO water_metrics (metric_id,site_id,water_id,point,metric,value_num,value_text,unit,result_kind,statistic,period,detection_limit,standard_max,source_id,notes) VALUES ('M024-02','CN0110','W024-05','污水总排口','COD',12.85,NULL,'mg/L','报告期披露浓度','统计口径未披露','2024',NULL,1000,'S024-07','年报列GB8978-1996限值；未许可总量，ND不作0');
INSERT INTO water_metrics (metric_id,site_id,water_id,point,metric,value_num,value_text,unit,result_kind,statistic,period,detection_limit,standard_max,source_id,notes) VALUES ('M024-03','CN0110','W024-05','污水总排口','总镍',NULL,'未检出','mg/L','报告期披露浓度','统计口径未披露','2024',NULL,1,'S024-07','年报列GB8978-1996限值；未许可总量，ND不作0');
INSERT INTO water_metrics (metric_id,site_id,water_id,point,metric,value_num,value_text,unit,result_kind,statistic,period,detection_limit,standard_max,source_id,notes) VALUES ('M024-04','CN0110','W024-05','污水总排口','总锌',0.1,NULL,'mg/L','报告期披露浓度','统计口径未披露','2024',NULL,5,'S024-07','年报列GB8978-1996限值；未许可总量，ND不作0');
INSERT INTO water_metrics (metric_id,site_id,water_id,point,metric,value_num,value_text,unit,result_kind,statistic,period,detection_limit,standard_max,source_id,notes) VALUES ('M024-05','CN0110','W024-05','污水总排口','钼',0.22,NULL,'mg/L','报告期披露浓度','统计口径未披露','2024',NULL,3,'S024-07','年报列GB8978-1996限值；未许可总量，ND不作0');
INSERT INTO water_metrics (metric_id,site_id,water_id,point,metric,value_num,value_text,unit,result_kind,statistic,period,detection_limit,standard_max,source_id,notes) VALUES ('M024-06','CN0110','W024-05','污水总排口','氨氮',4.25,NULL,'mg/L','报告期披露浓度','统计口径未披露','2024',NULL,30,'S024-07','年报列GB8978-1996限值；未许可总量，ND不作0');
INSERT INTO water_metrics (metric_id,site_id,water_id,point,metric,value_num,value_text,unit,result_kind,statistic,period,detection_limit,standard_max,source_id,notes) VALUES ('M024-07','CN0110','W024-05','污水总排口','石油类',0.62,NULL,'mg/L','报告期披露浓度','统计口径未披露','2024',NULL,20,'S024-07','年报列GB8978-1996限值；未许可总量，ND不作0');
INSERT INTO water_economics (cost_id,site_id,water_id,item,value,unit,basis,period,source_id,notes) VALUES ('E024-01','CN0132',NULL,'污水处理费',0.23,'万元','招股书历史公司会计支出','2020','S024-01','搬迁前/过渡公司口径，非科技新城独立厂年度成本；无处理量不可算元/t');
INSERT INTO water_economics (cost_id,site_id,water_id,item,value,unit,basis,period,source_id,notes) VALUES ('E024-02','CN0132',NULL,'污水处理费',0.55,'万元','招股书历史公司会计支出','2021','S024-01','搬迁前/过渡公司口径，非科技新城独立厂年度成本；无处理量不可算元/t');
INSERT INTO water_economics (cost_id,site_id,water_id,item,value,unit,basis,period,source_id,notes) VALUES ('E024-03','CN0132',NULL,'污水处理费',1.69,'万元','招股书历史公司会计支出','2022','S024-01','搬迁前/过渡公司口径，非科技新城独立厂年度成本；无处理量不可算元/t');
INSERT INTO water_economics (cost_id,site_id,water_id,item,value,unit,basis,period,source_id,notes) VALUES ('E024-04','CN0132',NULL,'废水处理系统原值',114.22,'万元','设备账面原值','2025-06-30','S024-04','1套；净值83.54万元，成新率73.14%；不是总站投资或运行费');
INSERT INTO water_economics (cost_id,site_id,water_id,item,value,unit,basis,period,source_id,notes) VALUES ('E024-05','CN0132',NULL,'废水处理系统净值',83.54,'万元','设备账面净值','2025-06-30','S024-04','同一设备不能与原值相加');
INSERT INTO projects (project_id,site_id,project,status,date,capacity_note,water_change,source_id) VALUES ('P024-01','CN0132','高纯贵金属新材料项目','2024批复；2025-12建筑完工报道，计划2026-03投产未核','2024-05-09','150t/a贵金属渣精炼线','新站分池、蒸发脱盐预处理；非现行工艺','S024-03');
INSERT INTO projects (project_id,site_id,project,status,date,capacity_note,water_change,source_id) VALUES ('P024-02','CN0255','贵金属催化剂新材料生产基地','2023批复（披露转述）；2025募投，实际投运待核','2023-02-07','316t/a催化剂募投','污水站建筑2160m²，流程未披露','S024-06');
INSERT INTO site_relations (relation_id,site_id,other_site_id,relation,status,source_id,notes) VALUES ('REL024-01','CN0255','CN0132','异地子公司/母公司','披露确认','S024-04','长青工业园与科技新城为不同地点；不计母厂已运行产能');
INSERT INTO tasks (task_id,site_id,priority,missing,next_query,state) VALUES ('T0255','CN0255','P1','批复原文、2026建设及验收、废水量及单元、膜及成本','宝审服环字〔2023〕12号、长青工业园纳管及排污许可证','待核实');
INSERT INTO claims (claim_id,site_id,field,value,evidence_class,source_id,scope,observed_date) VALUES ('CL024-01','CN0132','2024产能与产量','非均相132000/110723.73 kg；均相20000/24281.04 kg','WEB_SECONDARY','S024-02','科技新城；常规产能，均相利用率121.41%','2024');
INSERT INTO claims (claim_id,site_id,field,value,evidence_class,source_id,scope,observed_date) VALUES ('CL024-02','CN0132','200吨/日处理能力','原文质量单位；历史200m³/d摘要未删除','WEB_COMPANY','S024-01','2023招股书污染物处理表','2023');
INSERT INTO claims (claim_id,site_id,field,value,evidence_class,source_id,scope,observed_date) VALUES ('CL024-03','CN0255','募投产能','135+161+20=316 t/a成品催化剂','WEB_SECONDARY','S024-04','异地项目，非已投产','2025');
INSERT INTO evidence_notes (note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES ('N024-01','CN0132','S024-01','历史环保费用及证照','1-1-178至180','两证916103017521431781001V（2022-04-18至2027-04-17）及916103017521431781002V（2021-08-26至2026-08-25），厂区对应和续证待核；2020/21/22环保固定资产投入5.31/226.91/1784.85万元、环保相关费用38.05/40.97/74.54万元、折旧26.62/29/53.84万元；污水费另列，不能将总环保费视为水成本。','WEB_COMPANY','正文/公开披露转述；非原件归档','2026-11-27');
INSERT INTO evidence_notes (note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES ('N024-02','CN0132','S024-03','高纯项目批复','一、二（四）（五）（八）','总投资10600万元、环保投资970万元（全环保，非污水专用）；项目不改变热解能力和既批危废类别、精炼规模；废水分质，接管执行GB8978三级及GB/T31962 B级；管道加流量计。','WEB_PRIMARY','正文/公开披露转述；非原件归档','2026-11-27');
INSERT INTO evidence_notes (note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES ('N024-03','CN0132','S024-08','建设进度','正文','2025年12月8栋单体建筑完成建设，报道计划2026年3月投产，不确认实际投运。','WEB_PRIMARY','正文/公开披露转述；非原件归档','2026-11-27');
INSERT INTO evidence_notes (note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES ('N024-04','CN0255','S024-04','募投设施及范围','问询回复设备/面积表','拟建污水处理站建筑面积2160m²非池容、非日处理量；项目地块96692.44m²；催化剂316t/a另有配体15、氢化产品300t/a；纯水制备5台套未披露膜类型，不作为污水膜。','WEB_SECONDARY','正文/公开披露转述；非原件归档','2026-11-27');
INSERT INTO evidence_notes (note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES ('N024-05','CN0255','S024-06','审批','募投审批段','招股书转述宝审服环字〔2023〕12号；节能宝凤行审批字〔2025〕106号。未取环评正文，未确认建设验收。','WEB_SECONDARY','正文/公开披露转述；非原件归档','2026-11-27');
INSERT INTO evidence_notes (note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES ('N024-06','CN0132','S024-04','既有设备','2025-06设备表','废水处理系统1套，账面原值114.22万元，净值83.54万元、成新率73.14%；105台套反应釜对应152t/a常规产能；2022年8月主要生产迁至科技新城，不能把迁前年度成本归新厂。','WEB_SECONDARY','正文/公开披露转述；非原件归档','2026-11-27');
INSERT INTO search_log (log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES ('L024-01','CN0132','W01-B14/W11-B15','陕西瑞科 招股说明书 污水处理 200 吨 日 环保费用','S024-01','取得正式申报书及截图；核对历史单位与年度费用','按两许可及新站验收查水量、实际膜和2025/26费用','2026-11-27');
INSERT INTO search_log (log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES ('L024-02','CN0132','W01-B14/W11-B15','陕西瑞科 2026 贵金属催化剂 产能 2025 吨 宝鸡','S024-02','取得2023/24产能产量、2025设备；2026最新产能未核','2025年报、2026许可及项目验收','2026-11-27');
INSERT INTO search_log (log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES ('L024-03','CN0132','W01-B14/W11-B15','陕西瑞科 科技新城 污水处理站 高纯项目','S024-03','新项目批复及2025建设报道；尚无验收','2026实际投产及站分流','2026-11-27');
INSERT INTO search_log (log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES ('L024-04','CN0255','W01-B14/W11-B15','陕西璟邑科技 贵金属催化剂 新材料 生产基地 环评 废水 宝鸡 凤翔','S024-04','独立异地项目，历史公示和募投口径不同；未获实际站工艺','批复原件/排污许可和验收','2026-11-27');
INSERT INTO search_log (log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES ('L024-05','CN0110','W01-B14/W11-B15','沈阳三聚凯特 2025 年度报告 污水 MBR 2026 海新能科','S024-07','2024年报7项浓度；2025年报仅命中主体经营资料未获工艺','2025年报环境章节、2026执行报告、MBR设备更换','2026-11-27');
INSERT INTO search_log (log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES ('L024-06','CN0195','W01-B14/W11-B15','山东荣创催化新材料 2021 污水 循环利用 整改 42','W01S08','2021政府原页打开超时；2015报告复见不重复','按许可证及后续监测查实际回用','2026-11-27');
INSERT INTO search_log (log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES ('L024-07','CN0162','W01-B14/W11-B15','凯文特 鄄城 催化剂 废水 验收 2026 硫酸铵',NULL,'验收转载索引已入库；无新有效工艺','独立合同履行、验收附件','2026-11-27');
INSERT INTO search_log (log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES ('L024-08','CN0115','W01-B14/W11-B15','山东中科新材料科技有限公司 催化剂 污水处理 2024 2025 排污 监测',NULL,'未获新增该厂近期工艺；沿用2023验收摘录画图','按许可证及实际监测','2026-11-27');
INSERT INTO process_diagrams (diagram_id,site_id,scope_key,stage,period,revision,coverage,mermaid,source_id,boundaries,gaps,updated_on) VALUES ('D024-01','CN0132','production-2023','historical','2023招股披露',1,'partial','flowchart TD
 A["生产/回收洗涤分离及清洗、喷淋"] --> B["分质收集"]
 B --> C["预处理"]
 C --> D["生化处理"]
 D --> E["园区污水厂"]
 D --> F["生化污泥"]
 F --> G["危废贮存及委外"]
 H["生活污水"] --> I["化粪池"]
 I --> E','S024-01','公司披露既有处理能力200t/d；非厂区现行完整图','单元型号、实际流量、出水水质、膜及浓水去向未知；两许可对应待核','2026-11-27');
INSERT INTO process_diagram_evidence (evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES ('DE024-01-1','D024-01','W024-01','S024-01','1-1-179','A,B,C,D,E,F,G','生产水分质预处理生化及生化泥资质处置');
INSERT INTO process_diagram_evidence (evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES ('DE024-01-2','D024-01','W024-02','S024-01','1-1-179','H,I,E','生活水化粪池后纳管');
INSERT INTO membrane_reviews (review_id,site_id,diagram_id,scope_key,stage,period,revision,presence,source_id,evidence_basis,gaps,updated_on) VALUES ('R024-01','CN0132','D024-01','production-2023','historical','2023招股披露',1,'not_identified','S024-01','公司披露既有处理能力200t/d；非厂区现行完整图','单元型号、实际流量、出水水质、膜及浓水去向未知；两许可对应待核','2026-11-27');
INSERT INTO membrane_retrofits (assessment_id,review_id,site_id,scope_key,option_key,revision,objective,proposed_route,feasibility,hard_constraints,evidence_basis,assumptions,missing_inputs,validation_plan,alternatives,feed_risk,pretreatment_risk,concentrate_risk,integration_risk,operational_risk,compliance_economics_risk,score_basis,updated_on) VALUES ('A024-01','R024-01','CN0132','production-2023','screening',1,'分质减量、回用或稳定达标','贵金属先回收，生化出水按需评估UF+RO回用；高盐流股另行取样','conditional','需确认现行设施、浓水合法去向与水质适配','公司披露既有处理能力200t/d；非厂区现行完整图','仅工程候选；不假定已装膜或水量','金属、盐、COD、真实水量、回用需求及浓水接收','分流取样、金属回收衡算、UF/RO小试及全成本测算','保持现有物化生化、源头减水并比较纳管费',NULL,NULL,NULL,NULL,NULL,NULL,'六维资料不足，全部留空；不以未知作为低难度','2026-11-27');
INSERT INTO process_diagrams (diagram_id,site_id,scope_key,stage,period,revision,coverage,mermaid,source_id,boundaries,gaps,updated_on) VALUES ('D024-02','CN0132','high-purity-project','design','2024批复',1,'partial','flowchart TD
 A["吸收塔高浓废水"] --> B["蒸发浓缩脱盐"]
 B --> C["结晶杂盐外运"]
 B --> X["液体后续去向待核"]
 D["工艺废水"] --> E["工艺废水收集池"]
 F["综合废水"] --> G["综合废水收集池"]
 E --> H["pH调整/混凝物化/生化"]
 G --> H
 H --> I["科技新城污水厂"]','S024-03','新高纯项目批复要求；蒸发液与新站具体连接未披露','流量、盐分、蒸发型号及实际建成状态待核','2026-11-27');
INSERT INTO process_diagram_evidence (evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES ('DE024-02-1','D024-02','W024-03','S024-03','二（四）','A,B,C,X','吸收塔高浓废水蒸发脱盐，杂盐外运，液去向未写');
INSERT INTO process_diagram_evidence (evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES ('DE024-02-2','D024-02','W024-04','S024-03','二（四）','D,E,F,G,H,I','两类收集池、物化生化、科技新城接管');
INSERT INTO membrane_reviews (review_id,site_id,diagram_id,scope_key,stage,period,revision,presence,source_id,evidence_basis,gaps,updated_on) VALUES ('R024-02','CN0132','D024-02','high-purity-project','design','2024批复',1,'not_identified','S024-03','新高纯项目批复要求；蒸发液与新站具体连接未披露','流量、盐分、蒸发型号及实际建成状态待核','2026-11-27');
INSERT INTO membrane_retrofits (assessment_id,review_id,site_id,scope_key,option_key,revision,objective,proposed_route,feasibility,hard_constraints,evidence_basis,assumptions,missing_inputs,validation_plan,alternatives,feed_risk,pretreatment_risk,concentrate_risk,integration_risk,operational_risk,compliance_economics_risk,score_basis,updated_on) VALUES ('A024-02','R024-02','CN0132','high-purity-project','screening',1,'分质减量、回用或稳定达标','若蒸发前去金属和有机物且盐种适合，比较NF/ED预浓缩；生化出水回用另评估','conditional','需确认现行设施、浓水合法去向与水质适配','新高纯项目批复要求；蒸发液与新站具体连接未披露','仅工程候选；不假定已装膜或水量','蒸发进水盐种、渗透压、贵金属、COD、冷凝液和杂盐处置费','分流化验、膜相容性、盐物料平衡及蒸汽电耗比较','原设计蒸发脱盐及物化生化',NULL,NULL,NULL,NULL,NULL,NULL,'六维资料不足，全部留空；不以未知作为低难度','2026-11-27');
INSERT INTO process_diagrams (diagram_id,site_id,scope_key,stage,period,revision,coverage,mermaid,source_id,boundaries,gaps,updated_on) VALUES ('D024-03','CN0110','production-historical','historical','2021H1',1,'partial','flowchart TD
 A["高氨氮废水"] --> B["预处理120t/d"]
 C["含重金属/镍废水"] --> D["加药预处理"]
 B --> E["综合站600t/d"]
 D --> E
 E --> F["水解及MBR（披露）"]
 F --> G["污水处理厂"]','turn127831search7','2021半年报历史站能力；不叠加120和600','原文水解表述待核，MBR膜型号及现时运行未知','2026-11-27');
INSERT INTO process_diagram_evidence (evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES ('DE024-03-1','D024-03','W0026','turn127831search7','2021H1污染防治设施','A,B,E','高氨独立预处理能力');
INSERT INTO process_diagram_evidence (evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES ('DE024-03-2','D024-03','W0027','turn127831search7','2021H1污染防治设施','C,D,E,F,G','重金属、含镍加药及MBR历史披露');
INSERT INTO membrane_reviews (review_id,site_id,diagram_id,scope_key,stage,period,revision,presence,source_id,evidence_basis,gaps,updated_on) VALUES ('R024-03','CN0110','D024-03','production-historical','historical','2021H1',1,'confirmed_present','turn127831search7','2021半年报历史站能力；不叠加120和600','原文水解表述待核，MBR膜型号及现时运行未知','2026-11-27');
INSERT INTO membrane_units (unit_id,review_id,unit_label,technology,role,feed,permeate_destination,concentrate_destination,specification,source_id,locator,notes) VALUES ('MU024-03','R024-03','历史综合站MBR','MBR','生化污泥截留','综合站预处理水','污水处理厂',NULL,NULL,'turn127831search7','2021H1污染防治设施','历史披露，非2026确认');
INSERT INTO membrane_retrofits (assessment_id,review_id,site_id,scope_key,option_key,revision,objective,proposed_route,feasibility,hard_constraints,evidence_basis,assumptions,missing_inputs,validation_plan,alternatives,feed_risk,pretreatment_risk,concentrate_risk,integration_risk,operational_risk,compliance_economics_risk,score_basis,updated_on) VALUES ('A024-03','R024-03','CN0110','production-historical','screening',1,'分质减量、回用或稳定达标','先复核现有MBR运行，优化除镍与高氨预处理；若有回用需求再比RO深度脱盐','conditional','需确认现行设施、浓水合法去向与水质适配','2021半年报历史站能力；不叠加120和600','仅工程候选；不假定已装膜或水量','MBR通量、污染、氨及重金属浓度、盐和浓水去向','运行趋势、预处理烧杯及膜CIP/截留测试；以实际成本比较','保留既有MBR，优化药耗及生化负荷',NULL,NULL,NULL,NULL,NULL,NULL,'六维资料不足，全部留空；不以未知作为低难度','2026-11-27');
INSERT INTO process_diagrams (diagram_id,site_id,scope_key,stage,period,revision,coverage,mermaid,source_id,boundaries,gaps,updated_on) VALUES ('D024-04','CN0115','production-acceptance','historical','2023验收',1,'partial','flowchart TD
 A["高浓工艺水"] --> B["脱轻塔气提"]
 B --> C["气相循环水及低温盐水冷凝"]
 C --> D["冷凝废液委外"]
 B --> E["塔底水"]
 F["低浓清洗/喷淋/冷却/生活水"] --> G["格栅及调节"]
 E --> G
 G --> H["水解酸化"]
 H --> I["一级A/O"]
 I --> J["二级A/O"]
 J --> K["二沉"]
 K --> L["絮凝沉淀/活性炭过滤"]
 L --> M["产水池/排放"]
 K --> N["污泥浓缩脱水"]
 N --> O["污泥外运"]
 N --> G','turn106948search90','2023验收摘录，气提支路及综合站；不作2026运行确认','实际流量、出水指标、排放受纳方及膜未核','2026-11-27');
INSERT INTO process_diagram_evidence (evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES ('DE024-04-1','D024-04','W0001','turn106948search90','表4.1-2、图4-1旧摘录','A,B,C,D,E,G','气提、冷凝委外、塔底入站');
INSERT INTO process_diagram_evidence (evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES ('DE024-04-2','D024-04','W0002','turn106948search90','图4-2旧摘录','F,G,H,I,J,K,L,M,N,O','综合站序列、污泥及滤液回流');
INSERT INTO membrane_reviews (review_id,site_id,diagram_id,scope_key,stage,period,revision,presence,source_id,evidence_basis,gaps,updated_on) VALUES ('R024-04','CN0115','D024-04','production-acceptance','historical','2023验收',1,'not_identified','turn106948search90','2023验收摘录，气提支路及综合站；不作2026运行确认','实际流量、出水指标、排放受纳方及膜未核','2026-11-27');
INSERT INTO membrane_retrofits (assessment_id,review_id,site_id,scope_key,option_key,revision,objective,proposed_route,feasibility,hard_constraints,evidence_basis,assumptions,missing_inputs,validation_plan,alternatives,feed_risk,pretreatment_risk,concentrate_risk,integration_risk,operational_risk,compliance_economics_risk,score_basis,updated_on) VALUES ('A024-04','R024-04','CN0115','production-acceptance','screening',1,'分质减量、回用或稳定达标','在生化/炭滤出水端按回用需求试验UF+RO；高浓液保留气提而非直接膜','conditional','需确认现行设施、浓水合法去向与水质适配','2023验收摘录，气提支路及综合站；不作2026运行确认','仅工程候选；不假定已装膜或水量','胺类、COD、盐、温度、氨、实际水量和回用目标','分流分析、膜污染与产水试验、浓水合规和能药成本','保持脱轻及生化，优化气提和分质',NULL,NULL,NULL,NULL,NULL,NULL,'六维资料不足，全部留空；不以未知作为低难度','2026-11-27');
INSERT INTO process_diagrams (diagram_id,site_id,scope_key,stage,period,revision,coverage,mermaid,source_id,boundaries,gaps,updated_on) VALUES ('D024-05','CN0195','production-2015','design','2015环评',1,'partial','flowchart TD
 A["项目外送水100.2t/d（设计）"] --> B["既有站500t/d（设计）"]
 B --> C["调节/电解/沉淀"]
 C --> D["水解酸化/UASB"]
 D --> E["接触氧化/A/O"]
 E --> F["淄博凯丹水务"]','W01S07','2015环评摘录；2021整改另存W0101，未与本图拼接','2021改造原文复开超时；膜洗涤是产品环节不能当污水膜；实际站及流量待核','2026-11-27');
INSERT INTO process_diagram_evidence (evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES ('DE024-05-1','D024-05','W0099','W01S07','2015环评旧摘要','B,C,D,E,F','设施能力及处理序列');
INSERT INTO process_diagram_evidence (evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES ('DE024-05-2','D024-05','W0100','W01S07','5.1.2','A,B,F','项目废水及既有站接管');
INSERT INTO membrane_reviews (review_id,site_id,diagram_id,scope_key,stage,period,revision,presence,source_id,evidence_basis,gaps,updated_on) VALUES ('R024-05','CN0195','D024-05','production-2015','design','2015环评',1,'not_identified','W01S07','2015环评摘录；2021整改另存W0101，未与本图拼接','2021改造原文复开超时；膜洗涤是产品环节不能当污水膜；实际站及流量待核','2026-11-27');
INSERT INTO membrane_retrofits (assessment_id,review_id,site_id,scope_key,option_key,revision,objective,proposed_route,feasibility,hard_constraints,evidence_basis,assumptions,missing_inputs,validation_plan,alternatives,feed_risk,pretreatment_risk,concentrate_risk,integration_risk,operational_risk,compliance_economics_risk,score_basis,updated_on) VALUES ('A024-05','R024-05','CN0195','production-2015','screening',1,'分质减量、回用或稳定达标','先确认2021后酸碱分流是否建成；若仍有低盐出水，再筛UF/RO，酸碱流股单独评价','conditional','需确认现行设施、浓水合法去向与水质适配','2015环评摘录；2021整改另存W0101，未与本图拼接','仅工程候选；不假定已装膜或水量','现行站、盐/酸碱组分、回用水量、浓水处置','核2021整改和现行许可，分流取样、回用与膜中试','源头酸碱分质及既有站提标',NULL,NULL,NULL,NULL,NULL,NULL,'六维资料不足，全部留空；不以未知作为低难度','2026-11-27');
INSERT INTO process_diagrams (diagram_id,site_id,scope_key,stage,period,revision,coverage,mermaid,source_id,boundaries,gaps,updated_on) VALUES ('D024-06','CN0156','production-design','design','历史技改设计',1,'partial','flowchart TD
 A["清洗水190.29m³/a（设计）"] --> C["PAC/PAM混凝絮凝"]
 B["喷淋水90m³/a（设计）"] --> C
 C --> D["沉淀过滤，设施1m³/d"]
 D --> E["分类回用"]','turn259897view0','原历史摘录；设施与年水量不同口径；无反应废水不等于全厂无水','未取得本轮原报告；普通过滤不识别为膜，回用点待核','2026-11-27');
INSERT INTO process_diagram_evidence (evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES ('DE024-06-1','D024-06','W0076','turn259897view0','历史摘录','A,B,C,D,E','清洗/喷淋、混凝和回用');
INSERT INTO process_diagram_evidence (evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES ('DE024-06-2','D024-06','W0083','turn259897view0','历史设计','C,D','1m³/d设施');
INSERT INTO membrane_reviews (review_id,site_id,diagram_id,scope_key,stage,period,revision,presence,source_id,evidence_basis,gaps,updated_on) VALUES ('R024-06','CN0156','D024-06','production-design','design','历史技改设计',1,'not_identified','turn259897view0','原历史摘录；设施与年水量不同口径；无反应废水不等于全厂无水','未取得本轮原报告；普通过滤不识别为膜，回用点待核','2026-11-27');
INSERT INTO membrane_retrofits (assessment_id,review_id,site_id,scope_key,option_key,revision,objective,proposed_route,feasibility,hard_constraints,evidence_basis,assumptions,missing_inputs,validation_plan,alternatives,feed_risk,pretreatment_risk,concentrate_risk,integration_risk,operational_risk,compliance_economics_risk,score_basis,updated_on) VALUES ('A024-06','R024-06','CN0156','production-design','screening',1,'分质减量、回用或稳定达标','低量水优先保留物化回用，必要时小型UF去胶体；仅当回用目标要求脱盐才考虑RO','conditional','需确认现行设施、浓水合法去向与水质适配','原历史摘录；设施与年水量不同口径；无反应废水不等于全厂无水','仅工程候选；不假定已装膜或水量','现行水量、SS、盐分及水质目标','取样及滤后水小试、运行费和维护比较','现有混凝过滤及分质回用',NULL,NULL,NULL,NULL,NULL,NULL,'六维资料不足，全部留空；不以未知作为低难度','2026-11-27');
INSERT INTO process_diagrams (diagram_id,site_id,scope_key,stage,period,revision,coverage,mermaid,source_id,boundaries,gaps,updated_on) VALUES ('D024-07','CN0130','reaction-water','historical','历史摘录',1,'partial','flowchart TD
 A["反应废水"] --> B["蒸发浓缩"]
 B --> C["冷凝水回用"]
 B --> D["残渣危废"]','turn640106search4','历史摘录、非全厂现行图','蒸发装置型式、实际废水量、膜、盐和危废成本未核','2026-11-27');
INSERT INTO process_diagram_evidence (evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES ('DE024-07-1','D024-07','W0068','turn640106search4','历史摘录','A,B,C,D','反应废水蒸发及冷凝回用、残渣危废');
INSERT INTO membrane_reviews (review_id,site_id,diagram_id,scope_key,stage,period,revision,presence,source_id,evidence_basis,gaps,updated_on) VALUES ('R024-07','CN0130','D024-07','reaction-water','historical','历史摘录',1,'not_identified','turn640106search4','历史摘录、非全厂现行图','蒸发装置型式、实际废水量、膜、盐和危废成本未核','2026-11-27');
INSERT INTO membrane_retrofits (assessment_id,review_id,site_id,scope_key,option_key,revision,objective,proposed_route,feasibility,hard_constraints,evidence_basis,assumptions,missing_inputs,validation_plan,alternatives,feed_risk,pretreatment_risk,concentrate_risk,integration_risk,operational_risk,compliance_economics_risk,score_basis,updated_on) VALUES ('A024-07','R024-07','CN0130','reaction-water','screening',1,'分质减量、回用或稳定达标','先核贵金属与溶剂；若进料相容且有蒸发节能价值，比较NF/ED或RO预浓缩，保留蒸发','conditional','需确认现行设施、浓水合法去向与水质适配','历史摘录、非全厂现行图','仅工程候选；不假定已装膜或水量','金属、盐、溶剂、渗透压及蒸发运行费用','贵金属回收衡算、膜相容性、连续浓缩和危废成本对比','现有蒸发回用及源头回收',NULL,NULL,NULL,NULL,NULL,NULL,'六维资料不足，全部留空；不以未知作为低难度','2026-11-27');
UPDATE sites SET capacity_summary='2024常规产能非均相132t/a、均相20t/a；产量110723.73kg及24281.04kg；新高纯150t/a为贵金属渣精炼非新剂',water_summary='2023披露废水能力200t/d，分质预处理+生化；2024新高纯项目蒸发脱盐、pH调整混凝生化另列设计；历史200m³/d单位待核',source_status='招股及政府批复补证' WHERE site_id='CN0132';
UPDATE tasks SET missing='现行两许可对应、2026新站验收、实际分流量/水质、膜和吨水成本',next_query='按916103017521431781001V及002V续证、2026高纯项目验收及费用',state='部分完成' WHERE site_id='CN0132';
UPDATE sites SET water_summary=water_summary||'；2024年报总排口7项浓度已补，未证明现时MBR运行' WHERE site_id='CN0110';
UPDATE tasks SET missing='2025/26实际产能、MBR型号/运行与流量和成本',next_query='2025年报环境章及2026许可执行、MBR运维采购',state='部分完成' WHERE site_id='CN0110';
CREATE TEMP TABLE assert024 (ok INTEGER CHECK(ok=1));
INSERT INTO assert024 SELECT count(*)=0 FROM pragma_foreign_key_check;
INSERT INTO assert024 SELECT count(*)=0 FROM process_diagram_evidence e JOIN process_diagrams d USING(diagram_id) JOIN wastewater w USING(water_id) WHERE e.evidence_id LIKE 'DE024-%' AND d.site_id<>w.site_id;
INSERT INTO assert024 SELECT count(*)=0 FROM process_diagrams d WHERE d.diagram_id LIKE 'D024-%' AND NOT EXISTS(SELECT 1 FROM site_sources s WHERE s.site_id=d.site_id AND s.source_id=d.source_id);
DROP TABLE assert024;
COMMIT;
