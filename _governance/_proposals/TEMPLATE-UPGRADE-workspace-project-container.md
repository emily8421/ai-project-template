# TEMPLATE-UPGRADE: 引入 project/ 项目代码骨架单一入口（嵌套 B 方案，docs 缓移）

> 来源：模板维护者（workspace-root-structure 评估链，6 份研究 + 1 份第三方复核）
> 状态：候选（待评估）
> 目标版本：待确认（建议随下一个 MINOR 窗口）
> Release impact：minor（AI 建议，待维护者确认）
> Release strategy：单独发布

## 1. 动机

用户核心诉求：**编码实现所涉及的目录能放进同一个入口，未来只需要代码时可以直接拷贝出来**。当前根目录 38 项中，`frontend/`、`backend/`、`tests/`、`docker/`、`tasks/`、`docs/` 六类项目骨架与模板方法论（`ai/`、`template-docs/`、`scripts/`）、治理记录（`ai-records/`、`sync-records/`、`_proposals/`）平级混放，复制代码需手工挑目录并避开治理材料。

参考工作空间 miiot_plugin_develop_system 的根目录仅 10 项，其中 `flowkit/` 是唯一应用代码入口。其"根目录只装领域入口 + 单一代码入口"的职责机制（M1/M4）值得借鉴；其"登记挂载多仓"机制（M3）因模板仓派生靠 `git archive`/`git clone` 整体复制，无法照搬。

本提案引入 **`project/` 容器**，将派生项目代码骨架收拢为单一可复制入口。**`docs/` 本次不迁移**（下一阶段单独梳理，见 §6），避免把"代码入口整理"升级为全模板文档路径迁移。

## 1.1 与既有规则的关系（去重）

- **`docs/README.md` §5**（`docs/` 分区规则，模板仓文档）：管理 `docs/` 内部子目录分区。**对象不同**——本提案不动 `docs/`，只动 `frontend/` 等代码骨架目录；`docs/` 内部结构规则不受影响。
- **`git-guide.md` §5**（派生项目同步 SOP）：规定同步禁止路径（`docs/00-09`、`frontend/` 等）。**机制不同**——本提案修改的正是它禁止路径清单中代码目录部分；`docs/` 禁止路径保持不变。
- **`template-sync.json`**（同步清单，`files_all` 156 项）：当前仅 2 项含 `docs/`（`docs/README.md`、`docs/inputs/README.md`）。**互补不重复**——本提案不改这两项路径（docs 不动），代码目录本不在 `files_all`（项目件不同步），同步清单机制本身不新增内容。
- **`template-docs/docs-scaffold/`**（00-09 骨架模板）：项目事实文档的长期结构参考。**对象不同**——docs 缓移，scaffold 的三层定位表"项目事实指向 `docs/00-09`"本次不改。
- **`scripts/new-project.sh`**（派生项目脚手架）：全量复制 + 选择性裁剪。**机制不同**——本提案修改其 `--shape` 裁剪路径（`frontend/` 等 → `project/` 子层），不改变其复制/裁剪机制本身。
- **远端 #370**（`_proposals/_remote-issues/issue-370.md`，OPEN）：补“代码目录为什么这样划分”的通用依据。**层级不同、互补不重复**——#370 管代码目录的部署/分层/纵切/契约/生命周期依据；本提案管根目录中的代码入口与治理入口。实施时应在目录说明中引用这套判断口径，但不把 #370 的说明性改动混入本结构迁移批次。
- **远端 #374**（`_proposals/_remote-issues/issue-374.md`，OPEN）：补文件级职责表、结构检查和阈值棘轮。**对象不同**——#374 管“代码放进哪个文件”，本提案只决定代码骨架的根级容器；维持独立 Batch，避免目录迁移与 Web 结构规则混批。
- **`MAINTAINERS.md` §4**（模板仓专用文件清单）：登记模板仓自有文件。**互补不重复**——本提案需要其登记 `project/` 的语义（模板仓内层容器 vs 派生仓标准布局），属登记信息更新，不重复治理规则。

