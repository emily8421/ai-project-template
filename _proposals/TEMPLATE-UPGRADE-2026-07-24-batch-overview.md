# TEMPLATE-UPGRADE 2026-07-24 批次总览：模板工程化闭环七提案评估

> 来源：模板维护者（用户提出 7 条优化思路，并由另一 AI 独立分析；本文件为双 AI 综合评估）
> 状态：候选（评估已完成，配套提案逐一起草中）
> 目标版本：待确认（各配套提案分别判断 patch / minor）
> Release impact：none（本文件仅为评估总览与提案索引，不改 `VERSION` 或模板行为）
> Release strategy：本文件为批次总览，不单独发布；落地随各配套提案 PR
> 评估基线：母模板 `v1.56.13`（`main` @ `4814731`，分支 `chore/template-upgrade-proposals-2026-07`）

---

## 1. 背景

用户围绕「让模板从规则提醒走向工程化闭环」提出 7 条优化思路，另一 AI 给出独立分析记录。本文件综合两份评估，逐项核对母模板 `v1.56.13` 现状，剔除已实现项与无效项，输出可执行的提案落地计划。配套提案见 §6。

**重要前提**：部分原始论断（提案 4、5）基于派生项目旧版本（zhiyan / agent-system-template 在 v1.54.x，digital-cs-demo 在 v1.54.2）。母模板 `v1.56.13` 已实现其中相当部分，需先以现状为锚修正认知，再判断真实缺口。

## 2. 现状基线与共同结论

模板已覆盖的基础（避免重复造轮子）：

- **演示**：`ai/commands/show-demo.md` + `template-docs/demo-runbook-template.md`（8 节结构）。
- **图表规范**：`ai/document-lifecycle-rules.md §13`（应含图表 + 默认 mermaid）。
- **Node 版本管理**：`ai/project-rules.md §2.9` + `scripts/check-prereqs.ps1` + `scripts/check-runtime.ps1`，manager-neutral（不绑死 volta/nvm），且 §2.9 示例已写「米家插件运行时要求 Node 16.x」。
- **Web 文件膨胀**：`template-docs/web-fullstack-profile.md §5`（数值表）+ **§5.1（主应用文件职责边界与业务下沉）**。
- **Web scaffold**：仍为实验协议（`template-docs/web-app-scaffold-experiment.md`），母模板不生成真实 scaffold。

**真正缺口**（双 AI 共识）：上述机制整体偏「规则提醒」，未形成「系统框架先落地 → 图纸可审核 → 用户可使用 → 研发数据可沉淀」的工程化闭环。具体缺口见 §3。

## 3. 逐项评估

### 提案 1 — 阶段演示：场景指令 / 演示手册 / 场景质量 / 用户手册 ⚠️ 部分成立

| 子断言 | 判断 | 依据 |
|---|---|---|
| 缺场景指令（阶段演示） | 部分成立 | `show-demo.md:17-19` 是单一场景，不与 `03-prd §3` Phase 路线图耦合，无「阶段级演示」概念 |
| 缺演示操作手册 | 部分成立 | `demo-runbook-template.md` 模板已有 8 节；但**缺回滚/清理环节**，且仓库与 `_examples/` 均未实例化 |
| 缺场景质量 | **基本不成立（剔除）** | `scenario-guides.md:53-83` 已是三层表格 + 强制「先说为什么再执行」+ 完成判据，质量已高，不值得投入 |
| 缺用户手册 | 成立 | 全仓无 how-to 操作手册；`beginner-guide.md:6-8` 自定位为心智模型手册；操作知识散落 scenario-guides/commands/prompts/SOP 四处 |

**建议**：扩展 `demo-runbook-template`（补回滚 + 阶段演示脚本）+ 用户手册走 `docs/README.md` 分区扩展（不塞 `docs/` 根）；剔除「场景质量」无效项。→ 配套提案 `TEMPLATE-UPGRADE-demo-and-user-manual.md`。

### 提案 2 — README 缺架构图 / 流程图 / 交互图 ✅ 成立

`README.md` 全文纯文字。**建议**：README 加 2-3 个轻量 mermaid（模板架构 / 设计流程 / 使用维护流程），细节留 `beginner-guide` / `scenario-guides`，避免 README 变重。注意根 README 不进同步清单（`global-rules.md:102`），图应落在 `template-docs/` 作可同步能力。→ 配套提案 `TEMPLATE-UPGRADE-readme-visual-navigation.md`。版本 **patch**。

### 提案 3 — 文档审核符合工程规范，尤其图纸 ⚠️ 部分成立

- 体系层面基本合规：`00-09 + design + inputs + vision` 对应 SE 六阶段，`document-lifecycle-rules §2/§5/§6` 追溯链完整；`ai/doc-standards/` 本就是审计基线。
- **图纸审核真实硬缺口**：
  - `§13`（`document-lifecycle-rules.md:530-546`）要求 07 含时序图，但 `ai/doc-standards/07-api-spec.md` 通篇只有契约矩阵，**无时序图字段/检查项**（最大缺口）。
  - `06-db-design.md:23` 把 ER 图写成「必要时补」，弱化 §13「应含」语气。
  - 无独立「图纸/可视化审核 checklist」；scaffold 用 ASCII 占位无 mermaid 强制块。

