# GitHub Issue #565: TEMPLATE-UPGRADE: 同步收尾补「版本复制指针核对」advisory 步

> Source URL: https://github.com/emily8421/ai-project-template/issues/565
> State: OPEN
> Labels: proposal, from:agent-system-template
> Author: emily8421
> Created: 2026-11-16T11:15:17Z
> Updated: 2026-11-16T11:15:17Z
> Mirrored at: 2026-11-16
> Mirror status: raw remote issue copy for local triage; GitHub issue remains source of comments and closure state.

## Raw Issue Body

# TEMPLATE-UPGRADE: 同步收尾补「版本复制指针核对」advisory 步

> 来源：agent-system-template（emily8421/agent-system-template）派生项目回流
> 状态：**草案 · 待维护者确认**（2026-11-16 起草并提交母仓）
> 目标模板版本：ai-project-template v1.79.1+
> Release impact：patch（AI 建议，待维护者确认——SOP / 审计清单文案增量，不挂自检断言、不改脚本 / 同步清单）
> Release strategy：单独发布
> 仓库角色：B 组 · 待上行跨领域（回流母模板）

## 1. 动机

派生仓同步收尾时，权威版本文件（根 `VERSION` / `TEMPLATE-BASE.md`）更新后，同步清单外的「版本复制指针」不随动，形成双源漂移面。实证（同一派生仓连续两轮）：

- 2026-11-02 同步 v1.76.0 轮：收尾漏回写 `ai/project-rules.md` §0「当前继承母模板版本」（滞留 v1.75.0），连续两轮 handoff 滚动与收尾自检均未发现，直至无关联的 rollup 任务顺带撞见（来源仓 pitfall 记录 2026-11-03，当轮仓内 PR #27 回写）。
- 2026-11-16 同步 v1.79.1 轮：同型复现（§0 滞留 v1.76.0），本次靠收尾自查捕获并回写。

同家族先例（母模板已实证）：#481 gmbl 仓「单日 4 Sprint / 14 提交后 VERSION 滞留 v0.1.0 靠人工发现」——版本事实滞留的发现成本高、且依赖偶然触发。本提案把「复制指针与权威源一致性」纳入同步收尾核对面，使滞留在收尾自查（而非偶然任务）被捕获；并给出「纯指针化」改写建议，从源头消灭漂移面。

## 1.1 与既有规则的关系（去重）

- doc-standards 00/08/09 元信息「一句话状态 + 权威源指针，不整段重述」（#379）：**同范式扩展，互补不重复**——#379 已在文档元信息层确立「指针不复制」写法，本提案把同一范式应用到 project-rules §0 版本指针场景并补同步收尾核对步；不新增、不修改元信息规则。
- `ai/implementation-lifecycle-rules.md` §7.1 回写职责 + doc-standards/project-rules §2.4（#481）：**同家族不同机制，互补不重复**——#481 管发版侧（Sprint 完成包 → VERSION / CHANGELOG 回写挂钩），本提案管同步侧（下行同步 → 清单外复制指针核对）；触发点与对象均不同。
- #491（路由行消双口径）：**同哲学，指向**——消双源、立权威源是同一治理哲学，本提案不触碰路由。
- `12-sync-template.md` 步骤 14（project-rules 骨架迁移提示）：**对象相邻主题不同，互补不重复**——步骤 14 管「同步引入新骨架项的人工迁移」，本提案管「清单外版本复制指针的一致性核对」；落点选相邻位置便于同一时点执行。
- `15-post-sync-cleanup.md` 第一段 §5「审计版本机制启用状态」条：**落点容器相邻条目**——该条管 VERSION↔CHANGELOG 漂移（同步清单内权威文件间），本提案新增条目管清单外复制指针漂移，互不覆盖。

## 2. 拟改

两处落点、同措辞（防双写漂移，参照 v1.79.1「归档操作序列补同步更新归档索引表固定步」的两处同措辞先例）：

1. `ai/prompts/maintainers/12-sync-template.md` 步骤 14 尾部追加一句（同步收尾执行时点）。
2. `ai/prompts/maintainers/15-post-sync-cleanup.md` 第一段 §5「审计 ai/project-rules.md」清单、「审计版本机制启用状态」条后追加一条同措辞审计项（整理审计时点兜底）。

核对内容（同措辞）：核对派生仓内**非同步清单文件的版本复制指针**（如 `ai/project-rules.md` §0 的「当前领域模板版本 / 当前继承母模板版本」、根 README 状态行等）与权威源（根 `VERSION` / `TEMPLATE-BASE.md`）一致；发现滞留即随收尾提交回写，或建议改写为纯指针（「以 <权威源> 为准，不复制版本号」）从源头消除漂移面。

具体 old→new 见 `TEMPLATE-UPGRADE-sync-closing-version-pointer-check-patch.md`。

## 3. 版本影响

PATCH（与 v1.76.2 #515「结构取证固定预检步」同性质）：SOP / 审计清单文案增量，不新增同步结构、不挂自检断言、不改脚本与同步清单；默认行为与下游必做流程不变。派生项目同步后，下次同步收尾 / post-sync-cleanup 时生效，存量仓无强制迁移。

## 4. 影响面

- 全体派生项目（普通 + 领域路线）：同步收尾 / post-sync-cleanup 各多一条 advisory 核对；成本为精确点位 grep（秒级），无敏感面。
- 模板仓自身：不适用（模板仓无派生同步收尾场景）。

## 5. 验证方式

- 全量自检（`check-template.sh`）+ md-clean 窄检 + `git diff --check`。
- 行为验证：在存在复制指针的派生仓（提案来源仓已实测双轮复现场景）确认两处落点均能命中滞留副本并给出回写 / 纯指针化提示；PATCH 豁免 L3 e2e（与 #515 同口径）。

## 6. 待确认项

- 落点措辞与位置由维护者裁量（patch 锚点基于 v1.79.1 文件，如偏移按语义就近落位）。
- 是否同步扩展 `ai/doc-standards/project-rules.md` §0 字段规范：AI 建议不扩——普通派生项目 §0 无版本字段（基线仅定义项目名称 / 代号缩写），为领域模板场景扩基线属过度设计；领域仓 `ai/project-rules.md` 为自有件，纯指针写法已在来源仓落地示范（本提案提交同批完成）。
