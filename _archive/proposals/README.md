# 已处理模板优化提案归档

本目录保存已经处理完成、但仍需保留审计记录的模板优化提案。

归档原则：

- `_proposals/` 是待处理 / 汇总中的提案收件箱。
- `_archive/proposals/` 是已处理提案的历史记录。
- 提案归档后，模板变更事实仍以根目录 `VERSION`、README 版本记录和 Git 历史为准。
- 归档内容不得作为当前待办事项重复执行；若要再次调整，应创建新的 `TEMPLATE-UPGRADE-*.md` 提案。

## 归档批次

| 批次 / 提案 | 归档说明 |
|---|---|
| Batch 0：`TEMPLATE-UPGRADE-batch-0-a13-sync-closure.md` | 已在 `v1.30.6` 吸收 A13 同步模板完整闭环说法、命令索引提示和自检断言；对应 issue 镜像 `issue-118.md` 已归档到 `_archive/proposals/_remote-issues/`。 |
| Batch 1：`TEMPLATE-UPGRADE-batch-1-proposal-inbox-governance-status-dictionary.md` | 已在 `v1.31.0` 吸收提案收件箱镜像机制、分批治理、横切状态词典、待确认事项总览和文档体系生成总控最低规则；对应 issue 镜像 `issue-111.md`、`issue-117.md` 已归档到 `_archive/proposals/_remote-issues/`。 |
| Batch 2：`TEMPLATE-UPGRADE-batch-2-requirements-chain-00-03.md` | 已在 `v1.33.0` 吸收 `00-03` 需求链规范、健康度矩阵、Phase 状态传播和兼容补齐规则；对应 issue 镜像 `issue-105.md`、`issue-112.md` 已归档到 `_archive/proposals/_remote-issues/`。 |
| Batch 3：`TEMPLATE-UPGRADE-batch-3-architecture-tech-risk-readiness.md` | 已在 `v1.34.0` 吸收 `04-05` 架构 / 技术方案规范、风险验证闭环、依赖配置矩阵和 readiness gate；对应 issue 镜像 `issue-106.md`、`issue-113.md` 已归档到 `_archive/proposals/_remote-issues/`。 |
| Batch 7：`TEMPLATE-UPGRADE-batch-7-docs-generation-guidance-open-items.md` | 已在 `v1.32.0` 吸收文档体系生成引导、open items 命令 / Prompt / 示例、专题方案讨论边界和定稿门禁；该批次来自维护者复核，无直接关联远端 issue。 |
| 维护修复：`TEMPLATE-UPGRADE-github-issue-query-robustness.md` | 已在 `v1.38.1` 吸收 GitHub issue / PR 查询稳定过滤、列表 + 单项状态复核和自检断言；来源为 2026-07-07 维护扫描误判复盘。 |
