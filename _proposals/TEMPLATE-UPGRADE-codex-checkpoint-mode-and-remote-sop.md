# TEMPLATE-UPGRADE: Codex Checkpoint Mode 与远端操作防卡死 SOP

> 来源：模板维护者当前会话评估；本地续接记录指向 GitHub issue #195（远端状态本轮未复核）
> 状态：候选 / 待评估
> 目标版本：待确认
> Release impact：none（仅新增提案；后续落地预计 patch，待维护者确认）
> Release strategy：先以 #195 最小 Batch 单独落地 Codex CLI / sandbox / 远端操作防卡死规则；模板分层治理与多 agent 协作作为后续候选

## 1. 背景

随着 `ai-project-template` 的方法论、规则包、命令入口、文档模板、同步机制和 Web / UI / Domain Profile 不断增多，模板维护任务的执行成本正在上升。实际使用中，尤其在 Codex CLI 环境下，较容易出现以下不确定性事件：

- 长任务执行后 AI 未及时汇报，用户难以判断当前进度。
- 大范围搜索或读取大量规则后，原始目标被稀释，输出偏离用户期望。
- GitHub / CI / PR / issue 操作遇到 pending、失败、权限不足或网络限制时，AI 长时间等待或连续尝试。
- sandbox 权限不足、网络受限、凭据 / askpass / gh auth 等问题导致命令失败，但失败边界不清。
- 对话中断后需要人工打断再续接，虽然 handoff 能恢复，但执行中缺少“刹车”和“仪表盘”。

当前模板已经具备一些基础能力：任务路由、快速续接、Git 事实优先、写入确认、Task 拆分、远端预检和长输出摘要约定。缺口在于：**非快速续接任务的执行过程中，还缺少一套明确的短步执行、短汇报、失败即停、远端操作防卡死协议**。

## 2. 目标

1. 为 Codex CLI 等易受 sandbox / network / 长输出影响的环境增加可执行的 `Checkpoint Mode`（短输出 / 检查点模式）。
2. 让高风险模板维护任务默认“一步一汇报”，降低长任务跑飞和中断后不可恢复的概率。
3. 为 GitHub 远端、CI、PR、issue、push / merge / close / delete branch 等操作提供防卡死 SOP。
4. 明确命令失败、超时、权限不足、sandbox / network 错误后的停止与确认边界。
5. 在不重构整个模板文档体系的前提下，先给 AI 执行过程增加“刹车、仪表盘和续接点”。

## 3. 非目标

- 不把所有任务都强制改成短输出模式；简单阅读、单文件小修和明确一次性命令仍可保持常规节奏。
- 不在本提案阶段重构 `docs/00-09`、`ai/doc-standards/` 或完整 PLM 文档链。
- 不把 Codex CLI 的 sandbox / network 限制伪装成模板能完全解决的问题；模板只定义识别、停止、确认和恢复策略。
- 不引入真正并发多 agent 默认流程；多 agent 仅作为后续角色化协作建议。
- 不让 handoff 替代正式项目事实、验证记录、PR 说明或 issue 评论。

## 4. 建议方案：Checkpoint Mode

`Checkpoint Mode` 的核心不是“少说话”，而是：

> 每次只做一个可描述、可停止、可恢复的小步骤；每步完成后立即用短摘要汇报状态，再进入下一步。

### 4.1 默认触发条件

建议在以下场景默认启用：

- 模板维护、规则改造、同步机制、自检脚本、发布流程、提案收件箱处理。
- 涉及 GitHub / CI / Actions / PR / issue / push / merge / close / delete branch 的任务。
- 需要读取完整规则回退包、批量扫描 `_proposals/`、批量审计文档或执行全量自检。
- 修改范围预计超过 3 个文件 / 模块，或任务需要拆分为多个 Task / Batch。
- 最近发生过 AI 中断、长时间无响应、sandbox/network 错误、权限不足或 CI pending 卡住。
- 用户显式要求“短输出模式”“一步一汇报”“每步确认”“不要大范围搜索”。

### 4.2 可不强制的场景

- 单文件只读解释。
- 简单问答或不改变项目状态的局部分析。
- 用户明确要求一次性完成，且不涉及远端、CI、写入、批量搜索或全量验证。

