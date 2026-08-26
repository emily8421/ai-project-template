> 来源：LUMEN_demo_T2.1（emily8421/LUMEN-DEMO）派生项目回流
> 状态：起草完成，待提交模板维护者

# TEMPLATE-UPGRADE：根目录重组执行层路径核对清单（root reorg execution-layer checklist）

## 1. 动机（去项目化）

模板 v1.64.0 落地「根目录分类框架」（#357 §2.2 三层区：模板继承 / 项目治理 / 项目产出），v1.6x 系列把代码目录标准定为 `project/`（frontend/backend/tests/docker）、治理目录标准定为 `_governance/`。**存量派生仓**从旧布局（代码目录散在根、治理目录散在根）迁移到新布局时，会发生一次大规模目录重组。

实证观察（某派生仓 2026-08 迁移，486 文件 / 386 rename）：**文档层的路径引用替换**（docs / tasks / README 等约 100 个文件）是机械工作、一次性完成；真正拖长闭环的是**执行层路径常量**——它们不随文档替换而更新，散落在 12 类互不相同的载体里，且每一类的「本地验证」与「CI/部署验证」覆盖面不同。逐类清单：

| # | 载体 | 断裂形态 | 为何本地易漏 |
|---|---|---|---|
| 1 | CI checker 脚本（lint/结构/行数门） | 硬编码扫描路径 `join(root,'backend')` → ENOENT | **本地验证脚本本身可能就是漏改项**——脚本挂了不等于验证失败被看见 |
| 2 | workflow `working-directory` | 指向旧目录 → `npm ci` 等全部 ENOENT | 本地不跑 workflow |
| 3 | workflow step 内相对路径 | `node ../scripts/x.mjs` 深度变化后应为 `../../` | 同上，CI-only |
| 4 | workflow 内联 python 片段 | `sys.path.insert(0, os.path.join(cwd,"tests",...))` → `ModuleNotFoundError` | 同上，CI-only |
| 5 | 类型检查配置（mypy packages / mypy_path） | `packages=backend` 找不到包；导入根变化后全量 import-not-found | 本地跑的方式与 CI 命令形参不一致时漏 |
| 6 | 独立工具脚本（schema 导出等） | `sys.path.insert(repo_root)` 后 import 失败 | 只在 CI 的 schema-diff job 里执行 |
| 7 | package.json scripts 相对路径 | `../scripts/...`、`../openapi/...` → 模块/文件找不到 | 只有从该子目录调 npm script 才触发 |
| 8 | 本地启动器（ps1/sh） | 前端根 join + 内嵌 python wrapper 的导入根 / 模块路径 | 不实际启动就不炸 |
| 9 | Dockerfile | `WORKDIR`/`COPY` 后的 uvicorn 导入根 → 容器起不来 | 需 docker build + run 才暴露 |
| 10 | compose 文件相对路径 | `env_file: ../.env` 以 compose 文件目录为基准，目录挪一层深度即错 | `docker compose config --quiet` 一条命令就能静态查出，但容易被跳过 |
| 11 | 治理目录嵌套层级 | `sync-records/template-sync/template-sync/` 双重嵌套 | 无 CI 门，纯人工/清单核对 |
| 12 | 配置/示例注释路径 | pytest.ini markers 描述、ruff.toml 头注释、.env.example 指引 | 零功能影响，但误导后续维护者 |

**核心教训**：目录重组的验证必须分层——「本地全绿」只是必要条件（#1 自身可能漏改、#2-#6 是 CI-only 面、#9-#10 是部署-only 面）；完整闭环 = 本地全量 + CI 全链 + demo 启动端到端 + `docker compose config` / 镜像构建。且被动中断的旧 handoff 可能含未消化的预警条目，收口前应重读全文。

## 1.1 与既有规则的关系（去重）

