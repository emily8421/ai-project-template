# TEMPLATE-UPGRADE: Agent 命令预检与失败隔离

> 来源：模板维护者（2026-08-10 Codex CLI 同步预检会话）
> 状态：已采纳（P0 实施于 v1.60.4；P1 预检脚本留候选池）
> 目标版本：v1.60.4
> Release impact：patch（实施 P0：核心规则约束 + 同步两阶段预检契约，不改默认同步语义）
> Release strategy：先落地 P0 最小预检契约（v1.60.4），P1 预检脚本作为同主题后续 Batch；不把某一模型或 CLI 的偶发行为写成模板事实
> 评审决议（2026-08-11）：见 §13

## 1. 摘要

一次从模板仓发起的派生项目同步预检，在读取 registry 并确认目标项目角色后，因为一个辅助脚本存在性检查的 PowerShell 参数构造错误而中止。同步 dry-run、切分支、同步写入、提交和远端操作均未发生。

现有规则正确地要求“命令失败即停”，因此没有发生后续越界操作；但当前同步 SOP 没有把预检拆成稳定的失败域，也没有提供一个可复用的只读预检入口。结果是：一个非关键辅助检查失败时，包含 Git 状态、版本与 lineage 在内的整批只读结果无法被保留和报告。

本提案建议将防护收敛为三层：

1. 在核心规则中补一条通用的“精确查询 + 失败隔离”约束。
2. 在 `sync-methodology` 与其 Prompt 中定义两阶段预检和逐项结果矩阵。
3. 在后续实施批次中提供 Bash / PowerShell 对称的只读预检脚本，减少由 Agent 临场拼接 shell 参数的机会。

## 2. 事故事实与边界

### 2.1 实际失败命令

```powershell
Get-ChildItem -LiteralPath scripts -File -Name sync-template.ps1,check-derived-sync.ps1
```

PowerShell 返回 `ParameterBindingException`：无法将 `System.Object[]` 转换为 `-Filter` 所需的单个 `System.String`。

### 2.2 直接起因

`Get-ChildItem -Name` 是输出格式开关，不是“按名称选择文件”的参数。命令在 `-Name` 后提供了两个文件名，PowerShell 将其作为未绑定的位置参数尝试处理，最终落到只接受单一字符串的 `-Filter`，因数组类型不匹配而失败。

要检查少量已知文件，正确的抽象不是“枚举目录后格式化名称”，而是“验证精确路径是否存在”。例如应逐条使用 `Test-Path -LiteralPath <path> -PathType Leaf`，或由专用预检脚本封装该逻辑。

### 2.3 放大因素

预检由多个独立的只读调用组成，但调用端以 all-or-nothing 的并行聚合方式收集结果。辅助检查抛错后，聚合失败，已完成的 Git 状态、版本、stash、lineage 等结果没有回到上层流程。

这不是 PowerShell 对正确命令的误判，也不是同步脚本自身的失败。它是一次由 Agent 生成的命令形状错误，加上“不同失败域混入同一结果聚合”所产生的诊断损失。

### 2.4 未发生的事项

- 未执行 dry-run、同步、切换或新建分支。
- 未修改派生项目、模板仓规则、同步清单或版本文件。
- 未触发网络、远端 GitHub、安装依赖或破坏性操作。
- 未发现同步脚本或 `check-derived-sync` 脚本的行为缺陷。

## 3. 模型与 CLI 归因边界

本记录不能据此断定 `gpt-5.6-luna`、`gpt-5.6-terra`、Codex CLI 或 PowerShell 存在特定缺陷。

- PowerShell 的参数绑定错误可由命令文本直接复现，直接根因是命令文本不符合 cmdlet 参数契约。
- 不同模型、reasoning effort、上下文长度和工具编排策略可能影响此类命令构造错误的发生概率，但当前只有单个可定位样本，不能形成模型差异结论。
- 即使更高能力模型降低命令错误概率，也不能替代流程防护；模板应假设任何 Agent 都可能生成不符合 shell 参数契约的命令。

如需验证模型差异，应另建小型评估：在相同系统提示、相同 reasoning effort 和相同 PowerShell 预检样例下，比较命令一次通过率、参数绑定错误率、失败后是否保留关键事实和总工具调用数。评估结果未产生前，不修改模型选型策略。

## 4. 现有控制与缺口

