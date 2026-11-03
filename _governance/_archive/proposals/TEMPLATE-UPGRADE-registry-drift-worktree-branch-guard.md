# TEMPLATE-UPGRADE：registry 对账工具工作区分支守卫——消业务分支检出假阳性 DRIFT

> 来源：模板维护者（2026-11-03 registry 对账例行核对实证）
> Release impact：patch（AI 建议，待维护者确认）
> Release strategy：单独发布（模板仓专用工具增强，不阻塞派生同步窗口）

## 1. 动机（去项目化）

`check-registry-drift.ps1` 比对 registry `Inherited` 与各仓 `<LocalPath>/TEMPLATE-BASE.md`——读的是**工作区文件**。当派生仓工作区检出业务分支（非 main）时，工作区 `TEMPLATE-BASE.md` 是旧基线视图，触发**假阳性 DRIFT**。

2026-11-03 实证：某派生仓工作区停在 Sprint-4 业务分支（工作区 v1.75.5），而 main 实况 v1.76.0 == registry 登记值，工具报 DRIFT 属假阳性。假阳性的代价：①每次都要人工 `git show main:TEMPLATE-BASE.md` 复核，稀释真漂移的信号价值；②叠加「管道退出码劫持」执行坑（`$?` 取尾命令退出码）后，曾致「EXIT=0 全 MATCH」错误结论过审一轮（假阳性行恰被 PS 中文输出 binary 吞行的已知显示问题掩盖，双坑叠加）。

## 2. 拟改（建议）

DRIFT 判定前加**工作区分支守卫**（`scripts/check-registry-drift.ps1` 单文件）：

1. 比对前先取当前分支：`git -C <LocalPath> rev-parse --abbrev-ref HEAD`（只读）。
2. 分支 == `main`：现行逻辑不变。
3. 分支 != `main`：改用 `git -C <LocalPath> show main:TEMPLATE-BASE.md` 读 **main 基线**作为 Repo 比对值——
   - main 基线 == registry → 输出 `MATCH（工作区 <branch>，比对以 main 为准）`，**不计入漂移计数**，附一行提示「工作区不在 main，建议该仓会话收尾切回 main」；
   - main 基线 != registry → 输出真 `DRIFT（main 基线不符，实查回写）`，照常计入。
4. 退出码语义：分支守卫消解的假阳性不算漂移（全真 MATCH 时 EXIT=0）；真 DRIFT 仍 EXIT=1。工具定位不变：advisory、只报不修。

约束：仍纯只读（`rev-parse` / `show` 均只读，不改工作区）；不引入 `check-template` 断言；不改 PowerShell fallback 结构。

## 3. 版本影响

PATCH——模板仓专用工具增强（`scripts/README.md` §1 分类：不下行、不进同步清单），不改变默认行为语义（只消假阳性），无下游采用面变化。先例：v1.75.7 新增工具本体即 PATCH（PR #493）。

## 4. 影响面

- 仅 `scripts/check-registry-drift.ps1` 单文件。
- 同步清单零改动；`scripts/README.md` §4 `TOOL-GOV-001` 登记行无需变更（能力不变、准确性提升）。
- 对账运行频率触发点不变（C1 triage 开头 / 半年度机制审计 / 派生同步窗口收尾）。

## 5. 与既有规则的关系（去重）

- **v1.75.7 工具本体提案**（PR #493）：本提案是其**准确性补强**，不改变定位与触发点，非新机制。
- **registry README「登记快照 ≠ 仓内实况，git 实查为准」口径**：本提案正是把该人工纪律机械化到「分支维度」；Notes 级欠账（如已完成未销账的待办）仍靠人工实查，工具不覆盖——边界不变。
- **维护流程「同步前先读该仓 handoff + git 实查」（09-18 教训）**：不受影响；工具守卫消的是**版本字段的假阳性**，人工实查职责不减轻。

## 6. 验证方式

1. 复现：对工作区在业务分支的派生仓跑现行工具 → 复现假阳性 DRIFT（实施前基线）。
2. 改后实跑同仓：输出 `MATCH（工作区 xx，比对以 main 为准）`、漂移计数 0、EXIT=0。
3. 正常 9 仓（工作区在 main）MATCH 行为不变。
4. 真漂移场景：临时改 registry 一行 → 真 DRIFT、EXIT=1 → 还原。
5. `git diff --check`；PowerShell 语法检查（`-NoProfile` 加载冒烟）。
