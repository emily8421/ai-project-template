# Token Hotspot 记录：sync 代理配置回流（PR #229）+ digital-cs-demo 同步阶段 1 评估

> 日期：2026-07-18
> 任务类型：模板维护（v1.54.2 patch：git-guide §5.7 + sync-template 双脚本 fetch 失败代理提示 + check-template 断言 + 提案）+ 派生项目大同步评估（digital-cs-demo v1.30.4→v1.54.2，跨约 24 版本，阶段 1）
> 触发条件：`ai/session-rules.md` §4.1（模板维护改同步清单文件 + 自检脚本断言 + 派生项目跨版本 dry-run 大输出；check-template 自检失败一次 debug 往返）

## 热点工作

- **规则读取**（部分复用同会话前任务上下文 H-001）：`ai/index.md`、`ai/rules-core.md`、`ai/session-rules.md`、`ai/commands/submit-proposal.md`、`ai/commands/commit-message.md` + `ai/prompts/git/06-commit-message.md`。
- **sync 代理回流**：
  - `git-guide.md` §5（139-278 行，定位 §5.7 插入点 = §6 前）
  - `_proposals/TEMPLATE-UPGRADE-token-hotspot-records.md`（270 行，提案格式参考）
  - `scripts/sync-template.sh`（grep 定位 fetch §427 + 读 415-454）/ `.ps1`（grep 定位 fetch §609 + 读 595-639）
  - `scripts/check-template.sh` 断言区 §925-964 + `require_contains` 定义 §38-49（`grep -Eq` 关键）；`check-template.ps1` 断言结构（grep 确认只 4 个 `Require-Contains`，简化 fallback，不镜像）
  - 母模板 `CHANGELOG.md` 顶部（v1.54.1 条目，定位 v1.54.2 插入点）
  - 改 7 文件 + commit + push + PR #229 + Monitor CI（template-check pass 9s）+ squash 合并 `c859dd4`
- **digital-cs-demo 阶段 1 评估**：
  - memory `derived-project-digital-cs-demo`（8 天旧，验证现状：v1.30.4 / 无 TEMPLATE-BASE / 无 workflow / 旧 sync 脚本 / docs 齐全）
  - bootstrap 最新 sync-template.sh（fetch 模板远端 v1.54.2，设 local proxy 7897，commit `68d16e7`）
  - dry-run（523 行 log）+ dry-run `--preserve-project-version`（确认双版本保护 VERSION/CHANGELOG + 首次生成 TEMPLATE-BASE.md）
  - dry-run log 审查（grep 项目专属触及 + head 版本机制关键词，未全读 523 行）

## 热点判断

- **主要成本**：sync 代理回流的脚本段读取（git-guide §5 140 行 + token-hotspot 提案 270 行格式参考 + sync-template/check-template 脚本段）；digital-cs-demo dry-run log 523 行（grep/head 审查未全刷）。
- **debug 往返**：check-template 自检失败一次——断言误用 BRE `\|`（字面 `|`），但 `require_contains` 用 `grep -Eq`（ERE），OR 应为 `|`。读 `require_contains` 定义 §38 发现后修复（1 次往返）。
- **agent 分担未用**：这两个任务改动/评估点明确（grep 定位 fetch/断言区），直接读脚本段 + dry-run 更准，未派 agent（与同日 LUMEN 任务派 agent 取 zhiyan 参考不同——那里是跨项目取参考，这里改自己的脚本/评自己的派生项目）。
- **总量级**：medium-high（两个任务 + 一次 debug 往返 + dry-run 大输出）。

## 质量影响

- **H-003（验证证据摘要）生效**：check-template 输出重定向 log + grep（EXIT/失败项/代理断言/尾部）；dry-run 523 行用 grep（项目专属/版本机制）+ head 审查，未全刷。
- **debug 教训（BRE vs ERE）**：写 check-template 断言前未确认 `require_contains` 的 grep 风格（实际 `grep -Eq` ERE），误用 BRE `\|` 致自检失败一次。现有断言的 `\|` 是匹配代码里**字面 case OR 模式**（如 `README.md|ai/project-rules.md`），非 regex OR——新断言要 regex OR 必须用 `|`。应在加断言前先读断言函数实现确认 grep 风格。
- **dry-run 大输出审查模式**：跨版本 dry-run log 大（523 行），用「grep 项目专属触及 + grep 版本机制关键词 + head/tail」组合审查，不全文读。是 H-003 的扩展（成功长输出只摘要）。
- **大同步分阶段**：digital-cs-demo 跨约 24 版本同步分阶段（评估→同步→启用），阶段 1 评估 + 留痕（memory/handoff），新会话续阶段 2。分阶段 + 留痕续接降低大工程风险 + 单会话上下文负担。

## 优化建议

- **check-template 断言 pattern 风格提示**（可回流）：`require_contains` 用 `grep -Eq`（ERE），断言 pattern 用 ERE 语法（OR 用 `|` 不带反斜杠）。现有断言 `\|` 是匹配代码字面 `|`，容易误导新断言写成 BRE。可在 `check-template.sh` 断言区加一行注释「require_contains 用 ERE；regex OR 用 `|`」，降低未来断言踩 BRE/ERE 坑（本次 1 次往返）。
- **dry-run 审查 checklist**（可沉淀）：派生项目跨版本同步的 dry-run 审查，固定查 ①项目专属触及（`docs/0N`/根 README/`project-rules`/业务代码）②版本机制处理（TEMPLATE-BASE/VERSION/CHANGELOG/preserve）③变化规模（Δ 文件数）。可写入 `ai/prompts/maintainers/12-sync-template.md` 或 git-guide §5。
- **大同步分阶段 + 留痕续接**（好模式，保持）：跨 10+ 版本的大同步分阶段，每阶段独立 commit/PR + 留痕（memory + handoff），新会话续。避免单会话做完大工程致上下文爆炸。digital-cs-demo 阶段 1 是范例。

## 关联

- PR ai-project-template#229（sync 代理回流 v1.54.2，squash 合并 `c859dd4`）
- 提案 `_proposals/TEMPLATE-UPGRADE-sync-proxy-guidance.md`
- digital-cs-demo 阶段 1 评估：分支 `chore/sync-template-v1.54.2`（bootstrap `68d16e7`），详见 memory `derived-project-digital-cs-demo`
- 机制 `_proposals/TEMPLATE-UPGRADE-token-hotspot-records.md`（H-001 / H-003）
- 同日同会话链前一份：`2026-07-18-lumen-version-mechanism-enable.md`（LUMEN 版本机制启用）
- 相关脚本：`scripts/check-template.sh` `require_contains`（§38，`grep -Eq` ERE）