### 4.1 已有有效控制

- `AGENTS.md` 与 `ai/rules-core.md` 的 Checkpoint Mode 要求命令失败立即停止并汇报，避免错误后继续执行同步。
- `ai/commands/sync-methodology.md` 要求在同步前检查目标路径、Git 状态、`VERSION`、`TEMPLATE-BASE.md`、同步脚本与 `template-sync.json`。
- `scripts/sync-template.*` 和 `scripts/check-derived-sync.*` 已对实际同步、lineage 与同步边界提供脚本化保护。

### 4.2 缺口

| 缺口 | 后果 | 当前状态 |
|---|---|---|
| 已知文件检查没有规范为精确路径查询 | Agent 容易把 `Get-ChildItem` 的输出参数误当筛选参数 | 缺失 |
| 关键事实与辅助能力检查混在一个失败域 | 辅助失败掩盖已完成的 Git / 版本事实 | 缺失 |
| 同步前没有独立的、只读的预检脚本 | 每次由 Agent 临场重写类似 PowerShell / Bash 逻辑 | 缺失 |
| 预检结果没有统一的逐项状态矩阵 | 很难区分 `fail`、`not-checked` 与“没有返回” | 缺失 |
| 失败后的“立即停止”没有说明哪些事实已成功取得 | 停止是安全的，但恢复成本高 | 部分覆盖 |

## 5. 目标与非目标

### 5.1 目标

1. 让同步前预检使用确定、最小、只读且跨 shell 可复用的检查路径。
2. 让一个辅助检查失败不会掩盖已取得的关键事实。
3. 保持现有“命令失败即停”的安全边界，不把失败自动重试为写入操作。
4. 将 shell 参数易错点收敛到经验证的脚本，而不是散落在 Prompt 或即时工具调用中。
5. 为后续模型或 CLI 评估保留可观察指标，但不预设归因结论。

### 5.2 非目标

- 不要求所有任务、所有 shell 命令都逐参数运行 `Get-Command -Syntax` 或人工查帮助。
- 不把 PowerShell 专有细节写入 `AGENTS.md`、`ai/global-rules.md` 或项目专属规则。
- 不要求由模板仓在一次同步中修改所有旧派生项目的历史预检流程。
- 不改变 `sync-template` 的版本保留、dry-run、commit、边界检查或 PR 流程。
- 不把单个事故作为更换 Codex 模型或限制某模型使用的依据。

## 6. 推荐方案

### 6.1 P0：合并到现有核心规则的通用约束

在 `ai/rules-core.md` §4 的 Checkpoint Mode 规则中补充一条短约束：

> 对有限且已知的目标，使用与目标数量和类型相匹配的精确查询；不得把目录枚举或输出格式参数当作筛选机制。并行预检按失败域拆分，逐项保留结果；辅助检查失败不得掩盖 Git、版本、lineage 等关键事实。

该规则只描述工具调用的正确性与结果保留，不绑定 PowerShell、Codex、`Promise.allSettled` 或具体命令名称。其他工具可将其实现为分批调用、具名结果或等价的错误收集机制。

### 6.2 P0：同步命令的两阶段预检契约

在 `ai/commands/sync-methodology.md` 和 `ai/prompts/maintainers/12-sync-template.md` 中将当前“检查”细化为两阶段：

| 阶段 | 检查项 | 失败语义 | 允许的后续 |
|---|---|---|---|
| A. 身份与安全事实 | 本地路径、Git 仓、分支与工作区、stash、`VERSION`、`TEMPLATE-BASE.md` lineage、registry `Sync mode` | 任一关键项失败或冲突即停 | 仅报告，不进入 dry-run |
| B. 同步能力 | `scripts/sync-template.*`、`scripts/check-derived-sync.*`、`template-sync.json`、必要的运行入口 | 记录缺项和原因；不会抹去阶段 A 结果 | 缺项即停或转旧项目 bootstrap 路径 |

每项必须显式输出 `pass`、`fail` 或 `not-checked`。命令失败时，报告已成功取得的 A 阶段事实、失败项及尚未执行的项，而不是只报告批次失败。

### 6.3 P1：只读预检脚本

新增以下对称脚本，作为同步命令的首选入口：

```text
scripts/preflight-derived-sync.sh
scripts/preflight-derived-sync.ps1
```

职责限定为：

