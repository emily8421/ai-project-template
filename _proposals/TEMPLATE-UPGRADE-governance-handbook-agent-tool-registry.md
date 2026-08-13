# TEMPLATE-UPGRADE: 模板开发手册、分层管家、治理机制与工具注册体系评估

> 来源：模板维护者（2026-08-13 关于模板开发手册、四路径管家、治理机制登记与工具管理的讨论）
> 状态：Batch 1 已获授权、完成本地实施、通过验证和人工评审；Batch 2-5 未授权
> 目标版本：v1.61.6（仅 Batch 1）
> Release impact：patch（Batch 1 新增人读机制与工具登记，不改变默认行为、同步范围或门禁）；后续 Batch 分别判断 patch / minor
> Release strategy：先登记与手册整理，再做角色化试点；不在首批默认启用真正并发多 Agent

## 0. 执行摘要

本报告评估四项相互关联的模板治理建议：

1. 建设面向人的 AI 模板开发手册。
2. 为文档体系生成、代码实现、测试验收、知识沉淀分别设置管家 Agent，并由总管 Agent 协调。
3. 登记模板中已经存在的治理机制，形成可审计的机制总览，并强化层内自治、层间协调。
4. 建立脚本与工具注册管理机制，解决工具用途不透明、重复建设难识别、生命周期无人管理的问题。

综合判断如下：

- **开发手册应基于现有内容重构，不应从零重写。** 当前模板已经有完整但分散的人读材料，主要缺口是统一的信息架构、角色视角和资产导航，而不是内容从无到有。
- **四个专业管家 + 一个总管的逻辑模型可行。** 短期应先实现为“角色契约 + 路由规则 + 交接协议”，不默认启动五个长期并发 Agent。只有真实用例证明角色化不足时，再考虑可执行 Agent 配置或并发调度。
- **治理机制登记应优先落地。** 当前模板并非缺少治理，而是机制分布在规则、Profile、SOP、命令、脚本和记录目录中，缺少统一的机制资产视图，难以判断覆盖、冲突、重复和失效。
- **工具管理应在现有 `scripts/README.md` 上升级。** 当前已有基础用途表，但缺少完整注册字段、生命周期、权威实现关系、重复性审查和机器校验。无需立刻引入数据库或复杂管理平台。
- **实施顺序应为：登记现状 -> 重构手册导航 -> 定义角色契约 -> 两条流程试点 -> 决定是否 Agent 化和物理拆规则。** 如果反过来先建 Agent，容易把现有规则再包一层，增加误触发和维护成本。

本提案不把上述建议写成已批准事实。所有架构选择、角色命名、首批范围、版本级别和是否正式启用 Agent 配置均保留为待人工确认。

## 1. 背景与问题定义

### 1.1 用户提出的问题

本轮问题集中在模板自身的可理解性、职责分离和资产治理：

- 模板已经积累较多规则、手册和运行记录，需要开始形成给人看的开发手册；需要判断是在现有内容上改，还是重新构建。
- 文档体系、代码实现、测试验收、知识沉淀四条路径是否可以各设一个管家 Agent，由总管 Agent 只负责协调。
- 已存在的治理机制是否应登记，以便看清已有能力、审查充分性和冲突，并实现层内自治、层间专门协调。
- 模板已经生成较多脚本工具，但使用者不知道有哪些、做什么、是否重复，需要工具注册与管理机制。

### 1.2 问题的共同根因

四项问题不是四个孤立功能，背后是同一个治理缺口：

> 模板已经从“少量规则 + 文档骨架”演进为包含规则、命令、Prompt、Profile、脚本、同步、验证、记录和治理流程的方法论产品，但资产仍主要按文件和历史增长组织，尚未完整形成“职责域 + 所有者 + 契约 + 注册表 + 生命周期”的产品化视图。

这会带来以下具体影响：

- 人能找到单个文件，但难以快速建立全局心智模型。
- AI 能按入口路由读取规则，但跨层任务的所有权仍依赖长规则中的自然语言约束。
- 已有机制很多，却难回答“模板现在到底有哪些管理机制、哪些层已经足够、哪些重复或冲突”。
- 工具可以被调用，但缺少统一的创建准入、权威实现、包装器、状态和退役信息。
- 一旦直接引入多个 Agent，现有职责模糊会被放大为跨 Agent 争抢文件、重复执行和循环交接。

### 1.3 与既有规则的关系（去重）

- **Capability Packages 与 Profile 契约索引**（`template-docs/capability-packages.md`，已启用）：定义 Core、Docs、Implementation、Verification、Profiles、Governance 等影响域，并给出 `Router / Coordinator`、`Editor`、`Verifier`、`Maintainer` 的短期角色化建议。**合并入**——本提案不另建平行能力包体系，而是在该索引基础上补“价值流所有权、机制注册与跨层交接”。
- **Capability Packages 历史提案**（`_archive/proposals/TEMPLATE-UPGRADE-capability-packages-and-profile-contracts.md`，已归档）：明确目录重组与真正多 Agent 暂缓，先用角色化流程。**互补不重复**——本提案延续其风险判断，但基于当前新增需求重新评估“按四条价值流划分角色”的可行性，并提出试点门槛。
- **Document Lifecycle Rules**（`ai/document-lifecycle-rules.md`，已启用）：定义输入到文档、计划、验证和代码的主链、按 scope 读取及变更传播。**层级不同**——它是 AI 执行规则，本提案是人读治理总览和所有权模型，不复制具体规则正文。
- **Implementation Lifecycle Rules**（`ai/implementation-lifecycle-rules.md`，已启用）：定义 Phase、Sprint、Task、编码、验证与验收留痕。**层级不同**——本提案评估实现管家与验收管家的职责边界，不立即拆分规则文件。
- **研发数据链 Profile**（`template-docs/rd-data-chain.md`，已启用）：登记 ADR、research、meetings、handoff、hotspot、pitfall 等数据载体及主链关系。**对象不同**——它登记研发数据，本提案补治理机制和工具资产登记，并把知识管家的职责建立在该 Profile 上。
- **脚本说明**（`scripts/README.md`，已启用）：已有脚本用途、运行位置、读写属性和使用者表。**合并入**——本提案不另造工具目录，而是把现有说明升级为工具注册表和生命周期入口。
- **模板方法论说明**（`template-docs/template-methodology.md`，已启用）：解释模板为什么这样设计，并明确演进原则不是推翻重来。**合并入**——建议将其逐步升级为开发手册主干，而不是新建内容重复的整套手册。
- **领域模板继承与 Agent 系统 Profile**（`_proposals/TEMPLATE-UPGRADE-domain-template-inheritance.md`，部分落地）：讨论作为软件产品的 Agent 系统所需 planner、executor、tool permission、memory、eval 等领域能力。**对象不同**——本提案中的“管家 Agent”是模板研发流程角色，不是 Agent 系统产品领域模板，不引入 agent runtime、memory、trace 或领域 scaffold。
- **规则入口与 Checkpoint Mode**（`ai/index.md`、`ai/rules-core.md`、`ai/session-rules.md`，已启用）：负责任务路由、写入确认、失败即停和续接。**指向**——总管角色应复用这些现有入口，不新增另一套全局调度权威源。

