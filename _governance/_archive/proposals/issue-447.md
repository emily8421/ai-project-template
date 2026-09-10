# GitHub Issue #447: TEMPLATE-UPGRADE：UI 设计知识回流入口与配方类记录（REC-*）

> Source URL: https://github.com/emily8421/ai-project-template/issues/447
> State: OPEN
> Labels: proposal, from:zhiyan-digital-cs-platform
> Author: emily8421
> Created: 2026-09-09T08:58:34Z
> Updated: 2026-09-10T02:55:53Z
> Mirrored at: 2026-09-10
> Mirror status: raw remote issue copy for local triage; GitHub issue remains source of comments and closure state.

## Raw Issue Body

# TEMPLATE-UPGRADE：UI 设计知识回流入口与配方类记录（REC-*）

> 来源：zhiyan-digital-cs-platform（emily8421/zhiyan-digital-cs-platform）派生项目回流
> 状态：实践案例已补全（2026-09-09），待项目用户确认后按 submit-proposal 流程提交模板仓
> 起草日期：2026-09-09
> 建议版本：minor
> 提交方式：跨仓开 issue（`ai/commands/submit-proposal.md` 流程），不直接改模板仓文件

## 1. 动机（去项目化）

v1.62.0 的 `template-docs/ui-knowledge/` 核心层解决了「派生项目从哪里查设计依据」，Batch 2A（v1.62.1）补了来源核验与结构校验。但在一个数字客服类派生项目（双端 H5 + 运营台）的界面重设计实践中，仍暴露出两个缺口：

1. **回流没有入口。**核心层定义了记录模型、选择流程和 core 晋升条件（「跨 ≥2 项目验证」，README §9），但没有说明项目侧的验证结果和设计观察往哪里交、按什么格式入库。这类内容目前只存在于个别项目族群自建的收集层仓库（其 README 与收集 SOP），核心层没有提及。只随同步读到核心层的项目，既不知道收集层是否存在，也不知道 core 晋升所需的「项目实证」该由谁、以什么方式提交——晋升条件因此难以落地。
2. **缺选型与配方类记录。**组件库 / 设计系统选型是每个 UI 项目都要做的比选，结论高度收敛（如 React 中后台大多落在 Ant Design 一类体系），但现有四类记录（Source / Principle / Pattern / Case）没有位置承载「某类产品在选型和组合上的推荐结论」。每个新项目从零比选，结论无法继承；先做比选的项目，结论也只能留在项目自己的参考分析里，其他项目查不到。

## 2. 拟改

### 2.1 变更集 A：核心层补「两仓分工与项目回流」章节

改 `template-docs/ui-knowledge/README.md`：

1. 登记两层分工：母模板核心层（字段规范与推荐核心，随同步到达各派生项目）与项目族群自建的收集层仓库（承接全部收集量与候选池）。母模板只约定三件事：ID 与字段规范、回流内容与方式、上浮条件；收集层仓库建不建、建在哪里，由项目族群自行决定。
2. 新增「项目回流」小节，写明三件事：
   - 回流内容：项目设计实践中产生的观察——选型比选、令牌配置、模式实证、问题与规避——写成 Case（或 Pattern 候选）交收集层仓库，按其收集 SOP 入库；
   - 回流边界：项目设计稿与品牌资产不入库；采纳 / 排除决定仍写在项目自己的参考分析，不回写知识记录；
   - 上浮通道：候选记录在 ≥2 个项目实证后，由项目按 `ai/global-rules.md` §9 既有通道起草 TEMPLATE-UPGRADE 提案升入核心层。此为 §9 core 条件的操作说明，不改变晋升标准本身。
3. 在 `ai/commands/ui-prototype-exploration.md`（执行流程第 2 步附近）与 `ai/document-lifecycle-rules.md` §5.2.1 末尾各加一行指针，指向上述回流小节；只加指针，不展开正文。

### 2.2 变更集 B：知识模型新增第五类记录 Recipe（配方）

改 `template-docs/ui-knowledge/README.md` §2 与 §4：

1. §2.1 表加一行：

| 记录类型 | ID 前缀 | 用途 | 能否直接作为项目决定 |
|---|---|---|---|
| Recipe（配方） | `REC-*` | 按产品类型组织的选型结论与推荐组合（组件库、令牌配置、布局范式、关键页骨架、反模式清单） | 作为比选起点，不替代项目自身核对 |

2. §4 新增字段规范（最小集，与 §4.2 同口径）：

| 字段 | 说明 |
|---|---|
| REC-ID | 稳定编号，按产品类型分段，如 `REC-CS-001`（客服类） |
| 适用范围 | 产品类型、端（双端 / 单端）、阶段（Demo / MVP / 产品） |
| 推荐内容 | 选型对比矩阵与推荐组合；每项挂 `SRC-*` / `PAT-*` / `CASE-*` 证据 ID |
| 适用 / 不适用条件 | 同 Pattern 字段口径 |
| 证据等级 | A / B / C / D；整体等级不超过所引证据中的最高等级 |
| 状态 | candidate / reviewed / core / deprecated / retired（沿用既有生命周期，不另立） |
| 最后核验 | 日期 + 核验范围 |

3. 使用边界（随字段一并写明）：配方是有证据的推荐起点，不是标准答案；项目仍须在参考分析中做采纳 / 调整 / 排除；所引证据升级、降级或选型环境变化时，配方随之复评。
4. 收集层仓库同源增补：项目族群自建的收集层仓库需在其 README 与收集 SOP 中增补第五类记录的承接条目。该类仓库不在模板同步范围，本提案合并后由其自行跟进，模板侧不阻塞。

### 2.3 不做的事

