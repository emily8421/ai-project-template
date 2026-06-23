# ai-project-template

跨项目复用的AI编程项目模板。新建项目推荐使用 `scripts/new-project.sh` 从 GitHub `main` 派生；不建议手工复制模板文件夹后再改造。

## 快速开始

```text
1. 在模板仓库运行 `bash scripts/new-project.sh <项目名>`，创建派生项目、初始化 Git、首提交并推送远端
2. 进入新项目目录：`cd <项目名>`
3. 运行 `powershell -ExecutionPolicy Bypass -File scripts/collect-env.ps1` 生成 `docs/env/local-env.md`，补齐人工确认项
4. 填写 docs/00-scenario.md ~ 02-srs.md
5. 先填 ai/project-rules.md 的 §1 Phase边界 + §2 技术栈 + §2.5 运行环境与资源约束 + §3 项目形态与文档裁剪（含演示形态；凭 00-02 粗略定即可，作为 03-09 生成的约束）
6. 用 INIT-PROMPT.md 中的“新项目初始化”Prompt，按 §3 的裁剪结果生成 docs/03-09（无数据库则省略 06；无公开接口则省略 07）
7. 人工审核03-09后，补 ai/project-rules.md 的 §4 目录特例 + §5 编码约定与禁区
8. 以下文件直接使用，不需修改：
   ai/index.md、ai/global-rules.md、
   AGENTS.md / CLAUDE.md / .cursor/rules/project-rules.mdc
9. 进入Sprint1
```

`scripts/new-project.sh` 默认使用 `emily8421` 创建私有仓库；如需覆盖，可使用参数或环境变量：

```bash
ACCOUNT=<GitHub账号> VISIBILITY=private bash scripts/new-project.sh <项目名>
bash scripts/new-project.sh <项目名> --account <GitHub账号> --visibility public
TEMPLATE_REMOTE=<模板仓库URL> bash scripts/new-project.sh <项目名>
bash scripts/new-project.sh <项目名> --local --no-remote  # 只创建本地项目，不建远端，适合烟测
```

> **若起点是一份产品愿景文档**（而非从零写 00-02）：完成步骤 1–3 后，直接用 `INIT-PROMPT.md` §0
> 「从产品愿景文档生成完整文档体系」——它会一次性产出 00-09 + design-\* + 阶段建议（含验证计划）；
> 人工只需确认 03 §3 的阶段路线图，即可进入 Sprint1。愿景文档约定放 `docs/vision/product-vision.md`。

### 轻量项目路径

若项目是小脚本、一次性实验、纯工具库或明确不会长期演进的轻量项目，可按以下方式裁剪，但仍需保留基本边界与验证口径：

```text
1. 填写 docs/00-scenario.md ~ 02-srs.md，只写当前要解决的问题与验收口径
2. 运行 `scripts/collect-env.ps1` 生成 `docs/env/local-env.md`，至少确认本机可运行边界
3. 填写 ai/project-rules.md 的 §1 Phase边界、§2 技术栈、§2.5 运行环境与资源约束、§3 项目形态与文档裁剪
4. 保留 docs/03-prd.md、04-architecture.md、05-tech-spec.md、08-dev-plan.md、09-verification.md 的最小版
5. 若无持久化存储，删除 docs/06-db-design.md，并在 ai/project-rules.md §3 声明省略
6. 若无对外接口，删除 docs/07-api-spec.md，并在 ai/project-rules.md §3 声明省略
7. 每次只实现一个小任务；任务完成后把验证结果记录到 docs/09-verification.md 或当前 Sprint
```

轻量路径只减少文档篇幅，不改变“先明确需求与边界，再让 AI 编码”的原则。

## 目录说明

