# 工作空间根目录结构综合评估（deepseek-v4-flash）

> **定位**：调研记录。本文基于对参考工作空间 `miiot_plugin_develop_system` 与本仓库根目录的**只读核对**，综合既有 4 份评估/核对，给出根目录重组建议。本文不改变当前模板目录契约，不构成已批准的迁移方案。
> **关联文件**：
> - [2026-08-21-workspace-root-structure-assessment-gpt-5.6-terra.md](./2026-08-21-workspace-root-structure-assessment-gpt-5.6-terra.md)（gpt 评估）
> - [2026-08-21-workspace-root-structure-eval-minimax-m3.md](./2026-08-21-workspace-root-structure-eval-minimax-m3.md)（minimax-m3 自评）
> - [2026-08-21-workspace-root-structure-meta-eval-minimax-m3.md](./2026-08-21-workspace-root-structure-meta-eval-minimax-m3.md)（minimax-m3 横向评估）
> - [2026-08-21-workspace-root-structure-fact-verification-minimax-m3.md](./2026-08-21-workspace-root-structure-fact-verification-minimax-m3.md)（minimax-m3 事实补正）
> 评估者：deepseek-v4-flash（2026-08-21）。

## 1. 目的与范围

回答用户诉求：「重新整理根目录，让编码实现所涉及的目录能放进同一个入口，未来只需要代码时可以直接拷贝出来；其他目录能规整更好」。

本轮**只读核对**范围：

- 参考工作空间 `D:\2-Project\7-Plugin\miiot_plugin_develop_system`：根目录一层清单、各顶层目录二层清单、根 `README.md` / `AGENTS.md` / `CLAUDE.md` / `.code-workspace`，以及 `_workspace/00-总入口.md` + `01-目录索引.md` + `02-跨目录约束.md`，`flowkit/README.md` 与 `flowkit/` 工程结构。另核对 README/索引中登记的旧目录是否实际存在于工作区内。
- 本仓库 `D:\2-Project\5-Project Templates\ai-project-template`：根目录一层清单（含隐藏）、各顶层目录一层清单。
- 综合既有 4 份评估/核对（gpt 评估、minimax-m3 自评、meta-eval、fact-verification）的结论、影响审计与事实订正。

未读取：

- 参考工作空间各目录的业务内容、`_workspace/` 全部规则全文（仅读 00/01/02）、`flowkit/` 业务实现。
- 本仓库 `ai/` 规则全文、`template-docs/` 手册全文、`scripts/` 脚本实现、`docs/00-09` 内容、既有 4 份研究之外的细节。

## 2. 已核实观察

### 2.1 参考工作空间（miiot_plugin_develop_system）

根目录**实际存在** 10 项可见条目（本次 `ls` 核对）：

| 条目 | 类型 | 职责 |
|---|---|---|
| `_workspace/` | 治理 | 00-总入口 + 01-10 编号规则 + `_handoff/` 续接，横切治理集中一处 |
| `01-文档/` | 文档 | 业务文档（00-规范 / 学习 / V3.5 / 自动化系统） |
| `02-数据/` | 数据治理 | 数据源登记与工作副本索引；数据本体不在本目录 |
| `03-知识输入/` | 知识 | 只读参考依据 |
| `04-工具/` | 工具 | 脚本治理 + `tool-registry.json`（唯一事实源） |
| `flowkit/` | 代码 | **唯一应用代码入口**（Electron+React monorepo：apps/desktop + packages/core + config + docs） |
| `AGENTS.md` / `CLAUDE.md` | AI 入口 | Codex / Claude 引导，桥接 `_workspace/00-总入口.md` |
| `README.md` | 人类入口 | 目录地图 + 迁移状态 + 硬约束 |
| `.code-workspace` | 挂载 | VS Code folders 挂载登记 |

**关键观察**：

