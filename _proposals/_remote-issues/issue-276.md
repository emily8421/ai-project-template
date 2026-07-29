# GitHub Issue #276: TEMPLATE-UPGRADE: scenario-guides 三层路径矩阵与领域派生项目场景

> Source URL: https://github.com/emily8421/ai-project-template/issues/276
> State: OPEN
> Labels: proposal, from:agent-system-template
> Author: emily8421
> Created: 2026-07-28T00:38:23Z
> Updated: 2026-07-28T00:38:23Z
> Mirrored at: 2026-07-28T17:14:50+08:00
> Mirror status: raw remote issue copy for local triage; GitHub issue remains source of comments and closure state.

## Local Triage / Implementation Notes

> Local triage updated: 2026-07-29T15:23:21+08:00
> Remote issue state at triage: OPEN

Batch 1 has landed in the mother template:

- PR: https://github.com/emily8421/ai-project-template/pull/283
- Merge commit: `894cb2b3b0ae952136df545ff529985603d0de34`
- Version: `v1.58.3`
- Scope: three-layer L1/L2/L3 scenario routing, L2-to-L3 playbook requirement, adjacent-layer feedback/proposal routing, and `check-template` assertions.
- Explicitly not included: `template-docs/domain-derived-scenarios-template.md`, `template-sync.json` changes, sync script protocol changes, or `new-project --profile <domain>`.
- Validation before merge: `git diff --check`; Markdown clean check; `scripts/check-template.ps1`; `scripts/check-template.sh --summary` (`1908` checks / `0` failures). CI `template-check` passed on PR #283.

Remaining decision notes:

- C1 (`domain-derived-scenarios-template.md`): resolved for Batch 1 as "do not add yet"; keep as future optional candidate only if multiple L2 templates need a reusable skeleton.
- C2 (L2-to-L3 playbook required asset): resolved in Batch 1 by documenting the requirement in `template-docs/domain-templates.md`, `scenario-guides.md`, `domain-template-lab`, and maintainer prompt checks.
- C3 (transitional L1 new-project plus L2 overlay): documented as tolerated transitional routing; no script change in this batch.
- C4 (new A29): resolved as "do not split yet"; routing stays in the matrix and A2/A13/A15/C entries.

## Raw Issue Body

# TEMPLATE-UPGRADE: scenario-guides 三层路径矩阵与领域派生项目场景

> 来源：agent-system-template（emily8421/agent-system-template）派生项目回流
> 状态：草案 · 待母模板维护者确认（B 组 · 待上行跨领域）
> 目标仓库：母模板 `ai-project-template`（本提案先存派生项目 `_proposals/`，成熟后 `submit-proposal` 回流）
> 目标版本：母模板下一个 patch；若新增命令或同步骨架文件，可评估为 minor
> Release impact：patch（AI 建议；场景路由与领域模板创建口径澄清，不改变普通派生项目默认主路径）
> Release strategy：建议并入 domain-template inheritance 后续批次；可先文档化路径矩阵，再评估脚本 / command 增量

## 1. 背景与动机

母模板最初只有两层路径：

```text
L1 母模板 ai-project-template -> 普通 L3 派生项目
```

领域模板是后期插入的可选中间层，形成三层路径：

```text
L1 母模板 ai-project-template -> L2 领域模板 -> 领域 L3 派生项目
```

当前 `template-docs/scenario-guides.md` 的多数 A 场景默认服务两层主路径；A20 已覆盖“母模板 -> 领域模板”的创建评估，`domain-template-lab` 也提供领域模板实验线入口。但整个 scenario guide 尚未系统评估：

- 哪些 A / C 场景对三条路径都适用。
- 哪些场景必须按路径分叉，例如新建、同步、回流、发布、批量同步。
- 哪些场景母模板只给原则，具体剧本应由领域模板维护。
- 创建新领域模板时，是否必须同时产出“领域模板 -> 领域派生项目”的场景剧本。

本提案目标是补上 scenario guide 的三层路径矩阵。母模板不直接写 agent / OCR / IoT 等具体领域剧本，但应要求每个领域模板产出自己的 L2->L3 场景剧本。

