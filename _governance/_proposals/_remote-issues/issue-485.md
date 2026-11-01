# GitHub Issue #485: TEMPLATE-UPGRADE-v1.76.0：评审机制总纲（触发矩阵）+ 图表体系评审清单

> Source URL: https://github.com/emily8421/ai-project-template/issues/485
> State: OPEN
> Labels: proposal, from:gmbl_project
> Author: emily8421
> Created: 2026-10-29T09:13:46Z
> Updated: 2026-10-29T11:34:13Z
> Mirrored at: 2026-10-29（第二次刷新：维护者 triage 校正 3 处被 gmbl 侧采纳，正文经 `gh issue edit --body-file` 刷新）
> Mirror status: raw remote issue copy for local triage; GitHub issue remains source of comments and closure state.

## Raw Issue Body

# TEMPLATE-UPGRADE-v1.76.0 评审机制总纲（触发矩阵）+ 图表体系评审清单

> 来源：gsc 网络赌博主体关联研究系统（emily8421/gmbl_project）派生项目回流

## 1. 动机

派生项目完成首轮全链文档审计与 Phase1 收口评估后，确认两个可通用于多项目的模板缺口（均为「规则存在、触发与收拢不力」型，非机制缺失）：

1. **评审机制缺总纲：什么时候必须评审、用哪个命令、标准去哪查，散落无索引。** 模板的评审资产其实不少——E1~E6 评估码（lifecycle §2）、四个评审命令 + tech-env-evaluation、各 doc-standards 审计基线——但没有一张「阶段 × 时点 × 命令 × 粒度 × 强制/建议 × 结论落点」总表，也没有评审标准的单一入口（公共维度散在 lifecycle 多章节，专属维度在 doc-standards，评审者需自行拼装）。派生实证：规则定义了 E1~E6，但没有任何强触发点，派生项目 E2~E5 阶段评估断档约三周无人执行，直到收口时补跑。

2. **图表体系评审覆盖不全：OO 产物「选用即失管」，图表维度分散。** lifecycle §2.1/§2.2 将 OO 产物（事物-事件表、用例本体表、用例图、分析类图、数据词典）定义为可选增强并给出产物级转换映射，但一旦选用，按什么标准审没有着落（§2.2 只给对账断点登记，无审核条目）；§13 图表审核四维度散落在 04/06/07 各 doc-standards，00-03 层图表与 design 层图表无统一 checklist。派生实证：首轮审计发现图表覆盖不足（应含图表的文档多数 0 图 / 不可渲染图）且无评审维度兜底——「建议 + 默认」在生成与评审两端都没接住。

## 1.1 与既有规则的关系（去重）

- 与评审意图分诊类提案（说法驱动选命令）：**对象不同、互补**。分诊解决「用户说法 → 选哪个命令」（说法驱动）；本提案解决「阶段时点 → 必须/建议评审什么、结论落哪」（时点驱动）。该姊妹提案尚在派生侧试点、未回流（回流触发：真实评审 ≥2 轮无返工），正式回流前不以文件名引用，避免悬空引用；既有先例见 #441（路由粒度分层，v1.73.0）。
- 与已归档提案 engineering-diagram-review（v1.57.1）：**互补不重复**。该提案已落地图表四维度与 doc-standards 04/06/07 检查项；本提案「收拢入口、不改本体」——四维度定义指向既有落地，只做按文档类型的收拢索引 + OO overlay 审核条目。
- 与 lifecycle §2（E1~E6）：**指向，不重定义**。触发矩阵引用既有评估码与结论语义，不复制。
- 与 lifecycle §13（图表规范）：**收拢入口，不改本体**。四维度保持原文，新增的「图表体系评审清单」小节做按文档类型的收拢索引 + OO overlay 补充；生成式镜像机制不动。
- 与 lifecycle §2.2（产物级转换映射）：**互补**。对账断点管「对账登记」，本提案补「审核条目」。
- 与 doc-standards 04/06/07（关键图字段）：**指向**。文档专属维度留在 doc-standards，总纲/清单只索引，防双写漂移。
- 与审计回流主题 a / d / e / f：a（生成时点评估触发弱）由触发矩阵直接落地；d（确认疲劳）复用 lifecycle §6.2 open items 门禁，不另造机制；e（评估独立性）由总纲「独立性口径」段收拢；f（CI 样板）**不在本提案范围**（图表 CI `--check` 校验留作后续独立提案）。

## 2. 拟改

### 2.1 新增 `ai/review-guide.md`（评审总纲，一页索引型）

- **评审触发矩阵**：行 = PLM 阶段转换（E1~E6）+ 关键时点（编码前 / Sprint 收口 / Phase 收口 / 同步后 / 收尾梳理），列 = 触发条件（强制/建议）、命令、评估粒度、结论落点、报告落盘路径（`docs/research/YYYY-MM-DD-*-<scope>.md`）。
- **评审标准索引**：公共维度 → lifecycle 既有章节指针（§6 追溯链、§7.1 状态词典、§6.1/6.2 待确认结构、§9 变更传播）；文档专属维度 → `ai/doc-standards/<doc>.md`。
- **结论分级与关闭规则**：Go / Conditional Go / No Go 语义引用 lifecycle §2；open items 门禁引用 §6.2。
- **评审独立性口径**：AI 自查（文档生成后自检）/ 交叉评审（不同会话 / 不同命令复核）/ 人工确认（待确认项、Phase 升级）各管什么。
- 文件为纯索引型，禁止复制规则正文（防双写漂移）；新增文件需登记 `template-sync.json` 同步清单。

