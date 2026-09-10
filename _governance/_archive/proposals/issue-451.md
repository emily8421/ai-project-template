# GitHub Issue #451: TEMPLATE-UPGRADE：Web 类项目 UI 组件库与样式承载声明 + Web 领域模板候选观察

> Source URL: https://github.com/emily8421/ai-project-template/issues/451
> State: OPEN
> Labels: proposal, from:zhiyan-digital-cs-platform
> Author: emily8421
> Created: 2026-09-09T10:10:09Z
> Updated: 2026-09-10T03:15:54Z
> Mirrored at: 2026-09-10
> Mirror status: raw remote issue copy for local triage; GitHub issue remains source of comments and closure state.

## Raw Issue Body

# TEMPLATE-UPGRADE：Web 类项目 UI 组件库与样式承载声明 + Web 领域模板候选观察

> 来源：zhiyan-digital-cs-platform（emily8421/zhiyan-digital-cs-platform）派生项目回流
- 日期：2026-09-09
- 状态：草稿（待用户确认后提交模板仓 issue）
- 建议版本：minor（两变更集均为文档级新增，advisory，不改既有条款语义、不设 gate）
- 姊妹提案：`TEMPLATE-UPGRADE-ui-knowledge-loop-recipe-layer.md`（已提交模板仓 issue #447——管「知识 → 设计」的消费与回流机制；本提案管「设计 → 实现」的承载规范与模板分层观察，两线互补）

## 0. 摘要

两个来源同一实践缺口的轻量变更：

- **变更集 A**：`web-fullstack-profile.md` 补「UI 组件库与样式承载声明」小节——组件库选型（或明确自绘）是 web 项目的结构性决策，模板在探索期有默认 UI 基线推荐、在结构期有 token 单源约束，但实现期「引入哪个组件库、怎么接主题、版本怎么锁」没有声明与核查口径。实践中暴露三个具体坑：前端框架 major 版本与组件库兼容矩阵盲区（React 19 + antd v5 需官方补丁包）、依赖 `latest` 不锁版本放大风险、组件库引入对目录 / 主题 / 可访问性基线的连锁影响无检查点。
- **变更集 B**：`domain-templates.md` 登记「Web 领域模板候选观察」——领域模板层已方法论化但尚无真实候选在积累例证。web 类系统（管理后台 + 数据密集 + 双端 UI）是潜在候选方向之一，建议开一个「候选观察」档位：未达三条件前先登记观察、随真实项目积累例证（首个例证即本提案来源项目），攒够 3-5 例后再按 §2 三条件正式评估。不建仓库、不改同步语义。

## 1. 动机

### 1.1 与既有规则的关系（去重）

| 既有规则 | 关系类型 | 说明 |
|---|---|---|
| `ai/document-lifecycle-rules.md` UI 段 / `ai/doc-standards/ui-prototype-strategy.md`（默认 UI 基线推荐） | 对象不同 | 它们管探索期「参考什么基线出稿」；本提案管实现期「选型落什么依赖、怎么承载」，互补不重复 |
| `web-fullstack-profile.md` §4（`styles/` design tokens 目录）、§5.1（样式文件职责行：禁字面色值） | 互补不重复 | 它们管「样式值放哪」；本提案管「组件库选型与主题接入怎么声明核查」，是其上游决策位 |
| `web-fullstack-profile.md` §9（代码层契约） | 对象不同 | §9 管错误响应 / 类型同步 / 传输边界；不涉及 UI 组件库 |
| `ai/global-rules.md` §2.1 L0-10（依赖声明集中） | 层级不同 | L0 是跨形态基本功；本提案是 web 形态的选型核查口径 |
| `template-docs/profiles/domain-templates.md` §2（三条件判定） | 互补不重复 | 变更集 B 不改判定标准，只是在其前加「候选观察 / 例证积累」档位，评估仍以三条件为准 |
| 提案 #447（UI 知识循环配方层） | 机制不同 | #447 管知识消费 → 设计的机制；本提案管设计 → 实现的承载规范；同源于同一派生项目实践线 |

## 2. 变更集 A：web-fullstack-profile 补「UI 组件库与样式承载声明」

### 2.1 拟改内容

在 `template-docs/profiles/web-fullstack-profile.md` 新增一节（建议编号 §10「UI 组件库与样式承载声明」，定位 advisory，与 §9 同级同强度）：