- **#357 root-directory-organization（已落地 v1.64.0 §2.2）**：定义根目录「应该长什么样」（分类框架）。**本提案管迁移过程**——从旧布局到新布局怎么搬不踩坑。对象不同（目标态 vs 迁移动线），互补不重复。
- **post-sync-cleanup 命令（`ai/commands/post-sync-cleanup.md`）**：模板下行同步后的整理流程。本提案是它的特化补充：当同步引入目录布局变更（如 v1.6x 的 `project/`/`_governance/` 标准化）时，post-sync-cleanup 应挂接本清单的执行层核对段。层级不同（通用清理 vs 目录重组专项）。
- **sync-template 脚本与 check-derived-sync**：管模板件的覆盖与边界校验，不管派生项目自有代码目录的位置。对象不同。
- **file-responsibility-table（#374）**：管「新代码写进哪个文件」的静态职责；本提案管「存量文件搬家时哪些隐形引用要跟着走」的动态迁移。互补。
- **checklist 型既有文档（docs-checklist 等）**：面向文档生成；无目录重组专项清单。本提案填补该空缺。

## 2. 拟改

在 `template-docs/` 新增（或并入 post-sync-cleanup 附录）**根目录重组执行层核对清单**，内容为 §1 表格的通用化 + 三段验证纪律：

### 2.1 执行层路径核对清单（12 类载体）

按「载体 → 检查方式 → 断裂形态」组织（通用化措辞，不绑定具体仓）：

1. CI/本地 checker 脚本的硬编码扫描路径——迁移后先跑 checker 本身（ENOENT 即漏改），再信其结论；
2. CI workflow `working-directory` 全量 grep；
3. workflow step 内相对路径深度（`../` 逐层数）；
4. workflow 内联代码片段（python `sys.path` 等）；
5. 类型/lint 工具配置的包路径与搜索路径（packages / mypy_path / include）；
6. 独立工具脚本的导入根与仓库根定位（`Path(__file__).parents[N]` 的 N 是否变）；
7. 包管理器 scripts（package.json 等）中的相对路径；
8. 本地启动器脚本（ps1/sh/多语言内嵌 wrapper）的工作目录与导入根；
9. Dockerfile 的 WORKDIR / COPY / PYTHONPATH（或等价语言机制）三元组；
10. compose 相对路径（env_file / volumes / build context）——**静态验证一条命令：`docker compose config --quiet`**；
11. 治理目录嵌套层级（防 `a/a/` 双重嵌套）；
12. 配置与示例文件中的注释路径（零功能影响，防误导）。

### 2.2 三段验证纪律

- **本地**：全量 test + lint + type + build + 各 checker 自跑；
- **CI**：全链 PR checks（本地验证覆盖不到 #2-#6 的 CI-only 面）；
- **部署面**：demo 启动端到端 + `docker compose config` +（可行时）镜像构建与容器内 import 冒烟（#9-#10 只在此层暴露）。

### 2.3 流程挂接

- post-sync-cleanup 命令在「同步引入目录布局变更」时提示挂接本清单；
- 提案不引入 CI 硬门禁（清单是 runbook 性质；机械化检查以既有 check-derived-sync / 各 checker 为准）。

## 3. 版本影响

模板 MINOR：新增 template-docs runbook + post-sync-cleanup 一处提示，不改规则语义、不加 CI 门。

## 4. 影响面

- 新增：`template-docs/`（或并入既有 post-sync-cleanup 文档）一份清单文档；
- 修改：`ai/commands/post-sync-cleanup.md` 加一句挂接提示；
- 不改：`ai/` 规则语义、脚本、CI workflow；
- 下行同步后存量派生仓不强制执行（清单在需要重组时使用）。

## 5. 验证方式

- 模板仓：文档审阅 + check-template 自检；
- 派生仓实证：本提案来源仓的迁移已按此清单补完 12 类断裂并三层验证闭环（本地 + CI 10 项 + Docker），可作为首例回溯材料。


> Mirrored at 2026-08-26 by triage session (auto-refresh).
