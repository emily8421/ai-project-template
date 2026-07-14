# TEMPLATE-UPGRADE: Capability Packages 与 Profile 契约化治理

> 来源：从 `_proposals/TEMPLATE-UPGRADE-codex-checkpoint-mode-and-remote-sop.md` 的 Batch B / Batch C 抽出；模板维护者当前会话补充
> 状态：待评估
> 目标版本：待确认
> Release impact：none（仅新增提案 / 分析报告，不改变模板行为；后续落地可能为 patch / minor，待维护者确认）
> Release strategy：先报告化评估，再选择低风险 Profile 试点；不直接做目录级重组或多 agent 并发默认化

## 1. 背景

#195 / PR #205 / PR #206 已完成 Codex Checkpoint Mode、远端 / CI / sandbox 防卡死 SOP 和风险分级确认。该能力解决的是“AI 执行过程中如何刹车、汇报、失败即停”的执行安全问题。

但 #195 提案中仍留下一个更大的结构性问题：模板越来越重后，`ai/` 规则、`docs/00-09`、`template-docs/`、`SOP.md`、`git-guide.md`、Profile、命令、同步清单和自检断言之间的耦合越来越强。若每次优化都触发全局规则读取、全局文档影响评估和多处同步修改，后续维护成本会持续升高。

因此，本提案承接 #195 的后续 Batch B / Batch C，专门评估是否需要把模板能力治理从“全局规则堆叠”转向“能力包 / Profile 契约化”。

## 2. 目标

1. 把 #195 中未落地的 Batch B / Batch C 从防卡死 SOP 中拆出，形成独立待评估提案。
2. 定义 Capability Package / Profile 的最小契约模板，降低每次优化的全局联动成本。
3. 建立影响域表：明确 Core、Docs、Implementation、Verification、Profiles、Governance 各层输入、输出和消费者。
4. 选择一个低风险 Profile 作为试点，建议优先 Remote / CI SOP；备选 Web App Profile。
5. 保留目录级重组、多 agent 并发和 worktree 协作作为后续评估项，不在本提案阶段默认执行。

## 3. 非目标

- 不在本提案阶段移动 `ai/`、`template-docs/`、`docs/` 或 `scripts/` 目录。
- 不改 `ai/index.md` 的任务路由行为。
- 不改 `template-sync.json`、`VERSION`、`CHANGELOG.md` 或自检脚本。
- 不引入真正并发多 agent 默认流程。
- 不让 Profile 契约替代 `docs/00-09`、`tasks/*`、`docs/09-verification.md` 或 Git / PR 事实。

## 4. P0：从 #195 抽出 Batch B / C

已从 `_proposals/TEMPLATE-UPGRADE-codex-checkpoint-mode-and-remote-sop.md` 抽出的后续项：

- Batch B：能力包 / Profile 契约。
- Batch C：角色化协作与 worktree。

抽出后的处理原则：

- #195 保持聚焦：Codex Checkpoint Mode、远端 / CI / sandbox 防卡死、风险分级确认。
- 本提案负责结构性治理：能力包契约、影响域、Profile 试点、多 agent / worktree 后续评估。
- 若后续落地，应另开 PR，不与 #195 已关闭 issue 混合。

## 5. P1：能力包契约模板

每个 Capability Package / Profile 建议只维护以下契约，不复制完整方法论正文：

```markdown
# Capability / Profile Contract: <name>

## 1. 适用场景
- 触发条件：
- 不适用场景：
- 相关 scenario / command：

## 2. 必读文件
- 核心规则：
- Profile 规则：
- 权威模板 / SOP：
- 可选参考：

## 3. 输入契约
- 上游事实来源：
- 必填字段 / 前置状态：
- 禁止从哪里推断：

## 4. 输出契约
- 必须产出：
- 可选产出：
- 不得写入：

## 5. 消费者
- 下游文档：
- 代码 / 测试：
- SOP / 命令：
- 同步 / 自检：

## 6. 验证方式
- 自动检查：
- 人工验收：
- 失败 / pending 处理：

## 7. 自检断言
- 必须存在的入口：
- 必须存在的关键词：
- 必须禁止的漂移：

## 8. 禁止项
- 不得新增未授权需求：
- 不得替代的权威事实：
- 不得默认启用的高风险行为：
```

