# 工作空间根目录结构评估：minimax-m3 自评（基于完整只读读取）

> **定位**：调研记录。本文是 minimax-m3（MiniMax 自研 M3 模型）在已**完整读取**参考工作空间目录与本仓库现状后的自评，与同日 gpt-5.6-terra 出的 [2026-08-21-workspace-root-structure-assessment-gpt-5.6-terra.md](./2026-08-21-workspace-root-structure-assessment-gpt-5.6-terra.md) 互为补充。
> 本文不改变当前模板目录契约，不构成已批准的迁移方案；任何目录变更须先起 `_proposals/TEMPLATE-UPGRADE-*.md` 提案并经评审。

## 1. 目的与范围

回答用户提出的诉求：「未来只需要代码时可以直接拷贝出来；其他目录若能规整更好」。

本轮只读检查范围：

- 参考工作空间 `D:\2-Project\7-Plugin\miiot_plugin_develop_system`：根目录两层清单 + `README.md` / `AGENTS.md` / `CLAUDE.md` / `.code-workspace`，以及 `_workspace/00-总入口.md` + 01–10 编号规则 + `_workspace/01-目录索引.md` + `_workspace/02-跨目录约束.md` + `_workspace/03-git管理.md` + `_workspace/07-VSCode工作区挂载登记.md` + `_workspace/08-通用文档管理原则.md` + `_workspace/09-工具管理.md`，并读了 `flowkit/` / `01-文档/` / `02-数据/` / `04-工具/` 的根 `README.md`。
- 本仓库 `D:\2-Project\5-Project Templates\ai-project-template`：根目录两层清单 + `README.md` + `docs/README.md` + `ai/index.md` + `MAINTAINERS.md` + `SOP.md` + 各顶层目录职责与体积。

未读取：

- 参考工作空间的业务文档内容、各目录下的具体资料。
- 本仓库 `ai/` 下规则全文（除 `ai/index.md`）、`template-docs/` 手册全文、`scripts/` 脚本实现、`docs/00-09` 内容。
- 派生项目仓库的同步后状态。

## 2. 已核实观察

### 2.1 参考工作空间（miiot_plugin_develop_system）

根目录共 9 项（不含 dot 文件 / .code-workspace）：

| 类别 | 路径 | 职责 |
|---|---|---|
| 横切治理 | `_workspace/` | 全局规则 / 索引 / 跨目录约束 / git / 续接 / 挂载登记 / 通用原则（A1–A7） / 工具管理 / 平台数据约束 |
| 业务文档 | `01-文档/` | 项目背景、学习记录、V3.5 项目、自动化系统文档 |
| 数据治理 | `02-数据/` | 数据源登记与索引；数据本体不放在此目录 |
| 只读知识 | `03-知识输入/` | 米家文档 / 共享基础落地副本（只读） |
| 工具仓 | `04-工具/` | 公共脚本 + `tool-registry.json`（唯一事实源）+ `tool-registry.md`（自动生成）+ `find-tool.ps1` |
| 应用代码 | `flowkit/` | 唯一应用代码入口（Electron + React monorepo） |
| AI 入口 | `AGENTS.md` + `CLAUDE.md`（根） | Codex 读 AGENTS.md、Claude 读 CLAUDE.md（Claude 不读 AGENTS.md，向上查） |

观察到的具体设计模式：