**本提案不重复它们**：这些规则各自管理"docs 内部结构 / 同步禁止路径 / 同步清单 / 骨架模板 / 脚手架 / 维护登记"，本提案补的是**根目录层面"项目骨架单一入口"的结构缺位**。差异化：它不改变任何规则的机制，只在根目录增加一个容器并让相关路径引用适配。

## 2. 拟改

### 2.1 目标结构（嵌套 B 方案，docs 缓移）

```text
ai-project-template/
├─ project/                            # ★ 新增：项目代码骨架单一入口
│  ├─ frontend/                        # ← 现 frontend/ 迁入
│  ├─ backend/                         # ← 现 backend/ 迁入
│  ├─ tests/                           # ← 现 tests/ 迁入
│  ├─ docker/                          # ← 现 docker/ 迁入
│  └─ README.md                        # 代码骨架起步说明
│
├─ _governance/                        # ★ 新增：治理记录容器（不在同步契约，可自由归拢）
│  ├─ ai-records/                      # ← 现 ai-records/ 迁入（模板治理记录）
│  ├─ sync-records/                    # ← 现 sync-records/ 迁入（同步过程记录）
│  ├─ _proposals/                      # ← 现 _proposals/ 迁入（提案收件箱）
│  ├─ _archive/                        # ← 现 _archive/ 迁入（归档）
│  ├─ _examples/                       # ← 现 _examples/ 迁入（示例）
│  └─ README.md                        # 治理容器说明（分类地图）
│
├─ docs/                               # ◀ 本次不动，下一阶段单独梳理
│  ├─ 00-scenario.md ~ 09-verification.md
│  └─ inputs/ vision/ design/ decisions/ research/ meetings/ env/ archive/
├─ tasks/                              # ◀ 本次不动（跨 AI 协作任务单，非代码；下阶段随 docs 或 _governance/ 再定）
├─ ai/  template-docs/  scripts/       # 模板方法论（不动，同步契约内）
├─ AGENTS.md  CLAUDE.md  INIT-PROMPT.md  README.md
├─ MAINTAINERS.md  CONTRIBUTING.md  SOP.md  git-guide.md
├─ CHANGELOG.md  CHANGELOG-PLAIN.md  VERSION
└─ template-sync.json
```

派生项目经 `new-project.sh` 生成后与模板同构，同样保留 `project/` 与 `_governance/` 容器（嵌套 B 方案的核心特征）。

**根目录可见项从 38 → 约 15 项**：`project/` + `_governance/` 两容器收拢代码骨架与治理记录，方法论、入口、手册、版本保持根级。

### 2.2 设计要点

1. **`project/` 只收代码与运行骨架**：`frontend/`、`backend/`、`tests/`、`docker/`。**`tasks/` 不进 `project/`**——它是跨 AI 协作的任务单机制（给 AI 提供任务单 + 记录完成情况，保证不同模型输入一致），属协作/治理语义而非代码，与 `.ai/session-handoff.md` 同类；本次保留根级，下阶段随 docs 或 `_governance/` 再定归属。
2. **不合并 `src/`**：`frontend/`、`backend/` 原名迁入，不额外套 `src/` 层（glm5.3 Q2 建议采纳），保持形态裁剪开关（`--shape web/cli/docs`）在子目录层生效。
3. **`docs/` 缓移**：保留根目录，下一阶段单独梳理。理由：`docs/` 混杂项目事实 + 同步/脚本/规则/示例大量引用的标准路径，且 flowkit 参考仓的 docs 仅放任务记录，本仓 docs 需先厘清归属再迁。
4. **`template-sync.json` 不动**：`docs/README.md` + `docs/inputs/README.md` 两项路径保持原样；代码目录本不在 `files_all`（项目件不同步），同步清单无改动。
5. **治理记录归入 `_governance/`**：`ai-records/`、`sync-records/`、`_proposals/`、`_archive/`、`_examples/` 均**不在 `files_all`**（已核实：同步契约仅含 `ai/`、`template-docs/`、`scripts/`、`docs/` 2 项 + 根入口/手册/版本），归拢**零同步风险**。目标：根目录"每一类一眼看出范围"——代码（`project/`）、治理（`_governance/`）、方法论（`ai/`+`template-docs/`+`scripts/`）、项目事实（`docs/`）、入口/手册/版本（根级）。
6. **方法论不嵌套**：`ai/`、`template-docs/`、`scripts/` 保持根级（`files_all` 同步契约所限，移动会触发 6 仓同步连锁 + check-template 断言重写）；"眼花缭乱"用根 README 顶部**分类地图表**解决（方法论/治理/项目/入口四类），不靠移动。