| 路径 | 作用 |
|---|---|
| `ai/index.md` | 路由表，AI每次任务前必读的第一个文件 |
| `ai/global-rules.md` | 跨项目通用规则，逐字复用 |
| `ai/project-rules.md` | 本项目专属规则（Phase边界、技术栈、项目形态裁剪、编码约定与禁区），每个新项目重新填写 |
| `docs/00-09` | 核心文档骨架，00-02人工提供，03-09由AI生成、人工确认；其中06/07按 `ai/project-rules.md` §3 的项目形态可省略 |
| `docs/env/` | 本机运行环境与资源约束，由 `scripts/collect-env.ps1` 生成后人工补充确认项 |
| `docs/vision/` | 产品愿景叙事源文档（人工输入，不直接驱动开发；AI 据此抽取 00-09，见 INIT-PROMPT §0） |
| `tasks/` | 任务单，按需启用（见tasks/README.md） |
| `AGENTS.md` / `CLAUDE.md` / `.cursor/rules/project-rules.mdc` | 三个AI工具的入口文件，均指向`ai/index.md`，不随规则增减而修改（Cursor入口额外带frontmatter以便自动加载） |
| `SOP.md` | 标准操作流程索引，按场景指向权威操作文档与可复制 Prompt |
| `INIT-PROMPT.md` | 常用Prompt模板（初始化/单任务执行/审查） |
| `CONTRIBUTING.md` | 模板变更治理流程（分支→PR→评审→合并，含派生项目回流） |
| `git-guide.md` | git 使用说明（账号体系/起新项目/提交规范/同步/踩坑） |
| `scripts/` | 自动化脚本：`new-project.sh`（起新项目）、`sync-template.sh`（下行同步）、`check-template.sh`（模板自检）、`collect-env.ps1`（采集本机运行环境） |
| `_archive/` | 规范体系设计文档存档，供人查阅，AI不读取，新项目可保留或删除 |
| `_examples/` | 填好的参考样例项目（演示文档填完的样子），仅供对照，新项目可保留或删除 |
| `_proposals/` | 模板优化提案收件箱；模板仓库用于接收派生项目去项目化提案，派生项目用于本地临时起草提案 |

## 方法论同步（模板 ⇄ 项目）

模板的「方法论」文件在模板与各派生项目间双向流动；`ai/project-rules.md` 等**项目专属内容不参与同步**。

**上行（改模板 / 派生项目归纳回流）**：见 `CONTRIBUTING.md`——所有模板改动走「提案 → 分支 → PR → 评审 → 合并 → 归档」，禁止直推 `main`、禁止在派生项目里改 `ai/global-rules.md` 后手动回抄。任何需要修改模板的工作都必须先形成 `TEMPLATE-UPGRADE-*.md` 提案；派生项目发现可通用优化时，先在本项目 `_proposals/` 起草，再回到模板仓库提交到 `_proposals/` 收件箱，由模板维护者汇总分析后落地；已处理提案归档到 `_archive/proposals/`。

**下行（模板 → 项目）**：把下列**方法论文件**从模板覆盖到派生项目，并在项目提交里注明 `sync template vX.Y.Z`（版本号取自根目录 `VERSION`）：

```text
VERSION                   # 整个模板版本（三段式，审计基准）
ai/index.md               # AI 规则索引（新增规则文件时同步路由）
ai/global-rules.md        # 跨项目通用规则（自身版本独立记录）
AGENTS.md                 # Codex / agent 入口，指向 ai/index.md
CLAUDE.md                 # Claude Code 入口，指向 ai/index.md
.cursor/rules/project-rules.mdc # Cursor 入口，指向 ai/index.md 并启用 alwaysApply
SOP.md                    # 标准操作流程索引（场景 -> 权威文档 -> Prompt）
INIT-PROMPT.md            # 常用 Prompt 模板（初始化/单任务/审查）
CONTRIBUTING.md           # 模板变更治理流程
git-guide.md             # git 使用说明
scripts/new-project.sh    # 一键起新项目
scripts/sync-template.sh  # 本下行同步脚本（自举后由它自动完成）
scripts/check-template.sh # 模板自检脚本（入口、文档骨架、同步清单、版本号）
scripts/collect-env.ps1   # 本机运行环境采集脚本
```

手动下行：逐文件覆盖复制 + 提交。自动下行：在派生项目里先执行 `bash scripts/sync-template.sh --dry-run` 只预览差异（不修改工作区、不 stage），确认后执行 `bash scripts/sync-template.sh --commit` 覆盖并提交。审计：比对各项目根目录 `VERSION`，版本落后于模板即需同步。

> 注：`sync-template.sh` 是下行获取，派生项目是接收方；模板的改进只通过上行 PR 产生。

模板仓库改动提交前建议运行：`bash scripts/check-template.sh`，用于检查入口文件、核心文档骨架、同步清单与版本号是否自洽。

### 版本记录

> 模板版本采用三段式 `vMAJOR.MINOR.PATCH`，以根目录 `VERSION` 为单一审计入口。任何会影响下游同步判断的模板合并都应递增版本；多个小改可合并为同一个版本发布。`ai/global-rules.md` 顶部仅记录全局规则自身版本。