- 解析当前仓库根目录和 Git 工作区状态。
- 检查 `VERSION`、`TEMPLATE-BASE.md` 和 lineage 与指定同步模式是否一致。
- 逐一检查同步脚本、边界检查脚本和 `template-sync.json` 的存在性。
- 输出稳定的逐项状态矩阵及建议路径：普通派生、领域模板、旧项目 bootstrap、或停止。
- 全程只读：不 fetch、不创建分支、不 stage、不写入、不创建临时项目文件。

脚本不执行 dry-run 或同步。实际同步仍由既有 `sync-template.*` 承担，边界验证仍由 `check-derived-sync.*` 承担。

对尚未同步到包含该脚本版本的旧派生项目，Prompt 保留一组固定、逐条执行的精确路径检查作为 bootstrap 兼容路径。不得为了获得预检脚本而先在派生项目写入文件。

### 6.4 P1：可移植的失败隔离策略

Agent 在编排本地只读命令时应遵循：

1. 关键事实与辅助检查分批执行，不共用 all-or-nothing 结果聚合。
2. 并行执行时收集每条调用的成功和失败结果；当前工具不支持此能力时，改为顺序的短命令，而不是让一次失败吞掉整批事实。
3. 仅在用户的新一轮授权或明确恢复后，执行经修正的命令；同一失败点不得在当前 Checkpoint 内自动连续重试。
4. 使用脚本、命令或工具的已记录输入契约；参数含义不明确时，选择更简单的精确查询，或先做单独的只读语法核对。

## 7. 方案比较

| 方案 | 优点 | 不足 | 结论 |
|---|---|---|---|
| 仅增加“命令要正确”的规则 | 修改最少 | 无法减少即时 shell 拼接；不可测试 | 不采用 |
| 在 Prompt 中固化更多 PowerShell 命令片段 | 可快速缓解 | 容易与 Bash、脚本和后续维护漂移 | 仅作为旧项目 bootstrap 兼容 |
| 增加核心约束 + 两阶段契约 | 提升所有 Agent 的可恢复性 | 仍依赖 Agent 正确执行 | 采用 |
| 再增加只读预检脚本 | 将高频易错细节转为可测试实现 | 需要 Bash / PowerShell 对称维护 | 推荐实施 |
| 按单次事故替换模型 | 可能改变错误概率 | 无因果证据，不能保证正确 | 不采用 |

## 8. 拟改范围（实施批次，非本提案的实际改动）

| 文件 | 拟改内容 |
|---|---|
| `ai/rules-core.md` | 增加一条精确查询与预检失败隔离约束 |
| `ai/commands/sync-methodology.md` | 将预检拆成 A/B 两阶段，规定结果矩阵和停止条件 |
| `ai/prompts/maintainers/12-sync-template.md` | 使用预检脚本；保留旧项目 bootstrap 的固定兼容路径 |
| `scripts/preflight-derived-sync.sh` | 新增 Bash 只读预检实现 |
| `scripts/preflight-derived-sync.ps1` | 新增 PowerShell 只读预检实现 |
| `template-sync.json` | 将新预检脚本纳入同步范围 |
| `scripts/check-template.*` | 断言命令、Prompt、同步清单与两端预检脚本一致 |
| `MAINTAINERS.md` 或 `SOP.md` | 仅在需要时补充维护者调用示例，不复制规则正文 |

`AGENTS.md` 保持入口和 Checkpoint 摘要职责，不复制实现细节；`ai/global-rules.md` 保持跨项目方法论边界，不承载 shell 专项规则。

## 9. 验证与验收

实施后至少覆盖以下验证：

| 场景 | 预期 |
|---|---|
| 普通派生，干净工作区，完整同步工具 | 预检通过并建议 `--preserve-project-version` |
| 领域模板，干净工作区，领域 lineage | 预检通过并建议 `--domain-template` |
| Git 工作区有已跟踪改动 | 明确失败，不建议 dry-run |
| `TEMPLATE-BASE.md` lineage 与 registry `Sync mode` 冲突 | 明确失败并显示冲突字段 |
| 缺少同步脚本、边界检查脚本或 manifest | 阶段 A 事实仍完整输出；阶段 B 显示缺项和 bootstrap / 停止建议 |
| 任一辅助查询失败 | 已完成关键事实不会丢失；未执行项标记 `not-checked` |
| PowerShell 与 Bash | 对同一 fixture 输出相同的状态语义与建议路径 |
| 模板自检 | 同步清单、命令路由、Prompt 和两端脚本引用一致 |

