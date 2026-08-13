# scripts/ 脚本

本目录放 `ai-project-template` 的自动化脚本：新建项目、下行同步、自检、环境采集、一键安装、批量同步与回归检查。

## 1. 登记口径

当前共有 **15 个可执行脚本文件**，按用途和权威实现关系归并为 **12 类工具能力**。其中 3 类同时提供 Bash 权威实现和 PowerShell 包装 / fallback，所以文件数不能直接当作能力数。

本注册表描述工具当前行为，不授予执行权限，也不改变退出码、默认参数、同步范围或自动化门禁。执行前仍须遵守 `ai/rules-core.md`、`ai/session-rules.md`、`SOP.md` 和 `git-guide.md` 的确认要求。

## 2. 工具注册表

### 2.1 能力总览

| ID | 能力 | 文件 | 运行位置 | 逻辑 Owner | 主要消费者 / 入口 | 状态 |
|---|---|---|---|---|---|---|
| `TOOL-PROJECT-001` | 从模板创建项目 | `new-project.sh` | 模板仓或任意可访问模板的位置 | Governance / Setup | 使用者、维护者；`ai/commands/new-project.md`、`git-guide.md` | Active |
| `TOOL-SYNC-001` | 单个派生项目下行同步 | `sync-template.sh`、`sync-template.ps1` | 派生项目 | Governance | 使用者；`ai/commands/sync-methodology.md`、`git-guide.md` | Active |
| `TOOL-CHECK-001` | 模板仓完整性自检 | `check-template.sh`、`check-template.ps1` | 模板仓 | Governance / Verification | 维护者、CI；`MAINTAINERS.md`、`CONTRIBUTING.md` | Active |
| `TOOL-SYNC-002` | 派生项目同步边界检查 | `check-derived-sync.sh`、`check-derived-sync.ps1` | 派生项目 | Governance / Verification | 使用者、同步流程；`ai/commands/sync-methodology.md` | Active |
| `TOOL-ENV-001` | 采集本机环境事实 | `collect-env.ps1` | 派生项目 | Docs / Environment | 使用者；`ai/commands/collect-env.md`、`SOP.md` | Active |
| `TOOL-SETUP-001` | 检查基础工具前置条件 | `check-prereqs.ps1` | 任意本机目录 | Implementation / Setup | 使用者；`SOP.md` A1、`template-docs/environment-setup.md` | Active |
| `TOOL-ENV-002` | 深度诊断 Node 运行时 | `check-runtime.ps1` | 任意项目 | Implementation / Environment | 使用者；`template-docs/environment-setup.md` | Active |
| `TOOL-SETUP-002` | 安装基础开发工具 | `bootstrap-dev-env.ps1` | Windows 本机 | Implementation / Setup | 使用者；`SOP.md` A1、`template-docs/environment-setup.md` | Active |
| `TOOL-SYNC-003` | 批量同步父目录下的派生项目 | `sync-all-derived.sh` | 派生项目父目录 | Governance | 维护者；`MAINTAINERS.md` C8、`git-guide.md` | Active |
| `TOOL-RELEASE-001` | 同步链路端到端回归 | `e2e-sync-check.sh` | 模板仓 | Governance / Verification | 维护者、发布流程；`MAINTAINERS.md` C3 | Active |
| `TOOL-REMOTE-001` | GitHub 远端上下文预检 | `check-github-context.ps1` | Git 仓库 | Governance / Remote | 维护者、远端操作执行者；`git-guide.md`、Remote / CI Profile | Active |
| `TOOL-CHECK-002` | Markdown 清洁度检查 | `check-markdown-clean.ps1` | 模板仓或指定路径 | Governance / Verification | 维护者、CI、`check-template.ps1`；`MAINTAINERS.md` C2 | Active |

### 2.2 运行契约

