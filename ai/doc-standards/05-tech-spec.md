# 05 Technical Specification Standard（技术方案规范镜像）

> Sync notice: This file is maintained by `ai-project-template` and may be overwritten when a derived project syncs template methodology.
> Do not edit it directly in derived projects; propose reusable changes in `_proposals/` and upstream them to the template repository.

本文件是 `docs/05-tech-spec.md` 的规范镜像，用于 AI 生成、修订、审计和评估项目技术方案。它不是项目事实文档，派生项目的实际技术事实仍写入 `docs/05-tech-spec.md`。

## 1. 定位与边界

`05` 承接 `04` 的架构边界和 `03` 的 Phase / 交付物形态，输出技术栈、依赖配置、运行资源、安全隐私、技术风险验证和 readiness gate。

- 只说明“用什么技术以及如何落地”，不重复 `04` 架构图，不写 DB / API 字段细节。
- 候选、默认关闭、Mock、降级、已验证、已启用必须据实区分。
- 真实密钥、token、账号密码和客户敏感数据不得写入文档。
- 真实外部服务、数据库、LLM、部署能力进入 Sprint 前，必须有风险验证或 readiness gate 结论。

## 2. 最低结构

| 能力 | 最低字段 / 结构 |
|---|---|
| 技术栈与版本 | 类别、技术 / 版本、状态、用途、约束来源、替代品禁令 / 备注 |
| 关键技术决策 | 决策 ID、决策、理由、替代方案、影响范围、权威源、验证状态 |
| 依赖与配置 | 类型、名称、用途、启用阶段、当前状态、配置来源、密钥 / 敏感性、验证方式 |
| 运行环境与资源评估 | 运行项、本机要求、当前本机是否满足、验证证据、降级 / Mock、服务器预案 |
| 技术环境评估结论 | 评估报告路径、Go / Conditional Go / No-Go、阻塞项、需回填章节 |
| Phase 技术约束 | Phase、允许、禁止、Mock / 降级、技术状态说明、权威源 |
| 前端交互设计边界 | 是否触发 `docs/design/frontend-interaction.md`、权限边界、接口依赖、验收路径 |
| 安全、隐私与合规 | 项、要求、阶段、状态、权威源、验证入口 |
| 技术风险与验证计划 | Risk-ID、风险、触发条件、影响、验证方式、对应用例 / 任务、解锁条件 |
| Readiness gate | 真实依赖、数据库、外部服务、LLM、部署能力的进入标准、证据、状态、阻塞项 |
| 待人工确认项 | 结构化确认项表，不得把 AI 建议写成确认事实 |

## 3. 技术状态与依赖配置矩阵

| 类型 | 名称 | 用途 | 启用阶段 | 当前状态 | 配置来源 | 密钥 / 敏感性 | 验证方式 |
|---|---|---|---|---|---|---|---|
| Python 包 / Node 包 / Docker 服务 / 外部 API / 数据库 |  |  | Phase1 / Phase2 | 已启用 / 已验证 / 候选 / 默认关闭 / Mock / 降级 / 禁止 | `.env` / 配置文件 / 手工输入 | 无 / secret / token / 隐私 | 命令 / TC / Spike |

状态使用原则：

1. `候选` 不得作为实现事实。
2. `已验证` 不等于 `已启用`；必须说明是否进入当前 Phase。
3. `Mock` / `降级` 不等价真实能力通过，必须有后续验证或解锁条件。
4. `默认关闭` 能力不得被 Sprint 默认实现，除非 Phase 或人工确认解锁。
5. `禁止` 状态必须被 `08` Sprint 禁止事项和 `09` 验证边界承接。

## 4. 技术风险验证闭环

| Risk-ID | 风险 | 触发条件 | 影响 | 当前状态 | 验证方式 | 对应用例 / 任务 | 解锁条件 |
|---|---|---|---|---|---|---|---|
| RISK-001 |  |  |  | 待验证 / 已验证 / 已接受 / 阻塞 | 命令 / Spike / PoC / TC | TC-001 / Sprint-X / task-00X |  |

闭环要求：

- 每个 P0 / P1 技术风险必须至少映射到一种验证方式。
- 外部服务、数据库、LLM、Docker / 部署、重型 SDK、权限安全、真实数据处理等风险，必须映射到 `09` TC、Spike、PoC、Sprint 任务或人工风险接受记录。
- `05` 记录风险来源和解锁条件，`09` 记录验证用例和证据，`08` 记录 Sprint 前置条件和禁止事项。
- `No-Go` 或阻塞风险未关闭时，不得建议进入依赖该能力的实现 Sprint。

## 5. Readiness Gate

| Gate | 适用对象 | 进入标准 | 必需证据 | 状态 | 阻塞项 / 下一步 |
|---|---|---|---|---|---|
| RG-001 | 外部 API / 数据库 / LLM / Docker / 部署 |  | `docs/research/*tech-env-evaluation*.md` / 命令输出 / TC | Go / Conditional Go / No-Go / 待评估 |  |

触发条件：

- 项目涉及真实运行依赖，如 `backend/`、`frontend/`、`docker/`、数据库、本机模型、外部 API、重型 SDK。
- Phase 升级、Sprint 开始或用户要求从 Mock / 降级切换到真实能力。
- 技术环境、密钥、网络、资源、合规、权限或部署条件尚未验证。

最低通过标准：

- 已引用 `docs/env/local-env.md` 或明确服务器 / CI / 目标运行环境。
- 已列出依赖配置、敏感性、验证方式和启用阶段。
- 已给出 Go / Conditional Go / No-Go 结论及阻塞项。
- Conditional Go 必须说明限制条件、风险接受人或补做时点。
- No-Go 必须阻止相关 Sprint 或 Phase 升级，直到改为 Go / Conditional Go。

## 6. 与下游的映射

- 给 `06` / `07`：数据库、接口、权限和外部服务实现约束。
- 给 `docs/design/*`：组件技术选型、前端交互工程边界、状态管理和错误处理要求。
- 给 `08`：Sprint 前置条件、禁止事项、依赖安装 / 配置任务和 Spike / PoC。
- 给 `09`：Risk-ID、TC、证据路径、回归边界和 readiness gate 验证项。
