# TEMPLATE-UPGRADE：三层布局模式定型（母模板 → 领域模板 → 领域派生项目）

> 来源：模板维护者（2026-09-10 领域布局设计会话；维护者提出目录可读性与三层直观链路诉求）
> 状态：已确认，随本 PR 实施（C-001~C-005 全按 AI 建议裁决，2026-09-10；Batch A + B(R0+) 落地 v1.75.0，Batch C / D 另行）
> 目标版本：v1.75.0（MINOR；C-004 裁决单版发 Batch A + B(R0+)）
> Release impact：minor（建议，待确认；规则/同步清单变更下行影响派生项目）
> Release strategy：分批——Batch A 模式定型（本提案主体）→ Batch B L1 收敛（档位待 C-003 裁决，默认不迁移）→ Batch C agent-system-template L2 迁移 → Batch D 新 L2（Web 类）建仓套用

## 1. 动机

三层链路的**机制**已就位（inheritance 提案 Batch 1 / Batch 3 部分：`--domain-template` 角色分支 v1.47.0、`files_domain` 组 v1.60.0、领域版 `TEMPLATE-BASE.md`、registry 谱系、`domain-template-lab` 实验入口），但**布局模式未定型**：

- L2 领域模板：inheritance 提案 Batch 2 规划的文件集本身散布（`template-docs/agent-system/*` + `docs/design/*` + `ai/domain-rules.md`）；领域自有件混在 L1 覆盖同步区（`template-docs/`）内，`ls` 根目录看不出「母模板 + 领域叠加」，所有权靠心智记忆。
- L1 母模板：领域机制件散布 6 处（profiles / maintainer / doc-standards / commands+prompts / scripts / template-sync.json），无单一索引，「哪些是领域层内容」不可枚举。
- L3 领域派生项目：无实例、布局未定义；第二个领域模板（Web 类，Batch 0 候选观察中）建仓在即，无章可循。

时机论证：Web 类 L2 未建仓（零迁移成本）；agent-system-template 在 registry 挂有「L2 目录迁移待独立处理」既有待办——现在定型模式，两项皆顺势。

## 2. 三层布局模式（核心定义）

### 2.1 L2 领域模板标准布局

```text
<domain>-template/                ← L2 领域模板仓
├─ ai/  template-docs/  scripts/  docs/ ...   ← 母模板同步结构，原样不动
├─ ai/domain-rules.md             ← 领域规则种子（唯一例外于 domain/，见 C-002）
├─ domain/                        ← ★ 唯一领域目录（L2 自有，L1 同步永不触碰）
│  ├─ README.md                   ← 领域定位 + 导览 + 与 TEMPLATE-BASE scope 对应
│  ├─ standards/                  ← 领域标准件（如 agent：tool 权限矩阵 / memory / eval / trace / HITL 骨架）
│  ├─ scenarios.md                ← L2→L3 场景剧本（从母模板骨架实例化）
│  ├─ scaffold/                   ← 领域派生项目生成件 / checklist
│  └─ checks/                     ← 领域自检（成熟后启用）
├─ TEMPLATE-BASE.md               ← 领域版溯源（既有机制；Domain standards scope ↔ domain/ 内容对应）
└─ VERSION / CHANGELOG ...        ← 领域自有（--domain-template 已保留）
```

规则：

- `domain/` 是**保留名**，登记进 `ai/global-rules.md` §5 根级命名空间准入（L2 / 领域派生项目专属可选目录；L1 母模板无此目录；普通派生项目不使用）。
- `domain/` 与 `ai/domain-rules.md` 归 L2 自有：不进任何 L1 同步清单，受 `check-derived-sync.*` 保护（既有保护机制扩展一条路径）。
- 必须根级：不得塞进 `template-docs/<domain>/`——L2 仓内 `template-docs/` 是 L1 覆盖同步区，领域自有内容放覆盖区会混淆所有权（现状耦合感的根源）。

### 2.2 L3 领域派生项目标准布局