1. **声明项**：组件库选型（引入某组件库，或明确自绘）与 UI 原型策略同级，属结构性决策；落 `ai/project-rules.md` §2（技术栈约束）与 `docs/05-tech-spec.md` 依赖登记节。「明确自绘」同样要声明，避免无意识的散装样式。
2. **兼容性核查**：引入前核对前端框架 major 版本与组件库官方支持矩阵；需要补丁包的一并确认登记。（实践案例：React 19 + antd v5 需官方 React 19 补丁包，`latest` 依赖习惯下该盲区在安装时才暴露。）
3. **版本锁定**：组件库及其补丁包锁定版本，不随 `latest` / 浮动 tag；升级为独立决策。
4. **承载声明**：主题接入点（token 单源 → 组件库主题种子映射，如 ConfigProvider）与自绘 / 组件库的边界划分（哪些界面用组件库、哪些自绘）；与 §4 `styles/` token 目录、§5.1 样式文件职责行衔接，主题值不与 token 单源双写。
5. **强度**：advisory，不引入 `scripts/check-template.*` 断言，不设 gate（与模板「无自检门禁、避免过度治理」口径一致）。

### 2.2 版本影响

minor：纯新增小节；§1-§9 既有条款（含 WSG gate、阈值、职责表）不动。

## 3. 变更集 B：domain-templates 登记「Web 领域模板候选观察」

### 3.1 拟改内容

在 `template-docs/profiles/domain-templates.md`：

1. §2 末尾（「反例」段之后）补一段**例证积累机制**：领域候选在未达三条件前，可先经提案收件箱登记「候选观察」；例证随真实项目积累（首个例证：本提案来源项目，web 管理后台 + 双端 UI 形态）；积累 3-5 例后按 §2 三条件正式评估。观察登记不构成任何评估结论。
2. §7 状态与演进表增加一行「Batch 0（候选观察）」：web 领域模板候选观察已登记（2026-09-09，提案 issue 链接），例证积累中；不建仓库、不改两层主线与同步语义。

### 3.2 例证积累机制

- 例证清单在本提案 issue 内以评论滚动维护（项目名 + 形态一句话 + 登记日期），不另建文档。
- 起始例证（同一维护者名下 web 类系统，2026-09-09 登记）：
  1. zhiyan-digital-cs-platform——数字客服平台（管理后台 + 客户 H5 双端，本提案来源项目）；
  2. flowkit——web 类系统（代号，形态细节待登记）；
  3. lumen——web 类系统（代号，形态细节待登记）。
- 计入例证的标准：同模板体系下的 web 类派生项目，或经维护者认可的同类形态系统。
- 达到 3-5 例并满足 §2 三条件时，另起正式 TEMPLATE-UPGRADE 提案评估建仓（Batch 2 流程）；本提案不做预判。

### 3.3 版本影响

minor：文档级登记；三层模型定位声明（§0）与主线治理不变。

## 4. 影响面

- `template-docs/profiles/web-fullstack-profile.md`、`template-docs/profiles/domain-templates.md`：均为模板同步覆盖件，合并后随下次下行同步到达各派生项目。
- 不触碰：`ai/global-rules.md`、`ai/rules-core.md`、`template-sync.json`、同步 / 自检脚本、`ai/commands/*`。
- 对既有派生项目零破坏：新增内容为 advisory 声明位，不产生新的 gate 或自检失败面。

## 5. 验证方式

1. 文档评审：提案 PR 对照本文件 §2.1 / §3.1 拟改清单逐项核对（章节编号连续、锚点稳定、与去重表声明的关系成立）。
2. 实践验证：来源派生项目的 UI 实现 Sprint 完成后，在本提案 issue 补施工报告（声明落点、兼容矩阵核查记录、版本锁定值、token → 主题映射方式、踩坑）。
3. `scripts/check-template.*` 不新增断言（advisory 语义）。

## 6. 实践案例（占位，施工后补）

- 声明落点：待补（组件库条目落入项目技术栈约束与依赖登记的章节引用）。
- 兼容矩阵核查记录：待补（框架 major 版本 × 组件库版本 × 补丁包）。
- 版本锁定值：待补。
- token → 主题映射方式与偏差：待补。
- 踩坑与配方修订建议：待补。
