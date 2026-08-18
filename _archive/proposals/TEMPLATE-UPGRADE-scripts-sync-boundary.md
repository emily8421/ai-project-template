# TEMPLATE-UPGRADE: 脚本同步边界分层——模板专用脚本移出下行清单 + 工具注册表 README 下行

> 来源：模板维护者（2026-08-18 延后池 triage 会话；吸收并关闭 C-016）
> 状态：**已落地**（2026-08-18 PR #371 squash merge `36a9ca7`，v1.65.0；CI template-check 通过 + 本地 L3 e2e 回归通过；归档时点随合并移入 `_archive/proposals/`）
> 目标版本：v1.65.0（MINOR）
> Release impact：minor（AI 建议，方向已获维护者确认；改变同步范围，按 `scripts/README.md` §4 治理规则必须提案、升版）
> Release strategy：单独发布；落地后随下次派生同步窗口做 6 仓孤儿清理

## 0. 执行摘要

现状：`template-sync.json` 把全部 15 个可执行脚本无差别放进 `files_all`，派生项目每次同步都被覆盖式下发；而其中 5 个（`check-template.sh/.ps1`、`sync-all-derived.sh`、`e2e-sync-check.sh`、`new-project.sh`）只有模板仓维护者和模板仓 CI 使用。同时 `scripts/README.md`（工具注册表，v1.61.6 建立）不在同步清单，派生项目获得脚本但不获得使用说明——这是 governance Batch 1 识别的 C-016 治理缺口。

本提案把脚本按「消费者」分为下行 / 不下行两类，补齐 README 下行与孤儿清理机制：

1. **5 个模板专用脚本移出 `files_all`**（模板仓自身是源，不需要"同步给自己"）。
2. **`scripts/README.md` 加入 `files_all`**（C-016 本体：工具注册表跟随 8 个仍下行的脚本走）。
3. **`new-project.sh` 派生路径适配**：新项目创建时删除这 5 个模板专用脚本（`new-project.sh` 用 `git archive` 全量复制模板，移出同步清单不影响初始复制，需要显式删除步骤）。
4. **孤儿清理与防回流审计**：同步是覆盖式、不删除，既有派生仓中的 5 个脚本需一次性清理；`post-sync-cleanup` 审计项新增「模板专用脚本残留」检查（与 v1.64.0 §2.3 裁剪审计机制同构）。
5. **配套小修**：`sync-template.sh` 兜底清单 `DEFAULT_SYNC_FILES` 同步调整；`scripts/README.md` 重写为「下行视角」（8 工具为主、模板仓专用 5 项单列"不下行"）并补 `Sync notice`；`check-template.sh` 断言更新；SOP / MAINTAINERS 措辞对齐。

## 1. 动机（去项目化）

### 1.1 脚本按真实消费者分为两类，现状混装

| 类别 | 脚本 | 真实消费者 | 下行判断 |
|---|---|---|---|
| **派生项目要用**（8 个能力，10 文件） | `sync-template.sh/.ps1`（TOOL-SYNC-001）、`check-derived-sync.sh/.ps1`（TOOL-SYNC-002）、`check-github-context.ps1`（TOOL-REMOTE-001）、`collect-env.ps1`（TOOL-ENV-001）、`check-prereqs.ps1`（TOOL-SETUP-001）、`check-runtime.ps1`（TOOL-ENV-002）、`bootstrap-dev-env.ps1`（TOOL-SETUP-002）、`check-markdown-clean.ps1`（TOOL-CHECK-002） | 派生项目 CI（`project-check.yml` 跑 `check-derived-sync.sh`）、同步流程、环境初始化、提交卫生 | **保留在 `files_all`** |
| **模板仓专用**（4 项能力，4 文件） | `check-template.sh`、`check-template.ps1`（TOOL-CHECK-001）、`sync-all-derived.sh`（TOOL-SYNC-003）、`e2e-sync-check.sh`（TOOL-RELEASE-001） | 模板维护者、模板仓 CI（`template-check.yml`） | **移出 `files_all`** |
| **模板仓专用**（1 文件） | `new-project.sh`（TOOL-PROJECT-001） | 在模板仓（或可访问模板的位置）创建新项目时 | **移出 `files_all`**（派生项目不再派生；领域模板自建 `new-domain-project.*`） |

### 1.2 证据（2026-08-18 抽查 + 既有事实）

