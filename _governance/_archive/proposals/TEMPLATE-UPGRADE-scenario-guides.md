# TEMPLATE-UPGRADE: 场景引导编排层（scenario-guides）

> 状态：草案 v6（待维护者评审）
> 提案目标版本：v1.22.0
> 提出日期：2026-07-01
> 维护分支：`change/scenario-guides`
> 主题：新增分角色的场景引导编排层，收敛散落的 AI CLI 引导词，让「说一个场景 → 给分步引导计划」成为标准交互

## 1. 动机

模板现有引导资产分四层（`README` 门面 / `template-docs/` 手册 / `ai/commands/` 单点路由 / `ai/prompts/` 详细 prompt），但缺少一层把单点操作串成**端到端场景剧本**的编排，导致：

1. **引导词三处近乎逐字重复且已漂移**：同一段「第一次打开 AI CLI」7 步引导词出现在 `README` §推荐路径、`template-docs/beginner-guide.md` §4 路径 A、`template-docs/ai-cli-setup.md` §6。其中 `ai-cli-setup §6` 比另两处多一句关键的场景区分（「已在派生项目则第 3 步改确认 Git 状态」），三处不同步。违反模板自身反双写纪律（`commands/README` 维护规则、`global-rules §9`）。
2. **缺端到端场景剧本**：`commands` 把操作拆成原子（new-project / generate-docs / sync-methodology …），但跨工作目录的端到端流程没有权威剧本。
3. **场景的工作目录（cwd）切换点不明确**：引导词步骤横跨「模板仓库」与「派生项目」两个 cwd，没标切换点；且没有「先判断 cwd 状态再路由」的入口机制。
4. **新项目第一次运行无独立场景定义与状态识别**：与「新建项目」混在同一段引导词里。
5. **cmd 兜底路径散乱**：无 AI 时的手动命令分散在 `README` / `git-guide` / `SOP`，没有按场景组织。
6. **缺「冷启动」场景**：所有现有场景隐含「已在本地有模板仓库或派生项目」。若用户只有仓库链接、本地零资产，没有引导路径（事实上 `new-project.sh` 远端模式不需先 clone 模板，但用户不知道）。
7. **账户默认化不适用多用户**：模板此前由单人同时担任使用者/设计者/维护者，远端建仓隐含默认账户。放开给其他使用者后，账户/可见性/是否建远端不能再假设默认，需显式引导；同时模板内不得硬编码任何具体账户（去项目化）。
8. **文档体系「一键生成」易漂移、缺 PLM 阶段细分与验证场景**：现有「生成文档体系」是一键铺 00-09，缺「按 PLM 阶段逐文档生成/审核/精修」的细分场景，也缺文档审核后的「验证验收」场景。
9. **缺「准备输入材料」的独立引导**：新用户做项目时最大的卡点是「不知道要准备什么输入」。现有流程直接评审输入，缺前置的「按已有材料分层引导准备」场景。
10. **缺「阶段规划」独立场景**：想定/输入 → 需求/设计是按完整愿景铺的，但实现要分 Demo→MVP→产品。缺「评审完整文档体系 → 建议阶段划分（哪些 REQ 进 P1 Demo）→ 落实到 03 §3 路线图与 08 计划」的引导（对应 `global-rules §8` 阶段双维度）。
11. **缺设计文档图表规范**：04/05/06/07/design 该含哪些图（架构/流程/ER/时序等）、格式用 mermaid 还是 plantuml，全无约定，导致文档图表风格不一、AI 生成时无所适从。

核心诉求：用户在 AI CLI 里直接说一个具体场景意图，AI 即识别角色+场景+当前状态，产出分步引导计划（每步带目的/影响/确认点），逐步执行，完成后给下一步。

## 2. 目标 / 非目标

### 目标
- 新增一层场景引导编排：用户说一个具体场景意图 → AI 产出分步引导计划 → 逐步执行。
- 按角色（使用者 / 维护者）与**用户旅程**组织场景，覆盖从冷启动到演进、从输入准备到验证的完整链路。
- 提供**场景路由入口**：AI 先判断 cwd 状态（零资产 / 模板仓库 / 派生项目）再路由。
- 提供**输入材料准备的分层引导**，降低新用户「不知准备什么」的卡点。
- 提供**阶段规划引导**（Demo/MVP/产品 × P1/P2/愿景 路线图），衔接完整设计与分阶段实现。
- 提供**设计文档图表规范**（类型+格式，默认 mermaid，用户可确认）。
- 明确每个场景的 cwd、前置、步骤序列、完成判据、下一步。
- 收敛三处重复引导词为唯一源；提供 cmd 兜底指针（不重写命令）。
- 明确账户/可见性/远端的多用户引导约定，模板去账户化。

