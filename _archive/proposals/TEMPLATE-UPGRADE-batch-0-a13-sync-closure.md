# TEMPLATE-UPGRADE: A13 场景完整闭环说法补充

> 来源：GitHub issue #118（本地镜像：`_proposals/_remote-issues/issue-118.md`）
> 类型：模板优化提案
> 状态：已完成维护者分析，待实施
> 计划批次：Batch 0
> 建议版本：PATCH（建议下一版本 `v1.30.6`）
> 关联 issue：#118

## 1. 背景与问题

A13「同步模板到派生项目」已经在 `template-docs/scenario-guides.md` 中列出完整同步闭环：同步预检、dry-run、同步提交、边界验证、同步后整理、文档体系同步后审计、提案回流收口、项目验证建议和同步报告留痕。

但当前 A13 缺少一句可以直接复述给用户的“完整闭环说法”。当用户说“同步模板 / 更新方法论”时，AI 容易只说明或执行 `sync-methodology`，而没有先用一句话强调后续还必须串联 `post-sync-cleanup`、`docs-system-audit`、提案回流收口和同步报告留痕。

#118 的核心诉求不是新增流程，而是把既有流程显性化成一句稳定话术，降低用户和 AI 漏步骤的概率。

## 2. 现有依据

- `template-docs/scenario-guides.md` A13 说明已包含“边界验证、整理、文档审计、项目验证建议和同步报告留痕”。
- A13 步骤表已包含：`sync-methodology`、`post-sync-cleanup`、`docs-system-audit`、提案回流收口、项目验证建议和同步报告。
- `ai/commands/sync-methodology.md` 已说明该命令用于同步后完整闭环。
- `ai/prompts/maintainers/12-sync-template.md` 已要求先输出标准闭环计划。
- `git-guide.md` 已包含“同步后进入标准闭环”表达。

因此本提案应做小范围话术补强，不应重构同步流程。

## 3. 设计目标

1. **一句话概括完整闭环**：让用户和 AI 能快速识别 A13 的完整执行范围。
2. **减少遗漏步骤**：明确 `sync-methodology → post-sync-cleanup → docs-system-audit → 提案回流收口 → 同步报告留痕` 的顺序。
3. **保持现有结构**：只补充 A13 场景描述和命令索引提示，不改变现有流程。
4. **增加轻量防回归**：通过自检断言避免关键话术后续被误删。

## 4. 拟改范围

| 文件 | 拟改内容 | 是否必须 |
|---|---|---|
| `template-docs/scenario-guides.md` | 在 A13「触发」后增加“完整闭环说法” | 必须 |
| `ai/commands/README.md` | 在 `sync-methodology` 行补充“完整闭环”关键词 | 建议 |
| `scripts/check-template.sh` | 增加 A13 完整闭环关键词断言 | 建议 |
| `scripts/check-template.ps1` | 增加 PowerShell fallback 自检断言 | 建议 |
| `CHANGELOG.md` | 记录 PATCH 变更 | 必须 |
| `VERSION` | 递增 PATCH 版本 | 必须 |

## 5. 建议修改内容

### 5.1 A13 场景补充

建议在 `template-docs/scenario-guides.md` A13 的「触发」行后增加：

```markdown
- **完整闭环说法**：「模板新版已发布，请按 A13 执行完整闭环：sync-methodology → post-sync-cleanup → docs-system-audit → 提案回流收口 → 同步报告留痕。」
```

### 5.2 命令索引补充

建议将 `ai/commands/README.md` 中 `sync-methodology` 的常见说法或说明补充“完整闭环”关键词。例如：

```markdown
| `sync-methodology` | 更新方法论 / 同步模板方法论 / 已同步但没做后续 / 补完同步后流程 / A13 完整闭环 | `git-guide.md` §5、`ai/prompts/maintainers/12-sync-template.md` |
```

### 5.3 自检断言

建议增加轻量断言：

- `template-docs/scenario-guides.md` 包含 `完整闭环说法`。
- `template-docs/scenario-guides.md` 包含 `sync-methodology → post-sync-cleanup → docs-system-audit → 提案回流收口 → 同步报告留痕`。
- `ai/commands/README.md` 包含 `A13 完整闭环` 或同等关键词。

## 6. 版本影响

建议作为 PATCH 版本处理。

理由：

- 不新增命令、不改变同步流程、不改变脚本行为。
- 仅提升场景描述和命令索引的可理解性。
- 影响面局限在 A13 话术和自检断言。

## 7. 验证方式

1. 运行 `git diff --check`。
2. 运行 `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/check-template.ps1`。
3. 如本机 Git Bash 可用，运行 `bash scripts/check-template.sh`。
4. 人工检查 A13：用户能在场景描述中直接看到完整闭环说法。
5. 人工检查命令索引：`sync-methodology` 行能提示 A13 完整闭环。

## 8. Issue 关闭策略

- 实施 PR 合并后关闭 #118。
- 关闭留言建议说明：已在 A13 场景增加完整闭环说法，并在命令索引 / 自检中补充防回归。
- 本地镜像 `_proposals/_remote-issues/issue-118.md` 可随本 proposal 一并归档到 `_archive/proposals/`。

## 9. 非目标

- 不调整 `sync-template` 脚本。
- 不修改 `12-sync-template` 的标准闭环流程。
- 不修改 `git-guide.md` 的同步章节。
- 不处理 #105-#117 文档规范大队列。
- 不制度化“远端 issue 本地镜像机制”；该机制归入 Batch 1 分析。

## 10. 待确认项

| ID | 待确认项 | AI 建议 | 建议依据 | 备选方案 | 取舍影响 / 阻塞关系 |
|---|---|---|---|---|---|
| B0-C1 | 是否同步修改 `ai/commands/README.md` | 建议修改 | 命令索引是自然语言路由入口，能提升触发可见性 | 只改 `scenario-guides` | 改动更少，但入口提示较弱 |
| B0-C2 | 是否增加自检断言 | 建议增加 | 防止关键闭环话术后续被误删 | 不加断言 | 更轻量，但回归保护弱 |
| B0-C3 | 是否实施后归档 issue 镜像 | 建议归档本 proposal 与 `issue-118.md` | 便于后续维护者知道 issue 已处理 | 只关闭远端 issue，不归档镜像 | 本地 `_remote-issues` 会残留已处理项 |
