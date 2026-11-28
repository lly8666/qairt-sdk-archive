-- 053: source-column QA correction; preserve original migration history.
BEGIN;
UPDATE water_metrics SET metric='氨氮',notes='053复核表3.2.5-3 pp80-81列位置，50为氨氮而非总氮；设计产生浓度，非实际监测' WHERE metric_id='M052-019' AND site_id='CN0019' AND metric='总氮' AND value_num=50;
UPDATE wastewater SET pollutants='COD、六价铬、总铬、氨氮' WHERE water_id='W052-14';
INSERT INTO evidence_notes(note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES('N053-01','CN0019','W01B2S09','源强表列位置复核','表3.2.5-3 pp80-81；正文3.2.4.2','M052-019 50mg/L应为氨氮而非总氮；实验室25mg/L汇总表列氨氮而正文称TN，保留汇总值并标注异文，不能作实际监测。','WEB_PRIMARY','结构化内容保全，非原文全文','2026-11-28');
UPDATE water_metrics SET notes=notes||'；正文3.2.4.2称TN 25mg/L，表3.2.5-3列氨氮，异文待核' WHERE site_id='CN0019' AND metric_id LIKE 'M052-%' AND point='实验室废水' AND metric='氨氮' AND value_num=25;
COMMIT;