### 非目标
- 不复制 `commands`/`prompts` 正文，只做编排引用（守住反双写纪律）。
- 不为本提案外的新能力立项；场景剧本只编排现有积木（A4/A9/C2/C5/C7 等能力部分待补的场景，剧本写完整但标注待补）。
- 不在初版做 SessionStart hook 自动化（列为后续可选增强，跨 AI 工具不一致）。
- 不改变现有规则文件的核心约束；场景引导是能力增强层，图表规范是对 doc-standards 的补充，不替代 `ai/index.md`、`global-rules` 等。

## 3. 拟改

### 3.1 新增 `template-docs/scenario-guides.md`（主文件，静态文档）
内容结构：
- 角色定义：A 使用者 / C 维护者（含设计）。含**账户约定**（见 §4.1）。
- **场景路由入口**：cwd 状态识别三分支（见 §4.2）。
- 工具形态说明：AI CLI / IDE（主，对话式分步）/ cmd（兜底，指针）。
- 「说场景 → 给引导计划」触发约定 + 冷启动识别（零本地资产时先走 A0）。
- 引导计划输出契约（标准格式，见 §4.3）。
- 场景目录（角色 × 旅程 × 场景矩阵，见 §4.4）。
- 每个场景条目字段：触发说法 / cwd 上下文 / 前置 / 步骤序列（**引用** command+prompt+script，不复制）/ 完成判据 / 下一步场景 / cmd 兜底指针。
- **图表规范横切说明**（见 §3.6）。
- A7 的 PLM 转换子场景（见 §4.5）。
- 元场景 M1：如何用本文件做事。

### 3.2 新增 `ai/commands/scenario.md`（元命令）
- `/run scenario` 或自然语言「我想 <场景>」。
- 路由到 `scenario-guides.md`，AI 按契约产出引导计划。
- 在 `commands/README` 命令表新增一行；顶部加「场景优先」约定：AI 听到场景意图，先查 `scenario-guides.md` 产出引导计划，再路由到具体 command。

### 3.3 收敛三处引导词
- `README` §推荐路径、`beginner-guide` §4 路径 A、`ai-cli-setup` §6 的逐字重复 7 步话术，改为「说一个场景，见 `scenario-guides.md`」的触发示范 + 指针；`scenario-guides.md` 成为唯一源。保留各文档自身语境，只删重复正文。

### 3.4 纳入下行同步
- `template-sync.json` 新增 `template-docs/scenario-guides.md` 与 `ai/commands/scenario.md`，派生项目同步后获得同等能力。

### 3.5 配套更新
- `README`「我该看哪个文件」表 + 「常用命令」补 `scenario-guides` 入口。
- `SOP.md` 场景索引补场景引导。
- `scripts/check-template.sh` / `check-template.ps1` 加断言：`scenario-guides.md` 存在、`commands/scenario.md` 路由有效、三处引导词不再逐字重复、模板内不出现硬编码具体 GitHub 账户（防漂移与去账户化回归）。

### 3.6 设计文档图表规范（横切）
- `document-lifecycle-rules` / `ai/doc-standards` 增图表约束：04 总体设计（系统架构图 / 运行拓扑）、05 技术方案（技术栈 / 部署拓扑）、06 DB（ER 图）、07 API（接口 / 时序）、`docs/design`（流程 / 状态机 / 交互）应含的图表类型。
- 格式默认 **mermaid**，可选 plantuml；`ai/project-rules.md` 增「图表格式偏好」填项（默认 mermaid，用户可改）。
- scenario-guides.md 加图表规范横切说明；A3 首跑填 project-rules、A7 精修设计文档时引导确认图表偏好。
- `check-template` 可加轻量断言：设计文档包含规定图表、格式一致（可选，避免过度刚性）。

## 4. 角色与场景定义

### 4.1 角色
- **A 使用者**：基于模板做派生项目开发的人（多数，含团队其他成员）。主工具 AI CLI。
- **C 维护者**：维护模板仓库的人，含方法论设计、提案处理、版本与同步机制维护、新增模板能力。

