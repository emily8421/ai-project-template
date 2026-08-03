# TEMPLATE-UPGRADE: 模板治理分层（project-rules/domain-rules + 同步路线 + 边界声明）

> 来源：模板维护者
> 状态：候选（v3，已吸收评审 P1-1/P1-2/P2-1/P2-2/P2-4）
> 目标版本：待确认（AI 建议：第一+二阶段 patch → v1.59.3；第三阶段（含同步路线/边界）minor → v1.60.0；或合并为 v1.60.0 单次 minor）
> Release impact：minor（AI 建议，待维护者确认）
> Release strategy：同主题聚合（一份提案，可分 PR 落地）
> 关联：延续 doc-standards 分层（`TEMPLATE-UPGRADE-doc-standards-location` / `batch-3-1-doc-standards-layering`）与领域模板方法论（`domain-template-lab` / `domain-templates.md`）；Sync notice 覆盖 + json 自声明另起独立 patch `TEMPLATE-UPGRADE-sync-notice-coverage.md`

## 1. 背景与问题

### 1.1 project-rules.md 身兼三职，而 docs 体系已三层分离

`docs/` 文档体系已建立三层分工（`ai/doc-standards/README.md` L16-23 等）：规范/审计基线（`ai/doc-standards/*`，同步）、结构参考副本（`template-docs/docs-scaffold/*`，同步）、种子实例（`docs/00-09`，不同步）。而 `ai/project-rules.md` 只有单层，同时承担规范基线 + 种子模板 + 项目事实三职。

### 1.2 后果：约束"分散"是结构性的

约束 `project-rules` 的规则散落在 9 类出处（自身头部、global-rules、各 doc-standards、CONTRIBUTING、MAINTAINERS、git-guide、12-sync-template、15-post-sync-cleanup、check-template.sh 11+ 断言 / check-derived-sync.sh）。带来：难评估有效性、易漂移、章节号单点修改风险。

### 1.3 领域层（domain template）存在真实缺口

全仓搜 `domain-rules` 零命中；领域专属约束只能塞进 `TEMPLATE-BASE.md` 的 `Domain standards scope`（TODO 占位）。规则只有两层（global → project-rules），缺中间层"领域通用但跨项目"。

### 1.4 同步路线与边界声明同样分散（与 1.2 同构）

两条路线同步文件集完全相同（共享扁平 `template-sync.json`，差异仅 TEMPLATE-BASE.md 写法）；受保护/可覆盖清单三处分散（sync.json 纯列表、check-derived-sync 硬编码、Sync notice）；TEMPLATE-BASE.md 不列受管文件。

## 2. 设计目标

1. project-rules 规范收敛到单一事实源（standards 层）。
2. 复用 docs 三层模型。
3. 补齐领域层 rules 缺口。
4. 保持实例层不同步。
5. 不破坏现有派生项目。
6. 同步路线与边界声明事实源化。

## 3. 已确认决策（本轮拍板）

| 决策项 | 选定方案 | 理由 |
|---|---|---|
| 领域 rules 同步策略 | 方案①全不同步 | 与现有机制一致，零新代码。 |
| scaffold 层 | 不建 | 两层已足够。 |
| 落地范围 | 做到第三阶段 | 一次性补齐。 |
| 清单分类形式 | 分三个组（`files_all`/`files_ordinary`/`files_domain`） | 直观、改动小。 |
| Sync notice 覆盖 + json 自声明 | 独立 patch | 与本主题弱相关、可独立闭环。 |
| 路线 + 边界 | 并进本提案（§4.4 / §10） | 与规则文档分层同构。 |

## 4. 建议方案

### 4.1 project-rules：补 standards 层（两层）

| 层 | 载体 | 是否同步 |
|---|---|---|
| 规范/审计基线 | `ai/doc-standards/project-rules.md` 🆕 | 是（进 `files_all`） |
| 种子实例 | `ai/project-rules.md` | 否（已有 → 瘦身） |

### 4.2 domain-rules：母模板只给 standards，种子由领域仓自生成

