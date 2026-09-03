# 提案：自留内容审计扩展——init 期随母仓结构下行的 sync-records / ai-records / _archive 残留

> 状态：草案（待维护者评审）
- 提出日期：2026-09-03
- 来源：派生项目 v1.72.0 同步轮 post-sync-cleanup 实证（2 个 v1.61.4 期 init 的普通派生存量仓同构命中）
- 关联：v1.70.0 derived-init-trim（new-project 黑名单扩展）；15-post-sync-cleanup.md「模板仓自留内容残留」审计项

## 1. 背景

v1.70.0 起，post-sync-cleanup 对「模板仓自留、不应存在于派生项目」的内容审计覆盖三类：

1. 根级 `MAINTAINERS.md`；
2. `.github/ISSUE_TEMPLATE/`（模板收件箱 issue 表单）与 `.github/pull_request_template.md`；
3. `docs/research/`、`docs/archive/` 中与模板仓当前文件同名的治理记录。

## 2. 问题

v1.67.0 前（治理目录迁入 `_governance/` 之前）init 的派生仓，除上述三类外，还会带入**三类母仓治理内容**，且不在现有审计清单内：

| 残留 | 内容 | 危害 |
|---|---|---|
| 根级 `sync-records/` | 含**母仓视角**的下行同步汇总运行记录（如「v1.57.1 → 4 派生项目」类汇总），与派生仓自己的同步记录混放 | 审计 / 回流扫描时误把母仓记录当派生事实；谱系混淆 |
| 根级 `ai-records/` | `e2e-reports/`、`project-registry/`、`token-hotspots/` 的母仓副本 | 与母仓真值漂移；派生仓内出现过期 registry / hotspot 记录误导后续会话 |
| 根级 `_archive/` | 母仓归档的方法论文档（如 AI 研发手册、规范体系历史版本） | 非项目资产占位；同样存在谱系混淆 |

这些目录在 v1.67.0 治理目录迁移后会随 `git mv` 进入 `_governance/`，若不先判定去留，母仓内容将长期混入派生治理区。

## 3. 实证

2026-09-03 同步轮中，2 个 v1.61.4 期 init 的普通派生存量仓在 post-sync-cleanup 中同构命中：

- 模板仓专用脚本残留 5 件、template-docs 旧路径残留 18 件（v1.65/v1.66 清单口径，全中）；
- 本提案新增三类（sync-records 母仓视角记录、ai-records 三子目录副本、_archive 母仓归档）**全部命中**；
- 两仓 `_proposals/` 均无自建提案、`docs/research|archive` 无自建内容——即命中内容均为纯母仓残留，无项目事实混入。

## 4. 建议方案（供评审，二选一或并行）

**方案 A（审计指引扩展，最小变更）**：在 `ai/prompts/maintainers/15-post-sync-cleanup.md`「模板仓自留内容残留」审计项下增补第④类——根级（或迁移后 `_governance/` 内）`sync-records/`、`ai-records/`、`_archive/` 中的母仓自留内容，判定口径：

- 记录主语为母仓视角（「模板仓 → N 派生」汇总类）→ 可安全删除；
- 内容为母仓治理副本（registry / token-hotspots / e2e-reports）→ 可安全删除，真值以母模板仓为准；
- 派生仓自建的同步记录、提案、归档 → 一律保留。
- 同口径备注：删除无需回填 §3 / §4 字段。

**方案 B（init 黑名单，治本）**：将三目录列入 `new-project.sh` init 裁剪黑名单（对齐 v1.70.0 derived-init-trim 思路），保证新建派生仓初始即不含。

## 5. 影响面

- 无脚本行为变更（方案 A）或仅 new-project.sh 黑名单扩展（方案 B）；
- `template-sync.json` 无需改动（三类内容均不在下行清单，正因如此才残留）；
- 存量派生仓按更新后的审计指引在下轮 post-sync-cleanup 清理。

## 6. 去项目化声明

本提案不含客户、账号、机器路径或项目专属业务细节；实证细节以 2026-09-03 两份派生同步运行记录为准（记录位于各派生仓 `_governance/sync-records/template-sync/`）。