- **误用防御散布 5 处**：`ai/commands/sync-methodology.md` §8、`ai/prompts/maintainers/12-sync-template.md`（2 处）、`15-post-sync-cleanup.md`、SOP / MAINTAINERS 多处反复提醒「派生项目不要用 `check-template`」「普通 PR 不应运行模板自检」。一个工具需要在多处规则里防御性提醒"别误用"，说明它不该出现在派生项目的 `scripts/` 里。
- **派生仓 CI 实测**：digital-cs-demo 与 agent-system-template 的 `.github/workflows/project-check.yml` 均只运行 `bash scripts/check-derived-sync.sh HEAD`，不运行 `check-template.*`。
- **派生仓孤儿实据**：digital-cs-demo `scripts/`（19 文件中 5 个模板专用脚本无 CI / 命令 / 文档引用，仅被同步反复覆盖）；zhiyan、LUMEN-DEMO 同样存在（LUMEN 还在 `scripts/` 叠加了自己的 10+ 业务脚本，模板专用脚本混在其中）。agent-system-template（领域模板）已自建 `check-agent-template.*` / `sync-domain-template.*` / `new-domain-project.*`，母模板下发的 4 个专用脚本在其目录中纯占位。
- **脚本间依赖核查**：`check-derived-sync.*` 与 `sync-template.*` 不调用模板专用脚本（仅输出文案提到 `check-template` 名称作为对比提示）；`sync-all-derived.sh` 调用 `sync-template.*`（方向正确：模板侧入口调用下行脚本，反之无依赖）。移出不影响任何下行脚本的运行。
- **C-016 缺口**（governance Batch 1 §16.2 / §16.4 记录）：`scripts/README.md` 不在 `template-sync.json`，派生项目获得脚本但不获得工具注册表。Batch 1 明确"作为独立后续事项评估，不阻塞"，即本提案。

### 1.3 为什么是 MINOR 不是 PATCH / MAJOR

- **非 PATCH**：`_proposals/README.md` 发布判断规则——同步范围结构变化属「新的下游采用面」；且 `scripts/README.md` §4 治理规则明确「改变同步范围必须提案、升版」。
- **非 MAJOR**：同步机制本身（`files_all` / `files_ordinary` / `files_domain` 三级清单 + 覆盖式同步）不变；只是清单成员调整。派生项目侧无强制迁移——孤儿脚本是"建议清理"而非"不清理即坏"（移出清单后同步不再覆盖它们，残留文件成为普通未跟踪项目文件，不破坏任何流程）。
- **MINOR 依据**：新下行文件（工具注册表 README）= 新下游采用面；同步范围成员变化需全量派生在下次同步时感知（dry-run 报告会显示新增 / 停更文件）。

## 1.1 与既有规则的关系（去重）

- **`scripts/README.md` 工具注册表**（`scripts/README.md`，v1.61.6 启用）：**合并入**——本提案吸收 C-016（注册表下行），并把注册表 §2.1 能力总览表重写为「下行 / 模板仓专用」两段视角；§5 缺口审计条目「本文件不在 template-sync.json」随落地关闭。
- **`template-sync.json` 三级清单机制**（`files_all` / `files_ordinary` / `files_domain`，`sync-template.sh` `parse_sync_array`）：**机制不同**——本提案不新增机制（不引入"模板专用"第四个数组键），模板专用脚本直接移出清单即可：模板仓自身持有源文件，无需任何清单登记。`files_ordinary` / `files_domain` 语义不变。
- **governance Batch 1 提案**（`_proposals/TEMPLATE-UPGRADE-governance-handbook-agent-tool-registry.md`）：**指向**——本提案关闭其遗留的 C-016 待确认项；不触碰 Batch 2-5（手册重构、角色契约等另行评估）。
- **v1.64.0 post-sync-cleanup 裁剪审计**（`ai/prompts/maintainers/15-post-sync-cleanup.md` §88-89「声明省略但目录 / 骨架仍存在」）：**互补不重复**——裁剪审计管「项目声明不用的目录 / 文档残留」，本提案新增审计项管「模板专用脚本残留」，机制同构（列出路径 → 提示清理 → 回填事实），合并进同一审计小节。
- **`new-project.sh` 裁剪步骤**（`--shape` / `_proposals` 排除 / workflow 替换）：**合并入**——新增删除 5 个模板专用脚本的步骤，与既有 `_proposals` 排除、`template-check.yml` 删除同类。
- **#334 Stack Adapter**（暂缓中）：**对象不同**——管 `template-docs/stack-adapters/` 载体，不管脚本分发。

**本提案不重复它们**：既有机制管「怎么同步」（三级清单）、「工具是什么」（注册表）、「裁剪怎么审计」（post-sync-cleanup）；缺的是「哪些脚本该同步」的边界定义与配套清理。差异化：首次把脚本维度的同步边界显式化。

## 2. 拟改

### 2.1 `template-sync.json`（核心改动）