母模板只提供 `ai/doc-standards/domain-rules.md`（进 `files_domain`）；种子 `ai/domain-rules.md` 由领域模板仓按 standards 自生成（母模板不放）。避免母仓放无意义占位 + 普通派生拿到无用文件。

### 4.3 收敛动作（规则文档分层）—— 引用迁移须分两类（P1-1 修正）

**关键：不是所有 `project-rules` 引用都该改指向 standards。** 各 `ai/doc-standards/*` 对 `ai/project-rules.md` 的引用分两类，迁移时必须区分：

- **A 类·字段规范引用**（指向"§X 字段定义/规范"，应迁移到 `ai/doc-standards/project-rules.md §X`）：
  - `05-tech-spec.md:21`（见 §2.9 运行时版本锁定）、`04-architecture.md:43`（§2.6 图表格式）等"见 §X 字段"。
- **B 类·项目实例权威位置引用**（指向"项目实例要填/要检查的状态"，**保持指向 `ai/project-rules.md` 实例，不得迁移**）：
  - `03-prd.md:61`（给 project-rules.md：当前 Phase 允许/禁止/预告 —— 回填到实例）、`03-prd.md:36`（Phase 变更传播到实例 §1）、`06-db-design.md:10`/`07-api-spec.md:10`（按 §3 裁剪 —— 实例决策）、`08-dev-plan.md:70`（与 project-rules 一致）、`09-verification.md:61/71/72`（检查实例状态/阶段一致性）、`frontend-interaction.md:10`/`design-doc.md:10`/`ui-prototype-strategy.md:28,32`（在 §X 写豁免 —— 实例要填）。

迁移原则：**只迁移 A 类；B 类保持不动**。误把 B 类改成指向 standards 会把"项目实例权威位置"改成"规范落点"，破坏文档链路（如 03 生成后 Phase 无处回填）。

其余收敛：① `check-template.sh` 的 project-rules 断言清单与 standards 对齐（standards 为单一事实源）；② `global-rules.md` 收敛"规则分层原则"小节指向 standards。

### 4.4 同步路线与边界声明（概要，详 §10）

1. 按路线差异化同步：`template-sync.json` 拆三组；`sync-template.sh` **及 `.ps1`** 的文件加载按路线选组（P1-2）。
2. 边界声明：不新建第四套清单（尊重 `MAINTAINERS.md` L65）；派生 `TEMPLATE-BASE.md` 加受管文件指针行。
3. json 的"勿改"自声明 + 所有同步文件的 Sync notice 覆盖，归独立 patch（P2-4 重组，使 patch 自洽）。

## 5. 落地路径（三阶段）

### 第一阶段（patch）：建 project-rules standards + 入清单 + 最小断言（P2-1 修正）

- 新建 `ai/doc-standards/project-rules.md`。
- **同步入 `template-sync.json`（`files_all` 组）**——遵守 `MAINTAINERS.md` L64「新增规则文件必须同时更新 template-sync.json 和自检断言」。
- **加最小自检断言**：`check-template.sh` + `check-template.ps1` 断言该 standards 文件存在、带 Sync notice。
- 此阶段**不改既有断言、不迁移引用**（仅作为对照基线落地 + 合规入清单）。

### 第二阶段（patch）：断言与引用对齐（仅 A 类引用）

- `check-template.sh` + `check-template.ps1` 的 project-rules 断言清单与 standards 对齐。
- **仅迁移 A 类引用**（§4.3）到 `doc-standards/project-rules.md`；B 类保持不动。
- `global-rules.md` 收敛"规则分层原则"。
- `ai/project-rules.md` 瘦身（剥离规范长文，保留填写骨架）。
- `CONTRIBUTING.md` / `MAINTAINERS.md` / `15-post-sync-cleanup.md` 判断标准指向 standards。

### 第三阶段（minor）：领域层 + 同步路线 + 边界声明

