# TEMPLATE-UPGRADE: docs/design/* 通用详细设计标准与分类 checklist

> Proposal status: Draft for review
> Proposal batch: Batch 6
> Related issues: #110, #116
> Source mirrors: `_proposals/_remote-issues/issue-110.md`, `_proposals/_remote-issues/issue-116.md`

## 1. 背景与问题

`docs/design/*` 位于 `04-07` 总体设计 / 契约与 `08-09` 实现计划 / 验证之间，用于承载非平凡子系统、复杂 UI、权限边界、AI / 外部服务、导入 / 异步任务或高风险愿景能力的详细设计。现有模板已经定义前端交互设计基线，也要求详细设计承接 `03/04/05/07/08/09`，但缺少一个通用的 `docs/design/*` 详细设计标准。

从派生项目回流 issue 看，常见详细设计包括后端服务、页面入口、Web 控制台、知识策略、Mock 集成、场景包、权限、RAG、术语管理等。它们形态不同，但都承担 `04-07` 与 `08-09` 之间的承接职责。如果没有通用标准，容易出现：

1. 多数 `docs/design/*` 缺少统一元信息，输入来源、覆盖 REQ、关联 `04-09`、当前状态、最后更新和下游影响不稳定。
2. 职责、边界、不做事项结构不统一，详细设计中容易越过 PRD / API / Phase 边界。
3. 流程、状态机、失败 / 降级路径要求不一致，外部服务、AI、OCR、异步任务、权限拒绝等场景容易遗漏。
4. `docs/design/*` 与 `06` 表字段、`07` API-ID、`09` TC-ID、`08` Sprint / Task 的追溯表不统一。
5. UI、权限、安全、AI / RAG、导入 / 异步任务、高风险愿景能力等不同类型详细设计需要不同 checklist，但模板目前只有前端交互基线。
6. Mock / 降级 / Demo 与真实能力之间的差异缺少固定记录位，容易在实现后产生文档漂移。
7. 代码实现后缺少实现偏差 / 设计回写区，设计与代码事实逐渐漂移。
8. 待人工确认项容易退化为自由文本，缺少 AI 建议、依据、备选方案和阻塞关系。

这些问题不依赖具体业务项目。凡是存在非平凡子系统、复杂 UI、权限边界、AI / 外部服务、导入 / 异步任务或高风险愿景能力的派生项目，都需要通用 `docs/design/*` 模板规范。

## 2. 设计目标

Batch 6 目标是把 #110 与 #116 的 `docs/design/*` 通用详细设计诉求合并为一组可实施的模板优化，确保模板能稳定支撑以下链路：

```text
02 REQ / NFR / 边界场景
  → 03 Phase / 非目标 / 交付物形态
  → 04 模块 / Flow
  → 05 技术状态 / 风险 / Mock / 降级
  → 06 DB / 07 API 契约
  → docs/design/* 子系统详细流程 / 状态 / 失败 / 权限 / UI / AI
  → 08 Sprint / Task
  → 09 TC / 验收 / 风险
```

具体目标：

1. 所有非平凡 `docs/design/*` 都有统一元信息、职责边界、阶段、追溯、验收和待确认项结构。
2. 不同类型设计可在同一通用模板下裁剪：服务型、页面 / 交互型、策略 / 规则型、配置型、集成适配型、高风险愿景型。
3. 详细设计明确不新增未授权需求、接口、表、验收目标或 Phase 外能力。
4. 详细设计能承接 `04/05/06/07`，并输出给 `08/09` 和代码实现。
5. Mock / 降级 / 实现偏差有固定记录位置，避免 Demo 能力被误读为真实能力。
6. 前端交互设计作为 `docs/design/*` 的子类型参考，但不替代通用 design 标准。
7. 旧派生项目可按需追加元信息、追溯矩阵和实现偏差区，不要求全文重写。

## 3. 合并范围与去重结论

