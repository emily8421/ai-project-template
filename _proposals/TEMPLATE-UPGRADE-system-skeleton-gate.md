# TEMPLATE-UPGRADE：通用「可运行系统框架实现 + 验收」门禁（System Skeleton Gate）

> 来源：模板维护者（双 AI 综合评估 P0，见 `TEMPLATE-UPGRADE-2026-07-24-batch-overview.md`）
> 状态：候选（待评估 → 处理中）
> 目标版本：待确认（建议下一个 minor）
> Release impact：minor（AI 建议，待维护者确认）—— 新增一类能力层级（通用阶段门禁）+ 新的下游采用面 + 触及核心流程（阶段状态机 / 验收结构）
> Release strategy：单独发布（独立 PR，不与其他批次提案混改）

## 1. 动机（WHY）

软件工程标准做法：有了总体设计（系统架构、功能划分、接口规范、主业务流程）后，应**先实现并验证一套可运行系统框架（walking skeleton / executable architecture）**，通过框架验收后，再按模块划分逐个细化实现。验收路径也应分层：需求验收大纲 → 系统框架测试大纲 → 集成测试大纲 → 单元模块测试大纲。

模板当前**缺这两个通用环节**：

- 「先实现可运行骨架、再做模块细化」只对**复杂 Web/全栈项目**以条件性旁路 Profile 形式存在（Walking Skeleton Gate），**不是通用阶段**；CLI、纯后端 API、库、quick-script 等非 Web 项目默认从 Demo 最简路径直接堆功能。
- 验收是**扁平测试等级矩阵**，没有「系统框架测试大纲」这一独立层次。
- 存在**「骨架」命名碰撞**隐患，引入新概念前必须先消除。

派生项目实际实现过程也印证：Demo 倾向先走最简路径再逐步补模块，缺少「总体框架先行 + 框架验收」这一步，导致主文件膨胀、模块边界后补（关联 `web-fullstack-profile §5.1` 与本批次提案 5）。

## 2. 现状证据（file:line）

| 现状 | 证据 |
|---|---|
| Walking Skeleton 是条件性旁路 Profile | `template-docs/web-fullstack-profile.md:25-37`（WSG-001~006）、`:92-99`（§6 Sprint 0 用词「建议/可」） |
| 仅复杂 Web/全栈触发，非 Web 无骨架先行门禁 | `ai/global-rules.md:104`（触发条件）、`ai/implementation-lifecycle-rules.md:35-36`（仅 Web 项目 Sprint 0 要求） |
| 「骨架」命名碰撞：状态机「骨架」=设计文档占位，≠可运行骨架 | `ai/global-rules.md:156`（`骨架 → P{N}-已设计 → P{N}-已实现`）、`ai/document-lifecycle-rules.md:287`（骨架指设计要素占位） |
| 验收是扁平矩阵，非层次大纲 | `docs/09-verification.md:32-43`（测试等级矩阵）、`docs/09-verification.md:77-83`（§4.1 Phase 测试大纲，仅 Phase 维度）、`ai/implementation-lifecycle-rules.md:73-81`（§6 扁平分层列表） |
| 标准层已列 WSG smoke，但实例层不同步 | `ai/doc-standards/09-verification.md:22-27`（审计基线有 Walking Skeleton smoke）vs `docs/09-verification.md` 实例层与 `template-docs/docs-scaffold/09` 未同步 |
| 实现层级模型无独立「框架层」 | `ai/implementation-lifecycle-rules.md:20-28`（Phase→Sprint→Task→TC→Commit→Acceptance，无框架层） |

## 3. 拟改（WHAT）

### 3.1 新增通用 System Skeleton Gate（可运行系统框架实现 + 验收）

把「可运行系统框架先行」从 web-fullstack 旁路 Profile **提升为通用门禁**，适用所有 non-trivial 项目（不限 Web）：

