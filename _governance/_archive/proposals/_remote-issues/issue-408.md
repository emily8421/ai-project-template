# GitHub Issue #408: TEMPLATE-UPGRADE：阶段「最小产物 + 出口」清单与产物级转换映射（stage artifacts & exit criteria matrix）

> Source URL: https://github.com/emily8421/ai-project-template/issues/408
> State: OPEN
> Labels: proposal, from:LUMEN_demo_T2.1
> Author: emily8421
> Created: 2026-08-27T02:32:32Z
> Updated: 2026-08-27T02:32:32Z
> Mirrored at: 2026-08-27
> Mirror status: raw remote issue copy for local triage; GitHub issue remains source of comments and closure state.

## Raw Issue Body

> 来源：LUMEN_demo_T2.1（emily8421/LUMEN-DEMO）派生项目回流
> 状态：**已起草，待用户确认后跨仓提交**（`ai/commands/submit-proposal.md`）
> 参照实例：FlowKit（米家插件自动化开发系统）开发过程规范 01 号《软件开发生命周期与放行规范》+《阶段方法与产物依据》；评估报告：LUMEN `docs/research/2026-08-26-flowkit-lumen-methodology-gap-evaluation.md` §2-§3

# TEMPLATE-UPGRADE：阶段「最小产物 + 出口」清单与产物级转换映射（stage artifacts & exit criteria matrix）

## 1. 动机（去项目化）

模板的文档生命周期规则定义了链路（PLM §2）、评估码（E1-E6）和每份文档的职责（§5 生成矩阵），但**没有定义「每个阶段结束时必须存在哪些可评审产物、满足什么条件才放行」**：

- E1-E6 是评估**动作**（做什么检查），不是产物**清单**（什么必须已存在）。
- `ai/doc-standards/` 按文档分册定义字段，但无单点「阶段 × 产物」总表。
- 面向对象方法的事物-事件表、用例本体表、数据词典编号在模板中没有位置，可能导致场景、用例和类图之间缺少可追溯映射。

参照实例在六阶段中定义「入口 / 最小产物 / 出口」三元组，以阶段 × 核心文档 × 核心图 × 核心表总表和产物转换映射作为评审对账依据，并已经完整链路实测。

## 2. 拟改

### 2.1 `ai/document-lifecycle-rules.md` §2 增补「阶段最小产物与出口」对照表（核心）

在 E1-E6 评估码表之后增加一张「阶段 × 最小产物 × 出口条件」对照表（Full 剖面默认，Lean/Standard 按 §4 剖面裁剪）：

| 阶段 | 最小产物（缺一不放行） | 出口条件 |
|---|---|---|
| 需求获取 | 用户需求说明；事物-事件表或等价场景对象关系表；待确认项清单 | 主要场景可定位到需求来源；范围内外已区分；待确认项不误写为已确认 |
| 需求分析 | SRS（02）；用例本体表 + 用例图；分析类图或等价领域模型；数据词典或等价；验收规格 | 每项范围内功能可追溯至来源/用例/验收；领域对象与数据边界明确；变更有登记位置 |
| 概要设计 | 概要设计说明（04）；功能分配表；接口契约；错误分类表；架构图 + 概设类图 + 主链顺序图 | 每项核心功能可定位到负责模块和调用链；跨模块数据流与错误处理可检查 |
| 详细设计 | 逐模块详设：职责、接口、算法、数据边界、异常降级路径、验证方式 | 通过可驱动性检查（挂接 codability 提案，若其被采纳） |
| 实现计划 | 08 Sprint 计划 | Sprint 可执行、粒度合适、禁止事项明确 |
| 测试验证 | 09 验证计划（REQ→TC 矩阵 + 分层验证） | 覆盖当前阶段 REQ；Mock/降级边界明确 |

### 2.2 产物级转换映射（对账红线）

在 §6 追溯链规则后补产物抽取/映射关系与断点：场景叙事→事物-事件表→用例→分析类图；分析类图→概设类图；用例→顺序图；需求验收规格→TC。对应断点包括无场景来源的用例、无事件依据的类图、设计期无变更登记地推翻领域概念、以及 TC 与验收规格不一致。

### 2.3 `ai/doc-standards/` 补位

- `02-srs.md`：补可选「用例本体表」。
- `00-scenario.md` 或 `02`：将事物-事件表登记为需求获取阶段新项目默认产物，存量项目不强制回补。
- `06-db-design.md`：将跨阶段统一编号的数据词典登记为可选增强。

## 3. 版本影响

模板 MINOR：`document-lifecycle-rules` 增表和小节；doc-standards 00/02/06 补可选段位；不改 00-09 编号体系、不强制全剖面、不加自检断言。

## 4. 与既有规则的关系（去重）

- **E1-E6 评估码**：补齐评估的对照物，不新增评估码。
- **§5 文档生成矩阵**：文档视角与阶段视角的互补视图，产物表应引用生成矩阵行而不复制内容。
- **§13 图表规范**：图表规范管图怎么画，本提案管哪些图在阶段中应出现。
- **#354（doc-system-oo-diagrams，已落地 v1.63.0）**：维持「建议 + 默认」非强制力度；补阶段放行、E-E 表、用例本体表、数据词典和转换映射。
- **profile 剖面**：产物表按 Full/Standard/Lean 裁剪。
- **codability-six-questions 提案（同批）**：详细设计出口可挂接六问；两提案独立可裁。

## 5. 影响面

- 修改：`ai/document-lifecycle-rules.md`、`ai/doc-standards/00-scenario.md`、`02-srs.md`、`06-db-design.md`。
- 不改：00-09 编号、生成矩阵语义、E1-E6、图表规范、脚本与 CI。
- 存量派生仓不强制回溯补产物。

## 6. 验证方式

- 模板仓：文档审阅 + check-template 自检。
- 实例佐证：参照实例完整链路实测；LUMEN 的 OO 覆盖度评估为独立实证；首个采用项目试点后回填。