## 6. P1：影响域表

| 层级 | 主要职责 | 输入 | 输出 | 消费者 | 典型文件 |
|---|---|---|---|---|---|
| Core | AI 行为硬约束、路由、写入确认、handoff、Checkpoint Mode | 用户任务、Git 事实、规则入口 | 规则包选择、确认边界、恢复策略 | 所有任务 | `ai/index.md`、`ai/rules-core.md`、`ai/session-rules.md`、`ai/project-rules.md` |
| Docs | 需求到文档体系、追溯链、变更传播、裁剪 | 输入材料、愿景、PRD / SRS / task | `docs/00-09`、`docs/design/*` | Implementation、Verification、README | `ai/document-lifecycle-rules.md`、`ai/doc-standards/*` |
| Implementation | Phase / Sprint / Task、实现边界、完成包 | `03-09`、`tasks/*`、设计文档 | 代码改动、验证摘要、完成记录 | Verification、Git / PR | `ai/implementation-lifecycle-rules.md`、`ai/commands/run-dev-task.md` |
| Verification | TC、smoke、回归、资源验证、验收记录 | REQ、实现事实、环境事实 | `docs/09`、测试证据、验收结论 | Phase 升级、PR、维护者 | `docs/09-verification.md`、`template-docs/*report*` |
| Profiles | 可选能力剖面，如 Web App、UI Prototype、Remote / CI SOP、Domain Template | Core + Docs / Implementation 的子集 | Profile Gate、契约、局部 SOP、最小验证 | Commands、Docs、Implementation、自检 | `template-docs/web-fullstack-profile.md`、`git-guide.md`、`SOP.md` |
| Governance | 版本、同步、提案、发布、自检 | 变更 diff、提案、PR / issue 事实 | VERSION、CHANGELOG、sync list、归档记录 | 模板维护者、派生同步 | `MAINTAINERS.md`、`CONTRIBUTING.md`、`template-sync.json`、`scripts/check-template.*` |

初步判断：当前模板已有分层雏形，缺的不是马上拆目录，而是让 Profile / 能力包具备统一契约，避免每次优化都需要全局读全局改。

## 7. P2：低风险 Profile 试点选择

### 推荐试点：Remote / CI SOP Profile

理由：

- 范围小，主要涉及 `git-guide.md`、`SOP.md`、`ai/session-rules.md`、`ai/commands/README.md` 和自检断言。
- 与 #195 已落地内容天然衔接。
- 低风险：不改变项目文档链、不影响代码脚手架、不引入新目录结构。
- 成功标准清晰：远端操作前预检、CI 短轮询、sandbox / network / auth 失败即停、高风险动作单步确认。

Remote / CI SOP Profile 契约草案：

| 契约项 | 草案 |
|---|---|
| 适用场景 | push、PR create / merge、issue close、Actions / CI 查询、远端分支处理、GitHub CLI 认证问题 |
| 必读文件 | `ai/rules-core.md`、`ai/session-rules.md` §3.3、`git-guide.md` §1.1 / §1.2、`SOP.md` A10/C4 |
| 输入契约 | 当前 repo root、branch、origin、worktree status、gh auth、viewer permission、目标远端动作 |
| 输出契约 | 预检摘要、远端动作确认点、CI 状态摘要、失败类别和下一步建议 |
| 消费者 | PR / CI 收尾、模板维护、派生同步、issue 关闭流程 |
| 验证方式 | `scripts/check-github-context.ps1`、`gh pr checks` 一次或短轮询、`scripts/check-template.*` 断言 |
| 禁止项 | 不绕过 sandbox / auth；不无限等待 CI；不在未确认时 push / merge / close / delete |

### 备选试点：Web App Profile

理由：已有 `template-docs/web-fullstack-profile.md` 和 scaffold experiment protocol，适合做第二个 Profile 契约试点。

暂不作为首个试点的原因：Web App Profile 牵涉 Docs、Implementation、Verification、template-docs、scaffold 实验和自检，影响面比 Remote / CI SOP 更大。

## 8. P3：目录级重组与多 agent 后续评估

