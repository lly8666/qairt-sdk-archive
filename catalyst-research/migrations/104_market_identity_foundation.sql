-- 104: additive market identity layer; never rewrite legacy fact rows.
PRAGMA foreign_keys=ON;
BEGIN;
CREATE TABLE market_entities (
 entity_id TEXT PRIMARY KEY,
 entity_kind TEXT NOT NULL CHECK(entity_kind IN ('organization','facility','project')),
 name TEXT NOT NULL CHECK(length(trim(name))>0),
 province TEXT, city TEXT, address TEXT,
 lifecycle TEXT NOT NULL CHECK(lifecycle IN ('historical','design','built','operating','unknown')),
 evidence_period TEXT NOT NULL,
 anchor_site_id TEXT NOT NULL, source_id TEXT NOT NULL,
 locator TEXT NOT NULL, boundary TEXT NOT NULL,
 FOREIGN KEY(anchor_site_id,source_id) REFERENCES site_sources(site_id,source_id)
);
CREATE TABLE market_identity_links (
 link_id TEXT PRIMARY KEY,
 site_id TEXT NOT NULL, entity_id TEXT NOT NULL REFERENCES market_entities(entity_id),
 link_role TEXT NOT NULL CHECK(link_role IN ('legal_subject','physical_site','project_scope','group_scope','candidate')),
 link_state TEXT NOT NULL CHECK(link_state IN ('evidence_linked','candidate','disputed','superseded')),
 evidence_period TEXT NOT NULL, source_id TEXT NOT NULL,
 locator TEXT NOT NULL, boundary TEXT NOT NULL,
 UNIQUE(site_id,entity_id,link_role,evidence_period),
 FOREIGN KEY(site_id,source_id) REFERENCES site_sources(site_id,source_id)
);
CREATE TRIGGER market_identity_kind_insert BEFORE INSERT ON market_identity_links
WHEN NOT EXISTS (SELECT 1 FROM market_entities e WHERE e.entity_id=NEW.entity_id AND
 (NEW.link_role='candidate' OR (NEW.link_role IN ('legal_subject','group_scope') AND e.entity_kind='organization') OR
 (NEW.link_role='physical_site' AND e.entity_kind='facility') OR (NEW.link_role='project_scope' AND e.entity_kind='project')))
BEGIN SELECT RAISE(ABORT,'identity link role/entity kind mismatch'); END;
CREATE TRIGGER market_identity_kind_update BEFORE UPDATE ON market_identity_links
WHEN NOT EXISTS (SELECT 1 FROM market_entities e WHERE e.entity_id=NEW.entity_id AND
 (NEW.link_role='candidate' OR (NEW.link_role IN ('legal_subject','group_scope') AND e.entity_kind='organization') OR
 (NEW.link_role='physical_site' AND e.entity_kind='facility') OR (NEW.link_role='project_scope' AND e.entity_kind='project')))
BEGIN SELECT RAISE(ABORT,'identity link role/entity kind mismatch'); END;
CREATE TRIGGER market_entity_kind_immutable BEFORE UPDATE OF entity_kind ON market_entities
WHEN OLD.entity_kind<>NEW.entity_kind
BEGIN SELECT RAISE(ABORT,'entity kind immutable; use a new entity and mapping'); END;
CREATE TABLE market_entity_relations (
 relation_id TEXT PRIMARY KEY,
 from_entity_id TEXT NOT NULL REFERENCES market_entities(entity_id),
 to_entity_id TEXT NOT NULL REFERENCES market_entities(entity_id),
 relation_kind TEXT NOT NULL CHECK(relation_kind IN ('operated_by','planned_operator','subsidiary_of','located_at','planned_at','replacement_for','shared_site','other')),
 evidence_stage TEXT NOT NULL CHECK(evidence_stage IN ('historical','design','built','operating','unknown')),
 evidence_period TEXT NOT NULL, legacy_relation_id TEXT NOT NULL REFERENCES site_relations(relation_id),
 anchor_site_id TEXT NOT NULL, source_id TEXT NOT NULL,
 locator TEXT NOT NULL, boundary TEXT NOT NULL,
 CHECK(from_entity_id<>to_entity_id),
 UNIQUE(from_entity_id,to_entity_id,relation_kind,evidence_period),
 FOREIGN KEY(anchor_site_id,source_id) REFERENCES site_sources(site_id,source_id)
);
CREATE TABLE market_ownership_observations (
 observation_id TEXT PRIMARY KEY,
 organization_id TEXT NOT NULL REFERENCES market_entities(entity_id),
 ownership_class TEXT NOT NULL CHECK(ownership_class IN ('central_state_controlled','local_state_controlled','private_controlled','foreign_controlled','mixed_control_unclear','other','unknown')),
 listed_status TEXT NOT NULL CHECK(listed_status IN ('listed','unlisted','unknown')),
 controlling_entity_id TEXT REFERENCES market_entities(entity_id),
 effective_period TEXT NOT NULL,
 evidence_state TEXT NOT NULL CHECK(evidence_state IN ('evidence_linked','candidate','disputed','superseded')),
 anchor_site_id TEXT NOT NULL, source_id TEXT NOT NULL, locator TEXT NOT NULL, boundary TEXT NOT NULL,
 FOREIGN KEY(anchor_site_id,source_id) REFERENCES site_sources(site_id,source_id)
);
CREATE TRIGGER market_ownership_kind_insert BEFORE INSERT ON market_ownership_observations
WHEN NOT EXISTS (SELECT 1 FROM market_entities WHERE entity_id=NEW.organization_id AND entity_kind='organization')
 OR (NEW.controlling_entity_id IS NOT NULL AND NOT EXISTS(SELECT 1 FROM market_entities WHERE entity_id=NEW.controlling_entity_id AND entity_kind='organization'))