**本提案不重复它们**：现有文件分别解决规则执行、能力契约、研发数据、脚本说明和领域模板问题，但尚未形成统一的“人读开发手册 + 四条价值流所有权 + 治理机制注册 + 工具生命周期管理”方案。本提案补的是这些现有局部机制之间的总览、所有权和实施路线。

## 2. 评估范围、依据与限制

### 2.1 本次读取的主要依据

本次评估以 2026-08-13、模板版本 `v1.61.5`、主线提交 `ded851d` 为事实基线，主要读取：

- 规则入口与核心规则：`ai/index.md`、`ai/rules-core.md`。
- 生命周期规则：`ai/global-rules.md`、`ai/document-lifecycle-rules.md`、`ai/implementation-lifecycle-rules.md`、`ai/session-rules.md`。
- 项目与命令约束：`ai/project-rules.md`、`ai/commands/README.md`、`ai/prompts/README.md`。
- 人读入口：`README.md`、`template-docs/README.md`、`template-docs/beginner-guide.md`、`template-docs/template-methodology.md`、`SOP.md`。
- 治理与同步：`CONTRIBUTING.md`、`MAINTAINERS.md`、`template-sync.json`、`template-docs/capability-packages.md`。
- 数据与工具索引：`template-docs/rd-data-chain.md`、`scripts/README.md`。
- 相关提案：Capability Packages 历史提案、领域模板继承提案。

### 2.2 资产规模快照

本次只读盘点得到：

| 资产类别 | 当前数量 | 说明 |
|---|---:|---|
| `scripts/` 可执行脚本 | 15 | 不含 `scripts/README.md` 和 `.gitkeep`；包含 Bash / PowerShell 主实现、包装器和独立工具 |
| `ai/commands/` 命令文件 | 28 | 不含 `ai/commands/README.md` |
| `ai/prompts/` Prompt 文件 | 26 | 不含 `ai/prompts/README.md` |
| GitHub workflow | 1 | `template-check.yml` |
| GitHub issue template | 2 | derived feedback 与 template change |

这些数字只用于说明治理规模，不等于每项都需要独立机制或独立 Agent。

### 2.3 限制

- 本轮最后一次用于检查 `.agents` / `.codex` 等实际 Agent 配置的组合只读命令失败，按 Checkpoint Mode 未连续重试。因此本报告**不声称当前仓库已经或尚未存在可执行 Agent 配置**；后续进入 Agent 实施前须单独精确核实。
- 本次没有联网复核远端 issue / PR，也没有把远端状态作为建议依据。
- 本报告是治理设计评估，不包含实际规则拆分、Agent 配置、脚本注册表改造或自检代码修改。

## 3. 当前体系诊断

### 3.1 已具备的基础

模板并不是从零开始。现有体系已经提供本方案所需的大部分基础能力：

1. **层级雏形已经存在**：`capability-packages.md` 已区分 Core、Docs、Implementation、Verification、Profiles、Governance。
2. **文档层具备 scope 隔离**：`document-lifecycle-rules.md` 要求按任务 scope 读取对应 doc standard，不预读全模板。
3. **文档与实现已有生命周期边界**：文档生命周期负责输入、生成、追溯和传播；实现生命周期负责计划、代码、验证和验收留痕。
4. **知识沉淀已有载体分类**：`rd-data-chain.md` 已覆盖 ADR、research、meetings、verification、CHANGELOG、handoff、hotspot、pitfall 和 project registry。
5. **跨层事实已有单一权威源原则**：横切事实必须有唯一权威定义点，其他位置只引用。
6. **风险协调已有总控基础**：`ai/index.md`、`rules-core.md` 和 Checkpoint Mode 已承担路由、确认和失败停止。
7. **脚本已有初级说明表**：`scripts/README.md` 已登记用途、运行位置、读写属性和使用者。
8. **模板演进已有治理闭环**：提案、维护分支、PR、版本、归档和下行同步均已存在。

### 3.2 主要缺口

当前缺口集中在“看得见、说得清、分得开、能审计”：

| 缺口 | 当前表现 | 直接影响 |
|---|---|---|
| 人读总览不足 | 内容散布在 beginner、methodology、SOP、MAINTAINERS、CONTRIBUTING 和专题 Profile | 新使用者和维护者难以形成统一心智模型 |
| 价值流所有权不明确 | Docs / Implementation / Verification 有影响域，但“谁对最终结果负责”未形成角色契约 | 跨层任务容易扩大读取和修改范围 |
| 测试仍嵌在实现生命周期 | 规则层没有独立 Verification 生命周期文件 | 立即拆出验收管家时容易出现双重权威 |
| 知识沉淀入口分散 | 已有数据链索引，但 knowledge owner、晋级/归档/回写责任未集中表达 | 记录可能长期停留在辅助载体，未回写事实源 |
| 治理机制无统一台账 | 规则、Gate、Profile、SOP、自检、同步分别存在 | 难判断重复、冲突、覆盖空白和失效机制 |
| 工具说明不是生命周期注册 | 缺 owner、状态、权威实现、wrapper、依赖、风险、替代与退役字段 | 难评估重复建设或安全边界 |
| 入口之间存在维护压力 | README、SOP、commands、prompts、script README 均有局部清单 | 新资产加入时容易漏更新某个入口 |

### 3.3 当前脚本登记的可见缺口

`scripts/README.md` 已覆盖大部分核心脚本，但当前 `scripts/` 还包含：

- `check-markdown-clean.ps1`
- `check-github-context.ps1`

二者没有进入该 README 的主脚本说明表。它们在其他 SOP 或维护文档中有引用，但这仍说明“用途说明”和“完整资产注册”不是同一件事：工具可被局部文档引用，却仍可能缺少统一登记和生命周期信息。

### 3.4 不建议直接物理重构的原因

不建议当前立即大改目录、拆分所有规则或新增五套并发 Agent，原因包括：

