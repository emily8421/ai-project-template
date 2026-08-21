# TEMPLATE-UPGRADE: 实现生命周期与验证规则

> 来源：模板维护者。
> 类型：模板仓库内直接发起的模板优化提案。
> 状态：第二步落地中；v1.27.0 已新增实现生命周期核心规则，当前分支继续增强 docs/08、docs/09 与 A9 规划 prompt，Scenario Guide / dev prompt / beginner guide 增强留待后续 PR。
> 覆盖问题：A9-A12 阶段 / Sprint / 实现链路；beginner guide 中“实现代码”规则缺口。

## 0. 落地状态（2026-07-04）

当前分支 `change/implementation-lifecycle-rules` 已按第一 PR 范围落地：

- 新增 `ai/implementation-lifecycle-rules.md`。
- `ai/index.md` 加入新规则必读入口。
- `ai/global-rules.md` 补充实现生命周期规则指针。
- `template-sync.json` 与 `scripts/sync-template.sh` 兜底同步清单加入新规则。
- `scripts/check-template.sh` / `.ps1` 增加关键断言。
- `VERSION` / `CHANGELOG.md` 更新为 `v1.27.0`。

未在本 PR 落地，保留后续排期：

- 增强 `docs/08-dev-plan.md`。
- 增强 `docs/09-verification.md`。
- 新增 A9 阶段 / Sprint 规划 prompt。
- 更新 `template-docs/scenario-guides.md` A9-A12、`run-dev-task` / `sprint-summary` prompt、`beginner-guide` 引导文案。

### 第二步（v1.27.1）落地中

当前分支 `change/implementation-lifecycle-docs-08-09` 继续落地：

- 增强 `docs/08-dev-plan.md`。
- 增强 `docs/09-verification.md`。
- 新增 `ai/prompts/planning/19-plan-phases-and-sprints.md`。
- `template-sync.json` 与 `scripts/check-template.sh` / `.ps1` 加入新 Prompt 和关键断言。

仍留待后续 PR：

- 更新 `template-docs/scenario-guides.md` A9-A12。
- 强化 `ai/prompts/dev/02-run-task.md`、`ai/prompts/dev/09-sprint-summary.md`。
- 增强 `template-docs/beginner-guide.md` 对实现生命周期的入口说明。

## 1. 背景与问题

当前模板对“输入材料 → 文档体系”的治理较完整，已有 `ai/document-lifecycle-rules.md` 约束文档生成、追溯链、变更传播与上下游影响。但在“文档体系 → 阶段规划 → Sprint / task → 编码实现 → 分层验证 → 验收留痕”阶段，规则分散在多个文件中：

- `docs/03-prd.md` 定义 Phase 路线图。
- `docs/08-dev-plan.md` 提供 Sprint / task 拆分骨架。
- `docs/09-verification.md` 提供验证计划骨架。
- `ai/prompts/dev/02-run-task.md` 约束单任务执行。
- `template-docs/scenario-guides.md` A9-A12 串联阶段规划、执行任务、修 Bug、验证验收。

这些内容能覆盖基本流程，但缺少一份与 `document-lifecycle-rules` 对等的“实现生命周期规则”。新手看到 `template-docs/beginner-guide.md` 中“输入材料 → 文档体系 → 实现代码”的核心心智时，能找到文档生成规则，却找不到同等明确的 AI 运行时实现规则。

具体风险：

- Phase、Sprint、Task 的层级关系与边界没有集中定义。
- A9 阶段规划只有场景说明，缺少专门 prompt / SOP。
- A10 容易退化为“读 08 后直接改代码”，对任务拆分、修改范围、提交粒度和越界审查约束不足。
- A12 验证与验收表述偏简化，容易被误解为“跑单元测试即可”。
- `docs/09-verification.md` 提到验证策略，但没有强制形成测试大纲、测试用例、执行证据与验收结论的闭环。

## 2. 设计目标

- 建立实现侧权威规则，补齐 `document-lifecycle-rules` 之后的工程闭环。
- 明确 `Phase → Sprint → Task → Test Case → Commit / PR → 验收记录` 的层级和追溯链。
- 让 AI 在规划、编码、验证时有明确输入、输出、禁止项与确认节点。
- 把测试从“跑测试”升级为分层验证体系：单元测试、集成测试、系统测试、验收测试、回归测试、资源 / 环境验证。
- 保持小步快跑：一个任务只做一个可验收目标，避免一次实现整个系统。
- 与现有 `docs/03/08/09`、`tasks/*`、`ai/prompts/dev/*` 兼容，不推翻已有文档体系。

## 3. 建议方案

新增实现生命周期规则文件：

```text
ai/implementation-lifecycle-rules.md
```

并将其加入 `ai/index.md` 必读清单，位置建议在 `ai/document-lifecycle-rules.md` 之后、`ai/session-rules.md` 之前或之后。

建议规则文件包含以下章节：