| 来源 | 核心诉求 | Batch 6 处理方式 |
|---|---|---|
| #110 | 新增通用 `docs/design/*` 详细设计标准，覆盖元信息、职责边界、追溯、流程、契约、失败 / 降级、验收等 | 纳入主范围，作为标准文件和 Prompt 增强来源 |
| #116 | 增加子系统类型裁剪、readiness gate、实现偏差 / 设计回写和命令路由补充 | 纳入主范围，作为裁剪规则、审计规则和回写规则增强来源 |
| 既有前端交互设计基线 | UI 型项目的详细设计要求 | 作为子类型引用，不替代通用标准 |
| Batch 2 / #105 / #112 | REQ / Phase 追溯 | 作为上游依赖；Batch 6 承接 REQ、Phase 和非目标 |
| Batch 3 / #106 / #113 | 技术状态、风险和 readiness gate | 作为上游依赖；Batch 6 将其落到子系统设计的 gate 和状态区 |
| Batch 4 / #107 / #114 | DB / API 契约状态 | 作为上游依赖；Batch 6 要求引用表 / 字段 / API-ID |
| Batch 5 / #108 / #109 / #115 | Sprint / TC / 回写闭环 | 作为下游依赖；Batch 6 输出到 Sprint、Task、TC 和实现偏差回写 |

去重结论：

- #110 偏“通用设计标准文件”，#116 偏“类型裁剪、实现偏差和命令 / 审计联动”，二者应合并为同一 Batch。
- Batch 6 不重复前端交互设计的页面 / 路由 / 响应式细节；前端交互是 `docs/design/*` 的一种子类型。
- Batch 6 不要求所有简单项目创建 design 文档；只对非平凡子系统或触发条件成立时启用。

## 4. 建议新增通用 design 标准

建议新增 `ai/doc-standards/design-doc.md`，定位为 `docs/design/*` 的详细设计标准文件。

### 4.1 文档定位

建议标准文件包含以下定位：

