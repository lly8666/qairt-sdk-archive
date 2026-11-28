PRAGMA foreign_keys=ON;
BEGIN;
INSERT INTO sites(site_id,name,province,city,address,category,status,record_type,capacity_summary,water_level,priority,permit_id,source_status,as_of,notes) VALUES
('CN0329','崇阳县芜菁再生资源有限公司','湖北','咸宁','崇阳县经济开发区','废催化剂/纯回收','2025名录载2023换证；2026扩建征求意见及生产调研线索','纯回收','HW50许可20000t/a；扩建危废规模不增','缺失','P1','S42-12-23-0118','本轮部分复核','2026-11-28','2026年1月扩建草案新增一般固废20000t/a，后续索引称5000t/a，版本不同；不作为已建或新剂产能'),
('CN0330','湖北星升环保科技有限公司','湖北','咸宁','咸安区贺胜桥镇贺胜茶场','含钒废催化剂/纯回收','历史危废许可到2025-08-06，续证待核','纯回收','历史HW50含钒废物8000t/a','缺失','P2','S42-12-02-0013','本轮部分复核','2026-11-28','历史许可不等于当前生产；未取污水资料');
INSERT INTO sources(source_id,title,url,source_type,document_date,scope,access_date) VALUES
('S074-01','湖北省危废经营许可单位名录（截至2025-06-05）','https://sthjt.hubei.gov.cn/fbjd/zc/zcwj/sthjt/tzgg/202506/P020250605682630807072.pdf','WEB_PRIMARY','2025-06-05','印刷页45–46序号93、95、96，截图及文本','2026-11-28'),
('S074-02','芜菁废旧催化剂综合利用生产线扩建环评征求意见公示','https://hbj.cyxw.cn/info?colid=686&id=110762','WEB_PRIMARY','2026-01-19','政府公示正文；草案全文链接访问超时','2026-11-28'),
('S074-03','崇阳生产企业调研报道','https://www.cyxw.cn/info?SiteId=1&colid=31&id=97329','WEB_PRIMARY','2026-10-12','生产线调研报道；无实际吞吐量','2026-11-28'),
('S074-04','芜菁2026年扩建审批索引','https://www.bidcenter.com.cn/zhaobiao/zbkeyw-2980-420000-17.html','WEB_SECONDARY','2026-10-30','聚合索引摘要；原审批未取，非独立确证','2026-11-28'),
('S074-05','浙江微通危险废物处置询比采购公告转载','https://m.yfbzb.com/inviteBid/detail/20261119_649388703.html','WEB_SECONDARY','2026-11-19','预算、浓缩盐预估量、服务及运输边界','2026-11-28'),
('S074-06','中石化云溪150吨有机膦配体项目环评信息','https://yunxiqu.gov.cn/38965/39034/39035/39063/41965/42378/content_2398149.html','WEB_PRIMARY','2026-09-04','官方检索摘要；正文超时，拟建信息待核','2026-11-28'),
('S074-07','中石化北京涂覆式催化剂中试项目报批前公示','https://scc.sinopec.com/scc/info/gsxx/2026/8/I1544022384065904640.shtml','WEB_PRIMARY','2026-08-14','公示正文；附件访问失败','2026-11-28'),
('S074-08','天津经开区中石化催化剂综合回收项目进展','https://www.teda.gov.cn/contents/13/114318.html','WEB_PRIMARY','2026-09-03','厂房钢结构安装，预计2027年一季度投产','2026-11-28'),
('S074-09','三美股份2026年半年度报告','https://vip.stock.finance.sina.com.cn/corp/view/vCB_AllBulletinDetail.php?id=12523307&stockid=603379','WEB_PRIMARY','2026','公开财报转载检索正文，募投资金进展非环保验收','2026-11-28'),
('S074-10','润和浙江一期规划许可索引','https://m.bidcenter.com.cn/enterprise/rhchclzjyxgs/','WEB_SECONDARY',NULL,'聚合索引：规划许可条目，具体发布日期及原件未核','2026-11-28');
INSERT INTO site_sources(site_id,source_id) VALUES
('CN0329','S074-01'),
('CN0330','S074-01'),
('CN0212','S074-01'),
('CN0329','S074-02'),
('CN0329','S074-03'),
('CN0329','S074-04'),
('CN0217','S074-05'),
('CN0003','S074-06'),
('CN0007','S074-07'),
('CN0013','S074-08'),
('CN0214','S074-09'),
('CN0019','S074-10'),
('CN0192','turn787991search0');
INSERT INTO capacity(capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES
('C074-01','CN0329','HW50 251-016-50',15000,'t/a','许可','2023-10-30换证，2025名录','分项','S074-01','非实际量，合计20000'),
('C074-02','CN0329','HW50 251-018-50',2000,'t/a','许可','2023-10-30换证，2025名录','分项','S074-01','非实际量'),
('C074-03','CN0329','HW50 261-173-50',3000,'t/a','许可','2023-10-30换证，2025名录','分项','S074-01','不含硫铁矿制酸废含钒催化剂；所有危废不得检出卤素'),
('C074-04','CN0330','HW50含钒废物',8000,'t/a','历史许可','2024-08-07至2025-08-06','许可','S074-01','已过名录所列期限，续证待核'),
('C074-05','CN0212','HW50 251-016-50',10000,'t/a','历史许可','2025-04-28起一年','分项','S074-01','不得检出卤素，重金属不超过环评要求'),
('C074-06','CN0212','HW50 261-173-50',2500,'t/a','历史许可','2025-04-28起一年','分项','S074-01','不含硫铁矿制酸废催化剂；非现行确认'),
('C074-07','CN0192','HW46/HW50含钨钼镍钒铜锌铝废催化剂',50000,'t/a','经营许可','2026-05-27至2031-05-26','许可分项','turn787991search0','与800合计50800；不额外加中试1500'),
('C074-08','CN0192','HW46/HW50含铂钯铑银废催化剂',800,'t/a','经营许可','2026-05-27至2031-05-26','许可分项','turn787991search0','非实际产量'),
('C074-09','CN0003','有机膦配体',150,'t/a','拟建环评摘要','2026-09','项目','S074-06','配体非催化剂成品，非在产');
INSERT INTO projects(project_id,site_id,project,status,date,capacity_note,water_change,source_id) VALUES
('P074-01','CN0329','废旧催化剂综合利用生产线扩建','征求意见稿公示','2026-01-19','危废20000t/a不增；草案新增含钒一般固废20000t/a；后续索引5000t/a，待原批复校核','草案全文未取；污水设施未核','S074-02'),
('P074-02','CN0003','150吨/年有机膦配体生产项目','环评信息索引，正文待核','2026-09-04','拟建150t/a配体，非催化剂成品','摘要称依托现有废水设施；分流未核','S074-06'),
('P074-03','CN0007','涂覆式催化剂中试项目','报批前公示','2026-08-14','规模待核','附件未取，工艺及水量未知','S074-07');
UPDATE sites SET address='崇阳县经济开发区发展南路',permit_id='S42-12-23-0129',capacity_summary='2025-04-28一年期许可HW50分项12500t/a，另HW35废碱12500t/a；续证待核，旧5500历史保留',status='历史危废许可，2026续证待核',as_of='2026-11-28' WHERE site_id='CN0212';
UPDATE sites SET permit_id='LN2112210079',capacity_summary='2026经营许可HW46/HW50 50800t/a（50000+800）；另1500t/a中试批复，不叠加',as_of='2026-11-28' WHERE site_id='CN0192';
UPDATE projects SET status='2026-09厂房钢结构安装；预计2027Q1投产',date='2026-09-03',source_id='S074-08' WHERE project_id='P016-002';
INSERT INTO water_economics(cost_id,site_id,water_id,item,value,unit,basis,period,source_id,notes) VALUES
('K074-01','CN0217',NULL,'浓缩盐利用处置采购预算',100000,'元','含税采购预算；非成交或实际费用','2026-11公告，服务拟至2027-12-31','S074-05','预估40t/a；采购方负责运输；按实际接收量结算；合同期与年预估不必一致，不作吨水成本');
INSERT INTO evidence_notes(note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES
('N074-01','CN0329','S074-01','历史许可','印刷页45–46，序号95','HW50三分项15000/2000/3000t/a，合计20000；2022-08-22初领、2023-10-30换证5年；卤素不得检出；2026现行变更待核','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N074-02','CN0330','S074-01','历史许可','印刷页45，序号93','含钒HW50 8000t/a；许可证编号S42-12-02-0013；2024-08-07至2025-08-06；未核续证，不算当前产能','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N074-03','CN0212','S074-01','许可跨期差异','印刷页46，序号96','HW50 10000+2500=12500t/a，另HW35 12500t/a；总25000混合许可，不计作纯废催化剂；2025-04-28起一年；旧5500保留','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N074-04','CN0329','S074-02','扩建草案','项目概况','总投资180万元（非污水投资）；增加铂、镍、钒、钼钒等回收线及调整原四线；危废20000t/a不增、一般工业固废20000t/a拟增；征求意见稿非批复','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N074-05','CN0329','S074-03','现场报道','生产调研','报道涉及生产车间和生产线运行；不是实际处理量统计、环境验收或连续运行证明','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N074-06','CN0329','S074-04','扩建审批索引与版本冲突','2026-10-30检索摘要','后续索引称危废20000t/a不增、一般固废5000t/a、新增废气/废水设施；与1月草案20000一般固废不同，未见审批原件；勿认定已建','WEB_SECONDARY','WEB_TEXT','2026-11-28'),
('N074-07','CN0217','S074-05','浓缩盐采购','采购范围及要求','HW11/900-013-11浓缩盐40t/a预计；预算含税10万元，利用处置、运输采购方负责，合同至2027年底；100000/40=2500仅算术比值，期限与数量未必一致，不是成交单价或吨水成本；来源为公告转载','WEB_SECONDARY','WEB_TEXT','2026-11-28'),
('N074-08','CN0192','turn787991search0','2026经营许可','2026-11-06名录第54项','50800t/a（普通金属50000、贵金属800）；2026-05-27至2031-05-26，1500中试单列，80t/d蒸发和200t/d站旧证据不重复','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N074-09','CN0019','W01B2S09','一期排放口表校核','表5.3-1/5.3-2；同报告镜像 https://aimg8.dlssyht.cn/u/2280227/ueditor/file/1141/2280227/1721274459934866.pdf','DW001 22960t/a、DW002 5576.7t/a、DW003 3660t/a、DW004 62116.7t/a（旧W052-30）；排放口统计有上下游包含关系，不求和；原表DA/DW及银铜/银钡异文保留；表列接收厂排放标准非厂区实测','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N074-10','CN0019','S074-10','规划许可索引','聚合条目','一期PDH7000和银1000t/a规划许可索引，原件及明确日期待核；不作新产能或投产证据','WEB_SECONDARY','WEB_TEXT','2026-11-28'),
('N074-11','CN0003','S074-06','新项目索引','政府检索摘要','150t/a有机膦配体；摘要拟依托现有污水设施；总投资7072万元、环保投资431万元不等于污水投资；正文超时，未取分股、水质及设备','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N074-12','CN0007','S074-07','中试报批前公示','2026-08-14公示','附件 https://scc.sinopec.com/scc/content_file/info/gsxx/2026/8/1544022384061710336_file_2.pdf 返回502；不以公司网站页脚作项目地址；项目规模与水工艺未取','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N074-13','CN0013','S074-08','施工进度','2026-09-03正文','1200t/a原回收项目正在钢结构安装，预计2027Q1投产；近5000万元总投资、报道回收效率提高约10%，不是污水投资或独立实测；原6月开工史见S016-005','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N074-14','CN0214','S074-09','募投进度','2026半年报募投表检索','累计投入3991.11万元，占5500万元承诺投资72.57%，当期361.68万元，4月达到预定可使用状态；不等于环境验收、实际生产或水处理费用','WEB_PRIMARY','WEB_TEXT','2026-11-28');
INSERT INTO wastewater(water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES
('W074-01','CN0019','DW001设计排放口','2021一期环评设计',22960,'t/a','表5.3-2设计口径',NULL,NULL,NULL,NULL,'W01B2S09','WEB_PRIMARY','非实测；总口W052-30包含关系待核'),
('W074-02','CN0019','DW002设计排放口','2021一期环评设计',5576.7,'t/a','表5.3-2设计口径',NULL,NULL,NULL,NULL,'W01B2S09','WEB_PRIMARY','银铜/银钡异文待核；不可与总排口相加'),
('W074-03','CN0019','DW003设计排放口','2021一期环评设计',3660,'t/a','表5.3-2设计口径',NULL,NULL,NULL,NULL,'W01B2S09','WEB_PRIMARY','非实测；不可与总排口相加');
INSERT INTO tasks(task_id,site_id,priority,missing,next_query,state) VALUES
('T0329','CN0329','P1','2026批复原件、实际废水分流、水量、站工艺和膜','查咸宁正式审批或可读环评，核一般固废版本差异','部分完成'),
('T0330','CN0330','P2','现行续证/停产状态及污水系统','查2026现行许可/验收原件，非重复旧目录','部分完成');
INSERT INTO search_log(log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES
('L074-01','CN0329','074并行 independent_hubei_roster','site_current 许可及生产身份','S074-01','政府名录页45–46；context_gain','新许可或验收','2026-11-28'),
('L074-02','CN0330','074并行 independent_hubei_roster','site_current 许可及生产身份','S074-01','名录93项；context_gain','续证/停产公告','2026-11-28'),
('L074-03','CN0212','074并行 independent_hubei_roster','site_current 许可及生产身份','S074-01','名录96项；context_gain','2026续证原件','2026-11-28'),
('L074-04','CN0329','074并行 new_eia_notice','expansion_2026 扩建及污水处理','S074-02','正文草案，后续索引弱证据；context_gain','正式批复或可读报告','2026-11-28'),
('L074-05','CN0329','074并行 document:hp.cseti.com.cn','expansion_2026 分股及站工艺','S074-02','附件超时；access_blocked','新原件链接','2026-11-28'),
('L074-06','CN0217','074并行 concentrated_salt_tender','site_current 危废处置采购及成本','S074-05','采购转载，非实际吨水成本；engineering_gain','正式成交/报价或合同','2026-11-28'),
('L074-07','CN0192','074并行 regulator_roster_202611','site_current 许可及生产身份','turn787991search0','不重复中试与已有水站数据；context_gain','许可变更或验收','2026-11-28'),
('L074-08','CN0019','074并行 document:W01B2S09','phase1_2021 排放口设计水量','W01B2S09','同一报告镜像，不新增来源；engineering_gain','独立实际监测或其他未取章节','2026-11-28'),
('L074-09','CN0019','074并行 planning_index','phase1_2021 规划建设节点','S074-10','弱索引，不升级运行；context_gain','规划许可原件/验收','2026-11-28'),
('L074-10','CN0003','074并行 regulator_index','ligand_2026 新项目及依托水设施','S074-06','仅政府检索摘要；context_gain','正式批复或原报告','2026-11-28'),
('L074-11','CN0007','074并行 company_eia_notice','coating_pilot_2026 新项目及站工艺','S074-07','不假定新水处理站；context_gain','批复或可读附件','2026-11-28'),
('L074-12','CN0007','074并行 document:S074-07','coating_pilot_2026 分股及站工艺','S074-07','502；access_blocked','新可访问附件','2026-11-28'),
('L074-13','CN0013','074并行 park_news','silver_recovery_1200 建设进度','S074-08','同一项目，不重复容量；context_gain','实际投产/验收公告','2026-11-28'),
('L074-14','CN0214','074并行 half_year_report','site_current 建设及验收状态','S074-09','不是污水费用；context_gain','环保验收/实测','2026-11-28'),
('L074-15','CN0138','074并行 independent_product_search','site_current 补分质排放路径',NULL,'新型分子筛三路分质原库已录；duplicate','独立新报告/验收','2026-11-28'),
('L074-16','CN0253','074并行 approval_index_recheck','site_current 核一期范围',NULL,'IPN150t/a不在一期范围已录，不重开原附件冷却；duplicate','新独立批复/验收','2026-11-28'),
('L074-17','CN0017','074并行 recent_regulator_index','site_current 建设及审批节点',NULL,'原10万吨环评公示及报批信息已录；no_new','正式新批复或验收','2026-11-28'),
('L074-18','CN0134','074并行 alternate_attachment_index','site_current 历史实际排放表',NULL,'同文件名另一入口，片段无完整单位/列名；access_blocked','可读表格全文','2026-11-28');
INSERT INTO research_revisit_attempts(attempt_id,site_id,scope_key,gap,route_key,search_log_id,source_id,checked_on,outcome,gained_fields,evidence_refs,effort_minutes,next_check_on,reopen_trigger,rationale) VALUES
('A074-01','CN0329','site_current','许可及生产身份','independent_hubei_roster','L074-01','S074-01','2026-11-28','context_gain','新主体许可规模','N074-01/C074-01–03',NULL,'2027-02-28','新许可或验收','政府名录页45–46'),
('A074-02','CN0330','site_current','许可及生产身份','independent_hubei_roster','L074-02','S074-01','2026-11-28','context_gain','新主体历史许可','N074-02/C074-04',NULL,'2027-02-28','续证/停产公告','名录93项'),
('A074-03','CN0212','site_current','许可及生产身份','independent_hubei_roster','L074-03','S074-01','2026-11-28','context_gain','历史许可分项及新旧差异','N074-03/C074-05–06',NULL,'2027-02-28','2026续证原件','名录96项'),
('A074-04','CN0329','expansion_2026','扩建及污水处理','new_eia_notice','L074-04','S074-02','2026-11-28','context_gain','扩建项目范围及版本差异','P074-01/N074-04–06',NULL,'2026-12-12','正式批复或可读报告','正文草案，后续索引弱证据'),
('A074-05','CN0329','expansion_2026','分股及站工艺','document:hp.cseti.com.cn','L074-05','S074-02','2026-11-28','access_blocked','无','N074-04',NULL,'2026-12-12','新原件链接','附件超时'),
('A074-06','CN0217','site_current','危废处置采购及成本','concentrated_salt_tender','L074-06','S074-05','2026-11-28','engineering_gain','处置预算、预计残余物、运输边界','K074-01/N074-07',NULL,'2026-12-05','正式成交/报价或合同','采购转载，非实际吨水成本'),
('A074-07','CN0192','site_current','许可及生产身份','regulator_roster_202611','L074-07','turn787991search0','2026-11-28','context_gain','2026换证分项及有效期','C074-07–08/N074-08',NULL,'2027-02-28','许可变更或验收','不重复中试与已有水站数据'),
('A074-08','CN0019','phase1_2021','排放口设计水量','document:W01B2S09','L074-08','W01B2S09','2026-11-28','engineering_gain','三个设计排放口水量及旧总口边界','W074-01–03/N074-09',NULL,NULL,'独立实际监测或其他未取章节','同一报告镜像，不新增来源'),
('A074-09','CN0019','phase1_2021','规划建设节点','planning_index','L074-09','S074-10','2026-11-28','context_gain','规划许可索引','N074-10',NULL,'2026-12-28','规划许可原件/验收','弱索引，不升级运行'),
('A074-10','CN0003','ligand_2026','新项目及依托水设施','regulator_index','L074-10','S074-06','2026-11-28','context_gain','拟建配体项目','P074-02/C074-09/N074-11',NULL,'2026-12-12','正式批复或原报告','仅政府检索摘要'),
('A074-11','CN0007','coating_pilot_2026','新项目及站工艺','company_eia_notice','L074-11','S074-07','2026-11-28','context_gain','报批前公示节点','P074-03/N074-12',NULL,'2026-12-12','批复或可读附件','不假定新水处理站'),
('A074-12','CN0007','coating_pilot_2026','分股及站工艺','document:S074-07','L074-12','S074-07','2026-11-28','access_blocked','无','N074-12',NULL,'2026-12-12','新可访问附件','502'),
('A074-13','CN0013','silver_recovery_1200','建设进度','park_news','L074-13','S074-08','2026-11-28','context_gain','钢结构安装，投产时间细化','P016-002/N074-13',NULL,'2027-04-01','实际投产/验收公告','同一项目，不重复容量'),
('A074-14','CN0214','site_current','建设及验收状态','half_year_report','L074-14','S074-09','2026-11-28','context_gain','募投累计投资及比例','N074-14',NULL,'2027-02-28','环保验收/实测','不是污水费用'),
('A074-15','CN0138','site_current','补分质排放路径','independent_product_search','L074-15',NULL,'2026-11-28','duplicate','无','旧项目已有',NULL,NULL,'独立新报告/验收','新型分子筛三路分质原库已录'),
('A074-16','CN0253','site_current','核一期范围','approval_index_recheck','L074-16',NULL,'2026-11-28','duplicate','无','旧批复已录',NULL,NULL,'新独立批复/验收','IPN150t/a不在一期范围已录，不重开原附件冷却'),
('A074-17','CN0017','site_current','建设及审批节点','recent_regulator_index','L074-17',NULL,'2026-11-28','no_new','无','无',NULL,'2026-12-28','正式新批复或验收','原10万吨环评公示及报批信息已录'),
('A074-18','CN0134','site_current','历史实际排放表','alternate_attachment_index','L074-18',NULL,'2026-11-28','access_blocked','无','无',NULL,'2026-12-28','可读表格全文','同文件名另一入口，片段无完整单位/列名');
INSERT INTO research_document_review(site_id,source_id,scope_key,gap,reviewed_on,state,locator,remaining_work,next_check_on,attempt_id) VALUES
('CN0019','W01B2S09','phase1_2021','排放口设计水量','2026-11-28','section_done','表5.3-1/2；镜像链接见N074-09','不重读已提取章节；独立实际数据另查',NULL,'A074-08'),
('CN0329','S074-02','expansion_2026','分股及站工艺','2026-11-28','blocked','公示附件链接','完整报告/正式批复','2026-12-12','A074-05'),
('CN0007','S074-07','coating_pilot_2026','分股及站工艺','2026-11-28','blocked','报批附件','可读全文或批复','2026-12-12','A074-12');
COMMIT;