**账户约定（多用户）**：
- 模板内**不硬编码**任何具体 GitHub 账户/邮箱（去项目化）。
- 远端建仓默认使用「当前 `gh` 登录账户」（`new-project.sh` 已如此实现）。
- 场景引导把**账户 / 可见性 / 是否建远端**列为必填决策项：
  - 识别为**维护者**（C 角色或用户确认是模板所有者）→ 可建议沿用当前 `gh` 登录账户。
  - 识别为**其他使用者**（A 角色，多人放开使用）→ 必须显式确认账户、可见性、是否建远端，不假设默认账户。

### 4.2 场景路由入口（cwd 状态识别）

AI 收到用户的场景意图后，第一步判断当前工作目录状态再路由——「已在模板文件夹里」本身不是场景，而是路由的输入状态。

| cwd 状态 | 判据 | 路由含义 |
|---|---|---|
| 零本地资产 | cwd 无 `.git` / 空目录 / 用户明确「只有仓库链接」 | **无论目标场景是什么，先走 A0 冷启动**获取资产，再衔接到目标场景 |
| 在模板仓库 | cwd 是 `ai-project-template` 本体（有 `template-sync.json` + `_proposals/` + 模板标识 `README`） | 通常意图为 **A2 新建派生项目**，或 C 维护场景（C1–C7） |
| 在派生项目 | cwd 有 `VERSION` + `ai/` + `docs/`，但非模板本体（`README` 是项目说明、有项目专属内容） | 进入 **A3–A14** 开发/演进场景 |

> 三分支判断也写进 §4.3 契约的「状态识别」行；AI 必须先识别状态，零资产时不得跳过 A0。

### 4.3 引导计划输出契约

AI 识别到场景后，按以下格式产出（示例用「新建派生项目」，**已去账户化**）：

```
场景：<名> ｜ 角色：<A/C> ｜ 工具：<AI CLI/cmd>
状态识别：<§4.2 三分支判断结果；零本地资产时先转 A0>
引导计划：
  ① [只读]       <步骤>   → 影响：<…>
  ② [写入·确认]  <步骤>   → 影响：<…>
  ③ [只读]       <步骤>   → 影响：<…>
  ④ [引导]       <下一步>
完成判据：<…>
下一步场景：<衔接场景>
```

每步标注 **只读 / 写入·确认**（对应 `project-rules §6` 确认规则）。

### 4.4 场景清单（初版，共 23）

#### A 使用者（15，按用户旅程）
| 编号 | 场景 | 编排的现有能力 |
|---|---|---|
| A0 | 冷启动（只有仓库链接） | 识别意图 → `new-project.sh` 远端派生（无需先 clone 模板）/ `git clone` 已有项目 → 转 A1 或 A3 |
| A1 | 环境准备（onboarding + 排障） | `check-prereqs.ps1` + `bootstrap-dev-env.ps1` + `ai-cli-setup.md`；排障：check-prereqs 失败 → `template-docs/env-setup.md` / PowerShell fallback / 公司中转站代理 |
| A2 | 新建派生项目 | `new-project`(14) + `new-project.sh` + `collect-env`(13)；含账户/可见性/远端引导 |
| A3 | 新项目第一次运行 | `collect-env`(13) + 填 `project-rules.md`（含图表格式偏好）+ 转 A4 |
| A4 | 准备输入材料 ◐ | 按已有材料分层引导：完整文档→放 `docs/vision/`·`docs/inputs/`·`docs/decisions/`；零散想法/无几→填 `docs/inputs/initial-brief.md` 最小必要模板（目标用户/核心场景/输入输出/验收/非目标）；衔接 A5 评审反馈缺口、迭代补充 |
| A5 | 评审输入材料 | `review-inputs`(01)（入口模式 / 剖面 / 缺口；反馈待补信息） |
| A6 | 生成文档骨架 | `generate-docs`(00)（一键铺 00-09 骨架） |
| A7 | PLM 文档精修（转换子场景集，见 §4.5） | `edit-single-doc`(04) + `generate-docs`(00) 分阶段 + `review-inputs`(01)；支持全链路 / 单转换 / 单文档三种粒度 |
| A8 | 文档体系审计 | `docs-system-audit`(16) + `docs-checklist`(10)（开发前 PLM 全链审计） |
| A9 | 阶段规划与路线图 ◐ | 评审完整 docs（03/04/05）+ `global-rules §8` 阶段双维度（功能范围 P1/P2/愿景 × 交付物 Demo/MVP/产品）+ `project-rules §1` → 建议 Demo→MVP→产品 阶段划分（哪些 REQ 进 P1 Demo）→ 落实 03 §3 路线图 + 08 Sprint 划分 + project-rules §1 Phase 边界 |
| A10 | 执行 Sprint / 任务（编码 + 合规审查 + 提交） | `docs-checklist`(10) + `run-dev-task`(02) + `project-review`(03) 实现合规审查（`global-rules §4` 六维度 + 边界审查）+ `commit-message`(06) + 可选 PR（`git-guide §3.1`） |
| A11 | 修 Bug | `fix-bug`(05) + `commit-message`(06) |
| A12 | 验证与验收 | `09-verification`（REQ→用例追溯 / 资源验证 / 验收策略）+ `sprint-summary`(09) + 实际测试运行 |
| A13 | 同步模板到派生项目 | `sync-methodology`(12) + `post-sync-cleanup`(15) + `docs-system-audit`(16) + `check-derived-sync.ps1` |
| A14 | Phase 升级 | `phase-upgrade`(08) |

