-- Local audit: merge duplicate source, preserve revisit evidence.
PRAGMA foreign_keys=ON;
BEGIN;
UPDATE search_log SET source_id='S021-003',result='既有官方公示链接复查404，无新证据' WHERE source_id='S047-17';
UPDATE evidence_notes SET source_id='S021-003',topic='既有报批公示复查',detail='2026-11-28复查既有官方拟报批公示链接，正文404；没有新增工艺证据。' WHERE source_id='S047-17';
DELETE FROM site_sources WHERE source_id='S047-17';
DELETE FROM sources WHERE source_id='S047-17';
COMMIT;