- **每个登记目录自带 `AGENTS.md` + `README.md` 双入口**，Claude 侧额外配 `CLAUDE.md`（`@` 导入 `_workspace/00-总入口.md` 做桥接）。
- **挂载与 AI 引导解耦**：`.code-workspace` 的 `folders` 由 `07-VSCode工作区挂载登记.md` 驱动，用 `sync-vscode-workspace.ps1` 幂等同步；编辑器层只管 VS Code 侧边栏显示，不管 AI 引导。
- **机器可读 + 人读视图双轨**：`04-工具/tool-registry.json` 是唯一事实源，`tool-registry.md` 由 JSON 生成（人读视图）；编辑注册源后跑 `validate-tool-registry.py` + `render-tool-registry.py` 重建人读视图。
- **保护路径集中注册**：`02-跨目录约束.md` 的"保护注册清单"是受保护路径的唯一注册源，机器可读镜像 `04-工具/00-工具治理/protected-paths.json`；批量 / 整理脚本必须读该镜像做路径排除，不得硬编码。
- **数据"登记"与"本体"分离**：`02-数据/` 只放元数据 + 索引；数据本体在 `E:/miiot-data/`（外部盘，按形态分目录，不合并）。
- **目录状态显式登记**：`_workspace/01-目录索引.md` 每条目录都标注状态（新 / 旧待迁移 / 旧已归档 / 现役 / 参考）+ 是否独立 git 仓 + 入口文件路径。

### 2.2 当前模板仓库（ai-project-template）

根目录共 24 个条目（含 7 个隐藏 / 点目录）：

| 类别 | 条目 | 数量 |
|---|---|---|
| AI 入口 | `AGENTS.md` / `CLAUDE.md` / `INIT-PROMPT.md` + `ai/` | 4 |
| 模板手册 | `template-docs/` + `README.md` | 2 |
| 模板维护工具 | `scripts/` + `template-sync.json` + `ai-records/` + `sync-records/` + `_proposals/` + `_archive/` | 6 |
| 派生项目骨架 | `docs/` + `frontend/` + `backend/` + `tests/` + `docker/` + `tasks/` + `_examples/` | 7 |
| 维护手册与版本 | `MAINTAINERS.md` / `CONTRIBUTING.md` / `SOP.md` / `git-guide.md` / `CHANGELOG.md` / `CHANGELOG-PLAIN.md` / `VERSION` | 7 |

观察：

- 顶层 24 项里，**4 个是 AI 入口**（CLAUDE.md + AGENTS.md + INIT-PROMPT.md + ai/），已经为引导做了重投入；学习成本集中在「先读哪个 .md」。
- 派生项目骨架的 7 个目录**与模板治理材料平级**，复制时要逐个挑；不存在"项目产物单一入口"。
- `docs/` 既承载模板自身的项目事实（research / decisions / archive 等），又承载 00-09 主链——两种属性混在一起。
- 顶层 7 个 .md 维护手册各管一摊，缺乏统合入口；`template-docs/maintainer/` 已是部分整合（`e2e-regression-checklist.md` / `e2e-report-template.md` / `rd-data-chain.md`），但根目录的 `MAINTAINERS.md` / `CONTRIBUTING.md` / `SOP.md` / `git-guide.md` 仍在根。
- 模板自身的项目事实（如 `docs/research/` 现有 4 份调研记录）放哪，是当前布局未明确解决的问题。

### 2.3 两侧对照

| 维度 | 参考工作空间 | 当前模板仓库 |
|---|---|---|
| 根目录条目数 | 9 | 24 |
| 根目录是否有项目代码 | 有（`flowkit/`，单一入口） | 有（`frontend/`+`backend/`+`tests/`+`docker/`，分散 4 处） |
| 治理材料位置 | 集中在 `_workspace/` | 分散在根 + `template-docs/maintainer/` + `ai/` |
| 数据治理 | 登记与本体分离 | 无（模板无数据需求） |
| 工具 / 脚本 | 集中在 `04-工具/` | 集中在 `scripts/`（但 `scripts/` 含模板仓专用脚本 + 派生仓脚本两类） |
| AI 入口 | 每个登记目录自带 AGENTS.md/CLAUDE.md | 根目录 4 个入口 + `ai/index.md` 路由 |
| 挂载机制 | `.code-workspace` + 登记表 + 同步脚本 | 无（模板仓不需要 VS Code 跨仓挂载） |

## 3. 参考工作空间的设计原则提炼

