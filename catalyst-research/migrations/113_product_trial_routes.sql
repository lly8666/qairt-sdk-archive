-- 113: public procurement routes and dated CNOOC control chain.
PRAGMA foreign_keys=ON;
BEGIN;
INSERT INTO sources VALUES
('S113-01','海油发展2025年度审计报告及财务报表','https://money.finance.sina.com.cn/corp/view/vCB_AllBulletinDetail.php?id=12014166&stockid=600968','上市公告转载','2026-03','第115-116页子公司表：中海油天化高科持股100%，不据此认定直接持股','2026-11-28'),
('S113-02','海油发展2026年半年度报告摘要','https://vip.stock.finance.sina.com.cn/corp/view/vCB_AllBulletinDetail.php?id=12536253&stockid=600968','上市公告转载','2026-08-26','前十名股东：中国海洋石油集团有限公司持股81.65%；报告期控制权无变化','2026-11-28'),
('S113-03','国务院国资委央企名录','https://wap.sasac.gov.cn/n2588045/n27271785/n27271792/c14159097/content.html','政府官网','2026','名录第13项中国海洋石油集团有限公司','2026-11-28'),
('S113-04','中国石化物资采购电子商务平台','https://ec.sinopec.com/supp/index_siam.shtml','企业官方采购平台',NULL,'新供应商注册及采购公告入口；集团级','2026-11-28'),
('S113-05','中国海油采办业务管理与交易系统公开采购公告','https://buy.cnooc.com.cn/cbjyweb/001/001001/20260326/1486764033516888065-zhy.html','企业官方采购公告','2026-03-26','公告列集团采办系统入口和供应商注册；该标非天化高科污水项目','2026-11-28');
INSERT INTO site_sources VALUES ('CN0247','S113-01'),('CN0247','S113-02'),('CN0247','S113-03'),('CN0247','S113-05'),('CN0002','S113-04'),('CN0003','S113-04');
INSERT INTO market_entities VALUES
('MO0042','organization','中海油能源发展股份有限公司',NULL,NULL,NULL,'historical','2026H1','CN0247','S113-02','股东及控制权','上市母公司合并范围，非厂区采购主体');
INSERT INTO market_identity_links VALUES
('ML0068','CN0247','MO0042','group_scope','evidence_linked','2025-12-31','S113-01','子公司表','集团持股100%，直接/间接不作推断');
INSERT INTO market_ownership_observations VALUES
('OW0028','MO0042','central_state_controlled','listed',NULL,'2026H1','evidence_linked','CN0247','S113-02','股东及控制权；结合S113-03','中国海洋石油集团持股81.65%，国务院国资委央企名录'),
('OW0029','MO0020','central_state_controlled','unlisted','MO0042','2025末子公司表；2026H1母公司控制','evidence_linked','CN0247','S113-01','子公司表及S113-02/03','集团持股100%，非直接股权确认；不推断采购权限');
INSERT INTO business_contacts VALUES
('BC113-01','CN0002','中国石化催化剂有限公司长岭分公司','external_procurement','集团物资采购平台',NULL,'供应商注册及公告','supplier_portal','https://ec.sinopec.com/supp/index_siam.shtml','S113-04','新供应商注册入口',NULL,'2026-11-28','official_publication','集团级采购入口；非厂区联系人，具体准入及包件另核'),
('BC113-02','CN0003','中国石化催化剂有限公司云溪基地','external_procurement','集团物资采购平台',NULL,'供应商注册及公告','supplier_portal','https://ec.sinopec.com/supp/index_siam.shtml','S113-04','新供应商注册入口',NULL,'2026-11-28','official_publication','集团级采购入口；非厂区联系人，具体准入及包件另核'),
('BC113-03','CN0247','中海油天化高科化工有限公司','external_procurement','集团采办平台',NULL,'供应商注册及公告','supplier_portal','https://buy.cnooc.com.cn','S113-05','集团采办公告注册说明','2026-03-26','2026-11-28','official_publication','集团级入口；既有天化高科一期EPC公告S016-003在同平台；不代表当前开放或已获得准入');
COMMIT;
