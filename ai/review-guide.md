# Review Guide（评审机制总纲：触发矩阵 + 标准索引）

> Sync notice: This file is maintained by `ai-project-template` and may be overwritten when a derived project syncs template methodology.
> Do not edit it directly in derived projects; propose reusable changes in `_governance/_proposals/` and upstream them to the template repository.

**定位**：一页索引型评审总纲，回答「什么时候必须评审、用哪个命令、标准去哪查、结论落哪」。本文件只收拢指针，不复制规则正文；与被引用规则冲突时，以被引用规则为准。按用户说法选命令的分诊见 `ai/commands/README.md`；本文件按「阶段时点」驱动，两者互补。

**适用与裁剪**：Full / Standard 剖面默认全矩阵适用；Lean / Existing-system 剖面裁剪范围见 §6，剖面定义见 `ai/document-lifecycle-rules.md` §4。

## 1. 评审触发矩阵

「强制」指该时点必须完成对应评审动作并留结论（评估粒度可按剖面裁剪，见 §6）；「建议」指正常情况应执行，跳过时说明原因。

| 时点 | 触发条件 | 评审命令 | 评估粒度 | 结论落点 | 报告 / 记录落盘 |
|---|---|---|---|---|---|
| E1 输入 / 愿景 → 需求阶段 | 强制：生成 00-03 前 | `docs-evaluation`（19） | 阶段评估（E1） | Go / Conditional Go / No Go；No Go 不得生成 | `docs/research/YYYY-MM-DD-docs-evaluation-<scope>.md`（用户确认落盘后） |
| E2 需求阶段 → 总体设计 | 强制：生成 04-05 前 | `docs-evaluation`（19） | 阶段评估（E2） | 同上；No Go 不得进入 04-05 | 同上 |
| E3 总体设计 → 详细设计 | 强制：生成 06/07/`docs/design/*` 前 | `docs-evaluation`（19） | 阶段评估（E3） | 同上 | 同上 |
| E4 详细设计 → 实现计划 | 强制：生成 08 前 | `docs-evaluation`（19）+ 非平凡模块六问 | 阶段评估（E4）+ 模块可驱动性 | 同上；六问结论挂 Sprint 输入文档 | 同上 |
| E5 实现计划 → 验证 | 强制：进入验证前 | `docs-evaluation`（19） | 阶段评估（E5） | 同上 | 同上 |
| E6 实现结果 → 文档回写 | 强制：发现代码事实偏离文档时 | `sync-docs-from-code`（07）+ `docs-evaluation`（19 阶段归属审计维度） | 单文档 / 变更传播 | 实现偏差 / 设计缺口二分结论 + 回写落点 | `docs/design/*` 实现偏差区 / `docs/09-verification.md` |
| 真实运行依赖触达 | 强制：backend / 数据库 / 外部服务 / LLM / Docker 等真实依赖进入编码前 | `tech-env-evaluation`（20） | 技术路线与环境支撑 | Go / Conditional Go / No-Go → `05` Risk-ID / readiness gate | `docs/research/YYYY-MM-DD-tech-env-evaluation-<scope>.md` |
| 编码前 | 强制：每个 Sprint 开工前 | `docs-checklist`（10）+ `docs-open-items`（21） | 编码前就绪拦截 | 通过 / 未通过清单；阻塞 open item 未关闭不得编码 | 默认会话输出；需留痕时 `docs/research/` |
| Sprint 收口 | 强制：每个 Sprint 完成时 | `sprint-summary`（dev/09） | Sprint 验收 | Sprint 完成包；未通过项不得写成已完成 | `docs/09-verification.md` 验收记录 + `docs/08-dev-plan.md` 进度 |
| Phase 收口 / 升级 | 强制：Phase 升级评估前 | `phase-upgrade`（planning/08）+ `docs-evaluation`（19） | Phase 完成度 + 下一阶段解锁 | Phase 验收记录；升级结论须人工确认 | `docs/09-verification.md` Phase 验收 + `docs/research/`（评估留痕） |
| 同步后 | 强制：每次 `sync-template` 收尾 | `post-sync-cleanup`（maintainers/15）；差异显著时 `docs-system-audit`（16 同步后审计模式） | 同步差异 + 全链回梳 | 同步运行记录完成度 + 回梳建议 | `_governance/sync-records/template-sync/` 运行记录 |
| 收尾梳理 | 建议：Sprint / Phase 收口或连续多轮文档修改后 | `docs-health-review`（24） | 文档体系健康度 | 整理清单（保留可追溯底线） | 会话输出；整理动作遵守 `ai/global-rules.md` §8.4 |