验收证据应包含命令、退出码、逐项状态摘要和失败时的最小可定位片段。成功路径不回灌完整日志。

## 10. 版本与下行影响

本提案本身不修改同步范围，`Release impact` 为 `none`。

若实施仅增加兼容的预检说明、可选脚本和自检，不改变旧项目的默认同步语义，也不要求人工迁移，建议按 `patch` 评估。若将预检脚本变为旧项目必须采用的新门禁、改变同步入口或扩展出不可忽略的下游采用面，应按 `minor` 重新评估。

同步后，活跃的普通派生与领域模板应在各自的下一次正常方法论同步中获得新脚本；不建议为此提案单独对所有历史项目做高风险批量迁移。

## 11. 待确认项

| ID | 待确认项 | AI 建议 | 建议依据 | 备选方案 | 取舍影响 / 阻塞关系 |
|---|---|---|---|---|---|
| C-001 | 是否实施预检脚本 | 实施 P1 脚本，保留 P0 文档契约 | 高频跨 shell 预检值得固化为可测试实现 | 只改 Prompt | 只改 Prompt 成本低但仍依赖即时命令构造；不阻塞本提案评审 |
| C-002 | 是否将预检设为所有旧项目的强制门禁 | 不强制追溯；新版本默认采用 | 避免为获得脚本先修改旧项目，保持兼容 | 一次性批量迁移 | 批量迁移扩大风险；不阻塞后续同步 |
| C-003 | 是否在核心规则提及并行聚合实现细节 | 只写结果语义，不写具体 API | 模板需兼容 Codex、Claude、Cursor 等工具 | 写入 `Promise.allSettled` | 具体 API 会把模板绑定到单一运行时；不阻塞 |
| C-004 | 是否评估 Luna / Terra 的差异 | 先收集固定样例，再决定 | 目前无可归因数据 | 直接修改模型默认值 | 直接切换模型无法证明解决问题；不阻塞防护实施 |

## 12. 完成标准

- 预检可以在不执行同步写入的前提下给出完整、逐项的 A/B 阶段事实。
- 单个辅助检查失败不会掩盖已成功取得的关键事实。
- 所有推荐实现保持“失败即停”，不会自动重试或绕过用户确认。
- PowerShell 与 Bash 对同一仓库状态给出一致的同步路线建议。
- 模板命令、Prompt、同步清单和自检之间没有漂移。
- 模型差异仅在有可重复评估证据后才进入选型决策。

## 13. 评审与实施决议（2026-08-11）

评审结论：采纳 P0（§6.1 + §6.2 + §6.4），P1（§6.3 预检脚本）留候选池作为同主题后续 Batch。

| ID | 待确认项 | 决议 |
|---|---|---|
| C-001 | 是否实施预检脚本 | 本次只实施 P0（核心约束 + 两阶段契约）；P1 `scripts/preflight-derived-sync.*` 留候选池，后续 Batch 再评估 |
| C-002 | 是否将预检设为旧项目强制门禁 | 不强制追溯（采纳 §6.2 / §10 口径） |
| C-003 | 是否在核心规则写并行聚合 API | 只写结果语义，不写具体 API（采纳） |
| C-004 | 是否评估 Luna / Terra 差异 | 先收集固定样例，不修改模型选型（采纳 §3 归因边界） |

实施范围（v1.60.4，patch）：

- `ai/rules-core.md` §4 新增「预检精确查询与失败域隔离」通用约束（§6.1 + §6.4 并入）。
- `ai/commands/sync-methodology.md` 执行流程顶部 + 两阶段契约总述，步骤 2 / 3 标注 A / B 阶段。
- `ai/prompts/maintainers/12-sync-template.md` 模板仓发起模式步骤 2 + SOP Prompt 执行要求顶部落实两阶段契约 + 精确查询示例。
- 未改：`template-sync.json`、`scripts/check-template.*`（无新文件 / 脚本，P1 留候选池）。

未实施（留候选池）：§6.3 对称预检脚本 `scripts/preflight-derived-sync.sh/.ps1` + 相关 `template-sync.json` / `check-template` 断言，作为同主题后续 Batch。
