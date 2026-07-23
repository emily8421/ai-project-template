# Token Hotspot 记录：v1.56.0 PR #240 合并 + 归档 #241 + 分支清理

> 日期：2026-07-22
> 任务类型：PR/CI 闭环收尾（review + squash 合并 #240、归档 PR #241、分支清理、handoff 更新）；前置 claude/runtime 只读复核
> 触发条件：`ai/session-rules.md` §4.1（从快速续接进入 PR/CI 闭环长任务；读完整规则包 + git-guide 章节 + CONTRIBUTING 归档流程；多次远端 gh 查询 + 两次 PR 合并）

## 热点工作

- **续接与规则路由**：快速续接读 Git 事实 + `.ai/session-handoff.md`；升级为执行任务后按 `ai/index.md` 路由读 `rules-core.md`；PR/CI 收尾补读 `implementation-lifecycle-rules.md`、`project-rules.md`、`commands/README.md`、`git-guide.md`（§1.1 / §1.2 / §4）、`CONTRIBUTING.md`（归档流程）。
- **claude/runtime 复核（前置任务）**：`claude --version` / `where.exe claude` / `volta list all` / `scripts/check-runtime.ps1` / 三层 PATH 查询（Session/User/Machine）。
- **PR #240 review**：`gh pr view`（state/mergeable/review）、`gh pr checks`、`gh pr view --json files`（11 文件清单）；预检 `scripts/check-github-context.ps1`。
- **PR #240 合并**：`gh pr merge 240 --squash` → `d5f7bc1`；验证 `state=MERGED`。
- **归档 PR #241 闭环**：`git mv` 提案 → `_archive/proposals/`、commit `28b7d12`、push、`gh pr create` → #241、`gh pr checks`、`gh pr merge 241 --squash` → `1cb284a`。
- **分支清理**：删 `runtime-version-check-phase2` + `chore/archive-v1.56.0-runtime-health`（本地 + 远端）。
- **handoff 更新**：8 处 Edit（元数据 + 下次优先做 + 阻塞表 R1/B1/E1）。
- **memory 维护**：`claude-code-volta-update-loop.md` 治本状态 + PATH 认知修正、`MEMORY.md` 索引同步。

## 热点判断

- **主要成本**：规则门禁读取（PR/CI 闭环按路由读 4+ 规则包全文 + git-guide 章节 + CONTRIBUTING）；归档目录 `Glob _archive/proposals/*.md` 全列 90+ 文件名占用上下文；多次远端 `gh` 查询（含一次 `--jq` 失败重试）。
- **输出控制**：规则文件按任务路由定向读（未预读全 `ai/`）；`git-guide.md` 用 Grep 定位章节后只读两段；归档目录 Glob 后仅用于确认命名规范与 v1.55.0 先例，未逐文件读；`gh` 输出用 `ConvertFrom-Json` 精简字段。
- **远端风险点**：两次 PR 合并 + 两次分支删除 + 归档 push，均走代理 7897 + 单步确认（用户两次 `AskUserQuestion` 授权：合并方式、收尾范围）。
- **不确定性控制**：归档走 PR（`main` 禁直推）依据 `CONTRIBUTING` §3 line 60 + #237 先例交叉确认，非臆断；工作区未跟踪文件全程未纳入任何 PR。
- **总量级**：medium-high（规则门禁 + 双 PR 闭环 + 分支清理 + 复核前置 + memory 维护）。

## 质量影响

- **正向**：双 PR 分离（功能 #240 + 归档 #241），`main` 历史清晰；归档纯 rename 100% 无内容变更；分支及时清理。
- **风险控制**：合并前 `check-github-context.ps1` 预检（权限 ADMIN + scopes 含 repo/workflow）；squash 合并；未跟踪 issue/hotspot 文件未混入。
- **上下文压力点**：①PowerShell 5.1 下 `gh --jq` 反斜杠转义失败 → 重试 `ConvertFrom-Json`（多余往返）；②归档目录 Glob 返回 90+ 文件名（实际只需确认命名规范 + v1.55.0 先例）；③PR/CI 收尾按规则读 4 个规则包全文，单次成本偏高。

## 优化建议

- **gh + PowerShell 5.1**：避免 `--jq`（反斜杠转义易错），优先 `gh ... --json <fields> | ConvertFrom-Json`；可在 `git-guide.md` §1.1 / §8 命令速查补一条提示，减少失败重试。
- **归档目录确认**：`Glob _archive/proposals/*.md` 返回 90+ 项偏大；确认命名规范时可用 `--head_limit` 或按版本前缀过滤（如 `v1.5*`），或只读 `_archive/proposals/README.md`。
- **归档 SOP 轻量化（沿用 2026-07-20 建议）**：合并后归档形成固定 checklist（`git mv` → commit → 预检 → push → PR → merge → 删分支），规则读取可只回看 `git-guide` §1.1/§1.2 + `CONTRIBUTING` §3 归档行，不必每次读完整规则包。
- **双 PR 时序**：归档 PR 与功能 PR 分开是模板流程要求（§3 line 60 合并后归档）；可在功能 PR 的提案文件里预置归档目标说明，减少归档 PR 的 review 成本（本次归档 PR 纯 rename，CI 17s，成本可控）。
- **任务切换规则重读**：复核类前置任务（claude/runtime 只读）与主线（PR/CI 写入）在同会话连续推进时，规则路由从「只读」切到「写入」需补读规则包；可在 handoff 预标注下一任务类型，减少规则重读判断成本。

## 关联

- PR #240：`https://github.com/emily8421/ai-project-template/pull/240`（MERGED, `d5f7bc1`）
- PR #241：`https://github.com/emily8421/ai-project-template/pull/241`（MERGED, `1cb284a` 归档）
- `main` HEAD：`1cb284a`（VERSION `v1.56.0`）
- 归档文件：`_archive/proposals/TEMPLATE-UPGRADE-v1.56.0-runtime-health-detection.md`
- 前置复核：claude/runtime 环境 PASS（memory `claude-code-volta-update-loop.md` 已更新治本状态）
- 未跟踪输入（未纳入 PR）：`_proposals/_remote-issues/issue-232.md`、`issue-234.md`、`issue-235.md`、`ai-records/token-hotspots/2026-07-20-v155-archive-pr-and-mijia-plugin-assessment.md`
- 续接记录：`.ai/session-handoff.md`
