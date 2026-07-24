# TEMPLATE-UPGRADE：图纸审核准则（可审 / 可追溯 / 可验收）

> 来源：模板维护者（双 AI 综合评估 P1，见 `TEMPLATE-UPGRADE-2026-07-24-batch-overview.md`）
> 状态：候选（待评估 → 处理中）
> 目标版本：待确认（建议 patch）
> Release impact：patch（AI 建议，待维护者确认）—— 文档审计基线增强，不改默认行为、不要求派生项目迁移
> Release strategy：同主题聚合（可与 `readme-visual-navigation` 等文档补强 patch 同窗口发布）

## 1. 动机（WHY）

模板文档体系本身符合软件工程规范（`00-09` 对应 SE 六阶段，追溯链完整），但**图纸（架构图 / 流程图 / 时序图 / ER 图 / 状态图 / 部署图）审核偏柔性**，且存在权威要求与审计基线脱节的硬缺口。当前图纸只是「应含图表 + 默认 mermaid」的建议，不是「图可审、图可追溯、图能验收」的工程标准。

核心缺口：
- `§13` 要求 07 含时序图，但 07 审计基线无时序图字段/检查项 —— **审计无抓手**。
- 06 ER 图被写成「必要时补」，弱化 §13「应含」语气。
- 无独立图纸审核 checklist；图纸应作为**可追溯制品**挂到追溯链，而非装饰。

## 2. 现状证据（file:line）

| 现状 | 证据 |
|---|---|
| 图纸规范权威但柔性（建议 + 默认，非强制） | `ai/document-lifecycle-rules.md:530-546`（§13） |
| 图表格式偏好（mermaid 默认 / plantuml 可覆盖） | `ai/project-rules.md:62-66`（§2.6） |
| doc-standards 是审计基线 | `ai/doc-standards/README.md:8-14`、`docs/README.md:44` |
| 04 架构视图检查表（五视图，较强） | `ai/doc-standards/04-architecture.md:32-41` |
| **07 无时序图字段（最大缺口）** | `ai/doc-standards/07-api-spec.md:17-33`（通篇契约矩阵，无 sequence） |
| 06 ER 图条件化，与 §13 不一致 | `ai/doc-standards/06-db-design.md:23`（「必要时补 ER 图」） |
| design-doc 流程/状态机用表格非图 | `ai/doc-standards/design-doc.md:91-111`（Flow-D-001 表格 + 状态表） |
| scaffold 04 用 ASCII 占位，无 mermaid 块 | `template-docs/docs-scaffold/04-architecture.md` |

## 3. 拟改（WHAT）

### 3.1 图纸审核四维度（核心）

把图纸从「有没有」升级为「可审 / 可追溯 / 可验收」，新增四维度审核准则：

1. **可渲染**：图用 mermaid（默认）或 project-rules §2.6 指定格式，能在 CI / 文档预览中渲染（不破）。
2. **有 ID**：关键图带图编号（如 `DIAG-ARCH-01` / `DIAG-API-SEQ-01` / `DIAG-DB-ER-01`），可在评审 / 验收中被指名引用。
3. **可追溯**：图挂到现有追溯链（`U-ID→REQ-ID→Phase→设计→Sprint→TC→code`，`document-lifecycle-rules §6`）——架构图追溯 REQ / 模块，时序图追溯 API-ID / 关键流程，ER 图追溯表 / REQ，状态图追溯子系统 / TC。
4. **覆盖关键路径**：架构图覆盖异常 / 降级 / 权限边界；时序图覆盖关键业务流程与错误分支；ER 图覆盖核心实体关系；不只是一张「正常路径」图。

### 3.2 补齐审计基线具体缺口

- **07-api-spec**：补「关键接口时序图」字段与检查项（覆盖范围：跨模块关键流程、有并发/异步/权限的接口；不要求每个 CRUD 都画）。
- **06-db-design**：把 ER 图从「必要时补」对齐 §13「应含」语气，明确核心实体关系必须有 ER 图。
- **04-architecture**：保留并强化五视图检查表，scaffold 补 mermaid 代码块示例（替代纯 ASCII 占位）。
- **design-doc**：流程 / 状态机鼓励用 mermaid（`flowchart` / `stateDiagram`）表达，表格作为补充而非替代。

