# ai/ AI 行为规范

本目录是 **AI 运行时规则区**——给 AI（Claude CLI / Codex CLI / IDE 插件）读的规则，要求**短、准、可执行**。设计说明（why、通俗解释）在 `template-docs/`，不放这里。AI 每次任务先读 `ai/index.md` 路由表。

## 目录概览

| 文件 / 目录 | 是什么 |
|---|---|
| `index.md` | 路由表：AI 先读哪些规则（规则增减只改这里） |
| `global-rules.md` | 跨项目通用规则（AI 编程原则 / 代码规范 / 任务 / 审查 / 目录 / 演进） |
| `document-lifecycle-rules.md` | 文档生命周期（生成 / 追溯 / 裁剪 / 传播 / 横切事实） |
| `session-rules.md` | 会话续接与断点恢复规则 |
| `project-rules.md` | 项目专属规则模板（每项目填写：Phase / 技术栈 / 形态裁剪 / 禁区） |
| `commands/` | 快捷命令路由（`/run ...` → 权威 Prompt / SOP / 脚本） |
| `prompts/` | 详细 Prompt 模板库（按 docs / dev / review / planning / setup / git / maintainers 分） |
| `doc-standards/` | `docs/00-09` 撰写规范镜像（只读、审计基线、由 `sync-template` 刷新） |

> `index.md` 是 AI 入口；各 AI 工具入口（`AGENTS.md` / `CLAUDE.md` / `.cursor/rules/project-rules.mdc`）都只指向 `index.md`。规则正文与设计说明的分工见 `template-docs/template-methodology.md`。
