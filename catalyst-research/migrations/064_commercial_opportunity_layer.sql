-- 064 commercial opportunity layer; existing factual records remain untouched.
PRAGMA foreign_keys=ON;
BEGIN;
CREATE TABLE commercial_opportunity_screen (
 site_id TEXT PRIMARY KEY REFERENCES sites(site_id),
 anchor_water_id TEXT NOT NULL REFERENCES wastewater(water_id),
 priority_band TEXT NOT NULL CHECK(priority_band IN ('A','B')),
 opportunity_type TEXT NOT NULL,
 evidence_signal TEXT NOT NULL,
 outreach_hypothesis TEXT NOT NULL,
 qualification_gap TEXT NOT NULL,
 source_id TEXT NOT NULL,
 assessment_date TEXT NOT NULL,
 FOREIGN KEY(site_id,source_id) REFERENCES site_sources(site_id,source_id)
);
INSERT INTO commercial_opportunity_screen VALUES
('CN0026','W059-04','A','capacity_retrofit','2025在用二期2000t/d负荷100–130%；5200设计替代、未识别三期膜','优先核三期切换、二期膜及预处理运行成本；切换前后分别提出降本或回用试验','三期采购合同、实际负荷、浓水去向及EHS/工程部门','S059-01','2026-11-28'),
('CN0309','W056-06','A','new_build_retrofit','历史400t/d及高浓100t/d，1000t/d替代设计；现有三效及高级氧化','核扩容实施节点及高浓分股减蒸发；已有采购/技术渠道先转工程部门','1000站实际建设、蒸汽用量、盐种、废液结算','S056-01','2026-11-28'),
('CN0098','W0029','A','evaporation_reduction','2024报告铜系源强107320.778m³/a；蒸氨和三效既有设备及报告实际处理能力','以铜系分股做汽提/蒸发负荷优化和盐回收对比；南通厂业务渠道转接','源强非实际蒸发入料，核蒸汽、盐与金属平衡和当年运行成本','turn127831search84','2026-11-28'),
('CN0003','W0105','A','resource_recovery','2019历史共享200t/h站，ED/BMED盐酸及TPAOH回收，2024在线历史资料','针对母液/高氨支路和已有膜优化；核再生技改投运','实际分股进料、膜系统供应商/寿命、共享站费用归属','W01B2S04','2026-11-28'),
('CN0002','W013-020','A','ammonia_cost','历史50t/h高氨汽提标定，16.3元/t历史净处理成本；2026药剂采购线索','以高氨分股的全成本及副产物回收作对比；采购公告渠道仅按用途转接','2010成本已过时，核现行汽/酸/硫铵收益及处理量','turn699489search95','2026-11-28'),
('CN0202','W0150','A','procurement_followup','2026铜系38t/h工艺水循环EPC中标约1640万元，非污水排放量','核中标包及承包商，优先分包、技术联调或后续优化而非假设仍可投标','工艺水属性、包范围、中标方、验收及后续技改窗口','W03S11','2026-11-28'),
('CN0028','W039-25','A','ammonia_cost','2026H1站正常运行披露，高氨汽提；既有分子筛滤洗水设计量','先核高氨/低氨分股和汽提经济性，补生产/EHS工作渠道','实际分股流量、汽提蒸汽及药剂、历史蒸发支路是否仍在','S039-06','2026-11-28'),
('CN0127','W060-10','A','procurement_followup','2026膜浓缩与MVR扩建；膜设备181.4952万中标，验收服务采购','现有膜供应商已中标，核性能承诺、运行成本和后续备件/改造窗口','实际膜类型、能耗、母液处置及验收，不假设采购尚开放','W06S01','2026-11-28'),
('CN0139','W058-01','A','new_build_retrofit','2026设计MVR 2m³/h，浓盐液5042.91t/a危废设计量；185万设计投资','核新建进度，先做蒸发前减量与循环水回用两个独立场景','实际盐组成、危废属性和处置价格、MVR进料及合同','W03S18','2026-11-28'),
('CN0144','W060-20','A','new_build_retrofit','既有400m³/d站，2025分子筛技改高盐MVR/高氨回收，2026中试依托','查高盐/高氨分质技改落实，找技术、EHS及设备工程入口','MVR实际进料、蒸汽/回用成本、审批及建设','S045-08','2026-11-28'),
('CN0184','W027-H12024','A','metal_resource_recovery','2024实际重金属预处理分流及全厂混合排放，现有高盐MVR','按各金属支路评价选择性回收与减蒸发，不以全站流量算专线','实际混合排水边界、残液金属价值、处置及浓水合规','S027-05','2026-11-28'),
('CN0308','W054-17','A','evaporation_reduction','500m³/d共享站历史披露、含盐MVR，贵金属子项目2025结项','从公司公开业务入口转生产/环保工程；核贵金属、碘化物分股与MVR负荷','分股水量、盐/金属、共享成本、蒸发及危废处置费用','S054-05','2026-11-28'),
('CN0082','W013-001','B','installed_membrane_optimization','50m³/h CFRO 2023试车转固，资本化718.68万元；盐液原料回用','作为成本/竞争基准，核现有CFRO升级或更换周期','真实进水流量、通量/压力、硝酸钠质量、膜更换及吨成本','W13S01','2026-11-28'),
('CN0063','W0129','B','installed_membrane_optimization','30t/h再生站，历史验收MBR/两级RO/三效；2026运行自述','以已用膜站的能耗、清洗和浓水减量为切入点','实际流量、膜寿命、供应商、蒸发负荷和浓水','W01B2S22','2026-11-28'),
('CN0247','W047-04','B','new_build_retrofit','一期分子筛41.935m³/d设计工艺水，膜浓缩及蒸发、综合MBR；2026建成报道','查采购及投用，核新站性能与后续优化机会','现行膜规格、系统实际处理量、验收及承包商','S047-01','2026-11-28'),
('CN0077','W011-01','B','metal_resource_recovery','2022验收含铬132t/d及非含铬150t/d MBR，历史废水投资2500万元','分含铬物化回收和非含铬膜优化；先核现行系统与全球采购路径','铬去向、进出水水质、现行耗材和分股量','W11S01','2026-11-28'),
('CN0268','W032-03','B','ammonia_cost','2024园区汇总316m³/d；历史脱氨膜酸吸收回用','调查现有脱氨膜是否仍用、酸耗和铵盐回收，测试成本对比','历史膜非当前，分股实际流量、酸液去向及膜寿命','S031-01','2026-11-28'),
('CN0280','W035-03','B','installed_membrane_optimization','历史前处理120m³/d及再生150m³/d，有RO；提钛提钨扩建设计','查扩建验收和现有膜运行；按金属回收支流核经济性','实际规模、膜段与金属回收接口、浓水去向','S035-03','2026-11-28'),
('CN0019','W0114','B','new_build_retrofit','一期设计250t/d综合站，分质重金属；二期高盐专管','核一期/二期验收，优先重金属回收与高盐减量，不假定零排','站运行、分股负荷、园区纳管成本及回用标准','W01B2S09','2026-11-28'),
('CN0043','W046-26','B','metal_resource_recovery','贵金属精炼历史分质及蒸发膜回用，2024扩建拟批','核低量高价值贵金属回收与膜回用改造；区分厂区项目','现行精炼水量、贵金属浓度、已有膜和委外成本','S046-03','2026-11-28'),
('CN0102','W013-028','B','evaporation_reduction','2025拟建含氮磷1114m³/a蒸馏、其他15894m³/a纳集团','分开高浓蒸发和低浓公辅；核项目进度及集团处理费用','实际蒸发入料、氮磷盐、危废残液、集团结算','W13S04','2026-11-28'),
('CN0230','W0233','B','procurement_followup','共享100t/d站批复，2026废水工程中标575.18万','优先承包方/设备供应链及后续运维；核已签包范围','中标单位与验收、高浓分股实际、污水处理合同边界','W07S05','2026-11-28'),
('CN0251','W022-002','B','metal_resource_recovery','R32压滤水12m³/d既有描述；含铬水历史汽提/ED；新R113a另厂设计','分旧装置ED优化与独立新项目，分别核需求及项目归属','实际含铬/氟水量、膜运行、厂区及浓水盐处置','S022-001','2026-11-28'),
('CN0214','W0176','B','ammonia_cost','设计尾气吸收1000m³/a、蒸氨5t/h设计、低温蒸发回用','从公开公司渠道转环保/设备，核募投结项后投运及蒸氨经济性','实际水量、蒸汽及回收液、验收、独立站成本','W05S04','2026-11-28'),
('CN0288','W061-03','B','evaporation_reduction','2026申请称新建三效强制蒸发3t/h，未得验收','核盐水进料及蒸汽、冷凝水回用，试验膜前浓缩可行性','实际蒸发负荷、盐组成、蒸发盐属性及费用','S061-01','2026-11-28'),
('CN0110','W0027','B','installed_membrane_optimization','2021历史600t/d综合站MBR及120t/d高氨预处理；2024排口浓度','优先确认膜系统运行，分高氨预处理和末端回用成本','现行膜通量/清洗、实际流量、浓水出路、业务渠道','turn127831search7','2026-11-28'),
('CN0310','W056-08','B','capacity_retrofit','历史420m³/d站正常运行，子公司办公渠道','核内部工艺与技改报告；先由子公司渠道确认EHS/设备接口','现行分股流量、进水污染物、处理链及成本','S056-04','2026-11-28'),
('CN0221','W0191','B','procurement_followup','2026碱溶废水设备成交165万；2018生产生活水不外排披露','集团供应商平台核后续配套或运维机会；不将生活120m³/d作为生产水量','设备合同技术范围、处理规模、盐/金属、是否已投运','W05S18','2026-11-28'),
('CN0070','W027-05','B','capacity_retrofit','300m³/d设计站，169.74m³/d设计进站；2026报道生产活动','核真实投运、重金属预处理和可回用水；园区共享站费用独立','实际水量/水质、污水站验收、处置和回用标准','S027-01','2026-11-28'),
('CN0207','W0162','B','capacity_retrofit','全厂6000t/d共享站转载线索，2026催化材料技改验收公示','通过基地公开办公渠道核催化材料专属流量与共享站瓶颈','报告附件、真实专线流量和工艺、共享成本及部门','W03S29','2026-11-28');
-- A/B are researcher outreach triage, not verified buyer intent or engineering fit.
CREATE VIEW v_commercial_contact_coverage AS
SELECT site_id, count(*) AS public_channels,
 sum(CASE WHEN contact_scope='site' THEN 1 ELSE 0 END) AS site_channels,
 sum(CASE WHEN (department LIKE '%采购%' OR department LIKE '%技术%' OR department LIKE '%设备%' OR department LIKE '%环保%' OR upper(department) LIKE '%EHS%' OR department LIKE '%生产%' OR department LIKE '%工程%') AND department NOT LIKE '%公开%' AND department NOT LIKE '%投资者%' THEN 1 ELSE 0 END) AS role_channel_candidates