### 3.3 图纸审核载体（待确认二选一）

- **方案 A**：新增独立 `ai/doc-standards/diagram-checklist.md` 作为图纸审核子基线。
- **方案 B**：在现有 `ai/commands/docs-system-audit.md` / `docs-checklist.md` 增加「图纸维度」检查段，不新增文件。

### 3.4 与 §13 的关系

`§13` 保持「建议 + 默认」性质不变（不强求每类文档凑齐所有图），但**审计基线（doc-standards）层面**对 04/06/07 的关键图从「应含」落实为「有字段 / 有检查项 / 可追溯」。两者不冲突：§13 定方向，doc-standards 定可审抓手。

## 4. 版本影响

**patch**。理由（对照 `CONTRIBUTING.md §4`）：文档审计基线 / 自检增强、补充说明，不改默认行为、不要求派生项目迁移、不改同步清单结构。即使新增 `diagram-checklist.md` 也是可选审计材料，属 patch 定义内的「额外自检和补充说明」。

## 5. 影响面（拟改文件）

| 文件 | 改动 |
|---|---|
| `ai/doc-standards/07-api-spec.md` | 补时序图字段 + 检查项 |
| `ai/doc-standards/06-db-design.md` | ER 图对齐 §13「应含」 |
| `ai/doc-standards/04-architecture.md` | 五视图检查表强化（含追溯维度） |
| `ai/doc-standards/design-doc.md` | 流程/状态机鼓励 mermaid |
| （方案 A）`ai/doc-standards/diagram-checklist.md` | 新增图纸审核子基线 |
| `ai/commands/docs-system-audit.md`、`docs-checklist.md` | 加图纸审核维度（方案 B 或 A 的入口） |
| `template-docs/docs-scaffold/04-architecture.md` | mermaid 块示例 |
| `ai/document-lifecycle-rules.md §13` | 视情况补图 ID / 追溯说明（不改柔性性质） |

## 6. 待确认项

| ID | 待确认 | AI 建议 | 依据 |
|---|---|---|---|
| DR-1 | 图纸审核载体：独立 checklist vs 嵌入现有审计命令 | 方案 B（嵌入 docs-system-audit），减少文件数 | 命令不膨胀（CONTRIBUTING §7） |
| DR-2 | mermaid 是否强制块（scaffold） | 04 补 mermaid 示例块，但不强制所有图 | 兼容 plantuml 项目 |
| DR-3 | 07 时序图覆盖范围 | 关键跨模块流程 + 并发/异步/权限接口，非全量 | 避免过度负担 |
| DR-4 | 图 ID 命名方案 | `DIAG-<DOC>-<TYPE>-<NN>`（如 DIAG-API-SEQ-01） | 与 REQ/API/TC-ID 风格一致 |

## 7. 落地流程

1. 确认 §6 后，在维护分支改 doc-standards / 命令 / scaffold。
2. 运行 `scripts/check-template.sh`（含 doc-standards 存在性断言，确认不破）。
3. 用 `_examples/todo-api` 验证 07 时序图 / 06 ER 图字段可填。
4. PR 评审（重点：是否过度强制、是否保持 §13 柔性、追溯维度是否落地）。
5. 合并后 patch 版本递增 + CHANGELOG，下行同步。

## 8. 验证方式

- `scripts/check-template.sh` 通过。
- `_examples/todo-api` 的 07/06 补图后自洽且可追溯 REQ/API。
- 图纸审核维度在 docs-system-audit 可执行。

## 9. 关联

- 评估总览：`TEMPLATE-UPGRADE-2026-07-24-batch-overview.md`（提案 3）。
- 关联 P0 `system-skeleton-gate`：System Skeleton 验收可要求架构图 / 接口时序图作为框架验收证据，两提案在验收维度协同。
