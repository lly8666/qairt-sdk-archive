-- 069: post-build exact URL/project reconciliation; preserve new evidence
PRAGMA foreign_keys=ON;
BEGIN;
INSERT INTO source_aliases(alias_source_id,canonical_source_id,title,url,source_type,document_date,scope,access_date,original_site_ids,merged_on)
SELECT source_id,'W08S31',title,url,source_type,document_date,scope,access_date,'CN0244','2026-11-28' FROM sources WHERE source_id='S068-10';
UPDATE projects SET capacity_note='原13000吨/年处理规模保持不变，不新增用地',water_change='拟设置预处理清灰、三级清洗、完整件活化再生及破损件再制造；洗水量、水质、回用率和处理设施待环评' WHERE project_id='P0087';
DELETE FROM projects WHERE source_id='S068-10';
UPDATE evidence_notes SET source_id='W08S31' WHERE source_id='S068-10';
UPDATE search_log SET source_id='W08S31',result='既有2026-11首次公示补读三级清洗、改建不增规模，来源与旧项目合并' WHERE source_id='S068-10';
DELETE FROM site_sources WHERE source_id='S068-10';
DELETE FROM sources WHERE source_id='S068-10';
COMMIT;