### 2.2 阶段转换轻挂钩

在 `ai/prompts/docs/00-generate-or-complete-docs.md`、`ai/prompts/dev/02-run-task.md`、`ai/prompts/planning/08-phase-upgrade.md` 的执行流程各加一行：「阶段转换前 → 按 `ai/review-guide.md` 触发矩阵确认本轮评审义务与结论落点」。不加新 Gate、不引入自检断言。

### 2.3 lifecycle §13 增「图表体系评审清单」小节

- 按文档类型收拢「应含图表 + 四维度审核条目」索引表（正文指向既有四维度定义，不复制）。
- **OO overlay「选用即评审」规则**：可选产物一旦选用，审核标准同正式产物；并给出各产物 3~5 条最小审核条目——事物-事件表（场景覆盖 / 事物事件识别依据 / 与 U-ID 对应）、用例本体表 + 用例图（actor 与 SC 对应 / include-extend 语义 / plantuml 可渲染）、分析类图 / 领域模型（实体关联有场景事件依据 / 与概念模型一致）、数据词典（字段说明齐 / 与 06 目标结构一致）。
- 与 §2.2 对账断点互相引用（断点登记 ↔ 审核条目）。

### 2.4 评审命令接图表维度

`ai/prompts/review/10-docs-checklist.md`、`16-docs-system-audit.md`、`19-docs-evaluation.md` 各加一条条件检查项：按 §13 图表体系评审清单核对（项目声明裁剪的除外）。

## 3. 版本影响

- 目标模板版本：v1.76.0（在 v1.75.4 基础上新增）。
- 拟改文件：新增 `ai/review-guide.md`（+ `template-sync.json` 登记）；改 `ai/document-lifecycle-rules.md` §13（增小节）、`ai/prompts/docs/00-generate-or-complete-docs.md`、`ai/prompts/dev/02-run-task.md`、`ai/prompts/planning/08-phase-upgrade.md`（各加一行挂钩）、`ai/prompts/review/10 / 16 / 19`（各加一条条件检查项）。
- 不新增命令、不改命令文件结构、不引入 CI 断言。

## 4. 影响面

- 评审从「知道有这些命令」变为「到点即知该评什么、用什么评、结论落哪」——阶段转换评估的触发从自觉变矩阵兜底（直接消 a 主题实证的断档模式）。
- OO 产物从「选用即失管」变为「选用即有审核条目」；图表评审维度三命令统一。
- 总纲为索引型，规则正文零复制，维护成本接近零；无 CI 依赖，Lean 项目可裁剪（总纲标注剖面裁剪口径）。

## 5. 验证方式

- 派生项目内试点：下一 Phase 启动时按触发矩阵走（阶段转换 → 查矩阵 → 执行评审 → 结论落盘），记录矩阵命中是否准确、是否遗漏；OO overlay 试点待下一轮需求链产物选用时验证审核条目可用性。
- 模板仓回归：`scripts/check-template.sh` 自检通过；`review-guide.md` 无悬空引用（指向的章节 / 命令全部存在）；`template-sync.json` 含新文件。

## 6. 附：实证依据

派生项目首轮全链审计（合规审计报告，2026-10-28）与 Phase1 收口评估（2026-10-29）：E2~E5 评估断档三周（触发缺失实证）、图表覆盖不足无评审兜底（G6）、状态回写双漏网（04/05/07 连续漏——总纲把「回写核对」纳入触发矩阵收口时点可一并兜住）。相关观察已登记派生 pitfall / hotspot 本地记录，达到「重复出现 2 次以上再回流」的稳定门槛。

## Comments（本地镜像副本；GitHub 为评论权威源）

### emily8421（OWNER，2026-10-29T11:34:13Z）

感谢复核，gmbl 侧确认与处置如下：

**校正 1（引用失真）—— 确认：该提案从未回流。** `TEMPLATE-UPGRADE-v1.75.0-review-intent-triage-and-glossary-check` 目前仅在派生仓 `_governance/_proposals/` 本地试点（回流触发：真实评审 ≥2 轮无返工；第 1 轮已约定挂 Phase2 启动评估）。在模板仓可见范围内该引用属悬空引用，#478 同型问题成立。处置：按维护者建议，去重条目已删除文件名引用、改写为描述性互补说明并改引 #441（路由粒度分层，v1.73.0）；姊妹提案的互补关系待其正式回流后再补引。

**校正 2（版本 stale）—— 采纳。** 版本表述已改为「目标 v1.76.0（在 v1.75.4 基础上）」。

**补充去重 —— 采纳。** 去重章已补引已归档提案 engineering-diagram-review（v1.57.1）：该提案已落地图表四维度与 doc-standards 04/06/07 检查项；本提案「收拢入口、不改本体」与其互补——四维度定义指向既有落地，本提案只做按文档类型的收拢索引 + OO overlay 审核条目。

issue 正文已用修订后的本地提案稿刷新（`gh issue edit --body-file`），正文与最终内容一致，可直接据以实施。
