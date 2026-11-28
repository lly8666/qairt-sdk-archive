-- 108: dated ownership/procurement refresh + more precise market navigation + practical workbench views.
PRAGMA foreign_keys=ON;
BEGIN;
INSERT INTO sources VALUES
('S108-02','贺利氏贵金属技术（中国）有限公司危险废物经营许可申请基本信息','https://njna.nanjing.gov.cn/njsjbxqglwyh/202401/P020240103361436867144.pdf','政府公开许可信息','2024-01-03','企业经济性质、经营地址、危险废物利用业务；历史性质，不替代最新工商穿透','2026-11-28'),
('S108-03','浙江能源集团智慧供应链一体化平台供应商注册页','https://zsrm.zjenergy.com.cn/register.html','企业官方采购平台','未标','供应商注册入口；注册不等于获得供应商资格或存在开放项目','2026-11-28'),
('S108-04','浙能催化剂废SCR脱硝催化剂再生利用扩建项目竣工环保验收项目采购公告','https://www.bidcenter.com.cn/newscontent-452584871-1.html','第三方采购公告转载','2026-11-10','采购范围、供应商业绩要求、供应链平台注册方式及2026-11-17报价截止时间','2026-11-28'),
('S108-05','山东博苑新材料股份有限公司2026年半年度报告','https://static.cninfo.com.cn/finalpage/2026-08-20/1225481767.PDF','巨潮资讯上市公司报告','2026-08-20','第六节股东情况；控股股东及实际控制人为李成林、于国清一致行动；报告期末2026-06-30','2026-11-28');
INSERT INTO site_sources VALUES
('CN0184','S108-02'),
('CN0127','S108-03'),
('CN0127','S108-04'),
('CN0308','S108-05');
INSERT INTO market_ownership_observations VALUES
('OW0018','MO0014','private_controlled','listed',NULL,'2026-11-20股份过户完成','evidence_linked','CN0026','S105-01','2026-11-20股份过户完成公告；结合2026-10-15实际控制人变更公告','实际控制人为李进；李查德与李进签署一致行动协议；股权过户完成；控制权与采购授权分别判断'),
('OW0019','MO0024','private_controlled','listed',NULL,'2026-06-30报告期末','evidence_linked','CN0308','S108-05','第六节股东情况及一致行动说明','李成林、于国清为控股股东及实际控制人并签署一致行动协议；潍坊鼎聚为李成林一致行动人；国资参股不等于国资控制'),
('OW0020','MO0019','foreign_controlled','unlisted',NULL,'2024-01-03政府许可信息；2025-09环评回顾','evidence_linked','CN0184','S108-02','企业经济性质栏；结合S027-05第1章','政府许可信息列经济性质为外资；2025环评说明投资方隶属德国贺利氏集团；未追踪穿透至最终股东的最新变更');
UPDATE market_entities SET address='南京化学工业园区赵桥河南路139号',province='江苏',city='南京',evidence_period='2024-01-03',source_id='S108-02',locator='政府许可申请基本情况',boundary='2024许可申请列经营场所地址；申请信息另列占地84000m²、总人数245人，不确认2026生产状态' WHERE entity_id='MF0011';
INSERT INTO capacity VALUES
('CP108-01','CN0184','HW02含贵金属催化剂/溶剂废物利用申报量',250,'t/a','许可申请申报经营数量','2024-01-03','危险废物经营许可申请；非产品产能或实际处理量','S108-02','申请表列含贵重金属催化剂、溶剂等医药废物利用量；不等于实际处理量'),
('CP108-02','CN0184','HW04含贵金属催化剂/吸附剂废物利用申报量',50,'t/a','许可申请申报经营数量','2024-01-03','危险废物经营许可申请；非产品产能或实际处理量','S108-02','申请表列农药废物利用量；不等于实际处理量'),
('CP108-03','CN0184','HW06含贵金属废催化剂/溶剂废物利用申报量',100,'t/a','许可申请申报经营数量','2024-01-03','危险废物经营许可申请；非产品产能或实际处理量','S108-02','申请表列含有机溶剂废物利用量；不等于实际处理量'),
('CP108-04','CN0184','HW11含贵金属废液/废渣利用申报量',100,'t/a','许可申请申报经营数量','2024-01-03','危险废物经营许可申请；非产品产能或实际处理量','S108-02','申请表列精蒸馏残渣利用量；不等于实际处理量');INSERT INTO market_procurement_observations VALUES
('PR0012','CN0127','MO0015','浙江浙能催化剂技术有限公司','废SCR脱硝催化剂再生利用扩建项目竣工环保验收服务','solicitation_historical','2026-11-10（截止2026-11-17）','S108-04','采购公告正文第3至6项','环保验收咨询服务，不是废水处理设备或膜采购；报价截止已过；要求2021-07以来至少1项环保咨询合同业绩，公告列资质/人员无要求','未来参加浙能采购需先完成供应商平台注册；若公司缺少环保咨询业绩，应寻找有对应业绩的合作方；此标不能当成膜设备订单');
INSERT INTO business_contacts VALUES
('BC069-01','CN0127','浙江浙能催化剂技术有限公司','external_procurement','浙能集团供应商注册平台',NULL,'供应商注册及电子投标入口','supplier_portal','https://zsrm.zjenergy.com.cn/register.html','S108-03','官方平台供应商注册页',NULL,'2026-11-28','official_publication','平台注册不代表取得供应商资格或当前存在开放项目；具体准入和标段条件以采购文件为准');
DROP VIEW v_workbench_priority;
DROP VIEW v_workbench_candidates;
DROP VIEW v_workbench_water_signals;
DROP TABLE market_screen_terms;
CREATE TABLE market_screen_terms (
 direction TEXT NOT NULL,
 field_scope TEXT NOT NULL CHECK(field_scope IN ('water','process','destination')),
 term TEXT NOT NULL,
 signal_strength TEXT NOT NULL CHECK(signal_strength IN ('direct','contextual')),
 PRIMARY KEY(direction,field_scope,term)
);
INSERT INTO market_screen_terms VALUES
('high_salt','water','高盐','direct'),
('high_salt','water','含盐','direct'),
('high_salt','water','盐水','direct'),
('high_salt','water','硫酸钠','direct'),
('high_salt','water','硝酸钠','direct'),
('high_salt','water','氯化钠','direct'),
('high_salt','water','母液','contextual'),
('ammonia','water','高氨','direct'),
('ammonia','water','氨氮','direct'),
('ammonia','water','氯化铵','direct'),
('ammonia','water','硫酸铵','direct'),
('ammonia','water','铵盐','contextual'),
('ammonia','water','氨水','contextual'),
('metal_recovery','water','贵金属','direct'),
('metal_recovery','water','重金属','direct'),
('metal_recovery','water','含铬','direct'),
('metal_recovery','water','含镍','direct'),
('metal_recovery','water','含铜','direct'),
('metal_recovery','water','含钒','direct'),
('metal_recovery','water','含钨','direct'),
('metal_recovery','water','含钼','direct'),
('metal_recovery','water','含钯','direct'),
('metal_recovery','water','含铂','direct'),
('metal_recovery','water','金属离子','direct'),
('organic','water','高浓有机','direct'),
('organic','water','高有机','direct'),
('organic','water','有机废水','direct'),
('organic','water','高COD','direct'),
('organic','water','高浓度COD','direct'),
('organic','water','溶剂','contextual'),
('evaporation','process','MVR','direct'),
('evaporation','process','多效','direct'),
('evaporation','process','三效','direct'),
('evaporation','process','浓缩结晶','direct'),
('evaporation','process','蒸发','contextual'),
('reuse','destination','回用','direct'),
('reuse','destination','零排放','direct'),
('reuse','process','回收水','contextual'),
('reuse','process','中水','contextual'),
('external_disposal','destination','委外','direct'),
('external_disposal','destination','外委','direct'),
('external_disposal','destination','危废','direct'),
('external_disposal','destination','委托处置','direct'),
('membrane_optimization','process','反渗透','direct'),
('membrane_optimization','process','RO膜','direct'),
('membrane_optimization','process','纳滤','direct'),
('membrane_optimization','process','超滤','direct'),
('membrane_optimization','process','膜浓缩','direct'),
('membrane_optimization','process','CFRO','direct'),
('membrane_optimization','process','MBR','direct'),
('membrane_optimization','process','电渗析','direct'),
('membrane_optimization','process','双极膜','direct'),
('membrane_optimization','process','BMED','direct'),
('membrane_optimization','process','ED系统','direct'),
('membrane_optimization','process','UF膜','direct'),
('membrane_optimization','process','RO系统','direct'),
('membrane_optimization','process','DTRO','direct'),
('membrane_optimization','process','STRO','direct'),
('membrane_optimization','process','NF膜','direct'),
('membrane_optimization','process','反渗透系统','direct');
CREATE VIEW v_workbench_water_signals AS
SELECT w.site_id,w.water_id,t.direction,w.source_id,w.stage,w.stream,w.flow,w.flow_unit,w.flow_basis,w.pollutants,w.process,w.destination,w.residuals,
 group_concat(t.term,'、') AS matched_terms,
 CASE WHEN max(CASE WHEN t.signal_strength='direct' THEN 1 ELSE 0 END)=1 THEN 'direct' ELSE 'contextual' END AS signal_strength