## 3. 版本影响

- **Release impact：minor**（AI 建议）。新增 `project/` + `_governance/` 两容器属于"新增同步范围结构目录 + 新下游采用面"：派生项目经 `new-project.sh` 后获得 `project/` 层与治理归拢结构，`--shape` 裁剪路径、check 断言、README 模板均需适配。
- 不改变文档编号体系（major）或仅文案/脚本小修（patch）——代码骨架目录与治理结构是下游采用面，属 minor。

## 4. 影响面

基于 `fact-verification-minimax-m3.md` 的 4 项实测核对、glm5.3 补充核对，以及 C1 的限定路径审计，影响面不止最初的 4 类来源文件。**docs/ 内容与路径保持不动**，但所有把代码目录或治理目录写成根级路径的方法论、脚本和断言都必须同步改写：

| 文件 | 改造量 | 说明 |
|---|---|---|
| 目录迁移（git mv） | `frontend/ backend/ tests/ docker/` → `project/`；`ai-records/ sync-records/ _proposals/ _archive/ _examples/` → `_governance/` | 迁移是纯 `git mv` + 引用更新；`_governance/` 不在 `files_all` 零同步风险；`tasks/` 本次不动 |
| `scripts/new-project.sh` | `--shape` 裁剪路径改 4 行 + 生成的派生 README 中代码目录引用 + `_governance/` 治理泄漏裁剪（ROOT-C-006） | `--shape docs`：`rm -rf "$TARGET/frontend"` → `"$TARGET/project/frontend"` 等；README 模板中 `frontend/` 等路径改 `project/frontend/`；`_governance/` 裁剪策略：裁内容、保留各分区 README 种子 |
| `scripts/sync-template.*`、`scripts/check-derived-sync.*` | Bash / PowerShell 两套禁止路径模式 | `frontend/*`、`backend/*`、`tests/*`、`docker/*` → `project/frontend/*` 等；否则同步与派生仓验收会把项目件误判为可同步方法论 |
| `scripts/check-template.*` | 模板根路径断言、临时派生仓 smoke 与治理 README 断言 | 根 `_proposals/`、`_archive/`、`_examples/`、`ai-records/` 断言迁入 `_governance/`；同时新增 `project/` 与保留治理 README 种子的断言 |
| `ai/global-rules.md` §5 | 通用目录骨架、三层区分类框架和 Web 触发说明 | 根级代码目录清单与分类表改为 `project/` 内代码骨架、`_governance/` 内治理记录；保持 `docs/`、`tasks/` 根级且不改变其事实语义 |
| `ai/project-rules.md`、`ai/doc-standards/project-rules.md` | 项目形态裁剪和“需要保留的代码目录”字段 | 明确目录名相对 `project/` 解释；裁剪结果、`--shape` 以及示例路径改为 `project/frontend/` 等 |
| `ai/document-lifecycle-rules.md`、`ai/prompts/setup/14-new-project.md`、`ai/commands/new-project.md` | 代码/测试路径与新项目初始化说明 | 根级路径引用改为 `project/` 子层；不改变 docs 事实链、技术环境门禁或任务规则 |
| `template-docs/beginner-guide.md`、`template-docs/profiles/web-fullstack-profile.md` | 新手导航和 Web 推荐目录树 / 触发条件 | Web profile 的目录树嵌入 `project/`；新手指南的数据流和分类地图改为新根目录结构 |
| `git-guide.md` §5、`README.md`、`MAINTAINERS.md`、`scripts/README.md` | 同步禁止路径、模板目录速览、维护者布局说明和脚本使用说明 | 更新根级目录地图、禁止路径示例与模板仓/派生仓布局说明；`docs/00-09` 禁止路径**不变** |
| `README.md` 目录速览 | 加 `project/` 与 `_governance/` 段，移除已迁项，顶部加分类地图表 | 根目录速览表更新 |
| 全仓路径引用巡检 | `_proposals/`、`ai-records/`、`sync-records/`、`_examples/` 内部跨目录引用 | `_governance/` 迁移后，`README.md`、`_proposals/README.md`、规则文件中对这些目录的相对/绝对引用需同步更新 |
| `check-run*.log` | 删除 3 个文件 | 已核实 `.gitignore:25` `*.log` 覆盖、未跟踪，直接删除（ROOT-C-009） |

