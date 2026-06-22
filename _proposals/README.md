# 模板优化提案收件箱

`_proposals/` 是 `ai-project-template` 模板仓库专属的临时收件箱，用于收集派生项目中沉淀出的、已经去项目化的模板优化提案。

派生项目不应复制或长期保留本目录；新项目派生时应排除 `_proposals/`。

## 文件命名

建议按以下方式命名：

```text
TEMPLATE-UPGRADE-vX.Y.md        # 提案主体：动机、拟改、版本号、影响面、落地流程
TEMPLATE-UPGRADE-vX.Y-patch.md  # 可选：具体 patch / old→new 修改建议
```

若同一版本有多个来源或主题，可追加短主题：

```text
TEMPLATE-UPGRADE-vX.Y-proposal-inbox.md
TEMPLATE-UPGRADE-vX.Y-proposal-inbox-patch.md
```

## 回流方式

1. 在派生项目中起草去项目化提案。
2. 回到模板仓库开分支。
3. 将提案文件加入 `_proposals/`。
4. 模板维护者使用 AI 读取 `_proposals/TEMPLATE-UPGRADE-*.md`，汇总分析后生成优化计划。
5. 按优化计划修改模板文件，并通过 PR 评审合并。
6. 提案处理完成后，从 `_proposals/` 清理已处理的提案文件。

## AI 汇总要求

模板维护者 AI 处理本目录时，应先读取全部 `TEMPLATE-UPGRADE-*.md` 与可选 `*-patch.md`，再输出优化计划，至少包括：

- 去重：多个提案是否表达同一优化。
- 冲突：是否改同一文件、同一段落或版本号。
- 依赖：是否存在必须先落地的前置改动。
- 分阶段建议：本次合并改，还是拆成多个版本 / 多个 PR。
- 文件清单：建议新增、修改、删除哪些模板文件。
- 验证方式：需要运行哪些自检或人工审查。

AI 不应直接把派生项目的项目专属内容写入模板；所有落地改动必须保持去项目化。