#### C 维护者（7，含设计）
| 编号 | 场景 | 编排的现有能力 | 完整度 |
|---|---|---|---|
| C1 | 处理 `_proposals` 提案 | `template-proposal-summary`(11) + 分支→PR→归档 | ✓ |
| C2 | 版本 bump 与发布 | `MAINTAINERS` 发布 checklist + 打 tag（vX.Y.Z）+ GitHub Release + `CHANGELOG` + `check-template` 防滞后断言 | ◐ manual |
| C3 | 模板自检 | `check-template.ps1/.sh` | ✓ |
| C4 | 维护分支→PR→合并→归档 | `git-guide` §3-4 + `CONTRIBUTING` | ✓ |
| C5 | 维护下行同步机制 | `template-sync.json` + `sync-template` 脚本 + fallback | ◐ manual |
| C6 | 派生同步验收 | `check-derived-sync.ps1` + `derived-sync-report-template` | ✓ |
| C7 | 设计 / 新增模板能力 | 新增规则 / 文档骨架 / command / prompt / script（本提案即 C7 产物） | ◐ manual |

#### 元场景（1）
| 编号 | 场景 | 说明 |
|---|---|---|
| M1 | 用场景引导做事 | 教 AI 怎么用 `scenario-guides.md`：先按 §4.2 判断 cwd 状态 → 识别角色+场景 → 按契约产出引导计划 → 逐步执行；会话续接见 `ai/session-rules.md`，跨 Claude/Codex 一致 |

> 完整度标注：✓ = 现有 command+prompt+script 齐备；◐ = 能力部分待补（**A4** 待补输入材料最小模板；**A9** 待补阶段规划专门引导；C2/C5/C7 无专门 command，剧本引导走文档/手动路径）。

### 4.5 A7 的 PLM 转换子场景

A7 不是简单逐个文档精修，而是按 `document-lifecycle-rules` §2/§5 的 PLM 链路组织为一组**有方向的转换子场景**（上游 → 下游）。用户进入 A7 后可选三种粒度：
- **全链路**：沿主链顺序打磨（A7.1→A7.2→A7.4→A7.5→A7.6），并在需求就绪后并行 A7.3 定义验收、在实现后用 A7.7 回流。
- **单转换**：只做某个 A7.x（如「需求→总体设计」）。
- **单文档**：只精修 00-09 中某个文档。

| 子场景 | 上游 → 下游 | 依据（doc-lifecycle §5 生成矩阵） |
|---|---|---|
| A7.1 | 愿景 + 输入材料 → 需求阶段（00-03） | 00/01/02/03 行 |
| A7.2 | 需求（00-03）→ 总体设计（04-05） | 04/05 行 |
| A7.3 | 需求（00-03）→ 测试用例（09） | 09 行（REQ→用例追溯，早期定义验收） |
| A7.4 | 总体设计（04-05）→ 详细设计（06-07 + docs/design） | 06/07/design 行 |
| A7.5 | 详细设计 → 实现计划（08 + tasks） | 08/tasks 行 |
| A7.6 | 实现计划 → 验证（09） | 09 行 |
| A7.7 | 代码 → 文档反向同步 | §9 变更传播；`sync-docs-from-code`(07) |

> A7 的每个转换都引用 `document-lifecycle-rules §5` 的对应行作为权威（输入/输出/禁止/下游影响），不重述矩阵正文。
> 与 A12 的区分：A7.x 是**生成/精修 09 验证文档**，A12 是**运行验证、做验收**——一个写文档，一个跑验证。

## 5. cmd 兜底指针策略

**不独立成文。** 命令已存在于 `README` / `git-guide` / `SOP` / 各 script 头部，独立写一份会三重重复。每个场景内嵌一行指针指向已有命令权威源，例如：

