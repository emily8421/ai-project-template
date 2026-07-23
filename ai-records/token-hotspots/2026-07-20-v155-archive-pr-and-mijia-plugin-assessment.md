# Token Hotspot 记录：v1.55.0 提案归档 PR + 本地插件资料派生路径评估

> 日期：2026-07-20
> 任务类型：模板维护收尾（v1.55.0 提案归档、分支 / commit / push / PR #237）+ 本地资料库只读评估（插件项目普通项目 vs 领域模板路径）
> 触发条件：`ai/session-rules.md` §4.1（从快速续接进入写入 / 远端 PR 闭环；读取完整规则包、Git 流程规则、本地外部资料目录；跨规则 / Git / 本地材料综合判断）

## 热点工作

- **续接与规则路由**：先按快速续接读取 Git 事实、`.ai/session-handoff.md`，随后因进入归档写入与 PR 流程，补读 `ai/index.md`、`ai/rules-core.md`、完整规则回退包、`MAINTAINERS.md`、`CONTRIBUTING.md`、`template-sync.json`。
- **归档 PR 闭环**：将 `_proposals/TEMPLATE-UPGRADE-v1.55.0-runtime-version-locking.md` 移到 `_archive/proposals/`，本地提交 `7b2cfe2`，推送 `chore/archive-v1.55.0-proposal`，创建 PR #237。
- **GitHub 上下文预检**：远端操作前运行 `scripts/check-github-context.ps1`；预检因 3 个未跟踪 issue 镜像给出 warning，按用户确认继续，未纳入 PR。
- **本地插件资料评估**：只读扫描 `<local-plugin-research-dir>`，重点读取根 `README.md`、`进度看板.md`、V3.5 需求 README、自动化系统需求 README、环境安装文档、SDK `README.md` / `package.json`。
- **模板路径对照**：对照 `ai/prompts/setup/14-new-project.md` 的普通派生流程与 `ai/prompts/maintainers/23-domain-template-lab.md` 的领域模板实验线边界，输出“先普通项目，后领域模板实验线”的建议。

## 热点判断

- **主要成本**：规则与维护文件读取量偏大；本地资料库目录结构较深，且包含 SDK、学习记录、实战项目、自动化系统构想多类材料，需要分批回锚点判断相关性。
- **输出控制**：没有全文展开 SDK 大文档和长手册；对 `package.json` 只提取 scripts / runtime / React Native 版本等摘要；对资料库只读关键 README 和配置。
- **远端风险点**：push / PR 创建需要脱离 sandbox 访问 GitHub；按用户授权使用本机代理端口 7897，并遵守单步远端操作。
- **不确定性控制**：没有把本地资料库中的未确认需求写成项目事实；明确 V3.5 需求待确认、自动化系统依赖实战过程记录、领域模板只能作为候选实验线。
- **总量级**：medium-high（快速续接 + 完整规则回退 + PR 闭环 + 外部资料目录评估）。

## 质量影响

- **正向影响**：先归档并开 PR，避免 v1.55.0 提案长期停留在 `_proposals/`；同时把插件项目模板化判断与材料证据分离，降低过早领域模板化风险。
- **风险控制**：3 个 `_proposals/_remote-issues/issue-*.md` 保持未跟踪，未混入归档 PR；PR #237 只包含 100% rename。
- **证据粒度**：最终建议引用本地材料的具体文件和行号，例如 SDK 代码路径硬约束、Node 16.13.0、V3.5 需求未确认、领域模板实验线边界。
- **上下文压力**：完整规则包输出较长，后续类似“归档单文件 + PR”可考虑用更窄的 Git/模板维护章节读取，减少一次性上下文成本。

## 优化建议

- **归档 SOP 可轻量化**：对“已合并 PR 的提案归档”形成小型 checklist：确认源 / 目标路径 → `git mv` → 本地提交 → 预检 → push → PR；不必每次读取大量模板文档全文。
- **外部资料评估可分层**：先读根 README / 进度看板 / 关键约束，再决定是否读 SDK README / package；避免直接全仓 grep 或读取手册全文。
- **领域模板准入门槛**：至少完成一次普通项目实战闭环，沉淀可复现环境、SDK 项目创建 / 调试 / 发布路径、必备文档清单，再启动独立领域模板实验线。
- **插件项目初始化建议**：普通项目内优先把 `<local-plugin-research-dir>` 的关键材料转入 `docs/inputs/`，并在 `ai/project-rules.md` §2.9 锁定 Node.js `16.13.0` 与 Volta / `.node-version` 策略。
- **远端前状态门禁**：当预检只因明确排除的未跟踪资料文件 warning 失败时，可在 handoff 记录“保留未跟踪、不纳入 PR”的用户确认，降低后续重复解释成本。

## 关联

- PR #237：`https://github.com/emily8421/ai-project-template/pull/237`
- 本地提交：`7b2cfe2 chore(proposals): 归档 runtime version locking 提案（PR #236 / v1.55.0）`
- 归档文件：`_archive/proposals/TEMPLATE-UPGRADE-v1.55.0-runtime-version-locking.md`
- 未跟踪输入：`_proposals/_remote-issues/issue-232.md`、`_proposals/_remote-issues/issue-234.md`、`_proposals/_remote-issues/issue-235.md`
- 插件资料目录：`<local-plugin-research-dir>`
- 续接记录：`.ai/session-handoff.md`
