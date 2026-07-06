# Proposal：统一 AI 会话续接点恢复策略，禁止误用 CLI 内部元数据

## 背景

模板已通过 `ai/session-rules.md` 与 `.ai/session-handoff.md` 建立本地会话续接机制，要求 AI 在恢复上下文时结合 Git 客观事实、续接文件和项目文档交叉校验。

在跨 AI CLI / 跨模型测试中，同一项目、同一工作目录、同一规则与同一提示词 `读取续接点`，不同模型表现不一致：部分模型会优先搜索 CLI 私有目录或工具运行时元数据，并基于历史 session、memory、subagent metadata 推断当前任务；另一些模型则严格依据项目规则和 Git 状态恢复。

## 问题

以下工具运行时元数据容易被模型误解为项目续接点：

- `~/.claude/sessions/`
- `~/.claude/projects/`
- `memory/`
- `subagents/`
- cache、trace、history、conversation dump、agent meta 文件

这些信息可能只是当前 CLI 的缓存、历史残留、调试信息或非项目事实。若未经 Git 与项目文档验证即作为续接依据，可能造成：

1. 将历史 session 误认为当前项目状态；
2. 将已结束的 subagent 当作仍在运行；
3. 将旧 memory 误认为最新任务；
4. 恢复不存在的中断任务；
5. 与 Git 实际状态冲突，导致 AI 在错误上下文上继续工作。

## 建议

在 `ai/session-rules.md` 增加“工具运行时元数据边界”硬规则，明确：

- 会话恢复只能优先依据 Git、项目续接文件、项目正式文档和当前用户输入；
- CLI / AI 工具自身产生的 session、memory、subagent、cache 等运行时元数据仅可作为调试信息或用户明确要求时的辅助参考；
- 未经 Git、handoff 或项目文档交叉验证，不得据此推断当前任务、阶段、待办事项或 agent 状态；
- 若确需引用，必须标注来源、可信度和验证状态；无法验证的内容只能标记为“推测信息”。

## 建议落点

- `ai/session-rules.md`：在续接文件裁决优先级后新增“工具运行时元数据边界”。
- `ai/session-rules.md`：在新会话恢复流程中补充“不得先扫描 CLI 私有会话 / Memory / SubAgent / Cache 目录来推断续接点”。
- `CHANGELOG.md` / `VERSION`：作为 PATCH 版本发布。

## 版本级别建议

建议作为 PATCH 发布：该变更不改变模板核心流程、不新增必需产物、不要求派生项目重写文档，只是对既有会话续接机制补充边界约束，提升跨模型 / 跨 CLI 一致性。

## 验收标准

- `ai/session-rules.md` 明确声明工具运行时元数据不得直接作为项目续接依据。
- `读取续接点` 的标准恢复路径仍为：读规则 → Git 状态 → `.ai/session-handoff.md` / `NEXT-STEPS.md` → 项目文档。
- 若模型引用 CLI 内部元数据，必须标注来源、可信度和验证状态。
- 模板自检通过。
