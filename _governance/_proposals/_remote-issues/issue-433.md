# GitHub Issue #433: TEMPLATE-UPGRADE：CHANGELOG-PLAIN 启发式对项目自有双版本 CHANGELOG-PLAIN 误报

> Source URL: https://github.com/emily8421/ai-project-template/issues/433
> State: OPEN
> Labels: proposal, from:zhiyan-digital-cs-platform
> Author: emily8421
> Created: 2026-09-03T09:37:32Z
> Updated: 2026-09-03T09:37:32Z
> Mirrored at: 2026-09-09
> Mirror status: raw remote issue copy for local triage; GitHub issue remains source of comments and closure state.

## Raw Issue Body

# TEMPLATE-UPGRADE：CHANGELOG-PLAIN 启发式对「项目自有双版本 CHANGELOG-PLAIN」误报

> 来源：zhiyan-digital-cs-platform（emily8421/zhiyan-digital-cs-platform）派生项目回流

## 动机

`sync-template.*` 对根 `CHANGELOG-PLAIN.md` 的启发式检查（大意：文件顶部版本与派生项目本地 `VERSION` 不一致 → 警告「可能仍是母模板内容，请改写为派生项目自有大白话 changelog」）在已按双版本模式完成改写的派生项目中持续误报：

- 该类派生项目的 `CHANGELOG-PLAIN.md` 结构为：顶部「## 项目版本」段（vX.Y.Z 对齐本地 `VERSION`）+ 下方「历史模板同步记录」段（保留母模板历史版本叙事）。启发式取「文件中出现的模板版本号」与本地 `VERSION` 对比，必然不一致。
- 后果：每轮同步都出现同一条警告；且警告的指引（「请把它改写为派生项目自有大白话 changelog」）对该类项目是已完成动作，按指引重做反而会破坏「项目版本 + 模板历史」的双版本结构。
- 观察到连续 2 轮同步（跨不同上游版本）出现同一条误报，非单次环境偶发。

## 拟改

`sync-template.sh` / `sync-template.ps1` 中对 `CHANGELOG-PLAIN.md` 的启发式提示，建议升级为两段判定：

1. 若文件含「## 项目版本」段（或等价结构：第一个版本标题与本地 `VERSION` 一致），判定为「项目自有双版本 CHANGELOG-PLAIN」，提示降级为 info（如「✓ CHANGELOG-PLAIN.md 已确认为项目自有双版本结构，保留不动」）或静默。
2. 仅当未识别到该结构时，保留现状警告（引导改写）。

同时核对 `check-derived-sync.*` 是否存在同类提示，若有则一并统一口径。

## 建议版本

patch 级（仅提示逻辑，不改变同步行为）。

## 影响

- 同步行为零变化：`CHANGELOG-PLAIN.md` 自 v1.69+ 已保留不覆盖，本提案只影响提示文案与误报。
- 受益面：所有采用「项目自有 CHANGELOG + 模板历史保留」双版本结构的派生项目（含 `--preserve-project-version` 模式用户）。
- 风险：判定条件若过宽（如任何文件含「## 项目版本」字样即静默）可能漏报真正未改写的旧项目；建议判定条件同时要求「顶部第一个版本标题 = 本地 `VERSION`」。

## 验证方式

- 判定分支模拟：对三类根 `CHANGELOG-PLAIN.md` 样例验证——① 无「## 项目版本」段的母模板原版 → 保持现状警告（默认分支行为不变）；② 含「## 项目版本」段且顶部第一个项目版本标题与本地 `VERSION`一致 → 降级为 info / 静默；③ 含该段但版本不一致 → 提示版本漂移（而非引导改写）。
- 回归：`check-template.*` 模板仓自检与既有同步 e2e 应保持通过（仅提示逻辑新增分支，同步行为零变化）。
- 实测：在采用双版本结构的派生项目跑 `--dry-run`，确认不再出现「请改写」类警告。

## 与既有规则关系（去重）

- 与 v1.69.0「模板同步保留派生项目 `CHANGELOG-PLAIN.md`，不再覆盖」语义一致，是其后置提示逻辑的识别精度问题，不新增机制。
- 与 `TEMPLATE-BASE.md` 双版本记录、`project-check.yml` 版本一致性校验不冲突；不涉及 `check-template` 断言变更。
- 未发现既有提案覆盖同一问题（派生项目 `_governance/_archive/proposals/` 与上轮同步记录中无同题提案）。
