# TEMPLATE-UPGRADE: 远端 issue 本地镜像硬门禁

> 来源：模板维护者（当前维护会话）
> 类型：模板优化提案
> 状态：已实施，随 v1.38.2 归档
> 建议版本：PATCH
> 关联事件：2026-07-07 处理 `#131` 前置分析时，AI 未先写入 `_proposals/_remote-issues/issue-131.md`，直接基于远端正文形成初步计划
> 落地版本：v1.38.2

## 1. 背景与问题

模板已有 C1 提案收件箱机制，要求维护者先把 GitHub proposal / feedback issue 刷新到 `_proposals/_remote-issues/issue-<number>.md`，再基于本地镜像做去重、冲突、依赖和分批计划。

本次维护会话中，AI 在继续处理 `#131` 时先直接联网读取远端正文并形成初步分析，随后才发现本地缺少 `_proposals/_remote-issues/issue-131.md`。用户指出该流程违反“先镜像、后分析”的机制。经复核确认：机制已有，但对“未落盘远端正文不得进入分析”的硬阻断表达不够防呆，自检也未锁住该关键语义。

该问题属于模板维护流程防复发改进，不属于 `#131` 的 UI 原型策略内容。

## 2. 设计目标

1. **强化镜像前置门禁**：远端 issue 正文只能用于生成 / 刷新本地镜像。
2. **阻断未镜像分析**：没有本地镜像路径的 issue 不得进入正文分析、去重、分批计划、拟修改文件或续接记录。
3. **要求路径清单输出**：C1 优化计划必须列出本轮参与分析的镜像路径、`Updated` 和 `Mirrored at`。
4. **定义误读纠偏动作**：若 AI 已误读远端正文但未落镜像，必须丢弃分析结论，先刷新镜像，再重读本地镜像。
5. **加入自检保护**：模板自检锁住“镜像硬门禁 / 本地镜像路径 / 未落盘正文不得分析”等关键表述。

## 3. 落地范围

| 文件 | 落地内容 |
|---|---|
| `_proposals/README.md` | 新增“镜像硬门禁”，要求分析必须引用本地镜像路径；误读远端正文时先丢弃结论并刷新镜像 |
| `ai/commands/template-proposal-summary.md` | C1 执行流程新增镜像路径确认步骤；无镜像路径不得进入正文分析 |
| `ai/prompts/maintainers/11-template-proposal-summary.md` | Prompt 明确远端正文只用于镜像，输出格式增加“本地镜像路径清单” |
| `template-docs/scenario-guides.md` | C1 场景增加“镜像路径确认后再分析”阻断条件 |
| `scripts/check-template.ps1` / `scripts/check-template.sh` | 增加轻量断言，防止镜像硬门禁语义后续被删除 |

## 4. 规则摘要

- 远端 issue 正文只允许用于生成 / 刷新 `_proposals/_remote-issues/issue-<number>.md`。
- 后续去重、冲突、依赖、分批计划、拟修改文件、版本影响和续接记录必须引用本地镜像路径。
- 输出优化计划前必须列出本轮参与分析的镜像文件路径与 `Updated` / `Mirrored at`。
- 若 AI 已误读远端正文但尚未写入镜像，必须丢弃基于该正文形成的分析结论，先刷新镜像，再重新读取本地镜像后继续。

## 5. 非目标

- 不处理 `#131` 的 UI 原型策略内容；该 issue 仍应作为独立 Batch 候选。
- 不改变 GitHub issue 作为远端评论、关闭状态和单项状态权威来源的定位。
- 不强制维护者使用某一种 GitHub 查询工具；`gh`、REST API、PowerShell 或 `curl` 均可，只要先刷新本地镜像。
- 不新增远端状态修改；关闭 issue、改标签或评论仍需单项状态复核和人工确认。

## 6. 验证方式

1. `git diff --check`
2. `powershell.exe -ExecutionPolicy Bypass -File scripts/check-template.ps1`
3. `C:\Program Files\Git\bin\bash.exe scripts/check-template.sh`

## 7. 待确认项

| ID | 待确认项 | AI 建议 | 建议依据 | 备选方案 | 取舍影响 / 阻塞关系 |
|---|---|---|---|---|---|
| 无 | 当前无阻塞项 | 按 PATCH 修复先合入，再回到 `#131` 正常走镜像流程 | 该问题是维护流程防复发，范围小且已验证 | 与 `#131` 合并处理 | 会混合流程修复与 UI 原型策略能力增强，降低审查清晰度 |