> A2 新建派生项目｜无 AI 时手动：见 `README` §5 分钟最小路径 + `git-guide` §2

## 6. 落地步骤（建议分阶段，逐段提交）

1. 写 `template-docs/scenario-guides.md`（角色 + 账户约定 + 路由入口 §4.2 + 矩阵 + 契约 + 23 场景条目 + 图表规范横切 + A7 子场景 + M1 + cmd 指针）。
2. 写 `ai/commands/scenario.md` + 更新 `commands/README`（含「场景优先」约定）。
3. 收敛 `README` / `beginner-guide` / `ai-cli-setup` 三处引导词为指针。
4. 图表规范：更新 `document-lifecycle-rules` / `ai/doc-standards` + `project-rules` 增图表偏好填项。
5. 更新 `template-sync.json` + `README` / `SOP` 入口。
6. `check-template.sh` / `check-template.ps1` 加断言（存在性 + 路由有效 + 防漂移 + 去账户化 + 图表规范可选断言）。
7. `VERSION` → `v1.22.0`，`CHANGELOG` 记录。
8. PR 评审 → 合并 → 归档本提案到 `_archive/proposals/`。

## 7. 版本与影响面

- **版本**：v1.21.3 → **v1.22.0**（新增编排层 + 收敛 + 图表规范，属 feature）。
- **新增文件**：`template-docs/scenario-guides.md`、`ai/commands/scenario.md`；A4 落地时可能新增 `docs/inputs/initial-brief.md` 输入模板（放 `_examples/` 供引用）。
- **修改文件**：`README.md`、`template-docs/beginner-guide.md`、`template-docs/ai-cli-setup.md`、`ai/commands/README.md`、`ai/document-lifecycle-rules.md`（图表规范）、`ai/doc-standards/*`（图表规范）、`ai/project-rules.md`（图表偏好填项）、`template-sync.json`、`SOP.md`、`CHANGELOG.md`、`VERSION`、`scripts/check-template.sh`、`scripts/check-template.ps1`。
- **下行同步**：派生项目同步后获得 `scenario-guides.md`、`/run scenario` 与图表规范。

## 8. 验证方式

- `check-template.sh` / `check-template.ps1` 通过（含新增断言）。
- 手动验证：对 AI 说「我想新建一个派生项目」/「我只有仓库链接」/「帮我准备输入材料」/「帮我规划 Demo/MVP 阶段」/「帮我打磨 02-srs」，AI 按 `scenario-guides.md` 产出符合契约的引导计划。
- grep 确认三处引导词不再逐字重复、模板内无硬编码具体账户。
- 抽查设计文档（04/05/06/07）含规定图表且格式一致（默认 mermaid）。
- 派生项目同步 dry-run 确认 `scenario-guides.md` 进入同步清单且不覆盖项目专属文件。

## 9. 风险与待确认

- **场景颗粒度**：23 个是否过多；落地后按使用反馈裁剪或合并（如 A4–A8 输入与文档场景、A9 阶段规划与 A8 审计的边界）。
- **契约稳定性**：AI 实际产出是否稳定符合契约格式，需在 M1 元场景里强约束并举例。
- **路由入口准确性**：§4.2 的 cwd 三分支判据需在 M1 里给出可操作识别信号（如检查 `template-sync.json` + `_proposals/` 同时存在区分模板仓库 vs 派生项目），避免误判。
- **A9 阶段规划**：依赖 `global-rules §8` 阶段双维度，AI 需准确理解 Demo/MVP/产品 × P1/P2/愿景，避免把愿景功能塞进 P1 Demo（与 `document-lifecycle-rules §12` 禁止项一致）。
- **A4 输入模板**：`docs/inputs/initial-brief.md` 最小模板需落地时设计字段，避免过度结构化劝退新用户。
- **图表规范刚性**：mermaid/plantuml 渲染依赖环境（GitHub 原生支持 mermaid）；规范应「建议+默认」而非「强制」，留用户确认空间。
- **cmd 指针失效**：`README`/`git-guide` 改版可能令指针失效，纳入 `check-template` 断言或定期人工核对。
- **◐ manual 场景**（A4/A9/C2/C5/C7）：剧本引导走文档路径，体验弱于有专门 command 的场景；后续可按需补 command。
- **去账户化**：需排查现有文档/样例是否残留具体账户，`check-template` 加 grep 断言。
- **后续可选**：SessionStart hook 自动环境检查（跨 AI 工具不一致，单列不强推）。