## 2. 目标

1. 在 `scenario-guides.md` 增加三层路径判定矩阵：L1->普通 L3、L1->L2、L2->领域 L3。
2. 对 A0-A28 / C1-C8 做“通用适用 / 需路径分叉 / 仅特定路径适用”分类。
3. 对 A2 新建、A13 同步、A15 回流、C1-C8 维护者场景补充路径分叉原则。
4. 在 A20 / `domain-template-lab` 中要求：创建新领域模板时，必须规划该领域模板自己的 L2->L3 场景剧本入口。
5. 明确母模板的职责边界：提供三层路由原则、骨架和检查口径；不承载具体领域 scaffold 和具体领域派生项目操作细节。

## 3. 非目标

- 不把 agent-specific、OCR-specific 或其他领域专属剧本写入母模板。
- 不立即实现 `new-project --profile <domain>`。
- 不改变普通派生项目默认的两层主路径。
- 不让普通派生项目承担领域模板复杂度。
- 不让领域派生项目业务事实越级回流母模板。
- 不在本提案中直接修改母模板 `template-sync.json` 主同步语义。

## 4. 三条路径定义

| 路径 | 说明 | 默认场景 |
|---|---|---|
| L1 -> 普通 L3 | 母模板直接派生普通项目；当前主路径 | 大多数 A 场景默认路径 |
| L1 -> L2 | 母模板创建 / 维护领域模板；领域模板是可选中间层 | A20、`domain-template-lab`、领域模板维护者 C 场景 |
| L2 -> 领域 L3 | 领域模板创建 / 同步 / 验收 / 回流领域派生项目 | 应由领域模板提供具体剧本，母模板提供骨架要求 |

路由原则：

- 用户在普通派生项目中提出同步母模板：走 A13 / `sync-methodology`。
- 用户在领域模板中提出同步母模板：仍是 A13，但使用 `--domain-template` 角色口径。
- 用户在领域派生项目中提出同步领域标准件：不应直接让母模板脚本处理；应读取领域模板提供的 L2->L3 剧本。
- 用户在领域派生项目中提出跨领域通用反馈：先回流 L2；只有经 L2 提炼后才回流 L1。

## 5. A 场景适用性评估

| 场景 | 建议分类 | 说明 |
|---|---|---|
| A0 冷启动 | 需路径分叉 | 只有仓库链接时，先区分要 clone 母模板、领域模板，还是已有领域派生项目。 |
| A1 环境准备 | 通用适用 | 工具检查基本通用，但领域模板可追加领域工具前置项。 |
| A2 新建派生项目 | 需路径分叉 | 普通 L3 走母模板 `new-project`；L2 走 A20；领域 L3 走领域模板剧本。 |
| A3 新项目第一次运行 | 需轻分叉 | 普通项目填 `project-rules` 与环境；领域 L3 还需填领域 docs / checklist。 |
| A4-A12 文档 / 计划 / 实现 / 验证 | 通用适用 + 领域 overlay | 文档链路通用；领域 L3 需额外读取领域规则、领域 doc standards 和领域 checklist。 |
| A13 同步模板到派生项目 | 需路径分叉 | 普通 L3 同步 L1；L2 同步 L1 时用领域模板口径；领域 L3 同步 L2。 |
| A14 Phase 升级 | 通用适用 + 领域 overlay | Phase 规则通用；领域 L3 需检查领域 gate / advisory。 |
| A15 回流提案 / 反馈 | 需路径分叉 | 普通 L3->L1；领域 L3->L2；L2->L1 只回流跨领域通用结论。 |
| A16-A19 续接 / open items / 专题 / 定稿 | 通用适用 | 先判层，避免把 L2 候选建议写成 L3 项目事实。 |
| A20 领域模板派生 | 仅 L1->L2 | 应新增“领域派生项目场景剧本”为领域模板初始化必备产物。 |
| A21-A28 演示 / UI / 技术环境 / skeleton | 通用适用 + 领域 overlay | 具体项目执行；领域 L3 需合并领域运行、权限、安全和 eval 约束。 |