```markdown
# docs/design/* 详细设计文档标准

> 文档定位：当某个模块 / 子系统 / 前端入口 / 权限边界 / AI 流程 / 外部集成复杂到无法只靠 04-07 表达时，使用 `docs/design/<subsystem>.md` 记录内部流程、状态、失败处理、权限边界和验证追溯。
>
> 上游输入：`docs/02-srs.md`、`docs/03-prd.md`、`docs/04-architecture.md`、`docs/05-tech-spec.md`、`docs/06-db-design.md`、`docs/07-api-spec.md`、`ai/project-rules.md`。
>
> 下游输出：`docs/08-dev-plan.md`、`docs/09-verification.md`、`tasks/*`、代码实现与测试。
>
> 禁止事项：不得新增未授权需求、接口、表、验收目标或 Phase 外能力；不得用前端隐藏 / 禁用 / 路由守卫替代后端接口和服务层权限边界。
```

### 4.2 通用结构

建议 `docs/design/<subsystem>.md` 通用骨架如下：

```markdown
# <子系统>详细设计

> 定位：详细设计。本文细化 <子系统> 的职责、边界、流程、状态、失败处理和验收追溯；不替代 `docs/04-architecture.md`、`docs/05-tech-spec.md`、`docs/06-db-design.md` 或 `docs/07-api-spec.md`。

## 0. 文档元信息
## 1. 目标与范围
## 2. 职责边界与非目标
## 3. 上下游依赖
## 4. 核心流程 / 状态机 / 数据流
## 5. 数据、接口与配置契约
## 6. 失败处理、降级与安全边界
## 7. 阶段增量与 readiness gate
## 8. 追溯矩阵
## 9. 验收路径
## 10. 实现偏差 / 设计回写
## 11. 待人工确认项
```

### 4.3 文档元信息

| 项 | 内容 |
|---|---|
| 设计对象 / 子系统 | 子系统 / 页面 / 模块 / 流程 |
| 输入来源 / 上游依据 | 关联 `02/03/04/05/06/07/env/research` |
| 覆盖 REQ / NFR | REQ-... / NFR-... |
| 关联 04-07 | MOD / Flow / 技术状态 / 表 / 字段 / API-ID |
| 下游影响 | `docs/08-dev-plan.md`、`docs/09-verification.md`、tasks、代码模块 |
| 适用 Phase | Phase1 / Phase2 / 愿景 |
| 交付物形态 | Demo / MVP / 产品 / 不适用 |
| 当前状态 | 骨架 / 草稿 / 已设计 / 已实现 / 待验证 / 待回写 / 后续阶段 |
| 最后更新 | YYYY-MM-DD |

### 4.4 职责边界与非目标

| 项 | 内容 |
|---|---|
| 本设计负责 |  |
| 本设计不负责 |  |
| 不新增内容 | 未授权需求 / 接口 / 表 / 验收目标 / Phase 外能力 |
| 权限边界 | 后端 / 服务层 / DB / 前端可见性分工 |
| 依赖前置 |  |

### 4.5 上下游追溯

| 来源 | 章节 / ID | 本设计承接内容 | 下游影响 |
|---|---|---|---|
| `docs/02-srs.md` | REQ-... |  |  |
| `docs/04-architecture.md` | MOD / Flow |  |  |
| `docs/05-tech-spec.md` | 技术状态 / Risk-ID |  |  |
| `docs/06-db-design.md` | 表 / 字段 |  |  |
| `docs/07-api-spec.md` | API-ID |  |  |
| `docs/08-dev-plan.md` | Sprint / Task |  |  |
| `docs/09-verification.md` | TC-ID |  |  |

### 4.6 核心流程 / 状态机

```markdown
### Flow-D-001：<流程名称>

- 触发条件：
- 前置条件：
- 成功路径：
- 失败 / 异常路径：
- 降级路径：
- 关联 API / DB / TC：
```

状态机建议字段：

| 状态 | 含义 | 进入条件 | 退出条件 | 用户 / 系统可见表现 | 终态 |
|---|---|---|---|---|---|

### 4.7 数据、接口、配置与权限契约

| 能力 / 流程 | 数据表 / 字段 | API-ID / 命令 | 配置 / Feature flag | 权限规则 | 错误码 | 备注 |
|---|---|---|---|---|---|---|

最低规则：

- 详细设计不得自创新 API、表、配置或权限边界；若确有新增需求，应回到 `03/06/07` 待确认。
- 前端隐藏、按钮禁用或路由守卫只能作为可见性控制，不能替代后端接口和服务层权限边界。

### 4.8 失败、异常、降级与实现偏差

失败 / 异常路径建议字段：

| 场景 | 触发条件 | 系统行为 | 用户可见信息 | 记录 / 日志 | 是否阻塞验收 | 关联 TC |
|---|---|---|---|---|---|---|

Mock / 降级差异建议字段：

| 能力 | 目标设计 | 当前实现 / Demo | Mock / 降级原因 | 是否等价真实能力 | 补齐时点 | 对验收影响 |
|---|---|---|---|---|---|---|

实现偏差 / 设计回写建议字段：

| 日期 | 实现事实 / 偏差 | 影响范围 | 是否仍在 Phase 边界内 | 应回写文档 | 后续动作 |
|---|---|---|---|---|---|

### 4.9 阶段增量、readiness gate 与验收追溯

阶段增量建议字段：

| 阶段 | 功能范围 | 交付物形态 | 设计状态 | 实现状态 | 备注 |
|---|---|---|---|---|---|

readiness gate 建议字段：

| 能力 | 当前状态 | 解锁条件 | 验证证据 | 降级路径 | 是否阻塞 Sprint / Phase |
|---|---|---|---|---|---|

验收追溯建议字段：

| 设计点 | 关联 REQ | 关联 Sprint / Task | 关联 TC | 验证方式 | 状态 |
|---|---|---|---|---|---|

## 5. 分类 checklist

建议在 `design-doc.md` 中内置分类 checklist，但保持可裁剪。

| 类型 | 必需重点 | 可裁剪项 |
|---|---|---|
| 服务型 | 服务职责、输入输出、错误处理、数据 / API 依赖、日志与安全 | 页面结构、响应式 |
| 页面 / 交互型 | 页面清单、用户路径、状态模型、表单校验、文案、接口依赖、验收路径 | 后端内部服务流程 |
| 权限 / 安全型 | 身份、授权、租户 / 空间边界、敏感字段、审计、越权失败 | 页面布局 |
| AI / RAG / 外部模型型 | 证据来源、召回 / 排序、提示词边界、成本、隐私、兜底、不可自动承诺 | 常规 CRUD 细节 |
| 导入 / 异步任务 / 外部集成型 | 状态机、幂等、重试、超时、限流、凭据、Mock / 真实边界 | 纯展示细节 |
| 策略 / 规则型 | 规则优先级、冲突处理、高风险边界、证据来源、不得提前实现声明 | 页面布局 |
| 配置型 | 配置字段、版本、校验规则、加载 / 发布状态、失败处理 | 复杂运行拓扑 |
| 高风险愿景型 | 当前 Phase 禁止项、候选状态、readiness gate、人工确认、降级路径 | 已确认实现细节 |

## 6. 触发与豁免规则

建议补充以下触发口径：

1. 非平凡子系统、复杂 UI、多角色权限、AI / 外部服务、导入 / 异步任务、跨模块状态机或高风险能力，应新增或补齐 `docs/design/*`。
2. 简单项目或单一函数 / 小脚本可豁免，但需在 `ai/project-rules.md`、`docs/05-tech-spec.md` 或相关评估中说明原因。
3. UI 型项目仍优先使用或扩展 `docs/design/frontend-interaction.md`；该文件也应满足通用 design 标准的元信息、追溯和验收要求。
4. 旧项目可先追加 `0. 文档元信息`、追溯矩阵和实现偏差区，不强制重写全文。

## 7. 拟改范围

| 文件 | 建议变更 |
|---|---|
| `ai/doc-standards/design-doc.md` | 新增通用 `docs/design/*` 详细设计标准文件 |
| `ai/doc-standards/README.md` | 增加对 `design-doc.md` 的定位说明与引用；说明前端交互是 design 子类型 |
| `template-sync.json` | 将新增 `ai/doc-standards/design-doc.md` 纳入同步清单 |
| `ai/document-lifecycle-rules.md` | 在 `docs/design/*` 规则中引用通用设计标准、触发 / 豁免规则、分类 checklist 和实现偏差回写 |
| `ai/global-rules.md` | 轻量补充详细设计触发原则，避免重复放长模板 |
| `ai/project-rules.md` | 在项目形态裁剪中保留前端交互 / 详细设计触发和豁免说明 |
| `ai/prompts/docs/00-generate-or-complete-docs.md` | 生成文档体系时按触发条件建议新增 design 文档，并使用通用模板 |
| `ai/prompts/docs/04-edit-single-doc.md` | 修订 design 文档时提示检查元信息、追溯、状态机、失败 / 降级、readiness gate、实现偏差和待确认项 |
| `ai/prompts/docs/07-sync-docs-from-code.md` | 实现偏差反向同步时提示补 `docs/design/*` 的实现偏差 / 设计回写区 |
| `ai/prompts/review/10-docs-checklist.md` | 编码前检查时确认触发条件下的 design 文档是否存在或有豁免 |
| `ai/prompts/review/16-docs-system-audit.md` | 审计 `docs/design/*` 时对照通用设计标准和分类 checklist |
| `ai/prompts/review/19-docs-evaluation.md` | E3 详细设计评估时增加通用 design checklist 和 Go / Conditional Go / No Go 影响 |
| `ai/commands/edit-single-doc.md` | 明确“补详细设计 / 补子系统设计”读取 design 通用标准 |
| `ai/commands/docs-system-audit.md` | 明确扫描 `docs/design/*` 的元信息、追溯、readiness gate 和实现偏差区 |
| `scripts/check-template.sh` / `.ps1` | 增加关键断言，防止 design 标准、同步清单和 Prompt 引用缺失 |
| `VERSION` / `CHANGELOG.md` | 按 MINOR 记录版本变更 |

## 8. 版本影响

建议作为 MINOR 版本处理。

理由：

- 新增 `ai/doc-standards/design-doc.md`，影响详细设计生成、审计、评估和同步清单。
- 增强 `docs/design/*` 的触发、豁免、分类裁剪、追溯、readiness gate 和实现偏差回写规则。
- 会改变 AI 对“是否需要补详细设计”和“详细设计是否可进入实现计划”的默认判断方式。

## 9. 验收口径

1. 模板存在 `ai/doc-standards/design-doc.md` 或等效标准文件。
2. `ai/doc-standards/README.md` 能引用 design 通用标准，并说明前端交互是 design 子类型。
3. `template-sync.json` 纳入新增 design 标准文件。
4. 新标准包含元信息、职责边界、上下游依赖、流程 / 状态、数据 / 接口 / 权限契约、失败处理、追溯矩阵、验收路径、实现偏差和待确认项。
5. 新标准支持按服务型、页面 / 交互型、权限 / 安全型、AI / RAG 型、导入 / 集成型、策略型、配置型、高风险愿景型裁剪。
6. `document-lifecycle-rules` 明确 `docs/design/*` 触发、豁免、不得新增需求和实现偏差回写规则。
7. `generate-docs` / `edit-single-doc` 能按触发条件建议或修订 design 文档。
8. `docs-system-audit` / `docs-evaluation` 能发现 design 文档缺元信息、追溯矩阵、readiness gate 或实现偏差区。
9. `docs-checklist` 编码前能检查触发条件下的 design 文档是否存在或有豁免。
10. 自检脚本能防止 design 标准、同步清单和关键 Prompt 引用被误删。
11. 合并后关闭 #110、#116，并在关闭说明中说明二者的合并处理方式。

## 10. 非目标

- 不落地 `00-03` 需求链规范；该范围由 Batch 2（#105、#112）处理。
- 不落地 `04-05` 架构 / 技术方案风险验证；该范围由 Batch 3（#106、#113）处理。
- 不落地 `06-07` DB / API 契约规范；该范围由 Batch 4（#107、#114）处理。
- 不落地 `08-09` 开发计划与验证证据规范；该范围由 Batch 5（#108、#109、#115）处理。
- 不要求所有简单项目都创建 `docs/design/*`。
- 不要求所有 design 文档都包含前端页面 / 路由 / 响应式章节。
- 不在当前 Phase 之前提前写死后续能力细节。
- 不允许 design 文档新增上游未授权需求、接口、表或验收目标。
- 不一次性新增多个子模板目录；先以单文件 `design-doc.md` 降低维护成本。

## 11. 风险与缓解

| 风险 | 缓解 |
|---|---|
| 文档负担增加 | 仅非平凡子系统触发；简单项目可豁免并说明理由 |
| 与前端交互设计重复 | 明确前端交互是子类型，通用 design 标准覆盖更多子系统 |
| AI 借 design 新增需求 | 强调 design 只能承接 04-07 和 REQ，不新增需求 / API / 表 / TC |
| 过早细化后续能力 | 使用 readiness gate 和状态标签，候选能力不得写成已实现 |
| 与 Batch 5 回写规则重复 | Batch 6 只提供 design 内部实现偏差区，正式验收与完成包仍归 08 / 09 |
| 旧项目迁移成本高 | 允许先追加元信息、追溯矩阵和实现偏差区，不强制重写全文 |

## 12. 待确认项

| ID | 待确认项 | AI 建议 | 建议依据 | 备选方案 | 取舍影响 / 阻塞关系 |
|---|---|---|---|---|---|
| B6-C1 | design 通用标准放在单文件还是目录 | 建议先单文件 `ai/doc-standards/design-doc.md` | 易于同步和引用，避免一次新增多个子模板 | 建 `ai/doc-standards/design/` 目录 | 目录更清晰但初期维护成本更高 |
| B6-C2 | 是否将 `0. 文档元信息` 设为所有 design 必填 | 建议非平凡 design 必填 | design 必须可追溯上游和下游 | 复杂 design 必填 | 简单 design 也可能断链，但可通过豁免处理 |
| B6-C3 | 是否将分类 checklist 放入通用 design 标准 | 建议放入 | 可覆盖 UI、权限、AI、导入、高风险愿景的差异 | 后续单独拆提案 | 更聚焦但会增加提案数量 |
| B6-C4 | 是否要求实现偏差 / Mock / 降级表 | 建议涉及实现期或 Demo 降级时必填 | 防止设计与代码事实漂移 | 仅在 `sync-docs-from-code` 时临时生成 | 临时生成更轻，但容易遗漏历史偏差 |
| B6-C5 | readiness gate 是否放入 design 标准 | 建议保留入口并引用 Batch 3 | design 文档最常承接候选能力，但横切状态需统一 | 完全放到 Batch 3 | design 标准可能缺少高风险能力门槛 |
| B6-C6 | Batch 6 是否等待 Batch 1-5 合并后再实施 | 建议等待 | Batch 6 承接前序全部追溯、状态、契约和回写规则 | 并行实施 | 可能出现上游字段或术语冲突 |

## 13. Issue 关闭与归档策略

- Batch 6 实施 PR 合并后关闭 #110、#116。
- 关闭留言说明：已合并处理 `docs/design/*` 通用详细设计标准、分类 checklist、触发 / 豁免规则、readiness gate 和实现偏差回写。
- `_proposals/_remote-issues/issue-110.md` 与 `issue-116.md` 可随 Batch 6 proposal 归档。
- 若 Batch 1-5 proposal 合并前暂不实施 Batch 6，本 proposal 保持在 `_proposals/` 作为待处理提案。