- 不新增命令、不新增 `ai/*-rules.md` 必读文件；指引留在人读模板层，控制 AI 必读上下文（与 founding 提案 §9 立场一致）。
- 不新增 `check-template` 断言：`check_ui_knowledge_structure`（v1.62.1）暂不覆盖 REC-*；待配方条目积累后，按 Batch 2 的断言哲学单独评估「编号唯一 + 引用登记 + 稳定字段在场」的最小校验，不绑定长文案。
- 不改动既有四类记录的定义、字段与生命周期。

## 3. 建议版本

minor。核心层 README 是同步覆盖件，内容增补会随同步到达全部派生项目；配方是派生项目可见的知识模型扩展。若为配方单独立文件（如 `ui-knowledge/recipes.md`），同步清单增加一项，仍属 minor。无破坏性变更。

## 4. 影响面

| 对象 | 影响 |
|---|---|
| 派生项目 | 下次同步后核心层多一节回流指引；UI 任务可查配方，也有明确的回流去处。不使用知识层的项目不受影响 |
| 模板维护者 | triage 时多一类回流来源（项目实证记录）；core 晋升有了可操作的提交入口 |
| 收集层仓库 | 需同源增补第五类记录（见 2.2 第 4 点）；存量记录与 ID 不受影响 |
| 自检 | 本提案不新增断言（见 2.3）；既有断言不受影响 |

风险与控制：

- 配方被当作「免比选的答案」直接套用 → 使用边界写明「推荐起点、须核对适用条件」，项目参考分析仍要输出采纳 / 排除矩阵；
- 配方随证据或选型环境变化而过时 → 「最后核验」字段与既有生命周期降级机制承接，必要时标 deprecated / retired。

## 5. 验证方式

1. 结构：增补后核心层 README 的 ID 体系、字段规范与 §9 生命周期自洽——`REC-*` 可走完 candidate → core 全程，不需另立生命周期或新工具。
2. 流程：下一批派生项目 UI 任务按增补后指引完整走一遍「查配方 / 查模式 → 参考分析引用 ID → 设计 → 观察按收集 SOP 回流收集层」，回流链路有留痕可查（本提案 §7 即该流程的首个案例）。
3. 回归：`check-template` 既有断言全部通过；Markdown 清洁检查与同步 dry-run 正常。

## 6. 与既有规则的关系（去重）

| 既有能力 | 关系 |
|---|---|
| `TEMPLATE-UPGRADE-web-ui-design-knowledge-base`（已归档，v1.62.0） | 延伸不推翻：四类记录、字段、生命周期一律不动；本提案补第五类记录与回流入口 |
| `TEMPLATE-UPGRADE-web-ui-knowledge-quality-governance`（已归档，v1.62.1，Batch 2A） | 分工不同：Batch 2A 管来源核验与结构校验；本提案管项目回流入口与记录类型扩展，不碰自检断言 |
| `template-docs/ui-knowledge/README.md` §5 选择流程、§6 原型输入包契约 | 补全不重复：消费端已有，本提案补回流端 |
| `ai/document-lifecycle-rules.md` §5.2.1 与 UI-G 门禁 | 指针级引用，不新增阶段或门禁 |
| `ai/global-rules.md` §9 提案通道 | 沿用，不另建通道 |
| Batch 2 剩余（core 晋升节奏、证据升降级，见 Batch 2A §6） | 补前置：本提案让「项目实证」有提交入口，Batch 2 的评审节奏在其上运转 |
| 项目族群自建收集层仓库（如 web-ui-knowledge-base） | 只约定接口（ID / 字段 / 上浮条件），不收编、不纳入同步 |

起草时核对范围：模板仓 `_governance/_archive/proposals/` 全量清单与本仓收件箱，未发现同题提案。

## 7. 实践案例（已完成，2026-09-09）

首个完整案例：zhiyan（数字客服类，双端 H5 + 运营台）2026-09 界面重设计，五步全链路（brief → 补源 → 消费出稿 → 定稿 → 回填回流）走通。

1. **查询记录**：参考分析（`docs/research/2026-09-09-frontend-ui-reference-analysis-v2.md`）按客服双端 scope 命中核心层 12 条 Pattern（PAT-VIS-001~006、PAT-INT-001~003/004/006/007）+ 收集层 8 条 SRC / CASE，全部进入采纳 / 排除矩阵。查库过程无阻断；UI-G-002 一次通过。
2. **选型结论（配方层必要性的直接论据）**：Console 选 Ant Design 5，主题种子 `borderRadius: 2px` 适配直角风——该结论直接复用知识库 `CASE-antd-v5-tokens` 的令牌事实，比选只花一次会话；H5 端比选（Ant Design Mobile vs 轻量自绘 + 共享令牌）结论为后者，理由是单页对话场景组件收益低。这两个结论正是「分类推荐配方」应承载的形态：下个同类项目若无配方层，需从零重做全部比选。
3. **回流记录**：实践过程按收集 SOP 分两批入库 5 篇 CASE（`CASE-meiqia-cs-workbench` / `CASE-intercom-cs-workbench` / `CASE-slack-messaging`，v0.2.0；`CASE-linear-workbench` / `CASE-vercel-dashboard`，v0.2.1，由定稿候选 D 触发的参照补源），全部 candidate 待评审；另产出 C 级候选模式提名一项（「中性底盘 + 单强调色」，5 案支持）。入库成本可控，无卡点。
4. **指引缺口（与提案修订项一一对应）**：实践前核心层无回流指引——变更集 A 的直接动机；选型结论无处沉淀——变更集 B 的直接动机。实践后项目侧闭环：定稿承载写入 `docs/design/frontend-interaction.md` §16。

结论：机制全链路可跑通，支持两个变更集；建议按 minor 落地（§3）。若维护者对配方层字段有异议，§2.2 的字段表为最小集，可在评审中增删。
