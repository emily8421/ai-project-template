# TEMPLATE-UPGRADE: 方法论同步后的标准闭环流程

> 来源：模板维护者。
> 类型：模板仓库内直接发起的模板优化提案。
> 状态：已处理并归档；v1.27.6 已将派生项目方法论同步升级为同步、边界验证、同步后整理、文档体系审计、项目验证建议和同步报告留痕的标准闭环。
> 覆盖问题：派生项目同步模板方法论后，容易只完成文件同步，忘记按新方法整理项目、审计旧方法生成的文档体系、运行边界验证和形成同步报告。

## 1. 背景与问题

当前模板已经提供多个与方法论同步相关的独立能力：

- `sync-methodology`：同步模板方法论到派生项目。
- `post-sync-cleanup`：同步后整理项目专属内容、README、`project-rules` 与 docs 分区。
- `docs-system-audit`：审计 Scenario → 验证闭环的完整性、一致性和可行性。
- `check-derived-sync`：验收派生项目同步边界。
- `template-docs/derived-sync-report-template.md`：同步运行记录模板。

问题在于这些能力此前主要是“可选串联”。当用户在派生项目中说“更新模板方法论 / 同步模板方法论”时，AI 容易只执行同步本身，然后提示“下一步可做 post-sync-cleanup”。这会导致旧派生项目在拿到新方法论后，忘记按新方法整理项目、忘记重新审核文档体系、忘记评估旧方法生成的 `docs/00-09` 是否需要回梳。

## 2. 设计目标

- 用户说“更新模板方法论”时，AI 默认进入完整同步闭环，而不是只同步文件。
- 同步前先说明全流程：同步、边界验证、整理、审计、验证建议、报告。
- 每一步明确只读 / 写入边界，写入前仍按项目规则等待确认。
- 对旧派生项目，显式检查“旧方法生成内容是否需要按新方法回梳”。
- 形成统一同步报告，记录执行命令、结果、风险、待办、审计摘要和后续动作。
- 统一同步报告路径为 `sync-records/template-sync/`，旧路径仅作兼容读取。

## 3. 已落地范围

- `ai/commands/sync-methodology.md`：把同步流程升级为标准闭环。
- `ai/prompts/maintainers/12-sync-template.md`：增加标准闭环计划、同步后整理、同步后审计、项目验证建议和同步报告更新步骤。
- `ai/commands/post-sync-cleanup.md` / `ai/prompts/maintainers/15-post-sync-cleanup.md`：优先读取 `sync-records/template-sync/`，补充同步报告回写建议。
- `ai/commands/docs-system-audit.md` / `ai/prompts/review/16-docs-system-audit.md`：增加同步后审计模式。
- `template-docs/scenario-guides.md`：增强 A13，明确同步闭环。
- `template-docs/derived-sync-report-template.md`：增加同步后整理摘要、文档体系审计摘要和项目验证建议。
- `git-guide.md`：补充同步后标准闭环与报告路径。
- `scripts/check-template.sh`：增加同步闭环关键断言。
- `VERSION` / `CHANGELOG.md`：版本更新到 v1.27.6 并登记变更。

## 4. 验收口径

- 用户输入“更新模板方法论”时，AI 会先输出完整标准流程，而不是只执行同步命令。
- `sync-methodology` 明确同步后应进入 `post-sync-cleanup`、`docs-system-audit` 和项目验证建议。
- A13 场景清楚描述同步闭环，并指向对应 command / prompt。
- 同步报告路径统一为 `sync-records/template-sync/`，旧路径只兼容读取。
- 同步报告模板能记录整理摘要、文档审计摘要和后续回梳任务。
- 派生项目不会用模板仓 `check-template` 验收普通项目同步。
- 审计能识别“按旧方法生成、需按新方法回梳”的内容，但不会自动把新模板规范强行写入项目事实。

## 5. 风险与缓解

- **流程变长**：采用分阶段确认；同步本身、整理修改、文档回梳分别确认。
- **用户只想快速同步**：允许用户明确选择“只同步，不整理 / 审计”，但记录跳过原因和后续补做建议。
- **审计误把旧文档当错误**：同步后审计模式区分规范基线缺口、兼容差异和项目事实错误。
- **报告路径迁移**：统一新路径，对旧路径只做兼容读取，不再作为推荐写入位置。
