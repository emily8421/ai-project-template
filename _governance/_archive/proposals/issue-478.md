# GitHub Issue #478: check-derived-sync 对 squash 合并同步 PR 的校验伪影：放宽 (#N) 尾缀匹配并补校验时点指引

> Source URL: https://github.com/emily8421/ai-project-template/issues/478
> State: OPEN
> Labels: proposal, from:web-ui-knowledge-base
> Author: emily8421
> Created: 2026-09-19T01:04:44Z
> Updated: 2026-09-19T01:04:44Z
> Mirrored at: 2026-10-27
> Mirror status: raw remote issue copy for local triage; GitHub issue remains source of comments and closure state.

## Raw Issue Body

> 来源：web-ui-knowledge-base（emily8421/web-ui-knowledge-base）派生项目回流

# TEMPLATE-UPGRADE：check-derived-sync 对 squash 合并同步 PR 的校验伪影

## 1. 动机

派生仓以 squash 方式合并同步 PR（GitHub 常用合并选项；实证仓连续两个同步 PR 均为 squash）后，main HEAD 是一个 squash 提交，`check-derived-sync`（无参，校验 HEAD）出现两类伪影失败：

1. **提交信息误报**：GitHub squash 默认把 PR 标题作为提交标题并追加 ` (#N)`。同步提交信息模式校验（`sync template vX.Y.Z from ai-project-template`）无法匹配：
   - PR 标题精确等于模式时，squash 后变成 `sync template vX.Y.Z from ai-project-template (#N)`；
   - PR 标题带说明后缀时（如 `sync template vX.Y.Z from ai-project-template（含 xx）(#N)`）更无法匹配。
2. **清单外变更误报**：A13 标准闭环的同一分支常含项目自有提交（同步前补录、同步后整理、同步运行记录、汇总入库等），squash 后这些合法项目变更与同步变更揉进同一提交 diff，逐项命中「同步清单外变更」。

同时，脚本现有指引「若 HEAD 是 PR merge commit，请改传实际同步提交」在 squash 场景失效——squash 后原同步提交随分支删除，main 上不存在任何能通过校验的提交。结果是：流程正确执行（推送前已对纯同步提交校验通过、PR CI 绿），合并后在 main 上复核边界必然失败，需要人工按伪影解读，削弱检查的信号价值。

## 1.1 与既有规则的关系（去重）

- `scripts/check-derived-sync.*` 的「HEAD 是 PR merge commit 改传实际同步提交」提示：同对象（合并后校验路径），但只覆盖 merge commit 场景（原提交仍可达）；本提案补 squash 场景（原提交随分支删除）——互补不重复。
- `ai/prompts/maintainers/12-sync-template.md` 步骤 11（边界验证）：对象相同（校验执行时点），本提案不改其流程，仅在其产物无法在合并后复核时提供脚本层容忍 + 指引补强——指向关系。
- v1.75.1 同步跨度采用清单：无关（对象为上游变更采用留痕，非边界校验）。

## 2. 拟改（建议 + 备选）

1. **放宽提交信息模式（推荐）**：同步提交信息校验在精确模式之外容忍 GitHub squash 尾缀——允许行尾 ` (#N)`（N 为 PR 编号，正则 `\s+\(#\d+\)$`）；双语实现（`check-derived-sync.sh` / `.ps1`）同步修改。可选加强：允许模式行后跟一行内短说明（谨慎，易放宽过度，默认不做）。
2. **补校验时点指引（文档各一句）**：`git-guide.md` §5 与 `12-sync-template.md` 合并后校验相关段落补——squash 合并的派生仓，权威边界校验时点在推送前（`check-derived-sync <纯同步提交>` 并留痕于同步运行记录）；合并后 HEAD 校验失败时对照推送前记录判定伪影。
3. **（备选，不改默认）**：派生侧流程建议同步 PR 只含 sync + bootstrap 提交、项目自有提交分离走另一 PR——流程成本高，仅作指引层提示，不强制。

## 3. 版本影响

PATCH（脚本一处匹配放宽 + 文档指针；不改同步清单、不收窄通过口径、不新增自检断言）。

## 4. 影响面

- `scripts/check-derived-sync.sh` / `.ps1`：提交信息模式校验一处（双语同步改）。
- `git-guide.md` §5、`ai/prompts/maintainers/12-sync-template.md`：指引各一句。
- merge commit / 普通直接提交 / 推送前纯同步提交场景零行为变化（新模式为纯放宽尾缀，不改变既有匹配）。
- 清单外变更误报**不做脚本豁免**：squash 混合提交的伪影本质是提交粒度问题，脚本无法也不应猜测哪些清单外变更有意；靠校验时点指引 + 推送前留痕对照豁免。

## 5. 验证方式

- squash 合并同步 PR 的派生仓（提交标题 `sync template vX.Y.Z from ai-project-template (#N)`）在 main 上跑 `check-derived-sync`：提交信息检查通过。
- 纯 squash 单同步提交（PR 只含同步 + bootstrap 提交）场景：合并后 HEAD 校验 0 失败。
- 既有场景回归：merge commit、普通直接提交、推送前纯同步提交的校验行为不变（模板仓全量自检 + 既有 e2e）。

## 6. 实证记录（去项目化）

- 派生仓同步 PR（squash）合并后 `check-derived-sync`（无参）失败 5 项：提交信息 1 项 + 清单外变更 4 项（同步运行记录、观察汇总入库、两份既有项目文档补录——均为 A13 流程的合法项目产出）；同一内容在推送前对纯同步提交校验通过、PR CI 绿。
- 历史先例：同仓上一轮同步 PR（v1.71.0）squash 标题 `chore/sync template v1.71.0 (#2)`，同样无法匹配同步提交信息模式。