- `template-sync.json` 当前同步范围广，物理移动会扩大下游兼容和迁移成本。
- `ai/index.md` 已提供稳定入口，新增平行路由会制造双重权威。
- Verification 当前同时存在于文档主链、`docs/09`、实现生命周期和多个报告模板中，先物理拆规则可能造成断链。
- 知识沉淀中的项目事实、过程记录和 AI meta 数据性质不同，不能只凭“知识”一词放进同一写入域。
- 真正多 Agent 会把当前潜在的所有权模糊放大为并发写冲突。

## 4. 问题二：模板开发手册建设方案

### 4.1 方案比较

| 方案 | 优点 | 缺点 | 结论 |
|---|---|---|---|
| A. 从零重写一套开发手册 | 初始结构整齐，可按当前想法组织 | 重复现有内容；双份权威；历史链接和同步入口迁移成本高；容易与活规则漂移 | 不推荐 |
| B. 只在各现有文档零散补充 | 改动最小 | 全局心智模型仍分散；不能解决“去哪看全貌” | 不足以解决问题 |
| C. 以现有 `template-methodology.md` 为主干重构，其他文档保持专题职责 | 兼容现有路径；复用成熟内容；可逐步演进；符合单一权威源 | 需要先设计导航与章节边界，避免把规则正文抄进手册 | 推荐 |

### 4.2 推荐定位

建议把 `template-docs/template-methodology.md` 逐步升级为“模板开发手册主干”，继续保持现有文件名和链接兼容。它负责回答：

- 模板由哪些层和价值流构成。
- 每层负责什么、不负责什么。
- 从输入到交付再到知识回流如何运作。
- 当前有哪些治理机制和工具资产，应去哪里查。
- 发生跨层协作、异常和变更时如何协调。

它不负责：

- 复制 `ai/*-rules.md` 的可执行规则。
- 复制 `SOP.md` 的完整命令路由。
- 复制 `scripts/README.md` 的所有工具字段。
- 复制 `CONTRIBUTING.md` / `MAINTAINERS.md` 的操作 checklist。
- 承载项目专属事实。

### 4.3 推荐手册信息架构

建议在现有 methodology 内容上渐进调整为：

1. **读者与阅读路径**：使用者、项目维护者、模板维护者分别从哪里进入。
2. **整体架构**：Core、四条价值流、Profiles、Governance 的关系。
3. **四条价值流**：文档、实现、验收、知识各自的输入、输出、边界和权威源。
4. **开发全生命周期**：输入 -> 文档 -> 计划 -> 实现 -> 验收 -> 知识回写。
5. **管家角色与协作**：总管和四个专业管家的职责矩阵、交接 Gate、异常回退。
6. **机制总览**：指向治理机制注册表，不复制机制正文。
7. **工具总览**：指向 `scripts/README.md` 工具注册表和命令入口。
8. **模板与派生项目治理**：提案、版本、同步、回流和领域模板边界。
9. **演进策略**：何时新增机制、工具、Profile 或 Agent，何时只扩展现有能力。
10. **常见冲突与诊断**：事实源冲突、跨层越权、重复工具、失效机制和错误状态晋级。

### 4.4 手册维护原则

- 手册写“概念、关系、选择和导航”，规则写“必须、禁止、触发和停止”。
- 手册中的机制和工具名称引用稳定 ID，详细字段回到注册表。
- 规则、脚本或路径变更时，通过轻量稳定关键词检查确保手册入口未滞后。
- 不要求每次小变更重写整章；以局部引用和总览表更新为主。
- 历史背景进入归档或简短演进说明，不让手册成为 CHANGELOG 的替代品。

## 5. 问题三：四个专业管家与总管模型

### 5.1 推荐模型

建议采用“五角色逻辑模型”：

```text
                         总管 / Coordinator
                  路由、边界、确认、跨层协调、冲突裁决
                                   |
            +----------------------+----------------------+
            |                      |                      |
       文档管家                实现管家                验收管家
   输入/需求/设计/追溯       计划/任务/代码/完成包      TC/测试/证据/结论
            \                      |                      /
             +---------------------+---------------------+
                                   |
                              知识管家
                   决策/调研/经验/归档/回写追踪
```

图中知识管家不应被理解为所有内容的“最终存档员”。长期项目事实仍必须留在各自主权威源；知识管家负责分类、提炼、晋级、引用和回写追踪。

### 5.2 角色职责矩阵

| 角色 | 核心职责 | 主要拥有的内容 | 明确不负责 |
|---|---|---|---|
| 总管 | 识别任务类型、选择负责管家、控制跨层 Gate、维护全局 open items、协调冲突和人工确认 | 路由结果、交接契约、跨层待确认项、handoff 协调信息 | 不替专业管家直接修改领域内容；不自行宣布验收通过 |
| 文档管家 | 输入评审、需求链、总体/详细设计、追溯和文档变更传播 | `docs/inputs`、`docs/vision`、`docs/00-07`、`docs/design`、相关 doc standards 输出 | 不写生产代码；不把候选方案写成已确认；不宣布实现完成 |
| 实现管家 | 将已确认设计拆为 Sprint / Task，实施代码和配置，形成完成包 | `docs/08`、`tasks/*`、业务代码、必要配置和实现说明 | 不新增未批准需求；不替验收管家给最终通过结论；不擅改测试标准降低门槛 |
| 验收管家 | 设计测试策略和 TC，执行或核验测试，记录证据、缺陷、回归和验收结论 | `docs/09`、`tests/*`、测试报告和验证证据 | 不直接修生产代码；不修改需求以适配失败实现；不把 pending / mock 写成通过 |
| 知识管家 | 分类 ADR、调研、会议、经验和 AI meta 记录；识别应回写的长期事实；维护归档和检索入口 | `docs/decisions`、`docs/research`、`docs/meetings`、`ai-records`、知识索引 | 不把辅助记录升级成事实；不替其他管家决定需求、实现或验收状态 |

### 5.3 文件所有权原则

建议引入以下硬边界：

1. 一个文件或事实域只有一个主要内容所有者。
2. 非所有者若发现问题，只提交变更请求或交接包，不直接顺手修改。
3. 总管拥有路由和协调权，不天然拥有所有文件写入权。
4. 跨层变更必须经过明确 Gate，不通过目录扫描或关键词碰撞自动触发。
5. 项目事实、过程记录、AI meta 数据必须保持不同生命周期。

建议的默认所有权如下：

