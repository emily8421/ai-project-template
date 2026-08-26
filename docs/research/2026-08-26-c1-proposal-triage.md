# C1 模板提案 Triage 报告：LUMEN 新三提案（#386 / #390 / #392）与收件箱全量复核

> 生成日期：2026-08-26
> 定位：模板维护者决策参考（AI 评估 + 建议）；本报告为只读 triage 结论，本轮未执行任何落地改动；唯一写入为本报告自身与 issue-392 镜像补建。
> 评估基线：`HEAD 85fa319`（= `main`，v1.67.1）、2026-08-26 远端 open issue 实查、本地 `_governance/_proposals/` 3 份提案 + 7 个镜像。
> 前序报告：`docs/research/2026-08-12-c1-proposal-triage-template-proposals.md`（首轮）、`docs/research/2026-08-12-c1-proposal-triage-reassessment.md`（复评）、`docs/research/2026-08-18-c1-proposal-triage-batch-plan.md`（Batch A/B 计划，C-011 已拍板并全部落地为 v1.63.0 / v1.64.0）。本报告不覆盖历史结论。
> 拍板记录：本轮无（Q-A ~ Q-D 待维护者确认，见 §9）。

## 0. 执行摘要

远端 open issue 7 个（全部 `proposal`，无 `feedback`），其中 **#386 / #390 / #392 为 2026-08-25/26 LUMEN 回流的新提案**，未落地、未排期，构成本轮重点；其余 4 个（#290 / #334 / #370 / #374）维持既有 Gate 或待排期。#392 为本轮发现的无镜像新 issue，已按镜像硬门禁先行补建。三份新提案互相零冲突、零依赖，建议聚合为 **Batch A → v1.68.0（MINOR）**，拆 2-3 个 PR 落地；#370 + #374 成对留作 Batch B 候选；#334 / #290 维持暂缓 / DEFER。本地 3 份部分落地提案状态未变。

| 对象 | 处置建议 | 批次 / 版本 |
|---|---|---|
| #386 根目录重组执行层路径核对清单 | 采纳 | Batch A / PR A3 → v1.68.0 |
| #390 doc 元信息指针式默认值 | 采纳 | Batch A / PR A2 → v1.68.0 |
| #392 跨仓角色隔离（会话角色声明） | 采纳（+ triage 发现的 resume.md 契约补句） | Batch A / PR A1 → v1.68.0 |
| #370 代码目录划分依据五条 | 下轮候选 | Batch B（成对 #374） |
| #374 文件治理三层体系 | 下轮候选 | Batch B（成对 #370） |
| #334 Stack Adapter R5 | 维持暂缓（待 ≥2 项目实证；Batch B 可部分吸收） | 延后池 |
| #290 domain docs reorg | 维持 DEFER | 延后池 |
| 本地 inheritance / check-maintainability / governance 剩余 | 维持各自 Gate | 延后池 |

## 1. 评估范围与证据

### 1.1 镜像门禁检查

远端 open issue 7 个（`gh issue list --state open` 实查）：#290 / #334 / #370 / #374 / #386 / #390 / #392，全部带 `proposal` 标签，无 `feedback` 条目。**#392 本地无镜像**（2026-08-26 新开），本轮已按门禁先落镜像再分析；其余 6 个镜像均新鲜。

| 镜像路径 | State | remote Updated | Mirrored at | 新鲜度 |
|---|---|---|---|---|
| `_governance/_proposals/_remote-issues/issue-290.md` | OPEN | 2026-07-29 | 2026-08-21 | fresh |
| `_governance/_proposals/_remote-issues/issue-334.md` | OPEN | 2026-08-12 | 2026-08-21 | fresh |
| `_governance/_proposals/_remote-issues/issue-370.md` | OPEN | 2026-08-18 | 2026-08-21 | fresh |
| `_governance/_proposals/_remote-issues/issue-374.md` | OPEN | 2026-08-19 | 2026-08-21 | fresh |
| `_governance/_proposals/_remote-issues/issue-386.md` | OPEN | 2026-08-25 | 2026-08-26 | fresh |
| `_governance/_proposals/_remote-issues/issue-390.md` | OPEN | 2026-08-26 | 2026-08-26 | fresh |
| `_governance/_proposals/_remote-issues/issue-392.md` | OPEN | 2026-08-26 | **2026-08-26（本轮补建）** | fresh |

全部 7 个 issue 无评论（updatedAt ≈ createdAt），无隐藏讨论。本轮分析全部输入来自上表本地镜像路径与 `_governance/_proposals/TEMPLATE-UPGRADE-*.md`，满足镜像硬门禁。

### 1.2 本地提案

| 提案 | 状态 |
|---|---|
| `_governance/_proposals/TEMPLATE-UPGRADE-domain-template-inheritance.md` | Batch 1-3 已落地（agent-system-template 建仓 + `--domain-template` v1.47.0）；Batch 4 待 Gate：真实派生项目 ≥1（当前 0 个） |
| `_governance/_proposals/TEMPLATE-UPGRADE-governance-handbook-agent-tool-registry.md` | Batch 1（v1.61.6）+ Batch 2（v1.65.1）已落地；Batch 3-5 未授权，维持缓议 |
| `_governance/_proposals/TEMPLATE-UPGRADE-template-check-maintainability.md` | P1 / P2.3 / P2.4 / P2.1 保守版已落地（至 v1.56.13）；P2.1 物理拆分、P2.2 继续观察 |