FROM wastewater w JOIN market_screen_terms t ON
 CASE t.field_scope
  WHEN 'water' THEN instr(lower(coalesce(w.stream,'')||' '||coalesce(w.pollutants,'')),lower(t.term))
  WHEN 'process' THEN instr(lower(coalesce(w.process,'')),lower(t.term))
  WHEN 'destination' THEN instr(lower(coalesce(w.destination,'')),lower(t.term))
 END>0
GROUP BY w.water_id,t.direction;
DROP VIEW v_workbench_equipment;
CREATE VIEW v_workbench_equipment AS
SELECT r.site_id,u.unit_id,u.technology,u.unit_label,u.role,u.feed,u.permeate_destination,u.concentrate_destination,u.specification,
 r.stage,r.period,r.application_boundary,r.presence,u.source_id,u.locator,
 CASE WHEN upper(u.technology) IN ('RO','DTRO','CFRO','NF','UF','MF') THEN 'pressure_membrane'
      WHEN upper(u.technology) IN ('ED','BMED','EDI') THEN 'electro_membrane'
      WHEN upper(u.technology)='MBR' THEN 'bioreactor_membrane'
      ELSE 'other_membrane' END AS technology_family
FROM v_membrane_evidence_boundaries r JOIN membrane_units u USING(review_id);
CREATE VIEW v_workbench_economics AS
SELECT e.*,
 CASE WHEN item LIKE '%中标%' OR item LIKE '%合同%' OR item LIKE '%采购%' THEN 'procurement_reference'
      WHEN item LIKE '%投资%' OR item LIKE '%资本%' OR item LIKE '%安装%' OR item LIKE '%设备%' OR item LIKE '%预算%' THEN 'investment_reference'
      WHEN item LIKE '%收益%' OR item LIKE '%节约%' OR item LIKE '%效益%' OR item LIKE '%收入%' THEN 'benefit_reference'
      WHEN item LIKE '%运行%' OR item LIKE '%处理成本%' OR item LIKE '%处理费%' OR item LIKE '%电耗%' OR item LIKE '%药耗%' OR item LIKE '%能耗%' OR item LIKE '%原材料费%' THEN 'operating_reference'
      ELSE 'other_reference' END AS economics_group,
 CASE WHEN unit IN ('元/m³','元/t','元/t高氨氮废水','kWh/t','kg/t') THEN 'unit_reference_requires_same_scope_and_period'
      WHEN unit IN ('万元','元') THEN 'capital_or_contract_not_unit_cost'
      ELSE 'context_only' END AS comparability
