# ai-project-template

跨项目复用的 AI 编程项目模板。默认路径是：先准备产品愿景或其他上游输入、采集本机环境，再让 AI 多入口生成 / 补齐工程文档体系，最后按 Sprint 小步开发。

第一次使用模板，先看 `template-docs/beginner-guide.md`；想理解这套模板为什么这样设计，再看 `template-docs/template-methodology.md`。
如果机器还没准备好开发环境，先看 `template-docs/env-setup.md`。
如果要单独安装 `Claude CLI` / `Codex CLI`，看 `template-docs/ai-cli-setup.md`。
如果要验证新手能否从零跑通最小路径，按 `template-docs/smoke-test.md` 执行。
如果要留痕一次烟测结果，使用 `template-docs/smoke-test-report-template.md`。

## 5 分钟最小路径

```bash
bash scripts/new-project.sh my-demo --local --no-remote
cd my-demo
powershell -ExecutionPolicy Bypass -File scripts/collect-env.ps1
```

然后：

1. 把产品愿景写入 `docs/vision/product-vision.md`。
2. 补齐 `docs/env/local-env.md` 的人工确认项。
3. 初填 `ai/project-rules.md` 的项目名称、Phase1 目标、技术栈倾向、运行环境约束和项目形态裁剪。
4. 在 AI CLI 中说“评审输入材料”（或 `/run review-inputs`），让 AI 读取 `ai/commands/` 路由与 `ai/prompts/docs/01-review-inputs.md`；评审通过后说“生成文档体系”（或 `/run generate-docs`）。
5. 人工确认 `docs/03-prd.md` §3 阶段路线图、交付物形态和 `docs/05-tech-spec.md` 的本机 Demo 可行性，再说“执行当前 Sprint”（或 `/run run-dev-task`）。

> Demo / MVP 默认优先在本机运行。若 `docs/env/local-env.md` 显示资源不足，AI 必须在 `docs/05-tech-spec.md` 写明降级 / Mock 策略或服务器资源预案。

## 我该看哪个文件

| 你要做什么 | 看哪里 |
|---|---|
| 第一次使用模板 | `template-docs/beginner-guide.md` |
| 第一次准备开发环境 | `template-docs/env-setup.md` |
| 单独安装 AI CLI 工具 | `template-docs/ai-cli-setup.md` |
| 验证新手最小链路是否跑通 | `template-docs/smoke-test.md` |
| 记录一轮烟测结果 | `template-docs/smoke-test-report-template.md` |
| 理解模板为什么这样设计 | `template-docs/template-methodology.md` |
| 新建项目 | 本 README 的“5 分钟最小路径” |
| 使用 AI 快捷命令 | `ai/commands/README.md` |
| 新 CLI 窗口续接任务 | `ai/session-rules.md` |
| 多入口生成 / 补齐文档体系 | `ai/prompts/docs/00-generate-or-complete-docs.md` |
| 执行第一个 Sprint | `ai/prompts/dev/02-run-task.md` |
| 判断 docs / 代码目录如何裁剪 | `docs/README.md` |
| 查标准操作流程入口 | `SOP.md` |
| 同步模板到派生项目 | `SOP.md`、`git-guide.md` §5 |
| 修改模板本身 | `CONTRIBUTING.md`、`MAINTAINERS.md` |
| 查看完整版本记录 | `CHANGELOG.md` |

## 常用命令

### 派生项目使用者

```bash
# 新建本地烟测项目
bash scripts/new-project.sh my-demo --local --no-remote

# 检查新手环境前置项
powershell -ExecutionPolicy Bypass -File scripts/check-prereqs.ps1

# 一键安装基础开发环境
powershell -ExecutionPolicy Bypass -File scripts/bootstrap-dev-env.ps1

# 新建远端项目
bash scripts/new-project.sh my-demo --visibility private
bash scripts/new-project.sh my-demo --account <GitHub账号> --visibility private

# 派生项目同步模板方法论（在派生项目仓库运行；v1.6.8+ 后续同步）
powershell -ExecutionPolicy Bypass -File scripts/sync-template.ps1 --dry-run
powershell -ExecutionPolicy Bypass -File scripts/sync-template.ps1 --commit
powershell -ExecutionPolicy Bypass -File scripts/check-derived-sync.ps1
```

旧项目首次同步见 `git-guide.md` §5；派生项目同步验收使用 `check-derived-sync`，不要用完整模板自检替代。真实派生同步完成后，建议用 `template-docs/derived-sync-report-template.md` 记录同步运行结果，并将可通用优化点转写为去项目化 `_proposals/TEMPLATE-UPGRADE-*.md`。

