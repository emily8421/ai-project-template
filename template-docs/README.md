# template-docs/ 模板手册

本目录放 `ai-project-template` 给**人读**的手册与模板。规则正文（给 AI 读的短 / 准 / 可执行规则）在 `ai/`；项目事实在 `docs/`。

## 手册导航（按类型分组）

### 1. 手册与入口（根目录，进来先读）

| 文档 | 看什么 |
|---|---|
| `beginner-guide.md` | 第一次用的全貌心智模型（是什么 / 准备 / 怎么用 / 输入→文档→代码 / 目录 / 常见错误） |
| `scenario-guides.md` | 场景剧本：说一个场景意图 → AI 给「做什么 + 为什么」引导计划 |
| `env-setup.md` | 装基础工具与环境（check-prereqs / bootstrap） |
| `ai-cli-setup.md` | 装 AI CLI（Claude / Codex）+ 公司中转站衔接 |
| `smoke-test.md` | 新手烟测流程 |
| `template-methodology.md` | 模板为什么这么设计（设计原则、四条价值流、各子系统 why、注册表总览） |
| `capability-packages.md` | 模板机制与专项使用说明：14 类治理机制注册表（负责人 / 触发时机 / 完成判断）+ 工作分区 |
| `glossary.md` | 模板核心术语索引：文档链路、ID、阶段、状态、原型、handoff、同步治理 |

### 2. 专项说明（Profile，按项目形态选读）

| 文档 | 看什么 |
|---|---|
| `remote-ci-sop-profile.md` | 远端操作与 CI 速查（push / PR / issue / Actions 处置） |
| `web-fullstack-profile.md` | 复杂 Web / 全栈项目特化（App Shell / 前后端边界 / vertical slice） |
| `web-app-scaffold-experiment.md` | Web 应用脚手架实验（是否采用真实脚手架的验证记录） |
| `domain-templates.md` | 领域模板可选中间层方法论：什么时候引入 L2、边界和回流关系 |

### 3. 使用时才复制的模板（templates，用到再打开）

| 文档 | 看什么 |
|---|---|
| `smoke-test-report-template.md` | 烟测结果记录模板 |
| `session-handoff.example.md` | 会话续接文件样例 |
| `docs-open-items.example.md` | 待确认事项总览填充示例 |
| `demo-runbook-template.md` | 项目演示 SOP 模板（配合 `/run show-demo`） |
| `user-guide-template.md` | 项目用户指南模板 |
| `derived-sync-report-template.md` | 派生项目同步模板后的运行记录模板 |
| `ui-brief-intake-template.md` | UI 输入材料缺口梳理模板 |
| `frontend-experience-brief-template.md` | 前端体验 brief 模板 |
| `ui-prototype-exploration-template.md` | UI 原型策略 / 探索记录模板 |
| `ui-prototype-strategy-template.md` | UI 原型策略记录模板 |
| `frontend-ui-reference-analysis-template.md` | 前端参考产品分析落盘模板 |

### 4. 结构模板库与知识层（子目录）

| 目录 | 看什么 |
|---|---|
| `docs-scaffold/` | 项目文档结构模板库：`docs/inputs/*`、`docs/vision/*`、`docs/00-09`、`docs/design/*`、`docs/decisions/*`、`docs/research/*` 的原始大纲、占位表格和撰写提要 |
| `ui-knowledge/` | UI 设计知识核心层：视觉 / 交互模式 + 来源索引（按 scope 读取） |
| `examples/` | 工具脚本样例（如图表提取脚本） |

### 5. 模板仓专用（不下行，仅模板仓可见）

| 文档 | 看什么 |
|---|---|
| `e2e-regression-checklist.md` | L3 端到端回归清单（MINOR / MAJOR 发布门，模板维护者用） |
| `e2e-report-template.md` | L3 回归报告模板（模板维护者用） |
| `rd-data-chain.md` | 研发数据沉淀路径地图（模板仓治理视角） |

> 领域专属：`domain-derived-scenarios-template.md`（L2-to-L3 playbook 模板）仅领域路线下行（files_domain），普通派生项目不接收。

> 这些手册随模板下行同步（见 `template-sync.json`）；派生项目同步后获得最新版，不要在派生项目直接改，通用改进走 `_governance/_proposals/` 回流。操作走 `scenario-guides.md` 场景引导，命令速查看 `SOP.md`。
