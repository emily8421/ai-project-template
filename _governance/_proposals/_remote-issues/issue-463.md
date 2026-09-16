# GitHub Issue #463: TEMPLATE-UPGRADE: post-sync-cleanup 审计清单补「存量仓治理容器迁移」显式审计项

> Source URL: https://github.com/emily8421/ai-project-template/issues/463
> State: OPEN
> Labels: proposal, from:agent-system-template
> Author: emily8421
> Created: 2026-09-11T00:35:15Z
> Updated: 2026-09-11T00:35:15Z
> Mirrored at: 2026-09-16
> Mirror status: raw remote issue copy for local triage; GitHub issue remains source of comments and closure state.

## Raw Issue Body

# TEMPLATE-UPGRADE: post-sync-cleanup 审计清单补「存量仓治理容器迁移」显式审计项

> 来源：agent-system-template（emily8421/agent-system-template）派生项目回流
> 状态：草案（2026-09-11，本仓 v0.5.0 Batch C 补课时实证）
> 目标模板版本：ai-project-template v1.75.0+
> Release impact：patch（审计 Prompt 文档增量，不改脚本 / 清单 / CI）

## 1. 动机

v1.67.0 引入 `_governance/`（与 `project/`）容器后，覆盖式同步有意不做目录迁移（`template-sync.json` 清单成员不变），存量派生仓的容器迁移依赖 post-sync-cleanup 手动执行。但 `ai/prompts/maintainers/15-post-sync-cleanup.md` 的审计清单**没有**显式审计项驱动这次迁移：

- §5 第 100 行「审计治理记录目录中的母仓自留内容（v1.72.1 起）」顺带承认两种布局（「根级或已迁入 `_governance/` 的 `sync-records/`…」），但只审母仓自留内容，不审「是否已迁入容器」。
- §5 第 89 行「§3 裁剪一致性」覆盖 `project/frontend` 等代码占位，不覆盖治理容器。

实证：`agent-system-template`（v1.44.3 期建仓的 L2 领域模板）从 v1.67.0 同步起历经约 8 轮同步与多轮「轻量 post-sync-cleanup」，根级 `_proposals/`、`_archive/`、`_examples/`、`sync-records/` 一直未被触发迁移，直到 2026-09-11 人工复盘才发现；期间 SOP 推荐路径 `_governance/sync-records/template-sync/` 与仓库实际路径持续不一致（靠「旧路径兼容读取」兜着）。同类存量仓（v1.67.0 前初始化）都可能处于该状态。

## 2. 拟改

`15-post-sync-cleanup.md` §5 审计步骤新增一条（建议置于「审计治理记录目录中的母仓自留内容」之前）：

> - **审计治理容器迁移状态（v1.67.0 前存量仓）**：检查根级是否存在 `ai-records/`、`sync-records/`、`_proposals/`、`_archive/`、`_examples/` 治理目录——存在即说明尚未完成 v1.67.0 容器迁移（覆盖式同步不做目录迁移，`new-project.sh` 只对新项目生效）。列出根级残留目录，建议按 `git mv` 迁入 `_governance/`（保留历史）并全量更新仓库内引用（脚本剥离清单、project-rules §3/§4、layer-map / README、同步记录路径）；无法自动判断引用影响面时列待确认项。v1.67.0 之后经 `new-project.sh` 创建的项目初始即容器化，本审计项应为空。

同步配套（可选，非必须）：`check-derived-sync.*` 非阻断提示位可加一条「检测到根级治理目录（v1.67.0 前布局）」advisory info，与版本机制检测同强度。

## 3. 影响与边界

- 只加审计项 / 可选 advisory 提示；不改同步清单、不加 gate、不自动迁移。
- 普通派生项目与领域模板仓同适用（本提案来自领域模板仓实证）。
- 与 §5 第 89 行（§3 裁剪一致性：`project/*` 代码占位）、第 100 行（母仓自留内容）正交不重叠：三者分别管「代码容器裁剪」「容器内母仓残留」「容器迁移本身」。

## 3.1 验证方式

- 文档级提案：落地后在母模板仓 `check-template.*` 全量自检应零变化（不新增断言）；若采纳可选 advisory 提示，需在 PS5.1 + Git Bash 双入口实测 `check-derived-sync.*` 的提示路径分支（含无根级治理目录的新项目 = 空匹配不误报）。
- 实证样本：`agent-system-template` v0.5.0 Batch C（2026-09-11）完成存量迁移后，`check-domain-derived-sync.*` 与同步记录路径均落位推荐路径，无回归。

## 4. 与既有规则关系（去重）

- v1.67.0 changelog 与 `template-sync.json` description 已声明容器不入清单、迁移靠人工——本提案不改变该机制，只补「审计清单里看得见这一项」。
- `12-sync-template.md` 的 `_governance/sync-records/` 推荐路径 + 旧路径兼容读取维持不变；迁移完成后各仓自然落位推荐路径。
