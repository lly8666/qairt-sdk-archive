-- 110: complete Heraeus current MVR equipment list and disclosed investment scale.
PRAGMA foreign_keys=ON;
BEGIN;
UPDATE market_treatment_systems
SET boundary='MVR设施设备清单（2026方案）：储罐6、蒸发器1、换热器3、稠化器1、过滤器2、离心机1、压缩机1、输送泵8；2024高盐处理量及设计能力见S027-05；不表示膜预浓缩已安装'
WHERE system_id='TS109-04';
UPDATE process_diagram_evidence
SET detail='高盐废水MVR蒸发结晶路线；2026设备清单：储罐6、蒸发器1、换热器3、稠化器1、过滤器2、离心机1、压缩机1、输送泵8；2024处理量另见S027-05'
WHERE evidence_id='E109-04';
UPDATE market_entities
SET evidence_period='2026-03-26',source_id='S109-01',locator='第三部分处置方案概述',
 boundary=coalesce(boundary,'')||'；2026方案披露：2015年由贺利氏（中国）投资有限公司独资建设，项目总投资12000万美元、注册资本4000万美元；均为文件披露口径，不代表当前固定资产、营收或产能'
WHERE entity_id='MO0019';
COMMIT;