FROM water_economics e;
CREATE VIEW v_workbench_candidates AS
WITH tags AS (
 SELECT site_id,direction,count(DISTINCT water_id) AS water_records,
  count(DISTINCT CASE WHEN signal_strength='direct' THEN water_id END) AS direct_water_records,
  count(DISTINCT CASE WHEN signal_strength='contextual' THEN water_id END) AS contextual_water_records
 FROM v_workbench_water_signals GROUP BY site_id,direction
), seeds AS (
 SELECT site_id,CASE opportunity_type WHEN 'evaporation_reduction' THEN 'evaporation' WHEN 'ammonia_cost' THEN 'ammonia' WHEN 'metal_resource_recovery' THEN 'metal_recovery' WHEN 'resource_recovery' THEN 'resource_recovery' WHEN 'installed_membrane_optimization' THEN 'membrane_optimization' ELSE opportunity_type END AS direction,priority_band,evidence_signal,qualification_gap FROM commercial_opportunity_screen
), keys AS (SELECT site_id,direction FROM tags UNION SELECT site_id,direction FROM seeds)
SELECT k.site_id||':'||k.direction AS candidate_id,k.site_id,k.direction,coalesce(t.water_records,0) AS water_records,
 coalesce(t.direct_water_records,0) AS direct_water_records,coalesce(t.contextual_water_records,0) AS contextual_water_records,
 s.priority_band,s.evidence_signal,s.qualification_gap,'research_signal_not_confirmed_demand' AS state
