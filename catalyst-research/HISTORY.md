# 历史索引与进度记录契约

## 研究阶段001–103（封存）
完整原进度原样保存：[archive/research-001-103/PROGRESS.md](archive/research-001-103/PROGRESS.md)，原始blob 24acd135ec0a817982ff7ae6ea5669d9477736d2。以下是原文件行号范围，可通过GitHub #L定位或GitHub接口按行取回；不是重新编写历史。
- [001–024](archive/research-001-103/PROGRESS.md#L1-L148)：基线、首批证据、流程图/膜结构。
- [025–050](archive/research-001-103/PROGRESS.md#L149-L300)：调度、批量工艺与证据、公开资料收口。
- [051–069](archive/research-001-103/PROGRESS.md#L301-L384)：定量、商业初筛、联系渠道。
- [070–089](archive/research-001-103/PROGRESS.md#L385-L464)：检索时效、独立报告、覆盖。
- [090–103](archive/research-001-103/PROGRESS.md#L465-L552)：实际监测、历史成本、验收及最新研究。
- [迁移目录](migrations/)保留001–103全部历史SQL；某些迁移没有单独进度标题，用文件名、Git历史、原ID和数据库记录追溯。历史规则、审计报告、方法、联系和时效规范均在[archive/research-001-103/](archive/research-001-103/)，原blob清单见manifest.json。它们是历史依据/技术参考，不覆盖当前AGENTS和WORKPLAN。转段前提交：75cc2f26ae77116fb2e70d8a434c017b15bb7de7。

## 应用开发阶段（B编号）
[history/batches/](history/batches/)按每100批分目录（0000-0099、0100-0199…），文件名 B0000_<short_slug>.md，以独立连续批次号排序，不受SQL编号影响。每个批次一个文件；旧文件冻结，必要纠错另写后续批次指向原记录。目录天然索引，无需不断追加本页；使用文件名、任务ID、site_id、迁移号、关键字或Git搜索定位。施工信息集中在批次日志，原始事实/细节以数据库迁移和证据表为准，不复制大段代码/文档。
模板：
```
# Bxxxx — 日期：主题
- task_ids: A01/R01 ...
- base_head: <起始SHA>
- migrations: 无 / 104_...
- changed: 路径、实质产出、互异主体/新增事实（如适用）
- decisions: 关键设计决策与理由、事实/推断边界
- validation: 实际命令、结果、未执行项、CI链接/待核
- blockers: 未决与失败、下一触发条件
- next: 具体任务及验收
```
每批日志建议2–4KB，超过8KB的详细测试、设计或审计放独立附件/代码/证据，日志只留链接。验证补记可写入本批日志但不为更新CI状态递归提交；下批读取真实CI并在新日志记录。Git提交SHA由Git自身承载，不要求本提交写自己的SHA。

## PROGRESS是滚动快照，不是流水账
每批原位重写（不追加），≤8 KiB UTF-8，包含当前批次、下一批次、最新迁移号、批次日志路径、最新经实际验证的数据版本及统计、当前阶段、已完成关键能力、未完成/阻塞和下一批明确验收。不得复制所有历史或每个任务的全部说明。历史只读目录仍可搜索；WORKPLAN稳定任务ID承担阶段路线。check_handoff.py在CI检查快照上限、必需链接、编号及封存文件原始Git blob。