BEGIN SELECT RAISE(ABORT,'ownership requires organization'); END;
CREATE TRIGGER market_ownership_kind_update BEFORE UPDATE ON market_ownership_observations
WHEN NOT EXISTS (SELECT 1 FROM market_entities WHERE entity_id=NEW.organization_id AND entity_kind='organization')
 OR (NEW.controlling_entity_id IS NOT NULL AND NOT EXISTS(SELECT 1 FROM market_entities WHERE entity_id=NEW.controlling_entity_id AND entity_kind='organization'))
BEGIN SELECT RAISE(ABORT,'ownership requires organization'); END;
-- Reuse explicit legacy evidence only; periods do not assert current existence, control or operation.
INSERT INTO market_entities VALUES
('MO0001','organization','庄信万丰（上海）化工有限公司',NULL,NULL,NULL,'historical','2019-07','CN0256','S027-09','第13项 X2SH201907250038','历史同一法人两厂区；当前工商及控制权待核'),
('MF0001','facility','庄信万丰东兴路厂区','上海','上海','松江东兴路588、598号','historical','2019-07','CN0085','S027-09','第13项 X2SH201907250038','历史厂区；不将荣乐东路证据移入'),
('MF0002','facility','庄信万丰荣乐东路厂区','上海','上海','松江区荣乐东路298号','historical','2019-07','CN0256','S027-09','第13项 X2SH201907250038','历史厂区；现行状态未核'),
('MO0002','organization','江苏瑞孚再生资源有限公司',NULL,NULL,NULL,'historical','2024-06-19','CN0296','S042-02','拟审查公示','原报告同一主体迁建；不判定2026经营或控制权'),
('MF0003','facility','江苏瑞孚北厂区','江苏','泰州','姜堰区俞垛镇；门牌待核','historical','2024-06-19','CN0296','S042-02','拟审查公示','既有纯回收厂区；实际停产拆除待核'),
('MF0004','facility','江苏瑞孚南厂拟建厂址','江苏','泰州','姜堰区俞垛镇俞东河东侧、万鑫路北侧（原泰州市鑫鑫化工地块）','design','2024-06-19','CN0297','S042-02','拟审查公示','拟建物理厂址，不计已建/在产厂'),
('MP0001','project','江苏瑞孚南厂迁建项目','江苏','泰州',NULL,'design','2024-06-19','CN0297','S042-02','拟审查公示','与北厂历史范围分开，不累计产能'),
('MO0003','organization','大连瑞克科技股份有限公司',NULL,NULL,NULL,'historical','2026年年报来源','CN0082','W07S14','河北子公司关系','公开披露法人关系；不推断当前控制权或采购主体'),
('MO0004','organization','河北瑞克新能源科技有限公司',NULL,NULL,NULL,'historical','2026年年报来源','CN0232','W07S14','河北子公司关系','公开披露子公司关系；不推断在产或采购权');
INSERT INTO market_identity_links VALUES
('ML0001','CN0085','MO0001','legal_subject','evidence_linked','2019-07','S027-09','第13项','同法人不等于同厂'),
('ML0002','CN0256','MO0001','legal_subject','evidence_linked','2019-07','S027-09','第13项','同法人不等于同厂'),
('ML0003','CN0085','MF0001','physical_site','evidence_linked','2019-07','S027-09','第13项','东兴路历史厂'),
('ML0004','CN0256','MF0002','physical_site','evidence_linked','2019-07','S027-09','第13项','荣乐东路历史厂'),
('ML0005','CN0296','MO0002','legal_subject','evidence_linked','2024-06-19','S042-02','拟审查公示','同一法人历史范围'),
('ML0006','CN0297','MO0002','legal_subject','evidence_linked','2024-06-19','S042-02','拟审查公示','同一法人设计范围'),
('ML0007','CN0296','MF0003','physical_site','evidence_linked','2024-06-19','S042-02','拟审查公示','北厂历史范围'),
('ML0008','CN0297','MF0004','physical_site','evidence_linked','2024-06-19','S042-02','拟审查公示','南厂设计范围'),
('ML0009','CN0297','MP0001','project_scope','evidence_linked','2024-06-19','S042-02','拟审查公示','迁建项目，未核实投运'),
('ML0010','CN0082','MO0003','legal_subject','evidence_linked','2026年年报来源','W07S14','河北子公司关系','仅法人；不确认物理厂址'),
('ML0011','CN0232','MO0004','legal_subject','evidence_linked','2026年年报来源','W07S14','河北子公司关系','仅法人；不确认物理厂址');
INSERT INTO market_entity_relations VALUES
('MR0001','MF0001','MO0001','operated_by','historical','2019-07','REL027-01','CN0085','S027-09','第13项','历史关系'),
('MR0002','MF0002','MO0001','operated_by','historical','2019-07','REL027-01','CN0256','S027-09','第13项','历史关系'),
('MR0003','MF0003','MO0002','operated_by','historical','2024-06-19','REL042-01','CN0296','S042-02','拟审查公示','历史北厂'),
('MR0004','MF0004','MO0002','planned_operator','design','2024-06-19','REL042-01','CN0297','S042-02','拟审查公示','设计关系'),
('MR0005','MF0004','MF0003','replacement_for','design','2024-06-19','REL042-01','CN0297','S042-02','拟审查公示','计划替代，不判实际'),
('MR0006','MP0001','MF0004','planned_at','design','2024-06-19','REL042-01','CN0297','S042-02','拟审查公示','计划厂址'),
('MR0007','MO0004','MO0003','subsidiary_of','historical','2026年年报来源','R0005','CN0232','W07S14','河北子公司关系','历史披露，不推定采购权限或当前股权');
-- No ownership classifications are inferred; no procurement or commercial conclusions seeded.
CREATE VIEW v_market_identity_slots AS
SELECT s.site_id,s.name,s.province,s.city,s.address,s.record_type,s.status,s.permit_id,s.as_of,
 CASE WHEN s.record_type IN ('基地','厂区','载体基地','纯回收','回收利用') THEN 'facility_review'
 WHEN s.record_type IN ('项目','再生/项目','同址项目','研发项目') THEN 'project_review'
 WHEN s.record_type IN ('基地/项目','厂区/项目','企业/项目') THEN 'mixed_scope_review'
 WHEN s.record_type IN ('企业','集团/待拆分','销售/集团主体') THEN 'organization_review'
 WHEN s.record_type='退出' THEN 'inactive_review'
 ELSE 'candidate_review' END AS review_scope,
 (SELECT count(*) FROM market_identity_links l WHERE l.site_id=s.site_id AND l.link_state='evidence_linked') AS evidence_link_count,
 CASE WHEN EXISTS(SELECT 1 FROM market_identity_links l WHERE l.site_id=s.site_id AND l.link_state='evidence_linked') THEN 'partially_mapped' ELSE 'unmapped' END AS mapping_state