FROM keys k LEFT JOIN tags t USING(site_id,direction) LEFT JOIN seeds s USING(site_id,direction);
CREATE VIEW v_workbench_priority AS
SELECT s.*, (SELECT count(*) FROM v_workbench_candidates c WHERE c.site_id=s.site_id) AS direction_count,
 CASE WHEN subject_scope IN ('candidate','inactive','organization','research','unresolved') THEN 'scope_review'
 WHEN seed_count>0 THEN 'seed_review'
 WHEN EXISTS(SELECT 1 FROM v_workbench_candidates c WHERE c.site_id=s.site_id) AND contact_count>0 THEN 'signal_and_channel'
 WHEN EXISTS(SELECT 1 FROM v_workbench_candidates c WHERE c.site_id=s.site_id) THEN 'signal_review'
 ELSE 'water_evidence_gap' END AS research_queue
FROM v_workbench_subjects s;
DROP VIEW v_workbench_contact_routes;
CREATE VIEW v_workbench_contact_routes AS
SELECT contact_id,site_id,organization,contact_scope,department,channel_type,
 CASE WHEN ((contact_scope IN ('company','group','site') AND verification_status='official_publication')
       OR (contact_scope='external_procurement' AND channel_type='supplier_portal' AND verification_status='official_publication'))
 AND channel_type IN ('work_phone','business_email','official_form','supplier_portal')
 AND (department NOT LIKE '%投资者%' AND department NOT LIKE '%披露%' AND department NOT LIKE '%监督%' AND department NOT LIKE '%公众参与%' AND department NOT LIKE '%环评%')
 AND (use_boundary NOT LIKE '%仅投资者%' AND use_boundary NOT LIKE '%公众参与%' AND use_boundary NOT LIKE '%监督用途%' AND use_boundary NOT LIKE '%披露电话%')
 AND (public_name IS NULL OR trim(public_name)='') THEN channel_value ELSE NULL END AS public_work_channel,
 verification_status,use_boundary,source_id FROM business_contacts;
COMMIT;
