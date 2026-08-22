# TEMPLATE-UPGRADE: 快速续接输出契约与 Current Action Card

> 来源：模板维护者
> 状态：已落地（v1.67.1，PR #383 squash `3888db9`）
> 目标版本：v1.67.1
> Release impact：patch（已落地）
> Release strategy：单独发布

## 1. 动机

快速续接已经具备本地只读范围、Git 优先和 handoff stale 裁决，但输出只要求若干最小字段。面对包含历史 checkpoint 的 handoff，AI 可能只给出版本和状态摘要，或把多个独立事项混为“下一步”，使接手者无法确定应从哪里开始。

本提案补两个互补机制：

1. `ai/commands/resume.md` 定义固定的恢复摘要输出契约，强制区分唯一下一步、阻塞项和独立 backlog。
2. handoff 在元数据后增加 `Current Action Card`，只记录当前唯一行动起点及其前置条件、停止点和证据。

## 1.1 与既有规则的关系（去重）

- **快速续接模式与 stale 裁决**（`_governance/_archive/proposals/TEMPLATE-UPGRADE-fast-session-resume.md`，已归档）：定义时间盒、本地只读范围和 stale 停止条件。**互补不重复**——本提案不改变读取范围或裁决，只补恢复摘要的输出结构。
- **快速续接优先路由**（`_governance/_archive/proposals/TEMPLATE-UPGRADE-fast-resume-routing.md`，已归档）：确保纯恢复不误入完整任务流程。**互补不重复**——本提案让该路由必读输出契约，不新增平行路由。
- **会话续接 / 中断恢复**（`_governance/_archive/proposals/TEMPLATE-UPGRADE-session-resume.md`，已归档）：确立 Git 优先、主动 / 被动中断和自然语言入口。**层级不同**——本提案只约束恢复答复如何呈现既有判断。
- **handoff 结构**（`_governance/_archive/proposals/TEMPLATE-UPGRADE-session-handoff.md`，已归档）：提供当前任务、进度、计划和恢复命令的基本骨架。**合并入**——本提案在既有骨架顶部增加一个单一行动卡，不复制原有历史记录。
- **运行时元数据边界**（`_governance/_archive/proposals/TEMPLATE-UPGRADE-session-resume-runtime-metadata-boundary.md`，已归档）：限制 CLI 私有状态不得替代项目事实。**互补不重复**——行动卡仍须由 Git、handoff 和项目文档交叉核对。

**本提案不重复它们**：既有机制回答“读什么、何时停止、以谁为准”；本提案补“如何让恢复结论可直接接手执行”。

## 2. 拟改与影响面

| 文件 | 变更 |
|---|---|
| `ai/commands/resume.md` | 新增恢复摘要输出契约，作为格式唯一权威源。 |
| `ai/session-rules.md` | §3.1 强制读取并引用输出契约；推荐 handoff 结构加入行动卡。 |
| `ai/index.md`、`ai/commands/README.md` | 快速续接路由明确读取 `resume.md`。 |
| `template-docs/templates/session-handoff.example.md` | 在元数据后展示行动卡字段。 |
| `.ai/session-handoff.md` | 本地实例新增当前行动卡；不进入正式提交。 |
| `VERSION`、`CHANGELOG.md`、`CHANGELOG-PLAIN.md` | 按 PATCH 记录下行可见的规则增强。 |

不新增同步清单成员、不改脚本行为、不新增自检门禁。`ai/` 规则和 handoff 示例均已在 `template-sync.json` 的 `files_all` 中。

## 3. 设计约束

- 行动卡只能给出一个推荐下一步；没有活跃任务时明确写“无”，不得从历史段落拼凑多个候选。
- 快速续接只报告该动作，不执行它；需要联网、写入或远端操作时仍按原有规则退出快速续接模式。
- handoff 旧的“当前任务 / 下次优先做 / Latest checkpoint”保留为历史与证据，不与行动卡竞争默认决策权。
- handoff 与 Git 冲突时，仍按 `ai/session-rules.md` 的 stale 裁决停止并等待确认。

## 4. 版本影响

建议 `PATCH`：变更只细化既有快速续接与 handoff 机制的输出和导航，不改变默认执行动作、同步结构或派生项目迁移要求。

## 5. 验证方式

1. `git diff --check`
2. `powershell -ExecutionPolicy Bypass -File scripts/check-markdown-clean.ps1 _governance/_proposals ai template-docs CHANGELOG.md CHANGELOG-PLAIN.md`
3. `bash scripts/check-template.sh --summary`