### 8.1 目录级重组

当前不建议执行目录级重组。建议评估条件：

- 至少完成 1–2 个 Profile 契约试点。
- 能证明契约索引不足以降低维护成本。
- 已明确哪些文件需要拆、哪些入口保持稳定、派生项目同步如何兼容。

可能方向：

- 保持现有 `ai/` 入口稳定，仅新增人读契约索引。
- 或在 `template-docs/` 下新增 Profile contract 文档，不影响 AI 核心规则路由。
- 不建议直接把 `ai/` 拆成大量子包，除非同步机制和自检已准备好。

### 8.2 多 agent / 角色化协作

短期建议只采用角色化流程，不默认真正并发：

- `Router / Coordinator`：判断任务类型、规则读取、风险分级确认。
- `Editor`：只改已授权影响域内文件。
- `Verifier`：只跑验证、读日志、汇总失败。
- `Maintainer`：处理版本、同步清单、PR / issue 收口。

真正并发多 agent 的前置条件：

- 每个 agent 使用独立 `git worktree`。
- 共享状态只依赖 Git、handoff、task 文件、验证记录和 PR / issue 事实。
- 明确禁止多个 agent 同时写同一工作区或同一文件影响域。

## 9. 建议落地批次

### Batch 1：报告化索引（推荐下一步）

- 新增或更新一份人读 Profile / Capability contract 索引。
- 不改任务路由、不改同步清单、不改默认行为。
- 输出 Remote / CI SOP Profile 的完整契约草案。

### Batch 2：Remote / CI SOP Profile 试点

- 将 `git-guide.md` §1.1 / §1.2、`SOP.md` A10/C4、`ai/session-rules.md` §3.3 之间的输入 / 输出 / 验证关系写成契约。
- 增加最小自检断言，防止入口漂移。
- 评估是否需要在 `template-docs/` 增加独立 Profile contract 文档。

### Batch 3：Web App Profile 契约化

- 基于 `template-docs/web-fullstack-profile.md` 和 `template-docs/web-app-scaffold-experiment.md` 定义 Web App Profile 契约。
- 明确 Walking Skeleton Gate、scaffold experiment、docs / implementation / verification 的消费关系。

### Batch 4：目录 / 多 agent 评估

- 基于前 2–3 个契约试点的实际效果，再决定是否需要目录级重组。
- 若需要多 agent，先落 worktree 和角色化协作边界，不默认并发写同一工作区。

## 10. 验证建议

提案阶段：

- 只运行 Markdown / diff 基础检查。
- 不运行完整模板自检，除非后续改动进入同步范围或规则行为。

落地阶段：

- 若只新增人读 contract 文档，运行 Markdown 清洁检查即可。
- 若修改 `ai/`、`SOP.md`、`git-guide.md` 或自检脚本，运行 `scripts/check-template.*`。
- 若修改 `template-sync.json` 或新增同步范围文件，必须同步更新 Bash / PowerShell 自检断言。

## 11. 待确认项

| ID | 待确认项 | AI 建议 | 建议依据 | 取舍影响 |
|---|---|---|---|---|
| CAP-001 | 是否执行 Batch 1 报告化索引 | 建议执行 | 风险低，不改变模板行为，可先把能力边界讲清楚 | 增加少量文档，但能降低后续全局重构风险 |
| CAP-002 | 首个试点选择 | 建议 Remote / CI SOP Profile | 影响面小，且与 #195 已落地内容一致 | 能快速验证契约模板是否有用 |
| CAP-003 | 是否立即做目录级重组 | 不建议 | 当前证据不足，且会影响同步清单和规则路由 | 暂缓可避免大范围破坏性变更 |
| CAP-004 | 是否启用真正多 agent 并发 | 不建议默认启用 | 同工作区并发风险高；现有规则更适合角色化流程 | 保留未来能力，先降低复杂度 |

## 12. 下一步建议

1. 维护者确认本提案是否作为 #195 后续治理基线。
2. 若确认，执行 Batch 1：新增或更新 Profile / Capability contract 索引。
3. Batch 1 后再决定是否执行 Remote / CI SOP Profile 试点。
4. 暂不推进目录级重组和真正多 agent 并发。
