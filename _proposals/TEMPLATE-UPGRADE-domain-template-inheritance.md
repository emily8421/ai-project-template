# TEMPLATE-UPGRADE: 领域模板继承机制与 Agent 系统 Profile

> 来源：2026-07-09 维护会话中关于“母模板 → agent 专用模板”继承关系的设计讨论
> 状态：部分落地（Batch 1 方法论文档化已完成；Batch 3 母模板侧 AI 实验入口已提供；领域资产仍待独立仓库试验）
> 目标版本：v1.45.6（domain-template-lab AI 实验入口）；后续领域模板仓库资产待确认
> Release impact：patch（AI 建议，待维护者确认；新增独立实验入口，不改变主同步路径）
> Release strategy：分批落地；母模板只提供 `domain-template-lab` 启动器和边界，不把领域模板机制并入普通派生项目同步 SOP；领域 scaffold / 同步清单 / 自检先在独立领域模板仓库试验

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

### 方案 A：母模板内置领域 scaffold（不推荐正式落地）

在母模板中新增：

```text
template-docs/domain-templates/agent-system/
```

优点：

- 成本低，不需要新仓库。
- 可用现有 `check-template` 和 `template-sync.json` 管理。

缺点：

- 即使只新增独立文件夹，正式纳管也会牵动 `template-sync.json`、`check-template`、`VERSION`、`CHANGELOG.md`。
- 母模板需要承担 agent 领域模板的生命周期，长期会削弱通用母模板边界。
- 非 agent 项目会同步到无关领域模板内容。

结论：仅适合作为短期人工草稿或本地探索，不建议作为正式落地路径。

### 方案 B：独立 `agent-system-template` 仓库（推荐）

新建领域模板仓库，先由母模板生成或同步，再叠加 agent 专用文件。

优点：

- 继承边界清晰。
- agent 规则不会增加非 agent 项目负担。
- 可以独立版本化和发布。

缺点：

- 需要维护跨仓同步机制。
- 初期成本高于内置 scaffold。

结论：这是推荐正式路线。既然 agent scaffold 需要独立版本、自检、同步清单和后续 eval / trace / tool policy 扩展，就应让这些生命周期留在 `agent-system-template`，而不是让母模板承担领域模板职责。

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

### Batch 2：创建独立 `agent-system-template` 仓库

建议新仓库先从 `ai-project-template` 生成 / 同步，保留母模板通用方法论，再在独立仓库中新增 agent scaffold MVP。建议最小文件集：

```text
template-docs/agent-system/README.md
template-docs/agent-system/agent-system-checklist.md
template-docs/agent-system/docs/design/agent-architecture.md
template-docs/agent-system/docs/design/tool-permission-model.md
template-docs/agent-system/docs/design/memory-and-state.md
template-docs/agent-system/docs/research/agent-eval-plan.md
```

MVP 只提供结构模板和检查表，不绑定具体 agent runtime。母模板不新增这些 scaffold 文件。

### Batch 3：领域模板自检与同步链路

- 在 `agent-system-template` 仓库维护自己的 `template-sync.json`、`scripts/check-template.sh`、`VERSION` 和 `CHANGELOG.md`。
- `agent-system-template` 继续通过母模板 `sync-template` 吸收通用方法论更新。
- 具体 agent 项目从 `agent-system-template` 派生，并同步 agent 专用 scaffold。
- 母模板仅保留本提案，不纳入 agent scaffold 同步范围。
- v1.45.6 起，母模板提供 `/run domain-template-lab` 作为独立 AI 可执行实验入口：它只负责自动判定仓库角色、输出相邻层同步 / 回流计划，并在用户确认后引导目标领域模板仓库生成实验资产；不修改 `git-guide.md` §5 主路径，不让领域派生项目直接同步母模板。
- **实证（2026-07-11，agent-system-template 同步 v1.44.3→v1.45.6 试跑）**：母模板 `sync-template.sh` 按两端校验，`VERSION`/`CHANGELOG.md` 在 sync 清单内，每次同步会把领域模板 `VERSION` 覆盖为母模板版本（实测 `v0.1.0`→`v1.45.6`）、`CHANGELOG.md` 同样覆盖。当前临时方案：`VERSION` 同步后手动恢复领域版本（以 `TEMPLATE-BASE.md` 为权威）；`CHANGELOG.md` 接受母模板维护、领域演进记 `TEMPLATE-BASE.md`（口径 c）。**证实 Batch 3 需要"版本保留机制"**：sync 应跳过 / 保留领域模板的 `VERSION`/`CHANGELOG`，或提供领域专属 sync 清单（`domain-template-sync.json`），避免每次手动恢复。详见 agent-system-template `sync-records/template-sync/2026-07-11-sync-template-v1.45.6.md`。

### Batch 4：profile / 自动化评估

在独立 `agent-system-template` 被至少一个真实项目试用后，再评估：

- 是否在母模板或 agent 模板中新增 `new-project --profile agent-system`。
- 是否需要多级同步自动化或专门的领域模板创建脚本。
- 是否需要 agent 模板自己的发布 / 回流 / 下行同步 SOP。

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
| C-001 | agent 领域模板首版采用哪种形态 | 采用方案 B：独立 `agent-system-template` 仓库 | 正式 scaffold 需要独立版本、自检、同步清单和后续 eval / trace / tool policy 扩展，不应让母模板承担领域生命周期 | 母模板内置可选 scaffold | 初期成本低但会污染母模板治理边界 |
| C-002 | 是否立刻支持 `new-project --profile agent-system` | 暂不支持，等 scaffold 稳定后再做 | 脚本语义和测试矩阵会扩大 | 直接做 profile 参数 | 使用体验更好但容易过早固化不成熟结构 |
| C-003 | Batch 2 版本影响 | 母模板保持 none；`agent-system-template` 仓库按自身版本治理判断 | 母模板不新增 scaffold、不改同步清单；领域模板能力在独立仓库发布 | 若母模板内置 scaffold，则按母模板版本治理判断 | 独立仓库避免母模板因领域能力膨胀而频繁发版 |
| C-004 | Batch 3 版本保留机制：sync 是否跳过 / 保留领域模板 `VERSION`/`CHANGELOG` | 采用领域专属 sync 清单（`domain-template-sync.json`）排除 `VERSION`/`CHANGELOG`，或 sync 对"领域模板角色"分支跳过这两个文件 | 2026-07-11 试跑实证：每次 sync 覆盖 `VERSION`/`CHANGELOG` 需手动恢复，不可持续 | 母模板 sync 增加"领域模板角色"分支；领域模板从 sync 清单移除 `VERSION`/`CHANGELOG` | 增加分支复杂度；移除后需确保领域版本仍可追溯（`TEMPLATE-BASE.md` 已是权威） | 不阻塞当前同步（手动恢复可继续）；但每次同步都产生该开销，应纳入 Batch 3 优先项 |
