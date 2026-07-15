# TEMPLATE-UPGRADE: Capability Packages 与 Profile 契约化治理

> 来源：从 `_proposals/TEMPLATE-UPGRADE-codex-checkpoint-mode-and-remote-sop.md` 的 Batch B / C 抽出；2026-07-15 维护者重新评估，主线 B 经两轮调整后重新聚焦
> 状态：已评估（2026-07-15），分批落地中 —— Batch 1 ✅、Batch 1.5 ✅（`11d8b2c`）、Batch 2.5 ✅（`96a19e2`）已完成（feat/ai-execution-hardening 分支）；下一步 Batch 2 / 3。主线 B 重新聚焦为「AI 上下文定位效率」
> 目标版本：待确认
> Release impact：none（本提案仅文档 / 分析；后续落地为 patch / minor，待维护者确认）
> 一句话：模板变重后用「两条同根因主线」治理——**A 防跑飞**（管"读后不跑飞"：Batch 1.5 传递加固 + 最小必读）、**B AI 定位效率**（管"读前少读定向"：给 AI 配分诊台 = 分层地图 + 路由表执行加固，省 token 防跑飞）。预防性的"给人维护影响域清单"已砍；自检减负保留。

---

## 1. 背景与问题

**已落地**：#195 / PR #205 / #206 / #208 完成了 Codex Checkpoint Mode、远端 / CI / sandbox 防卡死 SOP 和风险分级确认，解决了"AI 执行中如何刹车、汇报、失败即停"的**执行安全**问题。

**遗留问题**：模板越来越重后，两个真实痛点——

1. **AI 跑飞**（执行安全）：长任务失忆、大范围搜索丢锚点、大上下文不确定性。
2. **AI 定位 / 读取成本高**（上下文效率）：AI 每次干活常要"把模板翻一遍"才搞清这事儿归哪块——慢、费 token、又加重跑飞。

两者**同根因**（上下文越重越糟），但阶段不同：① 是"读完后怎么不跑飞"，② 是"读之前怎么少读、定向读"。

**本提案范围**：承接 #195 未落地的后续项（Batch B 能力包契约、Batch C 角色化协作 / worktree）。经 2026-07-15 评估（含 git 耦合数据 + 维护者澄清），主线 B **重新聚焦为「AI 上下文定位效率」**——预防性的"给人维护影响域清单"已砍（与自检重叠、会腐烂），保留自检减负 + 分诊强化。#195 保持聚焦执行安全；本提案后续落地另开 PR、不与 #195 混。

## 2. 目标与非目标

**目标**：

1. 保留分层地图作为**人 AI 共用的分诊底座**（人看全貌、AI 定位层）。
2. 强化 AI 分诊：`ai/index.md` 路由表执行加固（先定位后定向读），降低定位 / 读取的 token 成本。
3. 给自检脚本减负（git 数据证实的真实耦合热点）。
4. 补齐防跑飞传递加固（Batch 1.5 瘦身版，含从主线 B 并入的"最小必读"）。
5. 用 1 个 Profile 作为分诊的首个真实用例（Remote / CI SOP），验证是否真省 token。
6. 保留目录级重组、多 agent 并发为后续评估项，本阶段不默认执行。

**非目标**：

- 不移动 `ai/`、`template-docs/`、`docs/`、`scripts/` 目录。
- 不改 `ai/index.md` 的任务路由行为（只强化执行，不改路由本身）。
- 不改 `template-sync.json`、`VERSION`、`CHANGELOG.md`（除非 Batch 2 自检减负明确授权）。
- 不引入真正并发多 agent 默认流程。
- **不新建"给人维护的影响域清单"**（预防性、与自检重叠、会腐烂——已砍）。
- **不全面铺开契约化**（待 Batch 3 用例结论）。

## 3. 两条治理主线（同根因，分阶段）

> 关键：两个痛点同根因（上下文重），但管的不同——A 管"读后不跑飞"，B 管"读前少读定向"。

| 主线 | 解决什么 | 现状 | 承载 | 批次 |
|---|---|---|---|---|
| **A 防跑飞**（读后） | 长任务失忆、搜索丢锚点、CI / 沙箱失败、codex 易跑飞、大上下文 | ✅ Checkpoint Mode（PR #205/#206）+ Batch 1.5 已落地（`11d8b2c`）：传递 / 触发 / 搜索回锚点 / 最小必读 | Batch 1.5 传递加固 + 最小必读 | Batch 1.5 ✅ |
| **B AI 定位效率**（读前） | AI 每次翻全模板才定位 → 慢、费 token、易跑飞 | 🟡 2026-07-15 重新聚焦（原"给人结构治理"是预防性已砍；真实动机是给 AI 省 token） | 分层地图（人 + AI 共用）+ 路由表执行加固 + 自检减负 | Batch 2.5 ✅（`96a19e2`）/ Batch 2（待）/ Batch 3（待） |