### 1.3 Git 事实

`main` @ `85fa319`（v1.67.1），工作区干净（除本轮新增：issue-392 镜像 + 本报告，均 untracked）。

## 2. 去重 / 冲突 / 依赖分析

### 2.1 新三提案互相（#386 / #390 / #392）

文件层零交集（template-docs + commands / doc-standards + scaffold / session-rules + CONTRIBUTING），主题层正交（迁移 runbook / 文档元信息写法 / 会话角色纪律）——互不冲突、互不依赖。各提案去重章节完整且经抽查与实际规则吻合（document-lifecycle §5 横切原则、session-rules §3.2/§8 边界、post-sync-cleanup 职责均属实）。

### 2.2 与既有落地项 / 延后项的交叉点

- **#392 × v1.67.1 行动卡机制（时序协调，非冲突）**：#392 拟在 `session-rules.md` §6 `Current Action Card` 加 `Role` 字段——v1.67.1（PR #383）刚完成行动卡改造，`resume.md` 恢复摘要契约已把行动卡定为默认决策入口。落地时 Role 字段须加在 v1.67.1 新结构上，且 `resume.md` 契约应同步一句「跨仓参考时看 Role」——提案未覆盖，落地 PR 需补（Q-D）。
- **#374 × #334（弱依赖，内容重叠）**：#374 §2.2 L2 结构检查「业务层不 import web 框架」与 #334 §2.1 FastAPI Adapter 第 1 条是同一规则的两面（怎么写对 / 怎么检查）。若都落地，L2 检查项应引用 Adapter 条目作规范源，避免两处独立定义漂移；不阻塞各自独立落地。
- **#386 × v1.67.0 project-container（实证已充分）**：提案实证场景（治理目录迁移）在本仓生态已发生两次（zhiyan `8b64df5`、flowkit PR #2 `03b47bd`），且 flowkit 那次真实踩到「方案误判为已正确、实查仍是根级路径」的引用漏改——正是清单第 12 类载体。实证强度高于提案自述（其引用 LUMEN 486 文件迁移）。
- **#386 与 #357（v1.64.0 已落地）**：互补成立（目标态框架 vs 迁移过程 runbook）；与 post-sync-cleanup 命令为「通用清理 vs 目录重组专项」层级关系，提案自述挂接方式（提示一句）合理。
- **#390 与 document-lifecycle §5 / doc-standards project-rules §1**：互补成立（原则层已有权威源定义，缺字段级默认写法）；#356（v1.63.0 已落地）的 00 元信息精简措辞是其子集，#390 升格并统一到 00/08/09 三处 + scaffold。

## 3. 分批落地计划（待拍板）

| Batch | 内容 | 版本 | 理由 |
|---|---|---|---|
| **A（本轮建议立项）** | #392 + #390 + #386 | **一个 MINOR（v1.68.0），拆 2-3 个 PR** | 同批回流、实证新鲜（含本仓生态两例迁移实证）、轻量、零冲突；主题各异故拆 PR，版本聚合成一个 MINOR |
| B（下轮候选） | #370 + #374（成对落地） | MINOR | 两者自声明为两级粒度延伸（目录级 / 文件级）、判断口径同源；#374 的 L2 检查项届时引用 #334 Adapter（若已落地） |
| C（待条件） | #334 Stack Adapter | MINOR | 维持「待 ≥2 项目实证」还是放宽，需拍板（Q-C） |
| 维持 | #290 DEFER；3 份本地提案剩余 Batch | none | 触发条件均未满足（第 2 领域模板未出现、agent-system-template 无派生项目、Batch 3-5 缓议、P2.1/P2.2 观察） |

Batch A 内部 PR 顺序建议：PR A1 = #392（规则类，含 resume.md 契约补句）→ PR A2 = #390（标准 + scaffold）→ PR A3 = #386（runbook + 挂接提示）。三者无文件重叠，顺序仅为评审节奏，非硬依赖。

## 4. 拟修改文件清单（Batch A，执行时核对）

| PR | 文件 | 动作 | 来源 |
|---|---|---|---|
| A1 | `ai/session-rules.md`（新 §3.4 跨仓角色声明，约 15 行；§6 行动卡结构样例加 Role 字段一行） | 修改 | #392 |
| A1 | `ai/commands/resume.md`（恢复摘要契约补「跨仓参考时看 Role」一句） | 修改 | #392 + triage 补充（Q-D） |
| A1 | `CONTRIBUTING.md`（§2 或 §5 加操作发起目录对照表 4 行） | 修改 | #392 |
| A2 | `ai/doc-standards/00-scenario.md` / `08-dev-plan.md` / `09-verification.md`（各 1-2 行「当前状态 / 当前 Phase」写法约束） | 修改 | #390 |
| A2 | docs scaffold `00/08/09` 元信息默认值改指针式（指向 `ai/project-rules.md` §1） | 修改 | #390 |
| A2 | `ai/doc-standards/08/09` 补状态标记收口纪律一行（收口时 grep 全部重述点） | 修改 | #390 §2.3（伴生轻量） |
| A3 | `template-docs/`（根目录重组执行层清单 runbook，12 类载体 + 三段验证纪律；落点二选一见 Q-B） | 新增/并入 | #386 |
| A3 | `ai/commands/post-sync-cleanup.md`（+「同步引入目录布局变更时挂接清单」提示一句） | 修改 | #386 §2.3 |
| 收口 | `template-sync.json`（仅当 #386 走独立 runbook 且决定下行时登记）、`VERSION`、`CHANGELOG.md`、`CHANGELOG-PLAIN.md` | 按惯例 | Batch A 收口 |