- **定义**：System Skeleton = 基于总体设计（04 架构 / 功能划分 / 07 接口规范 / 主业务流程）实现的**最小可运行系统框架**——模块边界就位、关键接口连通、至少一条纵切可跑通、错误/空/加载入口存在；不含完整业务逻辑。
- **位置**：作为 Phase 内、首个业务模块 Sprint 前的独立环节（建议命名「Sprint 0 / Framework Sprint」通用化），输出可运行骨架 + 框架验收证据。
- **触发与豁免**：non-trivial 项目（多模块 / 有接口 / 有运行依赖）默认要求；quick-script、纯计算库、单文件工具等可豁免，须在 `ai/project-rules.md §3` 写明豁免理由（沿用现有豁免纪律）。
- **不依赖正式 scaffold**：设计为**规则 / 门禁层**（约束 docs 与实现顺序），不要求母模板生成代码脚手架——因 `web-app-scaffold` 仍为实验协议（`template-docs/web-app-scaffold-experiment.md`）。

### 3.2 消除「骨架」命名碰撞（前置必做）

引入「System Skeleton」前，先消除与状态机「骨架」的碰撞。**建议方案（待确认）**：

| 概念 | 现状用词 | 建议新词 |
|---|---|---|
| 设计文档要素占位（状态机第一态） | `骨架` | `设计骨架`（或 `outline`）—— 明确是文档占位 |
| 最小可运行系统框架（本提案新增） | （无） | `System Skeleton` / `可运行骨架` —— 明确是可运行代码 |

影响 `ai/global-rules.md §8.1`（状态机标签）、`ai/document-lifecycle-rules.md`（骨架占位说明）等所有用到「骨架」处。

### 3.3 验收路径层次化

`docs/09-verification.md` 从扁平测试等级矩阵 + Phase 测试大纲，扩出**层次化测试大纲**结构（与软件工程验收层次对齐）：

1. 需求验收大纲（REQ 级，已有 §2 追溯矩阵基础）
2. **系统框架测试大纲**（System Skeleton 验收 —— 新增层）
3. 集成测试大纲
4. 单元模块测试大纲

保留现有测试等级矩阵（单元/集成/系统/验收/回归/资源/Readiness）作为「等级维度」，与「大纲层次维度」正交，不删除既有内容（遵守 `global-rules §8.3` 只增不删）。

### 3.4 四层同步

落地时必须同步四层，避免再次出现标准层与实例层脱节：

1. **rules**：`ai/global-rules.md §8`（状态机命名 + 通用 Gate 触发）、`ai/implementation-lifecycle-rules.md`（§2 层级模型加框架层 / §3 阶段规划 / §6 测试分层补系统框架层）。
2. **doc-standards**（审计基线）：`ai/doc-standards/08-dev-plan.md`、`ai/doc-standards/09-verification.md`（System Skeleton 章节 + 层次大纲）。
3. **docs-scaffold**（结构模板）：`template-docs/docs-scaffold/08-dev-plan.md`、`template-docs/docs-scaffold/09-verification.md`。
4. **docs 实例**：`docs/08-dev-plan.md`、`docs/09-verification.md`（补 Sprint 0 / 框架验收章节 + 测试等级矩阵补 Walking Skeleton smoke 行）。

### 3.5 与 web-fullstack-profile 的关系

两条路径（待确认，见 §6）：
- **方案 A（合并）**：把 web-fullstack WSG-001~006 通用化为 System Skeleton Gate 的 Web 特化条款，web-fullstack-profile 改为引用通用 Gate + Web 特化。
- **方案 B（双轨）**：保留 web-fullstack-profile 现状，通用 Gate 作为更基础层，Web 项目两者叠加。

### 3.6 命令与场景对齐

- `ai/commands/docs-evaluation.md`、`ai/commands/docs-checklist.md`：评审项加「System Skeleton Gate 是否完成或豁免」「验收大纲是否分层」。
- `template-docs/scenario-guides.md` A27（WSG 状态确认）扩展为通用 System Skeleton 确认场景。

## 4. 版本影响

**minor**。理由（对照 `CONTRIBUTING.md §4`）：新增一类能力层级（通用阶段门禁）+ 新的下游采用面（所有 non-trivial 派生项目须识别并采用）+ 触及核心流程（阶段状态机命名 + 验收结构变化 + 推荐工作流可见变化）。不构成 major（不改 `00-09` 编号、不改同步协议、向后兼容——豁免机制保证旧项目可不变）。

