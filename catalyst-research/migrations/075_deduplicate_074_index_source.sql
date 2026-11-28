PRAGMA foreign_keys=ON;
BEGIN;
INSERT INTO source_aliases(alias_source_id,canonical_source_id,title,url,source_type,document_date,scope,access_date,original_site_ids,merged_on)
 SELECT source_id,'S026-14',title,url,source_type,document_date,scope,access_date,'CN0329','2026-11-28' FROM sources WHERE source_id='S074-04';
INSERT INTO site_sources(site_id,source_id) SELECT site_id,'S026-14' FROM site_sources WHERE source_id='S074-04';
UPDATE evidence_notes SET source_id='S026-14' WHERE source_id='S074-04';
DELETE FROM site_sources WHERE source_id='S074-04';
DELETE FROM sources WHERE source_id='S074-04';
COMMIT;