### 4.3 每步输出格式

建议固定为 1–3 行：

```text
目标：本步要确认 / 修改 / 验证什么。
结果：关键结论 + 证据位置 / 命令退出状态。
下一步：建议动作；若涉及写入、远端或长命令，等待确认。
```

### 4.4 命令执行约束

- 一命令一目的：避免把搜索、检查、远端查询、提交、推送串成一条长命令。
- 长命令前预告：预计超过 30 秒、会联网、会产生大量输出、会写文件或会触发 CI 的命令先说明。
- 大范围搜索限制：默认限定目录、文件类型、关键词；扩大范围前先汇报原因。
- 长输出摘要：成功日志默认只保留命令、退出码、关键摘要和失败链接；失败日志保留最小可定位片段。
- 失败即停：命令失败、超时、权限不足或输出异常后，先解释原因和下一步，不继续串行执行后续步骤。
- 重试上限：同类失败默认最多重试 1 次；疑似 sandbox/network 问题不得无限循环。

### 4.5 续接与恢复

- 阶段节点后输出可复制续接摘要：当前分支、修改文件、已验证命令、未完成项、下一步。
- 多步骤维护任务可更新 `.ai/session-handoff.md`，但 handoff 只记录本地会话状态，不替代正式文档、提案或 PR 记录。
- 中断恢复时继续以 Git 客观事实为准；若 handoff 与 Git 冲突，先列冲突再等待用户确认。

## 5. 远端 / CI / sandbox 防卡死 SOP

建议新增或扩展一个小型 SOP，服务 GitHub 远端操作和 CI 查询，不混入普通编码流程。

### 5.1 远端操作前置检查

- 确认 repo root、当前分支、工作区状态、remote URL、Git identity、`gh auth status` 和仓库权限。
- push / PR / merge / close issue / delete branch 前必须单步确认。
- 如果预检发现账号不对、仓库不对、工作区 dirty、权限不足或 `gh repo view` 失败，应停止并说明，不继续远端操作。

### 5.2 CI / Actions 查询策略

- 默认只查询一次或短轮询；pending 就报告 pending，不长时间挂起。
- CI 失败时只抓取失败 job / step 的关键片段和链接，不复制完整长日志。
- 若 CI 失败原因与本次改动无关，先标记“不确定 / 可能 unrelated”，不得擅自扩大修复范围。
- 修 CI 前回到任务路由，确认是否进入 PR / CI 修复任务。

### 5.3 sandbox / network / 权限错误处理

- 识别常见错误类别：network restricted、DNS / registry 失败、permission denied、credential / askpass、gh auth、写入目录受限、命令超时。
- 错误发生后先停下，说明：命令、错误类别、是否可能由 sandbox 引起、建议下一步。
- 若任务确实需要越过 sandbox 或联网，应请求用户确认，不通过替代路径绕过权限边界。
- 对安装依赖、拉取远端、推送、删除分支、关闭 issue 等操作，必须保持单步确认。

## 6. 模板治理的后续方向

本提案建议先解决执行防跑飞问题；模板变重的结构性治理可作为后续 Batch。

### 6.1 分层建议

- `Core`：Git 事实优先、写入确认、任务路由、handoff、Checkpoint Mode、隐私边界。
- `Docs`：需求到 `docs/00-09`、追溯链、变更传播、文档裁剪。
- `Implementation`：Phase / Sprint / Task、实现边界、验证闭环、验收记录。
- `Verification`：`docs/09`、TC、smoke、回归、资源验证、Demo 验证。
- `Profiles`：Web App、UI Prototype、Domain Template、Remote / CI SOP 等可选能力包。
- `Governance`：版本、CHANGELOG、模板同步、提案收件箱、发布 checklist、自检断言。

### 6.2 能力包契约

每个能力包只定义：

1. 适用场景。
2. 必读文件。
3. 输入契约。
4. 输出契约。
5. 验证方式。
6. 自检断言。
7. 禁止项。

目标是减少“每次优化都全局改”的连锁成本，让模板维护从全局耦合转为按影响域修改。

## 7. 多 agent 协作建议

短期不建议默认开启真正并发多 agent；更适合先采用角色化流程：