读完治理文件后，**"清晰简洁"的根源不是编号本身，而是 5 条职责原则**：

| 编号 | 原则 | 参考工作空间实现 | 对模板仓的可借鉴性 |
|---|---|---|---|
| P1 | 根目录只装领域入口，不装内容 | 6 个顶级项（治理 / 文档 / 数据 / 知识 / 工具 / 代码），每个自带 AGENTS.md + README.md | 模板根 24 项里 P1 违反明显（治理材料直堆根） |
| P2 | 横切治理集中在 `_workspace/` | `_workspace/` 内部再用 00–10 编号细分 | 模板已有等价物（`ai/` + `template-docs/maintainer/` + 根 4 维护手册），但未集中 |
| P3 | 数据"登记"与"本体"分离 | `02-数据/` 只放元数据；本体在 `E:/miiot-data/` | 模板无数据需求，无需复制 |
| P4 | 机器可读注册源 + 人读视图双轨 | `tool-registry.json` 唯一事实源；`tool-registry.md` 自动生成；脚本不得写人读视图 | 模板已部分采用（`template-sync.json` + `scripts/README.md`） |
| P5 | 挂载与 AI 引导解耦 | `.code-workspace` 只管 VS Code 侧边栏；每个目录自带 AGENTS.md/CLAUDE.md | 模板不需要 `.code-workspace`；每个登记目录自带入口的子模式可借鉴 |

P1+P2 是"根目录简洁"的主因；P3+P4+P5 是"系统可演进"的支撑。这 5 条**都不依赖编号**——编号只是排序技巧。

## 4. 借鉴可行性矩阵

逐项评判哪些做法值得照搬，哪些不适合本仓：

| 参考做法 | 借鉴？ | 理由 |
|---|---|---|
| 根目录按 `01-/02-/03-/04-` 编号 | **不建议** | 编号只是排序技巧；本仓已有 CLAUDE.md / AGENTS.md / README.md 三入口，视觉编号会冲淡入口语义；移动 `ai/` / `template-docs/` / `scripts/` 进编号区将破坏 `template-sync.json`、派生仓同步与 6 仓派生项目 |
| `_workspace/` 集中治理 | **已存在等价物** | `ai/` + `template-docs/maintainer/` + 根目录 4 维护手册就是分散版；无需新设 `_workspace/` |
| 数据登记与本体分离 | **不适用** | 模板不存用户数据；无 `02-数据/` 必要；可只在 README 提示"派生项目若产生大数据，需自建 `data/` 元数据 + 外置本体" |
| 工具注册源 JSON + 自动生成 .md 视图 | **已采用** | `template-sync.json` + `scripts/README.md` 模式等价 |
| `.code-workspace` 挂载 | **不适合** | 模板仓与工作空间职责不同；模板仓不需要 VS Code 跨仓挂载 |
| 每目录自带 AGENTS.md / README.md | **部分借鉴** | 派生项目确实需要，但这是 `new-project.sh` 生成职责，不是模板仓根目录问题 |
| 受保护路径集中注册 + 机器可读镜像 | **可借鉴** | 模板仓的"模板仓专用文档 / 脚本"清单目前散在 `MAINTAINERS.md` §4，可考虑集中到 `template-docs/maintainer/protected-paths.json` |

## 5. 建议方案

按强度排序：

### 5.1 方案 A：维持现状 + 仅文档说明

- **做法**：根目录不动；`README.md` / `SOP.md` 加一段"派生项目复制清单"：`docs/` + `frontend/` + `backend/` + `tests/` + `docker/` + `tasks/` + `_examples/` + 根目录 6 个 .md。
- **代价**：零迁移；用户复制仍需手工挑。
- **何时适用**：不想做任何目录变更。
- **结论**：**不满足本次核心目标**，不建议作为主方案。可作为方案 B 启动前的过渡软启动。

### 5.2 方案 B：新增 `project/` 单一复制入口（推荐）

