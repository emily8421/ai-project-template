# TEMPLATE-UPGRADE：根级命名空间三分与点目录治理（准入清单 + .ai 内部白名单 + tmp 统一）

> 来源：模板维护者会话（2026-08-26，用户提出「点目录/下划线目录的规范与约束」问题，评估获认可）
> 提案日期：2026-08-26
> 目标文件：`ai/global-rules.md` §5、`ai/commands/post-sync-cleanup.md`、`ai/prompts/maintainers/15-post-sync-cleanup.md`、`template-docs/beginner-guide.md` §5、`.gitignore`（模板默认值）
> 状态：**草案，待 C1 triage**（可与 Batch B（#370+#374）聚合发版，也可独立 PATCH）
> 与既有提案关系：#357 管根目录**三层区分类**（模板继承/治理记录/项目产出），本提案管根目录**命名空间与准入**——同一根目录的两个正交维度；#370 管代码目录内部划分依据，#374 管文件级治理，本提案是两者的「根目录级」补位，共同构成目录治理全景

## 1. 动机

派生项目根目录点目录持续增殖（实证：LUMEN 17 个点目录占根目录 44 项的 39%；模板仓也曾出现来源不明的 `.agents/` 空目录），凌乱只是表层；实质缺口是**模板没有定义「谁有权在根目录创建点目录」**：

- 点前缀混杂三类性质完全不同的目录：①平台硬约定（`.git` `.github`，零选择权）②工具链约定（`.venv` `*_cache` `.vscode` `.history` `.claude` `.cursor`，装了就有）③项目自建「隐藏」目录（本项目 `.ai/`）——项目对 ①② 类只能收容（gitignore），对 ③ 类和「② 类工具的选择」才是规范对象；三类混同管理导致「管不了的在管、该管的没管」。
- `.ai/` 在 LUMEN 被整目录 gitignore 后，`*.log` 全局规则对其失效，运行日志就近堆在 `.ai/` 根部（十几个 `live-backend-*.log` 等），机制目录（pitfalls/token-hotspots/session-handoff）与杂物混居，语义被稀释。
- 临时目录命名漂移：`.tmp/` 与 `tmp/`（无点、未被 gitignore，`git add -A` 即误入库）双版本并存；任务级临时目录（`.tmp-sprint28/`）用完不删。
- 安全缺口：编辑器 Local History 快照目录（`.history/`）会复制 `.env` 密钥文件（LUMEN 实测 18 份 `.env_*` 明文快照），虽 gitignored 但对本机任何可读文件的进程暴露。

## 2. 拟改

### 2.1 根级命名空间三分（`ai/global-rules.md` §5 三层区框架后补一段）

| 命名空间 | 语义 | 准入 |
|---|---|---|
| `.` 点前缀 | 外部系统拥有（平台 + 工具链 + 本机私有状态） | **项目不自建新点目录**；只准入 §5 准入清单内出现 |
| `_` 下划线前缀 | 项目级治理容器（`_governance/`） | 排序置顶 + 与正文命名空间视觉区分；沿用 v1.67.0 既有拍板 |
| 无前缀 | 项目产出 + 模板方法论正文（`docs/` `project/` `ai/` `tasks/` 等） | 按三层区框架（#357） |

口径：点命名空间 = 「外部系统拥有」；`_` = 治理命名空间；无前缀 = 正文。项目确需新的「本机私有 / 不入库」目录时，优先评估放入 `.ai/`（会话/观察类）或 `.tmp/`（临时类），而不是新开点目录。

### 2.2 点目录准入清单制（`ai/global-rules.md` §5 + post-sync-cleanup 审计项）

模板定义基线准入清单（去项目化）：

- **平台**：`.git`、`.github`
- **模板机制**：`.ai`（本机会话与观察记录，gitignored 子集见 `.gitignore`）
- **AI CLI / 编辑器**：`.claude`、`.cursor`（`.cursor/rules/project-rules.mdc` 为规则入口镜像，在 sync 清单内）
- **工具运行时白名单（gitignored，按栈出现）**：`.venv`、`node_modules`、`__pycache__`、`.mypy_cache`、`.pytest_cache`、`.ruff_cache`、`.vscode`、`.idea`、`.vs`、`.history`、`.swp`、`.env`、`.env.local`

审计项（`ai/commands/post-sync-cleanup.md` + `ai/prompts/maintainers/15-post-sync-cleanup.md` 各补一条）：**「准入清单外点目录」**——逐个列出并问三个问题：谁创建的 / 还在用吗 / 该收容（gitignore）还是该删。空目录（如实测发现的 `.agents/`）必删或必溯源，不留幽灵目录。该审计不限同步后，普通项目自查同样适用。