- `files_all` 移出 5 项：`scripts/check-template.sh`、`scripts/check-template.ps1`、`scripts/sync-all-derived.sh`、`scripts/e2e-sync-check.sh`、`scripts/new-project.sh`。
- `files_all` 移入 1 项：`scripts/README.md`。
- `description` 字段补一句：清单只含下行到派生项目的文件；模板仓专用脚本（自检 / 批量同步 / 发布回归 / 建项目入口）不在此列。

### 2.2 `scripts/README.md`（重写为下行视角）

- 头部补 `Sync notice`（Markdown 形态，对齐 `template-docs/*.md` 惯例；当前是 `scripts/` 下唯一缺 notice 的同步候选文件，`check-template.sh` `require_sync_notice` 会校验）。
- §1 登记口径改写：区分「随模板下行（8 能力 / 10 文件）」与「模板仓专用、不下行（5 文件）」两段；说明专用脚本在模板仓 `scripts/` 可见、派生项目不会获得。
- §2.1 / §2.2 表格按上述分组重排（派生项目侧 8 能力在前；模板仓专用 4 能力标注「运行位置：仅模板仓」）。
- §5 缺口审计：C-016 条目改为已落地记录（2026-08-18，v1.65.0）。
- 补「孤儿脚本清理」小节：历史版本曾下行、现已移出清单的脚本，派生项目可安全删除；列出清理清单与判断依据。

### 2.3 `scripts/sync-template.sh`（兜底清单 + 提示对齐）

- `DEFAULT_SYNC_FILES`（`template-sync.json` 不可读时的兜底）同步调整：移出 5 项、移入 `scripts/README.md`，与主清单保持一致。
- `warn_derived_workflow_migration` 附近不动（该提示继续有效：防派生项目误装 `template-check.yml`）。
- 输出提示若提及「同步 N 个文件」，无需改动（计数自动反映）。

### 2.4 `scripts/new-project.sh`（初始裁剪）

- 在既有裁剪段（`rm -rf _proposals` / `rm -f template-check.yml` 附近）新增：删除 `scripts/check-template.sh`、`scripts/check-template.ps1`、`scripts/sync-all-derived.sh`、`scripts/e2e-sync-check.sh`，并自删 `new-project.sh` 自身。
- 生成的新项目 README / `.gitignore` 不受影响；`--shape` 路径叠加在本步骤之后，无交互。
- 提示文案补一行：新项目不再包含模板仓专用脚本；工具说明见 `scripts/README.md`（下行版）。

### 2.5 `scripts/check-template.sh` / `.ps1`（断言更新）

- 同步清单自洽断言（`template-sync.json` 成员存在性、`Sync notice` 覆盖）自动适配：`scripts/README.md` 需含 `Sync notice`；5 个移出文件不再要求 notice 校验范围内的清单成员身份（模板仓自身文件仍保留各自 notice 头，不变）。
- 新增断言：`template-sync.json` 不含 5 个模板专用脚本路径（防回流）；含 `scripts/README.md`。
- 新项目烟测（本地 `--local --no-remote` 场景）新增检查项：产物项目 `scripts/` 不含 5 个模板专用脚本、含 `scripts/README.md`。
- PowerShell fallback 结构断言同步（`.ps1` 结构性兜底范围内）。

### 2.6 `ai/prompts/maintainers/15-post-sync-cleanup.md` + `ai/commands/post-sync-cleanup.md`（审计项）

- 审计清单新增一条（与 §88-89 裁剪审计同构）：「`scripts/` 中是否存在已移出同步清单的模板专用脚本残留（`check-template.*` / `sync-all-derived.sh` / `e2e-sync-check.sh` / `new-project.sh`）——列出路径，提示可安全删除；删除后无需回填任何字段（它们不是项目资产）」。

### 2.7 `SOP.md` / `MAINTAINERS.md` / `template-docs/env-setup.md`（措辞对齐）

- SOP C3 / MAINTAINERS 维护流程：注明 `check-template.*` / `sync-all-derived.sh` / `e2e-sync-check.sh` 仅模板仓存在（措辞微调，命令不变）。
- `template-docs/env-setup.md` §「check-prereqs 通过后可运行 new-project」链路：明确 `new-project.sh` 在模板仓运行（现状已是如此，仅消除"项目内也有此脚本"的歧义）。

## 3. 版本

模板版本：**MINOR → v1.65.0**。依据：同步范围成员变化（5 出 1 入）+ 新下行文件（工具注册表）= 下游采用面变化；`scripts/README.md` §4 治理规则要求。非 MAJOR：同步机制与清单结构不变，派生侧无强制迁移。

## 4. 影响