| 路径 / 事实 | 主要所有者 | 协作者 |
|---|---|---|
| `docs/inputs`、`vision`、`00-07`、`docs/design` | 文档管家 | 总管、知识管家 |
| `docs/08`、`tasks`、生产代码和实现配置 | 实现管家 | 文档管家、验收管家 |
| `docs/09`、`tests`、验证证据 | 验收管家 | 实现管家、总管 |
| `docs/decisions`、`research`、`meetings` | 知识管家 | 内容来源对应的专业管家 |
| `.ai/session-handoff.md` | 总管协调维护 | 当前任务专业管家提供状态 |
| `.ai/token-hotspots`、`.ai/pitfalls`、`ai-records/*` | 知识管家 | 总管负责触发和隐私边界 |
| `ai/`、`template-docs/`、`scripts/` 模板治理变更 | 模板维护者角色 | 对应专业管家提供评估与验证 |

### 5.4 层内自治规则

“层内只关自己的事”可以成立，但应理解为**动作自治，不是事实孤立**：

- 文档管家可以在已授权 scope 内生成或精修文档，不自动运行代码测试。
- 实现管家可以按已确认 Task 实施和自测，不自动重写上游需求。
- 验收管家可以执行验证、记录失败和提出缺陷，不直接修业务实现。
- 知识管家可以整理和提炼记录，不自动改变项目阶段状态。
- 层内发现跨层影响时，生成交接请求，由总管决定是否启动下一层。

### 5.5 跨层交接契约

每次跨层交接建议至少包含：

| 字段 | 说明 |
|---|---|
| Handoff ID | 稳定编号，例如 `XFER-DOC-IMPL-001` |
| From / To | 发起管家与接收管家 |
| 触发原因 | 哪个 Gate、变更或失败触发 |
| 权威输入 | 文件和章节，不依赖聊天记忆 |
| 请求动作 | 接收方要完成什么 |
| 允许范围 | 可读 / 可写路径与边界 |
| 禁止事项 | 不得顺带完成什么 |
| 完成条件 | 可核对输出和验收标准 |
| 回传证据 | 文档、测试、commit、PR 或记录位置 |
| 人工确认 | 是否需要、由谁确认、阻塞关系 |

典型 Gate：

```text
文档 Go
  -> 实现管家接收已确认设计和 Sprint 输入
  -> 实现完成包
  -> 验收管家执行独立核验
  -> 验收通过 / 条件通过 / 失败
  -> 知识管家提炼决策、经验和长期回写项
```

失败回退：

- 需求或设计缺口 -> 返回文档管家。
- 实现缺陷 -> 返回实现管家。
- 测试环境或证据缺失 -> 由验收管家保留未验证状态，总管协调环境或人工确认。
- 新发现的通用模板缺口 -> 知识管家提出候选，总管决定是否进入 `_proposals/`。

### 5.6 为什么短期不默认真正并发

真正并发多 Agent 的风险包括：

- 多个 Agent 同时修改同一工作区或交叉文件。
- 文档与代码尚未完成交接时，验收 Agent 提前基于半成品给结论。
- 各 Agent 重复读取完整规则，增加上下文成本。
- 状态依赖聊天记忆，交接后不可审计。
- 总管退化为“什么都再做一遍”的额外层。

因此短期应采用：

- 单会话中的角色化串行路由，或明确阶段切换。
- 必须并行时使用独立 worktree。
- 共享状态只依赖 Git、项目文档、Task、测试记录、handoff 和 PR / issue 事实。
- 先试点，再决定是否建立真正的 Agent 定义和调度机制。

### 5.7 与现有四角色建议的关系

现有 `Router / Coordinator`、`Editor`、`Verifier`、`Maintainer` 按“执行动作”分工；本提案的文档、实现、验收、知识四管家按“价值流所有权”分工。

建议不是简单替换，而是两维组合：

- 总管承担 Router / Coordinator。
- 文档管家和实现管家在自己的影响域内承担 Editor。
- 验收管家承担 Verifier。
- 模板仓发生版本、同步、PR 和归档时，由现有 Maintainer 角色叠加治理职责，不必再新增第六个常驻管家。

## 6. 问题四：治理机制注册体系

### 6.1 是否应该登记

结论：应该，并且应先于正式多 Agent 落地。

原因：

- 没有机制台账，就无法给管家分配清晰所有权。
- 没有触发和不触发条件，就无法保证层内动作不误触其他层。
- 没有依赖和冲突关系，就无法审计重复、循环或空白。
- 没有状态和生命周期，就无法淘汰已经失去消费者的机制。

### 6.2 注册表定位

建议优先扩展 `template-docs/capability-packages.md`，使其成为“治理机制与能力注册表”的人读入口，而不是新建另一份平行完整清单。

可选实现方式：

- 首批直接在现有文件新增“机制注册表”章节，最少改动。
- 若登记项增长明显，再把明细拆到 `template-docs/governance-mechanisms.md`，由 capability index 保留总览和指针。

不建议首批直接创建复杂 JSON/YAML 机制数据库；先验证字段和使用方式稳定，再决定是否结构化。

### 6.3 建议登记字段

| 字段 | 用途 |
|---|---|
| Mechanism ID | 稳定引用，例如 `MECH-DOC-001` |
| 名称 | 人可读名称 |
| 所属层 | Core / Docs / Implementation / Verification / Knowledge / Governance / Profile |
| Owner | 主要管家或维护角色 |
| 状态 | candidate / experimental / active / deprecated / retired |
| 解决的问题 | 为什么存在 |
| 适用范围 | 哪类项目、阶段和任务适用 |
| 触发条件 | 什么时候启动 |
| 不触发条件 | 哪些相似场景不应启动 |
| 权威源 | 规则、SOP 或结构化清单的唯一事实源 |
| 输入契约 | 必须读取的事实和前置状态 |
| 输出契约 | 必须产物、状态和证据 |
| 允许写入范围 | 哪些路径可被该机制修改 |
| 消费者 | 哪个文档、Agent、命令、脚本或 Gate 使用 |
| 自动化 | 相关命令、Prompt、脚本、CI |
| 验证方式 | 自动检查和人工审查 |
| 依赖机制 | 必须先满足什么 |
| 冲突 / 互斥 | 不能同时启动或会争夺事实源的机制 |
| 失败语义 | fail / pending / not-checked 如何处理 |
| 引入版本 | 何时生效 |
| 退役 / 迁移 | 替代机制和移除条件 |

### 6.4 建议首批登记的机制族

首批不必逐条登记所有小规则，先登记“具有独立触发、输入输出或生命周期”的机制族：

