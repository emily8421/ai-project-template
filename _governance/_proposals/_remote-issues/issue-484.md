# GitHub Issue #484: TEMPLATE-UPGRADE: 同步 PR 收尾件与 squash 合并后边界校验的粒度冲突

> Source URL: https://github.com/emily8421/ai-project-template/issues/484
> State: OPEN
> Labels: proposal, from:LumiOne-Framework
> Author: emily8421
> Created: 2026-10-29T03:18:59Z
> Updated: 2026-10-29T03:18:59Z
> Mirrored at: 2026-10-29
> Mirror status: raw remote issue copy for local triage; GitHub issue remains source of comments and closure state.

## Raw Issue Body

> 来源：LumiOne-Framework（emily8421/LumiOne-Framework）派生项目回流
> Release impact：patch（AI 建议，待维护者确认）
> Release strategy：单独发布

# TEMPLATE-UPGRADE：同步 PR 收尾件与 squash 合并后边界校验的粒度冲突

## 1. 动机

派生项目按 A13 同步闭环（`ai/prompts/maintainers/12-sync-template.md`）执行同步时，除同步提交外通常还会产生若干**SOP 自身要求的收尾提交**：

- 提案回流收口的归档移动（`_governance/_proposals/` → `_governance/_archive/proposals/`，SOP 步骤 16-17）；
- 同步运行记录（`_governance/sync-records/template-sync/*.md`，SOP 步骤 21）；
- 偶发的项目种子文件联动清理（如 `ai/project-rules.md` 中「提案合并并下行同步后本节随之清理」类自清理条款）。

这些收尾件与同步提交进入**同一个 PR**、以规范 subject（匹配 `sync template vX.Y.Z from ai-project-template`）squash 合并后，project-check.yml 的合并后边界校验（`check-derived-sync.sh HEAD`）会把全部收尾件报为「同步清单外变更」→ **每次此类同步在 main 上必然出现一次红 CI**，需人工按 #478 指引对照推送前留痕裁决。

实证链：某派生仓单版本 PATCH 同步（3 提案聚合，无脚本改动），推送前对纯同步提交校验通过并留痕；PR 含同步 + 归档 + 运行记录 3 个提交，squash 合并后 main 校验报 6 项清单外变更，全部为收尾件，同步清单内文件全部合规。早期同步 PR 因 subject 保留分支前缀（正则按 v1.54.3 口径拒绝分支前缀变体）而整体跳过该校验，此摩擦此前未暴露；#478（v1.75.4）统一规范 subject 后，该场景将常态化出现。

## 1.1 与既有规则的关系（去重）

- **#478 校验时点指引**（v1.75.4，git-guide §5 checklist + 12-sync-template 步骤 11）：#478 管「合并后校验失败时如何裁决」（以推送前留痕为准、判定合并粒度伪影、不回改边界）——是裁决口径；本提案管「如何让该场景源头即可校验通过，免去人工裁决与红 CI 噪音」——是机制消除。层级互补，不重复。
- **git-guide §5.5「同步后整理另开分支、不混入同步提交」**：该条已约束 post-sync-cleanup 类整理；本提案把同一原则显式延伸到同步收尾件（归档 / 运行记录），若采纳方向 A 属对该条的补充，不冲突。
- **v1.54.3 ` (#N)` 尾缀容忍**：本提案不改 subject 正则，与该容忍正交。
- **CONTRIBUTING §2 观察·回流**：本提案本身即按该机制起草，不新增回流通道。

## 2. 拟改（两方向，可组合；请维护者裁决）

**方向 A（SOP 指引，零脚本改动）**：在 `12-sync-template.md` 收尾门禁附近与 `git-guide.md` §5.5 各补一句——同步 PR 只含同步提交；提案归档移动、同步运行记录、种子文件联动清理等收尾提交**拆到合并后的后续小 PR / 提交**。合并后 HEAD 即纯同步提交，校验天然通过。代价：每次同步多一个收尾小 PR。

**方向 B（脚本豁免，方向 A 的兜底）**：`check-derived-sync.*` 在 HEAD 校验场景对两类机械收尾件豁免：

1. `_governance/sync-records/**`（SOP 步骤 21 的指定落盘位置）；
2. `_governance/_proposals/` ↔ `_governance/_archive/proposals/` 的成对移动（rename 对）。

边界：**不得**把 `ai/project-rules.md` 等项目种子文件纳入豁免——保护种子文件正是该脚本的职责；种子联动清理仍按方向 A 拆出同步 PR。

## 3. 版本影响

建议 **patch**（方向 A 为治理说明补强；方向 B 为自检脚本兼容性增强，均有先例同级，如 #474 → v1.75.3、#479 → v1.75.4）。不新增能力层级、不改同步清单、不改默认流程、不新增下游强制采用面。

## 4. 影响面

- 全体派生项目的同步闭环流程（`sync-methodology` / A13）与 CI 体验（消除常态性红 CI）；
- `check-derived-sync.*`（仅方向 B）；`project-check.yml` 生成模板（`new-project.sh`）不改——触发机制不变；
- 存量派生项目无迁移义务（方向 A 对未来同步生效；方向 B 为脚本下行同步后自动获得）。

## 5. 验证方式

- 构造 squash 场景：同步提交 + 收尾提交合并为单提交后跑 `check-derived-sync HEAD`；
- 方向 A：收尾件拆出后，同步 PR 单提交合并，main 校验应全绿；
- 方向 B：仅 `sync-records/**` 与归档成对移动被豁免；其余清单外文件（含种子文件）仍必须报错；
- subject 正则行为不变（` (#N)` 尾缀容忍保留、分支前缀变体仍拒绝）；
- `check-template.*` 自检通过。