## 5. 影响面（拟改文件）

| 文件 | 改动 |
|---|---|
| `ai/global-rules.md` | §8.1 状态机命名消碰撞；§8 / 行 104 通用 Gate 触发条件 |
| `ai/implementation-lifecycle-rules.md` | §2 层级模型加框架层；§3 阶段规划通用化 Sprint 0；§6 测试分层补系统框架层 |
| `ai/doc-standards/08-dev-plan.md` | Sprint 0 / Framework 章节基线 |
| `ai/doc-standards/09-verification.md` | System Skeleton 验收 + 层次化大纲基线（已部分有 WSG smoke，对齐扩展） |
| `template-docs/docs-scaffold/08-dev-plan.md` | Sprint 0 结构模板 |
| `template-docs/docs-scaffold/09-verification.md` | 层次大纲 + Walking Skeleton smoke 行 |
| `docs/08-dev-plan.md`、`docs/09-verification.md` | 实例层补章节与 smoke 行（与 scaffold 对齐） |
| `template-docs/web-fullstack-profile.md` | 按方案 A/B 调整与通用 Gate 的关系 |
| `ai/commands/docs-evaluation.md`、`docs-checklist.md` | 评审项 |
| `template-docs/scenario-guides.md` | A27 场景通用化 |
| `scripts/check-template.sh` | 视情况补自检断言（如 doc-standards 含 System Skeleton 关键字） |

## 6. 待确认项

| ID | 待确认 | AI 建议 | 依据 |
|---|---|---|---|
| SS-1 | 通用 Gate 的触发与豁免边界（哪些项目形态强制） | non-trivial（多模块/有接口/有运行依赖）默认要求；quick-script/纯计算库/单文件工具豁免 | 对齐 `project-rules §3` 形态裁剪 |
| SS-2 | 「骨架」重新命名的具体术语 | 状态机改「设计骨架」，新增「System Skeleton」 | 消除字面碰撞 |
| SS-3 | web-fullstack WSG 与通用 Gate 合并 vs 双轨 | 方案 A（合并，Web 特化条款），减少双轨维护成本 | 但 Web 项目有 App Shell 等特化点，需保留 |
| SS-4 | 验收层次大纲：新增章节 vs 重构现有矩阵 | 新增大纲层次维度，与现有等级矩阵正交，不删既有 | 遵守 `global-rules §8.3` 只增不删 |
| SS-5 | 是否同时改 `docs/` 实例层 | 是，四层同步，否则重蹈标准层/实例层脱节 | `doc-standards/09` vs `docs/09` 现状不同步 |

## 7. 落地流程

1. 本提案确认后，在 `chore/template-upgrade-proposals-2026-07` 或新切 `change/system-skeleton-gate` 分支实施。
2. 按 §3 顺序改文件（先消碰撞命名，再通用 Gate，再验收层次化，再四层同步）。
3. 运行 `scripts/check-template.sh` 自检；文档自洽复核（rules→doc-standards→scaffold→docs 一致）。
4. 用一个 `_examples/`（如 `todo-api`）验证 System Skeleton 章节可落地。
5. PR 评审（重点：是否消碰撞、是否四层同步、是否保持豁免兼容）。
6. 合并后递增 `VERSION` minor + `CHANGELOG.md`，下行同步各 active 派生项目。

## 8. 验证方式

- `scripts/check-template.sh` 通过。
- 四层文件命名与结构一致（人工 + 自检断言）。
- `_examples/todo-api` 补 System Skeleton 章节后自洽。
- 至少一个派生项目试同步验证下游可采用、豁免路径可走。

## 9. 关联

- 评估总览：`TEMPLATE-UPGRADE-2026-07-24-batch-overview.md`（提案 6）。
- 关联提案 5（主文件膨胀）：System Skeleton 先行可从源头减少主文件膨胀；§5.1 已存在职责边界，本提案补「框架先行」的上游环节。
- 关联提案 3（图纸审核）：System Skeleton 验收可要求架构图 / 接口时序图作为框架验收证据，两提案可在验收维度协同。