| 机制族 | 现有主要权威源 | 建议 Owner |
|---|---|---|
| 任务路由与规则加载 | `ai/index.md`、`ai/rules-core.md` | 总管 |
| 写入确认与 Checkpoint Mode | `rules-core`、`session-rules` | 总管 |
| 会话续接与 handoff rollup | `ai/session-rules.md` | 总管 / 知识管家 |
| 文档生成与追溯 | `ai/document-lifecycle-rules.md`、doc standards | 文档管家 |
| 文档评估 / 审计 / open items | commands + review prompts | 文档管家 / 总管 |
| Phase / Sprint / Task | `implementation-lifecycle-rules`、`docs/08` | 实现管家 |
| System Skeleton / readiness gate | implementation rules、profiles、`05/08/09` | 实现管家，验收管家核验 |
| 测试、回归与验收留痕 | implementation rules、`docs/09` | 验收管家 |
| 技术环境评估 | review prompt、`docs/research`、`05/09` | 验收管家 / 文档管家协作 |
| ADR / research / meetings 回写 | `rd-data-chain.md` | 知识管家 |
| hotspot / pitfall / summary rollup | `session-rules`、`ai-records` | 知识管家 |
| 模板提案与归档 | `CONTRIBUTING.md`、`_proposals` | Maintainer |
| 版本发布 | `VERSION`、CHANGELOG、MAINTAINERS | Maintainer |
| 下行同步与派生验收 | `template-sync.json`、sync/check scripts | Maintainer |
| Remote / CI SOP | remote profile、git guide | 总管 / Maintainer |
| Profile 启用与裁剪 | capability packages、project rules | 总管 + 对应专业管家 |

### 6.5 冲突审核规则

治理审计不应只检查“有没有机制”，还应检查：

1. **所有权冲突**：两个 active 机制是否同时拥有同一事实或文件。
2. **触发冲突**：相同用户意图是否会同时触发两个互斥流程。
3. **事实源冲突**：同一规则是否在多个文件独立定义，而不是引用。
4. **循环依赖**：A 等 B、B 又等 A，无法进入下一状态。
5. **状态升级冲突**：候选、已验证、已启用是否被跨层错误升级。
6. **验证缺口**：机制是否只有文字要求，没有自动或人工验证入口。
7. **孤儿机制**：是否没有 command、Agent、脚本或文档消费者。
8. **过期机制**：是否已有替代机制但旧入口仍 active。
9. **范围泄漏**：层内任务是否会扫描、修改或验证不属于本层的内容。
10. **失败扩散**：辅助检查失败是否会掩盖已取得的关键事实，或错误触发后续动作。

### 6.6 解耦原则

建议把解耦具体化为四条规则：

- **所有权解耦**：每个事实域有唯一 Owner。
- **触发解耦**：每个机制明确 trigger / non-trigger，不因目录中存在某文件自动全链启动。
- **执行解耦**：本层可以独立完成局部任务，跨层通过交接契约调用。
- **失败解耦**：本层失败只阻止依赖它的后续 Gate，不抹掉其他层已经确认的事实。

## 7. 问题五：工具注册与管理体系

### 7.1 当前判断

工具管理需求真实存在，但当前不是“完全没有说明”，而是“已有初级说明、缺完整治理”。因此正确动作是升级现有 `scripts/README.md`，而不是再建一个无人维护的重复列表。

### 7.2 工具注册表建议字段

| 字段 | 用途 |
|---|---|
| Tool ID | 稳定编号，例如 `TOOL-SYNC-001` |
| 名称 / 路径 | 可执行文件位置 |
| 一句话用途 | 解决什么问题 |
| 所属层 / 机制 | 归属哪个价值流和 Mechanism ID |
| Owner | 主要维护角色 |
| 调用者 | 人、command、Prompt、其他脚本或 CI |
| 运行位置 | 模板仓、派生项目、父目录或任意环境 |
| 输入 | 参数、文件、环境和前置状态 |
| 输出 | stdout、报告、文件、提交或远端状态 |
| 副作用 | 只读、写文件、安装、联网、提交、远端变更 |
| 风险等级 | low / medium / high，并说明确认点 |
| 权威实现 | 主实现路径 |
| 包装器 / fallback | wrapper 与功能等价范围 |
| 依赖 | Bash、PowerShell、Git、gh、网络等 |
| 失败语义 | 退出码、fail / pending / not-checked |
| 验证方式 | 单测、自检、smoke、CI 或人工步骤 |
| 状态 | experimental / active / deprecated / retired |
| 引入版本 | 首次进入模板的版本 |
| 替代 / 退役计划 | 被什么替代、何时移除 |

### 7.3 工具创建准入

新增脚本或工具前必须先回答：

1. 该动作是否稳定、重复，并能被机械化验证。
2. 不自动化是否会造成显著风险、频繁返工或跨项目重复劳动。
3. 是否已有工具可以扩展，而不需要新建平行实现。
4. 能否定义明确输入、输出、副作用、失败语义和维护者。
5. 是否需要 command 入口，还是只由现有机制内部调用。
6. 是否值得进入下行同步范围；仅模板维护使用的工具不应无条件下行。
7. 是否需要 Bash 主实现、PowerShell 包装器或仅一个原生实现。

满足以下情况通常**不应**新建工具：

- 只执行一次、无法稳定复现的人工调查。
- 现有脚本增加小参数即可覆盖。
- 只是为了包装一条简单命令，却引入新的维护入口。
- 无法定义失败语义，或只能靠 AI 猜测输出。
- 没有明确消费者或 Owner。

### 7.4 权威实现与包装器规则

当前模板已有 Bash 主实现和 PowerShell wrapper / fallback 模式。注册表应显式表示：

- 哪个文件是权威逻辑。
- 哪个只是包装入口。
- fallback 覆盖到什么程度，哪些检查不等价。
- 修改主实现时需要同步检查哪些包装器、SOP 和断言。

这样可以避免把 `.sh` 与 `.ps1` 错算为两个独立能力，也避免两个实现逐步漂移。

### 7.5 工具生命周期

建议统一状态：

```text
candidate -> experimental -> active -> deprecated -> retired
```

- `candidate`：只有需求和设计，不提供稳定入口。
- `experimental`：可试用，但不作为默认路径，兼容性未承诺。
- `active`：有权威入口、文档、消费者和验证。
- `deprecated`：仍兼容，已声明替代方案和移除窗口。
- `retired`：不再调用；代码已移除或只在归档中保留。

工具不得从 active 直接静默消失。退役至少需要：

- 搜索并迁移 command、Prompt、SOP、CI 和其他脚本消费者。
- 更新 `template-sync.json` 及同步兼容策略。
- 更新工具注册表和 CHANGELOG。
- 对派生项目说明替代路径或兼容窗口。

### 7.6 自动校验建议

分阶段引入轻量校验：

**阶段 1：advisory**

- `scripts/` 中的可执行脚本必须能在注册表找到。
- 注册表声明的路径必须存在。
- wrapper 必须指向已登记的权威实现。
- 已标 retired 的工具不得仍被 active command / CI 引用。