```text
<project>/                        ← L3
├─ ai/  template-docs/  scripts/ ...   ← 通用方法论（L1 经 L2 下行）
├─ domain/                        ← L2→L3 覆盖同步区（标准件 + 剧本 + scaffold，随 L2 同步清单下行）
├─ docs/  project/  tasks/        ← 项目产出（自有）
└─ ai/project-rules.md            ← 项目事实种子（含领域规则的项目化实例）
```

- L3 **不设** `ai/domain-rules.md` 种子：规则分层三层已定义（通用 / 项目专属 / 领域专属），领域规则到 L3 落入 `ai/project-rules.md` 项目化，避免第三份领域规则文件漂移。
- L3 的 `domain/` 相对 L2 是覆盖同步区，项目不得直改；领域件的项目化改写走项目自有文档。

### 2.3 L1 母模板布局与边界

- L1 根目录**不出现任何领域目录**；领域机制件继续按功能归位（规范基线在 `ai/doc-standards/`、命令在 `ai/commands/`、机制在 scripts / `template-sync.json`）。
- `template-docs/profiles/domain-templates.md` 新增**「母模板领域机制件索引表」**（单一视图终结「不好区分」）：

| 文件 / 位置 | 角色 | 下行 |
|---|---|---|
| `template-docs/profiles/domain-templates.md` | 方法论定位 + 布局模式 + 索引表 | files_all |
| `template-docs/maintainer/domain-derived-scenarios-template.md` | L2→L3 剧本骨架（领域无关） | files_domain |
| `ai/doc-standards/domain-rules.md` | 领域规则基线（任何领域通用的种子规范） | files_domain |
| `ai/commands/domain-template-lab.md` + `ai/prompts/maintainers/23-*.md` | AI 实验入口 | files_all |
| `scripts/sync-template.*` / `check-derived-sync.*` 内 `--domain-template` / `files_domain` 分支 | 同步机制本体 | 不下行（脚本专用） |
| `_governance/ai-records/project-registry/` Type / Upstream 字段 | 谱系索引 | 不下行 |

新增领域机制件必须登记进索引表（文档约定，不加 check 硬断言——与 rd-data-chain §4「无自检门禁、避免过度治理」口径一致）。

## 3. 多领域扩展语义（一仓一领域）

- **扩展单元是仓库，不是目录**：一个领域 = 一个独立 L2 仓；`domain/` 语义为「本仓的那个领域」。领域数量增长 = L2 仓数量增长，仓内结构不随 N 变化。
- **领域身份三标识**：仓库名（如 `agent-system-template`）、registry `Type`/`Upstream` 字段、`TEMPLATE-BASE.md` 的 `Domain standards scope`。目录名统一是可识别模式的来源（类比各仓 `docs/` 内容不同但目录名统一）。
- **L1 不随 N 膨胀**：L1 机制件全部领域无关参数化（基线管「任何领域的种子长什么样」、剧本骨架管通用环节、机制按仓识别角色）；各领域的标准件永不进 L1。
- **形态（profile）与领域（domain）判分**：`web-fullstack-profile` 等形态 profile 管工程形态通用约束，随 files_all 下行给所有项目；只有满足 domain-templates.md §2 三条件（多同类项目 / 需独立版本与自检 / 共享领域标准件）才建领域模板。多数「Web 项目」走 L1 + 形态 profile 即可；Web 类 L2 面向「Web 产品线族群」。
- **跨领域项目**：单继承是当前边界——L3 只有一个直接上游，选主领域 L2（标准件更重者），另一边靠 L1 形态 profile 兜住通用约束；「多领域叠加 / 多重继承」明确不设计，待真实第 2 例出现再评估。
- **领域间共享标准**：不做 L2↔L2 横向同步（横向依赖是漂移之源）；共享信号即「跨领域通用」，走两级回流上浮（L2 提炼 → 提案 → L1 收编，两个 L2 下次同步获得）。链路保持严格单向：L1 → L2 → L3，回流只向上。

## 4. 拟改（分批）