FROM sites s;
CREATE VIEW v_market_address_review AS
SELECT province,city,trim(address) AS address,count(*) AS site_count,group_concat(site_id,',') AS legacy_site_ids
FROM (SELECT * FROM sites ORDER BY site_id)
WHERE trim(coalesce(address,''))<>'' GROUP BY province,city,trim(address) HAVING count(*)>1;
CREATE VIEW v_market_identity_review_queue AS
SELECT site_id,'identity_mapping' AS gap,'旧主体尚无证据映射' AS reason FROM v_market_identity_slots WHERE mapping_state='unmapped'
UNION ALL SELECT site_id,'missing_address','旧主体地址空；非所有记录都应有厂址' FROM sites WHERE trim(coalesce(address,''))=''
UNION ALL SELECT site_id,'address_collision','同省市地址文本重合；不是合并依据' FROM sites s WHERE EXISTS(SELECT 1 FROM v_market_address_review a WHERE a.province IS s.province AND a.city IS s.city AND a.address=trim(s.address))
UNION ALL SELECT site_id,'relation_review','历史关系需分期和范围复核' FROM sites s WHERE EXISTS(SELECT 1 FROM site_relations r WHERE s.site_id IN (r.site_id,r.other_site_id));
CREATE VIEW v_market_legacy_relations AS SELECT r.*,s.name AS from_name,o.name AS to_name,x.title AS source_title,x.url AS source_url FROM site_relations r JOIN sites s ON s.site_id=r.site_id JOIN sites o ON o.site_id=r.other_site_id LEFT JOIN sources x ON x.source_id=r.source_id;
CREATE VIEW v_market_entity_catalog AS
SELECT e.*,s.title AS source_title,s.url AS source_url,
 (SELECT count(DISTINCT l.site_id) FROM market_identity_links l WHERE l.entity_id=e.entity_id AND l.link_state='evidence_linked') AS linked_legacy_sites
FROM market_entities e JOIN sources s USING(source_id);
CREATE VIEW v_market_seed_opportunities AS
SELECT 'LEGACY-'||o.site_id AS seed_id,o.*,w.stream,w.stage,w.flow,w.flow_unit,w.flow_basis,
 'legacy_research_candidate' AS seed_state,'unassessed' AS technology_fit,
 'unknown' AS buyer_intent
FROM commercial_opportunity_screen o JOIN wastewater w ON w.water_id=o.anchor_water_id AND w.site_id=o.site_id;
COMMIT;
