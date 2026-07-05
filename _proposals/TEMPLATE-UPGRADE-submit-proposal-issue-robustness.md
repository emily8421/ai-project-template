# TEMPLATE-UPGRADE：submit-proposal 的 gh issue 创建流程稳健性

> 来源：LUMEN_demo_T2.1（emily8421/LUMEN-DEMO）派生项目回流。
> 上游 issue：`https://github.com/emily8421/ai-project-template/issues/93`。

## 1. 背景与问题

派生项目使用 `submit-proposal` 将本地 `TEMPLATE-UPGRADE-*.md` 回流到模板仓 issue 时，原流程推荐将完整 Markdown 正文传给 `gh issue create --body`，并直接传入 `proposal,from:<派生标识>` 标签。这在 Windows shell、多行 Markdown、代码块、反引号、管道符、美元符号和来源标签缺失场景下不够稳健。

## 2. 目标

1. 使用 `--body-file` 提交提案正文，避免 shell 拆分多行 Markdown。
2. 创建 issue 前检查认证、目标仓权限、重复标题和标签可用性。
3. 来源标签不存在时区分“可创建”和“无权限创建”的处理路径。
4. 创建失败后先搜索是否已生成半成品 issue，避免重复提交。
5. 将 issue URL、标签、模板仓 repo 和提案文件写入续接记录。

## 3. 拟改范围

- `ai/commands/submit-proposal.md`
  - 增加创建前只读预检。
  - 改用 `--body-file`。
  - 增加来源标签创建 / 降级规则和失败恢复。
- `ai/prompts/maintainers/17-submit-proposal.md`
  - 更新可复制 SOP Prompt。
  - 禁止使用 `--body "<提案全文>"` 提交多行 Markdown。
- `template-docs/derived-sync-report-template.md`
  - 在“遇到的问题”中增加 submit-proposal / gh issue create 失败记录项。
- `scripts/check-template.ps1`、`scripts/check-template.sh`
  - 增加断言，防止回退到 `--body "<提案全文>"`。

## 4. 版本影响

建议作为 PATCH 版本发布：增强既有回流流程的稳健性，不改变提案格式。

## 5. 验证计划

1. `git diff --check`。
2. `powershell -ExecutionPolicy Bypass -File scripts/check-template.ps1`。
3. 文本断言：`submit-proposal` 文档包含 `--body-file`、标题搜索、标签降级和失败恢复。

## 6. 归档计划

本提案随对应 PR 落地并关闭 issue #93 后，从 `_proposals/` 移动到 `_archive/proposals/`，并在 issue 中说明处理 PR。
