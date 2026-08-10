# TEMPLATE-UPGRADE: 会话 worktree 登记与恢复可见性

> 来源：模板维护者（2026-08-11，agent-command-preflight P0 实施期间发现 D:\tmp 漂移 worktree）
> 状态：待评审
> 目标版本：待评审后确定（实施时按 patch 评估，见 §10）
> Release impact：none（本提案仅记录分析；若实施，建议按 patch 评估）
> Release strategy：单独发布；不与命令预检或其他模板提案合并

## 1. 摘要

模板已有「多会话并发用 git worktree 防踩踏」的指引（`session-rules §8` / `git-guide §4`），但没有要求会话在恢复时检查 worktree、也没要求把活跃 worktree 登记到续接文件。结果是：一个 CLI / 会话创建的 worktree 及其未提交工作，对其他会话 / CLI 完全不可见，直到有人主动 `git worktree list`。

2026-08-11 实测发现：`D:\tmp\ai-project-template-document-language-style` 是主仓的一个 worktree（分支 `change/document-language-style`，做 `global-rules §10` 文档语言规范），有 7 文件未提交改动，停在旧 HEAD `08d2875`；创建它的会话把提案头部写成「已落地」，但 Git 事实是零提交。主仓和后续会话此前均不知情，属于典型被动中断漂移。

本提案建议把 worktree 纳入会话恢复的只读检查 + 续接文件登记 + 建 / 删 worktree 的登记责任，使活跃 worktree 在跨会话 / 跨 CLI 接手时可见、可续接，不改变 worktree 的 git 语义。

## 2. 事故事实与边界

### 2.1 实际现象

- `git worktree list` 显示两个工作区：主仓 + `D:\tmp\ai-project-template-document-language-style`。
- 后者 `.git` 是指针文件 → 主仓 `.git/worktrees/...`，共享主仓 .git，是 worktree 而非独立 clone。
- 分支 `change/document-language-style`，HEAD `08d2875`（早于主仓 main 的 `9f71aec`）。
- 工作区有 7 文件未提交改动（global-rules / document-lifecycle / rules-core / VERSION / CHANGELOG / CHANGELOG-PLAIN / 归档 README）。
- 其 `_proposals/TEMPLATE-UPGRADE-document-language-style.md` 头部自述「状态：已落地，待验证后归档」「目标版本 v1.60.4」——与 Git 事实（零提交、HEAD 旧）冲突。

### 2.2 直接根因

- 创建该 worktree 的会话（很可能是另一个 CLI）做完改动后未提交就中断；会话状态认知（「已落地」）与 Git 事实（零提交）脱节。
- 后续会话的恢复流程没有检查 worktree，所以「看不见」它。

### 2.3 放大因素

`session-rules §8` 与 `git-guide §4` 只讲「多会话并发应开独立 worktree 防踩踏」，没有：

- 把 `git worktree list` 纳入会话恢复的只读检查；
- 要求续接文件记录活跃 worktree；
- 规定创建 / 移除 worktree 的登记责任。

### 2.4 未发生的事项

- 该 worktree 的工作从未进 main（零提交、零 push、零 PR）。
- 未误覆盖主仓或派生项目文件。
- 未触发网络 / 远端 / 破坏性操作。

## 3. 归因边界

本记录不据此断定特定 CLI、模型或会话有缺陷。任何会话 / CLI 在被动中断（撞 token / 时间上限 / 跨 CLI 接手）时都可能留下未提交的 worktree 工作区。模板应假设 worktree 可能被任意会话创建并中途搁置，靠恢复流程 + 登记机制保证可见，而不是假设「创建者会记得提交」。

## 4. 现有控制与缺口

### 4.1 已有有效控制

- `session-rules §8` / `git-guide §4`：建议多会话并发用 worktree 防踩踏（共享 .git、独立 HEAD）。
- `session-rules §1` 裁决优先级：Git 客观事实 > handoff；被动中断以 Git 为唯一锚点。
- `session-rules §3` 新会话恢复流程：先取 Git 事实（status / log / stash）再读 handoff。

### 4.2 缺口