### 模板维护者

```bash
# 模板仓库完整性自检（仅在 ai-project-template 模板仓库运行）
powershell -ExecutionPolicy Bypass -File scripts/check-template.ps1

# Bash 完整自检入口（CI 使用同类路径）
bash scripts/check-template.sh
```

Windows 脚本入口选择：

| 入口 | 运行位置 | Git Bash 依赖 | 失败时优先排查 |
|---|---|---|---|
| `scripts/check-template.ps1` | 模板仓库 | 可 fallback 到 PowerShell 结构检查 | 若 Bash 启动失败，先看输出中的 fallback 结果 |
| `scripts/sync-template.ps1` | 派生项目仓库 | 需要 Git Bash | Git for Windows / MSYS 是否可启动 |
| `scripts/check-derived-sync.ps1` | 派生项目仓库 | 需要 Git Bash | Git for Windows / MSYS 是否可启动 |

远端建仓默认优先使用当前 `gh` 已登录账号；只有需要切换账号时，才显式传 `--account`。

## 目录速览

| 路径 | 作用 |
|---|---|
| `template-docs/` | 模板自身的手册、烟测、环境和方法论说明 |
| `ai/` | AI 行为规范；AI 每次任务先读 `ai/index.md` |
| `ai/commands/` | AI CLI 快捷命令路由；用户可说“更新方法论”或 `/run sync-methodology` |
| `ai/session-rules.md` | AI 会话续接与断点恢复规则；本地续接文件不进入提交 |
| `docs/` | 项目事实、需求、设计、计划与验证；分区规则见 `docs/README.md` |
| `tasks/` | 复杂 Sprint 拆分后的任务单 |
| `SOP.md` | 标准操作流程索引 |
| `INIT-PROMPT.md` / `ai/prompts/` | Prompt 索引与按场景拆分的可复制 Prompt 模板 |
| `CONTRIBUTING.md` | 模板变更治理流程 |
| `MAINTAINERS.md` | 模板维护者说明、发布 checklist、同步清单维护规则 |
| `CHANGELOG.md` | 完整版本记录 |
| `template-sync.json` | 下行同步方法论文件清单 |
| `scripts/` | 新建项目、同步模板、自检、环境采集脚本 |
| `_examples/` | 已填好的参考样例项目 |
| `_proposals/` | 模板优化提案收件箱 |

## 轻量项目路径

若项目是小脚本、一次性实验或纯工具库，仍保留基本边界与验证口径即可：

1. 写最小 `docs/vision/product-vision.md`。
2. 运行 `scripts/collect-env.ps1`，确认本机可运行边界。
3. 按 `docs/README.md` 的裁剪表决定是否省略 `docs/06`、`docs/07` 和代码目录。
4. 保留最小版 `docs/03-prd.md`、`04-architecture.md`、`05-tech-spec.md`、`08-dev-plan.md`、`09-verification.md`。
5. 每次只实现一个小任务；验证结果记录到 `docs/09-verification.md` 或当前 Sprint。

## 当前版本

当前模板版本见 `VERSION`。最近版本摘要：

