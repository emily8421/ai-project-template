# GitHub Issue #392: TEMPLATE-UPGRADE：跨仓角色隔离——派生仓会话中的模板维护者任务显式化（cross-repo role isolation）

> Source URL: https://github.com/emily8421/ai-project-template/issues/392
> State: OPEN
> Labels: proposal, from:LUMEN_demo_T2.1
> Author: emily8421
> Created: 2026-08-26T03:31:49Z
> Updated: 2026-08-26T03:31:49Z
> Mirrored at: 2026-08-26
> Mirror status: raw remote issue copy for local triage; GitHub issue remains source of comments and closure state.

## Raw Issue Body

> 来源：LUMEN_demo_T2.1（emily8421/LUMEN-DEMO）派生项目回流
> 状态：草案（本地起草，待提交模板维护者）

# TEMPLATE-UPGRADE：跨仓角色隔离——派生仓会话中的模板维护者任务显式化（cross-repo role isolation）

## 1. 动机（去项目化）

模板 ↔ 派生是两个独立仓库、两种角色（维护者 / 使用者），但同一 owner 常在**同一台机器、甚至同一个 CLI 会话**里先后触碰两边：派生仓发现问题回流提案（submit-proposal）、维护者在模板仓 triage 落地、派生仓执行下行同步。模板现有规则已覆盖「三方向别混」（上行回流开 issue / 模板治理走 PR / 下行走同步脚本），但**没有约束「在哪个目录开 CLI、什么时点切角色」**。

实证观察（某派生仓会话，2026-08-26）：用户在派生仓 CLI 会话中说「做模板仓提案 triage」，AI 在同一会话内跨目录读取模板仓 handoff 与维护者规则并输出 triage 报告。过程合规（派生仓路由表本身含「模板维护」任务行；两仓 Git 均未被误写），但产生两个结构性风险：

1. **角色混戴不可见**：AI 读着派生仓使用者规则 + 模板仓维护者 handoff 的混合上下文行动，用户无法从会话状态一眼分辨当前是哪个角色在动哪个仓；跨仓操作（模板仓建分支 / 开 PR）与派生仓操作共享同一确认流，误授权面扩大。
2. **维护者任务残留进派生语境**：triage 产出的维护者计划（分批、拟改文件、版本影响）留在派生仓会话上下文与派生 handoff 的 backlog 里；若会话后续继续派生开发，AI 可能带着「模板待改清单」的惯性误判派生仓文件（尤其派生仓内存在同步覆盖件 `MAINTAINERS.md` / `CONTRIBUTING.md` / `ai/prompts/maintainers/*` 副本——在派生仓直接改它们会被下次同步覆盖或冲突）。

根因：**规则定义了「仓库方向」，未定义「会话角色绑定」**。方向约束的是文件流向，角色绑定约束的是「哪个会话、什么声明下可以动哪个仓」；缺后者时，跨仓动作的门槛只剩用户一句话。

对照既有机制的空缺定位：
- `session-rules §3.2` 已有「跨仓库 / 跨角色后规则来源不确定 → 重新读规则」，但它管的是**规则加载**，不管**动作授权与目录建议**；
- `session-rules §8` 多会话并发管的是**同仓多会话**（worktree 隔离），不管跨仓单会话；
- `rules-core` Checkpoint Mode 把跨仓库操作列为高风险需单步确认，但没有「先问该不该在这个会话做」的前置门。

## 1.1 与既有规则的关系（去重）

- **`session-rules §3.2`（同会话规则复用边界）**：管重新读规则的触发条件。本提案是其**前置补充**——在重新读规则之前，先显式声明角色切换与目标仓库，让「跨角色」这个事实对用户可见。层级不同（规则加载 vs 角色授权），互补。
- **`session-rules §8`（多会话并发 / worktree）**：管同仓多会话的 HEAD 踩踏。本提案管**跨仓单会话**的角色清晰性。对象不同（并发隔离 vs 角色隔离）。
- **`rules-core §2`（Checkpoint Mode 高风险单步确认）**：已要求跨仓库操作逐步确认。本提案加一条**入口级前置**（进入前声明），不改变逐步确认粒度。合并入（作为 Checkpoint 跨仓条目的前置句）。
- **`ai/commands/submit-proposal.md` / `submit-feedback.md`**：已定义派生侧回流的合规通道（跨仓开 issue、不动派生文件）。本提案与其一致——回流本就该留在派生会话内做；本提案约束的是回流之外「直接动模板仓」类任务（triage、模板 PR、发版）。互补不重复。
- **三方向原则（回流 issue / 治理 PR / 下行同步，CONTRIBUTING §2）**：管文件流向。本提案管会话与目录选择，是其操作层补全。指向。
- **CLAUDE.md / AGENTS.md 入口**：只声明「本仓角色」，无法感知会话此刻在替谁干活。本提案不修改入口文件。