**阶段 2：blocking**

- 登记字段和使用方式稳定后，再把路径存在性、唯一 Tool ID、权威实现唯一性转为阻断门禁。
- 不建议对长文案、owner 名称或所有描述字段做 CI 字符串断言。

### 7.7 是否需要单独的机器可读注册表

短期建议：不需要。

先用 `scripts/README.md` 的结构化 Markdown 表验证字段和维护习惯。满足以下条件后再考虑 `tool-registry.json`：

- 工具数量继续增长，Markdown 已难维护。
- `check-template`、命令路由或 Agent 调度需要程序化查询。
- 字段已经过至少两个发布批次验证，变化趋于稳定。
- 能明确 JSON 是权威源，README 由它生成或只保留摘要，避免双写。

## 8. 推荐目标架构

### 8.1 分层模型

建议在现有 Core / Docs / Implementation / Verification / Governance 上增加 Knowledge 的显式人读影响域，但不立即改动所有规则文件：

| 层 | 主要职责 | 主要 Owner | 典型权威源 |
|---|---|---|---|
| Core / Coordination | 路由、确认、状态、跨层协调 | 总管 | `ai/index.md`、`rules-core`、`session-rules` |
| Documentation | 输入、需求、设计、追溯、传播 | 文档管家 | `document-lifecycle-rules`、doc standards、`docs/00-07` |
| Implementation | Phase、Sprint、Task、代码、完成包 | 实现管家 | `implementation-lifecycle-rules`、`docs/08`、`tasks`、代码 |
| Verification | 测试策略、TC、证据、验收与回归 | 验收管家 | `docs/09`、`tests`、verification profiles |
| Knowledge | 决策、调研、会议、经验、归档与回写追踪 | 知识管家 | `rd-data-chain`、`docs/decisions`、`research`、`ai-records` |
| Governance | 模板提案、版本、同步、发布、自检 | Maintainer | `CONTRIBUTING`、`MAINTAINERS`、`template-sync.json` |
| Profiles | 条件启用的局部能力契约 | 总管路由 + 对应专业 Owner | `capability-packages.md`、各 Profile |

### 8.2 总管只协调的约束

为防止“大管家最后什么都管”，建议规定：

- 总管只产出任务分类、Owner、交接顺序、确认点和状态汇总。
- 总管不得在没有专业管家结果时自行补领域结论。
- 总管不重复运行已经有可信证据的验证。
- 单层任务直接交给对应管家，不强制经过完整五角色流水线。
- 只有跨层、冲突、阻塞、状态晋级或模板治理任务才需要总管持续参与。

### 8.3 不采用事件自动触发链

首批不建议实现“某目录一变化就自动召唤下一管家”的事件链。原因是：

- 文件变化不等于语义状态完成。
- 草案、候选、已验证和已启用不能仅凭路径判断。
- 自动触发容易造成连锁读取和误写。

建议由显式 Gate / handoff contract 触发，未来若自动化，也必须读取状态字段和完成证据，而不是只监听路径变化。

## 9. 分阶段实施路线

### Batch 0：确认设计边界

目标：确认本提案的术语、首批范围和版本策略。

待确认：

- 是否采纳“五角色逻辑模型”。
- Knowledge 是否作为显式影响域加入 capability index。
- 首批是否只做登记和手册导航，不创建可执行 Agent 配置。
- 是否以 `template-methodology.md` 作为开发手册主干。

产物：本提案确认版。

版本影响：`none`。

### Batch 1：机制与工具只读盘点

目标：先看清现状，不改变行为。

建议改动：

- 在 `template-docs/capability-packages.md` 增加机制注册表章节或链接到单独明细。
- 升级 `scripts/README.md` 为工具注册表，补齐当前 15 个可执行脚本（归并为 12 类工具能力）及 wrapper / 权威实现关系。
- 明确 command、Prompt、脚本、Profile 和机制之间的引用关系。
- 输出重复、冲突、孤儿和登记缺口清单，但不在同一 Batch 大规模修复。

版本建议：若只补人读登记且不改变推荐流程，优先 `patch`。

### Batch 2：开发手册主干重构

目标：让人能从一份主干理解模板架构和入口。

建议改动：

- 重构 `template-docs/template-methodology.md` 的章节与导航。
- 更新 `template-docs/README.md`、根 `README.md` 和 `beginner-guide.md` 的指针，避免复制正文。
- 引用机制注册表与工具注册表。
- 保持原路径，避免派生项目链接失效。

版本建议：若只重组说明和导航，`patch`。

### Batch 3：五角色契约落地

目标：形成可执行但不强制并发的角色契约。

建议改动：

- 在 capability index 中登记总管、文档、实现、验收、知识角色。
- 定义文件所有权、交接字段、Gate 和失败回退。
- 在 `ai/index.md` 任务路由中补 Owner 信息，但保持现有规则入口权威。
- 不立即复制四套规则；各角色按现有规则 scope 工作。

版本建议：如果角色契约成为派生项目推荐工作流的新采用面，建议 `minor`；若仅实验性、默认关闭，可先 `patch`。

### Batch 4：双用例试点

建议试点两个闭环：

1. **文档生成试点**：输入评审 -> 文档生成 -> open items -> 文档 Go；验证文档管家与总管的边界。
2. **Sprint 实现验收试点**：Task -> 实现完成包 -> 独立验收 -> 缺陷回退 -> 经验沉淀；验证实现、验收、知识三管家交接。

试点观察指标：

- 是否减少无关规则和文件读取。
- 是否出现两个角色争夺同一文件。
- 是否出现总管重复专业工作。
- 交接信息是否足以跨会话恢复。
- 验收失败能否准确路由回责任层。
- 知识记录是否正确回写长期事实而非形成平行事实源。

### Batch 5：决定物理演进

仅在试点证明必要后评估：

- 是否拆出 `ai/verification-lifecycle-rules.md`。
- 是否新增 knowledge lifecycle 专题规则，或继续由 `rd-data-chain.md` 承载。
- 是否建立真正可执行的 Agent 配置。
- 是否需要机器可读 mechanism / tool registry。
- 是否需要多 Agent 并发调度和自动 handoff。

没有实证时不推进目录级重组。

## 10. 候选修改文件与影响面

以下是未来实施候选，不代表本报告已授权修改：

