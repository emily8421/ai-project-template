# TEMPLATE-UPGRADE: 合并后收尾第一步纪律（switch main + squash HEAD 核对）

> 来源：模板维护者（pitfall 第十一批 rollup #530 回流候选，2026-11-08 实证，去项目化）
> 状态：候选；待 C1 triage
> 目标版本：待确认
> Release impact：none（本提案入库本身不改变模板版本）；实施建议 patch（现有流程文档措辞补强，不新增门禁）
> Release strategy：单独发布（低强度微调）

## 0. 摘要

`git-guide.md` §3.1 合并后清理段已有 `git switch main → git pull → git branch -d` 命令序列，但只列命令、未规定顺序纪律。实测中 AI 在任务分支上凭惯性直接跑 pull / 删分支：pull 在任务分支空跑（"Already up to date" 输出误导），分支删除被 checkout 占用拒绝，失败即停后逐项纠正。建议把「squash 合并确认后，收尾第一步固定 `git switch main` 并核对 HEAD 为带 ` (#<PR号>)` 尾缀的 squash 提交；分支敏感操作脱离长链单独执行」并入 §3.1，约 2-4 行规则文件微调，不新增脚本、门禁或同步清单变更。

## 1. 动机与实证（去项目化）

1. **实证失败链**：一次 PR squash 合并确认后的收尾轮，执行方未先切回 main 就直接跑 pull 与分支删除。pull 在任务分支上空跑并以 "Already up to date" 误导判断；`git branch -D` 因该分支仍被 checkout（且被 worktree 占用）拒绝。失败即停后逐项纠正（switch → pull ff → 删分支 → 复跑验证），无远端影响。根因是**合并后收尾的第一动作（switch main）不在执行清单的显式顺序位**，凭记忆惯性直接进入后续命令。
2. **家族背景**：该坑属 pitfall 记录「关键前置未进执行清单」家族第三面（时序 / 中间态 / 分支归属），该家族在第九~十一批持续复发。第十一批提炼的模式是「当场修复 ≠ 纪律内化，需操作模板化」——pitfall 记录是收尾自检时才读的被动观察载体，无法在前置位置生效；操作纪律应写进执行清单入口（`git-guide.md` §3.1 正是各类提交任务收尾的标准流程入口）。
3. **squash HEAD 核对的价值**：核对 HEAD 为带 ` (#<PR号>)` 尾缀的 squash 提交，可确认 pull 已实际拉到合并结果（而非停在旧 HEAD），避免在旧 HEAD 上继续做对账复跑、分支删除等后续判断。` (#<PR号>)` 尾缀约定已由 v1.54.3 在脚本层固化（`.sh` / `.ps1` 双语正则），本提案只是把同一约定补进人读流程文档，不引入新约定。

## 1.1 与既有规则的关系（去重）

- **pitfall 第十一批 rollup**（`_governance/ai-records/pitfalls/SUMMARY.md` 第十一批，已入库 #530）：本提案的出处；该处行为纪律已记录并给出回流建议。**指向**——本提案把纪律从观察记录落进操作清单入口，观察记录保持原样。
- **`git-guide.md` §3.1 合并后清理段**（`git-guide.md`，现行 v1.77.1）：已有 `switch main → pull → branch -d` 命令序列。**互补不重复**——有序列、无纪律：未标注 switch main 是第一强制动作、无 squash HEAD 核对、未提示分支敏感操作应脱离长链。本提案补的正是这三点。
- **`git-guide.md` §5 checklist squash 校验时点指引**（v1.75.5 #486 / #478 收窄采纳）：同步 PR 边界校验的 squash 时点裁决（推送前为准、合并后粒度伪影裁决）。**对象不同**——那是同步内容边界校验的时点问题，本提案是合并后本地收尾的动作顺序问题；互不覆盖。
- **registry 漂移工作区分支守卫提案**（`_governance/_archive/proposals/TEMPLATE-UPGRADE-registry-drift-worktree-branch-guard.md`，已归档）：对账工具对「工作区不在 main」输出 MATCH 免计 + 切回提示。**机制不同**——那是工具输出层的提示，本提案是流程文档层的顺序纪律；两者互补。
- **`template-docs/scenario-guides.md` 场景 C4 第 4 行**（`template-docs/scenario-guides.md`，现行）：维护分支 PR 流程收尾行 `git switch main` + `git pull` + 删分支 + 归档，同序列同缺口。**互补不重复**——作为次要落点随主落点顺带评估，不单独扩提案范围。

**本提案不重复它们**：既有载体要么是命令序列（无顺序纪律），要么是被动观察记录（不在前置位置生效）。差异化：把「第一步做什么 + 如何确认已到位 + 哪些操作须隔离执行」作为顺序纪律写进执行清单入口。

## 2. 拟改（C1 triage 前不得视为实施授权）

1. `git-guide.md` §3.1 合并后清理段：在命令块前补顺序纪律——squash 合并确认后，收尾第一步固定 `git switch main && git pull`，并核对 HEAD 为带 ` (#<PR号>)` 尾缀的 squash 提交；分支敏感操作（`branch -d` / `-D`、`push --delete`）不嵌入长链，单独执行。约 2-4 行，不改动既有命令块与 §3.1 其余内容。
2. （可选，随主落点顺带评估）`template-docs/scenario-guides.md` 场景 C4 第 4 行：同步补一句第一步顺序提示，与 §3.1 同口径。

## 3. 版本、影响面与边界

- 候选提案入库：`none`，不修改 `VERSION`、`CHANGELOG` 或同步清单。
- 后续实施：建议 `patch`（流程文档措辞补强，不新增门禁、脚本或同步清单变更）；具体发布级别由 C1、维护者与实际 diff 判定。
- 影响消费者：所有按 §3.1（派生项目日常提交）与场景 C4（维护者 PR 流程）收尾的使用者与维护者；`git-guide.md` 属下行同步范围，派生项目下次同步获得。
- 排除：不改 §5 同步 SOP 与同步边界校验口径、不加 CI 门禁或自检断言、不改 §4 多会话并发 worktree 约定、不重开 #478 squash 校验时点议题。

## 4. 验证与验收建议

1. 人工情景核验：模拟 squash 合并后收尾——按新口径先 switch main + pull + 核对 HEAD 尾缀，再删分支；对照旧顺序（任务分支直跑 pull / 删分支）验证前置动作确实规避该失败链。
2. 实施改动后跑 `git diff --check` 与 Markdown 窄检；`git-guide.md` 属自检防滞后断言覆盖的根入口手册（v1.18 起脚本层锁关键路径引用），实施 PR 的全量自检以非沙箱直跑或 CI 为准，不在受限环境内定性。

## 5. 落地流程

本提案入库 PR → C1 triage（属实性、补强、落点与版本判定）→ 维护者拍板 → 实施 PR（PATCH 发版，如维持 patch 判断）→ 提案归档至 `_governance/_archive/proposals/`。
