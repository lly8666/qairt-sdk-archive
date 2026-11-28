PRAGMA foreign_keys=ON;
BEGIN;
CREATE TRIGGER market_relation_provenance_insert BEFORE INSERT ON market_entity_relations
WHEN NOT EXISTS (
 SELECT 1 FROM site_relations r
 JOIN market_identity_links a ON a.entity_id=NEW.from_entity_id AND a.link_state='evidence_linked'
 JOIN market_identity_links b ON b.entity_id=NEW.to_entity_id AND b.link_state='evidence_linked'
 JOIN site_sources sa ON sa.site_id=a.site_id AND sa.source_id=NEW.source_id
 JOIN site_sources sb ON sb.site_id=b.site_id AND sb.source_id=NEW.source_id
 WHERE r.relation_id=NEW.legacy_relation_id AND r.source_id=NEW.source_id
 AND NEW.anchor_site_id IN(r.site_id,r.other_site_id)
 AND ((a.site_id=r.site_id AND b.site_id=r.other_site_id) OR (a.site_id=r.other_site_id AND b.site_id=r.site_id))
)
BEGIN SELECT RAISE(ABORT,'relation endpoints require legacy pair and both-site provenance'); END;
CREATE TRIGGER market_relation_provenance_update BEFORE UPDATE ON market_entity_relations
WHEN NOT EXISTS (
 SELECT 1 FROM site_relations r
 JOIN market_identity_links a ON a.entity_id=NEW.from_entity_id AND a.link_state='evidence_linked'
 JOIN market_identity_links b ON b.entity_id=NEW.to_entity_id AND b.link_state='evidence_linked'
 JOIN site_sources sa ON sa.site_id=a.site_id AND sa.source_id=NEW.source_id
 JOIN site_sources sb ON sb.site_id=b.site_id AND sb.source_id=NEW.source_id
 WHERE r.relation_id=NEW.legacy_relation_id AND r.source_id=NEW.source_id
 AND NEW.anchor_site_id IN(r.site_id,r.other_site_id)
 AND ((a.site_id=r.site_id AND b.site_id=r.other_site_id) OR (a.site_id=r.other_site_id AND b.site_id=r.site_id))
)
BEGIN SELECT RAISE(ABORT,'relation endpoints require legacy pair and both-site provenance'); END;
CREATE TABLE market_procurement_observations (
 procurement_id TEXT PRIMARY KEY, site_id TEXT NOT NULL, organization_id TEXT REFERENCES market_entities(entity_id),
 buyer_label TEXT NOT NULL, package_scope TEXT NOT NULL,
 procurement_stage TEXT NOT NULL CHECK(procurement_stage IN ('award_reported','solicitation_historical','policy_reference','open_verified','unknown','cancelled')),
 evidence_period TEXT NOT NULL, source_id TEXT NOT NULL, locator TEXT NOT NULL, boundary TEXT NOT NULL, outreach_hypothesis TEXT NOT NULL,
 UNIQUE(site_id,package_scope,evidence_period,source_id),
 FOREIGN KEY(site_id,source_id) REFERENCES site_sources(site_id,source_id)
);
CREATE TRIGGER market_procurement_kind_insert BEFORE INSERT ON market_procurement_observations WHEN NEW.organization_id IS NOT NULL AND NOT EXISTS(SELECT 1 FROM market_entities e JOIN market_identity_links l USING(entity_id) WHERE e.entity_id=NEW.organization_id AND e.entity_kind='organization' AND l.site_id=NEW.site_id AND l.link_state='evidence_linked') BEGIN SELECT RAISE(ABORT,'procurement organization must be linked to site'); END;
CREATE TRIGGER market_procurement_kind_update BEFORE UPDATE ON market_procurement_observations WHEN NEW.organization_id IS NOT NULL AND NOT EXISTS(SELECT 1 FROM market_entities e JOIN market_identity_links l USING(entity_id) WHERE e.entity_id=NEW.organization_id AND e.entity_kind='organization' AND l.site_id=NEW.site_id AND l.link_state='evidence_linked') BEGIN SELECT RAISE(ABORT,'procurement organization must be linked to site'); END;
CREATE TABLE market_water_scope_reviews (
 review_id TEXT PRIMARY KEY, water_id TEXT NOT NULL REFERENCES wastewater(water_id),
 site_id TEXT NOT NULL, source_id TEXT NOT NULL, scope_class TEXT NOT NULL CHECK(scope_class IN ('system_capacity','unit_capacity','shared_system_capacity','derived_quantity','design_generation','historical_case_scale','procurement_capacity','unquantified_stream','reported_unit_throughput','reported_site_quantity','unknown')),
 review_date TEXT NOT NULL, boundary TEXT NOT NULL,
 UNIQUE(water_id,review_date),
 FOREIGN KEY(site_id,source_id) REFERENCES site_sources(site_id,source_id)
);
CREATE TRIGGER market_water_scope_insert BEFORE INSERT ON market_water_scope_reviews WHEN NOT EXISTS(SELECT 1 FROM wastewater w WHERE w.water_id=NEW.water_id AND w.site_id=NEW.site_id AND w.source_id=NEW.source_id) BEGIN SELECT RAISE(ABORT,'water scope source/site mismatch'); END;
CREATE TRIGGER market_water_scope_update BEFORE UPDATE ON market_water_scope_reviews WHEN NOT EXISTS(SELECT 1 FROM wastewater w WHERE w.water_id=NEW.water_id AND w.site_id=NEW.site_id AND w.source_id=NEW.source_id) BEGIN SELECT RAISE(ABORT,'water scope source/site mismatch'); END;
INSERT INTO sources VALUES
('S105-01','中触媒关于原实际控制人股份过户完成的公告','https://epaper.cs.com.cn/zgzqb/html/2026-11/20/nw.D110000zgzqb_20261120_1-B015.htm','上市公司公告转载','2026-11-20','股份过户完成；公告回溯2026-10-15控制权变动','2026-11-28'),
('S105-02','中触媒关于控股股东增持公司股份计划实施结果的公告（控制权段）','https://big5.sse.com.cn/site/cht/www.sse.com.cn/disclosure/listedinfo/announcement/c/new/2026-11-25/688267_20261125_X0L3.pdf','交易所公告检索摘录','2026-11-25','增持主体基本情况；实际控制人变更为李进','2026-11-28'),
('S105-03','浙江省能源集团有限公司财务报表附注','https://static.sse.com.cn/bond/bridge2/disclosure/announcement/c/202606/2af002_20260616_446L.pdf','交易所财务附注检索摘录','2026-06-16','子公司表第259项，浙能催化剂持股及表决权100%；报告期需核完整表头','2026-11-28'),
('S105-04','浙江省能源集团有限公司重大信息公开','https://www.zjenergy.com.cn/ZNWW/contents/153/1772.html','集团官网',NULL,'集团省属国有企业性质；不证明子公司采购授权','2026-11-28'),
('S105-05','中国石化催化剂有限公司公司简介','https://scc.sinopec.com/scc/about/gsjj01/A159002008Gone1.shtml','企业官网',NULL,'中国石化旗下专业公司及国资委科改行动；未披露持股比例','2026-11-28'),
('S105-06','云溪基地450吨/年环氧化催化剂连续高效滚球成型示范装置建设项目环境影响评价拟审批信息','https://www.yunxiqu.gov.cn/38965/39034/39035/39063/41965/42378/content_2301463.html','政府公示','2024','长岭分公司云溪基地现有厂房；不同厂区范围保留','2026-11-28'),
('S105-07','中国石化催化剂有限公司物资装备中心','https://scc.sinopec.com/scc/about/fzgs/2026/9/I1549920306229936128.shtml','企业官网','2026-09','2024-01独立运行，生产建设物资归口管理和集中采购','2026-11-28'),
('S105-08','催化剂长岭分公司5万吨/年催化裂化催化剂联合生产装置建设项目招标公告','https://ebidding.sinopec.com/TPWeb4AAA/InfoDetail/Default.aspx?CategoryNum=002001&InfoID=98cdad26-432f-48dc-9ab2-75ad76147bf9','官方招标公告','2016','历史项目业主和招标人；非当前采购','2026-11-28');
INSERT INTO site_sources VALUES
('CN0026','S105-01'),
('CN0026','S105-02'),
('CN0127','S105-03'),
('CN0127','S105-04'),
('CN0002','S105-05'),
('CN0003','S105-05'),
('CN0003','S105-06'),
('CN0002','S105-07'),
('CN0003','S105-07'),
('CN0003','S105-08');
INSERT INTO market_entities VALUES
('MO0005','organization','北京方信立华科技有限公司',NULL,NULL,NULL,'historical','2024','CN0167','W08S04','2024年报及R0007/R0008','销售/集团主体，不认定北京制造'),
('MO0006','organization','安徽方信立华环保科技有限公司',NULL,NULL,NULL,'historical','2024','CN0237','W08S04','2024年报R0007','制造子公司；具体控制权待核'),
('MO0007','organization','马鞍山方信环保科技有限公司',NULL,NULL,NULL,'historical','2024','CN0238','W08S04','2024年报R0008','制造子公司；具体控制权待核'),
('MO0008','organization','陕西瑞科新材料股份有限公司',NULL,NULL,NULL,'historical','2025-10','CN0132','S024-04','问询回复REL024-01','母公司；采购主体待核'),
('MO0009','organization','陕西璟邑科技有限公司',NULL,NULL,NULL,'historical','2025-10','CN0255','S024-04','问询回复REL024-01','异地子公司；不确认投运'),
('MO0010','organization','江西应陶康顺实业有限公司',NULL,NULL,NULL,'historical','历史企业介绍','CN0293','S041-07','REL041-01','企业自述母公司'),
('MO0011','organization','江西陆度雪新材料有限公司',NULL,NULL,NULL,'historical','历史企业介绍','CN0294','S041-07','REL041-01','企业自述子公司，拟建项目不等于运行'),
('MO0012','organization','肯特催化材料股份有限公司',NULL,NULL,NULL,'historical','2025-04','CN0309','S056-04','招股书及REL056-01','历史仙居基地法人'),
('MO0013','organization','江西肯特化学有限公司',NULL,NULL,NULL,'historical','2025-04','CN0310','S056-04','招股书及REL056-01','历史永新基地法人'),
('MF0005','facility','肯特催化仙居基地','浙江','台州','仙居经济开发区现代医药化工园区丰溪西路7号','historical','2024','CN0309','S056-01','环评项目厂址','历史厂区；扩容设计不等于运行'),
('MF0006','facility','江西肯特永新基地','江西','吉安','永新县工业园（茅坪产业园）','historical','2025-04','CN0310','S056-04','招股书基地及污水设施','历史厂区，不将仙居站归属江西'),
('MO0014','organization','中触媒新材料股份有限公司',NULL,NULL,NULL,'historical','2026-11-25','CN0026','S105-02','公告增持主体基本情况','上市法人；自然人实际控制，非采购权限'),
('MF0007','facility','中触媒松木岛基地','辽宁','大连','松木岛化工园','historical','2025-09','CN0026','S059-01','环评现有工程','历史设施与三期设计分开'),
('MO0015','organization','浙江浙能催化剂技术有限公司',NULL,NULL,NULL,'historical','2026-06-16披露','CN0127','S105-03','财务附注子公司表第259项','集团持股及表决权100%，直接/间接链及报告期待核'),
('MO0016','organization','浙江省能源集团有限公司',NULL,NULL,NULL,'historical','2026-11-28查阅','CN0127','S105-04','集团重大信息公开','省属国企；集团不等于具体厂区采购方'),
('MF0008','facility','浙能催化剂宁海基地','浙江','宁波','宁海强蛟望岗路1号','historical','2026-01','CN0127','W06S01','扩建环评既有工程','历史厂区；扩建实际进度待核'),
('MO0017','organization','中国石化催化剂有限公司',NULL,NULL,NULL,'historical','2026-11-28查阅','CN0002','S105-05','公司简介','央企旗下专业公司；具体股权比例未披露'),
('MF0009','facility','中石化催化剂云溪基地','湖南','岳阳','岳阳绿色化工产业高新技术开发区长岭片区','historical','2024','CN0003','S105-06','拟审批信息项目概况','既有厂房范围，拟建装置不等于投运');
INSERT INTO market_identity_links VALUES
('ML0012','CN0167','MO0005','legal_subject','evidence_linked','2024','W08S04','2024年报及R0007/R0008','销售/集团主体，不认定北京制造'),
('ML0013','CN0237','MO0006','legal_subject','evidence_linked','2024','W08S04','2024年报R0007','制造子公司；具体控制权待核'),
('ML0014','CN0238','MO0007','legal_subject','evidence_linked','2024','W08S04','2024年报R0008','制造子公司；具体控制权待核'),
('ML0015','CN0132','MO0008','legal_subject','evidence_linked','2025-10','S024-04','问询回复REL024-01','母公司；采购主体待核'),
('ML0016','CN0255','MO0009','legal_subject','evidence_linked','2025-10','S024-04','问询回复REL024-01','异地子公司；不确认投运'),
('ML0017','CN0293','MO0010','legal_subject','evidence_linked','历史企业介绍','S041-07','REL041-01','企业自述母公司'),
('ML0018','CN0294','MO0011','legal_subject','evidence_linked','历史企业介绍','S041-07','REL041-01','企业自述子公司，拟建项目不等于运行'),
('ML0019','CN0309','MO0012','legal_subject','evidence_linked','2025-04','S056-04','招股书及REL056-01','历史仙居基地法人'),
('ML0020','CN0310','MO0013','legal_subject','evidence_linked','2025-04','S056-04','招股书及REL056-01','历史永新基地法人'),
('ML0021','CN0309','MF0005','physical_site','evidence_linked','2024','S056-01','环评项目厂址','历史厂区；扩容设计不等于运行'),
('ML0022','CN0310','MF0006','physical_site','evidence_linked','2025-04','S056-04','招股书基地及污水设施','历史厂区，不将仙居站归属江西'),
('ML0023','CN0026','MO0014','legal_subject','evidence_linked','2026-11-25','S105-02','公告增持主体基本情况','上市法人；自然人实际控制，非采购权限'),
('ML0024','CN0026','MF0007','physical_site','evidence_linked','2025-09','S059-01','环评现有工程','历史设施与三期设计分开'),
('ML0025','CN0127','MO0015','legal_subject','evidence_linked','2026-06-16披露','S105-03','财务附注子公司表第259项','集团持股及表决权100%，直接/间接链及报告期待核'),
('ML0026','CN0127','MO0016','group_scope','evidence_linked','2026-11-28查阅','S105-04','集团重大信息公开','省属国企；集团不等于具体厂区采购方'),
('ML0027','CN0127','MF0008','physical_site','evidence_linked','2026-01','W06S01','扩建环评既有工程','历史厂区；扩建实际进度待核'),
('ML0028','CN0002','MO0017','group_scope','evidence_linked','2026-11-28查阅','S105-05','公司简介','央企旗下专业公司；具体股权比例未披露'),
('ML0029','CN0003','MO0017','group_scope','evidence_linked','2026-11-28查阅','S105-05','公司简介及云溪基地政府公示','CN0003属于该公司业务范围；不与长岭物理厂区合并'),
('ML0030','CN0003','MF0009','physical_site','evidence_linked','2024','S105-06','拟审批信息项目概况','既有厂房范围，拟建装置不等于投运');
INSERT INTO market_entity_relations VALUES
('MR0008','MO0006','MO0005','other','historical','2024','R0007','CN0237','W08S04','R0007','制造与销售总部关系；直接股权未核'),
('MR0009','MO0007','MO0005','other','historical','2024','R0008','CN0238','W08S04','R0008','制造与销售总部关系；直接股权未核'),
('MR0010','MO0009','MO0008','subsidiary_of','historical','2025-10','REL024-01','CN0255','S024-04','REL024-01','异地子公司，不汇总产能'),
('MR0011','MO0011','MO0010','subsidiary_of','historical','历史企业介绍','REL041-01','CN0294','S041-07','REL041-01','自述母子公司关系'),
('MR0012','MO0013','MO0012','subsidiary_of','historical','2025-04','REL056-01','CN0310','S056-04','REL056-01','全资子公司，异地生产');
INSERT INTO market_ownership_observations VALUES
('OW0001','MO0014','private_controlled','listed',NULL,'2026-11-25披露','evidence_linked','CN0026','S105-02','增持主体基本情况','自然人李进实际控制；2026-10控制权变更，不推断采购权'),
('OW0002','MO0012','private_controlled','listed',NULL,'2026H1','evidence_linked','CN0309','S058-04','财务报表附注公司基本情况','自然人夫妇实际控制；2026H1报告，不推断采购审批'),
('OW0003','MO0013','private_controlled','unknown','MO0012','2025-04','evidence_linked','CN0310','S056-04','招股书及REL056-01','当期全资子公司，结合母公司自然人控制披露；当前控制及采购权仍待核'),
('OW0004','MO0016','local_state_controlled','unknown',NULL,'2026-11-28查阅','evidence_linked','CN0127','S105-04','重大信息公开','省属国有企业，集团范围'),
('OW0005','MO0015','local_state_controlled','unknown','MO0016','2026-06-16披露','evidence_linked','CN0127','S105-03','财务附注第259项；结合S105-04','集团持股及表决权100%；按披露时点，不假设直接股东'),
('OW0006','MO0017','central_state_controlled','unknown',NULL,'2026-11-28查阅','evidence_linked','CN0002','S105-05','公司简介','中国石化旗下国资委科改企业；未核具体直接股权比例');
INSERT INTO market_procurement_observations VALUES
('PR0001','CN0127','MO0015','浙江浙能催化剂技术有限公司','再生废水膜浓缩设备','award_reported','2026','S022-010','N022-007后续补证/中标索引','181.4952万元索引，非安装或投运；不是仍开放采购','既有中标设备后续优化/合作，待核合同'),
('PR0002','CN0127','MO0015','浙江浙能催化剂技术有限公司','母液干化设备','award_reported','2026','S022-010','重新招标中标索引','62.35万元，独立标段，不是膜价','核后续设备接口和运行'),
('PR0003','CN0127','MO0015','浙江浙能催化剂技术有限公司','扩建环保验收服务','solicitation_historical','2026-11','S049-12','采购单P-XJ-20261119-000026','11-25报价截止已过；结果/验收未核','跟踪验收，非开放标'),
('PR0004','CN0202',NULL,'西南化工（眉山）有限公司（项目关联方，实际招标人待核）','铜系工艺水循环EPC','award_reported','2026-08','S018-007','二次招标0747-2660SCCZUP32索引','约1640万元，中标不等于签约/验收；工艺水非必然污水','核合同包、合作及后续优化'),
('PR0005','CN0230',NULL,'江苏斯德瑞克化工有限公司（项目关联方，实际招标人待核）','扩建废水处理工程','award_reported','2026-09-20','S030-10','中标结果公告第四项','5751800元，供应商脱敏；不是仍可投标','核承包方和后续配套'),
('PR0006','CN0003','MO0017','中国石化催化剂有限公司长岭分公司','5万吨/年催化裂化催化剂联合生产装置工程','solicitation_historical','2016','S105-08','招标条件','历史业主为中国石化催化剂有限公司，招标人为长岭分公司；非当前项目','历史采购主体参考，当前包另核'),
('PR0007','CN0002','MO0017','中国石化催化剂有限公司物资装备中心','公司生产建设物资集中采购职责','policy_reference','2026-09','S105-07','官网物装中心职责','2024-01独立运行；不能推定每个污水项目均集中采购','核具体采购包及合规准入'),
('PR0008','CN0003','MO0017','中国石化催化剂有限公司物资装备中心','公司生产建设物资集中采购职责','policy_reference','2026-09','S105-07','官网物装中心职责','集团级参考，不等于云溪每个项目采购权','核具体采购包及合规准入');
INSERT INTO market_water_scope_reviews SELECT 'WS105-01',water_id,site_id,source_id,'system_capacity','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W0027' AND source_id IS NOT NULL;
INSERT INTO market_water_scope_reviews SELECT 'WS105-02',water_id,site_id,source_id,'derived_quantity','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W0029' AND source_id IS NOT NULL;
INSERT INTO market_water_scope_reviews SELECT 'WS105-03',water_id,site_id,source_id,'system_capacity','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W0105' AND source_id IS NOT NULL;
INSERT INTO market_water_scope_reviews SELECT 'WS105-04',water_id,site_id,source_id,'system_capacity','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W011-01' AND source_id IS NOT NULL;
INSERT INTO market_water_scope_reviews SELECT 'WS105-05',water_id,site_id,source_id,'system_capacity','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W0114' AND source_id IS NOT NULL;
INSERT INTO market_water_scope_reviews SELECT 'WS105-06',water_id,site_id,source_id,'system_capacity','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W0129' AND source_id IS NOT NULL;
INSERT INTO market_water_scope_reviews SELECT 'WS105-07',water_id,site_id,source_id,'unit_capacity','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W013-001' AND source_id IS NOT NULL;
INSERT INTO market_water_scope_reviews SELECT 'WS105-08',water_id,site_id,source_id,'historical_case_scale','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W013-020' AND source_id IS NOT NULL;
INSERT INTO market_water_scope_reviews SELECT 'WS105-09',water_id,site_id,source_id,'design_generation','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W013-028' AND source_id IS NOT NULL;
INSERT INTO market_water_scope_reviews SELECT 'WS105-10',water_id,site_id,source_id,'procurement_capacity','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W0150' AND source_id IS NOT NULL;
INSERT INTO market_water_scope_reviews SELECT 'WS105-11',water_id,site_id,source_id,'shared_system_capacity','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W0162' AND source_id IS NOT NULL;
INSERT INTO market_water_scope_reviews SELECT 'WS105-12',water_id,site_id,source_id,'design_generation','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W0176' AND source_id IS NOT NULL;
INSERT INTO market_water_scope_reviews SELECT 'WS105-13',water_id,site_id,source_id,'unquantified_stream','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W0191' AND source_id IS NOT NULL;
INSERT INTO market_water_scope_reviews SELECT 'WS105-14',water_id,site_id,source_id,'unit_capacity','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W022-002' AND source_id IS NOT NULL;
INSERT INTO market_water_scope_reviews SELECT 'WS105-15',water_id,site_id,source_id,'shared_system_capacity','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W0233' AND source_id IS NOT NULL;
INSERT INTO market_water_scope_reviews SELECT 'WS105-16',water_id,site_id,source_id,'system_capacity','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W027-05' AND source_id IS NOT NULL;
INSERT INTO market_water_scope_reviews SELECT 'WS105-17',water_id,site_id,source_id,'reported_unit_throughput','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W027-H12024' AND source_id IS NOT NULL;
INSERT INTO market_water_scope_reviews SELECT 'WS105-18',water_id,site_id,source_id,'reported_site_quantity','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W032-03' AND source_id IS NOT NULL;
INSERT INTO market_water_scope_reviews SELECT 'WS105-19',water_id,site_id,source_id,'unit_capacity','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W035-03' AND source_id IS NOT NULL;
INSERT INTO market_water_scope_reviews SELECT 'WS105-20',water_id,site_id,source_id,'design_generation','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W039-25' AND source_id IS NOT NULL;
INSERT INTO market_water_scope_reviews SELECT 'WS105-21',water_id,site_id,source_id,'derived_quantity','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W046-26' AND source_id IS NOT NULL;
INSERT INTO market_water_scope_reviews SELECT 'WS105-22',water_id,site_id,source_id,'design_generation','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W047-04' AND source_id IS NOT NULL;
INSERT INTO market_water_scope_reviews SELECT 'WS105-23',water_id,site_id,source_id,'shared_system_capacity','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W054-17' AND source_id IS NOT NULL;
INSERT INTO market_water_scope_reviews SELECT 'WS105-24',water_id,site_id,source_id,'system_capacity','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W056-06' AND source_id IS NOT NULL;
INSERT INTO market_water_scope_reviews SELECT 'WS105-25',water_id,site_id,source_id,'system_capacity','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W056-08' AND source_id IS NOT NULL;
INSERT INTO market_water_scope_reviews SELECT 'WS105-26',water_id,site_id,source_id,'unit_capacity','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W058-01' AND source_id IS NOT NULL;
INSERT INTO market_water_scope_reviews SELECT 'WS105-27',water_id,site_id,source_id,'system_capacity','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W059-04' AND source_id IS NOT NULL;
INSERT INTO market_water_scope_reviews SELECT 'WS105-28',water_id,site_id,source_id,'design_generation','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W060-10' AND source_id IS NOT NULL;
INSERT INTO market_water_scope_reviews SELECT 'WS105-29',water_id,site_id,source_id,'system_capacity','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W060-20' AND source_id IS NOT NULL;
INSERT INTO market_water_scope_reviews SELECT 'WS105-30',water_id,site_id,source_id,'unit_capacity','2026-11-28','人工复核原流量口径；不代表可处理流量、独立流股或实测现行数据' FROM wastewater WHERE water_id='W061-03' AND source_id IS NOT NULL;
CREATE VIEW v_market_water_observations AS
SELECT w.*,coalesce(r.scope_class,'unknown') AS scope_class,r.review_id AS scope_review_id,r.review_date,r.boundary AS scope_boundary,
 CASE WHEN w.flow IS NULL THEN 'no_quantity' WHEN r.scope_class IN ('system_capacity','unit_capacity','shared_system_capacity','procurement_capacity','historical_case_scale') THEN 'capacity_not_flow' WHEN r.scope_class='design_generation' THEN 'design_not_actual' WHEN r.scope_class IN ('reported_unit_throughput','reported_site_quantity') THEN 'reported_quantity_not_eligible_volume' WHEN r.scope_class='derived_quantity' THEN 'derived_not_actual' ELSE 'unreviewed' END AS quantity_status,
 NULL AS eligible_annual_volume