**建议**：把图纸审核从「有图」升级为「图可审、图可追溯、图能验收」——审核维度（可渲染 / 有 ID / 可追溯 REQ·API·TC / 覆盖异常·降级·权限路径）挂到现有追溯链（`U-ID→REQ-ID→…→TC`）；补 07 时序图审计基线、06 ER 图对齐。→ 配套提案 `TEMPLATE-UPGRADE-engineering-diagram-review.md`。版本 **patch**。

### 提案 4 — node 版本管理器（volta/nvm 多版本） ❌ 基本已解决

母模板 `v1.55.0→v1.56.0` 已建 **manager-neutral** 机制：声明层 `project-rules.md §2.9`（`:92-102`，含锁定版本/声明文件/切换工具/CI 校验/锁定原因）+ 检测层 `check-prereqs.ps1:42-61` + 诊断层 `check-runtime.ps1:59-85`（深度诊断 Volta/nvm/fnm，退出码恒 0，门禁 opt-in）+ 自检门禁 `check-template.sh`。母模板明文中立（`env-setup.md:307-311`）—— 正是「应对 volta/nvm 变化的机制」。**残留小缺口**：bootstrap 不装 manager（半刻意）、Linux/macOS 无对称脚本、check-runtime 仅覆盖 Node。

**建议**：**不新开主提案**。母模板仅补初始化提醒；米家插件 v16.13.0 锁定走派生项目 §2.9 声明或**领域模板**（呼应 agent-system-template 先例）。需时单列 patch。

### 提案 5 — 主文件膨胀只给数值表、无框架规范 ❌ 与现状不符

`web-fullstack-profile.md §5.1`（`:75-90`）**已存在「主应用文件职责边界与业务下沉」**：主文件只承担组合 hook/service、跨域 orchestration、cross-cutting wrapper、render 启动装配；业务状态机/副作用/领域计算下沉域 hook；状态/handler 软上限 ~10-15；跨域边界。原始论断「只给数值表」来自派生项目旧版本（v1.54.x 尚无 §5.1）。

**可深化点**：§5.1 仅在 web-fullstack Profile 内，CLI/纯后端/库项目无对等主入口约束。建议**横向泛化**一条与形态无关的「主入口文件职责边界」原则（成本低、填空白）；Web 内部深化等 `web-app-scaffold` 正式化时一并做。版本 **patch**。

### 提案 6 — 缺「系统框架实现与验收」环节 ✅ 核心成立（优先级最高）

触及模板核心设计，7 条里最有价值。现状：

- **Walking Skeleton 已存在但是条件性旁路 Profile**：`web-fullstack-profile.md:25-37`（WSG-001~006）只在触发复杂 Web/全栈时要求（`global-rules.md:104`），§6 用词「建议/可」加 Sprint 0（`:92-99`），**非通用强制阶段**。非 Web 项目（CLI/后端/库/quick-script）默认从 Demo 最简路径直接堆功能。
- **「骨架」命名碰撞（真实隐患）**：状态机 `骨架 → P{N}-已设计 → P{N}-已实现`（`global-rules.md:156`）的「骨架」指**设计文档占位**（见 `document-lifecycle-rules.md:287`），**不是可运行骨架**。引入「System Skeleton」前必须先消除碰撞。
- **验收是扁平矩阵，非层次大纲**：`09-verification.md:32-43` 测试等级矩阵 + §4.1 Phase 测试大纲，无「需求级 / 系统框架级 / 集成级 / 单元级」层次。
- **标准层与实例层不同步**：`ai/doc-standards/09-verification.md:22-27` 审计基线已列「Walking Skeleton smoke」，但 `docs/09` 实例层与 `docs-scaffold/09` 未同步。

**建议**：新增通用「可运行系统框架（System Skeleton）实现 + 系统框架验收」层；消除「骨架」命名碰撞；验收升层次大纲；同步 rules→doc-standards→docs-scaffold→docs 四层；**设计成规则/门禁层，不依赖正式 scaffold**（因 Web scaffold 仍为实验协议）。→ 配套提案 `TEMPLATE-UPGRADE-system-skeleton-gate.md`。版本 **minor**（新增能力层级 + 下游采用面 + 触及核心流程）。

### 提案 7 — 开知识沉淀路径，维护研发数据链 ✅ 成立

有两条性质不同的链：① 文档事实链（强统一，`document-lifecycle-rules §2/§5/§6`）；② 辅助留痕（`decisions/`/`research/`/`meetings/`/`CHANGELOG`/`handoff`/`ai-records/`）各自为政，**无统一总览**；token-hotspots 自成体系但与领域知识链无交叉（孤岛 meta 链）；辅助留痕载体无自检硬门禁（不像 D/F 有 `check-template.sh` require_contains）。

