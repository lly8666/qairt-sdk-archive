BEGIN;
-- Versioned evidence diagrams. Never create a generic diagram for an unknown plant.
CREATE TABLE process_diagrams (
 diagram_id TEXT PRIMARY KEY, site_id TEXT NOT NULL REFERENCES sites(site_id),
 scope_key TEXT NOT NULL, stage TEXT NOT NULL CHECK(stage IN ('operating','built','design','historical','unknown')),
 period TEXT NOT NULL, revision INTEGER NOT NULL CHECK(revision>=1),
 coverage TEXT NOT NULL CHECK(coverage IN ('partial','complete','no_production_wastewater')),
 mermaid TEXT NOT NULL CHECK(length(trim(mermaid))>0),
 source_id TEXT NOT NULL REFERENCES sources(source_id), boundaries TEXT NOT NULL,
 gaps TEXT NOT NULL, updated_on TEXT NOT NULL,
 UNIQUE(site_id,scope_key,stage,period,revision), UNIQUE(diagram_id,site_id)
);
CREATE TABLE process_diagram_evidence (
 evidence_id TEXT PRIMARY KEY, diagram_id TEXT NOT NULL REFERENCES process_diagrams(diagram_id),
 water_id TEXT REFERENCES wastewater(water_id), source_id TEXT NOT NULL REFERENCES sources(source_id),
 locator TEXT, element_ids TEXT NOT NULL, detail TEXT NOT NULL
);
CREATE TABLE membrane_reviews (
 review_id TEXT PRIMARY KEY, site_id TEXT NOT NULL REFERENCES sites(site_id),
 diagram_id TEXT, scope_key TEXT NOT NULL, stage TEXT NOT NULL CHECK(stage IN ('operating','built','design','historical','unknown')),
 period TEXT NOT NULL, revision INTEGER NOT NULL CHECK(revision>=1),
 presence TEXT NOT NULL CHECK(presence IN ('confirmed_present','confirmed_absent','not_identified','uncertain','not_applicable')),
 source_id TEXT REFERENCES sources(source_id), evidence_basis TEXT NOT NULL, gaps TEXT NOT NULL, updated_on TEXT NOT NULL,
 CHECK(presence NOT IN ('confirmed_present','confirmed_absent','not_applicable') OR source_id IS NOT NULL),
 FOREIGN KEY(diagram_id,site_id) REFERENCES process_diagrams(diagram_id,site_id),
 UNIQUE(site_id,scope_key,stage,period,revision), UNIQUE(review_id,site_id)
);
CREATE TABLE membrane_units (
 unit_id TEXT PRIMARY KEY, review_id TEXT NOT NULL REFERENCES membrane_reviews(review_id),
 unit_label TEXT NOT NULL,
 technology TEXT NOT NULL CHECK(technology IN ('MF','UF','NF','RO','MBR','ED','EDR','BMED','FO','MD','OTHER','UNSPECIFIED')),
 role TEXT NOT NULL, feed TEXT, permeate_destination TEXT, concentrate_destination TEXT,
 specification TEXT, source_id TEXT NOT NULL REFERENCES sources(source_id), locator TEXT, notes TEXT
);
CREATE TABLE membrane_retrofits (
 assessment_id TEXT PRIMARY KEY, review_id TEXT NOT NULL, site_id TEXT NOT NULL REFERENCES sites(site_id),
 scope_key TEXT NOT NULL, option_key TEXT NOT NULL, revision INTEGER NOT NULL CHECK(revision>=1),
 objective TEXT NOT NULL, proposed_route TEXT NOT NULL,
 feasibility TEXT NOT NULL CHECK(feasibility IN ('candidate','conditional','not_recommended','infeasible','unknown','not_applicable')),
 hard_constraints TEXT NOT NULL, evidence_basis TEXT NOT NULL, assumptions TEXT NOT NULL,
 missing_inputs TEXT NOT NULL, validation_plan TEXT NOT NULL, alternatives TEXT NOT NULL,
 feed_risk INTEGER CHECK(feed_risk BETWEEN 0 AND 2),
 pretreatment_risk INTEGER CHECK(pretreatment_risk BETWEEN 0 AND 2),
 concentrate_risk INTEGER CHECK(concentrate_risk BETWEEN 0 AND 2),
 integration_risk INTEGER CHECK(integration_risk BETWEEN 0 AND 2),
 operational_risk INTEGER CHECK(operational_risk BETWEEN 0 AND 2),
 compliance_economics_risk INTEGER CHECK(compliance_economics_risk BETWEEN 0 AND 2),
 score_basis TEXT NOT NULL, updated_on TEXT NOT NULL,
 FOREIGN KEY(review_id,site_id) REFERENCES membrane_reviews(review_id,site_id),
 UNIQUE(review_id,scope_key,option_key,revision)
);
CREATE VIEW v_latest_process_diagrams AS SELECT d.* FROM process_diagrams d WHERE NOT EXISTS (
 SELECT 1 FROM process_diagrams n WHERE n.site_id=d.site_id AND n.scope_key=d.scope_key AND n.stage=d.stage AND n.period=d.period AND n.revision>d.revision);
