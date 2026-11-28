PRAGMA foreign_keys=ON;
BEGIN;
INSERT INTO capacity(capacity_id,site_id,product,value,unit,basis,period,scope,source_id,notes) VALUES
('C089-01','CN0019','废FCC/DCC催化剂处理',13000,'t/a','环评批复设计分项','2023-01','二期废剂装置','W01B2S10','属于30000t/a总量，不重复累计'),
('C089-02','CN0019','废贵金属铂系催化剂处理',3000,'t/a','环评批复设计分项','2023-01','二期废剂装置','W01B2S10','非实际'),
('C089-03','CN0019','废银催化剂处理',1500,'t/a','环评批复设计分项','2023-01','二期废剂装置','W01B2S10','非实际'),
('C089-04','CN0019','待生加氢催化剂再生',12500,'t/a','环评批复设计分项','2023-01','二期废剂装置','W01B2S10','非实际');
UPDATE wastewater SET destination='预处理后作为含盐废水经专管排入西部污水厂生化后构筑物，与尾水混合排海（批复设计）',notes=COALESCE(notes,'')||'；089核批复第2页，现行投运待核' WHERE water_id IN ('W0118','W0119');
INSERT INTO wastewater(water_id,site_id,stream,stage,flow,flow_unit,flow_basis,pollutants,process,destination,residuals,source_id,confidence,notes) VALUES
('W089-01','CN0187','项目接管总排水','2025环评批复设计',61560,'t/a','批复第七条核定年水量上限','COD、氨氮、总氮、总磷、SS、全盐量','生活预处理和公辅水合流，工艺水分质回用','园区污水厂',NULL,'S030-08','WEB_PRIMARY','第6页截图；不是实际水量或两工艺站进水量');
INSERT INTO water_metrics(metric_id,site_id,water_id,point,metric,value_num,value_text,unit,result_kind,statistic,period,detection_limit,standard_max,source_id,notes) VALUES
('M089-001','CN0187','W089-01','厂区接管','COD',18.31,NULL,'t/a','审批总量上限','年总量','2025-11环评批复',NULL,18.31,'S030-08','第7条第6页；不同边界不相加；非实际或浓度'),
('M089-002','CN0187','W089-01','厂区接管','氨氮',1.22,NULL,'t/a','审批总量上限','年总量','2025-11环评批复',NULL,1.22,'S030-08','第7条第6页；不同边界不相加；非实际或浓度'),
('M089-003','CN0187','W089-01','厂区接管','总氮',2.03,NULL,'t/a','审批总量上限','年总量','2025-11环评批复',NULL,2.03,'S030-08','第7条第6页；不同边界不相加；非实际或浓度'),
('M089-004','CN0187','W089-01','厂区接管','总磷',0.17,NULL,'t/a','审批总量上限','年总量','2025-11环评批复',NULL,0.17,'S030-08','第7条第6页；不同边界不相加；非实际或浓度'),
('M089-005','CN0187','W089-01','厂区接管','SS',14.08,NULL,'t/a','审批总量上限','年总量','2025-11环评批复',NULL,14.08,'S030-08','第7条第6页；不同边界不相加；非实际或浓度'),
('M089-006','CN0187','W089-01','厂区接管','全盐量',16.56,NULL,'t/a','审批总量上限','年总量','2025-11环评批复',NULL,16.56,'S030-08','第7条第6页；不同边界不相加；非实际或浓度'),
('M089-007','CN0187','W089-01','环境排放核定','COD',3.08,NULL,'t/a','审批总量上限','年总量','2025-11环评批复',NULL,3.08,'S030-08','第7条第6页；不同边界不相加；非实际或浓度'),
('M089-008','CN0187','W089-01','环境排放核定','氨氮',0.31,NULL,'t/a','审批总量上限','年总量','2025-11环评批复',NULL,0.31,'S030-08','第7条第6页；不同边界不相加；非实际或浓度'),
('M089-009','CN0187','W089-01','环境排放核定','总氮',0.92,NULL,'t/a','审批总量上限','年总量','2025-11环评批复',NULL,0.92,'S030-08','第7条第6页；不同边界不相加；非实际或浓度'),
('M089-010','CN0187','W089-01','环境排放核定','总磷',0.03,NULL,'t/a','审批总量上限','年总量','2025-11环评批复',NULL,0.03,'S030-08','第7条第6页；不同边界不相加；非实际或浓度'),
('M089-011','CN0187','W089-01','环境排放核定','SS',1.23,NULL,'t/a','审批总量上限','年总量','2025-11环评批复',NULL,1.23,'S030-08','第7条第6页；不同边界不相加；非实际或浓度'),
('M089-012','CN0187','W089-01','环境排放核定','全盐量',16.56,NULL,'t/a','审批总量上限','年总量','2025-11环评批复',NULL,16.56,'S030-08','第7条第6页；不同边界不相加；非实际或浓度');
INSERT INTO process_diagrams(diagram_id,site_id,scope_key,stage,period,revision,coverage,mermaid,source_id,boundaries,gaps,updated_on) VALUES
('D089-01','CN0019','phase2-segregation','design','2023',2,'partial','flowchart TD
 A["废银及银离心 废铂废银喷淋"] --> B["1号混凝沉淀 反应沉淀 树脂吸附"] --> C["三效蒸发 后续待核"]
 D["其他涉重水"] --> E["2号混凝沉淀 反应沉淀 树脂吸附"] --> F["新综合站"] --> G["纳管"]
 H["高硅水"] --> I["压滤 反应沉淀"] --> N["含盐水专管"]
 J["高氨氮水"] --> K["负压汽提"] --> N
 L["Y/ZSM-5及氨回收含盐水"] --> M["压滤 中和"] --> N
 N --> O["西部污水厂生化后构筑物"] --> P["混合园区尾水 排海"]
 Q["其他废水"] --> F','W01B2S10','批复第2–3页；高硅及高氨氮按预处理后作为含盐水排放；不擅自连1号蒸发后去向','运行阶段、分股实际流量、膜、蒸发费用','2026-11-28');
INSERT INTO process_diagram_evidence(evidence_id,diagram_id,water_id,source_id,locator,element_ids,detail) VALUES
('DE089-01','D089-01','W0116','W01B2S10','批复第2页截图','A,B,C','1号涉重水范围'),
('DE089-02','D089-01','W0117','W01B2S10','批复第2–3页','D,E,F,G,Q','2号涉重及其他水入综合站'),
('DE089-03','D089-01','W0118','W01B2S10','批复第2页截图','H,I,N,O,P','高硅处理及含盐水支路'),
('DE089-04','D089-01','W0119','W01B2S10','批复第2页截图','J,K,N,O,P','高氨氮负压汽提及含盐水支路'),
('DE089-05','D089-01','W0120','W01B2S10','批复第2页截图','L,M,N,O,P','盐水专管不经园区生化单元，混尾水排海');
INSERT INTO membrane_reviews(review_id,site_id,diagram_id,scope_key,stage,period,revision,presence,source_id,evidence_basis,gaps,updated_on) VALUES
('R089-01','CN0019','D089-01','phase2-segregation','design','2023',2,'not_identified','W01B2S10','批复设计列沉淀树脂三效蒸发和盐水专管；未识别膜，不等于实际无膜','实际工艺和分流量、浓水条件、成本','2026-11-28');
INSERT INTO membrane_retrofits(assessment_id,review_id,site_id,scope_key,option_key,revision,objective,proposed_route,feasibility,hard_constraints,evidence_basis,assumptions,missing_inputs,validation_plan,alternatives,feed_risk,pretreatment_risk,concentrate_risk,integration_risk,operational_risk,compliance_economics_risk,score_basis,updated_on) VALUES
('A089-01','R089-01','CN0019','phase2-segregation','screening',2,'分流预处理与膜减量初筛','按重金属、高硅、高氨、盐分分别核实实际预处理出水；仅在回用需求及浓液合法去向明确时比较NF/RO和现有蒸发/汽提，避免高硅结垢及氨穿透','conditional','现行批复、排口、浓液去向及回用需求须确认','D089-01及批复截图，候选推断','非当前安装膜证明','实际流量、pH、金属、硅、氨、盐度、蒸发能耗及盐处置费','采样、膜兼容性试验、盐水平衡、全成本比较','保留分质预处理、汽提、蒸发及合法排放',NULL,NULL,NULL,NULL,NULL,NULL,'缺实际六维数据，不评分','2026-11-28');
INSERT INTO evidence_notes(note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES
('N089-01','CN0019','W01B2S10','二期规模及含盐支路闭合','2023-01-17批复第1–3页，p2截图','废剂处理13000+3000+1500+12500=30000t/a；高硅压滤反应沉淀、高氨氮负压汽提预处理后作为含盐废水排放，专管进入园区西部污水处理厂生化后构筑物混尾水排海。其他涉重水经2号进入综合站，1号含银及铂银喷淋废水处理至三效蒸发；蒸发后去向未明确。原D011-08修订，非在产。','WEB_PRIMARY','WEB_TEXT','2026-11-28'),
('N089-02','CN0187','S030-08','正式批复接管及环境排放总量','批复第2、6页截图','33m³/d及150m³/d两系统旧录，不重复；新取核定总水量≤61560t/a、6项接管/环境排放年总量，各边界分别记录；非工艺水产生量、实测或膜进水。','WEB_PRIMARY','WEB_TEXT','2026-11-28');
INSERT INTO search_log(log_id,site_id,work_package,query,source_id,result,next_action,search_date) VALUES
('L089-01','CN0019','089正式批复核查 document:approval_p2','phase2-segregation 高硅及高氨氮排放边界','W01B2S10','原文与截图第2页','验收/运行报告','2026-11-28'),
('L089-02','CN0187','089正式批复核查 document:approval_p6','salt-recovery 接管及环境排放总量','S030-08','原件扫描第6页','实际排口运行/验收','2026-11-28'),
('L089-03','CN0187','089正式批复核查 document:approval_p2','salt-recovery 处理规模及分流','S030-08','第2页扫描核，原规模已录','新验收','2026-11-28'),
('L089-04','CN0185','089正式批复核查 document:approval_pdf','site_current 正式批复原件','S035-09','PDF无法访问','可读官方新入口','2026-11-28'),
('L089-05','CN0062','089正式批复核查 document:full_pdf','site_current 扩建环评原件','S018-003','企业PDF超时','可读新入口或验收','2026-11-28');
INSERT INTO research_revisit_attempts(attempt_id,site_id,scope_key,gap,route_key,search_log_id,source_id,checked_on,outcome,gained_fields,evidence_refs,effort_minutes,next_check_on,reopen_trigger,rationale) VALUES
('A089-01','CN0019','phase2-segregation','高硅及高氨氮排放边界','document:approval_p2','L089-01','W01B2S10','2026-11-28','engineering_gain','2支路目的地、4产能分项、修订图','D089-01/C089-01–04',NULL,NULL,'验收/运行报告','原文与截图第2页'),
('A089-02','CN0187','salt-recovery','接管及环境排放总量','document:approval_p6','L089-02','S030-08','2026-11-28','engineering_gain','1水量上限及12质量上限','W089-01/M089-001–012',NULL,NULL,'实际排口运行/验收','原件扫描第6页'),
('A089-03','CN0187','salt-recovery','处理规模及分流','document:approval_p2','L089-03','S030-08','2026-11-28','duplicate','无','W030-06–08/D030-04',NULL,NULL,'新验收','第2页扫描核，原规模已录'),
('A089-04','CN0185','site_current','正式批复原件','document:approval_pdf','L089-04','S035-09','2026-11-28','access_blocked','无','无',NULL,'2026-12-28','可读官方新入口','PDF无法访问'),
('A089-05','CN0062','site_current','扩建环评原件','document:full_pdf','L089-05','S018-003','2026-11-28','access_blocked','无','无',NULL,'2026-12-28','可读新入口或验收','企业PDF超时');
INSERT INTO research_document_review(site_id,source_id,scope_key,gap,reviewed_on,state,locator,remaining_work,next_check_on,attempt_id) VALUES
('CN0019','W01B2S10','phase2-segregation','高硅及高氨氮排放边界','2026-11-28','section_done','原文与截图第2页','验收/运行报告',NULL,'A089-01'),
('CN0187','S030-08','salt-recovery','接管及环境排放总量','2026-11-28','section_done','原件扫描第6页','实际排口运行/验收',NULL,'A089-02'),
('CN0187','S030-08','salt-recovery','处理规模及分流','2026-11-28','section_done','第2页扫描核，原规模已录','新验收',NULL,'A089-03'),
('CN0185','S035-09','site_current','正式批复原件','2026-11-28','blocked','PDF无法访问','可读官方新入口','2026-12-28','A089-04'),
('CN0062','S018-003','site_current','扩建环评原件','2026-11-28','blocked','企业PDF超时','可读新入口或验收','2026-12-28','A089-05');
COMMIT;