FROM wastewater w LEFT JOIN market_water_scope_reviews r ON r.water_id=w.water_id AND NOT EXISTS(SELECT 1 FROM market_water_scope_reviews n WHERE n.water_id=r.water_id AND n.review_date>r.review_date);
CREATE VIEW v_market_water_quality_observations AS SELECT m.*,w.stream AS legacy_stream,w.stage AS water_stage,w.scope_class,w.quantity_status FROM water_metrics m LEFT JOIN v_market_water_observations w ON w.water_id=m.water_id AND w.site_id=m.site_id;
CREATE VIEW v_market_ownership_review AS SELECT l.site_id,l.entity_id,l.link_role,o.observation_id,o.ownership_class,o.listed_status,o.effective_period,o.evidence_state,o.source_id,o.boundary FROM market_identity_links l LEFT JOIN market_ownership_observations o ON o.organization_id=l.entity_id WHERE l.link_state='evidence_linked' AND l.link_role IN ('legal_subject','group_scope');
CREATE VIEW v_market_procurement_evidence AS SELECT p.*,x.title AS source_title,x.url AS source_url,CASE WHEN procurement_stage='open_verified' THEN 'verify_deadline_and_scope' ELSE 'not_open_verified' END AS opening_status FROM market_procurement_observations p JOIN sources x USING(source_id);
INSERT INTO search_log VALUES
('L105-01','CN0026','R01 ownership','中触媒2025/2026实际控制人，2026-11过户及增持公告','S105-02','实际控制人变更证据','核采购主体和最新治理披露','2026-11-28'),
('L105-02','CN0309','R01 ownership','肯特催化2025年报、2026半年报实际控制人','S058-04','复用半年报独立控制权章节；原招股书全资子公司关系','核实际采购流程','2026-11-28'),
('L105-03','CN0127','R01 ownership','浙能催化剂股权、集团财务附注及省属国企性质','S105-03','集团100%持股及表决权检索摘录；省属集团官网','核完整报告期及直接持股链','2026-11-28'),
('L105-04','CN0127','R01 procurement','浙能催化剂膜浓缩中标招标2026','S022-010','已知中标证据，未新增采购结果；转应用观察','核后续验收','2026-11-28'),
('L105-05','CN0003','R01 identity procurement','中国石化催化剂公司 长岭分公司 云溪基地 全资及采购','S105-06','明确云溪基地归属和历史项目招标人；官网物装职责','核现行采购包和准入','2026-11-28'),
('L105-06','CN0070','R01 ownership','华电哈密环保科技有限公司 股权 股东 华电科工',NULL,'命中许可和招聘，未确认股权链','有正式控股披露再核','2026-11-28'),
('L105-07','CN0308','R01 ownership','山东博苑2025年年度报告实际控制人','S054-06','检索摘录无具体控制人，原年报已在库','核控制权独立章节','2026-11-28');
COMMIT;