| 缺口 | 后果 | 当前状态 |
|---|---|---|
| 恢复流程不含 `git worktree list` | 活跃 worktree 对接手会话不可见 | 缺失 |
| handoff 不记活跃 worktree | 跨会话 / 跨 CLI 无法知道「还有一个 worktree 在 D:\tmp」 | 缺失 |
| 无 worktree 建 / 删登记责任 | 创建者搁置后无人知晓，改动悬空 | 缺失 |
| worktree 内的被动中断无专门裁决 | worktree 工作区 freshness 不在 §1 主动 / 被动中断判定范围 | 部分覆盖（§1 通用，未点名 worktree） |

## 5. 目标与非目标

### 5.1 目标

1. 会话恢复时能发现活跃 worktree（不只主工作区），并报告其路径 / 分支 / 是否含未提交改动。
2. 续接文件记录活跃 worktree，使跨会话 / 跨 CLI 接手时可见、可续接。
3. 创建 / 移除 worktree 的会话有登记 / 清理责任。
4. worktree 内被动中断时，handoff 的 worktree 登记让接手会话以 Git 事实重建上下文。

### 5.2 非目标

- 不把 worktree 登记做成 CI 门禁（本地会话状态，不可 CI 化）。
- 不要求 worktree 自动提交 / 自动同步。
- 不改变 worktree 的 git 语义（只加恢复可见性 + 登记）。
- 不把本地 worktree 路径写进 `template-sync.json`（worktree 是本机临时工作区，不进同步清单）。
- 不强制把 worktree 登记进 `ai-records/project-registry/`（registry 是跨机器派生项目登记；worktree 是本地会话级，登记放 handoff）。

## 6. 推荐方案

### 6.1 P0：会话恢复加 `git worktree list` 只读检查

在 `ai/session-rules.md`：

- **§3 新会话恢复流程**：在第 3 步只读状态检查（`git status` / `git log` / `git stash list`）后，加 `git worktree list`；若除主工作区外存在活跃 worktree，向用户报告每个 worktree 的路径 / 分支 / HEAD 是否落后主仓 / 是否含未提交改动，作为恢复上下文的一部分。
- **§3.1 快速续接模式**：最小只读检查清单加 `git worktree list`（低成本，防止快速续接漏看 worktree——本次正是快速续接后进入实施才发现）。

### 6.2 P0：续接文件登记活跃 worktree

在 `ai/session-rules.md`：

- **§6 推荐结构**（handoff 模板）加「## 活跃 worktree」段：路径 / 分支 / 主题 / 未提交改动摘要 / 是否待救回或待丢弃。
- **§1 裁决优先级**补充：worktree 内被动中断时，以该 worktree 的 Git 事实（分支 / HEAD / 未提交 diff）为锚点，handoff 的 worktree 登记仅作意图参考。
- 同步更新 `template-docs/session-handoff.example.md` 加该段示例。

### 6.3 P0：建 / 删 worktree 登记责任

在 `ai/session-rules.md` **§8 多会话并发操作** 与 `git-guide.md` **§4 多会话并发操作** 补充：

- 创建 worktree 的会话，应立即在 handoff「活跃 worktree」段登记（路径 / 分支 / 主题）。
- worktree 工作完成（合并进 main / 明确废弃）后，移除 worktree 并从 handoff 清除登记。
- worktree 中断时，handoff 的登记让接手会话能看见它并按 §1 裁决重建上下文。

### 6.4 P1（可选）：advisory 文档自检

考虑 `check-template.sh` 加一个 advisory（非阻断）：检查 `ai/session-rules.md` 是否包含「活跃 worktree」段说明与 `git worktree list` 检查引用。**注意**：handoff 本身是 gitignored，不作为 check-template 检查对象；自检只针对规则文件是否写明了机制，不扫 handoff 内容。

## 7. 方案比较

| 方案 | 优点 | 不足 | 结论 |
|---|---|---|---|
| 仅在 §8 强调「要记得提交 worktree」 | 改动最小 | 不可执行、不可见、不解决跨会话不可见 | 不采用 |
| 恢复检查 + handoff 登记 + 建 / 删责任（P0） | 跨会话可见、可续接、低成本 | 依赖会话自觉执行 | 采用 |
| 再加 advisory 自检（P1） | 防规则文件漂移 | handoff 不可 CI 化，自检价值有限 | 可选 |
| 把 worktree 登记进 registry | 跨机器可见 | worktree 是本机临时态，registry 是跨机器派生登记，语义不符 | 不采用 |