**建议**：轻量「研发数据链 Profile」——索引/分类决策/实验/验证/问题/提案如何沉淀，不污染 00-09。→ 配套提案 `TEMPLATE-UPGRADE-rd-data-chain-profile.md`。版本 **patch/minor**。

## 4. 双 AI 分析对比

### 4.1 共识
- 提案 6 最关键、优先级最高、应单独立项。
- 提案 4/5 现状已部分覆盖，不新开重活。
- 不塞进一个大 PR，按主题拆配套提案。

### 4.2 另一 AI 的增量价值（本方案采纳）
1. **用户/演示手册归属治理**：不塞 `docs/` 根目录，先扩展 `docs/README.md` 分区规则定义归属（呼应 `docs/README.md §4` 根目录只放核心文档）。
2. **Web scaffold 仍是实验协议**：system-skeleton-gate 必须设计成规则/门禁层，不依赖正式 scaffold。
3. **图纸审核维度框架**：图是否可渲染/有 ID/可追溯 REQ·API·TC/覆盖异常·降级·权限路径——挂到现有追溯链。
4. **提案 1 复用而非新建**：扩展 `demo-runbook`，不新造重复命令（呼应 `CONTRIBUTING §7` 命令不膨胀）。
5. **Node 版本走领域模板**：米家插件锁定建议做领域模板或派生项目 §2.9 声明。

### 4.3 另一 AI 的盲点（本评估补足，须吸收进配套提案）
1. **提案 6 的「骨架」命名碰撞**：`global-rules.md:156` 的「骨架」=设计占位≠可运行骨架。B 引入「System Skeleton」若不先消碰撞会雪上加霜。
2. **提案 1 的「场景质量」子断言基本不成立**：`scenario-guides.md` 质量已高，剔除以免无效投入。
3. **提案 6 标准层与实例层不同步**：改 rules 还要同步 doc-standards→docs-scaffold→docs 四层。
4. **提案 5 认知落差来源**：原始论断来自派生项目旧版本，先同步再评估。

### 4.4 分歧裁决
- **提案 5 深化方向**：本评估建议横向泛化（CLI/后端/库主入口约束，填空白），另一 AI 建议纵向深化（Web 文件放置规范）。**裁决**：先横向泛化共性原则（低成本），Web 内部深化等 scaffold 正式化。
- **Node 是否做领域模板**：双方同意不新开母模板主提案；是否额外做「米家插件领域模板」取决于需求是否反复，待用户判断。

## 5. 合并落地序列（P0–P2）

| 优先级 | 配套提案 | 关键内容 | 版本 |
|---|---|---|---|
| **P0** | `system-skeleton-gate` | 通用可运行系统框架实现+验收层；消除「骨架」命名碰撞；验收层次化；四层同步；不依赖正式 scaffold | minor |
| **P1** | `engineering-diagram-review` | 图纸审核维度挂追溯链；补 07 时序图/06 ER 对齐 §13 | patch |
| **P1** | `demo-and-user-manual` | 扩展 demo-runbook（回滚+阶段脚本）；用户手册走 docs/README 分区；剔除场景质量 | patch/minor |
| P2 | `readme-visual-navigation` | README 加 2-3 轻量 mermaid；细节留 beginner-guide | patch |
| P2 | `rd-data-chain-profile` | 轻量研发数据链索引/分类，不污染 00-09 | patch/minor |
| — | （不单独立案）Node 版本 | 母模板补初始化提醒；米家插件走领域模板或 §2.9 声明 | patch |

落地纪律（`CONTRIBUTING.md §3/§4`）：P0 因 minor + 触及核心流程，独立 PR、充分设计；P1/P2 多为 patch 可按主题聚合。提案文件本身 Release impact=none，不改 `VERSION`；只有后续 PR 合并并改变模板行为/下游同步判断时才判断版本递增。

## 6. 配套提案清单

| 文件 | 状态 |
|---|---|
| `_proposals/TEMPLATE-UPGRADE-system-skeleton-gate.md` | 起草中（P0） |
| `_proposals/TEMPLATE-UPGRADE-engineering-diagram-review.md` | 起草中（P1） |
| `_proposals/TEMPLATE-UPGRADE-demo-and-user-manual.md` | 起草中（P1） |
| `_proposals/TEMPLATE-UPGRADE-readme-visual-navigation.md` | 起草中（P2） |
| `_proposals/TEMPLATE-UPGRADE-rd-data-chain-profile.md` | 起草中（P2） |

## 7. 验证方式

- 本批次提案文件均为新增、不改模板行为；落盘后运行 `scripts/check-template.sh` 确认自检不破。
- 各配套提案落地实施时（改 rules/doc-standards/docs-scaffold）再各自跑自检 + 文档自洽 + PR 评审。
- 提案互相引用一致（均回指本总览）。
