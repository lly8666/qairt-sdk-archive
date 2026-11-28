-- 063: reconcile cross-site Rezel duplicate and retain new dated index
PRAGMA foreign_keys=ON;
BEGIN;
INSERT INTO source_aliases(alias_source_id,canonical_source_id,title,url,source_type,document_date,scope,access_date,original_site_ids,merged_on)
SELECT source_id,'W01B2S08',title,url,source_type,document_date,scope,access_date,'CN0016','2026-11-28' FROM sources WHERE source_id='S062-08';
UPDATE evidence_notes SET site_id='CN0017',source_id='W01B2S08',detail='2026-06-30征求意见稿为既有记录复核；建设主体润和催化剂（四川）有限公司，不与既有乐山基地共用污水站或产能。原报告附件未取。2026-09-20报批前公示另见S063-01。' WHERE note_id='N062-07';
UPDATE search_log SET source_id='W01B2S08',result='旧征求意见公示复核，归独立CN0017，不重复计入CN0016；另取9月20日报批前公示索引S063-01，详见N063-01。旧销售渠道不重复。' WHERE log_id='L062-16';
DELETE FROM projects WHERE project_id='P062-04';
DELETE FROM site_sources WHERE source_id='S062-08';
DELETE FROM sources WHERE source_id='S062-08';
INSERT INTO sources(source_id,title,url,source_type,document_date,scope,access_date) VALUES ('S063-01','润和催化剂官网新闻目录：10万吨稀土催化新材料项目报批前公示','https://www.rezel.com.cn/doc_28078210_0_0_1.html','WEB_COMPANY','2026-09-20','官网新闻目录列报批前公示日期；未取得具体报告，不证明批复或投产','2026-11-28');
INSERT INTO site_sources(site_id,source_id) VALUES ('CN0017','S063-01');
INSERT INTO evidence_notes(note_id,site_id,source_id,topic,locator,detail,evidence_class,archive_status,created_on) VALUES ('N063-01','CN0017','S063-01','报批前公示新节点','官网新闻目录检索摘要','2026-09-20报批前公示索引，相较既有2026-06-30征求意见为新节点；环评正文及审批未核。','WEB_COMPANY','WEB_TEXT','2026-11-28');
INSERT INTO projects(project_id,site_id,project,status,date,capacity_note,water_change,source_id) VALUES ('P063-01','CN0017','10万吨稀土催化新材料项目','报批前公示索引','2026-09-20','旧10万吨设计规模不重复累加','污水站规模、膜技术和批复待核','S063-01');
COMMIT;
