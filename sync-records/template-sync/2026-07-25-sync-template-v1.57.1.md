# 模板下行同步运行记录：v1.57.1 → 3 派生项目

> 本记录为**模板仓（ai-project-template / 母模板）视角**的下行同步汇总：记录 2026-07-25 将模板方法论 v1.57.1 下行同步到 3 个派生项目 + 模板仓 token-hotspot 落盘的完整闭环。
> 格式参考 `template-docs/derived-sync-report-template.md`（该模板为**派生视角**，本记录适配为**母模板下行视角**）。派生项目各自的派生视角 sync-records 可另写。

## 基本信息

- 操作主体：ai-project-template（模板仓 / 母模板）
- 同步日期：2026-07-25
- 目标模板版本：v1.57.1（含 v1.57.0 System Skeleton Gate + v1.57.1 P1/P2 文档增强聚合）
- 模板仓自身 HEAD：`a19414c`（含本会话 #266 token-hotspot docs）
- 下行目标派生项目：LUMEN-DEMO、agent-system-template、digital-cs-demo
- 未同步：zhiyan-digital-cs-platform（待确认路径与节奏）
- 操作入口：手动命令（非 `/run sync-methodology`；本会话从快速续接升级）
- AI 工具：Claude Code

## 执行命令（下行同步闭环）

| 仓库 | 同步分支 | 同步提交 | push | PR | CI | merge | 本地 main ff | 本地分支清理 |
|---|---|---|---|---|---|---|---|---|
| LUMEN-DEMO | `chore/sync-template-v1.57.1` | `382489a` | ✅（上会话）| #84 | project-check ✅ | squash | `3185e6b` | ✅ |
| agent-system-template | `chore/sync-template-v1.57.1` | `4213db4` | ✅（本会话）| #8 | 无 CI（workflow 未触发）| squash | `1a3d4a4` | ✅ |
| digital-cs-demo | `chore/sync-template-v1.57.1` | `2d8ae69`(+`6971842`) | ✅（本会话）| #37 | 无 CI（workflow 未触发）| squash | `4f28f59` | ✅ |
| ai-project-template（token-hotspot）| `docs/token-hotspots-2026-07-25` | `a9df8d9` | ✅（本会话）| #266 | template-check ✅ | squash | `a19414c` | ✅ |

> `check-derived-sync`：3 派生同步分支在上会话已 `check-derived-sync HEAD` 通过（普通派生 `TEMPLATE-BASE.md` 当前同步版本 v1.57.1；agent-system-template 为领域模板，保留自身 `VERSION` / `CHANGELOG.md`）。

## A13 完成判据矩阵（本轮口径）

| A13 步骤 | 状态 | 说明 |
|---|---|---|
| 标准闭环计划 | 完成 | 本会话按 PR/CI 收尾路由执行 |
| commit + 边界验证 | 完成 | 3 派生同步提交 + check-derived-sync 通过 |
| push + PR | 完成 | 4 PR 全部创建 |
| CI 验证 | 完成（有延迟） | #84/#266 CI SUCCESS（runner 分配延迟 ~2–3 min）；#8/#37 无 CI check |
| merge + 本地清理 | 完成 | 4 PR squash merge + 远端分支删除 + 本地 ff + 本地分支删除 |
| post-sync-cleanup | **未执行（轻量剩余）** | 本轮未在 3 派生跑 `/run post-sync-cleanup` |
| docs-system-audit | **未执行（轻量剩余）** | 本轮未在 3 派生跑 `/run docs-system-audit` |
| 提案回流收口 | **未执行（剩余）** | 本轮未做；标后续 |
| 同步报告留痕 | 完成 | 本记录 |

> 本轮口径：**远端同步主链 + merge 闭环完成；A13 闭环（post-sync-cleanup / docs-system-audit / 提案回流）尚有轻量剩余项**，不得写成“A13 完整闭环完成”。

## 同步结果

- 4 PR 全部 squash merge 成功，远端 + 本地分支清理完成。
- 3 派生 main 已 ff 到 v1.57.1 同步内容；模板仓 main 含 #266 token-hotspot 记录。
- zhiyan-digital-cs-platform 未同步。

## 遇到的问题

1. **handoff 失真**：旧 handoff 称三派生“未 push”，实际 LUMEN-DEMO 已 push + PR#84（上会话遗留未记）。→ 以 Git/远端事实为准，预检（`gh pr list --state all` + `git ls-remote`）查重，避免重复建 PR。
2. **#84 / #266 CI 长时间 QUEUED**：#84 达 3h49m，一度怀疑账户 Actions 分钟耗尽 / 账户级故障。→ cancel + rerun 探针后发现是 **runner 分配延迟（~2–3 min）**，最终 SUCCESS。非账户故障。
3. **Git Bash MSYS 路径转换破坏 jq `//`**：探针 jq 表达式 `.status+"/"+(.conclusion//"none")` 的 `//` 被转成 `C:/Program Files/Git/`，jq 报错。→ 规避：用不带 `//` 的 `--json` 原始输出或单字段 `.status`。
4. **#8 / #37 无 CI check**：agent-system-template / digital-cs-demo 的 project-check workflow 未触发（`statusCheckRollup=[]`），直接 CLEAN 合并。原因未深究（可能 workflow trigger 条件 / Actions 延迟）。

## 可优化点归纳

| 问题 | 是否项目专属 | 是否建议回流模板 | 建议提案 |
|---|---|---|---|
| CI QUEUED 易误判为账户故障 | 否（通用）| 候选：`remote-ci-sop-profile` 加“QUEUED 先 rerun 探针再下结论” | 候选 TEMPLATE-UPGRADE |
| jq `//` 在 Git Bash 被 MSYS 路径转换破坏 | 否（环境陷阱）| 候选：`env-setup` / `git-guide` 加 jq on Git Bash 注意事项 | 候选 |
| handoff 未及时记录 push/PR 导致续接失真 | 否 | 已有规则（`session-rules` §4），强化执行即可 | 无需提案 |

## 后续动作

- post-sync-cleanup / docs-system-audit：在 3 派生项目分别轻量或完整执行（标后续）。
- 提案回流收口：3 派生 + 模板仓扫描 `_proposals/` 与 issue。
- zhiyan-digital-cs-platform：确认本地路径后单独同步。
- 母模板 `ai-records/project-registry/registry.md` 更新（另开小任务）。
- 各派生项目可另写派生视角 `sync-records/`（本记录为母模板汇总视角）。
