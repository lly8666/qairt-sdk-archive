PRAGMA foreign_keys=ON;
BEGIN;
INSERT INTO sources(source_id,title,url,source_type,document_date,scope,access_date) VALUES
('S085-01','华润电力（常熟）废催化剂跨省转移申请材料','https://www.changshu.gov.cn/zgcs/c100404/202601/30f39cab9e7c400ab204ca8b7ecbb5ba/files/9dccc809cac04f67afdd6498b897c55e.pdf','WEB_PRIMARY','2026-01','政府公开企业申请材料第三、四部分；2025接收联单汇总及工艺；p12截图核资源化段','2026-11-28'),
('S085-02','芜湖市2025年7月备案工程一览表','https://zjw.wuhu.gov.cn/openness/public/6596411/40185856.html','WEB_PRIMARY','2025-07','3#污水站及配套厂房工程备案；面积非处理能力','2026-11-28'),
('S085-03','泰州姜堰政府公开危废跨省转移材料','https://www.jiangyan.gov.cn/cms_files/filemanager/1574877257/attach/20237/0fbce287f12d46e6bd46de4feb116e07.pdf','WEB_PRIMARY','2023-07','第三、四部分，p9截图核历史许可证；2022接收HW46滤渣，非HW50','2026-11-28'),
('S085-04','浙江历史危废许可证列表','https://zjjcmspublic.oss-cn-hangzhou-zwynet-d01-a.internet.cloud.zj.gov.cn/jcms_files/jcms1/web1756/site/attach/-1/2208251759110937931.pdf','WEB_PRIMARY','2022-08','索引第17行宁波双能HW50单列13700t；正文复开未定位原行','2026-11-28'),
('S085-05','大唐南京及江苏装备陕西地区2027–2028年废旧蜂窝式催化剂再生及回收年度采购计划公示转载','https://www.arrbid.com/biddetail/2026-0CD53A76CE5042B09181CA714B6439FE.html','WEB_SECONDARY','2026-11-27','搜索摘要；正文复开禁用，联合采购规模不可按两厂分别累计','2026-11-28');
INSERT INTO sites(site_id,name,province,city,address,category,status,record_type,capacity_summary,water_summary,water_level,priority,permit_id,source_status,as_of,notes) VALUES
('CN0349','宁波双能环保科技有限公司','浙江','宁波','鄞州区经济开发区咸开路208号（2022历史注册地址）','废催化剂火湿法综合利用','历史许可至2026-03-09，续证及现状待核','纯回收','2022许可索引HW50 13700t/a；2023材料综合180000t/a，版本及边界差异待核','历史湿法浸取、结晶、尾水处理，具体单元及去向未知','有工艺线索','P1','3302000053','部分复核','2026-11-28','非全部综合许可量均催化剂；2022实际接收含镍滤渣非HW50实际量；未证当前运行');
INSERT INTO site_sources(site_id,source_id) VALUES
('CN0122','S085-01'),
('CN0122','S085-02'),
('CN0349','S085-03'),
('CN0349','S085-04'),
('CN0063','S085-05'),
('CN0163','S085-05');
INSERT INTO capacity(capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES
('C085-01','CN0122','废钒钛系SCR 772-007-50',50000,'t/a','转移申请材料载许可','2025-05-28至2029-02-25','许可收集贮存利用','S085-01','非实际产量；许可编号340207001'),
('C085-02','CN0122','华润电力常熟废SCR',366.8,'t','实际接收批次汇总','2025-05及2025-10','单一客户14批','S085-01','报告第四部分合计；非全年总吞吐或生产量'),
('C085-03','CN0349','HW50废催化剂',13700,'t/a','历史官方名录搜索摘要','2022-08','许可分项','S085-04','原行复开未定位；不能当现行许可或与综合量相加'),
('C085-04','CN0349','多类危险废物',180000,'t/a','转移材料历史综合许可','2023材料，至2026-03-09','综合类别','S085-03','2022名录另列66300非HW50及13700 HW50，共80000，版本/范围差异待核；不可视180000为催化剂'),
('C085-05','CN0349','含镍废渣处理滤渣 HW46 900-037-46',108.2978,'t','实际接收记录','2022-07','单一客户4批','S085-03','不是HW50或催化剂实际经营量');
INSERT INTO projects(project_id,site_id,project,status,date,capacity_note,water_change,source_id) VALUES
('P085-01','CN0122','5万吨/年SCR脱硝催化剂循环再利用项目','2025-07-30工程备案表','2025-07-30','5万吨项目名称，与许可规模不叠加','3#污水处理站建筑面积608.64m²，非水量；无验收证明','S085-02'),
('P085-02','CN0063','南京环保及江苏装备陕西2027–2028废旧蜂窝SCR再生回收联合采购','计划及文件公示转载摘要','2026-11-27','两年预计3000m³，联合口径，不当产能','服务采购，非污水设备，生产分配待核','S085-05');
INSERT INTO wastewater(water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES
('W085-01','CN0122','模块预清洗、湿法清洗','2026转移材料历史工艺',NULL,NULL,'分股','含尘废水','1#预洗、2#3#湿法清洗','末端待核',NULL,'S085-01','WEB_PRIMARY','图示含尘水产生环节，非末端工艺'),
('W085-02','CN0122','模块化学清洗及酸清洗','2026转移材料历史工艺',NULL,NULL,'分股','清洗液、污染物','4#化学清洗、5#酸清洗','末端待核',NULL,'S085-01','WEB_PRIMARY','不推断处理单元'),
('W085-03','CN0122','活性负载设备清洗水','2026转移材料历史工艺',NULL,NULL,'分股',NULL,'7#负载工序','末端待核',NULL,'S085-01','WEB_PRIMARY','非负载液全量'),
('W085-04','CN0122','资源化初始酸洗母液','2026转移材料历史工艺',NULL,NULL,'生产母液',NULL,'检测后作为再生酸洗液','再生工序条件性回用',NULL,'S085-01','WEB_PRIMARY','工艺物料回用，非末端废水处理或膜'),
('W085-05','CN0122','资源化初始碱洗母液','2026转移材料历史工艺',NULL,NULL,'生产母液',NULL,'蒸发结晶、离心','粗制钨化合物，离心母液返配液水槽',NULL,'S085-01','WEB_PRIMARY','原图隔膜压滤是固液分离设备，非UF/RO'),
('W085-06','CN0349','废催化剂湿法工段尾水','2023转移材料历史描述',NULL,NULL,'流程描述',NULL,'浸取、结晶后尾水处理；单元未知','未知',NULL,'S085-03','WEB_PRIMARY','按不同金属采用不同浸取结晶工艺但共享湿法装置；非运行实测');
INSERT INTO process_diagrams(diagram_id,site_id,scope_key,stage,period,revision,coverage,mermaid,source_id,boundaries,gaps,updated_on) VALUES
('D085-01','CN0122','scr_transfer_2025','historical','2026公开材料回顾2025',1,'partial','flowchart TD
 A[预洗及湿法清洗] --> B[含尘废水 末端待核]
 C[化学及酸洗] --> D[清洗废水 末端待核]
 E[负载设备] --> F[清洗水 末端待核]
 G[资源化初始酸洗母液] --> H[检测] --> I[条件性回再生酸洗]
 J[资源化初始碱洗母液] --> K[蒸发结晶] --> L[离心]
 L --> M[粗制钨化合物]
 L --> N[母液返配液水槽]','S085-01','转移材料第三部分再生及资源化支路；末端水站独立未核','分流量、末端站实际设备、膜、排放及成本未知','2026-11-28'),
('D085-02','CN0349','recovery_historical','historical','2023公开材料',1,'partial','flowchart TD
 A[废催化剂焙烧后进入湿法] --> B[浸取]
 B --> C[结晶]
 C --> D[尾水处理 单元及去向待核]','S085-03','历史转移材料文字；仅湿法尾水主线，非铬渣工艺','现行尾水处理单元、膜、流量及水质未知','2026-11-28');
INSERT INTO process_diagram_evidence(evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES
('DE085-01','D085-01','W085-01','S085-01','第三部分再生工艺图','A,B','含尘废水'),
('DE085-02','D085-01','W085-02','S085-01','第三部分再生工艺图','C,D','化学酸洗水'),
('DE085-03','D085-01','W085-03','S085-01','第三部分再生工艺图','E,F','设备清洗水'),
('DE085-04','D085-01','W085-04','S085-01','第三部分资源化段，p12截图','G,H,I','初始酸洗母液检测回用'),
('DE085-05','D085-01','W085-05','S085-01','第三部分资源化段，p12截图','J,K,L,M,N','碱洗母液蒸发结晶及返回'),
('DE085-06','D085-02','W085-06','S085-03','第三部分表2文字','A,B,C,D','火湿法分段与尾水处理');
INSERT INTO membrane_reviews(review_id,site_id,diagram_id,scope_key,stage,period,revision,presence,source_id,evidence_basis,gaps,updated_on) VALUES
('MR085-01','CN0122','D085-01','scr_transfer_2025','historical','2026公开材料回顾2025',1,'not_identified','S085-01','材料未明确工业污水膜；隔膜压滤不是膜分离技术','分流量、末端站实际设备、膜、排放及成本未知','2026-11-28'),
('MR085-02','CN0349','D085-02','recovery_historical','historical','2023公开材料',1,'not_identified','S085-03','材料未明确工业污水膜；隔膜压滤不是膜分离技术','现行尾水处理单元、膜、流量及水质未知','2026-11-28');
INSERT INTO membrane_retrofits(assessment_id,review_id,site_id,scope_key,option_key,revision,objective,proposed_route,feasibility,hard_constraints,evidence_basis,assumptions,missing_inputs,validation_plan,alternatives,feed_risk,pretreatment_risk,concentrate_risk,integration_risk,operational_risk,compliance_economics_risk,score_basis,updated_on) VALUES
('RA085-01','MR085-01','CN0122','scr_transfer_2025','split_screen',1,'分股回用及尾水减量','先核实实际尾水与已有母液资源化，低盐支路有回用需求后小试膜处理；不直接改变高盐资源化回路','conditional','金属、盐、酸碱及浓液处置合规','历史转移材料','不假定现行膜或处理能力','实测流量、盐、金属、COD、pH、已有工艺及成本','独立采样、水平衡与小试、全成本核算','保留资源化及合法现有处理',NULL,NULL,NULL,NULL,NULL,NULL,'缺实际数据不评分','2026-11-28'),
('RA085-02','MR085-02','CN0349','recovery_historical','split_screen',1,'分股回用及尾水减量','先核实实际尾水与已有母液资源化，低盐支路有回用需求后小试膜处理；不直接改变高盐资源化回路','conditional','金属、盐、酸碱及浓液处置合规','历史转移材料','不假定现行膜或处理能力','实测流量、盐、金属、COD、pH、已有工艺及成本','独立采样、水平衡与小试、全成本核算','保留资源化及合法现有处理',NULL,NULL,NULL,NULL,NULL,NULL,'缺实际数据不评分','2026-11-28');
INSERT INTO evidence_notes(note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES
('N085-01','CN0122','S085-01','许可及实际接收','第三部分表1及第四部分','许可证340207001，2025-05-28至2029-02-25，HW50 772-007-50 50000t/a。2025-05和10月14批华润常熟接收合计366.8t，非全年。批次量28.74/29.5/29.62/30.7/31.68/29.14/19.24/25.74/27.06/26.16/25.18/28.56/26.2/9.28t，合计366.8；不重复计批次及总量。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N085-02','CN0122','S085-01','生产分流及资源化','第三部分表2，p12截图核','预洗湿洗含尘水、化学酸洗水、负载设备清洗水；初始酸洗母液经检测后作再生酸洗液，初始碱洗母液蒸发结晶离心得钨化合物，离心母液返配液。隔膜压滤非UF/RO。末端水站未知。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N085-03','CN0122','S085-02','工程备案','2025-07-30表3#站等','3#污水处理站608.64m²、5#资源化厂房4550.62m²、6#再生厂房7771.22m²，备案面积非处理能力或环保验收。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N085-04','CN0349','S085-03','历史许可及实收','第三部分表1及第四部分，p9截图核','2023材料综合18万t/a、至2026-03-09；包括HW50但分项未披露。2022年7月4批含镍滤渣108.2978t为HW46，不可算HW50量；名录类别与代码文字存在不一致。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N085-05','CN0349','S085-03','历史火湿法工艺','第三部分表2','焙烧后按不同金属浸取结晶，湿法装置共享、尾水处理；另有浸渣脱铝；原件未明确尾水处理技术。铬渣图不作为催化剂水站证据。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N085-06','CN0349','S085-04','许可版本差异','历史名录第17行搜索摘要','2022名录索引HW50 13700t、其他类别66300t，地址咸开路208号；2023材料综合180000t，不能合并，原行复开未定位；当前续证待核。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N085-07','CN0063','S085-05','联合再生服务采购','2026-11-27转载索引','与大唐南京联合采购陕西地区2027–2028两年约3000m³，按实际结算，非自产能力，实际分配未披露。正文复开禁用。','WEB_SECONDARY','WEB_TEXT','2026-11-28'),
('N085-08','CN0163','S085-05','联合再生服务采购','2026-11-27转载索引','同P085-02联合采购，3000m³不再计数；非污水改造或单厂产能。','WEB_SECONDARY','WEB_TEXT','2026-11-28');
INSERT INTO tasks(task_id,site_id,priority,missing,next_query,state) VALUES
('T0349','CN0349','P1','现行许可、HW50专线、尾水处理、流量、膜、实际成本','续证原件及现行环评验收','部分完成');
UPDATE sites SET permit_id='340207001',capacity_summary='2025材料载HW50 50000t/a许可至2029-02-25；2025华润常熟14批366.8t非全年',water_summary='再生分股、资源化母液回用/蒸发；2025备案3#污水站，实际处理规模待核',as_of='2026-11-28' WHERE site_id='CN0122';
INSERT INTO search_log(log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES
('L085-01','CN0122','085并行 cross_province_transfer','scr_transfer_2025 许可及实际接收','S085-01','独立原件，非全年','新年度转移及许可变化','2026-11-28'),
('L085-02','CN0122','085并行 document:transfer_material','scr_transfer_2025 生产分流及资源化','S085-01','原文与截图核','污水站验收及实际分流','2026-11-28'),
('L085-03','CN0122','085并行 construction_registry','scr_50000 污水站建设节点','S085-02','建筑面积非处理能力','实际验收及处理量','2026-11-28'),
('L085-04','CN0349','085并行 document:transfer_material','recovery_historical 历史许可与尾水工艺','S085-03','p9截图核；非实际处理量','续证原件及现行水站','2026-11-28'),
('L085-05','CN0349','085并行 historic_roster','site_current 许可分项及续证','S085-04','历史名录索引；续证未得','2026续证原件','2026-11-28'),
('L085-06','CN0063','085并行 recent_procurement','joint_scr_2027 新服务采购','S085-05','转载摘要','正式采购结果','2026-11-28'),
('L085-07','CN0163','085并行 recent_procurement','joint_scr_2027 新服务采购','S085-05','联合口径不重复','正式采购结果','2026-11-28'),
('L085-08','CN0231','085并行 document:W07S07','site_current 原报告剩余工程章节','W07S07','PDF超时','新可读入口','2026-11-28'),
('L085-09','CN0090','085并行 document:W07S09','site_current 原报告剩余工程章节','W07S09','PDF不可访问','新可读入口','2026-11-28'),
('L085-10','CN0241','085并行 document:W08S12','site_current 原报告剩余工程章节','W08S12','502','新可读入口','2026-11-28'),
('L085-11','CN0215','085并行 document:S027-07','site_current 现有工程水工艺','S027-07','超时','新可读入口','2026-11-28'),
('L085-12','CN0272','085并行 recent_project_search','site_current 拟审批及采购','S033-06','120/300t/d、设备包已有','新正式审批或验收','2026-11-28'),
('L085-13','CN0139','085并行 recent_project_search','site_current 拟审批及废水','S058-01','旧MVR设计已录','新验收或监测','2026-11-28'),
('L085-14','CN0127','085并行 recent_project_search','site_current 验收服务采购','S049-12','旧采购已录','正式验收','2026-11-28'),
('L085-15','CN0344','085并行 recent_project_search','site_current 阶段调试','S081-01','11月25日公示已录','正式验收','2026-11-28'),
('L085-16','CN0343','085并行 recent_project_search','site_current 中试环评','S080-05','10月22日公示已录','新受理或正式审批','2026-11-28');
INSERT INTO research_revisit_attempts(attempt_id,site_id,scope_key,gap,route_key,search_log_id,source_id,checked_on,outcome,gained_fields,evidence_refs,effort_minutes,next_check_on,reopen_trigger,rationale) VALUES
('A085-01','CN0122','scr_transfer_2025','许可及实际接收','cross_province_transfer','L085-01','S085-01','2026-11-28','context_gain','许可50000t/a及单客户366.8t','C085-01–02/N085-01',NULL,NULL,'新年度转移及许可变化','独立原件，非全年'),
('A085-02','CN0122','scr_transfer_2025','生产分流及资源化','document:transfer_material','L085-02','S085-01','2026-11-28','engineering_gain','5个分流/母液边界','W085-01–05/D085-01',NULL,NULL,'污水站验收及实际分流','原文与截图核'),
('A085-03','CN0122','scr_50000','污水站建设节点','construction_registry','L085-03','S085-02','2026-11-28','context_gain','3#站建筑面积及备案','P085-01/N085-03',NULL,NULL,'实际验收及处理量','建筑面积非处理能力'),
('A085-04','CN0349','recovery_historical','历史许可与尾水工艺','document:transfer_material','L085-04','S085-03','2026-11-28','engineering_gain','新增主体、历史综合许可及尾水主线','C085-04–05/W085-06/D085-02',NULL,NULL,'续证原件及现行水站','p9截图核；非实际处理量'),
('A085-05','CN0349','site_current','许可分项及续证','historic_roster','L085-05','S085-04','2026-11-28','context_gain','历史HW50分项及地址','C085-03/N085-06',NULL,'2026-12-28','2026续证原件','历史名录索引；续证未得'),
('A085-06','CN0063','joint_scr_2027','新服务采购','recent_procurement','L085-06','S085-05','2026-11-28','context_gain','联合两年3000m³预估','P085-02/N085-07',NULL,'2026-12-28','正式采购结果','转载摘要'),
('A085-07','CN0163','joint_scr_2027','新服务采购','recent_procurement','L085-07','S085-05','2026-11-28','context_gain','联合采购关系','P085-02/N085-08',NULL,'2026-12-28','正式采购结果','联合口径不重复'),
('A085-08','CN0231','site_current','原报告剩余工程章节','document:W07S07','L085-08','W07S07','2026-11-28','access_blocked','无','无',NULL,'2026-12-28','新可读入口','PDF超时'),
('A085-09','CN0090','site_current','原报告剩余工程章节','document:W07S09','L085-09','W07S09','2026-11-28','access_blocked','无','无',NULL,'2026-12-28','新可读入口','PDF不可访问'),
('A085-10','CN0241','site_current','原报告剩余工程章节','document:W08S12','L085-10','W08S12','2026-11-28','access_blocked','无','无',NULL,'2026-12-28','新可读入口','502'),
('A085-11','CN0215','site_current','现有工程水工艺','document:S027-07','L085-11','S027-07','2026-11-28','access_blocked','无','无',NULL,'2026-12-28','新可读入口','超时'),
('A085-12','CN0272','site_current','拟审批及采购','recent_project_search','L085-12','S033-06','2026-11-28','duplicate','无','S033-05/06/07',NULL,NULL,'新正式审批或验收','120/300t/d、设备包已有'),
('A085-13','CN0139','site_current','拟审批及废水','recent_project_search','L085-13','S058-01','2026-11-28','duplicate','无','W058-01–09',NULL,NULL,'新验收或监测','旧MVR设计已录'),
('A085-14','CN0127','site_current','验收服务采购','recent_project_search','L085-14','S049-12','2026-11-28','duplicate','无','S049-12',NULL,NULL,'正式验收','旧采购已录'),
('A085-15','CN0344','site_current','阶段调试','recent_project_search','L085-15','S081-01','2026-11-28','duplicate','无','P081-01',NULL,NULL,'正式验收','11月25日公示已录'),
('A085-16','CN0343','site_current','中试环评','recent_project_search','L085-16','S080-05','2026-11-28','duplicate','无','P080-04',NULL,NULL,'新受理或正式审批','10月22日公示已录');
INSERT INTO research_document_review(site_id,source_id,scope_key,gap,reviewed_on,state,locator,remaining_work,next_check_on,attempt_id) VALUES
('CN0122','S085-01','scr_transfer_2025','生产分流及资源化','2026-11-28','section_done','第三部分表2','污水站验收及实际分流',NULL,'A085-02'),
('CN0349','S085-03','recovery_historical','历史许可与尾水工艺','2026-11-28','section_done','第三部分表2','续证原件及现行水站',NULL,'A085-04'),
('CN0231','W07S07','site_current','原报告剩余工程章节','2026-11-28','blocked','原报告入口','新可读入口','2026-12-28','A085-08'),
('CN0090','W07S09','site_current','原报告剩余工程章节','2026-11-28','blocked','原报告入口','新可读入口','2026-12-28','A085-09'),
('CN0241','W08S12','site_current','原报告剩余工程章节','2026-11-28','blocked','原报告入口','新可读入口','2026-12-28','A085-10'),
('CN0215','S027-07','site_current','现有工程水工艺','2026-11-28','blocked','原报告入口','新可读入口','2026-12-28','A085-11');
COMMIT;
