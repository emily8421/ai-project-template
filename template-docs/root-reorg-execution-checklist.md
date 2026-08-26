# 根目录重组执行层路径核对清单（Root Reorg Execution-Layer Checklist）

> Sync notice: This file is maintained by `ai-project-template` and may be overwritten when a derived project syncs template methodology.
> Do not edit it directly in derived projects; propose reusable changes in `_governance/_proposals/` and upstream them to the template repository.

本清单服务于**存量派生仓的目录重组**：从旧布局（代码目录散在根、治理目录散在根）迁移到新布局（代码进 `project/`、治理进 `_governance/`）时，核对哪些**执行层路径常量**会跟着断。文档层的路径引用替换（docs / tasks / README）是机械工作、一次性完成；真正拖长闭环的是执行层常量——它们不随文档替换而更新，散落在 12 类互不相同的载体里，且每一类的「本地验证」与「CI/部署验证」覆盖面不同。

> 何时使用：`sync-methodology` / `post-sync-cleanup` 发现同步引入目录布局变更（如模板 `project/` / `_governance/` 容器标准化），或项目自行发起根目录重组时。post-sync-cleanup 命令在此场景会挂接本清单（见 `ai/commands/post-sync-cleanup.md` 步骤 4d）。

## 1. 执行层路径核对清单（12 类载体）

按「载体 → 检查方式 → 断裂形态」组织；通用化措辞，不绑定具体仓库。

| # | 载体 | 检查方式 | 断裂形态 |
|---|---|---|---|
| 1 | CI / 本地 checker 脚本（lint / 结构 / 行数门） | **迁移后先跑 checker 本身**（ENOENT 即漏改），再信其结论 | 硬编码扫描路径 `join(root,'backend')` → ENOENT；本地验证脚本本身可能就是漏改项——脚本挂了不等于验证失败被看见 |
| 2 | CI workflow `working-directory` | 全量 grep workflow 文件中的 `working-directory` | 指向旧目录 → `npm ci` 等全部 ENOENT；本地不跑 workflow，CI-only 面 |
| 3 | workflow step 内相对路径 | 逐条核对 `../` 深度（目录挪一层深度即错） | `node ../scripts/x.mjs` 深度变化后应为 `../../`；CI-only |
| 4 | workflow 内联代码片段 | grep workflow 中的内联 python / shell 片段里的路径拼接 | `sys.path.insert(0, os.path.join(cwd,"tests",...))` → `ModuleNotFoundError`；CI-only |
| 5 | 类型 / lint 工具配置 | 核对 `packages` / `mypy_path` / `include` 等包路径与搜索路径 | `packages=backend` 找不到包；导入根变化后全量 import-not-found；本地跑法与 CI 命令形参不一致时漏 |
| 6 | 独立工具脚本 | 核对导入根与仓库根定位（`Path(__file__).parents[N]` 的 N 是否变） | `sys.path.insert(repo_root)` 后 import 失败；只在 CI 的专项 job 里执行 |
| 7 | 包管理器 scripts | grep `package.json` 等的 `scripts` 段相对路径 | `../scripts/...`、`../openapi/...` → 模块 / 文件找不到；只有从该子目录调 npm script 才触发 |
| 8 | 本地启动器（ps1 / sh） | 核对工作目录假设与内嵌 wrapper 的导入根 / 模块路径 | 前端根 join + 内嵌 python wrapper 导入根错位；不实际启动就不炸 |
| 9 | Dockerfile | 核对 `WORKDIR` / `COPY` / `PYTHONPATH`（或等价语言机制）三元组 | 导入根错位 → 容器起不来；需 docker build + run 才暴露 |
| 10 | compose 文件相对路径 | **静态验证一条命令：`docker compose config --quiet`** | `env_file: ../.env` 以 compose 文件目录为基准，目录挪一层深度即错；易被跳过 |
| 11 | 治理目录嵌套层级 | 人工核对目录树，防 `a/a/` 双重嵌套 | `sync-records/template-sync/template-sync/` 双重嵌套；无 CI 门，纯人工 / 清单核对 |
| 12 | 配置 / 示例注释路径 | grep `pytest.ini` markers、`ruff.toml` 头注释、`.env.example` 指引 | 零功能影响，但误导后续维护者 |

## 2. 三段验证纪律

目录重组的验证必须分层——「本地全绿」只是必要条件（#1 自身可能漏改、#2-#6 是 CI-only 面、#9-#10 是部署-only 面）：

- **本地**：全量 test + lint + type + build + 各 checker 自跑；
- **CI**：全链 PR checks（本地验证覆盖不到 #2-#6 的 CI-only 面）；
- **部署面**：demo 启动端到端 + `docker compose config` +（可行时）镜像构建与容器内 import 冒烟（#9-#10 只在此层暴露）。

完整闭环 = 本地全量 + CI 全链 + demo 启动端到端 + `docker compose config` / 镜像构建。且被动中断的旧 handoff 可能含未消化的预警条目，收口前应重读全文。

## 3. 边界

- 本清单是 **runbook 性质**，不引入 CI 硬门禁；机械化检查以既有 `check-derived-sync` / 各 checker 为准。
- 新派生项目由 `new-project.sh` 直接生成新布局，不适用本清单；本清单面向**存量仓迁移**。
- 目录重组的「目标态」分类框架见 `ai/global-rules.md` §5 根目录三层区；本清单只管**迁移过程**。
