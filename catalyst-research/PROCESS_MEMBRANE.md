# 工艺图、膜技术及改造核查（现行）

原009及后续表结构保留：process_diagrams、process_diagram_evidence、membrane_reviews、membrane_units、membrane_retrofits。详细字段和评分依据见archive/research-001-103/PROCESS_MEMBRANE.md（继续作为技术参考，逐厂全图硬门槛已取消）。新应用增加流股/处理系统/设备拓扑时保留原版本和证据映射。

- 按厂区、系统、流股、scope_key、时期、stage、revision组织图。stage operating/built/design/historical/unknown；coverage partial/complete/no_production_wastewater。只画有证据支持的节点及连边，标未知、分流、浓水、污泥/盐、回流、共享站边界。原始图文件非必需；不能将设计和历史连成当前运行图。默认展示最新适用范围并明显标阶段，旧版可查。
- 膜状态 confirmed_present/confirmed_absent/not_identified/uncertain/not_applicable；没有提膜不等于没有。分别识别生产废水、纯水、公用、物料膜；MF/UF/NF/RO/MBR/ED/EDR/BMED/FO/MD/OTHER/UNSPECIFIED，滤布压滤及MVR不是膜。设备参数、流量、进出水、浓水、回收率、压力、型号、能耗、CIP、寿命有证据才录，未知留空。
- 改造路线为独立INFERRED方案，不进入事实图。结合具体流股与公司技术版本，比较原路线、前处理、膜浓缩/回用/资源回收及合法浓水去向；不保证膜替代蒸发或适合所有废水。候选/有条件/不建议/不可行/未知/不适用。六维难度（原水、预处理、浓水、集成、运行、合规经济）逐项0/1/2须有依据，任一未知则总体未知；保留假设、验证和替代方案。
- 应用以能支撑业务初筛为主，不强求每厂完整现行图或私有成本；高价值项目以真实分股和公司能力边界补证，技术升级后重匹配。历史研究图不是公司已建方案，不自动视为适配/确认采购。