| ID | 关键输入 / 默认模式 | 输出与副作用 | 风险和确认边界 | 权威实现与失败语义 |
|---|---|---|---|---|
| `TOOL-PROJECT-001` | 项目名；可选 `--account`、`--visibility`、`--no-examples`、`--local`、`--no-remote` | 创建目录、复制 / 克隆模板、裁剪、初始化 Git 并提交；未加 `--no-remote` 时还可建远端并 push | 高风险写入；创建目标、切换账号、建远端和 push 均须核对目标并确认 | 单一 Bash 实现；任一步失败即非零退出 |
| `TOOL-SYNC-001` | 默认 `--dry-run`；可选 `--commit`、`--summary`、模板远端 / 分支 | dry-run 报告差异；commit 模式覆盖同步文件、暂存并提交；可能访问网络 | `--commit` 为高风险，必须单步确认；不得在脏工作区或错误仓库执行 | `.sh` 为权威实现；`.ps1` 优先委托 Bash，失败后走 native fallback；非零表示失败 |
| `TOOL-CHECK-001` | 模板仓；可选 `--summary`、`--quiet` | 检查结构、同步契约和临时派生场景；只在临时目录写入 / 清理，不改真实工作区 | 低风险只读检查；发布仍以 Bash + CI 为准 | `.sh` 为完整权威检查，退出 `0/1/2` 分别表示通过、内容失败、环境或参数失败；`.ps1` fallback 仅结构性兜底 |
| `TOOL-SYNC-002` | 派生项目；可选待检查 commit，默认 `HEAD` | 检查同步文件、版本与提交边界，不写工作区 | 低风险只读；只适用于派生项目 | `.sh` 为权威实现；`.ps1` 优先 Bash 后 fallback；`0` 通过，`1` 失败 |
| `TOOL-ENV-001` | 可选 `-OutputPath`，默认 `docs/env/local-env.md` | 创建父目录并写环境 Markdown；不安装软件、不改系统配置 | 写项目文件前需确认路径；输出可能含本机环境信息，提交前应人工复核 | 单一 PowerShell 实现；命令错误按脚本输出诊断 |
| `TOOL-SETUP-001` | 无必填参数 | 输出 Required / Recommended 工具状态，不写文件 | 低风险只读；结果用于诊断，不等同于项目可运行 | 单一 PowerShell 实现；当前无强制非零退出契约 |
| `TOOL-ENV-002` | 当前项目与 PATH / Node manager 状态 | 输出 Node 路径、版本和声明漂移诊断，不写文件 | 低风险只读；属于深诊断，不替代基础前置检查 | 单一 PowerShell 实现；设计为诊断工具，当前始终以 `0` 退出 |
| `TOOL-SETUP-002` | 可选 `-WithDocker`、`-WithJava` | 通过 `winget` 安装 Git、gh、Node、Python、VS Code 及可选工具，改变本机软件状态 | 高风险系统写入；必须明确确认，且不负责登录、代理、Docker 初始化或项目依赖 | 单一 PowerShell 实现；缺少 `winget` 会失败，单项安装失败会告警并继续 |
| `TOOL-SYNC-003` | 父目录；默认 `--dry-run`，可选 `--commit` | 扫描派生仓；dry-run 汇总，commit 模式调用各项目同步并提交；访问模板远端 | `--commit` 会跨多个仓库写入和提交，必须单步确认并先检查脏状态 | 单一 Bash 实现；子任务或环境失败即非零退出 |
| `TOOL-RELEASE-001` | 模板仓 | 在临时目录构造派生场景，组合模板自检与批量同步 dry-run；不改真实派生项目 | 低风险本地回归，但依赖 Bash、Git 和临时目录能力 | 单一 Bash 实现；`0` 通过，非零失败 |
| `TOOL-REMOTE-001` | 可选 `-ExpectedOwner`、`-ExpectedRepo` | 读取 Git remote / identity、`gh` 登录与仓库权限；可能访问网络，不改远端 | 只读但涉及账号和网络；输出警告时必须先收口上下文，不能继续高风险远端动作 | 单一 PowerShell 实现；`0` 无警告，`2` 存在警告 |
| `TOOL-CHECK-002` | 路径参数，默认 `_proposals` | 递归检查 Markdown 的 BOM、尾空格、文件末尾换行和多余空行，不写文件 | 低风险只读；路径不存在时跳过 | 单一 PowerShell 实现；`0` 通过或无目标文件，`1` 检查失败 |