FROM business_contacts GROUP BY site_id;
CREATE VIEW v_commercial_market_overview AS
SELECT s.site_id,s.name,s.province,s.city,s.category,s.record_type,s.status,
 g.linked_url_sources,g.water_records,g.numeric_water_records,g.quality_point_records,g.diagram_count,g.operating_complete_diagrams,g.economics_records,
 coalesce(c.public_channels,0) AS public_channels,coalesce(c.site_channels,0) AS site_channels,coalesce(c.role_channel_candidates,0) AS role_channel_candidates,
 p.priority_band,p.opportunity_type,p.evidence_signal,p.outreach_hypothesis,p.qualification_gap,
 CASE WHEN s.record_type IN ('退出','销售/集团主体','研发项目') THEN 'scope_check'
 WHEN p.priority_band='A' THEN 'A_first_contact_research'
 WHEN p.priority_band='B' THEN 'B_qualification'
 WHEN s.record_type IN ('候选','集团/待拆分') THEN 'identity_scope_check'
 WHEN g.numeric_water_records>0 AND g.quality_point_records>0 AND g.diagram_count>0 THEN 'C_technical_prescreen'
 WHEN g.water_records>0 THEN 'D_quantify_opportunity'
 ELSE 'E_water_demand_unknown' END AS commercial_queue,
 r.public_disposition,r.next_gap,
 CASE WHEN g.numeric_water_records>0 AND g.quality_point_records>0 AND g.diagram_count>0 THEN 1 ELSE 0 END AS cross_scope_data_screen,
 '不等于同水流/时期可报价；需求、预算和技术适配均待核' AS caution