CREATE VIEW v_latest_membrane_reviews AS SELECT r.* FROM membrane_reviews r WHERE NOT EXISTS (
 SELECT 1 FROM membrane_reviews n WHERE n.site_id=r.site_id AND n.scope_key=r.scope_key AND n.stage=r.stage AND n.period=r.period AND n.revision>r.revision);
CREATE VIEW v_membrane_retrofit_rating AS SELECT a.*,
 (feed_risk+pretreatment_risk+concentrate_risk+integration_risk+operational_risk+compliance_economics_risk) AS score_total,
 CASE WHEN feasibility='not_applicable' THEN 'not_applicable'
 WHEN feasibility='infeasible' THEN 'blocked'
 WHEN (feed_risk+pretreatment_risk+concentrate_risk+integration_risk+operational_risk+compliance_economics_risk) IS NULL THEN 'unknown'
 WHEN (feed_risk+pretreatment_risk+concentrate_risk+integration_risk+operational_risk+compliance_economics_risk)<=3 THEN 'low'
 WHEN (feed_risk+pretreatment_risk+concentrate_risk+integration_risk+operational_risk+compliance_economics_risk)<=7 THEN 'medium'
 ELSE 'high' END AS difficulty
 FROM membrane_retrofits a WHERE NOT EXISTS (
 SELECT 1 FROM membrane_retrofits n WHERE n.review_id=a.review_id AND n.scope_key=a.scope_key AND n.option_key=a.option_key AND n.revision>a.revision);
CREATE VIEW v_process_membrane_queue AS SELECT s.site_id,s.name,s.province,s.category,s.record_type,s.status,s.priority,s.water_level,
 (SELECT count(*) FROM v_latest_process_diagrams d WHERE d.site_id=s.site_id) AS diagram_count,
 (SELECT count(*) FROM v_latest_process_diagrams d WHERE d.site_id=s.site_id AND d.stage='operating' AND d.coverage IN ('complete','no_production_wastewater')) AS operating_complete_diagrams,
 (SELECT count(*) FROM v_latest_membrane_reviews r WHERE r.site_id=s.site_id) AS membrane_review_count,
 (SELECT count(*) FROM v_latest_membrane_reviews r WHERE r.site_id=s.site_id AND r.stage='operating' AND r.presence IN ('confirmed_present','confirmed_absent','not_applicable')) AS operating_resolved_reviews,
 (SELECT count(*) FROM v_latest_membrane_reviews r WHERE r.site_id=s.site_id AND NOT EXISTS(SELECT 1 FROM v_membrane_retrofit_rating a WHERE a.review_id=r.review_id)) AS reviews_without_retrofit,
 (SELECT count(*) FROM v_latest_membrane_reviews r JOIN v_membrane_retrofit_rating a USING(review_id) WHERE r.site_id=s.site_id AND a.feasibility IN ('unknown','conditional')) AS retrofit_followup_options
 FROM sites s;
COMMIT;