- **模板仓**：`scripts/` 目录文件不删（模板仓继续持有全部 15+ 文件），仅清单与文档视角变化；CI（`template-check.yml`）不受影响。
- **派生项目（下次同步起）**：`scripts/README.md` 新增出现；5 个模板专用脚本停更（不再被覆盖）。**停更 ≠ 删除**：同步不删文件，孤儿清理由各项目按 §2.6 审计项自行执行（一次性 `rm`，随下次同步的 post-sync-cleanup 一并做）。
- **新项目（`new-project.sh` 产物）**：`scripts/` 初始即只含下行集合 + README，无孤儿问题。
- **agent-system-template（领域模板）**：收益最大——4 个纯占位脚本消失；其自建 `check-agent-template.*` / `new-domain-project.*` 不受影响。注意其 `files_domain` 路线继承 `files_all`，清单变化自动生效。
- **回滚方式**：模板侧 revert PR 即可恢复清单；派生侧已删孤儿如需恢复，从模板仓复制回即可（5 个文件均为模板资产，无项目侧状态）。
- **风险**：① 个别维护者习惯在派生项目本地跑 `check-template.sh` 快速验证——抽查 2 仓 CI 均不用；落地前剩余 4 仓确认一次（已抽查 digital-cs-demo / agent-system；zhiyan / LUMEN / LumiOne / gmbl 待同步窗口顺带确认）。② `sync-template.sh` 兜底清单若与主清单不同步会造成行为分叉——§2.3 已列为同 PR 改动项 + §2.5 断言守护。

## 5. 验证方式

1. `bash scripts/check-template.sh`（或 `--summary`）：清单自洽断言 + 新增防回流断言 + 烟测新检查项全过。
2. `powershell -ExecutionPolicy Bypass -File scripts/check-markdown-clean.ps1 _proposals scripts/README.md`：改动 Markdown 卫生。
3. `bash scripts/new-project.sh smoke-test-boundary --local --no-remote --no-examples` 烟测：产物 `scripts/` 无 5 个模板专用脚本、含 README。
4. `bash scripts/sync-template.sh <派生仓> --dry-run`（选 1 仓）：dry-run 报告正确显示 `scripts/README.md` 新增、5 个文件停更（不在清单）。
5. 人工评审：`scripts/README.md` 重写后的分组视角、post-sync-cleanup 审计项措辞、SOP / MAINTAINERS 对齐。

## 6. 备选（已评估未采）

- **仅 README 下行，不动脚本**（C-016 窄方案）：不解决误用防御散布与孤儿占位问题；README 下行后反而要向派生项目解释 5 个它们不该有的工具。否决。
- **新建 `scripts/template-only/` 子目录物理隔离**：路径迁移 = MAJOR（全量引用更新），且模板仓内部组织问题不值得动同步机制。否决。
- **用 `files_ordinary` / `files_domain` 反向排除**（把模板专用放进某路线、靠另一路线排除）：语义错位——这两个数组是「附加」不是「排除」，模板仓自己也不走同步路线。否决。
- **`sync-template.*` 增加删除逻辑（同步时自动删孤儿）**：同步语义从"覆盖"变"覆盖 + 删除"，风险升级且违背既有设计（派生项目文件所有权归项目）。孤儿清理留在项目侧审计项。否决。

## 7. 落地流程（执行时核对）

1. 切维护分支 `feat/scripts-sync-boundary`。
2. 按 §2.1-2.7 修改（提案先入 `_proposals/`，同 PR）。
3. §5 验证全过 → PR → squash merge → v1.65.0，CHANGELOG 登记。
4. 提案移入 `_archive/proposals/`；C-016 在后续 C1 计划文档中标记已消化。
5. 下次派生同步窗口：6 仓同步 v1.65.0 + post-sync-cleanup 顺带孤儿清理 + registry 更新。

## 8. 待确认项

| ID | 待确认项 | 结论（已拍板 2026-08-18） | 建议依据 | 备选方案 | 取舍影响 / 阻塞关系 |
|---|---|---|---|---|---|
| C-017 | 6 仓孤儿清理时点：随本 PR 只做模板侧 vs 留到下次同步窗口 | **按建议：留到下次同步窗口** | 孤儿无危害（停更不破坏流程）；集中一次做省 6 次上下文切换 | 本 PR 后立即逐仓清理 | 立即清理需 6 仓逐个开分支提交，成本前置且无收益 |
| C-018 | LumiOne / gmbl（init 阶段）是否随下次同步一并到 v1.65.0 | **按建议：一并（与 registry 快照核对合并处理）** | 两仓 v1.61.4 落后 3 版；孤儿清理对 init 阶段仓同样适用 | 维持落后单独排期 | 不一并则 registry 核对仍要单独跑一轮 |

（维护者 2026-08-18 已拍板：`new-project.sh` 移出；本 MINOR 现在做、不等 governance Batch 2；C-017 / C-018 均按 AI 建议执行。）