评估码 E1-E6 的阶段转换语义、阶段最小产物与出口对照、产物级对账断点，见 `ai/document-lifecycle-rules.md` §2 / §2.1 / §2.2，本表不复制。

## 2. 评审标准索引

| 评审维度 | 权威源（以该处为准） |
|---|---|
| 追溯链与需求链健康度 | `ai/document-lifecycle-rules.md` §6 / §6.0.1 |
| 横切状态词典 | `ai/document-lifecycle-rules.md` §7.1 |
| 待人工确认结构 / open items 门禁 | `ai/document-lifecycle-rules.md` §6.1 / §6.2 |
| 变更传播 | `ai/document-lifecycle-rules.md` §9 |
| 图表审核四维度 + 图表体系评审清单 | `ai/document-lifecycle-rules.md` §13 |
| 文档专属维度（字段 / 矩阵 / 审计项 / 禁止项） | `ai/doc-standards/<doc>.md`（00-09、design-doc、frontend-interaction、ui-prototype-strategy、project-rules） |
| 阶段交付物档位判据 | `ai/doc-standards/stage-exit-baseline.md` |
| 模块可驱动性（六问）/ 验证分层 / 验收留痕 | `ai/implementation-lifecycle-rules.md` §5.1 / §6 / §7 |
| 实现合规审查维度 | `ai/prompts/review/03-project-review.md`（维度源：`ai/global-rules.md` §4） |
| 领域专属规则（领域路线） | `ai/doc-standards/domain-rules.md` 规范基线 + 领域仓自持 `ai/domain-rules.md` 种子实例 |

## 3. 结论分级与关闭规则

- `Go / Conditional Go / No Go` 语义、状态对结论的影响与 open items 门禁：以 `ai/document-lifecycle-rules.md` §2 / §6.2 和 `ai/prompts/review/19-docs-evaluation.md` 为准，不在此复制。
- Conditional Go 必须列前置条件、补做时点和验证入口；无前置条件的「有保留通过」不得写成 Conditional Go。
- 阻塞项未关闭、未转任务、未回填权威文档且未被明确风险接受时，不得进入对应阶段 / Sprint，不得判 Go。
- 评审发现问题按 P0（阻塞）/ P1（阶段或 Sprint 前处理）/ P2（可延后，给回看时点）分级。

## 4. 评审独立性约定

| 形式 | 适用场景 | 边界 |
|---|---|---|
| AI 自查 | 文档生成 / 修改后即时执行 | 生成 prompt 内置自检 + `docs-checklist` 自查；自查通过不等于评审通过 |
| 交叉评审 | 关键阶段转换评估、全链路审计、修复回归 | 由不同会话或不同命令复核（如生成用 `generate-docs`、评估用 `docs-evaluation` / `docs-system-audit`）；评估执行与被评产物的生成分离 |
| 人工确认 | 待确认项关闭、Phase 升级、高风险 / 合规 / 成本 / 权限事项 | AI 建议不得写成已确认事实（`ai/global-rules.md` §5、`ai/document-lifecycle-rules.md` §6.1）；确认后回填权威文档 |

## 5. 与其他机制的关系

- **评审意图分诊（说法驱动选命令）**：互补——分诊解决「用户说法 → 选哪个命令」，本文件解决「阶段时点 → 必须 / 建议评审什么、结论落哪」。对应提案尚在派生侧试点、未回流；正式回流前不引用其文件名，回流后在本节补引（先例：路由粒度分层 v1.73.0 的分层路由见 `ai/commands/README.md`）。
- **图表体系评审清单**：`ai/document-lifecycle-rules.md` §13——按文档类型的应含图表索引 + OO 可选产物「选用即评审」条目；三份评审命令（10 / 16 / 19）已挂条件检查项。
- **engineering-diagram-review（v1.57.1，已归档）**：图表四维度与 doc-standards 04/06/07 关键图字段由该提案落地；本文件只收拢入口，不重复定义。
- **E1-E6 与阶段出口对照**：`ai/document-lifecycle-rules.md` §2 / §2.1 定义评估动作与对照物；本文件只补「时点 × 触发条件 × 命令」索引。

## 6. 剖面裁剪

- **Full / Standard**：§1 全矩阵默认适用。
- **Lean**：可裁剪至最低链——E1、E5、真实运行依赖触达、编码前、Sprint 收口 + open items 门禁；裁剪在 `ai/project-rules.md` §3 声明。
- **Existing-system**：E1-E3 通常由现状盘点（`docs-system-audit`）替代，以受影响文档评审 + E4-E6 为主。
