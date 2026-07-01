# ai-project-template

跨项目复用的 AI 编程项目模板（文档驱动 + 规则分层 + 只增不改）。默认路径：先确认机器能跑模板脚本，再让 AI 多入口生成 / 补齐工程文档体系，最后按 Sprint 小步开发。

## 快速开始

按你需要选一个入口：

- **想让 AI 带我做** → 在项目根目录打开 AI CLI（`Claude CLI` / `Codex CLI`），说一个具体场景或 `/run scenario` ─→ `template-docs/scenario-guides.md`（23 场景剧本，AI 先给「做什么 + 为什么」引导计划，确认后执行）。
- **我知道要做什么，找命令** → `SOP.md` 场景索引 / `ai/commands/README.md` 命令表 / `git-guide.md` git 操作 SOP。
- **想理解模板为什么这么设计** → `template-docs/beginner-guide.md` / `template-docs/template-methodology.md`。

> 第一次用、机器还没装好？先 `scripts/check-prereqs.ps1`（见 scenario-guides A1），缺工具再 `scripts/bootstrap-dev-env.ps1`；装 AI CLI 见 `template-docs/ai-cli-setup.md`；会话续接见 `ai/session-rules.md`。

## 当前版本

当前模板版本见 `VERSION`；完整记录见 `CHANGELOG.md`；维护者发布流程见 `MAINTAINERS.md`；模板治理见 `CONTRIBUTING.md`。

## 目录速览

| 路径 | 作用 |
|---|---|
| `template-docs/` | 手册：scenario-guides（场景引导）、beginner-guide、env-setup、ai-cli-setup、smoke-test、template-methodology 等 |
| `ai/` | AI 行为规范（`index.md` 路由 / `global-rules` / `document-lifecycle-rules` / `session-rules` / `project-rules`）；AI 每次任务先读 `ai/index.md` |
| `ai/commands/` | AI 快捷命令路由（`/run ...`） |
| `ai/prompts/` | 详细 Prompt 模板（按场景拆分） |
| `ai/doc-standards/` | 模板 `docs/00-09` 撰写规范镜像（只读，随模板同步刷新） |
| `docs/` | 项目事实、需求、设计、计划、验证（分区见 `docs/README.md`） |
| `tasks/` | 复杂 Sprint 拆分后的任务单（按需启用） |
| `frontend/` `backend/` `tests/` `docker/` | 代码骨架目录，按项目形态裁剪（见 `ai/project-rules.md §3`） |
| `scripts/` | 新建项目、同步、自检、环境采集脚本 |
| `.github/` | CI 工作流（template-check）+ PR/Issue 模板 |
| `SOP.md` | 操作流程速查（场景→命令） |
| `git-guide.md` | git 操作 SOP（新建/提交/同步/PR） |
| `_examples/` | 已填好的参考样例项目 |
| `_proposals/` | 模板优化提案收件箱 |
| `_archive/` | 已归档提案与旧文档 |