## 6. C 场景适用性评估

| 场景 | 建议分类 | 说明 |
|---|---|---|
| C1 处理提案收件箱 | 需路径分叉 | 母模板处理 L1 提案；领域模板处理 L2 提案；跨层回流必须保持来源和去项目化。 |
| C2 版本 bump 与发布 | 需路径分叉 | L1、L2、L3 的 `VERSION` / `CHANGELOG` 是不同版本空间。 |
| C3 模板自检 | 需路径分叉 | L1 跑 `check-template`；L2 跑领域自检；L3 跑项目 / 领域派生检查。 |
| C4 PR / 合并 / 归档 | 基本通用 | 分支、PR、归档流程通用；归档落点按 L1 / L2 区分。 |
| C5 维护下行同步机制 | 需路径分叉 | L1 维护 `template-sync.json`；L2 维护 `domain-template-sync.json` 或等价清单。 |
| C6 派生同步验收 | 需路径分叉 | L1->L3 用 `check-derived-sync`；L2->L3 用领域检查脚本。 |
| C7 模板能力设计流程 | 基本通用 | 提案、影响面、自检断言、发布纪律通用；同步范围不同。 |
| C8 批量同步所有派生项目 | 需路径分叉 | L1 批量同步普通派生 / 领域模板；L2 批量同步领域派生项目。 |

## 7. 拟改（母模板侧）

### 7.1 `template-docs/scenario-guides.md`

建议新增“路径矩阵 / 场景适用性”小节，放在场景总表前或总表后：

- 先判定当前任务属于 L1->普通 L3、L1->L2、L2->领域 L3。
- 对 A0-A28 / C1-C8 标注“通用 / 需路径分叉 / 仅某路径适用”。
- 在 A2、A13、A15、C1-C8 中补稳定分叉提示。
- 在 A20 完成判据中加入“领域模板必须规划 L2->L3 场景剧本入口”。

### 7.2 `ai/prompts/maintainers/23-domain-template-lab.md`

在“领域模板实验资产候选”中新增：

| 文件 / 目录 | 用途 | 状态 |
|---|---|---|
| `template-docs/<domain>/domain-derived-scenarios.md` | 领域模板 -> 领域派生项目的场景剧本，说明创建、同步、整理、自检、回流和发布后的下游同步 | 实验线必备资产 |

执行流程增加要求：若当前正在创建 / 更新领域模板实验线，必须规划该剧本；未生成时要在输出计划和续接记录中列为待办，不能只生成领域 scaffold、同步清单和自检脚本。

### 7.3 `template-docs/domain-templates.md`

补充领域模板职责：

- 母模板只提供三层边界和初始化要求。
- 每个领域模板必须维护自己的 L2->L3 场景剧本。
- 领域派生项目应从对应领域模板获取具体创建、同步、整理、自检、回流和发布后同步流程。

### 7.4 `ai/commands/*` 路由说明

建议轻量补充：

- `new-project`：只负责 L1->普通 L3；若用户要创建领域模板，转 A20 / `domain-template-lab`；若用户要创建领域派生项目，读取领域模板剧本。
- `sync-methodology`：只负责从母模板同步通用方法论；领域 L3 同步领域 overlay 应由领域模板脚本 / 剧本处理。
- `submit-proposal` / `submit-feedback`：按 L3->L2、L2->L1 两级回流区分目标仓库。

### 7.5 可选骨架文件

可选新增：

```text
template-docs/domain-derived-scenarios-template.md
```

若新增，应同步更新 `template-sync.json` 和 `check-template.*` 断言。若不新增文件，也应在 A20 / `domain-template-lab` 中列最小章节清单。

## 8. 领域模板自己的 L2->L3 剧本最小章节

每个领域模板应至少包含：