> 注意：`check-template.*` 是**模板仓**自检，`check-derived-sync.*` 才是**派生项目**同步验收。

## 3. 权威实现与配对关系

### 3.1 Windows 脚本入口选择

`.sh` 文件是**主实现 / 权威逻辑**，适用于 CI、Git Bash 和类 Unix 环境。

`.ps1` 文件是 **Windows 友好包装入口**，遵循以下原则：

- **优先委托 Git Bash**：先尝试启动 Git Bash 并运行对应的 `.sh` 脚本
- **PowerShell fallback**：Git Bash 无法启动时，走原生 PowerShell 结构性检查（非完整等价）
- **幂等性保证**：Bash 和 fallback 路径产生相同的检查结果类别（通过/失败）

### 3.2 权威性说明

- **完整权威检查**：Bash `check-template.sh` + CI（模板仓）
- **结构性兜底检查**：PowerShell native fallback（Git Bash 无法启动时最低保障）
- **等价性**：fallback 通过 ≠ 完整自检通过；发布前仍应以 CI 或 Bash 自检为准

### 3.3 故障排查

| 入口 | 运行位置 | Git Bash 依赖 | 失败时优先排查 |
|---|---|---|---|
| `scripts/check-template.ps1` | 模板仓 | 可 fallback 到 PowerShell 结构检查 | 若 Bash 启动失败，先看输出中的 fallback 结果 |
| `scripts/sync-template.ps1` | 派生项目 | 优先 Git Bash；失败时可 PowerShell fallback | 输出中的 fallback 标识；若 fallback 也失败再修 Git for Windows / MSYS |
| `scripts/check-derived-sync.ps1` | 派生项目 | 优先 Git Bash；失败时可 PowerShell fallback | 输出中的 fallback 标识；若 fallback 也失败再修 Git for Windows / MSYS |

## 4. 新增与维护规则

- 新增脚本前，先在本表登记用途、Owner、消费者、输入输出、写入边界、权威实现和失败语义，再判断是否真的需要新工具。
- 能通过现有脚本参数或组合调用完成的能力，优先扩展现有工具；不得仅因调用入口不同就复制实现。
- Bash / PowerShell 双入口必须明确谁是权威实现、fallback 是否完整等价；当前 3 组配对均以 Bash 为权威。
- 改变默认写入行为、退出码、同步范围、依赖或 CI 门禁时，必须按模板治理流程提案、升版并更新本表。
- 标为废弃的工具应先记录替代入口和迁移期，再删除实现；删除同步范围内文件还必须更新 `template-sync.json` 和自检断言。

## 5. 重复与缺口审计（2026-08-13）

- 3 组 `.sh` / `.ps1` 是跨平台包装关系，不计为重复建设；PowerShell fallback 不保证与 Bash 完整等价。
- `check-template.*` 聚合模板结构和同步契约检查，`check-markdown-clean.ps1` 只检查 Markdown 文件卫生；前者调用后者属于组合，不是重复。
- `check-prereqs.ps1` 做基础工具面检查，`check-runtime.ps1` 做 Node 深诊断；两者目的不同。
- `sync-all-derived.sh` 是维护者本地批量入口，`sync-template.*` 是单仓执行器；前者调用后者，职责不重复。
- 本次补登记了原说明遗漏的 `check-github-context.ps1` 与 `check-markdown-clean.ps1`。
- 当前未发现完全无用途的可执行脚本；但脚本是否仍被真实项目采用，需要后续结合派生项目遥测或人工抽查确认。
- 当前缺口：本文件不在 `template-sync.json`，派生项目会获得脚本但不会自动获得本注册表。本批不改变同步行为，后续应单独评估是否把本文件纳入下行同步。

完整命令矩阵见 `SOP.md` 常用命令；操作 SOP（新建 / 提交 / 同步）见 `git-guide.md`。