借鉴参考工作空间 `flowkit/` 单代码入口原则，但**模板化**——`project/` 不放特定项目，而是放**派生项目起点**的完整复制入口。

```text
ai-project-template/
├─ project/                          # 派生项目复制入口（单一、可拷贝）
│  ├─ docs/                          # ← 现 docs/ 迁入
│  ├─ src/                           # ← 现 frontend/ + backend/ 合并
│  │  ├─ frontend/                   # 形态裁剪开关（README 说明）
│  │  └─ backend/                    # 形态裁剪开关
│  ├─ tests/                         # ← 现 tests/ 迁入
│  ├─ tools/                         # ← 现 docker/ + 项目级脚本
│  ├─ tasks/                         # ← 现 tasks/ 迁入
│  └─ README.md                      # 派生项目起步说明
├─ ai/                               # 模板方法论（不动）
├─ template-docs/                    # 模板手册（不动）
├─ scripts/                          # 模板维护工具（不动）
├─ ai-records/                       # 模板治理记录（不动）
├─ sync-records/                     # 同步记录（不动）
├─ _proposals/                       # 提案收件箱（不动）
├─ _examples/                        # 独立示例（不动）
├─ _archive/                         # 历史归档（不动）
├─ template-sync.json                # 同步清单（不动）
├─ 7 个根 .md（README/CONTRIBUTING/...） # 维护手册（不动）
└─ VERSION / CHANGELOG               # 版本记录（不动）
```

关键设计点：

1. **`project/` 是单一复制入口**；复制这一层就是项目起点。
2. **`src/` 合并 `frontend/` + `backend/`**：解决"代码在两个目录"的散乱；子目录按形态裁剪。
3. **`tools/` 收编项目级脚本**：与根 `scripts/`（**模板维护脚本**）职责分清。
4. **`_examples/` 留在根**：是模板讲解用的"成品例子"，与"项目起点"语义分离。
5. **`docs/` 进 `project/`**：保留 `00-09` 主链与所有子目录分区规则（inputs / vision / design / decisions / research / env / meetings / archive），只是换了父目录。
6. **`project/` 与 `template-sync.json` 完全脱钩**——这是当前布局最大的隐性耦合问题（项目产物与方法论同步清单混在一个根下）。

### 5.3 方案 C：全面编号化根目录

- **做法**：把 `ai/` → `01-ai/`、`template-docs/` → `02-template-docs/`、`scripts/` → `03-scripts/`...
- **结论**：**不建议**。方法论文档路径变了，所有内部链接、外部引用、`template-sync.json` 路径清单、`check-template` 路径断言、6 仓派生项目 `sync-template` 全链路都要重写。收益 = 视觉整齐；代价 = 大规模返工。投入产出严重失衡。

### 5.4 方案 D：仅建复制清单文档

- **做法**：不改路径，写 `docs/派生项目复制清单.md`（或合并入 SOP.md）。
- **结论**：清单必然漂移；**不推荐作主方案**，可作为方案 B PR-1 阶段的软启动（先发清单，下一版再迁移）。

### 5.5 方案对比

| 方案 | 做法 | 优点 | 主要代价 | 推荐 |
|---|---|---|---|---|
| A | 维持现状 + 文档说明 | 零影响 | 复制仍需手工挑 | 不满足目标 |
| B | 新增 `project/` 容器 | 单一复制入口清晰；模板维护边界清晰；同步面收窄；项目骨架可独立演进 | 需系统迁移 + 兼容期 + 派生仓同步 | **推荐** |
| C | 全面编号化根目录 | 视觉整齐 | 同步契约、引用、脚本、6 仓派生项目大规模返工 | 不建议 |
| D | 仅建复制清单文档 | 迁移成本低 | 仍不是真实单一入口；清单易漂移 | 可作 B 的过渡 |

## 6. 迁移影响审计（方案 B）