## 2. 拟改

### 2.1 跨仓角色声明（核心，落 `ai/session-rules.md` 新小节 §3.4）

在派生仓会话中，当用户要求执行**模板维护者任务**（triage 收件箱 / 模板仓建分支改文件 / 模板仓 PR / 模板发版 / 维护者侧同步登记）时，AI 在动手前必须输出一段**角色切换声明**，内容四项：

```text
[角色切换] 使用者 → 模板维护者
目标仓库：<模板仓路径>；当前目录仍是派生仓 <路径>
本轮将动：<模板仓分支 / 文件类别>
建议：<若任务非即时，建议在模板仓目录新开会话执行>
```

声明不是请求许可（用户点单已是授权），是让角色边界**可审计**：会话记录里能定位「从哪句话起在替模板仓干活」。若用户任务**不要求即时执行**（如「下次做 triage」），AI 应建议在模板仓目录开新会话，而不是在本会话挂起维护者任务。

### 2.2 模板仓 handoff 行动卡加 Role 字段（落 §6 推荐结构）

`Current Action Card` 推荐字段增加一行：

```text
- Role: maintainer / derived-user / both（该行动卡所属角色）
```

派生仓会话的 AI 若读到模板仓 handoff（跨仓参考），Role 字段让其一望而知「这是维护者任务，不接续、仅参考」，防止维护者行动卡被派生会话误当作自己的下一步。

### 2.3 操作发起目录对照表（落 `CONTRIBUTING.md` §2 或 §5，一行表）

| 任务 | 建议发起目录 | 理由 |
|---|---|---|
| 上行回流（起草 + submit-proposal 开 issue） | 派生仓 | 提案上下文在派生侧，流程本就设计为免 fork 跨仓 issue |
| 模板治理（triage / 模板 PR / 发版） | 模板仓 | 维护者规则 / handoff / 分支纪律天然在模板仓 |
| 下行同步（sync-template） | 派生仓 | 脚本从派生仓拉取，写入面在派生仓 |
| 同步后整理（post-sync-cleanup） | 派生仓 | 审计对象是派生仓差异 |

违反对照表不禁止（有时用户就是要在一个会话连做），但 AI 应声明（§2.1）并提示风险面（同步覆盖件勿直改）。

### 2.4 派生仓同步覆盖件保护提示（轻量，一句）

派生仓的 `MAINTAINERS.md` / `CONTRIBUTING.md` / `ai/prompts/maintainers/*` 是同步覆盖件；在派生仓会话中若 AI 拟修改这些文件，Checkpoint 确认时必须附带「此为同步覆盖件，直改会被下次同步覆盖，应走回流提案」提示。可并入 §2.1 声明模板或 Checkpoint 口径，不单独成节。

## 3. 版本影响

模板 MINOR：`ai/session-rules.md` 新增 §3.4（跨仓角色声明）+ §6 行动卡 Role 字段；`CONTRIBUTING.md` 加对照表。均为流程纪律，不改同步清单成员、不加 CI 门禁、不强制派生仓迁移（声明是行为约定，无断言）。

## 4. 影响面

- 修改：`ai/session-rules.md`（新 §3.4，约 15 行；§6 结构样例加一行）；
- 修改：`CONTRIBUTING.md`（§2 或 §5 加 4 行对照表）；
- 不改：入口文件（CLAUDE.md / AGENTS.md / .cursor）、`template-sync.json` 成员、脚本、CI；
- 下行同步后即生效；派生仓无迁移成本（新会话自然遵守）。

## 5. 验证方式

- 模板仓：check-template 双跑 + 文档审阅；
- 行为验证（人工）：在派生仓会话要求「做模板 triage」，观察 AI 是否先输出角色切换声明；在模板仓读 handoff 行动卡确认 Role 字段可辨；
- 派生仓实证：提案来源仓本轮会话即首例——因无该机制，triage 在派生会话内直接展开；若机制在先，预期会先声明并建议模板仓新会话。可作为回溯材料。