1. 基本原则：先计划后编码、任务小步、验证闭环、禁止越界。
2. 层级模型：Phase / Sprint / Task / Test Case / Commit / Acceptance Record 的定义。
3. 阶段规划规则：如何从 `03/04/05/06/07` 规划当前 Phase 与后续 Phase。
4. Sprint 规划规则：如何从 Phase 拆出 Sprint，何时拆 `tasks/*`。
5. 单任务执行规则：编码前声明、修改范围、确认节点、实现后自检。
6. 测试与验证分层：单元、集成、系统、验收、回归、资源验证的适用范围。
7. 验收与留痕：Sprint / Phase 验收记录写入 `docs/09-verification.md`，必要时同步 `docs/08-dev-plan.md` 当前进度。
8. 代码事实反向同步：代码偏离文档时如何处理，什么时候用 `sync-docs-from-code`。
9. 禁止项：无设计编码、无验证宣布完成、把 Demo 写成 MVP、越过当前 Phase、测试远期功能为必过项等。

## 4. 文档骨架增强建议

### `docs/08-dev-plan.md`

建议增强：

- 明确 Phase / Sprint / Task 定义。
- 在 Sprint 总览中增加“测试等级 / 验证包”列。
- 增加“任务拆分决策树”：超过 3 个文件 / 模块、验收不可一次完成、涉及多个测试等级时必须拆 task。
- 增加“提交与 PR 粒度”说明：一个任务对应一个提交或一个小 PR。
- 增加“Sprint 完成包”：代码改动、测试结果、验收记录、残留风险、下一步。

### `docs/09-verification.md`

建议增强：

- 增加“测试等级矩阵”。
- 增加“Phase 测试大纲”。
- 增加“Sprint 验收包”。
- 增加“缺陷与回归记录”。
- 增加“自动化 / 人工验证边界”。
- 增加“验证证据”字段，如命令、日志、截图、人工验收人、日期。

## 5. Prompt / 场景增强建议

### 新增 A9 专门 prompt

建议新增：

```text
ai/prompts/planning/19-plan-phases-and-sprints.md
```

用途：基于 `03/04/05/06/07/09`，规划 Phase、Sprint、Task 和验证闭环。

输出至少包含：

- Phase 划分建议。
- 当前 Phase Sprint 列表。
- 每个 Sprint 覆盖 REQ / 功能。
- 每个 Sprint 修改范围。
- 每个 Sprint 需要的测试等级。
- 是否需要拆 `tasks/*`。
- 待人工确认项。

### 强化 A10 / A12

- A10 执行前必须检查 `implementation-lifecycle-rules`、`docs/08-dev-plan.md`、`docs/09-verification.md`。
- A10 输出实现方案时必须列出预期修改文件、关联 REQ、关联测试用例、验证方式。
- A12 不只“跑测试”，而是按测试等级矩阵执行并记录结果。

## 6. 拟改范围

- 新增：`ai/implementation-lifecycle-rules.md`
- 修改：`ai/index.md`
- 修改：`ai/global-rules.md`（引用实现生命周期规则，避免只强调文档驱动）
- 修改：`template-docs/beginner-guide.md`
- 修改：`template-docs/scenario-guides.md` A9-A12
- 修改：`docs/08-dev-plan.md`
- 修改：`docs/09-verification.md`
- 新增：`ai/prompts/planning/19-plan-phases-and-sprints.md`
- 修改：`ai/commands/README.md`，必要时新增命令路由
- 修改：`template-sync.json`
- 修改：`scripts/check-template.sh` / `.ps1`，增加关键文件和路由断言

## 7. 版本影响

建议作为 minor 版本落地。

理由：新增核心 AI 行为规则文件，并扩展 08/09 文档骨架、场景引导和 prompt，对派生项目后续开发流程有方法论级影响。

## 8. 验收口径

- `ai/index.md` 必读清单包含实现生命周期规则。
- 新规则能清晰回答 Phase、Sprint、Task、测试用例、验收记录的定义与关系。
- A9-A12 能从总体设计一路引导到 Sprint 规划、任务实现、分层验证与验收留痕。
- `docs/08-dev-plan.md` 能指导 Sprint / task 拆分，而不只是列 Sprint。
- `docs/09-verification.md` 覆盖单元、集成、系统、验收、回归、资源验证。
- AI 执行任务前能明确关联 REQ、Sprint、Task、Test Case 和预期修改范围。
- 完成 Sprint 时有验收记录，不再仅以“测试命令通过”作为完成证据。

## 9. 风险与缓解

- **规则过重**：Lean 项目可采用最小测试大纲，但仍需保留追溯与验收记录。
- **与 document-lifecycle 双写**：文档生成规则仍归 `document-lifecycle-rules`；实现执行规则归新文件，仅通过追溯链衔接。
- **现有派生项目迁移成本**：同步后不强制重写旧文档；在下一次阶段规划或 Sprint 执行前逐步补齐。
- **测试分类机械化**：规则应允许按项目形态裁剪，但必须说明哪些测试等级不适用及原因。
