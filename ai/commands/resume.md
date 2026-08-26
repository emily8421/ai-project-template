# Command: resume

> Sync notice: This file is maintained by `ai-project-template` and may be overwritten when a derived project syncs template methodology.
> Do not edit it directly in derived projects; propose reusable changes in `_governance/_proposals/` and upstream them to the template repository.

## 用户说法

- `/run resume`
- 读取续接点
- 继续上次
- 恢复上下文
- 看看现在做到哪了

## 适用场景

用户只想知道当前仓库可从哪里继续，但尚未明确要求执行远端 issue / PR、同步、合并、关闭、清理或编码任务。

## 不适用场景

- 用户已明确要求执行当前 Sprint / 修 bug / 同步模板 / 关闭 issue / 合并 PR；应直接路由到对应 command。
- 用户明确要求联网核对远端状态；可先说明会离开快速续接模式，再按对应命令执行。

## 必读文件

- `ai/index.md`（只确认快速续接例外；不展开任务规则包）
- `ai/session-rules.md` §1、§3.1
- `.ai/session-handoff.md`；若不存在，再读 `NEXT-STEPS.md`

Windows / PowerShell 环境若中文规则输出乱码，先用显式 UTF-8 重读上述最小文件，不得基于乱码内容推断续接状态：

```powershell
$OutputEncoding = [System.Text.UTF8Encoding]::new()
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
Get-Content -Path ai/session-rules.md -Encoding UTF8 -Raw
```

## 执行流程

1. 进入 `ai/session-rules.md` §3.1 的快速续接模式。
2. 只运行本地只读检查：`git status --short --branch`、`git log --oneline -3`、`git stash list`、`git worktree list`，并读取 `VERSION`；除主工作区外存在活跃 worktree 时，一并报告其路径 / 分支 / 未提交改动。
3. 读取续接文件的元数据、`Current Action Card`（存在时）、当前状态、下次优先做和阻塞 / 待确认。
4. 比对 Git 客观事实与 handoff 的分支、HEAD、VERSION 和任务进度。
5. 按本文件的「恢复摘要输出契约」输出恢复摘要；`Current Action Card` 是默认决策入口，历史 checkpoint 只能用于解释和交叉核对。
6. 若 handoff stale，停止深挖旧记录，不联网、不继续执行任务，等待用户确认下一步。
7. 若用户确认继续执行任务，退出快速续接模式，回到 `ai/index.md` 规则路由与对应 command 流程；无法判断时读取完整规则回退包。

## 恢复摘要输出契约

最终答复必须按以下顺序给出可接手的 briefing，不得只复述版本、提交或 handoff 标题：

1. **续接结论**：写明 `handoff fresh / stale / missing`，以及当前是否存在活跃工作流。
2. **已确认本地事实**：当前分支与工作区、最近提交、VERSION、stash 与活跃 worktree；远端一律标为“未复核”，除非本轮已按授权复核。
3. **唯一下一步**：只给出一个推荐动作，包含工作流、目标仓库或 worktree、首个只读或可执行动作、前置条件和停止点。快速续接只报告该动作，不执行它。
4. **阻塞 / 待确认**：列出会阻止该唯一下一步的事项；须明确 AI 建议、依据、备选方案和阻塞关系。没有则写“无”。
5. **独立 backlog**：把与唯一下一步无关的后续事项单列，不能混入“下一步”。
6. **依据**：分别标明 Git、handoff、项目文档和当前用户输入的支撑范围；旧 checkpoint 只能作为历史参考。

输出裁决：

- handoff 存在 `Current Action Card` 且与 Git 一致时，以其“推荐下一步”为默认行动起点。
- 行动卡缺失时，才从最新、可信的 handoff 状态推导一个行动起点；无法唯一确定时写“待确认”，不得列出多个并列下一步。
- 行动卡、下次优先做或历史 checkpoint 与 Git 冲突时，标为 `handoff stale`，列出冲突和不确定项后停止。
- “当前任务 / 当前进度 / 下次优先做 / Latest checkpoint”中的历史段落不改变行动卡的默认决策权。
- **跨仓参考裁决**：若读到的是另一仓库的 handoff（如派生仓会话读模板仓 handoff），以行动卡 `Role` 字段判断角色归属——非本会话角色的行动卡只作背景参考，不作为本会话的下一步接续（见 `ai/session-rules.md` §3.4）。

## 写入风险

默认只读，不写文件、不联网、不改远端状态。若用户要求更新续接文件或继续执行任务，必须先说明修改范围并按项目写入确认规则执行。

## 续接要求

快速续接本身通常不更新 handoff；只有发现 handoff stale 且用户确认要修正本地续接记录时，才更新 `.ai/session-handoff.md`。
