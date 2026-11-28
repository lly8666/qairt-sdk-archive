-- B0003: additive evidence-scoped market data and read-only application projections.
PRAGMA foreign_keys=ON;
BEGIN;
INSERT INTO sources VALUES
('S106-01','河南神马催化科技股份有限公司公开转让说明书（申报稿）','https://pdf.dfcfw.com/pdf/H2_AN202406251636863604_1.pdf%3F1719321077000.pdf','公司挂牌文件文本','2024-06-25','股权结构、实际控制人（1-1-21）；截图超时','2026-11-28'),
('S106-02','贵研铂业2025年度向特定对象发行股票发行结果暨股本变动公告','https://money.finance.sina.com.cn/corp/view/vCB_AllBulletinDetail.php?id=12156816&stockid=600459','上市公告转载','2026-04','发行前后云南省国资委实际控制','2026-11-28'),
('S106-03','贵研铂业控股子公司担保公告','https://epaper.cs.com.cn/zgzqb/wap/html/2025-04/25/nw.D110000zgzqb_20250425_1-B063.htm','上市公告转载','2025-04-25','贵研资源易门全资子公司及注册地址','2026-11-28'),
('S106-04','贵研铂业2026年半年度报告','https://money.finance.sina.com.cn/corp/view/vCB_AllBulletinDetail.php?id=12510431&stockid=600459','上市披露转载','2026H1','集团控制权沿革；不代表每个采购包','2026-11-28');
INSERT INTO site_sources VALUES
('CN0144','S106-01'),
('CN0375','S106-01'),
('CN0221','S106-02'),
('CN0221','S106-03'),
('CN0221','S106-04');
INSERT INTO market_entities VALUES
('MO0018','organization','科莱恩特种化学品（嘉兴）有限公司',NULL,NULL,NULL,'historical','2022-10','CN0077','W11S01','竣工验收登记表及报告','披露时点法人，采购权限及现行状态独立待核'),
('MF0010','facility','科莱恩嘉兴厂区','浙江','嘉兴','平湖市独山港镇海昌路251号','built','2022-10','CN0077','W11S01','竣工验收登记表及报告','厂区范围，地址采用已有公开记录；不据此确认当前在产或全厂流量'),
('MO0019','organization','贺利氏贵金属技术（中国）有限公司',NULL,NULL,NULL,'historical','2025-09','CN0184','S027-05','环评现有工程','披露时点法人，采购权限及现行状态独立待核'),
('MF0011','facility','贺利氏南京精炼厂区','江苏','南京','江苏南京江北新区（详细门牌待核）','historical','2025-09','CN0184','S027-05','环评现有工程','厂区范围，地址采用已有公开记录；不据此确认当前在产或全厂流量'),
('MO0020','organization','中海油天化高科化工有限公司',NULL,NULL,NULL,'historical','2026-11-20','CN0247','S016-001','园区一期建成报道','披露时点法人，采购权限及现行状态独立待核'),
('MF0012','facility','中海油天化高科南港一期','天津','天津','南港工业区（具体边界见原环评）','built','2026-11-20','CN0247','S016-001','园区一期建成报道','厂区范围，地址采用已有公开记录；不据此确认当前在产或全厂流量'),
('MO0021','organization','西南化工（眉山）有限公司',NULL,NULL,NULL,'historical','2023-12-05','CN0202','S018-004','一期投产报道','披露时点法人，采购权限及现行状态独立待核'),
('MF0013','facility','西南化工眉山基地','四川','眉山','眉山东坡区高新技术产业园区','historical','2023-12-05','CN0202','S018-004','一期投产报道','厂区范围，地址采用已有公开记录；不据此确认当前在产或全厂流量'),
('MO0022','organization','江苏斯德瑞克化工有限公司',NULL,NULL,NULL,'historical','2025-04-27','CN0230','W07S05','扩建审批','披露时点法人，采购权限及现行状态独立待核'),
('MF0014','facility','斯德瑞克淮安扩建厂区范围','江苏','淮安','盐化新材料产业园','design','2025-04-27','CN0230','W07S05','扩建审批','厂区范围，地址采用已有公开记录；不据此确认当前在产或全厂流量'),
('MO0023','organization','岳阳长旺化工有限公司',NULL,NULL,NULL,'historical','2026-04-08','CN0288','S061-01','跨省转移申请接收设施','披露时点法人，采购权限及现行状态独立待核'),
('MF0015','facility','岳阳长旺再生厂区','湖南','岳阳','云溪绿色化工产业园','historical','2026-04-08','CN0288','S061-01','跨省转移申请接收设施','厂区范围，地址采用已有公开记录；不据此确认当前在产或全厂流量'),
('MO0024','organization','山东博苑新材料股份有限公司',NULL,NULL,NULL,'historical','2024-09-30','CN0308','S054-05','招股书项目厂区','披露时点法人，采购权限及现行状态独立待核'),
('MF0016','facility','博苑寿光侯镇基地','山东','潍坊','寿光市侯镇海洋化工园区','historical','2024-09-30','CN0308','S054-05','招股书项目厂区','厂区范围，地址采用已有公开记录；不据此确认当前在产或全厂流量'),
('MO0025','organization','高化学（江苏）化工新材料有限责任公司',NULL,NULL,NULL,'historical','2024','CN0098','turn127831search84','扩建环评既有工程','披露时点法人，采购权限及现行状态独立待核'),
('MF0017','facility','高化学南通基地','江苏','南通','经开区通顺路6号（旧库地址）','historical','2024','CN0098','turn127831search84','扩建环评既有工程','厂区范围，地址采用已有公开记录；不据此确认当前在产或全厂流量'),
('MO0026','organization','河南神马催化科技新材料有限公司',NULL,NULL,NULL,'historical','2024-09','CN0144','S102-05','子公司身份、地址及业务','披露时点法人，采购权限及现行状态独立待核'),
('MF0018','facility','河南神马平顶山生产基地','河南','平顶山','尼龙园沙河二路化工三路','historical','2024-09','CN0144','S102-05','子公司身份、地址及业务','厂区范围，地址采用已有公开记录；不据此确认当前在产或全厂流量'),
('MO0027','organization','江苏黄马化工有限公司',NULL,NULL,NULL,'historical','2024-09','CN0375','S102-05','子公司身份、地址及业务','披露时点法人，采购权限及现行状态独立待核'),
('MF0019','facility','江苏黄马淮安基地','江苏','淮安',NULL,'historical','2024-09','CN0375','S102-05','子公司身份、地址及业务','厂区范围，地址采用已有公开记录；不据此确认当前在产或全厂流量'),
('MO0028','organization','贵研资源（易门）有限公司',NULL,NULL,NULL,'historical','2025-04-25','CN0221','S106-03','子公司及注册地址','披露时点法人，采购权限及现行状态独立待核'),
('MO0029','organization','云南省贵金属新材料控股集团股份有限公司',NULL,NULL,NULL,'historical','2025-04-25','CN0221','S106-03','全资子公司担保公告','集团关系，不作为厂区采购主体'),
('MO0030','organization','河南神马催化科技股份有限公司',NULL,NULL,NULL,'historical','2024-09','CN0144','S102-05','子公司章节','2024披露母公司，不等同子公司法人');
INSERT INTO market_identity_links VALUES
('ML0031','CN0077','MO0018','legal_subject','evidence_linked','2022-10','W11S01','竣工验收登记表及报告','披露时点法人，采购权限及现行状态独立待核'),
('ML0032','CN0077','MF0010','physical_site','evidence_linked','2022-10','W11S01','竣工验收登记表及报告','厂区范围，地址采用已有公开记录；不据此确认当前在产或全厂流量'),
('ML0033','CN0184','MO0019','legal_subject','evidence_linked','2025-09','S027-05','环评现有工程','披露时点法人，采购权限及现行状态独立待核'),
('ML0034','CN0184','MF0011','physical_site','evidence_linked','2025-09','S027-05','环评现有工程','厂区范围，地址采用已有公开记录；不据此确认当前在产或全厂流量'),
('ML0035','CN0247','MO0020','legal_subject','evidence_linked','2026-11-20','S016-001','园区一期建成报道','披露时点法人，采购权限及现行状态独立待核'),
('ML0036','CN0247','MF0012','physical_site','evidence_linked','2026-11-20','S016-001','园区一期建成报道','厂区范围，地址采用已有公开记录；不据此确认当前在产或全厂流量'),
('ML0037','CN0202','MO0021','legal_subject','evidence_linked','2023-12-05','S018-004','一期投产报道','披露时点法人，采购权限及现行状态独立待核'),
('ML0038','CN0202','MF0013','physical_site','evidence_linked','2023-12-05','S018-004','一期投产报道','厂区范围，地址采用已有公开记录；不据此确认当前在产或全厂流量'),
('ML0039','CN0230','MO0022','legal_subject','evidence_linked','2025-04-27','W07S05','扩建审批','披露时点法人，采购权限及现行状态独立待核'),
('ML0040','CN0230','MF0014','physical_site','evidence_linked','2025-04-27','W07S05','扩建审批','厂区范围，地址采用已有公开记录；不据此确认当前在产或全厂流量'),
('ML0041','CN0288','MO0023','legal_subject','evidence_linked','2026-04-08','S061-01','跨省转移申请接收设施','披露时点法人，采购权限及现行状态独立待核'),
('ML0042','CN0288','MF0015','physical_site','evidence_linked','2026-04-08','S061-01','跨省转移申请接收设施','厂区范围，地址采用已有公开记录；不据此确认当前在产或全厂流量'),
('ML0043','CN0308','MO0024','legal_subject','evidence_linked','2024-09-30','S054-05','招股书项目厂区','披露时点法人，采购权限及现行状态独立待核'),
('ML0044','CN0308','MF0016','physical_site','evidence_linked','2024-09-30','S054-05','招股书项目厂区','厂区范围，地址采用已有公开记录；不据此确认当前在产或全厂流量'),
('ML0045','CN0098','MO0025','legal_subject','evidence_linked','2024','turn127831search84','扩建环评既有工程','披露时点法人，采购权限及现行状态独立待核'),
('ML0046','CN0098','MF0017','physical_site','evidence_linked','2024','turn127831search84','扩建环评既有工程','厂区范围，地址采用已有公开记录；不据此确认当前在产或全厂流量'),
('ML0047','CN0144','MO0026','legal_subject','evidence_linked','2024-09','S102-05','子公司身份、地址及业务','披露时点法人，采购权限及现行状态独立待核'),
('ML0048','CN0144','MF0018','physical_site','evidence_linked','2024-09','S102-05','子公司身份、地址及业务','厂区范围，地址采用已有公开记录；不据此确认当前在产或全厂流量'),
('ML0049','CN0375','MO0027','legal_subject','evidence_linked','2024-09','S102-05','子公司身份、地址及业务','披露时点法人，采购权限及现行状态独立待核'),
('ML0050','CN0375','MF0019','physical_site','evidence_linked','2024-09','S102-05','子公司身份、地址及业务','厂区范围，地址采用已有公开记录；不据此确认当前在产或全厂流量'),
('ML0051','CN0221','MO0028','legal_subject','evidence_linked','2025-04-25','S106-03','子公司及注册地址','披露时点法人，采购权限及现行状态独立待核'),
('ML0052','CN0221','MO0029','group_scope','evidence_linked','2025-04-25','S106-03','全资子公司担保公告','集团关系，不作为厂区采购主体'),
('ML0053','CN0144','MO0030','group_scope','evidence_linked','2024-09','S102-05','子公司章节','2024披露母公司，不等同子公司法人'),
('ML0054','CN0375','MO0030','group_scope','evidence_linked','2024-09','S102-05','子公司章节','2024历史共同母公司，不推定现在股权');
INSERT INTO market_ownership_observations VALUES
('OW0007','MO0024','private_controlled','listed',NULL,'2025-12-31','evidence_linked','CN0308','S054-06','公司治理/控股股东实际控制人任职情况','两名自然人共同控制；国资参股不等于国资控制；2026变化待核'),
('OW0008','MO0030','local_state_controlled','unknown',NULL,'2024-06-25','evidence_linked','CN0144','S106-01','股权结构及实际控制人1-1-21','河南省国资委实际控制；非当前持股链'),
('OW0009','MO0026','local_state_controlled','unknown','MO0030','2024-09','evidence_linked','CN0144','S102-05','子公司身份及全资关系；结合S106-01','历史全资子公司；后续股权需核'),
('OW0010','MO0027','local_state_controlled','unknown','MO0030','2024-09','evidence_linked','CN0375','S102-05','子公司身份及全资关系；结合S106-01','历史全资子公司；不据此确认当前采购'),
('OW0011','MO0029','local_state_controlled','listed',NULL,'2026H1','evidence_linked','CN0221','S106-04','基本情况/控制权沿革','云南省国资委实际控制；集团'),
('OW0012','MO0028','local_state_controlled','unlisted','MO0029','2025-04-25','evidence_linked','CN0221','S106-03','全资子公司；结合S106-02/04','2025全资子公司、母公司控制权另有披露；具体采购权限独立');
INSERT INTO market_procurement_observations VALUES
('PR0009','CN0221','MO0028','贵研资源（易门）有限公司','二期无机车间碱溶废水处理设备设施','award_reported','2026-10-19','S061-03','成交结果公告转载','165万元旧库披露；成交非签约验收，原包不再开放','核实施与后续优化'),
('PR0010','CN0221','MO0028','贵研资源（易门）有限公司','二期无机车间碱溶废水处理设备设施首次采购','solicitation_historical','2026-09-04','S061-02','公开竞争性谈判公告','历史自筹采购，供应商财务资料要求按该包，不泛化','查下一包合规条件'),
('PR0011','CN0247','MO0020','中海油天化高科化工有限公司（项目关联方）','一期EPC','solicitation_historical','2024-12-17','S016-003','EPC公告','历史EPC招标，采购权及分包未核，非现在开放','核既有承包方和后续服务');
CREATE TABLE market_streams (
 stream_id TEXT PRIMARY KEY,site_id TEXT NOT NULL,water_id TEXT NOT NULL UNIQUE REFERENCES wastewater(water_id),source_id TEXT NOT NULL,
 stream_name TEXT NOT NULL,stream_class TEXT NOT NULL CHECK(stream_class IN ('production','utility','mixed','residual')),
 stage TEXT NOT NULL, period TEXT NOT NULL,boundary TEXT NOT NULL,
 FOREIGN KEY(site_id,source_id) REFERENCES site_sources(site_id,source_id)
);
CREATE TABLE market_treatment_systems (
 system_id TEXT PRIMARY KEY,site_id TEXT NOT NULL,water_id TEXT NOT NULL UNIQUE REFERENCES wastewater(water_id),source_id TEXT NOT NULL,
 system_name TEXT NOT NULL,stage TEXT NOT NULL,period TEXT NOT NULL,boundary TEXT NOT NULL,
 FOREIGN KEY(site_id,source_id) REFERENCES site_sources(site_id,source_id)
);
CREATE TABLE market_stream_system_links (
 link_id TEXT PRIMARY KEY,stream_id TEXT NOT NULL REFERENCES market_streams(stream_id),system_id TEXT NOT NULL REFERENCES market_treatment_systems(system_id),
 site_id TEXT NOT NULL,source_id TEXT NOT NULL,relation TEXT NOT NULL CHECK(relation IN ('feeds','partly_feeds','designed_to_feed')),
 boundary TEXT NOT NULL, UNIQUE(stream_id,system_id,relation),FOREIGN KEY(site_id,source_id) REFERENCES site_sources(site_id,source_id)
);
CREATE TRIGGER market_streams_insert BEFORE INSERT ON market_streams WHEN NOT EXISTS (SELECT 1 FROM wastewater w WHERE w.water_id=NEW.water_id AND w.site_id=NEW.site_id AND w.source_id=NEW.source_id) BEGIN SELECT RAISE(ABORT,'water/source mismatch'); END;
CREATE TRIGGER market_streams_update BEFORE UPDATE ON market_streams WHEN NOT EXISTS (SELECT 1 FROM wastewater w WHERE w.water_id=NEW.water_id AND w.site_id=NEW.site_id AND w.source_id=NEW.source_id) BEGIN SELECT RAISE(ABORT,'water/source mismatch'); END;
CREATE TRIGGER market_treatment_systems_insert BEFORE INSERT ON market_treatment_systems WHEN NOT EXISTS (SELECT 1 FROM wastewater w WHERE w.water_id=NEW.water_id AND w.site_id=NEW.site_id AND w.source_id=NEW.source_id) BEGIN SELECT RAISE(ABORT,'water/source mismatch'); END;
CREATE TRIGGER market_treatment_systems_update BEFORE UPDATE ON market_treatment_systems WHEN NOT EXISTS (SELECT 1 FROM wastewater w WHERE w.water_id=NEW.water_id AND w.site_id=NEW.site_id AND w.source_id=NEW.source_id) BEGIN SELECT RAISE(ABORT,'water/source mismatch'); END;
CREATE TRIGGER market_stream_system_insert BEFORE INSERT ON market_stream_system_links WHEN NOT EXISTS(SELECT 1 FROM market_streams a JOIN market_treatment_systems b ON a.site_id=b.site_id AND a.source_id=b.source_id WHERE a.stream_id=NEW.stream_id AND b.system_id=NEW.system_id AND a.site_id=NEW.site_id AND a.source_id=NEW.source_id) BEGIN SELECT RAISE(ABORT,'stream/system cross-boundary'); END;
CREATE TRIGGER market_stream_system_update BEFORE UPDATE ON market_stream_system_links WHEN NOT EXISTS(SELECT 1 FROM market_streams a JOIN market_treatment_systems b ON a.site_id=b.site_id AND a.source_id=b.source_id WHERE a.stream_id=NEW.stream_id AND b.system_id=NEW.system_id AND a.site_id=NEW.site_id AND a.source_id=NEW.source_id) BEGIN SELECT RAISE(ABORT,'stream/system cross-boundary'); END;
INSERT INTO market_streams SELECT 'ST-W060-01',site_id,water_id,source_id,stream,'production',stage,'2026扩建设计','表4.3-11分项设计；不与汇总重复，不是实际可处理年量' FROM wastewater WHERE water_id='W060-01';
INSERT INTO market_streams SELECT 'ST-W060-02',site_id,water_id,source_id,stream,'production',stage,'2026扩建设计','表4.3-11分项设计；不与汇总重复，不是实际可处理年量' FROM wastewater WHERE water_id='W060-02';
INSERT INTO market_streams SELECT 'ST-W060-03',site_id,water_id,source_id,stream,'production',stage,'2026扩建设计','表4.3-11分项设计；不与汇总重复，不是实际可处理年量' FROM wastewater WHERE water_id='W060-03';
INSERT INTO market_streams SELECT 'ST-W060-04',site_id,water_id,source_id,stream,'production',stage,'2026扩建设计','表4.3-11分项设计；不与汇总重复，不是实际可处理年量' FROM wastewater WHERE water_id='W060-04';
INSERT INTO market_streams SELECT 'ST-W060-05',site_id,water_id,source_id,stream,'production',stage,'2026扩建设计','表4.3-11分项设计；不与汇总重复，不是实际可处理年量' FROM wastewater WHERE water_id='W060-05';
INSERT INTO market_streams SELECT 'ST-W060-06',site_id,water_id,source_id,stream,'production',stage,'2026扩建设计','表4.3-11分项设计；不与汇总重复，不是实际可处理年量' FROM wastewater WHERE water_id='W060-06';
INSERT INTO market_streams SELECT 'ST-W060-07',site_id,water_id,source_id,stream,'production',stage,'2026扩建设计','表4.3-11分项设计；不与汇总重复，不是实际可处理年量' FROM wastewater WHERE water_id='W060-07';
INSERT INTO market_streams SELECT 'ST-W060-08',site_id,water_id,source_id,stream,'production',stage,'2026扩建设计','表4.3-11分项设计；不与汇总重复，不是实际可处理年量' FROM wastewater WHERE water_id='W060-08';
INSERT INTO market_streams SELECT 'ST-W060-09',site_id,water_id,source_id,stream,'production',stage,'2026扩建设计','表4.3-11分项设计；不与汇总重复，不是实际可处理年量' FROM wastewater WHERE water_id='W060-09';
INSERT INTO market_streams SELECT 'ST-W060-10',site_id,water_id,source_id,stream,'residual',stage,'2026扩建设计','表4.3-11分项设计；不与汇总重复，不是实际可处理年量' FROM wastewater WHERE water_id='W060-10';
INSERT INTO market_streams SELECT 'ST-W060-11',site_id,water_id,source_id,stream,'production',stage,'2026扩建设计','表4.3-11分项设计；不与汇总重复，不是实际可处理年量' FROM wastewater WHERE water_id='W060-11';
INSERT INTO market_streams SELECT 'ST-W060-12',site_id,water_id,source_id,stream,'mixed',stage,'2026扩建设计','表4.3-11分项设计；不与汇总重复，不是实际可处理年量' FROM wastewater WHERE water_id='W060-12';
INSERT INTO market_streams SELECT 'ST-W060-13',site_id,water_id,source_id,stream,'utility',stage,'2026扩建设计','表4.3-11分项设计；不与汇总重复，不是实际可处理年量' FROM wastewater WHERE water_id='W060-13';
INSERT INTO market_streams SELECT 'ST-W060-14',site_id,water_id,source_id,stream,'utility',stage,'2026扩建设计','表4.3-11分项设计；不与汇总重复，不是实际可处理年量' FROM wastewater WHERE water_id='W060-14';
INSERT INTO market_streams SELECT 'ST-W060-15',site_id,water_id,source_id,stream,'utility',stage,'2026扩建设计','表4.3-11分项设计；不与汇总重复，不是实际可处理年量' FROM wastewater WHERE water_id='W060-15';
INSERT INTO market_streams SELECT 'ST-W060-16',site_id,water_id,source_id,stream,'utility',stage,'2026扩建设计','表4.3-11分项设计；不与汇总重复，不是实际可处理年量' FROM wastewater WHERE water_id='W060-16';
INSERT INTO market_streams SELECT 'ST-W059-07',site_id,water_id,source_id,stream,'production',stage,'2025三期设计','分质设计，不证明三期投运' FROM wastewater WHERE water_id='W059-07';
INSERT INTO market_streams SELECT 'ST-W059-08',site_id,water_id,source_id,stream,'production',stage,'2025三期设计','分质设计，不证明三期投运' FROM wastewater WHERE water_id='W059-08';
INSERT INTO market_streams SELECT 'ST-W059-09',site_id,water_id,source_id,stream,'production',stage,'2025三期设计','分质设计，不证明三期投运' FROM wastewater WHERE water_id='W059-09';
INSERT INTO market_streams SELECT 'ST-W059-10',site_id,water_id,source_id,stream,'production',stage,'2025三期设计','分质设计，不证明三期投运' FROM wastewater WHERE water_id='W059-10';
INSERT INTO market_streams SELECT 'ST-W059-11',site_id,water_id,source_id,stream,'production',stage,'2025三期设计','分质设计，不证明三期投运' FROM wastewater WHERE water_id='W059-11';
INSERT INTO market_streams SELECT 'ST-W059-12',site_id,water_id,source_id,stream,'production',stage,'2025三期设计','分质设计，不证明三期投运' FROM wastewater WHERE water_id='W059-12';
INSERT INTO market_streams SELECT 'ST-W056-03',site_id,water_id,source_id,stream,'production',stage,'2024历史回顾','报告所述废水分股；未取得真实分股年量' FROM wastewater WHERE water_id='W056-03';
INSERT INTO market_streams SELECT 'ST-W056-04',site_id,water_id,source_id,stream,'production',stage,'2024历史回顾','报告所述废水分股；未取得真实分股年量' FROM wastewater WHERE water_id='W056-04';
INSERT INTO market_streams SELECT 'ST-W056-05',site_id,water_id,source_id,stream,'mixed',stage,'2024历史回顾','报告所述废水分股；未取得真实分股年量' FROM wastewater WHERE water_id='W056-05';
INSERT INTO market_streams SELECT 'ST-W013-001',site_id,water_id,source_id,stream,'production',stage,'2023-12','CFRO设备设计能力，不是实际进料' FROM wastewater WHERE water_id='W013-001';
INSERT INTO market_treatment_systems SELECT 'SY-W0192',site_id,water_id,source_id,stream,stage,'2026环评既有','一期站，50t/d容量' FROM wastewater WHERE water_id='W0192';
INSERT INTO market_treatment_systems SELECT 'SY-W0193',site_id,water_id,source_id,stream,stage,'2026环评既有','二期再生站，4t/h容量' FROM wastewater WHERE water_id='W0193';
INSERT INTO market_treatment_systems SELECT 'SY-W059-01',site_id,water_id,source_id,stream,stage,'2025环评历史','一期停用备用' FROM wastewater WHERE water_id='W059-01';
INSERT INTO market_treatment_systems SELECT 'SY-W059-04',site_id,water_id,source_id,stream,stage,'2025环评既有','二期在用披露，2000t/d能力' FROM wastewater WHERE water_id='W059-04';
INSERT INTO market_treatment_systems SELECT 'SY-W059-21',site_id,water_id,source_id,stream,stage,'2025三期设计','设计容量原报告单位冲突，不取数' FROM wastewater WHERE water_id='W059-21';
INSERT INTO market_treatment_systems SELECT 'SY-W056-01',site_id,water_id,source_id,stream,stage,'2024历史','400t/d旧站' FROM wastewater WHERE water_id='W056-01';
INSERT INTO market_treatment_systems SELECT 'SY-W056-06',site_id,water_id,source_id,stream,stage,'2024设计','1000t/d替代站，非实运' FROM wastewater WHERE water_id='W056-06';
INSERT INTO market_stream_system_links SELECT 'SL-W060-01-W0193',a.stream_id,b.system_id,a.site_id,a.source_id,'designed_to_feed','扩建环评计划依托既有站，非实际流向证实' FROM market_streams a JOIN market_treatment_systems b ON a.site_id=b.site_id AND a.source_id=b.source_id WHERE a.stream_id='ST-W060-01' AND b.system_id='SY-W0193';
INSERT INTO market_stream_system_links SELECT 'SL-W060-02-W0193',a.stream_id,b.system_id,a.site_id,a.source_id,'designed_to_feed','扩建环评计划依托既有站，非实际流向证实' FROM market_streams a JOIN market_treatment_systems b ON a.site_id=b.site_id AND a.source_id=b.source_id WHERE a.stream_id='ST-W060-02' AND b.system_id='SY-W0193';
INSERT INTO market_stream_system_links SELECT 'SL-W060-03-W0193',a.stream_id,b.system_id,a.site_id,a.source_id,'designed_to_feed','扩建环评计划依托既有站，非实际流向证实' FROM market_streams a JOIN market_treatment_systems b ON a.site_id=b.site_id AND a.source_id=b.source_id WHERE a.stream_id='ST-W060-03' AND b.system_id='SY-W0193';
INSERT INTO market_stream_system_links SELECT 'SL-W060-04-W0193',a.stream_id,b.system_id,a.site_id,a.source_id,'designed_to_feed','扩建环评计划依托既有站，非实际流向证实' FROM market_streams a JOIN market_treatment_systems b ON a.site_id=b.site_id AND a.source_id=b.source_id WHERE a.stream_id='ST-W060-04' AND b.system_id='SY-W0193';
INSERT INTO market_stream_system_links SELECT 'SL-W060-05-W0193',a.stream_id,b.system_id,a.site_id,a.source_id,'designed_to_feed','扩建环评计划依托既有站，非实际流向证实' FROM market_streams a JOIN market_treatment_systems b ON a.site_id=b.site_id AND a.source_id=b.source_id WHERE a.stream_id='ST-W060-05' AND b.system_id='SY-W0193';
INSERT INTO market_stream_system_links SELECT 'SL-W060-06-W0193',a.stream_id,b.system_id,a.site_id,a.source_id,'designed_to_feed','扩建环评计划依托既有站，非实际流向证实' FROM market_streams a JOIN market_treatment_systems b ON a.site_id=b.site_id AND a.source_id=b.source_id WHERE a.stream_id='ST-W060-06' AND b.system_id='SY-W0193';
INSERT INTO market_stream_system_links SELECT 'SL-W060-07-W0193',a.stream_id,b.system_id,a.site_id,a.source_id,'designed_to_feed','扩建环评计划依托既有站，非实际流向证实' FROM market_streams a JOIN market_treatment_systems b ON a.site_id=b.site_id AND a.source_id=b.source_id WHERE a.stream_id='ST-W060-07' AND b.system_id='SY-W0193';
INSERT INTO market_stream_system_links SELECT 'SL-W060-08-W0193',a.stream_id,b.system_id,a.site_id,a.source_id,'designed_to_feed','扩建环评计划依托既有站，非实际流向证实' FROM market_streams a JOIN market_treatment_systems b ON a.site_id=b.site_id AND a.source_id=b.source_id WHERE a.stream_id='ST-W060-08' AND b.system_id='SY-W0193';
INSERT INTO market_stream_system_links SELECT 'SL-W060-09-W0193',a.stream_id,b.system_id,a.site_id,a.source_id,'designed_to_feed','扩建环评计划依托既有站，非实际流向证实' FROM market_streams a JOIN market_treatment_systems b ON a.site_id=b.site_id AND a.source_id=b.source_id WHERE a.stream_id='ST-W060-09' AND b.system_id='SY-W0193';
INSERT INTO market_stream_system_links SELECT 'SL-W060-11-W0193',a.stream_id,b.system_id,a.site_id,a.source_id,'designed_to_feed','扩建环评计划依托既有站，非实际流向证实' FROM market_streams a JOIN market_treatment_systems b ON a.site_id=b.site_id AND a.source_id=b.source_id WHERE a.stream_id='ST-W060-11' AND b.system_id='SY-W0193';
INSERT INTO market_stream_system_links SELECT 'SL-W060-12-W0193',a.stream_id,b.system_id,a.site_id,a.source_id,'designed_to_feed','扩建环评计划依托既有站，非实际流向证实' FROM market_streams a JOIN market_treatment_systems b ON a.site_id=b.site_id AND a.source_id=b.source_id WHERE a.stream_id='ST-W060-12' AND b.system_id='SY-W0193';
INSERT INTO market_stream_system_links SELECT 'SL-W060-13-W0192',a.stream_id,b.system_id,a.site_id,a.source_id,'designed_to_feed','扩建环评计划依托既有站，非实际流向证实' FROM market_streams a JOIN market_treatment_systems b ON a.site_id=b.site_id AND a.source_id=b.source_id WHERE a.stream_id='ST-W060-13' AND b.system_id='SY-W0192';
INSERT INTO market_stream_system_links SELECT 'SL-W060-14-W0192',a.stream_id,b.system_id,a.site_id,a.source_id,'designed_to_feed','扩建环评计划依托既有站，非实际流向证实' FROM market_streams a JOIN market_treatment_systems b ON a.site_id=b.site_id AND a.source_id=b.source_id WHERE a.stream_id='ST-W060-14' AND b.system_id='SY-W0192';
INSERT INTO market_stream_system_links SELECT 'SL-W060-15-W0192',a.stream_id,b.system_id,a.site_id,a.source_id,'designed_to_feed','扩建环评计划依托既有站，非实际流向证实' FROM market_streams a JOIN market_treatment_systems b ON a.site_id=b.site_id AND a.source_id=b.source_id WHERE a.stream_id='ST-W060-15' AND b.system_id='SY-W0192';
INSERT INTO market_stream_system_links SELECT 'SL-W060-16-W0192',a.stream_id,b.system_id,a.site_id,a.source_id,'designed_to_feed','扩建环评计划依托既有站，非实际流向证实' FROM market_streams a JOIN market_treatment_systems b ON a.site_id=b.site_id AND a.source_id=b.source_id WHERE a.stream_id='ST-W060-16' AND b.system_id='SY-W0192';
INSERT INTO market_stream_system_links SELECT 'SL-W059-07-W059-21',a.stream_id,b.system_id,a.site_id,a.source_id,'designed_to_feed','分质预处理后全厂站设计；非现行运行' FROM market_streams a JOIN market_treatment_systems b ON a.site_id=b.site_id AND a.source_id=b.source_id WHERE a.stream_id='ST-W059-07' AND b.system_id='SY-W059-21';
INSERT INTO market_stream_system_links SELECT 'SL-W059-08-W059-21',a.stream_id,b.system_id,a.site_id,a.source_id,'designed_to_feed','分质预处理后全厂站设计；非现行运行' FROM market_streams a JOIN market_treatment_systems b ON a.site_id=b.site_id AND a.source_id=b.source_id WHERE a.stream_id='ST-W059-08' AND b.system_id='SY-W059-21';
INSERT INTO market_stream_system_links SELECT 'SL-W059-09-W059-21',a.stream_id,b.system_id,a.site_id,a.source_id,'designed_to_feed','分质预处理后全厂站设计；非现行运行' FROM market_streams a JOIN market_treatment_systems b ON a.site_id=b.site_id AND a.source_id=b.source_id WHERE a.stream_id='ST-W059-09' AND b.system_id='SY-W059-21';
INSERT INTO market_stream_system_links SELECT 'SL-W059-10-W059-21',a.stream_id,b.system_id,a.site_id,a.source_id,'designed_to_feed','分质预处理后全厂站设计；非现行运行' FROM market_streams a JOIN market_treatment_systems b ON a.site_id=b.site_id AND a.source_id=b.source_id WHERE a.stream_id='ST-W059-10' AND b.system_id='SY-W059-21';
INSERT INTO market_stream_system_links SELECT 'SL-W059-11-W059-21',a.stream_id,b.system_id,a.site_id,a.source_id,'designed_to_feed','分质预处理后全厂站设计；非现行运行' FROM market_streams a JOIN market_treatment_systems b ON a.site_id=b.site_id AND a.source_id=b.source_id WHERE a.stream_id='ST-W059-11' AND b.system_id='SY-W059-21';
INSERT INTO market_stream_system_links SELECT 'SL-W059-12-W059-21',a.stream_id,b.system_id,a.site_id,a.source_id,'designed_to_feed','分质预处理后全厂站设计；非现行运行' FROM market_streams a JOIN market_treatment_systems b ON a.site_id=b.site_id AND a.source_id=b.source_id WHERE a.stream_id='ST-W059-12' AND b.system_id='SY-W059-21';
INSERT INTO market_stream_system_links SELECT 'SL-W056-03-W056-01',a.stream_id,b.system_id,a.site_id,a.source_id,'feeds','历史预处理及综合站边界，非2026实况' FROM market_streams a JOIN market_treatment_systems b ON a.site_id=b.site_id AND a.source_id=b.source_id WHERE a.stream_id='ST-W056-03' AND b.system_id='SY-W056-01';
INSERT INTO market_stream_system_links SELECT 'SL-W056-04-W056-01',a.stream_id,b.system_id,a.site_id,a.source_id,'feeds','历史预处理及综合站边界，非2026实况' FROM market_streams a JOIN market_treatment_systems b ON a.site_id=b.site_id AND a.source_id=b.source_id WHERE a.stream_id='ST-W056-04' AND b.system_id='SY-W056-01';
INSERT INTO market_stream_system_links SELECT 'SL-W056-05-W056-01',a.stream_id,b.system_id,a.site_id,a.source_id,'feeds','历史预处理及综合站边界，非2026实况' FROM market_streams a JOIN market_treatment_systems b ON a.site_id=b.site_id AND a.source_id=b.source_id WHERE a.stream_id='ST-W056-05' AND b.system_id='SY-W056-01';
CREATE VIEW v_market_measurement_groups AS
SELECT 'PT-'||hex(site_id)||'-'||CASE WHEN water_id IS NULL THEN 'U' ELSE 'W'||hex(water_id) END||'-'||hex(coalesce(point,''))||'-'||hex(coalesce(source_id,''))||'-'||hex(coalesce(period,''))||'-'||hex(coalesce(result_kind,'')) AS group_id,
 site_id,water_id,point,source_id,period,result_kind,count(*) AS metric_count,
 'reported_point_label_not_verified_physical_point' AS boundary
