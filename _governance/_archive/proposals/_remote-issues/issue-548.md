# GitHub Issue #548: TEMPLATE-UPGRADE：双提交同步分支的 PR 标题显式指定（消除 squash 合并后信息伪影）

> Source URL: https://github.com/emily8421/ai-project-template/issues/548
> State: open
> Labels: proposal, from:LumiOne-Framework
> Author: emily8421
> Created: 2026-11-12T14:35:33Z
> Updated: 2026-11-12T14:35:33Z
> Mirrored at: 2026-11-14
> Mirror status: raw remote issue copy for local triage; GitHub issue remains source of comments and closure state.

## Raw Issue Body

> 来源：LumiOne-Framework（emily8421/LumiOne-Framework）派生项目回流

# TEMPLATE-UPGRADE：双提交同步分支的 PR 标题显式指定（消除 squash 合并后信息伪影）

## 1. 动机

派生项目同步分支通常含两个提交：bootstrap（`chore: bootstrap latest sync script`）+ 同步提交（`sync template vX.Y.Z from ai-project-template`）。SOP 步骤 24 的 `gh pr create --fill` 在多提交分支上取分支名 / 首提交作为 PR 标题，squash 合并后 HEAD 提交信息形如 `chore/sync template vX.Y.Z (#N)`，不匹配 `sync template vX.Y.Z from ai-project-template` 模式，导致：

- 合并后 `check-derived-sync HEAD` 报「提交信息不像模板同步提交」伪影失败（文件边界实际合规）；
- `project-check.yml` 因 HEAD 信息不匹配同步模式而跳过合并后边界校验，校验覆盖降级。

两轮派生实证：v1.76.0 轮失败（PR #12，伪影判定留痕于运行记录）；v1.78.0 轮改用显式标题后合并后校验干净通过（PR #13，`9879d6f` 信息格式匹配）。预防方案已验证有效。

## 2. 拟改

1. `ai/prompts/maintainers/12-sync-template.md` 步骤 24：同步分支含 bootstrap 等前置提交（双提交 / 多提交）时，改用 `gh pr create --title "sync template vX.Y.Z from ai-project-template" --body "<同步摘要>"` 显式指定标题；单提交分支可保留 `--fill`。
2. `git-guide.md` §5.3（v1.6.8+ 后续同步）与 §5.5 注意事项：补同口径一句（PR 标题显式指定，使 squash 合并后 HEAD 信息保持同步提交格式）。

## 3. 版本影响

PATCH（SOP 示例命令级调整，不改同步清单、不新增断言、不改变校验行为本身）。请维护者复核定级。

## 4. 影响面

行为面：仅影响含前置提交的同步分支的 PR 创建命令；单提交分支不变。文档面：`12-sync-template.md` + `git-guide.md` 两处措辞。

## 5. 与既有规则的关系（去重）

- v1.75.5「同步 PR 边界」：管收尾提交拆分（合并后 HEAD 纯净）——本提案管 PR 标题（合并后 HEAD 信息格式），互补不重复。
- v1.77.2「合并后收尾第一步纪律」：管合并后核对动作——本提案从源头消除伪影，减少该纪律需要裁决的伪影场景。
- git-guide §5.5 squash 校验时点口径：管伪影已发生时的裁决——本提案消除最高频伪影来源，为下游兜底。
- v1.76.0 轮运行记录「可优化点归纳」已登记候选并注明「复现再立案」：v1.78.0 轮复现预防机会并实证，立案条件满足。

## 6. 验证方式

- 派生实证：同仓两轮对照（`--fill` 失败 vs 显式标题通过，PR #12 / #13）。
- 模板侧验证建议：check-template 全量自检 + md-clean（文档改动）；无脚本 / 清单 / 断言变更，PATCH 豁免 L3 e2e 口径适用。