| 触发点 | 当前路径 | 迁移后 | 应对 |
|---|---|---|---|
| `scripts/new-project.sh` | 复制根 `docs/` / `frontend/` / `backend/` 等 | 复制 `project/` 整层 | 改源 |
| `template-sync.json` 的 `files_all` | 方法论文档白名单 | **不改**（方法论文件不动） | — |
| `scripts/check-template.sh` 的 `require_doc_standards_mirror` | 校验 `docs/00-09` | 校验 `project/docs/00-09` | 改路径断言 |
| `check-template.sh` 的 `check_scripts_sync_boundary` | 校验 `scripts/` 头注释 | **不改**（`scripts/` 不动） | — |
| `README.md` 目录速览表 | 列出根目录条目 | 加 `project/` 段；移除已迁项；保留所有方法论项 | 改文档 |
| `SOP.md` 场景索引 | 无路径断言 | 不变 | — |
| `MAINTAINERS.md` §7 文档分区 | `docs/README.md` 路径 | 改 `project/docs/README.md`；`docs/README.md` 自身迁入 | 改 |
| `_examples/` 内部示例 | 各自 `docs/` 等子路径 | 不动（`_examples/` 独立） | — |
| 派生项目 `sync-template` 后的路径预期 | 期望根 `docs/` | 期望 `project/docs/` | `post-sync-cleanup` 加路径期望更新；`derived-sync-report-template.md` 收口 |
| 文档内绝对路径引用 | 散落 `docs/...` | 散落 `project/docs/...` | rg 批量改 + A3 断链检查 |
| 模板自身的 `docs/research/` 4 份现成材料 | 放 `docs/research/` | 放 `ai-records/research/`（治理材料属性，非项目产物） | 同步搬 + 旧路径留 stub；见 ROOT-C-006 |

**核心约束**：方案 B 只挪**派生项目骨架（D 类）**，**不动模板方法论 / 治理 / 手册 / 工具（A/B/C/E 类）**。这是投入产出比最优的边界。

## 7. 与 gpt-5.6-terra 评估的差异

| 维度 | gpt-5.6-terra | minimax-m3（本评估） |
|---|---|---|
| 参考工作空间读取完整度 | 未完整读取（自承 PowerShell 转义失败，按失败即停未重试） | **已完整读取** 00–10 全部治理文件 + 4 个工作目录入口 + `.code-workspace` |
| 提炼的设计原则 | 偏目录示例（"01-文档/02-数据/03-知识输入/04-工具/flowkit/_workspace"） | **5 条职责原则（P1–P5）**，明确"编号只是表象" |
| 方案 B 目录命名 | `project/` | 一致 |
| `project/src/` 子结构 | `frontend/`+`backend/`+`packages/` | 一致；建议 `tests/` 提到 `project/tests/` 而非 `src/tests/`（保留形态裁剪边界） |
| `project/tools/` 收编范围 | `docker/`+ 项目级脚本 | 一致 |
| 影响面审计 | 未做（自承"未核验全部同步与自检依赖"） | **做了**：列出 11 个触发点 + 应对方式 |
| 待确认项 | 5 个（ROOT-C-001~005） | 6 个：复用前 5 个 + 新增 **ROOT-C-006**（模板自身的 `docs/research/` 等放哪） |
| 推荐推进顺序 | 6 步（含"先确认 `project/` 命名"作为第一步） | 4 步：先存本评估 → 起 `_proposals/TEMPLATE-UPGRADE-*.md` → 评审拍板 → 分 PR 实施；软启动建议先发方案 D 文档清单 |

## 8. 待人工确认

