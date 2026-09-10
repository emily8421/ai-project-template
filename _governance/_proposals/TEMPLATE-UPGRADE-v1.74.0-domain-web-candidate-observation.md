# TEMPLATE-UPGRADE：Web 类领域模板候选观察登记

> 来源：zhiyan-digital-cs-platform（emily8421/zhiyan-digital-cs-platform）派生项目回流（GitHub issue #451 变更集 B，镜像 `_governance/_proposals/_remote-issues/issue-451.md`）
> 状态：处理中（C1 triage 2026-09-10 通过，v1.74.0 Batch 3；变更集 A 另立提案 `TEMPLATE-UPGRADE-v1.74.0-web-ui-carrier-declaration.md`）
> 目标版本：v1.74.0
> Release impact：patch 级语义随批聚合（advisory 登记档位、无 gate / 默认行为变化；批内最高档为 #447 的 minor，发版取 v1.74.0 MINOR）
> Release strategy：同主题聚合（与 issue #447 一版发布，先例 v1.68.0 / v1.73.0）

## 1. 动机（去项目化）

领域模板层已方法论化（`template-docs/profiles/domain-templates.md`）但尚无真实候选在积累例证。web 类系统（管理后台 + 数据密集 + 双端 UI）是潜在候选方向之一。三条件判定（§2）是「建不建」的门槛，缺少「条件未满足但方向值得关注」时的低承诺登记位——本提案在判定标准之前补一个「候选观察」档位：先登记观察、随真实项目积累例证，攒够 3-5 例后再按三条件正式评估。

## 1.1 与既有规则的关系（去重）

| 既有规则 | 关系类型 | 说明 |
|---|---|---|
| `template-docs/profiles/domain-templates.md` §2（三条件判定） | 互补不重复 | 不改判定标准，只在其前加「候选观察 / 例证积累」档位，正式评估仍以三条件为准 |
| `template-docs/profiles/domain-templates.md` §7（状态与演进表） | 载体复用 | 新增 Batch 0 行登记观察状态，不改 Batch 1-4 语义 |
| `ai/commands/domain-template-lab.md`（实验入口） | 对象不同 | lab 是创建领域模板的执行入口；本提案是评估前的观察登记机制 |
| issue #290（TEMPLATE-DEFER：domain-template docs folder reorg） | 联动不触发 | 候选观察 ≠ 第二个领域模板建成；#290 复活触发器（Batch 2：第二个领域模板出现）在 Web 领域模板正式建仓时才满足，维持 DEFER |
| 提案 `TEMPLATE-UPGRADE-v1.74.0-web-ui-carrier-declaration.md`（issue #451A） | 姊妹变更集 | 同一 issue 拆分的两线：A 管实现期承载规范（web profile），B 管领域模板候选观察（domain-templates） |

**本提案不重复它们**：既有能力覆盖「怎么判定建不建」「怎么建」，本提案补「条件未满时往哪登记、例证怎么攒」这块空白。

## 2. 拟改

`template-docs/profiles/domain-templates.md`：

1. §2 末（Web App scaffold 段之后）补「候选观察」段：未达三条件的领域方向可先经提案收件箱登记观察；**例证须「项目名 + 形态一句话 + 登记日期」齐备方计入计数（仅代号占位不计入）**；积累 3-5 例后另起正式 TEMPLATE-UPGRADE 提案按三条件评估；观察登记不构成任何评估结论，不建仓库、不改两层主线与同步语义。随段登记当前候选：Web 类系统领域模板（2026-09-09，issue #451；首个成形例证 zhiyan-digital-cs-platform——数字客服平台，管理后台 + 客户 H5 双端；flowkit / lumen 为代号位待补形态）。
2. §7 状态与演进表新增 Batch 0 行：Web 类领域模板候选观察已登记（2026-09-09，issue #451），例证积累中；不建仓库、不改三层主线与同步语义。

计数口径说明（C1 裁决点 3，维护者确认）：issue #451 原文的起始例证 3 条中，flowkit / lumen 仅有代号无形态细节；按「形态 + 日期齐备方计入」口径，当前成形例证实际为 1 条（zhiyan）。

不做的事：不建仓库；不改 §0 定位声明与两层主线；不改三条件判定标准与 Batch 1-4 语义；不新增断言、同步清单成员或 gate。

## 3. 版本影响

advisory 登记档位，无默认行为 / 同步结构变化；按兼容性默认规则判 patch，随批聚合进 v1.74.0 MINOR。派生项目零迁移。

## 4. 影响面

- `domain-templates.md` 为同步覆盖件，合并后随下次下行同步到达各派生项目。
- 不触碰：`ai/global-rules.md`、`template-sync.json`、同步 / 自检脚本、`ai/commands/*`。
- 例证清单后续在 issue #451 内以评论滚动维护（项目名 + 形态一句话 + 登记日期），不另建文档；达到 3-5 例并满足三条件时另起正式提案评估建仓。

## 5. 验证方式

1. 文档评审：PR 对照本文件 §2 拟改清单逐项核对（§2 候选观察段 + 计数口径在场、§7 Batch 0 行格式与既有表一致）。
2. 回归：`check-template` 既有断言全部通过（基线 2112 项 / 0 失败，含 domain-templates 关键词断言不受影响）；Markdown 清洁检查。
