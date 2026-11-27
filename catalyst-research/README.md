# 催化剂工厂与废水数据库

基线：2026-11-27，193条主体/项目、69条产能、95条废水记录。数据为候选底账，历史摘要尚未逐条重新验证。

运行 `python catalyst-research/build.py /tmp/catalyst.sqlite` 从完整 CSV 和有序 SQL 迁移生成 SQLite。CSV 为可审计全量数据，SQL 迁移记录每次更新；请勿直接修改生成的数据库。查看 WORKPLAN.md 和 PROGRESS.md。

本仓库公开；只存公开产业信息及明确标注的待验证线索。