FROM sites s JOIN v_research_evidence_gaps g USING(site_id)
LEFT JOIN commercial_opportunity_screen p USING(site_id)
LEFT JOIN v_commercial_contact_coverage c USING(site_id)
LEFT JOIN v_public_research_queue r USING(site_id);
CREATE VIEW v_commercial_priority_30 AS
SELECT o.*,s.name,s.province,s.city,s.record_type,s.status,
 w.stream,w.stage,w.flow,w.flow_unit,w.flow_basis,w.process,w.destination,w.residuals,
 coalesce(c.public_channels,0) AS public_channels,coalesce(c.role_channel_candidates,0) AS role_channel_candidates,
 x.title AS evidence_title,x.url AS evidence_url,
 'INFERRED: 业务初筛；非已确认需求、报价或实际节约' AS assessment_boundary
FROM commercial_opportunity_screen o JOIN sites s USING(site_id)
JOIN wastewater w ON w.water_id=o.anchor_water_id AND w.site_id=o.site_id
JOIN sources x ON x.source_id=o.source_id
LEFT JOIN v_commercial_contact_coverage c USING(site_id);
-- Customer-specific economics: never infer actual throughput or costs from design capacity.
CREATE TABLE commercial_economic_scenarios (
 scenario_id TEXT PRIMARY KEY, site_id TEXT NOT NULL REFERENCES sites(site_id),
 water_id TEXT REFERENCES wastewater(water_id), scope_description TEXT NOT NULL,
 period TEXT, annual_comparable_volume REAL CHECK(annual_comparable_volume>=0),
 volume_unit TEXT CHECK(volume_unit IN ('t/a','m3/a')),
 old_cost_per_unit REAL CHECK(old_cost_per_unit>=0), new_cost_per_unit REAL CHECK(new_cost_per_unit>=0),
 unit_cost_boundary TEXT, annual_incremental_net_recovery REAL,
 incremental_capex_yuan REAL CHECK(incremental_capex_yuan>=0),
 input_class TEXT NOT NULL CHECK(input_class IN ('ACTUAL_VERIFIED','CUSTOMER_DISCLOSED','DESIGN_ESTIMATE','ASSUMPTION')),
 source_id TEXT REFERENCES sources(source_id), assumptions TEXT NOT NULL,
 CHECK(input_class!='ACTUAL_VERIFIED' OR source_id IS NOT NULL),
 CHECK((old_cost_per_unit IS NULL AND new_cost_per_unit IS NULL) OR (unit_cost_boundary IS NOT NULL AND volume_unit IS NOT NULL))
);
CREATE VIEW v_commercial_scenario_economics AS
SELECT *,
 CASE WHEN annual_comparable_volume IS NOT NULL AND old_cost_per_unit IS NOT NULL AND new_cost_per_unit IS NOT NULL AND annual_incremental_net_recovery IS NOT NULL
 THEN annual_comparable_volume*(old_cost_per_unit-new_cost_per_unit)+annual_incremental_net_recovery END AS scenario_annual_net_saving_yuan,
 CASE WHEN incremental_capex_yuan IS NOT NULL AND annual_comparable_volume*(old_cost_per_unit-new_cost_per_unit)+annual_incremental_net_recovery>0
 THEN incremental_capex_yuan/(annual_comparable_volume*(old_cost_per_unit-new_cost_per_unit)+annual_incremental_net_recovery) END AS scenario_simple_payback_years
FROM commercial_economic_scenarios;
COMMIT;