> 全部落地 diff 需去项目化：清除 LUMEN 项目名与派生路径（保留「已有派生项目实证」一级表述）。

## 5. 版本影响

**Batch A → v1.68.0（MINOR）**。依据：`ai/doc-standards/*` 与 scaffold 在同步范围内且改变派生项目文档默认生成写法（新下游采用面）；session-rules 新流程纪律（§3.4）下行即生效。符合「minor 必须能说明新的下游采用面或推荐工作流变化」口径；三个提案各自的 MINOR 声明聚合后为一个 MINOR，不叠成三次。

## 6. 验证方式

1. `bash scripts/check-template.sh` 与 `.ps1` 双跑全绿；`check-markdown-clean` 覆盖全部改动文件。
2. scaffold 变更 → 三形态 new-project smoke（`--shape web/docs/cli`），确认指针式元信息默认值入产物。
3. 行为验证（人工）：在派生仓会话要求「做模板 triage」，观察 AI 是否先输出角色切换声明；模板仓 handoff 行动卡确认 Role 字段可辨。
4. 下行影响：6 仓下次同步窗口自然生效；三提案均无断言、无目录变更、无迁移成本。

## 7. 远端 issue 处置计划（均待落地后单独复核执行）

- Batch A 落地合并后关闭：#386 / #390 / #392（关闭前按门禁做「open 列表 + 单项状态」复核）。
- #334 / #370 / #374 / #290 维持 OPEN（暂缓 / 待排期 / DEFER，无动作）。

## 8. 归档计划

- Batch A 落地后：issue-386 / 390 / 392 镜像随吸收说明移入 `_governance/_archive/proposals/_remote-issues/`。
- 未处理的 #334 / #370 / #374 镜像继续留在 `_remote-issues/`；#290 维持 DEFER 不动。
- 本地 3 份部分落地提案继续留在 `_proposals/`（剩余 Batch 未消化完，不归档）。

## 9. 待人工确认项

| ID | 待确认项 | AI 建议 | 建议依据 | 备选方案 | 取舍影响 / 阻塞关系 |
|---|---|---|---|---|---|
| Q-A | Batch A 是否立项（#386 + #390 + #392 → v1.68.0，拆 3 PR） | **立项**，按 A1（#392）→ A2（#390）→ A3（#386）顺序 | 实证新鲜、零冲突、轻量；三提案去重章节经核实无重复 | 只挑其中 1-2 个先落 | 全做 vs 挑做只影响版本聚合节奏，不影响各自可行性 |
| Q-B | #386 落点：独立 `template-docs/` runbook vs 并入 post-sync-cleanup 附录 | **独立 runbook + 入同步清单** | 12 类载体清单约 60 行、按载体组织，塞附录会稀释 post-sync-cleanup 主流程；独立成文可被重组场景直接引用 | 并入附录（少一个同步清单成员） | 独立 = 新下游文件（MINOR 依据更实）；并入 = 同步面不变 |
| Q-C | #334 暂缓条件是否放宽 | **维持待第 2 实证**；Batch B 落地 #374 时把 #334 FastAPI 条目作为 L2 规范源先行部分吸收 | 唯一实证仍是 LUMEN 单项目；提前固化只有 1 个消费者的载体有漂移风险 | 现在落地（+3 新文件） | 现在落地扩大同步面但消费者不足；维持则 #374 L2 检查项暂以 profile 为规范源 |
| Q-D | #392 落地时 `resume.md` 契约同步补「Role 字段跨仓可辨」一句 | 补（随 PR A1 带上） | 行动卡是 v1.67.1 默认决策入口；契约不提 Role 则字段只有登记意义、无消费入口 | 不补 | 不补则 Role 字段形同虚设；补的成本为一句话 |

## 10. 结论

7 个 open issue 中，LUMEN 新三提案（#386 / #390 / #392）实证新鲜、互相正交、去重清晰，建议聚合为 Batch A → v1.68.0（MINOR，3 PR）；#370 + #374 成对留作 Batch B；#334 / #290 / 本地提案剩余维持既有 Gate。#392 镜像本轮已补建。下一步：维护者拍板 Q-A ~ Q-D → 切维护分支 → PR A1 → A2 → A3 → v1.68.0 → 关闭 #386/#390/#392 + 镜像归档（远端操作逐项单独确认）。
