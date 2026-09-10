# TEMPLATE-UPGRADE：Web 类项目 UI 组件库与样式承载声明

> 来源：zhiyan-digital-cs-platform（emily8421/zhiyan-digital-cs-platform）派生项目回流（GitHub issue #451 变更集 A，镜像 `_governance/_proposals/_remote-issues/issue-451.md`）
> 状态：处理中（C1 triage 2026-09-10 通过，v1.74.0 Batch 2；变更集 B 另立提案 `TEMPLATE-UPGRADE-v1.74.0-domain-web-candidate-observation.md`）
> 目标版本：v1.74.0
> Release impact：patch 级语义随批聚合（AI 建议先例 v1.61.2：advisory 声明位、无新 gate / 默认行为变化；批内最高档为 #447 的 minor，发版取 v1.74.0 MINOR）
> Release strategy：同主题聚合（与 issue #447 一版发布，先例 v1.68.0 / v1.73.0）

## 1. 动机（去项目化）

组件库选型（引入某组件库，或明确自绘）是 web 项目的结构性决策：模板在探索期有默认 UI 基线推荐、在结构期有 token 单源约束，但实现期「引入哪个组件库、怎么接主题、版本怎么锁」没有声明与核查口径。派生项目 UI 实践中暴露三个具体坑：前端框架 major 版本与组件库兼容矩阵盲区（新框架 major + 组件库既有 major 需官方补丁包，`latest` 依赖习惯下安装时才暴露）、依赖 `latest` 不锁版本放大风险、组件库引入对目录 / 主题 / 可访问性基线的连锁影响无检查点。

## 1.1 与既有规则的关系（去重）

| 既有规则 | 关系类型 | 说明 |
|---|---|---|
| `ai/document-lifecycle-rules.md` UI 段 / `ai/doc-standards/ui-prototype-strategy.md`（默认 UI 基线推荐） | 对象不同 | 它们管探索期「参考什么基线出稿」；本提案管实现期「选型落什么依赖、怎么承载」，互补不重复 |
| `web-fullstack-profile.md` §4（`styles/` design tokens 目录）、§5.1（样式文件职责行：禁字面色值） | 互补不重复 | 它们管「样式值放哪」；本提案管「组件库选型与主题接入怎么声明核查」，是其上游决策位 |
| `web-fullstack-profile.md` §9（代码层契约） | 对象不同 | §9 管错误响应 / 类型同步 / 传输边界；不涉及 UI 组件库 |
| `ai/global-rules.md` §2.1 L0-10（依赖声明集中） | 层级不同 | L0 是跨形态基本功；本提案是 web 形态的选型核查口径 |
| `template-docs/profiles/domain-templates.md` §2（三条件判定） | 互补不重复 | 领域模板候选观察（变更集 B）不改判定标准，只在其前加例证积累档位 |
| 提案 `TEMPLATE-UPGRADE-v1.74.0-ui-knowledge-reflux-recipe.md`（issue #447） | 机制不同 | #447 管知识消费 → 设计的回流机制；本提案管设计 → 实现的承载规范；实施时互加交叉引用 |

**本提案不重复它们**：既有能力覆盖「探索期出稿依据」「样式值单源」「代码层契约」，本提案补「选型决策的声明、兼容核查、版本锁定与主题承载」这块空白。

## 2. 拟改

`template-docs/profiles/web-fullstack-profile.md` 文件末尾新增 `## 10. UI 组件库与样式承载声明`（advisory，与 §9 同级同强度）：

1. **声明项**：组件库选型（或明确自绘）须声明，落 `ai/project-rules.md` §2 与 `docs/05-tech-spec.md` 依赖登记节；「明确自绘」同样要声明。
2. **兼容性核查**：引入前核对前端框架 major 版本与组件库官方支持矩阵，补丁包一并确认登记。
3. **版本锁定**：组件库及补丁包锁定版本，不随 `latest` / 浮动 tag；升级为独立决策。
4. **承载声明**：主题接入点（token 单源 → 组件库主题种子映射）与自绘 / 组件库边界划分；主题值不与 §4 token 单源双写，样式职责以 §5.1 为准。
5. **强度**：advisory，不引入 `scripts/check-template.*` 断言，不设 gate。
6. **交叉引用**：与 ui-knowledge `REC-*` 配方互指（§10 指向 ui-knowledge §4.3；ui-knowledge §4.3 指向本节——回向引用随本 PR 落地，保证指向目标先存在）。

去项目化处理：issue 原文的 React 19 + antd v5 实例改为「典型盲区」通用表述，实践案例留在提案与 issue 评论。

不做的事：不触碰 §1-§9 既有条款（含 WSG gate、阈值、职责表）；不新增断言、同步清单成员或 gate；已核实与 §6 Sprint 0「禁止顺手实现复杂组件库」无冲突（范围禁令 vs 选型治理）。

## 3. 版本影响

advisory 声明位，无默认行为 / 推荐流程 / 同步结构变化；按 CONTRIBUTING §4 兼容性默认规则判 patch，随批聚合进 v1.74.0 MINOR。派生项目零迁移。

## 4. 影响面

- `web-fullstack-profile.md` 与 ui-knowledge README 均为同步覆盖件，合并后随下次下行同步到达各派生项目。
- 不触碰：`ai/global-rules.md`、`ai/rules-core.md`、`template-sync.json`、同步 / 自检脚本、`ai/commands/*`。
- 对既有派生项目零破坏：新增内容为 advisory 声明位，不产生新的 gate 或自检失败面。

## 5. 验证方式

1. 文档评审：PR 对照本文件 §2 拟改清单逐项核对（§10 编号连续、与去重表声明的关系成立、advisory blockquote 在场）。
2. 实践验证：来源派生项目 UI 实现 Sprint 完成后，在 issue #451 补施工报告（声明落点、兼容矩阵核查记录、版本锁定值、token → 主题映射方式、踩坑），发现缺口走后续 PATCH。
3. 回归：`check-template` 既有断言全部通过（基线 2112 项 / 0 失败）；Markdown 清洁检查。

## 6. 实践案例（占位，施工后补）

声明落点 / 兼容矩阵核查记录 / 版本锁定值 / token → 主题映射方式 / 踩坑与配方修订建议——待来源项目 UI 实现 Sprint 后在 issue #451 补充。
