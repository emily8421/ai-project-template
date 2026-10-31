# GitHub Issue #491: TEMPLATE-UPGRADE：路由表「PR / CI / Git 收尾」行对齐 remote-ci-sop-profile §2 最小必读集，消除双口径

> Source URL: https://github.com/emily8421/ai-project-template/issues/491
> State: OPEN
> Labels: proposal,from:flowkit-derived,
> Author: emily8421
> Created: 2026-10-30T04:06:16Z
> Updated: 2026-10-30T04:06:16Z
> Mirrored at: 2026-10-30T15:26:20Z
> Mirror status: raw remote issue copy for local triage; GitHub issue remains source of comments and closure state.

## Raw Issue Body

> 来源：flowkit-derived（emily8421/flowkit-derived）派生项目回流

# TEMPLATE-UPGRADE：路由表「PR / CI / Git 收尾」行对齐 remote-ci-sop-profile §2 最小必读集，消除双口径

## 1. 动机

派生项目执行 PR / CI / Git 收尾任务（A13 闭环）时，两份权威文档对「必读规则集」给出不一致的清单：

- `ai/index.md` 任务路由表「PR / CI / Git 收尾」行列出 4 份：`template-docs/profiles/remote-ci-sop-profile.md`、`ai/implementation-lifecycle-rules.md`、`ai/project-rules.md`、`ai/commands/README.md`（涉及 Git 流程时另读 `git-guide.md` 相关章节）。
- `template-docs/profiles/remote-ci-sop-profile.md` §2 自称「最小必读 4+1 份」：`ai/rules-core.md`、`ai/session-rules.md` §3.3、`git-guide.md` §1.1·§1.2、SOP A10·C4。

两清单仅 `remote-ci-sop-profile` 与 `git-guide` 相交，其余互不重叠；执行侧为确保合规通常两份都读（实测 6-7 份），AI 难以判断哪份可裁剪，形成固定的双口径读取成本（派生项目 hotspot 实录：2026-08-27 PR #3 合并收尾任务，约 8 份规则/文档读取，其中约 2-3 份源于该双口径）。

## 2. 拟改（两案任选，维护者定）

- **方案 a（推荐）**：`ai/index.md` 路由表该行改为以 `remote-ci-sop-profile.md` §2 为权威入口（如「必读规则包：`template-docs/profiles/remote-ci-sop-profile.md`（按其 §2 最小必读集执行）」，原列文件由 profile §2 内部点名承接），消除两处独立维护。
- **方案 b**：保留路由表现有清单，但在 `remote-ci-sop-profile.md` §2 补一句与路由表的覆盖关系说明（如「本节最小集为路由表该行的等价/超集入口」），使两清单声明从属关系。

同模式排查建议：路由表其余各行若也存在与目标文档自述必读集不一致的情形，可在本次一并核对（未逐行审计，仅实测命中此行）。

## 3. 目标版本影响

- 建议定级 **PATCH**（纯文档口径对齐，不新增机制、不改脚本、不增自检断言；#479 → v1.75.4 同级先例）；最终定级由维护者按 CONTRIBUTING §4 判断。

## 4. 影响面

- 影响文件：`ai/index.md`（方案 a）或 `template-docs/profiles/remote-ci-sop-profile.md`（方案 b），二选一。
- 不影响：脚本、`template-sync.json`、CI 断言、其余路由行。
- 受益场景：所有派生项目 PR / CI / Git 收尾任务的 AI 执行读取成本（每次任务省 2-3 份文件整读）。

## 1.1 与既有规则的关系（去重）

| 既有规则 | 关系类型 | 说明 |
|---|---|---|
| `ai/index.md` §3 章节级标注语义 | 机制相同 / 应用实例 | 本提案是章节级标注/权威入口指向机制在「PR/CI 收尾」行的落地，不新增机制 |
| `ai/session-rules.md` §3.2 同会话规则复用 | 互补不重复 | 本提案减首次路由读取；§3.2 管同会话后续复用，正交 |
| `ai/rules-core.md` §2「长任务 Checkpoint Mode」 | 互补不重复 | 读取集变小不改变 Checkpoint 触发与风险分级语义 |

## 5. 验证方式

- 实测依据：派生项目 `.ai/token-hotspots/2026-08-27-pr3-merge-closure.md`（已提炼入该仓 `_governance/ai-records/token-hotspots/SUMMARY.md` 模式 B）。
- 改后验证：`ai/index.md` 与 `remote-ci-sop-profile.md` §2 两清单一致（grep 核对无未声明的独立必读项）；`scripts/check-template.*` 全量自检通过（路由表/章节标注相关断言不涉改动）。

## 6. 备选方案（已考虑并放弃）

- 「维持现状，执行侧两份都读」：成本固定且随每次 PR 收尾重复发生；双口径还会随任一侧修订继续漂移，对齐成本低于持续容忍成本。