| 批次 | 文件 | 变更 |
|---|---|---|
| A 模式定型 | `ai/global-rules.md` §5 | 根级命名空间准入登记 `domain/`（L2/L3 专属可选保留名）；三层区表加一行 L2/L3 视角注记 |
| A | `template-docs/profiles/domain-templates.md` | 新增 §「三层布局模式」（2.1/2.2/2.3 tree + 规则）、§「多领域扩展语义」（§3 内容）、§「母模板领域机制件索引表」 |
| A | `ai/doc-standards/domain-rules.md` | 基线补一条口径：种子位置 `ai/domain-rules.md` 是 `domain/` 的唯一例外及其理由 |
| A | `_governance/_proposals/TEMPLATE-UPGRADE-domain-template-inheritance.md` | 修订 Batch 2 最小文件集：`template-docs/agent-system/* + docs/design/*` → §2.1 `domain/` 布局；处理记录加注本提案来源 |
| A | `scripts/check-derived-sync.sh` / `.ps1` | 保护清单补 `domain/` 路径（既有保护机制扩展，非新机制） |
| B L1 收敛（档位待 C-003，默认 **R0+ 不迁移**） | R0+：机制件索引表 + 各机制件头部「领域层机制件」标记；R1-lite：剧本骨架移入 `profiles/`；R1：独立 `template-docs/domain-layer/` 目录 | 见 C-003 论证（含 L2 双 domain 目录碰撞问题） |
| C L2 迁移 | agent-system-template 仓（独立会话） | 按§2.1 迁移领域内容入 `domain/`；`TEMPLATE-BASE.md` scope 对齐；对齐 registry 既有「L2 目录迁移」待办 |
| D 新 L2 套用 | Web 类领域模板建仓时 | 直接按 §2.1 生成（Batch 0 观察转化时） |

## 5. 明确不做

- 不引入多领域叠加 / 多重继承机制（待真实需求）。
- 不做 L2↔L2 横向同步。
- 不改 `sync-template.*` 同步算法 / 角色分支语义（仅可能动路径与保护清单）。
- 不要求任何存量普通派生项目变化（两层主路径不动，与 domain-templates.md §0 一致）。
- 不给索引表 / `domain/` 结构加 check-template 硬断言（避免过度治理；靠文档约定 + check-derived-sync 既有保护）。
- 本提案不执行 L2 迁移（Batch C 是 L2 仓自身工作）。

## 6. 与既有规则 / 机制关系（去重）

- **inheritance 提案（pending）**：本提案是其**布局维度**的细化与修订（Batch 2 文件集）；三层职责边界、同步机制、版本保留（v1.47.0 / v1.60.0）全部沿用，不重复定义。两提案关系：inheritance 管「三层是什么、怎么同步」，本提案管「三层各自长什么样、多领域怎么扩展」。
- **domain-templates.md §0-§8**（原 §5-§7 顺延为 §6-§8，新增 §5 布局模式）：定位 / 判定 / 机制部分不动；本提案补布局与多领域语义 + 索引表。
- **global-rules §5 根级命名空间三分与点目录准入**：`domain/` 是新增条目（非点目录），与准入清单并列登记；不改动既有三分框架。
- **v1.67.0 治理目录迁移先例**：沿用「治理记录归 `_governance/`、方法论归 `template-docs/`」方向，不推翻。
- **web-fullstack-profile / web-app-scaffold-experiment**：形态 profile 不迁移不改动；形态 vs 领域判分在 domain-templates.md 写明（§3）。
- **governance-handbook-agent-tool-registry / template-check-maintainability（另两份 pending 提案）**：主题无重叠（治理手册工具登记 / 自检脚本维护性），已核对。

## 7. 验证

- Batch A（纯文档 + 保护清单一条）：`scripts/check-template.sh` 全量自检过（当前基线 2114/0；既有内容断言 :929 等不受增节影响）；索引表完整性以 grep 对照（提案约定，不设断言）。
- Batch B（若非 R0+）：`template-sync.json` 路径 + check-template 路径断言（:565 烟测 / :929 区域）+ 交叉引用（A20 / global-rules §5 引用等）同步更新，全量自检过。
- Batch C：agent-system-template 仓 `check-derived-sync` + project-check 通过；registry 登记更新。
- 发版时 CHANGELOG-PLAIN 用大白话提示领域模板维护者关注新布局。

