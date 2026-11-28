-- 057: QA of 056 boundary and task labels. Preserve all observations and sources.
PRAGMA foreign_keys=ON;
BEGIN;
-- Rain discharge is a distinct monitoring point; it is not the central WWTP stream.
UPDATE water_metrics SET water_id=NULL WHERE site_id='CN0309' AND source_id='S056-01' AND water_id='W056-01' AND point='雨排口';
-- Station existence/capacity is not evidence of internal wastewater process.
UPDATE sites SET water_level='部分信息/流程待查',source_status='上市公司披露' WHERE site_id='CN0310';
UPDATE tasks SET state='部分完成' WHERE task_id IN ('T056-CN0309','T056-CN0310') AND state='open';
COMMIT;
