# Remote Issue Mirrors

This directory stores raw local mirrors of GitHub proposal / feedback issues for template-maintainer triage.

这些文件是远端 issue 的本地镜像，用于减少重复读取远端正文，并让后续分析像读取 `_proposals/` 文件一样稳定进行。

## Rules

- 镜像文件只代表 `Mirrored at` 时刻的远端 issue 正文，不自动同步。
- GitHub issue 仍是来源、评论和关闭状态的权威记录。
- 后续维护者分析、去重、冲突判断和正式 proposal 深化可引用这些镜像。
- 若远端 issue 有新增评论或正文更新，应刷新对应镜像并更新 `Updated` / `Mirrored at`。
- PR 合并并关闭 issue 后，可将对应镜像连同正式 proposal 归档到 `_archive/proposals/`。

## Naming

```text
issue-<number>.md
```

Example:

```text
issue-118.md
```
