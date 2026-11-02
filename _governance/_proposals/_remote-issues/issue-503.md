# GitHub Issue #503: TEMPLATE-UPGRADE：同步预检 A 阶段补派生仓自身 origin 新鲜度核验

> Source URL: https://github.com/emily8421/ai-project-template/issues/503
> State: OPEN
> Labels: proposal, from:web-ui-knowledge-base
> Author: emily8421
> Created: 2026-11-02T12:55:00Z
> Updated: 2026-11-02T12:55:00Z
> Mirrored at: 2026-11-02

> 来源：web-ui-knowledge-base（emily8421/web-ui-knowledge-base）派生项目回流

# TEMPLATE-UPGRADE：同步预检 A 阶段补派生仓自身 origin 新鲜度核验

## 1. 动机

2026-10-30 本项目自旧机器迁入后执行 `/run sync-methodology`，用户提出「不确定本项目是否最新」。现行预检两阶段契约的 A 阶段（`ai/prompts/maintainers/12-sync-template.md`）覆盖 Git 仓 / 分支与工作区 / stash / `VERSION` / `TEMPLATE-BASE.md` lineage，但**不含「本地 main vs 本仓 origin/main」的远端新鲜度核验**：

- `git status --short --branch` 显示的 ahead/behind 基于本地 remote-tracking ref，迁移、换机、多机协作场景下可能陈旧；
- 「工作区干净」只说明无未提交改动，不说明没有未拉取的远端提交；
- 同步流程对**上游模板**永远实读远端 `VERSION`（不信任本地记录），对**派生仓自身**却没有对等的远端实读步骤——同一「不信任本地缓存」原则只覆盖了一半。

本次实测：`git fetch origin` + `git rev-list --left-right --count main...origin/main` 结果 0/0 一致（迁移完整、无落差），确认属真实缺口而非误报；若存在 behind>0，同步分支会基于落后 HEAD 创建，同步 PR 将夹带「先拉齐再同步」之外的合并负担。

## 1.1 与既有规则的关系（去重）

- `ai/session-rules.md` §3.1 快速续接明确「不联网、远端未复核」——那是恢复摘要模式的最小只读边界；本提案只改**同步任务**的预检契约，不触碰快速续接模式。
- `12-sync-template.md` 步骤 5 已有「拉取模板 main 读 `VERSION`」——拉的是**上游模板仓**；本提案补的是**派生仓自身 origin**，对象不同、互补。
- `git-guide.md` §5.5「执行前工作区应干净」——干净 ≠ 最新；本提案是其前置补强，不改写该条。
- `sync-methodology` 命令文件的预检两阶段契约段与上述 Prompt 同源，需同批更新（两处同段双写，以 Prompt 为准、命令文件为清单化镜像）。

## 2. 拟改（建议 + 备选）

1. **预检 A 阶段增一项（推荐）**：`git fetch origin` + `git rev-list --left-right --count main...origin/main`（或等价 ahead/behind 实读）；
   - behind > 0 → 停下列待确认：先拉齐 main 再同步（避免同步分支基于落后 HEAD）；
   - ahead > 0 → 记录并提示：本地有未推送提交，同步分支基于本地 HEAD 创建，需人工确认是否先推送 / PR 收口既有工作；
   - 0/0 → pass。属只读检查，不改变 A 阶段「任一关键项失败即停」的语义。
2. **`git-guide.md` §5.5 补一句同口径**（与「工作区应干净」相邻）。
3. **非目标**：不引入 `check-derived-sync` / `check-template` 自检断言；不改同步脚本；不扩大到快速续接模式或其他任务类型的远端检查。

## 3. 版本影响

PATCH（预检清单 +1 项只读检查 + 两处文档各一句；不改同步清单、不新增断言、无脚本改动；先例 #479 / #478 同级）。

## 4. 影响面与验证方式

- 影响面：仅 `ai/prompts/maintainers/12-sync-template.md` 预检契约段与 `ai/commands/sync-methodology.md` 同源镜像段（两处同段双写，以 Prompt 为准）；`git-guide.md` §5.5 一句。不影响同步脚本、`check-derived-sync`、快速续接模式。
- 验证方式：执行 `/run sync-methodology` 时预检 A 阶段输出含 origin ahead/behind 实查一项（0/0 → pass；behind>0 → 停下列待确认）；不引入 `check-template` 自检断言，符合提案「非目标」边界。
- 实证记录：2026-10-30 与 2026-11-02 两轮 v1.75.6 / v1.76.0 同步均在预检中自行执行该检查（均 0/0），缺口持续存在且补查成本为一行命令。