**分治原则**：A 管"读后不跑飞"，B 管"读前少读定向"——同根因、不同阶段，各自独立 PR。本阶段**不推进多 agent / worktree / 角色化并发**（见 §8）。

---

## 4. 主线 A：防跑飞传递加固（Batch 1.5 瘦身版）✅ 已落地（`11d8b2c`）

> 详细 old → new 见 `_proposals/TEMPLATE-UPGRADE-capability-packages-and-profile-contracts-batch1.5-patch.md`。本节是摘要。

**现状**：Checkpoint Mode 已落地（风险分级、失败即停、长输出摘要、远端短轮询）。维护者反馈：改成"只高风险确认"后效率已回升、基本满足需求。

**仍有的真缺口**：

- 规则在文件里、不在执行流里 → codex 长任务中遗忘。
- 大上下文 / 长任务没有自动触发信号。
- 大范围搜索后不回任务原点 → 搜索失忆。
- 必读上下文过重 → 跑飞（需"最小必读"裁剪）。

**方案（瘦身版，零降效）**：

- **A2 codex 传递加固**：Checkpoint 节拍要点前置到 `AGENTS.md` 头部 + 每个 `ai/commands/*.md` 头部。
- **A3 大上下文 / 长任务自动触发**：`ai/rules-core.md` §2 触发条件补一条。
- **搜索回锚点**：`ai/rules-core.md` §4 补一条——搜索批次后必须回任务原点汇报再继续。
- **减重第一原则**：新增规则前先问能否合并 / 删除既有规则。
- **每层最小必读**（从主线 B 并入）：层 N 任务只必读 Core + 本层契约，不预读全模板。

**明确不做（防降效）**：不加"每写入动作强制汇报"、不加"连续无汇报 ≤3 硬上限"、不改 PR #206 的高风险确认规则、不改同步清单 / 默认行为。

---

## 5. 主线 B：AI 上下文定位效率（2026-07-15 重新聚焦）

> 🔁 **重新聚焦**：主线 B 原定位"结构治理 / 给人降低维护全局改"，经评估该目标是**预防性**（给人用的"影响域清单"已砍，见 §5.4）。维护者澄清真实动机是——**降低 AI 协作时的定位 / 读取成本**（每次任务都付、吃 token、加重跑飞），属**当前性**。故主线 B 重新聚焦为"给 AI 配分诊台：先定位后定向读"。

### 5.1 问题（大白话）

AI 干活时常要"把模板翻一遍"才搞清这事儿归哪块——又慢、又费 token、又容易跑飞。要的是：让 AI 先快速判断"归哪块"，再只读那块的文件。

### 5.2 两用的分层地图（人看全貌 + AI 层定位）—— 保留并升级

分层地图天生两用，**保留**：

| 层 | 职责（人看全貌） | 典型文件（AI 定位后只读这块） |
|---|---|---|
| Core | 路由 / 确认边界 / Checkpoint | `ai/index.md`、`rules-core.md`、`session-rules.md`、`project-rules.md` |
| Docs | 需求→文档体系 | `document-lifecycle-rules.md`、`doc-standards/*`、`docs/00-09` |
| Implementation | 文档体系→实现 | `implementation-lifecycle-rules.md`、`commands/run-dev-task.md` |
| Verification | 需求 / 实现→验证 | `docs/09-verification.md`、`template-docs/*report*` |
| Profiles | 可选能力剖面（Web App / Remote·CI SOP / Domain） | `template-docs/web-fullstack-profile.md`、`git-guide.md`、`SOP.md` |
| Governance | 版本 / 同步 / 自检 | `MAINTAINERS.md`、`template-sync.json`、`scripts/check-template.*` |

> 给人：一眼看懂模板分几块、每块干嘛。给 AI：任务落到某层后，只读该层"典型文件"。

### 5.3 分诊策略：地图 + 路由表配合（不新建，复用已有）

| 工具 | 组织方式 | 服务 | 现状 |
|---|---|---|---|
| 分层地图（§5.2） | 按"层" | 人看全貌 + AI 知道任务落在哪层 | 本提案保留升级 |
| `ai/index.md` 任务路由表 | 按"任务类型" | AI 速查"这类活看哪几份" | ✅ 已存在，需强化执行 |