**不动**：`ai/`、`template-docs/` 主体、根 `scripts/` 的同步/自检脚本、`template-sync.json` 同步清单机制、`docs/`（缓移）、`tasks/`（缓移）。

**已核实的机制约束**（`fact-verification` §2 + glm5.3 §二.3，本仓复核）：

- `sync-template.sh:901` 用 `git checkout "$REF" -- "$f"` 做 1:1 路径映射。因 docs 不动、代码目录不在 `files_all`，**本方案不需要前缀剥离规则**（这是嵌套 B 在 docs 缓移下的关键简化，比完整方案 B 少一大改动）。
- `new-project.sh` 治理记录泄漏（不裁剪 `ai-records/`、`sync-records/`、`docs/research/`）——**随本提案一并处理**（ROOT-C-006，已拍板）：治理归拢 `_governance/` 后，派生仓应裁剪该容器内的模板治理内容记录（`ai-records/`、`sync-records/`、`_proposals/`、`_archive/`、`_examples/` 的内容），**保留各分区 README 种子**（空治理区框架）。`docs/research/` 的 6 份评估仍保留（当前决策研究证据，待后续独立审计归属）。

## 5. 验证方式

落地时（后续 PR 阶段，本提案阶段不做）：

1. 临时分支模拟迁移：`git mv` 4 目录 → `project/`、`git mv` 5 治理目录 → `_governance/`，旧路径留 stub。`tasks/`、`docs/` 不动。
2. 跑 `bash scripts/check-template.sh` + `powershell -ExecutionPolicy Bypass -File scripts/check-template.ps1`，确认 docs 相关断言不受影响、project/governance 相关新断言通过。
3. 在迁移前后跑限定路径审计：根级 `frontend/`、`backend/`、`tests/`、`docker/` 与根级治理目录引用只允许出现在兼容说明或经登记的旧路径说明中；同步脚本和派生验收的模式必须只命中 `project/` 子层。
4. 跑 `scripts/check-derived-sync.*`，确认禁止路径更新正确；检查普通与领域两条同步路线均不将项目件误判为同步文件。
5. `new-project.sh` 三种形态 smoke（web/docs/cli）：确认 `--shape` 在 `project/` 子层正确裁剪、生成的派生仓 README 路径正确、首提交不含 `_governance/` 内模板治理内容记录（保留各分区 README 种子）。
6. 作为 MINOR 变更，跑 `bash scripts/e2e-sync-check.sh`，并按 `template-docs/maintainer/e2e-regression-checklist.md` 完成 R4-R6 人工项和 e2e 报告；不以 `check-template` 绿灯替代下行回归。
7. 运行 `git diff --check` 与 `scripts/check-markdown-clean.ps1 _proposals ai-records`；验证结果写入独立 e2e 报告和本提案实施记录，而非改写 `docs/09`（模板仓不把 `docs/09` 作为本模板变更的验收记录）。

## 6. 边界与后续

