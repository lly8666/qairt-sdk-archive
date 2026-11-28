# 061 数据覆盖度审计（2026-11-28，062施工前）
基线提交193ffe58089a9ee8280041d5998d02f9ca5c8b5f；实际SQLite完整性ok、FK0，非空URL重复组0。分母310主体/项目，不是全国在产厂数。全国完整名录与可比市场分母尚未建立，不估全国覆盖率。

## 指标
- record_type：141基地、76项目、51候选、15纯回收；其余27种类记录（混合厂区/项目、集团、研发等）。27个省级区域，山东50、江苏47、辽宁33、浙江31（合计161/310），不是全国分布比例。
- 808来源，641非空URL，167历史线索无URL；258主体有URL、52没有。URL存在不代表实时可访问或独立原件。
- 184主体有废水记录（59.4%），121有数值流量或站能力（39.0%），70初步浓度/物性点（22.6%），178有图（57.4%）；62同时具定量水量、初步水质与图（20.0%），其中10有公开联系渠道（3.2%），仍非同范围/同时间完全可报价。
- 247最新图范围（历史86、设计133、运行18、建成9、未知1）；242部分图、5无生产废水范围，完整实际运行图0；14主体有运行阶段图（18范围），非当前全部运行。265图版本不是265厂。
- 247最新膜审查：70确认有膜范围、168未识别、2明确无膜、6不适用、1不确定；确认有膜涉及58主体。按边界视图，industrial_direct 51范围（设计31、历史15、建成1、运行4，运行涉及2主体），industrial_shared 14范围（运行1），其它5范围非直接工业废水或未核。不能用70/247估行业膜渗透率。
- 247最新改造评价：241 difficulty unknown，6 not_applicable；无可核全维度难度评级。44经济记录覆盖21主体（6.8%），长岭2010标定高氨废水净成本16.3元/t为唯一明确历史单位实证成本例；设计估算、采购成交、环保投资不能当实际成本。
- 初筛监测：25主体/1669测项，规则 result_kind 含实测或监测且排除核算、限定浓度/物性单位，含旧时点及重复样品，不代表独立监测日或当前水质；不含年报浓度等另类标签，非穷尽。
- 124公开渠道覆盖40主体（12.9%）：74电话、42邮箱、7表单、1供应商平台。department含采购/环保/EHS/技术/环境/设备的13个锚点，仍需核部门范围与实际对接资格；未拨打。
- core_public 141（首次图26、分股流量36、水质41、实际运行38）；bounded_public 78；暂缓90（event14、private3、scope11、stalled28、weak_identity34）；无任务1。每主体只取首要缺口，不是所有字段缺口。覆盖率不能由队列倒推。

## 可复算 SQL
```sql
SELECT count(*),sum(linked_url_sources>0),sum(water_records>0),sum(numeric_water_records>0),sum(quality_point_records>0),sum(diagram_count>0),sum(operating_complete_diagrams>0),sum(operating_membrane_scopes>0),sum(economics_records>0) FROM v_research_evidence_gaps;
SELECT count(*) FROM v_research_evidence_gaps WHERE numeric_water_records>0 AND quality_point_records>0 AND diagram_count>0;
SELECT count(*) FROM v_research_evidence_gaps WHERE numeric_water_records>0 AND quality_point_records>0 AND diagram_count>0 AND site_id IN (SELECT site_id FROM business_contacts);
SELECT stage,coverage,count(*),count(DISTINCT site_id) FROM v_latest_process_diagrams GROUP BY 1,2;
SELECT presence,count(*),count(DISTINCT site_id) FROM v_latest_membrane_reviews GROUP BY 1;
SELECT * FROM v_membrane_boundary_counts;
SELECT difficulty,count(*) FROM v_membrane_retrofit_rating GROUP BY 1;
SELECT count(DISTINCT site_id),count(*) FROM water_metrics WHERE (result_kind LIKE '%实测%' OR result_kind LIKE '%监测%') AND (unit IN ('mg/L','μg/L','无量纲','NTU','μS/cm','mg/l','pH') OR metric='pH') AND result_kind NOT LIKE '%核算%';
SELECT * FROM v_public_research_counts;
SELECT channel_type,count(*) FROM business_contacts GROUP BY 1;
SELECT record_type,count(*) FROM sites GROUP BY 1;
SELECT province,count(*) FROM sites GROUP BY 1;
```
## 优先策略
继续每轮30个不同主体，优先可获取验收与实际运行水质、工艺、流量；先把62个三项交集主体按同厂区同阶段核完整性，10个兼有联系渠道可优先核厂区业务部门。补52个无URL身份与直接证据；公开渠道并行补，不抓非公开私人信息。按阶段/范围和证据质量分层，切勿为全国覆盖率或改造难度虚构分母和评分。
