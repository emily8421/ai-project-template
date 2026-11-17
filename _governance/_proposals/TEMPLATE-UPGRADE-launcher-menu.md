# TEMPLATE-UPGRADE-launcher-menu 控制台启动器菜单（对话即界面的并列点选入口）

> 来源：模板维护者（2026-11-17 会话提出：在「对话即界面」之外补充一种并列、不替代的点选式常用操作入口，降低维护者 / 用户的状态感知与入口发现成本）
> 状态：已拍板·实施中（2026-11-17 C1 triage 核实属实 → 维护者拍板「按建议执行」；W-001~W-004 按 AI 建议决议；triage 校正 2 / 补强 2 随批吸收；实施 PR 先入库、归档 PR 随后）
> 目标版本：v1.79.5 PATCH（拍板确认——兼容性默认规则：可选能力增强，默认行为 / 同步清单结构 / 下游必做流程不变）
> Release impact：patch（实施 PR）

## 1. 动机（去项目化）

模板治理机制持续累积（计数时点 v1.79.4 @ 2026-11-17 triage 实查）：15 类机制（`MECH-*`）+ 13 类工具（`TOOL-*`，本提案落地后 14 类）+ 28 个快捷命令 + 6 个维护者 prompts + 16 个脚本。维护者 / 用户的操作成本集中在两层：

1. **状态感知**（现在该做什么）：事实散在 registry 账本、handoff 行动卡、远端 issue、本地观察记录多处；
2. **入口发现**（想做什么该点什么单）：入口面大，新维护者 / 派生用户需要翻 CONTRIBUTING / prompts / SOP 才能找到发起方式。

「对话即界面」是主界面（AI 按路由表承担任务分诊与执行纪律），本提案**不替代它**，只补一个并列的点选式控制台菜单（启动器）。定位类比：遥控器，不是第二台电视——启动器不做模型交互、不做工具编排，执行层完全交给既有脚本与 harness 会话（Claude Code / Codex / Cursor 等），因此不与 harness 演进竞争。

## 1.1 与既有规则的关系（去重）

- **governance-decoupling 提案 Phase 3 载体层**（已入库，R1 审计收官）：载体变更「实证后动」纪律，拆分候选均配量化触发条件。**互补不重复**——本提案即按该纪律先出轻量实证形态（控制台菜单），并把更重形态（图形看板）挂触发条件。
- **pitfall SUMMARY §0 双写点家族**（F2「双写点无断言」等）：**机制不同、互补不重复**——本提案菜单清单采用单一来源渲染 + advisory 校验，正是防止新增双写点。软依赖注记：governance-decoupling Phase 4「双写点断言化」若先行落地，本清单 advisory 应并入该口径。
- **行动卡 Preconditions 授权纪律**（11-14「预告 ≠ 授权」教训，远端状态变更逐项显式求授权）：**指向**——菜单「点选 ≠ 授权」红线直接承接该口径。
- **v1.79.4 机制 / 工具登记固定步**（MAINTAINERS §3 条目 8 + CONTRIBUTING §3 步骤 5）：**指向**——新工具按固定步入 TOOL 表 + 刷新审计列，不留「已上线未登记」中间态。
- **rd-data-chain.md §4「无自检门禁、避免过度治理」**（模板仓文档，v1.66.0 起不下行）：**互补不重复**——菜单清单指向目标的存在性校验走 advisory，不设硬门禁。
- **跨 CLI 友好性链**（v1.77.1，#522/#523/#525）：**互补不重复**——菜单跨 CLI 中立（拉起 `claude` / `codex` 或输出点单词供任意 CLI 使用），不绑定单一 harness。
- **scripts/README TOOL 表**（TOOL×13，R1 审计通过；落地后 ×14）：**合并入**——新工具登记并入该表，不建平行注册表。
- **操作序列化先例**（镜像清尾 v1.78.1 / 归档索引固定步 v1.79.1 等「三犯立案」）：**机制不同**——本提案是入口聚合，不新增任何操作序列或机制本体。
- **template-check-maintainability 提案 P2.x**（收件箱挂账，check-template 可维护性）：**互补不重复**——本提案 advisory 为新增非阻断项，若 P2 重构 check-template 结构，advisory 项跟随新结构迁移即可，不构成冲突。

**本提案不重复它们**：现有体系回答了「机制有哪些、谁负责、怎么执行」，未回答「常用入口的点选式聚合」。差异化：只做入口索引 + 会话拉起，零新机制。

## 2. 拟改（方案设计，已按 triage 结论修订）

### 2.1 载体

`scripts/menu-launcher.ps1`（Windows 主）+ `scripts/menu-launcher.sh`（bash 镜像）+ 单一清单源 `scripts/launcher-menu.json`。命名走 ASCII（#540 手册链教训）；菜单显示名（中文）与清单 key（ASCII）分离（triage 补强 4）。`.ps1` 纯 ASCII 源码、中文文案全部在 UTF-8 清单（规避 Windows PowerShell 5.1 无 BOM 读非 ASCII 源码的编码坑）。

### 2.2 菜单两分区（Phase 1 共 11 项，scope 按同步边界与 §5.1 发起目录语义修正）

**脚本类（点选直接执行，无需 AI；同步边界判定 → scope）**：

| # | 菜单项 | 目标 | scope |
|---|---|---|---|
| 1 | registry 全仓对账 | `check-registry-drift.ps1` | maintainer（模板仓专用，不下行） |
| 2 | 模板全量自检 | `check-template.sh --summary` | maintainer（模板仓专用，不下行） |
| 3 | 新项目向导 | `new-project.sh` | maintainer（模板仓专用，不下行） |
| 4 | 采集本机环境事实 | `collect-env.ps1` | all |
| 5 | Markdown 清洁度检查 | `check-markdown-clean.ps1` | all |

