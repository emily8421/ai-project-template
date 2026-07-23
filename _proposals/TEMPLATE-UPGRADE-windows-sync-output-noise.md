# TEMPLATE-UPGRADE: Windows sync-template 输出降噪与大同步摘要

> 来源：模板维护者（token-hotspot records：digital-cs-demo 大同步、sync 代理回流）
> 状态：文档 / prompt 已落地（v1.56.4）；脚本侧降噪重新评估（2026-07-24）：sync-template `--summary` / `--no-stat` 早已有（v1.44.0+，成功路径轻量摘要已满足），**真剩余 = check-derived-sync 成功路径摘要化 + sync diff/stat 阶段 CRLF 更窄过滤**
> 目标版本：文档 / prompt = v1.56.4（已发布）；脚本降噪余项待确认
> Release impact：patch（文档 / prompt v1.56.4 已落地；脚本降噪余项后续 patch）
> Release strategy：文档 / prompt（✅ v1.56.4）；脚本余项同主题单独 PR（check-derived-sync 摘要 + CRLF 更窄过滤）

## 1. 背景

在 Windows / Git Bash 环境执行 `sync-template.sh --dry-run` 或 `--commit` 时，大批量同步会输出大量 `warning: LF will be replaced by CRLF` 与 diff-stat。digital-cs-demo 从 v1.30.4 同步到 v1.54.2 时，119 个文件产生 258+ 行 dry-run 输出，后续 `check-derived-sync.ps1` 成功路径又列出约 250 行；一次 dry-run 命中工具默认 120s 超时，但脚本本身并非真实失败。

这类噪音对人和 AI 都是高成本：容易把“工具超时 / 输出过长”误判为脚本失败，也会把大量低价值成功日志带入上下文。已有 H-003 规定成功长输出只保留摘要，但 sync 命令本身仍缺少更友好的大同步输出策略。

## 2. 目标

1. 降低 Windows 大同步中 CRLF 警告和成功文件清单对上下文的污染。
2. 明确大同步 dry-run / commit 的推荐执行方式：长超时、重定向 log、grep 摘要、失败才展开。
3. 在不改变同步语义、不隐藏真实失败的前提下，优化成功路径输出。
4. 将 `check-derived-sync` 成功路径从逐文件长列表逐步收敛为计数 + 摘要，失败或可疑时再展开。

## 3. 非目标

- 不修改派生项目的 `core.autocrlf`、`.gitattributes` 或换行策略。
- 不吞掉真实 Git 错误、冲突、删除、越界修改或校验失败。
- 不改变 `sync-template` 的文件选择、版本机制、TEMPLATE-BASE 写入或提交行为。
- 不要求所有 AI 工具都支持同样的超时参数；文档只给推荐策略。

## 4. 拟改

| 文件 | 改动 | 状态 |
|---|---|---|
| `git-guide.md` | §5.8 Windows 大同步输出：重定向 log、长超时、grep 摘要、CRLF 不判失败、失败才展开。 | ✅ 已落地 v1.56.4 |
| `ai/prompts/maintainers/12-sync-template.md` | A13 SOP 大同步输出处理步骤（成功摘要化、失败最小定位、CRLF 不判失败）。 | ✅ 已落地 v1.56.4 |
| `scripts/sync-template.sh` | `--summary` / `--no-stat` **已存在（v1.44.0+，成功路径轻量摘要已满足）**；剩余仅评估 diff/stat 阶段过滤精确 `LF will be replaced by CRLF` 噪音。 | 部分满足；CRLF 过滤 = 真余项 |
| `scripts/sync-template.ps1` | PowerShell fallback 对称提示 / 摘要策略评估。 | 候选 |
| `scripts/check-derived-sync.sh` / `.ps1` | 成功路径只输出同步文件计数、越界检查摘要和版本机制结果；失败 / 删除 / 越界 / 可疑时再展开逐文件列表。 | **真余项** |
| `scripts/check-template.sh` | 若改脚本输出，增加防回归断言（失败信息可见、成功摘要含关键计数 / 状态）。 | 随余项 |

> 2026-07-24 重新评估：原 §4 把「sync-template quiet/summary」列为待办，但 `--summary` / `--no-stat` 早在 v1.44.0+ 已具备（等价 `--dry-run --no-stat`，只出轻量摘要）。故脚本侧降噪收窄为上述 2 项真余项，不再含 sync-template summary。

## 5. 大同步审查 checklist 候选

1. 先跑 dry-run，并把完整输出写入本地 log。
2. 摘要输出只保留 EXIT、变化文件数、删除数、项目专属路径触及、版本机制处理结果。
3. 固定 grep 禁止路径：根 README、`ai/project-rules.md`、`docs/00-09`、业务代码目录、项目专属配置。
4. 固定 grep 版本机制：`VERSION`、`CHANGELOG.md`、`TEMPLATE-BASE.md`、`--preserve-project-version` 或 `--domain-template`。
5. 成功时不回灌完整文件列表；失败或可疑时再打开 log 中的最小相关片段。

## 6. 去项目化

- 不保留 digital-cs-demo、LUMEN-DEMO、zhiyan 等项目专属事实；仅保留“大批量派生同步 + Windows CRLF 输出噪音”的通用经验。
- 不写死本机路径、代理端口、PR 号或提交 SHA。
- 示例命令使用占位路径与占位 log 文件名。

## 7. 风险与缓解

| 风险 | 影响 | 缓解 |
|---|---|---|
| 过度过滤导致真实 Git 警告被隐藏 | 中 | 只过滤精确 CRLF warning；其他 stderr 保留或写入 log |
| quiet 输出降低审计性 | 中 | 完整 log 仍本地保留；失败时必须展开最小证据 |
| Bash / PowerShell 输出不一致 | 中 | 验收要求两端都能显示关键摘要和失败原因 |
| 文档提示替代脚本改造后执行不稳定 | 低 | 先落文档 / prompt，脚本改造单独验证 |

## 8. 验收标准

- Windows 大同步 SOP 明确“长超时 + log 重定向 + grep 摘要 + 失败展开”。
- `sync-template` 成功路径不再把大量 CRLF warning 作为主要上下文内容。
- `check-derived-sync` 成功路径可用摘要判断结果；失败路径仍能定位具体文件与原因。
- `scripts/check-template.sh` 或等效验证覆盖关键提示 / 输出行为。

## 9. 后续

- 文档 / prompt 已落地（v1.56.4）；sync-template `--summary` 早已满足，不再列为待办。
- 真剩余 2 项（2026-07-24 重新评估）：① `check-derived-sync` 成功路径摘要化（计数 + 越界 + 版本机制结果，失败 / 可疑再展开逐文件）；② sync diff/stat 阶段对精确 CRLF warning 的更窄过滤。落地前先给改动方案 + 回滚方式。
- 若后续出现非 Windows 环境的大同步输出问题，再扩展为通用 sync-output profile。