FROM water_metrics GROUP BY site_id,water_id,point,source_id,period,result_kind;
CREATE VIEW v_market_production_observations AS SELECT c.*,s.title AS source_title,s.url AS source_url,'legacy_scope_not_normalized_line' AS boundary FROM capacity c LEFT JOIN sources s USING(source_id);
CREATE VIEW v_market_project_observations AS SELECT p.*,s.title AS source_title,s.url AS source_url,'project_not_operating_factory' AS boundary FROM projects p LEFT JOIN sources s USING(source_id);
CREATE VIEW v_market_app_catalog AS
SELECT i.*,s.category,s.water_summary,s.capacity_summary,
 (SELECT count(*) FROM wastewater w WHERE w.site_id=i.site_id) AS water_count,
 (SELECT count(*) FROM market_streams w WHERE w.site_id=i.site_id) AS stream_count,
 (SELECT count(*) FROM water_metrics m WHERE m.site_id=i.site_id) AS metric_count,
 (SELECT count(*) FROM market_procurement_observations p WHERE p.site_id=i.site_id) AS procurement_count,
 (SELECT count(*) FROM market_ownership_observations o JOIN market_identity_links l ON l.entity_id=o.organization_id WHERE l.site_id=i.site_id AND l.link_role='legal_subject' AND l.link_state='evidence_linked' AND o.evidence_state='evidence_linked') AS legal_ownership_count,
 (SELECT count(*) FROM commercial_opportunity_screen p WHERE p.site_id=i.site_id) AS seed_count
FROM v_market_identity_slots i JOIN sites s USING(site_id);
COMMIT;
