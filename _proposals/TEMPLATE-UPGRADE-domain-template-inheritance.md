# TEMPLATE-UPGRADE: 领域模板继承机制与 Agent 系统 Profile

> 来源：2026-07-09 维护会话中关于“母模板 → agent 专用模板”继承关系的设计讨论
> 状态：候选 / 待评估
> 目标版本：待确认
> Release impact：none（本提案仅定义设计方向；未进入同步范围、未新增 scaffold、未改脚本）
> Release strategy：分批落地；先明确继承机制，再评估 agent-system scaffold，最后考虑 profile / 独立仓库

## 1. 背景

当前 `ai-project-template` 已具备通用 AI 工程治理能力：文档链路、AI 行为规则、模板同步、验证闭环、会话续接、提案治理和版本治理。它更适合作为 **母模板 / 基础方法论模板**，而不是直接塞入某个领域的全部细节。

Agent 类系统需要额外约束：planner / executor、tool registry、tool permission、memory / state、human-in-the-loop、trace / replay、agent eval、成本 / 延迟 / 安全指标等。这些内容如果直接进入母模板，会增加所有非 agent 项目的负担。

因此建议建立三层关系：

```text
ai-project-template（母模板 / base template）
  → domain template（领域模板，例如 agent-system-template）
    → project template / project（具体业务项目）
```

## 2. 目标

1. 明确母模板、领域模板、具体项目的职责边界。
2. 允许未来派生 `agent-system-template`，继承母模板通用方法论，并叠加 agent 专用标准件。
3. 避免把 agent 规则直接塞进母模板，保持母模板对 Web、CLI、数据管道、研究原型等多类型项目的通用性。
4. 为后续 `--profile agent-system` 或独立 `agent-system-template` 仓库预留设计边界。

## 3. 非目标

- 本提案不新增 `template-docs/domain-templates/agent-system/` scaffold。
- 本提案不修改 `scripts/new-project.*` 或 `scripts/sync-template.*`。
- 本提案不引入 LangGraph / AutoGen / CrewAI 等运行时框架选择。
- 本提案不规定所有项目必须采用 agent 设计文档。
- 本提案不改变当前同步清单和版本发布策略。

## 4. 继承关系定义

### 4.1 母模板职责：`ai-project-template`

母模板只提供跨项目通用能力：

- 文档链路与核心骨架：`docs/00-09`。
- AI 行为规范与生命周期规则：`ai/`。
- 会话续接与多 AI CLI 协作规则。
- 提案治理、版本治理、维护者流程。
- 通用验证计划、readiness gate、Sprint / Phase 验收包。
- 模板同步机制与自检机制。

母模板不应承担某个领域的全部细节，例如 agent memory 模型、工具权限矩阵、轨迹回放协议等。

### 4.2 领域模板职责：`agent-system-template`

领域模板继承母模板通用方法论，再叠加 agent 专用能力：

- Agent 架构：planner / executor / critic / supervisor / tool router / memory。
- Tool 权限：工具注册、权限边界、危险操作确认、沙箱与审计。
- Memory / state：短期上下文、长期记忆、状态持久化、清理与可解释性。
- Eval：任务集、轨迹评估、工具调用准确率、拒答 / 越权率、成本 / 延迟。
- Trace / replay：agent 执行日志、重放、失败归因、人工审核。
- Human-in-the-loop：审批点、人工接管、回滚与补偿。
- 安全与降级：prompt injection、数据泄露、外部服务失败、mock / fallback。

领域模板可以维护自己的版本、CHANGELOG、领域 scaffold 和自检，但不应 fork 母模板规则后长期漂移。

### 4.3 具体项目职责

具体项目从领域模板派生，填入业务事实：

- 业务需求、用户角色、目标场景。
- 真实工具、真实数据、账号权限、部署环境。
- 领域知识、客户规则、验收用例。
- 项目特有的风险接受、合规要求和运行指标。

具体项目不得把业务事实回写到母模板或领域模板；只有可通用于多个项目的改进，才通过提案回流。

## 5. 同步 / 继承策略候选

### 方案 A：母模板内置领域 scaffold（推荐先做）

在母模板中新增：

```text
template-docs/domain-templates/agent-system/
```

优点：

- 成本低，不需要新仓库。
- 可用现有 `check-template` 和 `template-sync.json` 管理。
- 方便先验证 agent 专用标准件是否稳定。

缺点：