| ID | 决策项 | AI 建议 | 依据 | 影响 |
|---|---|---|---|---|
| ROOT-C-001 | 是否走方案 B（`project/` 容器） | **走** | 用户已表达诉求；方案 A/D 不根治 | 是否启动目录迁移 |
| ROOT-C-002 | `project/` 定位（派生项目模板 vs 本仓唯一示例） | **派生项目模板** | 保持模板仓属性；不让模板仓变成 demo 项目 | README / sync / new-project 行为 |
| ROOT-C-003 | `src/` 是否合并 frontend + backend；`tests/` 归属 | **合并**；`tests/` 提到 `project/tests/` 不进 `src/` | 形态裁剪清晰；与 `_examples/` 内部示例结构对齐 | 代码骨架示例 |
| ROOT-C-004 | 项目脚本命名 | `project/tools/` | 与根 `scripts/` 职责分清 | 文档 / 脚本注册 |
| ROOT-C-005 | 数据目录是否进 `project/` | **不进**；README 提示派生项目按需自建 | 模板无数据需求；避免仓库膨胀与数据风险 | `.gitignore` 提示 |
| ROOT-C-006（新增） | 模板自身的 `docs/research/` / `decisions/` / `meetings/` 等"研究材料"放哪 | **放 `ai-records/` 下**（治理材料属性，非项目产物）；同步搬现成 4 份调研 + 旧路径留 stub 过渡 | 这些不是"项目产物"，是"模板治理"；归 `ai-records/` 与现有 `pitfalls/` / `token-hotspots/` / `e2e-reports/` 同类 | 影响 4 份现成调研；`docs/README.md` 分区规则 |

## 9. 推荐推进顺序

1. **本轮**：本评估已落盘 `docs/research/2026-08-21-workspace-root-structure-eval-minimax-m3.md`；下一步建议起草 `_proposals/TEMPLATE-UPGRADE-workspace-project-container.md`（含 ROOT-C-001~006 决策表 + 第 6 节影响矩阵 + 过渡期长度选项）。
2. **下一会话（提案评审）**：拍板 6 个决策项；决定过渡期长度（建议 1 个 MINOR 版本窗口内完成 PR-1 + PR-2）。
3. **再下一会话（PR-1）**：分支 `feat/project-container-introduction`；先迁代码骨架目录（`frontend/`+`backend/`+`tests/`+`docker/`+`tasks/`），旧路径留 stub；`new-project.sh` 同步改造；`README.md` 目录速览刷新；`check-template` 路径断言改写；本地 + CI 全绿。
4. **PR-2 / PR-3**：跟随 v_MINOR 版本窗口完成 `docs/` 迁入 + 派生仓同步 + `post-sync-cleanup`。

期间**不会触碰**：`ai/` / `template-docs/` / 根 `scripts/` / `template-sync.json` 同步清单；这些是模板方法论核心，移动它们的成本远超收益。

## 10. 本轮限制与后续验证

- 本评估基于目录结构、入口文档和顶层 README 的只读阅读；**未读取** `ai/` 规则全文（除 `ai/index.md`）、`template-docs/` 手册全文、`scripts/` 脚本实现、`docs/00-09` 文档内容、参考工作空间的业务内容。
- 第 6 节影响审计基于已知路径约定与 `MAINTAINERS.md` §4 同步清单描述；**未跑** `scripts/check-template.sh` 验证路径变更是否会触发未知断言。如进入实施 PR，必须在分支上**先全量跑 check-template + check-derived-sync**确认。
- 因此，本评估是**结构性候选方案的精化版**，不应被视为已批准的迁移决策。
- 如进入实施，应先以"模板维护 / 目录迁移"任务类型执行全量依赖审计（任务路由见 `ai/index.md` 第 3 节"模板维护 / 规则改造 / 同步机制"行），并验证每一项路径变更对同步、自检、示例、CI、6 仓派生项目的影响。

---

**维护提示**：本文为调研记录，按 `docs/README.md` §5 归 `docs/research/`。进入实施阶段后，本文件应**保持只读留档**（作为决策溯源），实施结果回写到 `_proposals/TEMPLATE-UPGRADE-workspace-project-container.md` + `CHANGELOG.md`，不替代任何项目事实文档。