1. **README / 目录索引登记的条目与工作区内物理目录不一致**：`01-目录索引.md` 登记的 `00-plugin-requiements/`、`miot-plugin-sdk/`、`mijia-light-plugin-v35-demo/`、`_smoke/` 等均**不在工作区内**（位于 `D:\2-Project\7-Plugin\` 兄弟目录），`E:\miiot-data\` 在外部盘。根目录保持 10 项的原因是**大量内容通过「登记挂载」而非「物理放入」引入**。
2. `_workspace/02-跨目录约束.md` 用**保护注册清单**统一管理只读/例外路径，且维护机器可读镜像 `04-工具/00-工具治理/protected-paths.json`。
3. `.code-workspace` 的 `folders` 由 `07-VSCode工作区挂载登记.md` 驱动同步，AI 引导（AGENTS.md/CLAUDE.md）与 VS Code 挂载解耦。
4. `flowkit/` 是**独立 git 仓**（`01-目录索引.md` 登记"独立仓（已提交 bb98cd1）"），工程内部自有 apps/packages/config/docs。

### 2.2 当前模板仓库（ai-project-template）

根目录 `ls -1A` 共 **38 项**（含隐藏；与 meta-eval 核对的数字一致）。角色混杂在同一层：

| 类别 | 条目 |
|---|---|
| 模板方法论 | `ai/`、`template-docs/`、`scripts/`、`template-sync.json` |
| 模板治理记录 | `ai-records/`、`sync-records/`、`_proposals/`、`_archive/`、`.ai/` |
| 派生项目骨架（分散） | `frontend/`、`backend/`、`tests/`、`docker/`、`docs/`、`tasks/` |
| 入口/手册 | `AGENTS.md`、`CLAUDE.md`、`INIT-PROMPT.md`、`README.md`、`MAINTAINERS.md`、`CONTRIBUTING.md`、`SOP.md`、`git-guide.md`、`CHANGELOG.md`、`CHANGELOG-PLAIN.md`、`VERSION` |
| 工具点目录 | `.agents/`、`.claude/`、`.cursor/`、`.github/`、`.git/`、`.history/` 等 |
| 残留 | `check-run.log`、`check-run2.log`、`check-run3.log`（临时日志，未入 `_archive/` 未 gitignore） |

**核心痛点**：要"只拷代码"，需从根目录手工挑 `frontend/`+`backend/`+`tests/`+`docker/`+`tasks/`+`docs/` 六处，且需避开模板治理材料。不存在单一复制入口。

### 2.3 两侧对照

| 维度 | miiot 工作空间 | 当前模板仓库 |
|---|---|---|
| 根目录物理条目 | 10 项 | 38 项 |
| 应用代码 | `flowkit/` 单一入口（独立仓） | 分散 4 处（frontend/backend/tests/docker） |
| 治理集中度 | `_workspace/` 集中 | `ai/`+`template-docs/maintainer/`+根 4 手册分散 |
| 内容引入方式 | 登记挂载（多仓/外部盘） | 单仓物理存放 |
| 数据治理 | 登记与本体分离 | 模板无数据需求 |
| AI 引导 | 每目录 AGENTS.md + CLAUDE.md | 根 4 入口 + `ai/index.md` 路由 |

## 3. 提炼的职责机制（本次核对的 M1–M4）

"清晰简洁"的根源不是编号，而是职责机制。本次核对确认 minimax-m3 的 P1–P5 方向正确，并补充一条关键差异：

| # | 机制 | miiot 实现 | 对模板仓适用性 |
|---|---|---|---|
| M1 | 根目录只装领域入口 | 6 目录职责单一 | ✅ 核心可借鉴 |
| M2 | 治理集中在 `_workspace/` | 00-总入口 → 01-10 + `_handoff/` | ⚠️ 模板已有等价物但分散 |
| M3 | 登记挂载 ≠ 物理放入 | SDK/demo/旧归档/外部盘登记挂载，根目录保持少项 | ⚠️ **不能照搬**：模板仓是单仓、派生靠整体复制 |
| M4 | 单一代码入口 | `flowkit/` 唯一代码仓 | ✅ **本次诉求核心** |

> 补充修正：miiot 的根目录简洁**高度依赖 M3（多仓挂载）**。模板仓不能复制 M3，只能用**物理容器**收拢项目产出（既有研究方案 B 的 `project/`）。这是本评估对既有 P1–P5 的重要补充。

## 4. 借鉴可行性判断

| 参考做法 | 借鉴？ | 理由 |
|---|---|---|
| 根目录 `01-/02-/` 编号 | **不建议** | 编号只是排序技巧；移动 `ai/`/`template-docs/`/`scripts/` 会破坏同步契约与派生仓 |
| `_workspace/` 集中治理 | **已存在等价物** | `ai/` + `template-docs/maintainer/` + 根维护手册；无需新设 |
| 多仓登记挂载 | **不适合** | 模板仓派生项目靠 `git archive`/`git clone` 整体复制，无法用挂载替代 |
| 单一代码入口 | **应借鉴** | 与本次诉求一致；用物理 `project/` 容器实现 |
| 保护路径集中注册 | **可借鉴** | 模板"仓专用文档/脚本"清单可集中到机器可读文件（已有 `template-sync.json` 等价） |
| 每目录自带 AGENTS.md | **部分借鉴** | 派生项目需要，但属 `new-project.sh` 生成职责 |

## 5. 推荐方案（方案 B 精化）

综合既有研究方案 B + 本次核对的两条修正，**推荐方案 B（新增 `project/` 单一复制入口）**：

```text
ai-project-template/
├─ project/                  # ★ 派生项目复制入口（一拷即走）
│  ├─ docs/                  # ← 现 docs/（00-09 主链 + decisions/design/inputs/research/...）
│  ├─ src/                   # ← 现 frontend/ + backend/ 合并
│  │  ├─ frontend/           #   形态裁剪开关（--shape web/cli/docs）
│  │  └─ backend/
│  ├─ tests/                 # ← 现 tests/
│  ├─ tools/                 # ← 现 docker/ + 项目级脚本（与根 scripts/ 职责分离）
│  ├─ tasks/                 # ← 现 tasks/
│  └─ README.md
├─ ai/                       # 模板方法论（不动）
├─ template-docs/            # 模板手册（不动）
├─ scripts/                  # 模板维护工具（不动）
├─ ai-records/  sync-records/  _proposals/  _archive/   # 治理记录（不动）
├─ AGENTS.md  CLAUDE.md  INIT-PROMPT.md  README.md       # 入口（部分更新引用）
├─ MAINTAINERS.md  CONTRIBUTING.md  SOP.md  git-guide.md # 维护手册（更新引用）
└─ template-sync.json  VERSION  CHANGELOG*.md            # 版本/同步（不动）
```

### 两条关键修正

1. **"多仓挂载"不能照搬，"单入口"必须照搬**。miiot 靠 `.code-workspace` 挂外部仓保持根干净；模板仓派生项目用 `git archive`/`git clone` 整体复制（fact-verification §2.1 确认），必须用**物理容器 `project/`** 而非登记挂载。
2. **`project/` 必须与 `template-sync.json` 完全脱钩**。`files_all` 156 项中仅 2 项含 `docs/`（`docs/README.md` + `docs/inputs/README.md`，治理元数据），迁入 `project/docs/` 后改这 2 处 + `description` 字段即可；`docs/00-09` 项目事实文档本就不在同步清单（派生项目自有维护），故 `project/` 内绝大部分内容天然不同步——这正是所需边界。

## 6. 影响面（基于 fact-verification，非重复审计）

改动收敛到 4 类来源文件，不碰模板方法论核心：

| 文件 | 改造量 |
|---|---|
| `scripts/new-project.sh` | `--shape` 裁剪路径改 4 行 + 生成的派生项目 README 模板 30+ 处 `docs/...` → `project/docs/...` |
| `template-sync.json` | 2 处路径 + `description` 字段 |
| `template-docs/docs-scaffold/README.md` | 三层定位表 + 00-09 落盘表约 12 处（scaffold 模板内容本身不动） |
| `git-guide.md` §5 | 禁止路径清单 + grep 正则 + `project/README.md` 项目件说明（5 处） |

**绝对不碰**：`ai/`、`template-docs/` 主体、根 `scripts/` 同步/自检脚本、`template-sync.json` 同步清单机制。`check-template.sh` 的 `require_doc_standards_mirror` 断言需从 `docs/` → `project/docs/`（实施前实测确认）。

## 7. 待人工确认

| ID | 决策项 | AI 建议 | 依据 | 影响 |
|---|---|---|---|---|
| ROOT-C-001 | 是否启动 `project/` 容器 | **启动**（分 PR 分阶段） | 唯一根治"拷代码要手挑"；A/D 方案不根治 | 是否启动目录迁移 |
| ROOT-C-002 | `project/` 定位 | **派生项目起点**，非本仓唯一示例 | 保持模板仓属性；`_examples/` 留在根作成品示例 | README / sync / new-project 行为 |
| ROOT-C-003 | 迁移节奏 | 一个 MINOR 版本窗口内 PR-1（代码骨架）+ PR-2（docs+同步收口） | 与 6 仓派生同步窗口联动 | 版本规划与派生仓同步排期 |
| ROOT-C-004 | `check-run*.log` 残留处置 | gitignore 或归 `_archive/` | 临时日志既非入口也非手册 | 根目录整洁度 |

## 8. 本轮限制与后续验证

- 本评估基于目录结构与入口文档的只读核对；**未读取**参考工作空间业务内容、本仓库规则全文、脚本实现与 `docs/00-09` 内容。
- 影响面直接引用 fact-verification 的事实审计结果（该文件已确认 `new-project.sh` 机制为 `git archive` 全量 + 选择性 rm）。
- **未跑** `scripts/check-template.sh` / `check-derived-sync` 实测路径变更影响。如进入实施，须先以"模板维护 / 目录迁移"任务类型执行全量依赖审计，在临时分支模拟迁移并跑本地 check-template + check-derived-sync 全绿后再开 PR。
- 因此，本评估是**结构性候选方案的综合确认版**，不应被视为已批准的迁移决策。

---

**维护提示**：本文为调研记录，按 `docs/README.md` §5 归 `docs/research/`。实施阶段保持只读留档（决策溯源），实施结果回写 `_proposals/TEMPLATE-UPGRADE-workspace-project-container.md` + `CHANGELOG.md`，不替代任何项目事实文档。