| 文件 | 候选变更 | Batch |
|---|---|---:|
| `template-docs/capability-packages.md` | 增加 Knowledge 影响域、机制注册表、五角色契约和交接协议 | 1 / 3 |
| `scripts/README.md` | 升级工具注册字段，补齐脚本，标注主实现 / wrapper / fallback / 生命周期 | 1 |
| `template-docs/template-methodology.md` | 重构为开发手册主干 | 2 |
| `template-docs/README.md` | 更新手册导航 | 2 |
| `README.md` | 保持轻量，只更新开发手册 / 注册表入口 | 2 |
| `template-docs/beginner-guide.md` | 新手视角增加角色与入口解释，不复制治理细节 | 2 |
| `ai/index.md` | 角色试点后在任务路由增加 Owner / handoff 提示 | 3 |
| `ai/rules-core.md` | 如确有必要，补总管不越权和跨层显式 Gate 最小硬规则 | 3 |
| `ai/implementation-lifecycle-rules.md` | 试点后收紧实现与验收职责边界 | 3 / 5 |
| `ai/session-rules.md` | 试点后补跨角色 handoff 最小字段；不把 handoff 变成事实源 | 3 |
| `scripts/check-template.sh` | 先 advisory 校验注册完整性，稳定后再决定 blocking | 1 / 5 |
| `template-sync.json` | 新增同步范围文件时更新；只改既有同步文件内容则不扩清单 | 按实际 |
| `VERSION`、`CHANGELOG*.md` | 按每个实施 Batch 的实际发布影响更新 | 1-5 |

## 11. 版本影响建议

### 11.1 当前报告

本次只新增 `_proposals/` 报告，不改变同步范围或模板行为：

- `Release impact: none`
- 不修改 `VERSION`
- 不修改 `CHANGELOG`

### 11.2 Batch 1 实施

Batch 1 修改了同步范围内的 `template-docs/capability-packages.md`，使派生项目获得治理机制总览，因此按兼容文档能力增强发布：

- `Release impact: patch`
- `VERSION`: `v1.61.5` → `v1.61.6`
- 更新既有 `CHANGELOG.md` 与 `CHANGELOG-PLAIN.md`；不新建仓库中不存在的 `CHANGELOG.zh-CN.md`
- 不修改 `template-sync.json`；`scripts/README.md` 尚未下行的问题登记为缺口，留待单独决策

### 11.3 后续实施

| 实施内容 | 建议版本判断 |
|---|---|
| 补机制 / 工具登记、补手册导航，不改变默认行为 | `patch` |
| 新增 advisory 自检但不阻断现有流程 | 通常 `patch` |
| 五角色成为推荐工作流或新增派生项目可见采用面 | `minor` |
| 新增同步范围结构文件或强制新 Gate | `minor` |
| 重写核心路由、目录或同步协议并要求迁移 | 才考虑 `major` |

同一主题可以聚合，但建议登记、手册、角色试点分别保留清晰 Batch 和验证证据，不把所有变更塞进一个高风险 PR。

## 12. 风险与控制措施

| 风险 | 表现 | 控制措施 |
|---|---|---|
| 过度治理 | 为每条小规则建立机制和 ID | 只登记有独立触发、输入输出或生命周期的机制族 |
| 双份权威 | 手册、注册表和规则都复制同一要求 | 手册解释与导航；注册表登记元数据；规则保持执行权威 |
| Agent 名称大于实际价值 | 建了五个角色，但工作仍由总管重复完成 | 规定总管不代做；用试点指标验证角色是否真实降复杂度 |
| 跨层死锁 | 每层都等待另一层先完成 | 交接契约明确前置、完成条件和失败回退；总管裁决阻塞关系 |
| 验收失去独立性 | 实现管家同时修改测试标准并宣布通过 | 验收管家拥有 `09` 和最终证据；实现管家只能提供自测摘要 |
| 知识层变成杂物箱 | 所有记录都丢给知识管家 | 保持项目事实、过程记录、AI meta 三类生命周期；长期事实必须回写权威源 |
| 工具注册表漂移 | 新脚本加入但无人登记 | 先 advisory、后 blocking 的路径存在性和唯一性检查 |
| 工具重复建设 | 相同能力以多个脚本出现 | 新工具准入必须检查扩展现有工具；登记权威实现与 wrapper |
| 物理拆分破坏同步 | 移动规则或目录导致派生项目断链 | 首批不移动；试点后单独评估迁移和兼容方案 |
| 多 Agent 并发冲突 | 同工作区交叉写入 | 默认不并发；并发必须独立 worktree 和文件影响域 |

## 13. 验收标准

### 13.1 本报告验收

- 报告明确回答手册“增量重构还是重建”。
- 报告给出总管 + 四专业管家的职责、所有权和禁止项。
- 报告给出层内自治与跨层交接的可执行字段。
- 报告给出机制注册表字段、首批机制族和冲突审计口径。
- 报告给出工具注册字段、创建准入、生命周期和自动校验路线。
- 报告包含去重分析、分批路线、版本建议、风险和待确认项。
- 报告没有把待确认建议写成已批准事实。

### 13.2 Batch 1 验收

- 当前 15 个可执行脚本全部登记，归并为 12 类工具能力，路径存在。
- Bash 主实现、PowerShell wrapper / fallback 关系明确。
- 至少能识别现有遗漏、重复候选和孤儿引用。
- 机制注册表覆盖首批机制族，并为每项指定唯一 Owner 和权威源。
- 不改变当前默认执行行为。

### 13.3 Batch 2 验收

- 使用者能从一个主干页面理解模板层次、四条价值流和入口。
- 维护者能从手册进入机制和工具注册表。
- 手册没有复制规则正文形成第二权威源。
- 现有关键路径和链接保持兼容。

### 13.4 Batch 3-4 验收

- 单层任务只启动对应管家，不必跑完整五角色流程。
- 跨层任务使用明确 handoff contract。
- 没有两个角色同时拥有同一事实源。
- 验收失败能回到实现或文档责任层，不由验收管家直接修生产代码。
- 知识管家能区分辅助记录和长期事实，并推动正确回写。
- 试点证明角色化减少而不是增加读取、重复工作和交接成本。

## 14. 待人工确认项