- 母模板体积增加。
- 需要明确它是“可选领域 scaffold”，不得影响 base 项目默认路径。

### 方案 B：独立 `agent-system-template` 仓库

新建领域模板仓库，先由母模板生成或同步，再叠加 agent 专用文件。

优点：

- 继承边界清晰。
- agent 规则不会增加非 agent 项目负担。
- 可以独立版本化和发布。

缺点：

- 需要维护跨仓同步机制。
- 初期成本高，容易过早抽象。

### 方案 C：`new-project --profile agent-system`

在新建项目脚本中增加 profile：

```text
--profile base
--profile agent-system
```

优点：

- 使用体验最好。
- 能在项目创建时直接落地 agent scaffold。

缺点：

- 会修改脚本语义和测试矩阵。
- 需要先稳定领域 scaffold，否则脚本复杂度过早上升。

## 6. 推荐分批落地

### Batch 1：机制设计（本提案）

- 明确三层继承关系。
- 明确职责边界和非目标。
- 不新增同步文件、不改脚本、不 bump 运行能力版本。

### Batch 2：agent-system scaffold MVP

建议最小文件集：

```text
template-docs/domain-templates/agent-system/README.md
template-docs/domain-templates/agent-system/agent-system-checklist.md
template-docs/domain-templates/agent-system/docs/design/agent-architecture.md
template-docs/domain-templates/agent-system/docs/design/tool-permission-model.md
template-docs/domain-templates/agent-system/docs/design/memory-and-state.md
template-docs/domain-templates/agent-system/docs/research/agent-eval-plan.md
```

MVP 只提供结构模板和检查表，不绑定具体 agent runtime。

### Batch 3：自检与同步清单

- 若 Batch 2 文件进入母模板同步范围，则更新 `template-sync.json`。
- `scripts/check-template.sh` 增加存在性和关键字段断言。
- 判断版本影响：新增可选 scaffold 大类，预计 `minor`；若仅提案则 `none`。

### Batch 4：profile / 独立仓库评估

在 agent scaffold 被至少一个真实项目试用后，再评估：

- 是否新增 `new-project --profile agent-system`。
- 是否拆出独立 `agent-system-template` 仓库。
- 是否需要领域模板自己的 `sync-template` 上游链路。

## 7. Agent scaffold MVP 内容边界

### 必须覆盖

- Agent 角色与责任边界。
- Planner / executor / tool router / memory / evaluator 的最小结构。
- Tool 权限矩阵与危险操作确认。
- Memory 与 state 生命周期。
- Trace / replay 与失败归因。
- Agent eval 任务集与验收指标。
- Human-in-the-loop 与人工接管。
- Prompt injection / 数据泄露 / 越权工具调用风险。

### 暂不覆盖

- 具体 agent runtime 框架选择。
- 具体模型供应商选择。
- 具体向量数据库 / memory backend。
- 具体 UI / dashboard。
- 具体业务领域 prompt。

## 8. 验收标准

本提案阶段：

- 能清晰回答母模板、领域模板、具体项目分别负责什么。
- 能解释为什么 agent 专用规范不应直接塞进母模板默认路径。
- 能给出 agent-system scaffold MVP 文件集。
- 能给出从 scaffold 到 profile / 独立仓库的分批演进路径。

后续实现阶段：

- agent scaffold 文件存在且有关键字段。
- 不影响 base 模板默认项目创建流程。
- 不绑定特定 runtime。
- 自检可防止 agent scaffold 漂移。

## 9. 待确认项

| ID | 待确认项 | AI 建议 | 建议依据 | 备选方案 | 取舍影响 / 阻塞关系 |
|---|---|---|---|---|---|
| C-001 | agent 领域模板首版采用哪种形态 | 先采用方案 A：母模板内置可选 scaffold | 成本低、可用现有自检验证，避免过早跨仓同步 | 直接新建 `agent-system-template` 仓库 | 边界更清晰但维护成本更高 |
| C-002 | 是否立刻支持 `new-project --profile agent-system` | 暂不支持，等 scaffold 稳定后再做 | 脚本语义和测试矩阵会扩大 | 直接做 profile 参数 | 使用体验更好但容易过早固化不成熟结构 |
| C-003 | Batch 2 版本影响 | 若新增同步范围 scaffold，建议按新版治理判断为 minor | 新增可选领域 scaffold 大类，属于新的下游采用面 | 若仅保留提案则 none | 版本判断取决于是否进入同步范围 |
