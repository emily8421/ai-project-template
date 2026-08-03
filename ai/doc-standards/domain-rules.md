# domain-rules 文档规范（审计基线）

> Sync notice: This file is maintained by `ai-project-template` and may be overwritten when a derived project syncs template methodology.
> Do not edit it directly in derived projects; propose reusable changes in `_proposals/` and upstream them to the template repository.

本文件是领域模板仓 `ai/domain-rules.md` 种子实例的**字段规范与审计基线（单一事实源）**，随模板下行同步到**领域模板路线**（`template-sync.json` 的 `files_domain` 组；普通派生项目不接收）。它只定义"领域层 rules 填什么、字段规范、审计项、禁止项"，**不替代**领域模板仓的实例事实——领域专属内容仍写在各自 `ai/domain-rules.md`（不同步、领域仓按本规范自生成）。

## 1. 定位与三层分工

`ai/` 规则在领域模板路线下分三层（规则分层原则见 `ai/global-rules.md` §5）：

| 层 | 载体 | 是否同步 | 适用路线 | 职责 |
|---|---|---|---|---|
| 通用层 | `ai/global-rules.md` / `ai/rules-core.md` | 是（`files_all`） | 全部 | 跨项目通用 AI 行为与目录原则 |
| 领域专属·规范基线 | `ai/doc-standards/domain-rules.md`（本文件） | 是（`files_domain`） | 仅领域模板 | 领域层 rules 字段定义、填写规范、审计项 |
| 领域专属·种子实例 | `ai/domain-rules.md` | 否 | 仅领域模板（领域仓自生成） | 领域通用但跨项目的领域标准件骨架 |
| 项目专属·规范基线 | `ai/doc-standards/project-rules.md` | 是（`files_all`） | 全部 | project-rules 字段规范 |
| 项目专属·种子实例 | `ai/project-rules.md` | 否 | 全部 | 派生项目填写的项目专属事实骨架 |

判断标准：一条规则换到**同一领域的不同项目**是否还成立——成立（该领域所有项目共有的标准件，如 agent 系统的工具权限矩阵、memory / state 模型、trace / replay、agent eval、human-in-the-loop）属领域层（本文件规范 + `ai/domain-rules.md` 实例）；换到**不同领域或非领域项目**不成立。换到任何项目都成立的属通用层；只对单个项目成立的属项目层（`ai/project-rules.md`）。

> 领域层是**可选中间层**：只有领域模板仓（如 `agent-system-template`）才有 `ai/domain-rules.md`；普通派生项目不经过领域层，不接收本文件，也不生成 `ai/domain-rules.md`。领域模板机制与适用判定见 `template-docs/domain-templates.md`。

## 2. 章节契约（种子实例必须保留的骨架）

领域模板仓的种子 `ai/domain-rules.md` 必须保留以下章节标题（章节号是跨文档引用的稳定锚点，不得随意改号）：

- §0 领域定位
- §1 领域标准件清单
- §2 领域裁剪与禁止
- §3 领域验收口径
- §4 与 project-rules 的关系

领域模板可按领域形态裁剪填写内容，但不得删除上述章节标题；不适用项写"无"或"不适用"，不留空占位。

## 3. 初始化必填检查（创建 / 生成领域模板时）

在用 `domain-template-lab`（`ai/commands/domain-template-lab.md` + `ai/prompts/maintainers/23-domain-template-lab.md`）创建领域模板、按本规范生成 `ai/domain-rules.md` 种子前，必须确认：

- §0 领域定位已明确：该领域模板面向哪一类系统（如 agent 系统 / OCR / IoT），及与母模板通用方法论的关系。
- §1 领域标准件清单已列出该领域所有项目都需要的标准件（不是单个项目事实），每项标注承载位置与执行口径（advisory / gate）。
- §2 领域裁剪与禁止已写明领域级允许 / 禁止（高于单个项目 §1，但低于通用层）。
- §3 领域验收口径已写明领域专属验收（如 agent eval gate），或写明豁免理由。
- §4 已声明：领域派生项目继承本领域 rules 后，仍在各自 `ai/project-rules.md` 填项目专属事实。
- 若以上任一项无法判断，AI 必须先向用户提问或提出待确认项，不得直接生成空骨架。

## 4. 各节字段规范

### §0 领域定位

- `领域`：该领域模板面向的系统类别（如 agent 系统）。
- `适用判定`：什么样的项目应走本领域模板、什么项目直连母模板、什么项目不适用（指向 `template-docs/<domain>/domain-derived-scenarios.md` 或 `template-docs/domain-derived-scenarios-template.md`）。

### §1 领域标准件清单

本节是该领域所有项目共享的标准件单一清单（领域通用、跨项目）。每项字段：

- `标准件名`：如工具权限矩阵 / memory·state 模型 / trace·replay / agent eval / human-in-the-loop。
- `承载位置`：该标准件在领域模板仓的物理位置（领域 docs / 领域 scaffold / 领域脚本 / 领域自检）。
- `执行口径`：advisory（建议）/ gate（强制阻断）。
- `与母模板的关系`：母模板不承担该项的理由（避免增加非领域项目负担）。

> §1 是领域层权威位置：领域派生项目继承本清单；新增领域标准件经领域模板仓 PR 演进，不回写母模板（除非可跨领域通用，再经 `_proposals/` 回流）。

### §2 领域裁剪与禁止

领域级允许 / 禁止，介于通用层与项目 §1 之间。字段：领域允许、领域禁止（不得留空）、领域默认开启 / 默认关闭能力。

### §3 领域验收口径

领域专属验收（高于项目 `docs/09-verification.md` 的通用验收）。字段：领域必过验收（如 agent eval gate）、领域 advisory 验收、豁免理由。

### §4 与 project-rules 的关系

声明三层规则在领域派生项目中的叠加关系：通用层 → 领域层（本文件 + `ai/domain-rules.md`）→ 项目层（`ai/project-rules.md`）。领域派生项目继承领域 rules 后，项目专属事实仍填 `ai/project-rules.md`；领域 rules 不替代项目 rules。

## 5. 审计项（对照领域模板仓 `ai/domain-rules.md`）

审计 / 生成领域模板时对照本文件检查实例：

- 章节骨架完整（§0-§4 标题齐全，章节号未改）。
- §0 领域定位明确，适用判定可执行。
- §1 标准件清单每项含承载位置与执行口径；无空占位。
- §2 领域禁止项不留空。
- §3 领域验收口径齐备或已豁免说明。
- §4 三层叠加关系声明清晰，未把项目专属事实写进领域层。
- 领域派生项目同步后，`ai/domain-rules.md` 受 `scripts/check-derived-sync.sh` + `.ps1` 保护（不在 `template-sync.json`，方案①全不同步），领域仓自行治理。

## 6. 与其它规范的关系

- 规则分层原则（通用 / 项目专属 / 领域专属）的权威表述见 `ai/global-rules.md` §5。
- 项目层 rules 规范见 `ai/doc-standards/project-rules.md`（与本文件正交：项目层管项目专属，领域层管领域通用）。
- 领域模板机制（三层模型、适用判定、`TEMPLATE-BASE.md`、同步双重身份）见 `template-docs/domain-templates.md`。
- 领域模板创建 / 生成 `ai/domain-rules.md` 种子的操作入口见 `ai/commands/domain-template-lab.md` + `ai/prompts/maintainers/23-domain-template-lab.md`。
- 本文件只走领域模板路线（`files_domain`）；普通派生项目不接收，`scripts/check-derived-sync.sh` + `.ps1` 按路线区分，防止普通派生误收领域文件。