- 新建 `ai/doc-standards/domain-rules.md`（进 `files_domain`）。
- `domain-template-lab` + `23-domain-template-lab.md`：领域模板创建时按 standards 生成领域仓 `ai/domain-rules.md` 种子。
- **`template-sync.json` 拆三组**；`sync-template.sh` **+ `sync-template.ps1`** 的 `load_sync_files`/`Get-SyncFilesFromRef` 按路线选组；`check-derived-sync.sh` **+ `.ps1`** 的 `Get-SyncFiles` 同步改（P1-2）。
- `TEMPLATE-BASE.md` 两个 writer（普通 L335-373 / 领域 L375-425）各加受管文件指针行。
- `check-derived-sync.sh` **+ `.ps1`**：受保护路径加 `ai/domain-rules.md`（方案①不同步）（P1-2）。
- `12-sync-template.md` 步骤 13 补 domain-rules；`template-docs/domain-templates.md` 增领域 rules 说明；`MAINTAINERS.md`/`git-guide.md` 边界说明对齐。
- **`check-domain-derived-sync.*` 不在本仓修改**（见 §9 已知限制）——改为更新 `domain-template-lab` 生成模板，让未来领域仓自带 domain-rules 保护（P2-2）。

## 6. 拟改范围（文件清单）

**新增**
- `ai/doc-standards/project-rules.md`（一阶段）
- `ai/doc-standards/domain-rules.md`（三阶段）
- 领域仓的 `ai/domain-rules.md` 种子（三阶段，由 `domain-template-lab` 生成）

**修改**
- `ai/project-rules.md`（二阶段瘦身）
- `ai/global-rules.md`（二阶段收敛分层原则）
- `scripts/check-template.sh` **+ `scripts/check-template.ps1`**（一阶段最小断言；二阶段断言对齐）—— P1-2/P1-3
- `scripts/check-derived-sync.sh` **+ `scripts/check-derived-sync.ps1`**（三阶段受保护路径加 `ai/domain-rules.md`；`Get-SyncFiles` 读三组）—— P1-2
- `scripts/sync-template.sh` **+ `scripts/sync-template.ps1`**（三阶段 `load_sync_files`/`Get-SyncFilesFromRef` 按三组选组；两个 TEMPLATE-BASE writer 加指针）—— P1-2
- `template-sync.json`（三阶段拆三组；`project-rules standards` 进 `files_all`、`domain-rules standards` 进 `files_domain`、`ai/domain-rules.md` 不入清单；**description 自声明归 patch，不在本提案**）—— P2-4
- `ai/commands/domain-template-lab.md` + `ai/prompts/maintainers/23-domain-template-lab.md`（三阶段纳入领域 rules 初始化 + 生成 domain-rules 保护逻辑）
- `ai/prompts/maintainers/12-sync-template.md`（三阶段步骤 13 补 domain-rules）
- `ai/prompts/maintainers/15-post-sync-cleanup.md`（二阶段审计对照 standards；三阶段补 domain-rules）
- 各 `ai/doc-standards/*`（二阶段仅迁移 A 类引用，B 类不动）+ `ai/session-rules.md` + `ai/commands/scenario.md` —— P1-1
- `CONTRIBUTING.md` / `MAINTAINERS.md` / `git-guide.md`（二阶段判断标准；三阶段边界说明）
- `template-docs/domain-templates.md`（三阶段）；`CHANGELOG.md`/`README.md`

## 7. 版本影响

整体 **minor**（新能力层 + 按路线差异化同步的同步行为变化）。建议拆 `v1.59.3`（patch，一+二阶段）+ `v1.60.0`（minor，三阶段）；或合并 `v1.60.0`。Sync notice + json 自声明的 release impact 归独立 patch（patch 级）。

## 8. 验收口径