**执行加固（Batch 2.5）**：AI 开工前**必先查 `index.md` 路由表定位**任务类型 / 层，再定向读对应规则包；**禁止未定位的全局 grep / 全量读**。这与主线 A 的传递加固（`AGENTS.md` / `commands` 头部前置）是同一套手段——规则在文件里，要靠入口前置让它进执行流。

### 5.4 与降级结论的关系（砍预防性、留当前性，不矛盾）

| 项 | 处置 | 理由 |
|---|---|---|
| 给人维护的"影响域清单" | ❌ 砍（不变） | 预防性、与 `check-template.*` 自检重叠、会腐烂 |
| 给 AI 定位的"地图 + 路由表" | ✅ 保留 + 强化（本次重新聚焦） | 当前性、省 token、防跑飞 |
| 最小必读 | ➡️ 并入主线 A（不变） | 防跑飞实证价值 |
| 自检减负（Batch 2） | ✅ 保留 | git 数据证实的真实热点 |
| 契约化全面铺开 | ⏸️ 不做 | 待 Batch 3 用例结论 |

### 5.5 备选仍暂缓

目录物理重组（Batch 5 条件触发）、多 agent 角色化（本阶段不推进）——不变。

---

## 6. Capability Package 契约模板

> 定位：供 Batch 3 分诊用例试用；其「必读文件」字段正是 AI 定向读取的依据（服务主线 B）。

每个 Capability Package / Profile 只维护以下契约，不复制完整方法论正文：

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

---

## 7. Profile 试点选择（Batch 3 分诊用例）

### 推荐首个用例：Remote / CI SOP Profile

理由：

- 范围小，主要涉及 `git-guide.md`、`SOP.md`、`ai/session-rules.md`、`ai/commands/README.md` 和自检断言。
- 与 #195 已落地内容天然衔接。
- 低风险：不改变项目文档链、不影响代码脚手架、不引入新目录结构。
- 适合验证分诊：该 Profile 的「必读文件」字段一旦写清，AI 做远端操作时就只读这几份，可直接对比 token / 文件数变化。

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

### 备选：Web App Profile

已有 `template-docs/web-fullstack-profile.md` 和 scaffold experiment protocol，适合做第二个用例。**暂不作为首个**：牵涉面更大；等 Batch 3 结论再定。

---

## 8. 目录重组与多 agent（暂缓项）

> ⏸️ 维护者 2026-07-15 决定本阶段不推进。以下作为后续评估保留。

### 8.1 目录级重组

不建议现在执行。触发条件：Batch 3 用例证明分诊 + 契约有用、且仍不足以降维护成本；已明确哪些文件要拆、哪些入口保持稳定、派生项目同步如何兼容。可能方向：保持 `ai/` 入口稳定仅新增人读索引；或在 `template-docs/` 下新增 Profile contract 文档。不建议直接把 `ai/` 拆成大量子包。

### 8.2 多 agent / 角色化协作

短期只采用角色化流程，不默认真正并发：`Router / Coordinator`、`Editor`、`Verifier`、`Maintainer`。真正并发的前置条件：每个 agent 用独立 `git worktree`；共享状态只依赖 Git、handoff、task 文件、验证记录和 PR / issue 事实；禁止多 agent 同时写同一工作区或同一文件影响域。

---

## 9. 落地路线

> 2026-07-15 主线 B 重新聚焦后批次：A 防跑飞（读后）+ B 定位效率（读前）+ 自检减负。

**总览**：

| 批次 | 主题 | 主线 | 状态 | 风险 |
|---|---|---|---|---|
| Batch 1 | 报告化索引 | — | ✅ 已完成（`5e80e8f`） | none |
| Batch 1.5 | 防跑飞传递加固 + 最小必读（瘦身版） | A | ✅ 已完成（`11d8b2c`） | none |
| Batch 2 | 自检减负（`check-template.*` 双镜像） | B | 待启动 | low |
| Batch 2.5 | 分诊强化（地图升级 + 路由表执行加固） | B | ✅ 已完成（`96a19e2`） | none |
| Batch 3 | Remote / CI SOP 分诊首个用例 | B | 待启动 | low |
| Batch 4 | Web App Profile | B | ⏸️ 等 Batch 3 结论 | low |
| Batch 5 | 目录重组 / 多 agent | — | ⏸️ 暂缓 | high |

**各批次要点**：

