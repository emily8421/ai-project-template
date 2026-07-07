# 模板优化提案收件箱

`_proposals/` 是 `ai-project-template` 模板仓库专属的本地临时收件箱，用于收集派生项目中沉淀出的、已经去项目化的模板优化提案，也用于模板仓库内直接发起的待处理模板改动提案。GitHub issue 是另一类提案收件箱：派生项目可通过 `submit-proposal` / `submit-feedback` 把提案提交为带 `proposal` / `feedback` 标签的 issue；维护者处理 C1 时必须把 issue 与本目录文件一并纳入汇总。

任何需要修改项目模板的工作，都必须先形成 `TEMPLATE-UPGRADE-*.md` 提案；提案处理完成后应移动到 `_archive/proposals/` 归档。

远端 GitHub issue 是权威评论与关闭状态来源；本地分析以 `_proposals/_remote-issues/` 镜像为稳定输入。维护者处理 C1「提案收件箱」时，必须先刷新必要 issue 镜像，再基于本地镜像和本地提案做去重、冲突和分批计划，避免跨会话重复联网或遗漏上下文。

派生项目不应复制或长期保留本目录；新项目派生时应排除 `_proposals/`。

## 文件命名

建议按以下方式命名：

```text
TEMPLATE-UPGRADE-vX.Y.Z.md        # 提案主体：动机、拟改、版本影响、影响面、落地流程
TEMPLATE-UPGRADE-vX.Y.Z-patch.md  # 可选：具体 patch / old→new 修改建议
```

若同一版本有多个来源或主题，可追加短主题：

```text
TEMPLATE-UPGRADE-vX.Y.Z-proposal-inbox.md
TEMPLATE-UPGRADE-vX.Y.Z-proposal-inbox-patch.md
```

## 回流方式

1. 在派生项目或模板仓库中起草去项目化提案。
2. 回到模板仓库先开维护分支，不要直接在本地 `main` 修改。
3. 将待处理提案文件加入 `_proposals/`，或通过 GitHub issue 提交到模板仓；同一 PR 中也可以先新增提案再落地修改。
4. 模板维护者使用 AI 读取 `_proposals/TEMPLATE-UPGRADE-*.md`、带 `proposal` / `feedback` 标签的 issue，以及标题为 `TEMPLATE-UPGRADE:` 的 open issue；远端 issue 先镜像到 `_proposals/_remote-issues/`，再汇总分析并生成优化计划。
5. 按优化计划修改模板文件，并通过 PR 评审合并。
6. 提案处理完成后，从 `_proposals/` 清理已处理的提案文件，并移动到 `_archive/proposals/` 归档；已处理 issue 应关闭，未处理或延后处理的提案继续留在 `_proposals/` 或保留 issue 标签 / 状态说明。

## 远端 issue 本地镜像

镜像目录固定为 `_proposals/_remote-issues/`，命名为 `issue-<number>.md`。镜像文件至少包含：

```markdown
# GitHub Issue #<number>: <title>

> Source URL:
> State:
> Labels:
> Author:
> Created:
> Updated:
> Mirrored at:
> Mirror status: raw remote issue copy for local triage; GitHub issue remains source of comments and closure state.

## Raw Issue Body
```

刷新规则：

- C1 开始时先读取 `_proposals/TEMPLATE-UPGRADE-*.md` 与既有 `_proposals/_remote-issues/*.md`。
- 再查询远端 open issue：`proposal` 标签、`feedback` 标签、标题匹配 `TEMPLATE-UPGRADE:` 的条目。
- 远端 open issue / PR 统计必须使用稳定过滤：GitHub `/issues` API 会同时返回 issue 与 PR；PowerShell 中应通过 `$null -eq $_.PSObject.Properties['pull_request']` 判断普通 issue，不得只用 `-not $_.pull_request`。若使用 `curl.exe | ConvertFrom-Json`，必须确认顶层数组被正确枚举。
- 若远端 issue 没有镜像，或远端 `updated_at` 晚于镜像中的 `Updated`，先刷新镜像再分析。
- 后续去重、冲突、依赖、分批计划和续接记录优先引用本地镜像路径。
- 关闭、改标签或评论前必须做“列表 + 单项状态复核”：先查 open 列表，再逐个查询准备操作的 issue / PR 单项状态；本地镜像不替代 GitHub issue 的权威状态。

归档规则：Batch 或 PR 合并后，已完全吸收的本地提案移入 `_archive/proposals/`；已关闭且不再参与后续 Batch 的 issue 镜像可随提案归档或在归档说明中列明吸收范围。延后处理的 issue 镜像继续保留，并在对应 proposal 或续接文件中标注后续 Batch。

## 主动新增建议时怎么记提案

若模板修改不是从 `_proposals/` 中已有提案开始，而是人工在当前会话中临时、逐步提出多条新增建议，则：

- 也必须形成 `TEMPLATE-UPGRADE-*.md` 提案记录。
- 不要求“每条建议一份提案”；如果这些建议最终由同一条 PR 落地，优先合并到同一份提案中持续追加。
- 若建议主题不同、版本节奏不同、计划拆成多个 PR，再拆成多份提案。
- 推荐做法：
  1. 先切维护分支
  2. 立即创建或更新一份 `TEMPLATE-UPGRADE-*.md`
  3. 在整个对话过程中持续把新增建议补进这份提案
  4. PR 合并后再归档

换句话说：

- 提案应先生成，再边改边补充；
- 不建议先改完模板、提交完成后，才回头补提案和归档记录。

## AI 汇总要求

模板维护者 AI 处理提案收件箱时，应先读取全部 `TEMPLATE-UPGRADE-*.md`、可选 `*-patch.md`、既有 `_proposals/_remote-issues/*.md`，再查询并刷新带 `proposal` / `feedback` 标签的 issue 以及标题为 `TEMPLATE-UPGRADE:` 的 open issue。镜像完成后再输出优化计划，至少包括：

- 去重：多个提案是否表达同一优化。
- 冲突：是否改同一文件、同一段落或版本号。
- 依赖：是否存在必须先落地的前置改动。
- 分阶段建议：本次合并改，还是拆成多个版本 / 多个 PR。
- 分批治理：一批一范围、报告先行、事实与模板分离、去重可审计、可续接。
- 文件清单：建议新增、修改、删除哪些模板文件。
- 验证方式：需要运行哪些自检或人工审查。

AI 不应直接把派生项目的项目专属内容写入模板；所有落地改动必须保持去项目化。

## 已处理提案

已处理并需要保留记录的提案，归档到 `_archive/proposals/`。本目录仅保留待处理或正在汇总的提案。
