# ai-project-template

这是一套**用 AI 按软件工程规范开发软件**的项目模板。

直接让 AI 写代码，往往产出难维护、缺文档、不规范。本模板反过来——先让 AI 按规范生成各阶段工程文档（需求、架构、设计、计划、验证），再让 AI 在这些文档约束下写代码。这样你既能得到完整规范的过程文档，又能让代码符合设计、可审查、可维护。一套模板，跨项目复用。

> **两类读者**：使用者（基于模板做派生项目）看本 `README.md` + `template-docs/beginner-guide.md`；模板维护者（维护本仓库）看 `MAINTAINERS.md`。

## 它能做什么

- **生成工程文档体系**：给 AI 你的需求 / 愿景 / 想法，它按软件工程规范生成需求 → 架构 → 技术方案 →（数据库 → 接口）→ 开发计划 → 验证各阶段文档；支持多种输入起步（愿景 / PRD / SRS / 任务单 / 小工具 brief）。
- **文档约束代码 + 合规审查**：AI 按文档实现，不自由发挥；六维度审查（需求 / 架构 / 技术 / 数据库 / 接口 / 边界）保证代码符合设计、不越出当前阶段。
- **分阶段交付**：把完整设计拆成 Demo → MVP → 产品 增量实现；文档只增不删，随阶段积累演进。
- **场景引导**：在 AI CLI 里说一个具体场景（如「帮我新建项目」「帮我规划阶段」），AI 给「做什么 + 为什么」分步引导计划，确认后执行；按使用者 / 维护者 / 元场景覆盖从零起步到 Phase 升级的完整旅程。
- **跨项目复用 + 经验回流**：一套模板派生多个项目，方法论下行同步统一；派生项目发现的可通用优化能回流模板，惠及所有项目。
- **多 AI 工具 + 会话续接**：支持 `Claude CLI` / `Codex CLI` / IDE 插件；切换工具或新开窗口不丢上下文。

## 快速开始

按你需要选一个入口：

- **想让 AI 带我做** → 在项目根目录打开 AI CLI（`Claude CLI` / `Codex CLI`），说一个具体场景或 `/run scenario` ─→ `template-docs/scenario-guides.md`（覆盖 A0–A24 / C1–C8 / 元场景，AI 先给「做什么 + 为什么」引导计划，确认后执行）。
- **我知道要做什么，找命令** → `SOP.md` 场景索引 / `ai/commands/README.md` 命令表 / `git-guide.md` git 操作 SOP。
- **想理解模板为什么这么设计** → `template-docs/beginner-guide.md` / `template-docs/template-methodology.md`。
- **查术语什么意思** → `template-docs/glossary.md`（PLM / SRS / REQ-ID / Phase / Sprint 等核心术语短定义 + 权威源指针）。

> 第一次用、机器还没装好？先 `scripts/check-prereqs.ps1`（见 scenario-guides A1），缺工具再 `scripts/bootstrap-dev-env.ps1`；装 AI CLI 见 `template-docs/ai-cli-setup.md`；会话续接见 `ai/session-rules.md`。

## 当前版本

当前模板版本见 `VERSION`；完整记录见 `CHANGELOG.md`；维护者发布流程见 `MAINTAINERS.md`；模板治理见 `CONTRIBUTING.md`。

## 目录速览

| 路径 | 作用 |
|---|---|
| `template-docs/` | 手册与人读模板：scenario-guides（场景引导）、beginner-guide、glossary（术语表）、`template-docs/docs-scaffold/`（inputs / vision / 00-09 / design / decisions / research 结构模板）、env-setup、ai-cli-setup、smoke-test、template-methodology、domain-templates（可选·领域模板中间层）等 |
| `ai/` | AI 行为规范（`index.md` 路由 / `global-rules` / `document-lifecycle-rules` / `session-rules` / `project-rules`）；AI 每次任务先读 `ai/index.md` |
| `ai/commands/` | AI 快捷命令路由（`/run ...`） |
| `ai/prompts/` | 详细 Prompt 模板（按场景拆分） |
| `ai/doc-standards/` | 规则 / 审计基线：`docs/00-09` 和 `docs/design/*` 应满足什么标准（只读，随模板同步刷新） |
| `docs/` | 项目事实：需求、设计、计划、验证（分区见 `docs/README.md`） |
| `sync-records/` | 同步运行记录（派生项目记录模板同步过程，与 `docs/` 项目文档分离） |
| `tasks/` | 复杂 Sprint 拆分后的任务单（按需启用） |
| `frontend/` `backend/` `tests/` `docker/` | 代码骨架目录，按项目形态裁剪（见 `ai/project-rules.md §3`） |
| `scripts/` | 新建项目、同步、自检、环境采集脚本 |
| `.github/` | CI 工作流（template-check）+ PR/Issue 模板 |
| `SOP.md` | 操作流程速查（场景→命令） |
| `git-guide.md` | git 操作 SOP（新建/提交/同步/PR） |
| `CONTRIBUTING.md` | 模板变更治理流程（提案→分支→PR→版本→回流→同步） |
| `MAINTAINERS.md` | 模板维护者手册（发布 checklist / 同步清单 / 自检 / README 边界） |
| `INIT-PROMPT.md` | AI 任务入口指针（指向 commands / prompts 索引） |
| `template-sync.json` | 下行同步文件清单（哪些方法论文件同步到派生项目） |
| `_examples/` | 已填好的参考样例项目 |
| `_proposals/` | 模板优化提案收件箱 |
| `_archive/` | 已归档提案与旧文档 |
