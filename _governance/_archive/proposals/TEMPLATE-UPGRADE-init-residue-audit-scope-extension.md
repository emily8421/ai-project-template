# 提案：自留内容审计扩展——init 期随母仓结构下行的 sync-records / ai-records / _archive 母仓残留

> 来源：LumiOne-Framework（emily8421/LumiOne-Framework）与 gmbl_project（emily8421/gmbl_project）派生项目回流（2026-09-03 v1.72.0 同步轮 post-sync-cleanup 实证）
> 状态：已评审，落地中（评审结论：仅落地方案 A；方案 B 经核实已由 v1.70.0 derived-init-trim 实现）
> 目标版本：v1.72.1（PATCH，已确认）
> Release impact：patch（治理说明补强：同步范围内 Prompt 审计项扩展，不改默认行为 / 同步结构 / 下游必做流程）
> Release strategy：单独发布（PATCH）；归档走合并后独立 PR，不单独触发版本递增

## 1. 动机（去项目化）

v1.70.0 起，post-sync-cleanup 对「模板仓自留、不应存在于派生项目」的内容审计覆盖三类：① 根级 `MAINTAINERS.md`；② `.github/ISSUE_TEMPLATE/` 与 `.github/pull_request_template.md`；③ `docs/research/`、`docs/archive/` 中与模板仓当前文件同名的治理记录。

v1.67.0 前（治理目录迁入 `_governance/` 之前）初始化的存量派生仓，还会在**治理记录目录**中带入三类母仓自留内容，不在上述口径内：

| 残留 | 内容 | 危害 |
|---|---|---|
| `sync-records/` | **母仓视角**的下行同步汇总运行记录（如「模板仓 → N 派生项目」类汇总），与派生仓自己的同步记录混放 | 审计 / 回流扫描时误把母仓记录当派生事实；谱系混淆 |
| `ai-records/` | `e2e-reports/`、`project-registry/`、`token-hotspots/` 的母仓副本 | 与母仓真值漂移；派生仓内出现过期 registry / hotspot 记录误导后续会话 |
| `_archive/` | 母仓归档的方法论历史文档 | 非项目资产占位；同样存在谱系混淆 |

这些目录在 v1.67.0 治理目录迁移后会随 `git mv` 进入 `_governance/`，若不先判定去留，母仓内容将长期混入派生治理区。

**实证**：2026-09-03 同步轮中，2 个 v1.61.4 期初始化的普通派生存量仓在 post-sync-cleanup 中同构命中本提案三类内容（且两仓 `_proposals/` 均无自建提案、`docs/research|archive` 无自建内容——命中内容均为纯母仓残留，无项目事实混入）。

## 1.1 与既有规则的关系（去重）

- **derived-init-trim 提案**（`_governance/_archive/proposals/TEMPLATE-UPGRADE-derived-init-trim.md`，已落地 v1.70.0）：管 init 时「新项目不带什么」（new-project 黑名单：MAINTAINERS、`.github` 收件箱模板、docs/research·archive 母仓记录、根级治理目录整删重建空种子）。**互补不重复**——它管增量（新 init 项目），本提案管存量（已 init 项目经 post-sync-cleanup 清理）；且 v1.70.0 黑名单不含治理记录目录**内部内容**的存量判定口径。
- **15-post-sync-cleanup.md 审计项 4a-4d**（`ai/prompts/maintainers/15-post-sync-cleanup.md`，已启用）：已覆盖模板专用脚本残留、template-docs 旧路径、模板自留三类（MAINTAINERS / `.github` 收件箱 / docs 分区同名记录）。**合并入**——本提案第④类作为该审计段的新增条目落地，不另立审计入口。
- **`check-derived-sync.*`**（同步清单内，已启用）：管同步提交边界（清单内外文件），不覆盖非同步清单的治理目录内容。**对象不同**。
- **rd-data-chain「无自检门禁」口径**（`template-docs/maintainer/rd-data-chain.md` §4，模板仓专用）：观察记录类内容不引入 CI 门禁。**指向**——本提案沿用该口径，仅 +1 条防漂移关键词断言，不做 blocking 检查。

**本提案不重复它们**：既有机制管「新项目不带」与「同步边界」，空白在「存量仓治理记录目录内部的母仓内容判定口径」。差异化：在既有 4e 审计段内补第④类，不动审计入口结构。

## 2. 方案与评审结论

**方案 A（审计指引扩展，本轮落地）**：在 `ai/prompts/maintainers/15-post-sync-cleanup.md`「模板仓自留内容残留」段新增第④类——治理记录目录（`sync-records/`、`ai-records/`、`_archive/`，根级或已迁入 `_governance/`）中的母仓自留内容，判定口径：

- 母仓视角记录（汇总主语非本派生项目）、母仓治理副本 → 可安全删除，真值以母模板仓为准，删除无需回填 §3 / §4 字段；
- 派生自建的同步运行记录、提案、归档 → 一律保留；
- 无法区分 → 列待确认项等人工裁决，不得误删。

**方案 B（init 黑名单，已由 v1.70.0 实现，无需重复落地）**：评审时核实 `scripts/new-project.sh`（v1.70.0 derived-init-trim）已整删根级 `ai-records/ sync-records/ _archive/ _examples/` 并重建 `_governance/` 空种子 + 分区 README——新初始化项目已不含母仓治理内容。本提案起草稿原建议「列入黑名单」属重复提案，已更正。

## 3. 拟改与影响面

| 文件 | 变更 | 下游影响 |
|---|---|---|
| `ai/prompts/maintainers/15-post-sync-cleanup.md` | 自留内容审计段新增第④类判定口径 | 随下次 sync 下行，存量派生仓下轮 cleanup 可清理 |
| `scripts/check-template.sh` | +1 条 `require_contains` 防漂移断言（锁定「母仓自留内容」关键词） | 无（模板仓专用脚本） |
| `VERSION` / `CHANGELOG.md` / `CHANGELOG-PLAIN.md` | PATCH v1.72.1 | 下行同步按 VERSION 判断 |

不新增自检门禁、不改 `template-sync.json`、不改默认行为。

## 4. 验证方式

`git diff --check`；`check-markdown-clean.ps1`（提案文件）；`bash scripts/check-template.sh --summary`（本地快速完整自检，发布权威仍以 CI 为准）；CI `Template Check`；合并后归档提案并下行同步验证（下轮派生同步 cleanup 时实测第④类命中与保留口径）。

## 5. 落地记录

- 2026-09-03：起草（派生同步轮回流）；同日评审——方案 B 已存在，仅落地方案 A，PATCH v1.72.1；实施 PR：见 git log（分支 `change/init-residue-audit-extension`）。