- v1.21.0：新增派生项目模板同步运行记录模板 `template-docs/derived-sync-report-template.md`，真实同步后可记录命令、结果、问题和可回流优化点，并提炼去项目化模板提案。
- v1.20.0：将模板 `docs/00-09` 撰写规范镜像主路径从 `docs/_scaffold/` 迁移为 `ai/doc-standards/`，明确其是 AI 文档标准 / 审计基线而非项目事实；旧路径仅作迁移期兼容。
- v1.19.0：新增 AI CLI 快捷命令路由 `ai/commands/` 与会话续接规则 `ai/session-rules.md`，支持 `/run ...` 或自然语言触发常用 Prompt，并用 `.ai/session-handoff.md` / `NEXT-STEPS.md` 记录断点。
- v1.18.3：增强模板维护性与去个人化；`check-template.sh` 动态校验当前 `VERSION` 与 CHANGELOG 顺序，`git-guide.md` 移除具体账号 / 邮箱事实，README 命令按使用者分组并补 Windows 脚本入口矩阵，`new-project.sh` 生成 `ai/project-rules.md` 首次必填 checklist。
- v1.18.2：`check-template.sh` 增加「防文档滞后」断言，要求 git-guide/SOP/MAINTAINERS 引用 `_scaffold`/16 号审计闭环，杜绝脚本先行、文档滞后再现。
- v1.18.1：根目录操作文档（`git-guide.md` / `SOP.md` / `MAINTAINERS.md` / `README.md` / `CONTRIBUTING.md`）追赶 v1.17–v1.18 的 `_scaffold` / 16 号审计闭环；`git-guide.md §5` 补 `_scaffold` 镜像说明与 `15→16` 闭环。
- v1.18.0：新增 `_scaffold` 规范镜像，下行同步时把模板 `docs/00-09` 撰写规范镜像到派生项目 `docs/_scaffold/`（只读、不覆盖项目事实）。
- v1.17.0：新增 `ai/prompts/review/16-docs-system-audit.md`，用于项目成型后用文档生命周期规则回溯审计整条 PLM 链路，先出报告不改文件。
- v1.16.2：补充模板维护纪律，明确无论是现有提案驱动还是对话中主动提出的模板修改，都必须先切维护分支、同步维护提案记录、合并后再归档。
- v1.16.1：把 `BEGINNER-GUIDE` / `ENV-SETUP` / `AI-CLI-SETUP` / `SMOKE-TEST` / `SMOKE-TEST-REPORT-TEMPLATE` / `TEMPLATE-METHODOLOGY` 等元文档集中迁移到 `template-docs/`（早期版本记录中的旧文件名现已对应 `template-docs/` 下的同名小写文件）。
- v1.16.0：新增 `AI-CLI-SETUP.md`，把 `Claude CLI` / `Codex CLI` 的安装、验证、与公司中转站配置的衔接顺序独立成文档。
- v1.15.1：修正公司中转站说明边界，明确内网手册用于 LeMesh / CC-Switch / 中转代理配置，不替代 `Claude CLI` / `Codex CLI` 的官方安装文档。
- v1.15.0：补充 AI CLI 工具说明，把 `Claude CLI` / `Codex CLI` 纳入新手环境文档；新增公司中转站手册入口，并明确非最小工具优先文档化而非立即脚本化。
- v1.14.0：补充 `ENV-SETUP.md` 的工具说明，明确 Git、Git Bash、PowerShell、gh、Node.js、Python、VS Code、Docker、Java 分别是什么、为什么要装。
- v1.13.0：新增 `SMOKE-TEST-REPORT-TEMPLATE.md`；完善 `new-project.sh` 的默认账号策略，远端建仓优先使用当前 `gh` 登录账号，本地烟测则无需 GitHub 账号。
- v1.12.0：新增 `SMOKE-TEST.md`，把 Windows 下的新手环境检查、本地建项目、环境采集和文档入口验证串成一份独立烟测操作单。
- v1.11.0：新增 `ENV-SETUP.md`、`scripts/check-prereqs.ps1` 和 `scripts/bootstrap-dev-env.ps1`，补上新手环境准备、一键安装和前置检测入口。
- v1.10.0：新增 `BEGINNER-GUIDE.md` 与 `TEMPLATE-METHODOLOGY.md`，把“新手上手”与“模板设计说明”从旧归档文档中解耦；`README.md`、`SOP.md` 和同步清单同步补充新入口。
- v1.9.0：拆分 Prompt Library，`INIT-PROMPT.md` 改为轻量索引，完整 Prompt 按场景迁移到 `ai/prompts/`。
- v1.8.0：新增文档生命周期规则与 `docs/inputs/` 原始输入包，支持多入口生成 / 补齐文档体系，强化全链追溯、变更传播、横切事实一致性和外部文档接入。
- v1.7.1：跟进阶段双维度，修正新项目 README 与样例项目的交付物形态说明，并将样例一致性纳入自检。
- v1.7.0：新增阶段双维度（功能范围 + 交付物形态），强化 vision→docs 的 REQ 全覆盖、产品红线和“声称据实”约束。
- v1.6.9：区分旧派生项目首次同步与 v1.6.8+ 后续同步；新增 `check-derived-sync` 派生边界检查，避免把模板仓库自检用于派生项目验收。
- v1.6.8：新增 `INIT-PROMPT.md` §15「同步后项目整理」，用于派生项目同步方法论后审计 docs 分区、README、project-rules 与运行环境约束。
- v1.6.7：补充模板同步文件的覆盖说明；明确派生项目根 `README.md` 不参与模板下行同步；标准化派生 README 版块；补齐样例 docs 分区结构。

完整记录见 `CHANGELOG.md`。