- `ai/doc-standards/project-rules.md` 为字段规范单一事实源；在 `template-sync.json` `files_all` 内；带 Sync notice。
- `check-template.sh` + `check-template.ps1` 的 project-rules 断言与 standards 对应（双脚本一致）。
- A 类引用迁移到 standards；B 类引用仍指向 `ai/project-rules.md` 实例（抽查 03:61/36、09:61/71/72 保持不动）。
- 领域模板创建后持有 `ai/domain-rules.md` 种子 + 同步下来的 standards；普通派生不出现 domain-rules。
- **按路线同步**：普通路线 dry-run/sync 不含 domain-rules；领域路线含（来自 `files_domain`）。**Bash 与 PowerShell 行为一致**（P1-2）。
- `ai/domain-rules.md` 不在 `template-sync.json`，受 `check-derived-sync.sh`+`.ps1` 保护。
- 派生 `TEMPLATE-BASE.md` 含受管文件指针行。
- `check-template.sh`+`.ps1` / `check-derived-sync.sh`+`.ps1` 全绿。
- **本 PR 验收只管本仓存在的脚本**；`check-domain-derived-sync.*` 的领域侧保护通过"更新 domain-template-lab 生成模板"保证，不在本仓验收范围（P2-2）。

## 9. 风险与缓解

- **A/B 类引用误判**：迁移前对每处引用逐条标注 A/B（已在本提案 §4.3 给出分类与例子）；落地时配 `*-patch.md` 列 old→new，仅改 A 类。
- **章节号迁移牵动面广**：standards 为唯一引用源；防文档滞后断言保障。
- **Bash / PowerShell parity**：所有同步/检查脚本改动必须 `.sh` + `.ps1` 成对（MAINTAINERS L68）；CI 两条路径都跑（P1-2）。
- **第一阶段纪律**：新 standards 即时入 `template-sync.json` + 自检断言，不留"悬空文件"（MAINTAINERS L64）（P2-1）。
- **`ai/project-rules.md` 瘦身**：只瘦模板仓种子的规范长文；派生实例不受影响（种子不同步）；瘦身后 `check-template.sh`+`.ps1` 确认仍含所有被断言章节。
- **存量领域模板（agent-system-template）无 domain-rules**：由其 post-sync-cleanup 按 standards 补建种子。
- **已知限制·领域→领域派生段未打通（P2-2）**：`domain-template-lab` 是 AI 工作流；`check-domain-derived-sync.*` / `sync-domain-template.*` / `domain-template-sync.json` 在本仓不存在（未落地 Batch 3）。因此：① 本次按路线同步只打通"母模板→领域模板"段；② `check-domain-derived-sync.*` **不在本仓修改也不在本 PR 验收**，改为更新 `domain-template-lab` 生成模板（`23-domain-template-lab.md`），让未来生成的领域仓自带 domain-rules 保护；③ 端到端链路（至领域派生）依赖 Batch 3。

## 10. 同步路线与边界声明的事实源化（详述）

### 10.1 按路线差异化同步（清单分三组，Bash + PowerShell）

- `template-sync.json` 由扁平 `files` 拆为 `files_all`/`files_ordinary`/`files_domain`；向后兼容（仅有 `files` 视为 `files_all`）。
- `sync-template.sh` `load_sync_files()`（L279-292）**与 `sync-template.ps1` `Get-SyncFilesFromRef`（L248）** 都改为：总集 = `files_all` ∪（普通 ? `files_ordinary`）∪（领域 ? `files_domain`），再叠 VERSION/CHANGELOG 过滤。路线判定复用 `detect_lineage_role()`。
- `check-derived-sync.sh` **+ `.ps1` `Get-SyncFiles`（L257）** 同步读三组（P1-2）。
- `domain-rules standards` 进 `files_domain`；`project-rules standards` 进 `files_all`。
- `check-template.sh`+`.ps1` 增断言：`files_domain` 内文件不得同时出现在其他组（防误配）。

### 10.2 边界声明（不新建清单，强化既有事实源）

- 尊重 `MAINTAINERS.md` L65：不复制完整清单到人读文档。
- 派生侧指针：`TEMPLATE-BASE.md` 两个 writer 各加"本仓受模板同步管理的文件见 `template-sync.json`，直接修改会在同步时被覆盖"。只指路、不抄清单。
- **json 自声明 + Sync notice 覆盖归独立 patch**（P2-4）：因 json 无法内嵌注释，`template-sync.json` 的"勿改"声明只能放 `description` 字段；这与"让所有同步文件带勿改声明"是同一主题，归 `TEMPLATE-UPGRADE-sync-notice-coverage.md` 闭环，不在本提案。
