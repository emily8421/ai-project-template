# Document Standards（文档规范镜像）

> Sync notice: This file is maintained by `ai-project-template` and may be overwritten when a derived project syncs template methodology.
> Do not edit it directly in derived projects; propose reusable changes in `_proposals/` and upstream them to the template repository.

本目录用于保存每份核心文档的细粒度规范标准，供 AI 生成、精修、审计和评估时作为只读规则依据。

## 定位

- `ai/doc-standards/00-09` 是 AI 使用的文档标准 / 审计基线，不是项目事实文档。
- 派生项目自己的需求、设计、计划和验证事实仍写在 `docs/00-09`。
- 本目录由 `scripts/sync-template.*` 下行同步刷新；派生项目不应手工修改镜像文件。
- AI 做文档体系审计、生成回梳或章节完整性检查时，可将本目录作为规范对照。


## 三层分工

| 层级 | 文件 | 职责 |
|---|---|---|
| 生命周期总控 | `ai/document-lifecycle-rules.md` | 阶段链路、输入输出职责、追溯、状态传播、变更传播、评估门禁 |
| 细粒度标准 | `ai/doc-standards/00-09.md`、未来 `ai/doc-standards/design-*.md` | 每份文档的章节、字段、ID、矩阵、状态、审计项、禁止项 |
| 大纲模板 | `docs/00-09.md` | 派生项目实际填写内容的大纲、占位表格、`【撰写提要：……】` |

路由规则：生成整个文档体系时读取 lifecycle + 已存在的全部 doc-standards；生成 / 审计需求阶段时读取 `ai/doc-standards/00-03`；精修单文档时读取对应 `ai/doc-standards/<doc>.md` 和上下游事实文档。

## 当前覆盖状态

| 范围 | 标准状态 | 后续计划 |
|---|---|---|
| `00-03` 需求阶段 | 已有独立细粒度标准 | 随需求链规则演进维护 |
| `04-05` 总体设计 | 已有独立细粒度标准 | 随风险验证和 readiness gate 演进维护 |
| `06-07` DB / API | 暂沿用兼容镜像 | Batch 4 补独立标准 |
| `08-09` 计划 / 验证 | 暂沿用兼容镜像 | Batch 5 补独立标准 |
| `docs/design/*` | 暂无统一独立标准 | Batch 6 补通用 design 标准 |
## 待人工确认项基线

`docs/00-09` 和 `docs/design/*` 的“待人工确认项”应采用结构化表格，而不是纯问题列表。最低字段为：`ID`、`待确认项`、`AI 建议`、`建议依据`、`备选方案`、`取舍影响 / 阻塞关系`。AI 建议只用于辅助判断，用户确认前不得写成已确认事实；确认后应回填到权威文档或续接文件。

## 00-03 需求链基线

`00-03` 是需求链权威入口。同步后派生项目会得到 `ai/doc-standards/00-scenario.md`、`01-user-requirements.md`、`02-srs.md`、`03-prd.md` 四份独立细粒度标准；这些文件用于生成、精修、审计和补齐，不替代派生项目自己的事实文档。

最低追溯链为：`SC-ID → U-ID → REQ-ID → Phase → AC / TC`。

- `00` 必须保留场景、边界、非目标、来源锚点和下游影响。
- `01` 必须保留用户操作流、用户可观察验收口径、优先级依据和 `U-ID → REQ-ID` 映射。
- `02` 必须保留功能需求、NFR、约束 / 假设、异常场景和验证入口。
- `03` 必须保留 Phase 功能范围、交付物形态、进入 / 退出标准、状态、证据 / 验收引用和非目标追溯。

需求链健康度矩阵默认由 `docs-evaluation` / `docs-system-audit` 输出，不强制每个项目写入正式 `03` 或 `09`；若项目选择落盘，应放入 `docs/research/*docs-evaluation*.md` 或审计报告。

## 前端交互设计基线

UI 型项目的前端交互设计属于条件性 `docs/design/*` 详细设计，推荐路径为 `docs/design/frontend-interaction.md`。其职责是承接 `03/04/05/07/08/09`，细化页面信息架构、路由清单、核心用户流、组件职责、状态 / 空态 / 错误态、表单校验、文案、接口依赖、响应式与可访问性、验收路径和阶段增量。该文档不得新增未授权需求、接口或验收目标；前端隐藏入口、按钮禁用或路由守卫只能作为可见性控制，不能替代后端接口和服务层权限边界。

## 04-05 总体设计基线

`04-05` 是从需求进入详细设计、计划和验证前的总体设计基线。同步后派生项目会得到 `ai/doc-standards/04-architecture.md`、`05-tech-spec.md` 两份独立细粒度标准；这些文件用于生成、精修、审计和补齐，不替代派生项目自己的事实文档。

最低追溯链为：`REQ / NFR → Phase → COMP-ID → MOD-ID → Flow-ID → Risk-ID → TC / Sprint`。

- `04` 必须保留架构约束、系统上下文、组件 / 模块 / Flow ID、部署拓扑、ADR 和 REQ / 功能追溯。
- `05` 必须保留技术状态、依赖配置、环境评估、安全隐私、技术风险矩阵和 readiness gate。
- 真实外部服务、数据库、LLM、Docker / 部署、重型 SDK 或权限安全能力进入 Sprint 前，必须有 `05` 风险验证或 readiness gate 结论。
- `候选`、`已验证`、`已启用`、`默认关闭`、`Mock`、`降级`、`禁止` 等状态必须绑定到依赖、风险、验证证据和启用阶段，不得混用。

## 与旧路径的关系

旧路径 `docs/_scaffold/00-09` 是 v1.18.x 的规范镜像位置。迁移期内，审计提示词和边界检查可兼容旧路径；长期主路径为 `ai/doc-standards/00-09`。