| ID | 待确认项 | AI 建议 | 建议依据 | 备选方案 | 取舍影响 / 阻塞关系 |
|---|---|---|---|---|---|
| GOV-C-001 | 开发手册采用何种建设方式 | 以 `template-methodology.md` 为主干增量重构 | 现有内容成熟且已有稳定入口；重写会形成双份权威和链接迁移成本 | 新建 `developer-handbook.md`；或只零散补现有文档 | 阻塞 Batch 2；不阻塞 Batch 1 登记 |
| GOV-C-002 | 是否采纳五角色逻辑模型 | 采纳“总管 + 文档 / 实现 / 验收 / 知识管家”，先角色化、不默认并发 | 与现有影响域兼容，能表达价值流 Owner；并发风险尚未实证可控 | 保持现有 Router / Editor / Verifier / Maintainer 四角色；或直接建五个并发 Agent | 阻塞 Batch 3；不阻塞登记和手册 |
| GOV-C-003 | Knowledge 是否成为显式影响域 | 在人读 capability index 中新增 Knowledge；暂不新建强制规则文件 | `rd-data-chain` 已形成事实基础，但当前影响域表未显式呈现知识所有权 | 继续归入 Governance；或立即新增 knowledge lifecycle rules | 影响角色边界；立即拆规则风险较高 |
| GOV-C-004 | Verification 是否立即拆出独立规则 | 暂不拆；先用角色契约和双用例试点验证 | 测试当前横跨 `docs/09` 和 implementation lifecycle，直接拆分可能产生双重权威 | 立即新建 `verification-lifecycle-rules.md` | 不阻塞角色试点；阻塞物理规则拆分 |
| GOV-C-005 | 机制注册表放在哪里（Batch 1 已确认） | 先扩展 `template-docs/capability-packages.md`；增长后再拆明细 | 现有文件已经是能力和影响域索引，最少重复 | 新建 `template-docs/governance-mechanisms.md` | 已按 Batch 1 授权实施；后续拆分仍需另行确认 |
| GOV-C-006 | 工具注册表采用 Markdown 还是机器可读格式（Batch 1 已确认） | 首批升级 `scripts/README.md`；字段稳定后再评估 JSON | 当前规模适合人工维护，过早结构化会增加双写和 schema 成本 | 立即新增 `tool-registry.json` | 已按 Batch 1 授权实施；机器可读格式仍未授权 |
| GOV-C-007 | 注册完整性检查何时阻断（Batch 1 已确认不新增门禁） | 首批只做人工登记和审计，完成一轮修正后再评估 advisory / blocking | 先暴露存量缺口，避免新门禁立即阻塞所有维护 | 首批即 blocking；或永久只人工检查 | 本批未改自检行为；后续自动检查仍需另行确认 |
| GOV-C-008 | 首批是否创建可执行 Agent 配置 | 不创建；先核实现有配置并完成角色试点 | 当前实际 Agent 配置尚未完成可靠核实，且既有提案明确暂缓真正并发 | 直接创建五 Agent 配置 | 阻塞 Agent 实施，不阻塞角色契约 |
| GOV-C-009 | 后续发布如何拆批 | Batch 1-2 作为兼容治理增强；Batch 3-4 单独评估 MINOR | 登记/手册与角色工作流的采用面和风险不同 | 一次性合并为单个 MINOR | 分批更易验证和回滚；一次合并更快但风险高 |

## 15. 推荐决策

AI 建议维护者确认以下总体方向：

1. 批准本报告作为后续设计依据，但不等同于批准全部实施。
2. 先启动 Batch 1，只做机制和工具现状登记，不改默认行为。
3. 原则同意在现有 `template-methodology.md` 上建设开发手册，不另起重复主干。
4. 原则同意五角色逻辑模型，以角色化流程试点，不默认并发。
5. 暂不拆 Verification 独立规则，不创建机器可读注册表，不创建可执行 Agent 配置。
6. Batch 1 完成后重新评估冲突清单和实际成本，再确认 Batch 2-4。

该顺序能够先解决“看不见、说不清”的问题，再决定是否需要“拆目录、建 Agent、加自动化”，避免用更复杂的新机制掩盖现有资产可见性不足。

## 16. Batch 1 实施记录

### 16.1 已实施范围

- `template-docs/capability-packages.md`：重命名文档标题为“模板机制与专项使用说明”，按读者实际使用顺序重写正文；14 类治理机制统一登记负责人、使用时机、主要依据、产出边界和完成判断，并说明分区内负责、跨分区协调的处理方式。
- `scripts/README.md`：把 15 个可执行脚本归并为 12 类工具能力，登记运行位置、Owner、消费者、输入、输出、副作用、风险、权威实现、失败语义和生命周期规则。
- `VERSION`、`CHANGELOG.md`、`CHANGELOG-PLAIN.md`：按 PATCH 记录 Batch 1 的下游可见人读增强。

### 16.2 审计发现

- 原说明遗漏 `check-github-context.ps1` 和 `check-markdown-clean.ps1`，本批已补登记。
- `sync-template`、`check-template`、`check-derived-sync` 的 Bash / PowerShell 双入口是主实现与 wrapper / fallback 关系，不是重复工具。
- `check-template` 与 `check-markdown-clean`、`check-prereqs` 与 `check-runtime`、`sync-all-derived` 与 `sync-template` 均为聚合或深浅分工，不建议合并。
- 当前未发现完全无用途的可执行脚本；真实采用率仍需结合派生项目抽查，不能只由模板仓引用推断。
- `scripts/README.md` 当前不在 `template-sync.json` 中，派生项目会获得脚本但不会自动获得工具注册表。这是 Batch 1 识别出的治理缺口，不在本批改变同步边界。
- 机制登记初稿含 5 类失效引用：文档审计命令、文档评估 Prompt、待确认事项 Prompt、开发计划文件，以及研发数据链 / CHANGELOG 文件名；本次重写已改为仓库内实际存在的路径。

### 16.3 明确未实施

- 未创建总管或四个专业 Agent，未启用多 Agent 并发。
- 未拆分现有规则文件，未修改 `ai/index.md` 路由。
- 未新增 advisory 或 blocking 自检，未修改任何脚本行为或退出码。
- 未把 `scripts/README.md` 加入同步清单。
- 未启动 Batch 2-5。

### 16.4 人工评审结论

- 维护者已接受“模板机制与专项使用说明”和工具注册表作为 `v1.61.6` Batch 1 的正式内容。
- `scripts/README.md` 暂不加入 `template-sync.json`；工具说明是否下行到派生项目，作为独立后续事项评估，不阻塞本批提交。

### 16.5 验证结果

- `git diff --check`：通过，仅有 Windows 工作区 LF → CRLF 提示。
- `scripts/check-markdown-clean.ps1 _proposals scripts/README.md template-docs/capability-packages.md CHANGELOG.md CHANGELOG-PLAIN.md`：通过，共检查 17 个 Markdown 文件。
- `scripts/check-template.ps1`：机制文档初稿完成后通过，`1996` 项 / `0` 失败，耗时约 234 秒。
- 按文档语言规范重写 `template-docs/capability-packages.md` 后重新运行 `scripts/check-template.ps1`：通过，`1996` 项 / `0` 失败，耗时约 247 秒。
- 首次完整自检曾因外层 120 秒预算不足被截断；后续两次均使用 300 秒上限完整通过，未修改脚本或降低检查范围。
