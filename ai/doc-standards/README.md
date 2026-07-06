# Document Standards（文档规范镜像）

> Sync notice: This file is maintained by `ai-project-template` and may be overwritten when a derived project syncs template methodology.
> Do not edit it directly in derived projects; propose reusable changes in `_proposals/` and upstream them to the template repository.

本目录用于保存模板 `docs/00-09` 撰写规范在派生项目中的只读镜像。

## 定位

- `ai/doc-standards/00-09` 是 AI 使用的文档标准 / 审计基线，不是项目事实文档。
- 派生项目自己的需求、设计、计划和验证事实仍写在 `docs/00-09`。
- 本目录由 `scripts/sync-template.*` 下行同步刷新；派生项目不应手工修改镜像文件。
- AI 做文档体系审计、生成回梳或章节完整性检查时，可将本目录作为规范对照。

## 待人工确认项基线

`docs/00-09` 和 `docs/design/*` 的“待人工确认项”应采用结构化表格，而不是纯问题列表。最低字段为：`ID`、`待确认项`、`AI 建议`、`建议依据`、`备选方案`、`取舍影响 / 阻塞关系`。AI 建议只用于辅助判断，用户确认前不得写成已确认事实；确认后应回填到权威文档或续接文件。

## 00-03 需求链基线

`00-03` 是需求链权威入口。同步后派生项目会得到 `ai/doc-standards/00-scenario.md`、`01-user-requirements.md`、`02-srs.md`、`03-prd.md` 四份镜像标准；这些文件来自模板 `docs/00-03`，用于审计和补齐，不替代派生项目自己的事实文档。

最低追溯链为：`SC-ID → U-ID → REQ-ID → Phase → AC / TC`。

- `00` 必须保留场景、边界、非目标、来源锚点和下游影响。
- `01` 必须保留用户操作流、用户可观察验收口径、优先级依据和 `U-ID → REQ-ID` 映射。
- `02` 必须保留功能需求、NFR、约束 / 假设、异常场景和验证入口。
- `03` 必须保留 Phase 功能范围、交付物形态、进入 / 退出标准、状态、证据 / 验收引用和非目标追溯。

需求链健康度矩阵默认由 `docs-evaluation` / `docs-system-audit` 输出，不强制每个项目写入正式 `03` 或 `09`；若项目选择落盘，应放入 `docs/research/*docs-evaluation*.md` 或审计报告。

## 前端交互设计基线

UI 型项目的前端交互设计属于条件性 `docs/design/*` 详细设计，推荐路径为 `docs/design/frontend-interaction.md`。其职责是承接 `03/04/05/07/08/09`，细化页面信息架构、路由清单、核心用户流、组件职责、状态 / 空态 / 错误态、表单校验、文案、接口依赖、响应式与可访问性、验收路径和阶段增量。该文档不得新增未授权需求、接口或验收目标；前端隐藏入口、按钮禁用或路由守卫只能作为可见性控制，不能替代后端接口和服务层权限边界。

## 与旧路径的关系

旧路径 `docs/_scaffold/00-09` 是 v1.18.x 的规范镜像位置。迁移期内，审计提示词和边界检查可兼容旧路径；长期主路径为 `ai/doc-standards/00-09`。