- `Router / Coordinator`：判断任务类型、选择规则包、控制 Checkpoint Mode。
- `Editor`：只修改已确认的限定文件。
- `Verifier`：只运行验证、读取日志、汇总失败证据。
- `Maintainer`：处理 VERSION、CHANGELOG、同步清单、PR / issue 收口。

如果未来使用并发多 agent，建议必须使用独立 `git worktree`，共享状态只依赖 Git、handoff、task 文件、验证记录和 PR / issue 事实，不依赖某个 agent 的聊天记忆。

## 8. 建议落地批次

### Batch A：#195 最小落地（优先）

建议只处理 Codex CLI / sandbox / 远端操作防卡死：

- 在核心规则或会话规则中增加 `Checkpoint Mode` 入口、触发条件和停止条件。
- 在 `SOP.md` / `git-guide.md` / PR 收尾相关命令中提示远端操作默认使用 Checkpoint Mode。
- 明确 CI pending / failed / sandbox / network / auth 错误的短轮询、停止和确认策略。
- 给自检脚本增加 2–3 个断言，防止规则入口、SOP 索引和同步清单漂移。
- 若新增同步范围内文件，更新 `template-sync.json`。

### Batch B：能力包 / Profile 契约（后续）

- 梳理 Web / UI / Domain / Sync / Remote SOP 等 Profile 的输入、输出、验证和禁止项。
- 将重规则从全局默认读取转为按任务路由或 Profile 触发读取。
- 保持 `README.md` 轻量，只做导航，不承载治理细节。

### Batch C：角色化协作与 worktree（后续）

- 增补多 AI 会话 / 多 agent 协作时的 worktree、handoff 和验证记录约束。
- 不默认并发写同一工作区。

## 9. 预期影响面

后续落地可能涉及：

- `ai/rules-core.md`
- `ai/session-rules.md`
- `ai/commands/README.md`
- `git-guide.md`
- `SOP.md`
- `scripts/check-template.sh`
- `scripts/check-template.ps1`
- `template-sync.json`（仅当新增 / 删除同步范围文件时）
- `CHANGELOG.md` / `VERSION`（仅当实际模板行为改动合并时）

本提案文件本身不要求版本递增。

## 10. 验证建议

提案阶段：

- 检查提案文件存在且字段完整。
- 确认未修改 `VERSION` / `CHANGELOG.md` / 模板规则文件。

落地阶段：

- 运行模板自检：`bash scripts/check-template.sh` 或 PowerShell fallback。
- 检查 `SOP.md` 是否能导航到远端操作防卡死规则。
- 检查 `ai/index.md` / `ai/rules-core.md` / `ai/session-rules.md` 是否能让 AI 在高风险任务中进入 Checkpoint Mode。
- 检查 CI / 远端操作相关命令没有引入无限等待或自动关闭 / 自动删除等危险默认行为。

## 11. 风险与待确认

| ID | 待确认项 | AI 建议 | 建议依据 | 取舍影响 |
|---|---|---|---|---|
| CP-001 | Checkpoint Mode 是否作为全局默认 | 不建议全局默认；建议高风险任务默认 + 用户可显式开启 | 简单任务强制短步会降低效率 | 折中后既降低跑飞概率，也避免日常小任务过重 |
| CP-002 | 是否把模板分层治理并入 #195 | 不建议并入；后续 Batch 单独做 | #195 应聚焦 Codex / sandbox / 远端防卡死 | 避免 PR 过大、影响面过宽 |
| CP-003 | CI pending 等待多久 | 建议只查一次或短轮询，pending 即汇报 | 防止 AI 卡在等待状态 | 可能需要人工稍后触发复查 |
| CP-004 | 是否真正启用多 agent | 暂不默认；先用角色化流程模拟 | 并发写同一工作区风险高 | 降低复杂度，保留未来扩展空间 |

## 12. 下一步建议

1. 维护者确认是否以本提案作为 #195 的本地分析基线。
2. 若确认，切维护分支并执行 Batch A。
3. Batch A 落地后，根据实际改动判断 `VERSION` / `CHANGELOG.md` 发布级别。
4. PR 合并后归档本提案或在归档说明中标注已吸收范围。
