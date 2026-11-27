BEGIN;
-- 028: supplemental evidence; stage corrections and scope exclusion without deleting history.
INSERT INTO sources (source_id,title,url,source_type,document_date,scope,access_date) VALUES ('S028-01','中石化金陵日化科技（南京）有限公司配套项目环评（现有项目一般变动回顾）','https://njna.nanjing.gov.cn/njsjbxqglwyh/202506/P020250616645594977427.pdf','政府公开环评','2025-06','第66–67页，2025年5月16日一般变动评审及取消催化剂装置','2026-11-27');
INSERT INTO site_sources (site_id,source_id) VALUES ('CN0198','S028-01');
INSERT INTO sources (source_id,title,url,source_type,document_date,scope,access_date) VALUES ('S028-02','江西申生永修有机硅及配套特种催化剂项目备案信息转载','https://m.cbi360.net/dinggc/njxm/spxm_798123053191237.html','项目备案转载','2026-09-17（转载）','项目2604-360425-04-01-331171；分项及备案，非投运','2026-11-27');
INSERT INTO site_sources (site_id,source_id) VALUES ('CN0118','S028-02');
INSERT INTO sources (source_id,title,url,source_type,document_date,scope,access_date) VALUES ('S028-03','2026年6月10日南京江北新区环评受理公示','https://njna.nanjing.gov.cn/njsjbxqglwyh/202606/t20260610_5855567.html','政府环评受理','2026-06-10','第1项，总投资及报告书链接','2026-11-27');
INSERT INTO site_sources (site_id,source_id) VALUES ('CN0093','S028-03');
INSERT INTO sources (source_id,title,url,source_type,document_date,scope,access_date) VALUES ('S028-04','四川明宏嘉成3000t PDH项目首次环评转载（项目平台）','https://www.china0001.com.cn/jianxun/ZCPRO381487063.html','首次公示转载','2026-11-19','厂房面积及工艺设备线索；已有3000t/a不重复','2026-11-27');
INSERT INTO site_sources (site_id,source_id) VALUES ('CN0218','S028-04');
INSERT INTO evidence_notes (note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES ('N028-01','CN0198','S028-01','关键范围变化','第66–67页；第3-4表前正文','报告回顾原2023批复，建设主体调整为金陵日化；2025年5月16日一般变动评审结论非重大变动，变动方案取消催化剂装置。原200t/a自用催化剂设计及共享水站UF/RO仅保留历史方案，不能作为现行催化剂制造/膜机会。截图404。','WEB_PRIMARY','公开文本摘录，非原件归档','2026-11-27');
INSERT INTO projects (project_id,site_id,project,status,date,capacity_note,water_change,source_id) VALUES ('P028-01','CN0198','高端日化项目一般变动','取消催化剂装置（2025一般变动回顾）','2025-05-16','原200t/a自制催化剂不再纳入变动方案','共享水系统历史设计不能归为当前催化剂生产废水','S028-01');
INSERT INTO task_triage (site_id,disposition,reason,reopen_trigger,reviewed_on) VALUES ('CN0198','scope_hold','2025公开环评明确取消原自制催化剂装置；保留历史设计，不计现有催化剂制造机会','出现新的独立催化剂制造建设审批/许可后复开','2026-11-27');
UPDATE sites SET status='2025一般变动取消催化剂装置',capacity_summary='2023原200t/a设计；2025变动方案取消，非在产',water_summary='历史共享UF/RO等设计仅属原日化方案；取消催化剂装置后不得作为现行催化剂废水证据' WHERE site_id='CN0198';
INSERT INTO capacity (capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES ('C028-01','CN0118','催化剂原料',3700,'t/a','备案转载设计','2026','项目分项','S028-02','原料及表面处理剂不得计成品催化剂；不视为已投产');
INSERT INTO capacity (capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES ('C028-02','CN0118','有机硅杂化不饱和催化剂',1000,'t/a','备案转载设计','2026','项目分项','S028-02','原料及表面处理剂不得计成品催化剂；不视为已投产');
INSERT INTO capacity (capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES ('C028-03','CN0118','丙烯腈催化剂',1000,'t/a','备案转载设计','2026','项目分项','S028-02','原料及表面处理剂不得计成品催化剂；不视为已投产');
INSERT INTO capacity (capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES ('C028-04','CN0118','加氢催化剂',1200,'t/a','备案转载设计','2026','项目分项','S028-02','原料及表面处理剂不得计成品催化剂；不视为已投产');
INSERT INTO capacity (capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES ('C028-05','CN0118','环氧乙烷催化剂',300,'t/a','备案转载设计','2026','项目分项','S028-02','原料及表面处理剂不得计成品催化剂；不视为已投产');
INSERT INTO capacity (capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES ('C028-06','CN0118','废气处理催化剂',200,'t/a','备案转载设计','2026','项目分项','S028-02','原料及表面处理剂不得计成品催化剂；不视为已投产');
INSERT INTO capacity (capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES ('C028-07','CN0118','金属表面处理剂',2000,'t/a','备案转载设计','2026','项目分项','S028-02','原料及表面处理剂不得计成品催化剂；不视为已投产');
INSERT INTO projects (project_id,site_id,project,status,date,capacity_note,water_change,source_id) VALUES ('P028-02','CN0118','4万吨有机硅及配套9400吨混合产品项目','备案转载','2026-09-17','成品催化剂明确分项合计3700t/a；另原料3700及表面处理剂2000','无废水设计原文','S028-02');
INSERT INTO evidence_notes (note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES ('N028-02','CN0118','S028-02','混合产能拆分','项目概况','项目代码2604-360425-04-01-331171，投资30000万元（总项目）；9400吨包括3700原料、3700五类成品催化剂、2000金属表面处理剂。计划2027年12月竣工非实际。','WEB_SECONDARY','公开文本摘录，非原件归档','2026-11-27');
UPDATE sites SET capacity_summary='备案转载9400t/a混合项目：成品催化剂3700t/a、原料3700、表面处理剂2000；非在产',status='2026备案转载，待环评及建设',source_status='项目备案转载待原件核实' WHERE site_id='CN0118';
INSERT INTO evidence_notes (note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES ('N028-03','CN0093','S028-03','项目投资及受理','第1项','铜系600t/a技改受理，总项目投资5799.77万元；不等于水处理投资；报告书附件约27.8MB工具无法读取，既有拟批工艺不重复。','WEB_PRIMARY','公开文本摘录，非原件归档','2026-11-27');
INSERT INTO evidence_notes (note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES ('N028-04','CN0218','S028-04','生产设备及厂房','主要建设内容','30亩，厂房5000平方米，附属用房1000平方米，配料罐、辊道窑、振动筛等；3000t/a项目首次公示已入库，无废水路线；项目平台日期与计划不是开工证明。','WEB_SECONDARY','公开文本摘录，非原件归档','2026-11-27');
INSERT INTO wastewater (water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES ('W028-01','CN0010','铵交换废水','2026环评在建/待建未验',1.5,'t/h','吹脱装置设计规模','氨氮','石灰调pH约10.5–11→沉淀排泥→蒸汽吹脱→硫酸吸收氨','吹脱出水调pH6–9进生化；硫酸铵液回用','沉淀泥','W03S01','WEB_PRIMARY','3.1.4.3.1；区别于已建已验分质图；S Zorb非催化剂成品');
INSERT INTO wastewater (water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES ('W028-02','CN0010','有机胶、草酸、吹脱出水及适应性改造清洗水等','2026环评在建/待建未验',NULL,NULL,NULL,'有机物、氨氮','生化调节→两级A/O→二沉→末端混凝沉淀','厂区污水出水池→博瑞德',NULL,'W03S01','WEB_PRIMARY','3.1.4.3.1；区别于已建已验分质图；S Zorb非催化剂成品');
INSERT INTO wastewater (water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES ('W028-03','CN0010','车间地洗、化验室、初期雨水','2026环评在建/待建未验',NULL,NULL,NULL,'磷','调节→投除磷剂/混凝絮凝→泥浓缩→板框压滤；滤液再沉淀','清液与合格公用排水混合接管','泥饼危废外送','W03S01','WEB_PRIMARY','3.1.4.3.1；区别于已建已验分质图；S Zorb非催化剂成品');
INSERT INTO wastewater (water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES ('W028-04','CN0010','S Zorb 1500t/a吸附剂装置冲洗及罐区相关初雨','2026环评在建/待建未验',NULL,NULL,NULL,NULL,'集水后回用尾气治理','不外排','最终危废委外','W03S01','WEB_PRIMARY','3.1.4.3.1；区别于已建已验分质图；S Zorb非催化剂成品');
INSERT INTO water_metrics (metric_id,site_id,water_id,point,metric,value_num,value_text,unit,result_kind,statistic,period,detection_limit,standard_max,source_id,notes) VALUES ('M028-01','CN0010','W028-01','氨吹脱装置','设计处理能力',1.5,NULL,'t/h','设计工况','原文工艺描述','2026环评在建/待建未验',NULL,NULL,'W03S01','非实际运行监测');
INSERT INTO water_metrics (metric_id,site_id,water_id,point,metric,value_num,value_text,unit,result_kind,statistic,period,detection_limit,standard_max,source_id,notes) VALUES ('M028-02','CN0010','W028-01','石灰调节池','pH',NULL,'10.5–11','无量纲','设计工况','原文工艺描述','2026环评在建/待建未验',NULL,NULL,'W03S01','非实际运行监测');
INSERT INTO water_metrics (metric_id,site_id,water_id,point,metric,value_num,value_text,unit,result_kind,statistic,period,detection_limit,standard_max,source_id,notes) VALUES ('M028-03','CN0010','W028-01','吹脱出水入生化前','pH',NULL,'6–9','无量纲','设计工况','原文工艺描述','2026环评在建/待建未验',NULL,NULL,'W03S01','非实际运行监测');
INSERT INTO process_diagrams (diagram_id,site_id,scope_key,stage,period,revision,coverage,mermaid,source_id,boundaries,gaps,updated_on) VALUES ('D028-01','CN0010','adaptation_unaccepted_2026','design','2026环评在建/待建未验',1,'partial','flowchart TD
A["铵交换水"] --> B["石灰调pH、沉淀"]
B --> C["蒸汽吹脱1.5t/h设计"]
C --> D["调pH6–9"]
C --> E["硫酸吸收"]
E --> F["硫酸铵液回用"]
D --> G["生化调节"]
H["有机胶、草酸、清洗等"] --> G
G --> I["两级A/O、二沉"]
I --> J["末端混凝沉淀"]
J --> K["总排水池"]
L["地洗、实验室、初雨"] --> M["除磷沉淀、污泥浓缩、板框压滤"]
M --> K
M --> N["泥饼危废委外"]
K --> O["博瑞德污水厂"]
P["S Zorb吸附剂相关冲洗及初雨"] --> Q["回用尾气治理，最终危废委外"]','W03S01','适应性改造/未验工程及吸附剂支路；非原有已验厂区图','实测各股流量、含盐/氨氮浓度、吹脱效率及实际投运待核','2026-11-27');
INSERT INTO process_diagram_evidence (evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES ('DE028-01-1','D028-01','W028-01','W03S01','3.1.4.3.1（报告第106–108页）','A,B,C,D,E,F','氨吹脱及硫酸铵回用');
INSERT INTO process_diagram_evidence (evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES ('DE028-01-2','D028-01','W028-02','W03S01','3.1.4.3.1（报告第106–108页）','G,H,I,J,K,O','生化及纳管');
INSERT INTO process_diagram_evidence (evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES ('DE028-01-3','D028-01','W028-03','W03S01','3.1.4.3.1（报告第106–108页）','L,M,K,N','除磷及泥饼');
INSERT INTO process_diagram_evidence (evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES ('DE028-01-4','D028-01','W028-04','W03S01','3.1.4.3.1（报告第106–108页）','P,Q','吸附剂回用/委外');
INSERT INTO membrane_reviews (review_id,site_id,diagram_id,scope_key,stage,period,revision,presence,source_id,evidence_basis,gaps,updated_on) VALUES ('MR028-01','CN0010','D028-01','adaptation_unaccepted_2026','design','2026环评在建/待建未验',1,'not_identified','W03S01','该阶段正文采用吹脱、两级A/O及沉淀；未见污水膜明确单元，不能判现行未用膜；园区规划膜不归厂','验收、设备清单、实际水质/水量','2026-11-27');
INSERT INTO membrane_retrofits (assessment_id,review_id,site_id,scope_key,option_key,revision,objective,proposed_route,feasibility,hard_constraints,evidence_basis,assumptions,missing_inputs,validation_plan,alternatives,feed_risk,pretreatment_risk,concentrate_risk,integration_risk,operational_risk,compliance_economics_risk,score_basis,updated_on) VALUES ('RA028-01','MR028-01','CN0010','adaptation_unaccepted_2026','screening',1,'降低含氮排放及增加可回用水','先稳定氨回收和生化，再以实测低盐生化出水筛选UF/RO；高盐水单独核浓缩回用，不直接混流','conditional','浓水去向、硫酸铵回用品质、草酸及硬度、园区接管均须验证','INFERRED；W03S01第3.1.4.3.1','仅在未验工程完成且实际存在回用需求时','分质实测、离子/硬度、盐负荷、回用量、成本','验收核查、除硬与膜通量小试、浓水物料衡算和实际电药耗比选','优化吹脱回收、A/O及源头回用',NULL,NULL,NULL,NULL,NULL,NULL,'六维缺实测；不判低难度','2026-11-27');
INSERT INTO evidence_notes (note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES ('N028-05','CN0010','W03S01','新增未验工程分流（非重复既有）','3.1.4.3.1，第106–108页','已有记录只覆盖已验和VOCs设计；本次补适应性改造吹脱1.5t/h设计、硫酸铵回用及两级A/O，S Zorb吸附剂支路单列。PDF截图因文件大小失败，文本可读；监测表抽取空白不猜。','WEB_PRIMARY','公开文本摘录，非原件归档','2026-11-27');
INSERT INTO search_log (log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES ('L028-01','CN0010','W01-B18/W11-B19','南京催化剂VOCs报告3.1.4.3.1在建未验项目吹脱','W03S01','新增未验工程分质及吹脱设计能力；既有流程不重复','查2026验收及实量','2026-11-27');
INSERT INTO search_log (log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES ('L028-02','CN0198','W01-B18/W11-B19','金陵日化一般变动取消催化剂装置','S028-01','2025取消设计明确，转范围暂缓，历史证据保留','新催化剂审批触发复开','2026-11-27');
INSERT INTO search_log (log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES ('L028-03','CN0118','W01-B18/W11-B19','江西申生永修9400吨项目备案分项','S028-02','取得备案转载明细及项目代码，未取得废水','按项目代码找环评','2026-11-27');
INSERT INTO search_log (log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES ('L028-04','CN0093','W01-B18/W11-B19','南京化工研究院600吨铜催化剂2026环评受理及全文','S028-03','既有拟批重复，受理新增总投资；正文附件过大','分段公开报告/验收','2026-11-27');
INSERT INTO search_log (log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES ('L028-05','CN0218','W01-B18/W11-B19','四川明宏嘉成3000t PDH首次公示新来源','S028-04','新来源补厂房和设备，旧规模不重复，未获水工艺','后续征求意见稿','2026-11-27');
CREATE TEMP TABLE assert028(ok INTEGER CHECK(ok=1));
INSERT INTO assert028 SELECT count(*)=0 FROM pragma_foreign_key_check;
INSERT INTO assert028 SELECT count(*)=(SELECT count(*) FROM sites) FROM v_research_evidence_gaps;
DROP TABLE assert028;
COMMIT;