- v1.6.4（2026-06-23）：新增 `SOP.md` 标准操作流程索引，按场景汇总新建派生项目、初始化 docs、环境采集、Sprint 执行、审查、模板同步与模板回流等入口；同步更新 README 目录说明、下行同步清单与模板自检规则。
- v1.6.3（2026-06-23）：修正 `scripts/sync-template.sh --dry-run` 的差异预览方向。dry-run 现在按“本地当前文件 → 模板 VERSION”显示统计，与 `--commit` 实际覆盖方向一致，避免将模板新增内容误显示为删除。
- v1.6.2（2026-06-23）：将派生项目新建 / 同步标准 SOP 固化为可复制 Prompt。`git-guide.md` §2 明确新建项目推荐使用 `scripts/new-project.sh` 从 GitHub `main` 派生，`INIT-PROMPT.md` 新增 §14 新建项目 Prompt；`INIT-PROMPT.md` §12 同步 Prompt 改为运行时读取模板 `VERSION`，避免固定版本号。
- v1.6.1（2026-06-23）：增强派生项目下行同步安全性。`scripts/sync-template.sh` 在 fetch 模板后会对比远端最新版脚本与本地脚本，不一致时停止并提示先 bootstrap 最新脚本；`git-guide.md`、`INIT-PROMPT.md` 和 `scripts/check-template.sh` 同步补充该 SOP，避免旧脚本漏同步新文件或错误解析版本。
- v1.6.0（2026-06-23）：新增运行环境与资源约束机制：`scripts/collect-env.ps1` 自动生成 `docs/env/local-env.md`，`ai/project-rules.md` 新增 §2.5，`docs/04` / `docs/05` / `docs/09` 增加运行拓扑、资源评估与本机资源验证，`INIT-PROMPT.md` 新增环境采集 Prompt；同步更新 README、`new-project`、自检脚本、同步清单和 `_examples/`。版本治理改为根目录 `VERSION` 三段式，并规定所有模板修改必须先形成提案、完成后归档到 `_archive/proposals/`。

- v1.5（2026-06-22）：`ai/global-rules.md` §5 明确 `frontend/` 由 `project-rules.md` §3「演示形态」决定，并注明根 `README.md` 是项目件；新增 §9「模板优化反馈」，规定派生项目起草 `TEMPLATE-UPGRADE-*.md`、模板仓库 `_proposals/` 汇总分析与 PR 落地。同期非 global-rules 改动：`ai/project-rules.md` §3 增加「演示形态」必填项；`INIT-PROMPT.md` 增加演示形态推导、README 项目化与模板优化汇总 Prompt；`scripts/new-project.sh` 创建干净 `_proposals/` 起草区并项目化 README；`CONTRIBUTING.md` 升级上行回流流程；`scripts/check-template.sh` 增加 `_proposals` 检查。
- v1.4（2026-06-19）：`ai/global-rules.md` 新增 §8 文档演进规则（积累式：完整骨架+阶段标签+状态，只增不删）；§5 目录标准扩为 00-09（新增 09-verification 验证支柱）、新增 `docs/vision/` 源文档与 `design-*.md` 子系统设计两类语义命名约定。同期非 global-rules 改动：`INIT-PROMPT.md` 新增 §0 愿景→完整文档体系主 prompt、§1/§10 扩至 03-09；`ai/project-rules.md` §5.2 禁区补阶段归属条；`docs/` 00-08 模板补完整需求+阶段标签写法指引、新增 09-verification 模板；`README` 快速开始加愿景起步分支
- v1.3（2026-06-17）：`ai/global-rules.md` §1 文档驱动开发顺序链补充说明（数据库 / API 环节仅按项目形态启用）。同期非 global-rules 改动：修正 `text-cleaner-cli` 样例 README 自相矛盾（原误标 `docs/07` 省略）、`INIT-PROMPT.md` §10 checklist C 对 06/07 加“（如有）”标注、`ai/project-rules.md` §3 补前端持久化指引（localStorage / IndexedDB 等不触发 06）、新增 `md-notes-frontend` 纯前端样例
- v1.2（2026-06-17）：将 `ai/project-rules.md` 的“项目形态与文档裁剪”前置为初始化必填；初始化/单任务 Prompt 改为按条件处理 docs/06、07；`docs/05-tech-spec.md` 不再依赖初始化时尚未填写的编码约定；新增无 DB / 无 API 样例项目
- v1.1（2026-06-16）：Cursor 入口加 frontmatter（`alwaysApply`）；docs 06/07 按项目形态可省略；新增模板版本戳与 docs/03-08 验收 checklist。同期非 global-rules 改动：docs 03-07 预置内容骨架、project-rules 补 §4 编码约定与禁区、`_archive` 两份合并为纯-why 单文档、init 顺序前置（§1/§2 在生成 03-08 前填、§3/§4 审核后补）
- v1.0：初始体系（设计说明见 `_archive/`）

设计说明（这套体系「为什么」这样设计）见 `_archive/AI编程规范体系说明.md`；规则本体（what）在 `ai/global-rules.md` 等 `ai/` 文件中，archive 不重复。
