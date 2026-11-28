PRAGMA foreign_keys=ON;
BEGIN;
INSERT INTO sources(source_id,title,url,source_type,document_date,scope,access_date) VALUES
('S082-01','中科合成油技术股份有限公司招股说明书申报稿','https://notice.10jqka.com.cn/api/pdf/85a303a6370081b9_1672392727/%E4%B8%AD%E7%A7%91%E5%90%88%E6%88%90%E6%B2%B9%E6%8A%80%E6%9C%AF%E8%82%A1%E4%BB%BD%E6%9C%89%E9%99%90%E5%85%AC%E5%8F%B8%E7%A7%91%E5%88%9B%E6%9D%BF%E9%A6%96%E6%AC%A1%E5%85%AC%E5%BC%80%E5%8F%91%E8%82%A1%E7%A5%A8%E6%8B%9B%E8%82%A1%E8%AF%B4%E6%98%8E%E4%B9%A6%EF%BC%88%E7%94%B3%E6%8A%A5%E7%A8%BF%EF%BC%89.pdf','WEB_COMPANY','2022-12','1-1-137至138，169；企业历史自述；截图超限','2026-11-28'),
('S082-02','内蒙古鄂尔多斯准格尔经济开发区规划环评公开报告','https://www.ordos.gov.cn/zt_127959/gyyqypggs/nmgzgejjkfq/dlcyy/202404/P020240419321069613496.pdf','WEB_PRIMARY','2024-04','表3.6-1及4.2-1；园区汇总；截图404','2026-11-28');
INSERT INTO site_sources(site_id,source_id) VALUES
('CN0341','S082-01'),
('CN0341','S082-02');
INSERT INTO capacity(capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES
('C082-1','CN0341','煤制油催化剂',12000,'t','历史报告期产能','2019','中科内蒙生产；发行人披露','S082-01','2022半年产能按年产能折算；不是二期现行产能'),
('C082-2','CN0341','煤制油催化剂',9263.03,'t','历史实际产量','2019','中科内蒙生产；发行人披露','S082-01','企业历史披露，非2026实际产量'),
('C082-3','CN0341','煤制油催化剂',12000,'t','历史报告期产能','2020','中科内蒙生产；发行人披露','S082-01','2022半年产能按年产能折算；不是二期现行产能'),
('C082-4','CN0341','煤制油催化剂',6804.06,'t','历史实际产量','2020','中科内蒙生产；发行人披露','S082-01','企业历史披露，非2026实际产量'),
('C082-5','CN0341','煤制油催化剂',12000,'t','历史报告期产能','2021','中科内蒙生产；发行人披露','S082-01','2022半年产能按年产能折算；不是二期现行产能'),
('C082-6','CN0341','煤制油催化剂',8109.05,'t','历史实际产量','2021','中科内蒙生产；发行人披露','S082-01','企业历史披露，非2026实际产量'),
('C082-7','CN0341','煤制油催化剂',6000,'t','历史报告期产能','2022年1–6月','中科内蒙生产；发行人披露','S082-01','2022半年产能按年产能折算；不是二期现行产能'),
('C082-8','CN0341','煤制油催化剂',3732.06,'t','历史实际产量','2022年1–6月','中科内蒙生产；发行人披露','S082-01','企业历史披露，非2026实际产量');
INSERT INTO wastewater(water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES
('W082-01','CN0098','铜系2 W2-1~4及设备清洗W7-2合并接管','2024扩建环评设计',6815.28,'m³/a','环评设计合并出水','COD、SS、总氮、全盐量、总铜、总锌','1#三效蒸发','南通能达化工污水处理厂',NULL,'turn127831search84','WEB_PRIMARY','接管端，不与两股进水重复累计'),
('W082-02','CN0098','分子筛固化还原及洗涤 W3-8/9/10合并接管','2024扩建环评设计',16341.9,'m³/a','环评设计合并出水','COD、SS、水合肼、总氮、全盐量','消解支路与树脂吸附支路合并','南通能达化工污水处理厂',NULL,'turn127831search84','WEB_PRIMARY','合并出水非单股；原表TN疑点保留'),
('W082-03','CN0098','扩建综合污水处理装置接管出水','2024扩建环评设计',54783.61,'m³/a','环评设计装置出水','COD、SS、氨氮、总氮、总磷、全盐量、吡啶、水合肼','A/O+MBR等综合处理','南通能达化工污水处理厂',NULL,'turn127831search84','WEB_PRIMARY','非全厂总水量，不与55937.65进水或分股相加'),
('W082-04','CN0341','煤制油催化剂合成洗滤支路','2019–2022上半年历史披露',NULL,NULL,'历史工艺，流量未披露',NULL,'多效蒸发','硝酸铵溶液',NULL,'S082-01','WEB_COMPANY','图示资源化支路；未披露母液具体组成、蒸发冷凝水去向及产量'),
('W082-05','CN0341','生产废水综合处理','2019–2022上半年历史披露',NULL,NULL,'历史工艺，流量未披露','COD、氨氮、其他特征污染物','氨氮污水处理系统；具体单元不详','报告期企业自述处理后循环利用',NULL,'S082-01','WEB_COMPANY','不等于全厂零排放或第三方实测达标'),
('W082-06','CN0341','生活废水至园区综合污水厂','2024园区规划报告现状',12.72,'t/d','园区汇总现状量','生活污水','厂内处理未披露','园区综合污水处理厂',NULL,'S082-02','WEB_PRIMARY','表4.2-1明确企业行；并非2026实测或全厂合计，跨页第二行待核');
UPDATE water_metrics SET water_id='W082-01',point='铜系2及设备清洗合并接管预测' WHERE water_id='W081-13' AND point LIKE '%接管预测';
UPDATE water_metrics SET water_id='W082-02',point='固化还原及洗涤合并接管预测' WHERE water_id='W081-19' AND point LIKE '%接管预测';
UPDATE water_metrics SET water_id='W082-03',point='综合污水装置接管预测' WHERE water_id='W081-23' AND point LIKE '%接管预测';
INSERT INTO process_diagrams(diagram_id,site_id,scope_key,stage,period,revision,coverage,mermaid,source_id,boundaries,gaps,updated_on) VALUES
('D082-01','CN0341','coal_catalyst_historical','historical','2019–2022上半年',1,'partial','flowchart TD
 A[合成洗滤] --> B[多效蒸发] --> C[硝酸铵溶液]
 D[生产废水] --> E[氨氮污水处理系统] --> F[企业披露循环利用]','S082-01','招股书两条独立描述；未证实蒸发冷凝水进入氨氮系统，不擅自连接','2026实际设施、流程单元、回用率、浓盐水、排口、膜及水量未确认','2026-11-28');
INSERT INTO process_diagram_evidence(evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES
('DE082-01','D082-01','W082-04','S082-01','1-1-137 工艺图','A,B,C','合成洗滤分支蒸发产硝酸铵溶液'),
('DE082-02','D082-01','W082-05','S082-01','1-1-137 环保设施表','D,E,F','COD、氨氮等；氨氮污水系统及企业历史自述回用');
INSERT INTO membrane_reviews(review_id,site_id,diagram_id,scope_key,stage,period,revision,presence,source_id,evidence_basis,gaps,updated_on) VALUES
('MR082-01','CN0341','D082-01','coal_catalyst_historical','historical','2019–2022上半年',1,'not_identified','S082-01','仅披露多效蒸发、氨氮污水处理系统；无膜单元证据','未识别不等于未安装；需现行设计、设备清单或验收','2026-11-28');
INSERT INTO membrane_retrofits(assessment_id,review_id,site_id,scope_key,option_key,revision,objective,proposed_route,feasibility,hard_constraints,evidence_basis,assumptions,missing_inputs,validation_plan,alternatives,feed_risk,pretreatment_risk,concentrate_risk,integration_risk,operational_risk,compliance_economics_risk,score_basis,updated_on) VALUES
('RA082-01','MR082-01','CN0341','coal_catalyst_historical','ammonium_recovery',1,'保持硝酸铵资源化并评价低盐回用','先实测蒸发冷凝水及氨氮系统各支路，满足预处理及回用条件才考虑膜深度处理；不直接改高浓度含铵母液','conditional','维持现有资源化；含氨氮水的排放、浓水与回用边界、安全和成本须验证','历史招股书及园区规划，非现行实测','不假定现有膜；不假定硝酸铵溶液可任意浓缩','流量、氮形态、盐度、COD、金属、pH、温度、现行回用需求及成本','现场核实分流，连续取样、水盐氮平衡、小试及经济性核算','保留蒸发资源化、现有氨氮处理及园区处理路径',NULL,NULL,NULL,NULL,NULL,NULL,'缺少实测，不评分','2026-11-28');
INSERT INTO evidence_notes(note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES
('N082-01','CN0341','S082-01','历史产能及产量','1-1-169','2019/2020/2021产能均12000t，产量9263.03/6804.06/8109.05t；2022上半年产能折算6000t、产量3732.06t。报告期产品由中科内蒙生产；不替代2023二期批复或2026现行产能。','WEB_COMPANY','WEB_TEXT','2026-11-28'),
('N082-02','CN0341','S082-01','环保投入','1-1-138','2019/2020/2021/2022上半年环保投资357.69/24.41/1043.15/37.90万元，环保费用121.66/101.50/195.61/40.02万元；2021主要原因系氨氮系统建设。均为综合环保口径，非污水专项决算或吨水成本，不进入water_economics。','WEB_COMPANY','WEB_TEXT','2026-11-28'),
('N082-03','CN0341','S082-02','历史用水','表3.6-1','2022园区汇总：48000t/a煤制油催化剂项目449.85t/d、14.845204万t/a；副产物转化87.27t/d、2.88万t/a；FCC催化剂39.48t/d、1.3029万t/a。用水非排水，项目名称非已建产能证据；未将其入废水流量。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N082-04','CN0341','S082-02','排水表跨页疑点','表4.2-1','企业明确行生活废水12.72t/d至园区综合站；其后空企业名单元生产40.4、生活2.58t/d至伊泰污水处理站，原图404未核归属，暂不入数值流量。不得断定全厂零排放。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N082-05','CN0098','turn127831search84','接管测点口径校正','pp139–144','补合并接管6815.28、16341.9及装置接管54783.61m³/a；原19项接管预测指标移至相应出水ID，不新增重复指标，设计进出水分开。','WEB_PRIMARY','WEB_TEXT','2026-11-28');
UPDATE sites SET water_summary='历史含氨氮污水处理及洗滤支路多效蒸发；园区报告生活排水12.72t/d，生产排水跨页待核；现行膜与流量待核',water_level='历史工艺及部分排水量' WHERE site_id='CN0341';
INSERT INTO search_log(log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES
('L082-01','CN0341','082追加 document:prospectus','coal_catalyst_historical 历史产能及废水工艺','S082-01','历史自述，非现行；截图超限','现行验收及设备清单','2026-11-28'),
('L082-02','CN0341','082追加 park_plan','site_current 园区水量及排水','S082-02','跨页疑点不入库','原表图页、现行许可执行报告','2026-11-28'),
('L082-03','CN0098','082追加 table_boundary','expansion_a_o_mbr 接管边界校正','turn127831search84','原报告口径校正非新增监测','正式验收','2026-11-28'),
('L082-04','CN0010','082追加 document:W03S01','site_current 现行运行报告','W03S01','14.46MB超限','可读附件','2026-11-28'),
('L082-05','CN0022','082追加 document:W15S07','site_current 共享站现行运行','W15S07','复开超时','可读附件','2026-11-28'),
('L082-06','CN0280','082追加 document:S035-03','site_current 现行运行及膜','S035-03','复开超时','可读附件','2026-11-28'),
('L082-07','CN0083','082追加 document:S018-009','site_current 共享站运行','S018-009','57MB超限','可读附件','2026-11-28'),
('L082-08','CN0344','082追加 independent_water_search','site_current 阶段废水工艺','S081-01','搜索返回已有调试信息','验收报告或新环评','2026-11-28'),
('L082-09','CN0345','082追加 independent_water_search','site_current 生产废水工艺','S081-02','返回旧许可','原环评或验收','2026-11-28'),
('L082-10','CN0342','082追加 independent_water_search','site_current 再生及新剂水站',NULL,'未发现可读新工艺','政府环评或验收','2026-11-28');
INSERT INTO research_revisit_attempts(attempt_id,site_id,scope_key,gap,route_key,search_log_id,source_id,checked_on,outcome,gained_fields,evidence_refs,effort_minutes,next_check_on,reopen_trigger,rationale) VALUES
('A082-01','CN0341','coal_catalyst_historical','历史产能及废水工艺','document:prospectus','L082-01','S082-01','2026-11-28','engineering_gain','历史生产及工艺、环保投资','C082-1–8/W082-04–05/D082-01/N082-01–02',NULL,NULL,'现行验收及设备清单','历史自述，非现行；截图超限'),
('A082-02','CN0341','site_current','园区水量及排水','park_plan','L082-02','S082-02','2026-11-28','engineering_gain','历史用水口径、明确生活排水','W082-06/N082-03–04',NULL,NULL,'原表图页、现行许可执行报告','跨页疑点不入库'),
('A082-03','CN0098','expansion_a_o_mbr','接管边界校正','table_boundary','L082-03','turn127831search84','2026-11-28','engineering_gain','3个合并接管出水量及19指标归属','W082-01–03/N082-05',NULL,NULL,'正式验收','原报告口径校正非新增监测'),
('A082-04','CN0010','site_current','现行运行报告','document:W03S01','L082-04','W03S01','2026-11-28','access_blocked','无','无',NULL,'2026-12-28','可读附件','14.46MB超限'),
('A082-05','CN0022','site_current','共享站现行运行','document:W15S07','L082-05','W15S07','2026-11-28','access_blocked','无','无',NULL,'2026-12-28','可读附件','复开超时'),
('A082-06','CN0280','site_current','现行运行及膜','document:S035-03','L082-06','S035-03','2026-11-28','access_blocked','无','无',NULL,'2026-12-28','可读附件','复开超时'),
('A082-07','CN0083','site_current','共享站运行','document:S018-009','L082-07','S018-009','2026-11-28','access_blocked','无','无',NULL,'2026-12-28','可读附件','57MB超限'),
('A082-08','CN0344','site_current','阶段废水工艺','independent_water_search','L082-08','S081-01','2026-11-28','no_new','无','P081-01',NULL,'2027-05-25','验收报告或新环评','搜索返回已有调试信息'),
('A082-09','CN0345','site_current','生产废水工艺','independent_water_search','L082-09','S081-02','2026-11-28','no_new','无','N081-05',NULL,'2026-12-28','原环评或验收','返回旧许可'),
('A082-10','CN0342','site_current','再生及新剂水站','independent_water_search','L082-10',NULL,'2026-11-28','no_new','无','无',NULL,'2026-12-28','政府环评或验收','未发现可读新工艺');
INSERT INTO research_document_review(site_id,source_id,scope_key,gap,reviewed_on,state,locator,remaining_work,next_check_on,attempt_id) VALUES
('CN0341','S082-01','coal_catalyst_historical','历史产能及废水工艺','2026-11-28','section_done','1-1-137–138,169','现行验收及设备清单',NULL,'A082-01'),
('CN0341','S082-02','site_current','园区水量及排水','2026-11-28','section_done','表3.6-1/4.2-1','原表图页、现行许可执行报告',NULL,'A082-02'),
('CN0010','W03S01','site_current','现行运行报告','2026-11-28','blocked','原报告入口','可读附件','2026-12-28','A082-04'),
('CN0022','W15S07','site_current','共享站现行运行','2026-11-28','blocked','原报告入口','可读附件','2026-12-28','A082-05'),
('CN0280','S035-03','site_current','现行运行及膜','2026-11-28','blocked','原报告入口','可读附件','2026-12-28','A082-06'),
('CN0083','S018-009','site_current','共享站运行','2026-11-28','blocked','原报告入口','可读附件','2026-12-28','A082-07');
COMMIT;