**会话类（生成标准点单词 + preconditions 摘要 → 显示 / 复制剪贴板 / 拉起 claude / codex；按 §5.1 发起目录语义分仓）**：

| # | 菜单项 | 点单词来源 | scope |
|---|---|---|---|
| 6 | C1 提案 triage | prompt 11 | maintainer（模板仓发起） |
| 7 | 快速续接（只读） | `ai/commands/resume.md` | all |
| 8 | 观察 rollup（hotspot / pitfall） | inline（triage 校正 1：无现成 prompt 文件，点单词内联在清单 brief 字段） | all |
| 9 | 派生同步轮 | prompt 12 | derived（派生仓发起） |
| 10 | 同步后清理与回流归纳 | prompt 15 | derived（派生仓发起） |
| 11 | 提案回流提交 | prompt 17 | derived（派生仓发起） |

### 2.3 单一清单源（防双写）

清单 `launcher-menu.json` 为菜单唯一渲染源（check-template **advisory** 校验 target / source 指向存在，不设硬门禁）。解析约束（triage 定稿）：bash 侧无 JSON 解析器，按行解析——每条目单行 `{}`、字段顺序固定 `key,type,title,(target,runner,args|source,brief),scope`，约束写入清单 description；根对象大括号行被解析器与 advisory 自然跳过。manifest 引用既有入口（脚本 / prompt / 命令），不复制其内容；`source` 支持 `inline` 类型（校正 1）。

### 2.4 红线：点选 ≠ 授权

会话类项仅做「拼装点单词 + 拉起会话」；会话内的远端状态变更（同步、关 issue、合并等）仍走既有逐项显式授权流程，菜单不预授权、不静默执行。

### 2.5 仓型自适应 + 环境前置

按 `MAINTAINERS.md` 是否存在区分母仓 / 派生仓并过滤 scope（#522 判据）。运行前置缺失降级不报错（triage 校正 2）：bash / powershell 不在 PATH 时显示手动执行命令；模板仓专用目标在派生仓提示「不下行」而非报错。

### 2.6 登记与同步清单

TOOL 表登记 `TOOL-LAUNCH-001`（§2.1 下行组 + §2.3 运行契约，登记与改动同批——v1.79.4 固定步）；`template-sync.json` `files_all` +3（launcher 双实现 + 清单）；`scripts/README.md` §1 分组计数随动（下行组 8 类 / 10 文件 → 9 类 / 13 文件）。

## 3. 版本影响

落盘 none。实施 **v1.79.5 PATCH**（拍板确认）：可选能力增强——默认行为不变、对话即界面仍是主推荐工作流、不要求下游采用，符合兼容性默认规则；「用户入口新增场景」的 minor 要素不适用（该条指文档骨架 / 工作流层面的新入口场景）。

## 4. 影响面

- **模板维护者**：高频操作（对账 / 自检 / 状态）零门槛直达；会话类操作免记点单词。
- **派生项目**：随同步获得 launcher 与通用项（自检类 / 环境采集 / resume / rollup），维护者专属项按 scope 隐藏，同步类会话项在派生仓显示。
- **不改**：`ai/` 规则、命令路由结构、check-template 硬断言、CI 门禁、发版流程。

## 5. 验证方式

- 全量自检非沙箱直跑（advisory +1 计数预期）+ `git diff --check` + md-clean 触达面 + CI Template Check；PATCH 豁免 L3 e2e（无骨架 / 规则文件触达）。
- 双启动器 `--list` 冒烟：母仓视角 8 项 / 模拟派生仓视角 7 项（scope 过滤正确）+ JSON 可解析 + bash 语法检查。
- **dogfood 两周**：母仓 + 至少一个派生仓各实战 ≥1 次。成功判据：高频操作不再需要翻文档找入口；advisory 漂移告警为 0（清单单一来源生效）。

## 6. 远期触发条件（更重形态挂账，不随本提案实施）

菜单 dogfood 证明使用价值（高频）+ 控制台形态天花板实证 ≥2 次（如需要跨仓聚合视图 / 图形化状态）→ 另立 **companion 看板提案**：独立项目、消费 registry / handoff 数据、**不入模板同步清单**，模板仓只留一行指针。

## 7. 待确认项（2026-11-17 已全部拍板）

| ID | 待确认项 | 决议 |
|---|---|---|
| W-001 | 菜单是否随同步下行 | **下行 + 仓型自适应过滤**（拍板：按 AI 建议） |
| W-002 | 版本级别 patch vs minor | **patch**（拍板：按 AI 建议；v1.79.5） |
| W-003 | 清单源落点 | **独立 manifest `launcher-menu.json`**（拍板：按 AI 建议） |
| W-004 | 状态台是否搭车 | **不搭车**，另立提案（拍板：按 AI 建议；R1 先例） |
| T-1 | triage 校正 2（rollup inline 类型 / 环境前置降级） | **采纳**，随批吸收（§2.3 / §2.5） |
| T-2 | triage 补强 2（计数时点 / 显示名与 key 分离） | **采纳**，随批吸收（§1 / §2.1） |
| T-3 | 实施期发现：同步边界使 check-template / new-project / registry-drift 均为模板仓专用 | **随动修正**（§2.2 scope 列 + 会话类 §5.1 发起目录分仓），triage 报告已预告实现细节可裁量 |