1. **适用性判断**：什么时候直连母模板、什么时候走本领域模板、什么时候不适用。
2. **创建领域派生项目**：过渡期组合流程、成熟期 profile / 领域脚本、初始化后必填事实。
3. **同步领域模板更新**：dry-run / commit、覆盖范围、copy-if-missing、永不覆盖项。
4. **初始化后整理与领域自检**：领域 docs / rules / checklist 填写顺序、advisory / gate 强度。
5. **领域派生项目日常开发**：哪些母模板 A 场景照常适用、哪些任务必须读取领域 overlay。
6. **L3->L2 回流**：领域专属经验回流 L2；跨领域通用经验由 L2 提炼后回流 L1。
7. **领域模板发布后的下游同步**：L2 版本发布、领域 L3 同步、运行记录和验证摘要。

## 9. 当前仓库参考经验

`agent-system-template` 已落地：

- `domain-template-sync.json`
- `scripts/sync-domain-template.*`
- `scripts/check-domain-derived-sync.*`
- `scripts/check-agent-template.*`
- `template-docs/agent-system/agent-system-checklist.md`
- `_examples/single-agent-demo/`

这些资产证明 L2->L3 机制可以在领域模板内试验，也暴露出一个通用缺口：同步清单和自检脚本不足以替代端到端场景剧本。母模板应在 A20 / `domain-template-lab` 阶段就要求新领域模板准备该剧本。

同时，当前 `agent-system-template` 的过渡机制写有 `requires_l1_sync_first=true`，即“普通项目先拿 L1 通用方法论，再叠加 L2 领域 overlay”。这应在母模板里标为 transitional：可用于真实试用，但长期仍应评估相邻同步和 `new-project --profile <domain>`。

## 10. 影响面与版本

- **普通派生项目**：无行为变化；只获得更清晰的“什么时候不需要领域模板”说明。
- **领域模板创建者**：A20 / `domain-template-lab` 输出计划更完整，减少只建脚本不建使用剧本的风险。
- **领域派生项目使用者**：知道应从领域模板获取具体 L2->L3 剧本，而不是要求母模板直接处理领域细节。
- **母模板维护者**：需要更新 `scenario-guides.md`、`domain-template-lab`、`domain-templates` 和少量命令路由说明。
- **Release impact**：文案和路由澄清建议 patch；若新增 `domain-derived-scenarios-template.md` 并纳入同步清单，可评估为 minor。

## 11. 验收建议

母模板落地时建议验证：

```powershell
git diff --check
powershell -ExecutionPolicy Bypass -File scripts\check-markdown-clean.ps1 _proposals template-docs ai\commands ai\prompts\maintainers\23-domain-template-lab.md
powershell -ExecutionPolicy Bypass -File scripts\check-template.ps1
```

如可用 Git Bash，再跑：

```bash
bash scripts/check-template.sh --summary
```

## 12. 待确认项

| ID | 待确认项 | AI 建议 | 建议依据 | 备选方案 | 取舍影响 / 阻塞关系 |
|---|---|---|---|---|---|
| C1 | 是否新增通用骨架文件 | 先不新增，先在 A20 / `domain-template-lab` 加最小章节清单 | 领域模板机制仍是候选 / 演进中；先降低同步面 | 新增 `template-docs/domain-derived-scenarios-template.md` | 新文件更易复用，但需同步清单和自检断言；不阻塞路径矩阵修正 |
| C2 | 是否把 L2->L3 剧本列为领域模板必备资产 | 是 | 没有 L2->L3 使用剧本，领域模板难以被具体项目稳定采用 | 仅作为建议 | 作为建议会继续依赖维护者记忆；建议至少进入 A20 完成判据 |
| C3 | 过渡期是否允许“先母模板 new-project，再叠加领域 overlay” | 允许，但标为 transitional | 当前真实领域模板试验已采用该方式；`new-project --profile <domain>` 仍属远期 | 强制相邻同步，L3 只从 L2 创建 | 更纯粹但当前机制不足；会阻塞真实试用 |
| C4 | 是否拆出独立 A29“领域派生项目创建 / 同步” | 暂不拆，先在路径矩阵与 A2 / A13 分叉中表达 | 避免场景编号膨胀；领域具体剧本由 L2 维护 | 新增 A29 | 更直观但会增加母模板主场景复杂度；可后续再评估 |