- **docs/ 下一阶段单独梳理**（本提案明确缓移，勿忘）：需先厘清 `docs/` 混杂属性（项目事实 + 同步/脚本引用标准路径 + 模板自身 research 材料），再决定是否进 `project/`、`docs/research/` 是否归 `ai-records/`。
- **tasks/ 同步缓移**：`tasks/` 是跨 AI 协作任务单机制（非代码），本次保留根级；下阶段随 docs 一并梳理，评估归入 `_governance/`（与 `.ai/session-handoff.md` 协作语义同类）或独立根级目录。
- **模板自身 `docs/research/` 6 份评估**：本次不迁 `ai-records/`（是当前决策的研究证据，待后续独立审计归属）。
- **已拍板**：ROOT-C-008 治理归拢随本提案一并落地；Q6 `check-run*.log` 3 个垃圾文件随提案删除（已核实被 `.gitignore:25` `*.log` 覆盖、未跟踪，直接删除无需补 ignore 规则）。
- **未拍板项**（不影响本提案主体，待评估阶段确认）：Q7 派生仓可选代码聚合模式（建议后补）。
- **C1 评估结论（2026-08-21）**：`Go`。ROOT-C-001~009 的决策已齐备，远端 #370/#374/#334/#290 均已镜像并完成去重；影响面已补齐方法论、脚本和断言的路径迁移清单，且提案级 Markdown / 空白检查通过。实施仍须按 §5 的 MINOR 验证门槛执行，不得以本 C1 结论替代实现验证或 PR 评审。

## 7. 待确认项

| ID | 决策项 | AI 建议 | 依据 | 影响 |
|---|---|---|---|---|
| ROOT-C-001 | `project/` 容器是否启动 | **启动**（本提案落地） | 唯一根治"拷代码要手挑"；A/D 方案不根治 | 是否迁移代码骨架目录 |
| ROOT-C-002 | 派生侧布局 | **嵌套 B**（派生仓保留 `project/` 容器） | 用户拍板；两侧同构，单一标准 | `new-project.sh` --shape 路径 + 派生 README + 6 仓后续同步 |
| ROOT-C-003 | `src/` 是否合并 | **不合并**（原名迁入） | glm5.3 Q2 建议；少一层嵌套，`--shape` 裁剪简单 | 容器内部结构 |
| ROOT-C-004 | `docs/` 处理 | **本次不动，下一阶段单独梳理** | flowkit docs 仅任务记录，本仓 docs 混杂；避免范围蔓延 | docs 相关同步/脚本/断言全部不变 |
| ROOT-C-005 | 版本影响 | **minor** | 新增同步范围结构目录 | 版本规划 |
| ROOT-C-006（已拍板） | `new-project.sh` 治理泄漏 | **随本提案一并处理：裁内容、保留分区 README 种子** ✅ | 新派生仓需要空的治理区框架（`_governance/` 各分区 README 保留），不带模板治理内容记录；泄漏范围明确（`ai-records/`、`sync-records/`、`_proposals/`、`_archive/`、`_examples/` 内容应裁） | 派生仓初始内容纯净度 + 空治理区框架 |
| ROOT-C-007（已拍板） | `tasks/` 归属 | **不进 `project/`**，本次留根，下阶段随 docs 或 `_governance/` 再定 ✅ | `tasks/` 是跨 AI 协作任务单机制（非代码），与 `.ai/session-handoff.md` 同类，属协作/治理语义；放 `project/` 外更合适（用户确认） | `project/` 收 4 个纯代码目录；tasks 引用面 30+ 文件不动 |
| ROOT-C-008（已拍板） | 治理记录归入 `_governance/` | **随本提案一并落地** ✅ | 5 个治理目录均不在 `files_all`，零同步风险；根目录"一眼分类"目标 | 收拢治理记录 |
| ROOT-C-009（已拍板） | `check-run*.log` 删除 | **随提案删** ✅ | 已核实 `.gitignore:25` `*.log` 覆盖、未跟踪，无历史包袱 | 清理根目录残留 |

## 8. 落地流程

1. 本提案评审通过后，`checkout main` → 开实施分支 `feat/project-container-introduction`。
2. `git mv` 4 目录 → `project/`；`git mv` 5 治理目录 → `_governance/`；旧路径留 stub。`tasks/`、`docs/` 不动。
3. 按 §4 表改造来源文件（含 `_governance/` 跨目录引用巡检）。
4. 按 §5 跑本地 + CI 全绿。
5. PR 合并后更新 CHANGELOG，归档本提案到 `_archive/proposals/`。
6. 派生仓同步窗口（6 仓）在 v1.66.0 之后的下一个窗口携带本改动。