## 8. 拟改范围（实施批次，非本提案的实际改动）

| 文件 | 拟改内容 |
|---|---|
| `ai/session-rules.md` | §3 / §3.1 加 `git worktree list` 只读检查；§6 handoff 结构加「活跃 worktree」段；§1 补 worktree 被动中断裁决；§8 加建 / 删登记责任 |
| `git-guide.md` | §4 多会话并发补 worktree 建 / 删登记责任 |
| `template-docs/session-handoff.example.md` | 加「活跃 worktree」段示例 |
| `scripts/check-template.sh` / `.ps1`（P1 可选） | advisory 断言 session-rules 含 worktree 登记机制说明 |

`AGENTS.md` / `CLAUDE.md` 保持入口职责，不复制 worktree 细节；`ai/global-rules.md` 不承载会话级 worktree 规则（属 session-rules）。

## 9. 验证与验收

实施后至少覆盖：

| 场景 | 预期 |
|---|---|
| 主仓无活跃 worktree | `git worktree list` 只显示主工作区，恢复正常进行 |
| 主仓有 1 个活跃 worktree（含未提交改动） | 恢复流程报告其路径 / 分支 / HEAD 落后情况 / 未提交改动，并提示用户 |
| worktree 工作已合并、未移除 | 恢复流程提示该 worktree 可清理 |
| 跨 CLI 接手 | 接手会话读 handoff「活跃 worktree」段 + `git worktree list` 交叉核对，重建上下文 |
| 模板自检 | session-rules / git-guide / handoff example 三处 worktree 机制一致，无漂移 |

验收证据：命令、退出码、`git worktree list` 输出摘要。成功路径不回灌完整日志。

## 10. 版本与下行影响

本提案本身不修改同步范围，`Release impact` 为 `none`。

实施时改 `ai/session-rules.md` + `git-guide.md` + `template-docs/session-handoff.example.md`（均在 `template-sync.json` `files_all`），属会话规则方法论补强，不改默认行为、不要求派生迁移、不新增能力层级或下游采用面——按 CONTRIBUTING §4 兼容性默认规则判 `patch`（参考 v1.60.3 token-hotspot 收尾自检强化的 patch 先例）。若 P1 把 advisory 做成阻断门禁或改变恢复默认流程，应重新评估。

下行同步后，活跃派生项目在各自下次同步获得新规则；worktree 是本地态，派生项目按各自需要启用。

## 11. 待确认项

| ID | 待确认项 | AI 建议 | 建议依据 | 备选方案 | 取舍影响 / 阻塞关系 |
|---|---|---|---|---|---|
| C-001 | worktree 登记放 handoff 还是 registry | 放 handoff | worktree 是本机会话级临时态，registry 是跨机器派生登记，语义不符 | 进 registry | 进 registry 扩大 registry 语义、需同步维护；不阻塞评审 |
| C-002 | 是否做 check-template advisory | 做 P1 advisory（只查规则文件含机制说明，不扫 handoff） | 防规则文件漂移；handoff gitignored 不可 CI | 不做 | 不做则依赖文档审计；不阻塞 P0 |
| C-003 | §3.1 快速续接是否也加 worktree list | 加 | 低成本只读，本次正是快速续接后才发现漂移 | 只在完整 §3 加 | 只在 §3 加则快速续接仍可能漏看；不阻塞 |
| C-004 | 是否在 §1 裁决优先级点名 worktree 被动中断 | 点名补充 | worktree 工作区 freshness 需明确锚点 | 只靠 §1 通用条款 | 通用条款不够显式；不阻塞 |

## 12. 完成标准

- 会话恢复（§3 与 §3.1）能在存在活跃 worktree 时报告它们，不只看主工作区。
- 续接文件有「活跃 worktree」段，跨会话 / 跨 CLI 可见。
- 建 / 删 worktree 有登记责任，中断后接手会话能以 Git 事实重建。
- 不引入 CI 门禁、不改 worktree git 语义、不把本地 worktree 写进同步清单。
- 模板规则、git-guide、handoff example 三处 worktree 机制一致，无漂移。