## 8. 待确认项

| ID | 待确认项 | AI 建议 | 建议依据 | 备选方案 | 取舍影响 / 阻塞关系 |
|---|---|---|---|---|---|
| C-001 ✅ | L2 领域目录命名 | 固定保留名 `domain/` | 跨 L2 统一才有可识别模式；`_governance/` 保留名先例；多领域语义（§3）以此为前提 | 按领域命名（`agent-system/` 等） | 各 L2 根不同，链路直观性下降；阻塞 §2 全部 |
| C-002 ✅ | `ai/domain-rules.md` 位置 | 保留在 `ai/`（一目录 + 一种子） | AI 入口路由约定 + v1.60.0 机制（files_domain 基线生成种子）+ check 保护已就位 | 严格并入 `domain/rules.md` + ai/index 指针 | 牵动规则分层原则与保护机制，收益边际；不阻塞其余项 |
| C-003 ✅ | L1 收敛档位 | **R0+：零迁移，索引表 + 头部标记**（对 2026-09-10 会话口头建议的修订） | L1 机制件仅 5 个文件且文件名均含 domain、已可 grep；物理迁移的同步清单 / 断言 / 引用改动收益小，且 R1 目录名 `domain/` 会在 L2 造成与根 `domain/` 双同名目录碰撞（template-docs/domain/ 下行件 vs 领域自有件），正是要消除的混淆 | R1-lite：剧本骨架移入 profiles/ 与 domain-templates.md 聚拢；R1：独立 `template-docs/domain-layer/` 目录 | R0+ 零风险零迁移；R1-lite 一次小迁移；R1 结构最「成家」但有碰撞面；不阻塞 A 批主体 |
| C-004 ✅ | 版本口径 | MINOR 单版发 A 批（B 若采纳并批） | 规则变更下行 + 可能的清单路径变更属结构级；v1.67.0 治理目录迁移为 minor 先例 | A/C 分版；或 B 单独 patch | 影响发版节奏与 CHANGELOG-PLAIN 提示粒度；不阻塞设计 |
| C-005 ✅ | 实施启动时点 | 提案确认后即执行 Batch A | Web 类 L2 建仓窗口临近，模式先行成本最低 | 暂缓观察 | 暂缓则 Web L2 建仓时无模式可依，需返工 |

## 9. 影响与风险

- 对存量两层派生项目：零影响（不迁移、不新增断言、主路径不动）。
- 对 agent-system-template：Batch C 迁移属其既有待办，非新增负担；迁移期一次性路径调整。
- 撞名风险：`domain/` 保留名与既有派生项目目录冲突——registry 可查当前无仓使用根级 `domain/`，风险低；登记准入后「清单外 = 审计对象」兜底。
- 机制风险：无新机制（复用 files_domain / 保护清单 / registry 既有字段），仅路径与文档。

## 处理记录

- 2026-09-10：设计会话（三层布局 + 多领域扩展语义）后起草本提案；C-003 为当日口头建议（L1 建 template-docs/domain/）经碰撞论证后的修订。待维护者确认 C-001~C-005 后进入 Batch A 实施。
- 2026-09-10：维护者裁决 C-001~C-005 全按 AI 建议（「同意」）；同日实施 Batch A + B(R0+)：global-rules §5 登记保留名 + 三层区行、domain-templates.md 新增 §5（布局 / 索引表 / 多领域语义）并顺延 §6-§8、domain-rules.md 种子例外口径 + 标记、剧本路径收敛（domain-templates.md §4.1 / domain-rules.md §4 / 剧本骨架 / lab 命令 + prompt / scenario-guides A20）、inheritance 提案 Batch 2 修订、check-derived-sync 双语保护清单补 `domain/*`、机制件标记 ×4；发版 v1.75.0（CHANGELOG / CHANGELOG-PLAIN 同步登记）。Batch C（agent-system-template 迁移）、Batch D（Web L2 建仓套用）另行。
