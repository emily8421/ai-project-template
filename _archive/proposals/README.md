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
| 维护修复：`TEMPLATE-UPGRADE-issue-mirror-hard-gate.md` | 已在 `v1.38.2` 吸收 C1 远端 issue 本地镜像硬门禁、镜像路径清单输出和自检断言；来源为 2026-07-07 处理 `#131` 前置分析时未先落本地镜像的流程复盘。 |
| UI 原型策略：`TEMPLATE-UPGRADE-ui-prototype-strategy.md` | 已在 `v1.39.0` 吸收 UI 型项目原型策略、可视化证据、Prompt / checklist / audit / evaluation 门禁和自检断言；对应 issue 镜像 `issue-131.md` 已归档到 `_archive/proposals/_remote-issues/`。 |
| 需求探索原型：`TEMPLATE-UPGRADE-ui-prototype-exploration.md` | 已在 `v1.40.0` 吸收 A5.5 需求探索原型场景、探索记录模板、命令 / Prompt 路由、同步清单和自检断言；来源为 2026-07-07 维护会话中对“先看原型再定需求 / 架构”的流程澄清。 |
| 快速续接模式：`TEMPLATE-UPGRADE-fast-session-resume.md` | 已在 `v1.41.0` 吸收快速续接模式、`resume` 命令、handoff stale 裁决、续接元数据样例、同步清单和自检断言；来源为 2026-07-07 维护会话中过度恢复复盘。 |
| 快速续接优先路由：`TEMPLATE-UPGRADE-fast-resume-routing.md` | 已在 `v1.41.1` 吸收快速续接例外、入口裁剪、`resume` 命令路由升级和自检断言；来源为 2026-07-08 维护会话中对“读取续接点”响应过慢的复盘。 |
| 模板易用性文档补强：`TEMPLATE-UPGRADE-template-usability-docs.md` | 已在 `v1.42.0` 吸收前端交互 / UI 原型策略独立标准、实现前原型场景、`docs-scaffold` 结构模板库、术语表、同步清单和自检断言；未执行的文档模板优化候选已拆到 `_proposals/TEMPLATE-UPGRADE-docs-scaffold-followups.md` 继续评估，版本治理候选已在 `v1.42.1` 处理。 |
| 模板版本治理：`TEMPLATE-UPGRADE-version-governance.md` | 已在 `v1.42.1` 吸收 release impact / release strategy、提案收件箱不触发版本递增、同主题聚合发布、即时发布 vs 维护窗口判断和自检断言；来源为 2026-07-08 维护会话中对 `MINOR` 增长过快的复盘。 |
| 版本影响门槛收敛：`TEMPLATE-UPGRADE-version-impact-threshold.md` | 已在 `v1.44.1` 收敛 release impact 判断：兼容、可选、默认行为不变的脚本参数 / 默认关闭能力 / 自检与治理增强默认按 patch；minor 仅用于新增能力层级或新的下游采用面。 |
| 普通派生项目版本治理：`TEMPLATE-UPGRADE-derived-project-version-governance.md` | 已在 `v1.46.0` 吸收普通派生项目双版本治理最小机制：`VERSION` 记录项目自身版本，`TEMPLATE-BASE.md` 记录继承模板版本，`sync-template.* --preserve-project-version` 保留项目版本；`zhiyan` 普通派生同步试点已确认通过。 |
| 派生项目版本机制默认启用与存量迁移：`TEMPLATE-UPGRADE-derived-version-mechanism.md` | 已在 `v1.53.0`（阶段 A，新建项目默认启用版本机制：VERSION v0.1.0 + CHANGELOG + project-check.yml 校验 + project-rules §2.8）+ `v1.54.0`（阶段 B，存量派生项目版本机制启用状态非阻断检测 + 迁移引导 + 防回归断言）吸收；阶段 C（MAINTAINERS / CONTRIBUTING 文档治理）评估后不做；对应 issue #221 已关闭，镜像 `issue-221.md` 已归档到 `_archive/proposals/_remote-issues/`。 |
| Codex Checkpoint Mode 与远端操作防卡死 SOP：`TEMPLATE-UPGRADE-codex-checkpoint-mode-and-remote-sop.md` | Batch A 已落地（Checkpoint Mode 落地于 `ai/rules-core.md` §2 / `ai/session-rules.md` §3.3；远端防卡死 SOP 落地于 `git-guide.md` / `SOP.md`）；#195 已关闭；Batch B/C 已拆到 `capability-packages-and-profile-contracts` 提案。 |
| issue 镜像归档：`issue-207.md` / `issue-217.md` | 两 issue 已 CLOSED，由 v1.52.5 吸收（issue-207 Windows UTF-8 读取 → PR #216；issue-217 sync-template pathspec → PR #219）；镜像归档到 `_archive/proposals/_remote-issues/`，无对应独立提案。 |
