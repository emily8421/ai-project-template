# Remote / CI SOP Profile（远端 / CI 操作分诊契约）

> Sync notice: This file is maintained by `ai-project-template` and may be overwritten when a derived project syncs template methodology.
> Do not edit it directly in derived projects; propose reusable changes in `_proposals/` and upstream them to the template repository.

本文件是 **Remote / CI SOP Profile**：AI 做远端操作（push / PR / CI / issue 等）时，先读本契约定位"该读哪几份、怎么做"，**只读必读文件、不全量翻模板**——这就是分诊。它是 capability package 提案 Batch 3 的分诊用例，用于验证"先定位后读取"是否真省 token（CAP-007）。

> 本文件当前为**实验阶段**：已落地但暂未进入 `template-sync.json` 同步清单、未加 `check-template.*` 断言，避免触发自检双镜像联动（见提案 Batch 2 暂缓说明）。等 CAP-007 验证有效后再正式纳入同步。

## 1. 适用场景

- 触发：`push`、PR create / merge、issue close、Actions / CI 查询、远端分支处理、GitHub CLI 认证问题。
- 不适用：纯本地只读、本地编码 / 文档生成（走 Core / Implementation / Docs 层，见 `ai/index.md` 路由）。
- 相关命令：远端收尾、模板维护、派生同步、issue 关闭。

## 2. 必读文件（最小必读——只读这些，不全量翻）

- `ai/rules-core.md`（硬规则 + 写入确认 + Checkpoint Mode 触发）
- `ai/session-rules.md` §3.3（Checkpoint Mode：远端短轮询、失败即停、高风险单步确认）
- `git-guide.md` §1.1 / §1.2（远端预检、分支 / worktree）
- `SOP.md` A10 / C4（远端常用命令）
- 可选：`scripts/check-github-context.ps1`（远端上下文预检）

> 这是分诊的核心：做远端操作时只读这 4 份 + 可选 1 份，不预读全模板。

## 3. 输入契约

- 上游事实：当前 repo root、branch、origin、worktree status、`gh auth` 状态、viewer permission、目标远端动作。
- 必填前置：先 `git status --short --branch` 确认分支与未提交改动。
- 禁止从哪推断：不从 CLI 私有会话、memory、cache 推断远端 / CI 状态；以 Git 事实 + `gh` / Actions 查询为准。

## 4. 输出契约

- 必须产出：远端动作前预检摘要、高风险动作确认点、CI 状态摘要（或 pending 标注）、失败类别 + 下一步建议。
- 可选产出：PR / issue 链接、远端动作结果。
- 不得写入：不得把远端查询结果 / 候选方案写成已确认项目事实；只有 Git / PR / issue 事实可作权威。

## 5. 消费者

PR / CI 收尾、模板维护、派生同步、issue 关闭流程。

## 6. 验证方式

- `scripts/check-github-context.ps1`（远端上下文预检）。
- `gh pr checks`（一次或短轮询；CI pending 即汇报 pending，不长等）。
- `scripts/check-template.*`（待纳入同步后加断言，防入口漂移）。

## 7. 自检断言（实验阶段为文档层期望，暂不入 check-template）

- 必须存在：本文件在 `template-docs/`。
- 必须关键词：远端 / CI / push / PR / 预检 / 失败即停 / 最小必读。
- 必须禁止的漂移：不得删除"必读文件"最小集（rules-core / session-rules §3.3 / git-guide §1.1·§1.2 / SOP A10·C4）。

## 8. 禁止项

- 不绕过 sandbox / auth。
- 不无限等待 CI（pending 即汇报，短轮询）。
- 未确认不做 push / merge / close / delete / release。
- 不把候选、未确认、Mock / 降级写成已通过 / 已确认。

## 9. 分诊实验说明（CAP-007）

本 Profile 是分诊首个用例，目的是验证"先定位后读取"是否真降 token：

- **成功标准**（可继续推广 / Batch 4）：AI 做远端操作时按"必读文件"只读这 4–5 份，平均读取文件数 / token 相比之前明显下降，定位更快，且"必读"未被违背 / 未漂移。
- **失败标准**（停止铺契约）：契约写了但 AI 仍全局读，或契约与实际漂移、无人维护 → 结论为"分诊 / 契约对本模板无效"，主线 B 收敛为仅"分层地图"。

观察方式：维护者在后续远端操作任务中，对比 AI 实际读取的文件数与本契约"必读文件"的一致性。
