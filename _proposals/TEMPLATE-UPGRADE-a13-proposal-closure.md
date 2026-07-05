# TEMPLATE-UPGRADE：A13 提案回流收口检查

> 来源：模板维护者。
> 本提案为去项目化模板优化提案，不记录个人账号、邮箱、token、本机路径或派生项目业务细节。

## 1. 背景与问题

派生项目可通过本地 `_proposals/` 或 `submit-proposal` / `submit-feedback` 将模板优化建议回流到模板仓 issue。模板仓处理这些 issue 并发布新版本后，派生项目执行 `sync-methodology` 同步到最新方法论时，需要判断本地提案草稿、续接记录和同步运行记录中的 issue 链接是否已被模板采纳、关闭、延后或仍待处理。

当前 A13 已有检查本地 `_proposals/` 并归档已采纳提案的机制，但对“已提交到模板仓 issue”的提案收口路径不够明确，容易出现：

- issue 已被模板 PR 处理，但派生项目本地草稿仍留在 `_proposals/`；
- issue 已关闭但无法判断是否采纳，AI 误归档；
- 同步运行记录未留下提案回流收口结论。

## 2. 目标

1. 将“提案回流收口检查”明确纳入 A13 同步闭环。
2. 要求扫描本地 `_proposals/`、`.ai/session-handoff.md`、`sync-records/template-sync/` 和模板仓 issue 链接。
3. 对照模板 `VERSION`、`CHANGELOG.md`、PR 记录和 issue 状态判断提案是否已处理。
4. 只有确认已采纳或已有明确决议时才归档；不确定时保留并写入待确认项。
5. 在同步运行记录中新增“提案回流收口”摘要。

## 3. 拟改范围

- `template-docs/scenario-guides.md`
  - A13 步骤表新增“提案回流收口检查”。
  - 完成判据增加“已完成提案回流收口判断”。
- `ai/prompts/maintainers/12-sync-template.md`
  - 扩展第 15 步，明确扫描范围和 issue 判断方式。
  - 要求无法判断时停止归档并写入待确认项。
  - 同步运行记录和最终汇总增加提案回流收口结论。
- `ai/commands/sync-methodology.md`
  - 执行流程和续接要求增加提案回流收口。
- `SOP.md`
  - 增加自然语言入口：“已同步模板，检查回流到模板 issue 的提案是否已处理并可归档”。
- `template-docs/derived-sync-report-template.md`
  - 新增“提案回流收口”章节。

## 4. 版本影响

建议作为 PATCH 版本发布：该优化补强既有 A13 同步闭环和运行记录结构，不改变同步文件边界。

## 5. 影响面

- 派生项目同步模板后，可更稳妥地处理本地提案草稿和已提交 issue 的收口。
- 模板维护者能从派生同步运行记录中看到哪些回流提案已处理、哪些仍待确认。
- 不引入新的远端写操作；查询 issue 只读，归档本地文件仍需按项目写入确认规则执行。

## 6. 验证计划

1. `git diff --check`。
2. `powershell -ExecutionPolicy Bypass -File scripts/check-template.ps1`。
3. 文本检索确认 A13、`sync-methodology`、同步运行记录模板均包含“提案回流收口”。

## 7. 归档计划

本提案随对应 PR 落地后，应从 `_proposals/` 移动到 `_archive/proposals/`。若与其他同步后处理变更合并发布，归档时记录对应 PR / 模板版本。