### 2.3 `.ai/` 内部白名单（`ai/global-rules.md` §5 或 `ai/session-rules.md` §6 附近补一段）

`.ai/` 只准以下子目录与顶层文件（与 `.gitignore` 模板默认值对齐）：

- 子目录：`token-hotspots/`、`pitfalls/`、`session-handoff-archive/`、`e2e-reports/`（均为 gitignored 本地观察材料）
- 顶层文件：`session-handoff.md`（gitignored）
- **禁止在 `.ai/` 根部堆文件**：运行日志进 `e2e-reports/` 或 `.tmp/`；一次性脚本用完即删。派生项目若整目录 gitignore `.ai/`（LUMEN 现状），需知 `*.log` 规则同时失效——白名单纪律更重要，建议改回按子路径 gitignore（模板 `.gitignore` 默认值已是子路径式）。

### 2.4 密钥文件编辑器快照排除（安全条款）

- `.env` / `.env.local` 等密钥类文件应加入编辑器 Local History / 时间线快照排除名单（VSCode：`local-history.exclude` 或禁用该插件对 `.env*` 的记录）。
- `.history/`（或等价快照目录）列入定期清理项：该目录内容永远不该被依赖，安全上视同密钥副本处理。
- 落点：`template-docs/beginner-guide.md` 常见错误区补一条；不强制进 `global-rules` 硬规则（编辑器配置属本机行为，模板只能提示不能保证）。

### 2.5 临时目录统一口径

- 临时目录统一用 `.tmp/`（模板 `.gitignore` 默认值补 `.tmp/` 一行）；禁无点 `tmp/`（裸奔不入 ignore，`git add -A` 即误入库）。
- 任务级临时目录（如 `.tmp-sprint28/`）随任务收尾即删；遗留即被 2.2 审计命中。

## 3. 与既有规则关系（去重）

| 既有规则 | 关系 |
|---|---|
| `global-rules §5` 三层区框架（#357 / v1.64.0） | **互补正交**：三层区管「目录归属分类」，本提案管「命名空间与准入」；本提案表格落在三层区框架段之后，不重复分类内容 |
| #370 目录划分依据 | 管代码目录内部；本提案管根目录级，互不重叠 |
| #374 文件治理三层体系 | 管文件级；本提案管根级命名空间，互不重叠 |
| `.gitignore` 模板默认值（不同步，派生自维护） | 本提案 2.5 补 `.tmp/` 一行；其余各点目录 ignore 项已存在 |
| `template-sync.json` | `.cursor/rules/project-rules.mdc` 已在清单内（既有事实，非本提案变更） |
| `check-template` 现有断言 | 不新增断言（点目录审计是 post-sync-cleanup 人工审计项，不做脚本门禁——与 rd-data-chain §4「无自检门禁、避免过度治理」一致） |

## 4. 版本影响

- **PATCH 到 MINOR 之间**：规则补充 + 审计项 + .gitignore 默认值一行，无 sync 清单路径变更、无脚本断言变更、无破坏性动作。若与 Batch B 聚合发版则随 Batch B MINOR；若独立发版建议 PATCH（规则澄清级）。
- 既有派生项目兼容：全部为新增规则与审计提示，无强制迁移；LUMEN 等「点目录已增殖」项目由审计项引导自行清理。

## 5. 影响面

- `ai/global-rules.md` §5（命名空间三分 + 准入清单 + `.ai/` 白名单）
- `ai/commands/post-sync-cleanup.md` + `ai/prompts/maintainers/15-post-sync-cleanup.md`（审计项各一条）
- `template-docs/beginner-guide.md`（三层地图表附近补命名空间说明 + 密钥快照排除提示）
- `.gitignore` 模板默认值（补 `.tmp/`）
- `CHANGELOG.md` / `CHANGELOG-PLAIN.md` / `VERSION`

## 6. 验证方式

- `scripts/check-template.sh` / `.ps1` 自检通过（不新增断言）。
- 行为验证：post-sync-cleanup 执行时「准入清单外点目录」审计能命中 LUMEN 实测样本（`.agents` `.tmp-sprint28` 等）。
- 派生项目下行同步后，beginner-guide 命名空间说明可读。

## 7. 备选方案与取舍

- **维持现状（不管点目录）**：增殖持续——LUMEN 已 17 个且含安全缺口（.env 快照），实证不支持。
- **脚本硬门禁（check-template 断言点目录）**：点目录高度依赖本机工具环境（装了什么工具就有什么目录），脚本误报率高；人工审计项 + 准入清单已够用，遵循「无自检门禁」口径。
- **禁止一切点目录（连 `.git` 都算违规）**：平台硬约定零选择权，不可行也不必要。