- **Batch 1 ✅**：人读 Profile / Capability contract 索引；不改任务路由 / 同步清单 / 默认行为。已落地于 `feat/capability-packages-index` 分支 commit `5e80e8f`（VERSION v1.52.3），待合并 main。
- **Batch 1.5 ✅**：见 §4。已落地于 feat/ai-execution-hardening `11d8b2c`（AGENTS.md / rules-core §2·§4 / commands/README）；patch 文件为 old→new 记录。含从主线 B 并入的"最小必读"。
- **Batch 2（自检减负）**：消除 `scripts/check-template.sh` / `.ps1` 双脚本镜像重复（git 数据：各被改 16 次，最大耦合热点）；单源生成双镜像（CAP-008）。
- **Batch 2.5 ✅（分诊强化）**：已落地于 feat/ai-execution-hardening `96a19e2`——rules-core §4「先查 index.md 路由定位、禁止未定位全局 grep」+ commands/README 引用补分诊（CAP-009 已实施）。注：地图升级（§5.2）属文档层，分诊功能已由规则覆盖，地图保持参考。
- **Batch 3（分诊用例）**：将 `git-guide.md` §1.1 / §1.2、`SOP.md` A10/C4、`ai/session-rules.md` §3.3 写成 Remote / CI SOP 契约（见 §7 草案）；用 CAP-007 标准观察"分诊 + 最小必读"是否真省 token / 提速定位，再决定是否继续（Batch 4）。
- **Batch 4**：基于 `template-docs/web-fullstack-profile.md` 和 `web-app-scaffold-experiment.md` 定义 Web App Profile。**等 Batch 3 结论再启动**。
- **Batch 5**：基于用例效果再决定是否目录重组；若需多 agent，先落 worktree 和角色化边界。

## 10. 验证建议

提案阶段：只运行 Markdown / diff 基础检查；不运行完整模板自检，除非后续改动进入同步范围或规则行为。

落地阶段：

- 若只新增人读 contract 文档，运行 Markdown 清洁检查即可。
- 若修改 `ai/`、`SOP.md`、`git-guide.md` 或自检脚本，运行 `scripts/check-template.*`。
- 若修改 `template-sync.json` 或新增同步范围文件，必须同步更新 Bash / PowerShell 自检断言。
- Batch 2 自检减负本身改自检脚本——需保证双镜像断言一致、CI 不回归。

## 11. 待确认项

| ID | 待确认项 | AI 建议 | 建议依据 | 取舍影响 |
|---|---|---|---|---|
| CAP-001 | Batch 1.5（含最小必读）是否落地 | ✅ 已落地（`11d8b2c`） | 零降效，直击跑飞痛点 | 传递 + 触发 + 搜索汇报 + 最小必读 |
| CAP-002 | ~~给人维护的影响域清单~~ | ❌ 已砍 | 预防性、与自检重叠、会腐烂 | 不再加人工清单层 |
| CAP-007 | Batch 3 分诊用例成功 / 失败标准 | 见下 | 用例替代假设 | 决定是否继续铺（Batch 4） |
| CAP-008 | `check-template.*` 双镜像减负方案 | 单源生成双镜像 | git 数据：自检是最大热点 | 降自检维护成本 |
| CAP-009 | 分诊执行强化落地形式 | ✅ 已落地（`96a19e2`）：rules-core §4 + commands/README | 与主线 A 同套手段；规则要进执行流 | 强制力 vs 上下文重量 |
| CAP-006 | Batch 1.5 落地分支策略 | 单独 PR | 与 capability package 主题正交 | 避免 feat 分支混杂 |

**CAP-007 用例标准（草案）**：

- ✅ 成功（可继续 Batch 4）：Batch 3 落地后，该 Profile 相关任务的"平均读取文件数 / token"相比之前**明显下降**，定位更快，且契约「必读文件」未被违背 / 未腐烂。
- ❌ 失败（停止铺契约）：契约写了但 AI 仍全局读，或契约与实际漂移、无人维护 → 结论为"分诊 / 契约对本模板无效"，主线 B 收敛为仅"分层地图"。

## 12. 下一步

1. ~~Batch 1.5 / 2.5~~ ✅ 已落地（`11d8b2c` / `96a19e2`，feat/ai-execution-hardening 分支）。
2. **Batch 2（自检减负）**：定 `check-template.*` 双镜像减负方案（CAP-008）——下一步。
3. **Batch 3（分诊用例）**：落地 Remote / CI SOP 契约，按 CAP-007 观察——下一步。
4. 两个分支（capability-packages-index / ai-execution-hardening）push + PR 时机，待维护者定。
5. 版本 bump：Batch 1.5 / 2.5 是规则增强，建议 patch（PR 合并时定）。
6. 暂不推进目录重组和真正多 agent 并发（Batch 5）；Batch 4 等 Batch 3 结论。
