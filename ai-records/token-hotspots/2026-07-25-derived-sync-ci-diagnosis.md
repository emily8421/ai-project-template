# Token Hotspot：派生下行同步 + CI 诊断长会话

- 日期：2026-07-25
- 任务类型：派生同步远端闭环（3 派生 push/PR/merge + 模板 #266）+ CI QUEUED 诊断
- 分支：`docs/token-hotspots-2026-07-25`（#266）+ 3 派生 `chore/sync-template-v1.57.1`
- 版本：v1.57.1 下行同步
- 汇总状态：未汇总（待下次 SUMMARY rollup 纳入）

## 1. 热点（上下文成本高的环节）

### 1.1 规则包读取
- 从快速续接升级到派生同步（PR/CI 收尾层），按 `ai/index.md` 路由读 `remote-ci-sop-profile` + `implementation-lifecycle-rules` + `commands/README` + `project-rules §6` + `session-rules §3.3 / §4.1`（5 文件）。
- P0+P1/P2 会话已读的 core/global/document-lifecycle 等可复用（§3.2），但 PR/CI 收尾层与 `derived-sync-report-template` 是新增读取。

### 1.2 跨 3 派生仓远端操作往返
- 预检：3 仓 `git status / log / remote` + `gh pr list --state all` 查重（发现 LUMEN-DEMO 已 #84，避免重复建 PR）。
- 逐仓 push + `gh pr create` + `gh pr view` 查状态，每仓多轮 gh 调用。
- merge 阶段：`gh pr merge` + 本地 `checkout main / pull --ff-only / branch -D`，3 仓 × 多步。

### 1.3 CI QUEUED 诊断往返（本轮最高成本）
- #84/#266 卡 QUEUED，多次 `gh run view / list` + `statusCheckRollup` 查询。
- cancel + rerun 探针（background 轮询 100s）。
- 诊断方向反复：private 分钟耗尽？账户级故障？平台故障？→ 最终定性为 **runner 分配延迟**（rerun 后 ~2–3 min 分配、SUCCESS）。
- 查 workflow `runs-on` + 仓库 `visibility` + `actions/runners` 辅助定性。

### 1.4 handoff 失真核对
- handoff 称三仓未 push，与 Git 事实（LUMEN 已 push + #84）冲突；额外 `gh pr list` / `git ls-remote` 核实。

## 2. 质量影响

- 跨仓远端操作的单步确认 + 失败即停机制有效（#8/#37 CLEAN 先合，#84/#266 等 CI）。
- CI 诊断占本轮最大成本，且一度误判方向（账户故障）——rerun 探针纠正，避免盲目标签。
- handoff 失真在预检阶段及时发现，避免重复建 PR。

## 3. 优化建议

- **应沉淀**：CI QUEUED 诊断 SOP——先 rerun 探针（~2–3 min）再下“账户故障”结论，避免长诊断往返。可入 `remote-ci-sop-profile` 或 `scenario-guides`。
- **应沉淀**：派生下行同步闭环 checklist（预检查重 → push → PR → CI → merge → 本地清理），跨仓操作的标准节奏，减少下次规划成本。
- **可压缩**：跨仓 git 预检用一条 bash 串多仓 `git -C` 减少 Round-trip（本次已部分这样做）。
- **环境陷阱（新）**：Git Bash MSYS 路径转换破坏 jq `//` 操作符（`//` → `C:/Program Files/Git/`）——用 `--json` 原始输出或单字段规避；可入 `env-setup` / `git-guide`。
- **保留**：规则门禁、远端单步确认、失败即停、handoff 与 Git 交叉核对。

## 4. 模板回流判断

- `TEMPLATE-UPGRADE-remote-ci-queued-diagnosis.md`（CI QUEUED 诊断 SOP）：去项目化、通用于所有维护者，候选。
- jq on Git Bash 注意事项（MSYS 路径转换）：候选入 `env-setup` / `git-guide`（小改动，不一定单独提案）。
- 派生下行同步闭环 checklist：候选 `scenario-guides` C 场景或 maintainer SOP。

## 5. 关联

- 续接：`.ai/session-handoff.md`（4 PR 全闭环 + A13 轻量剩余）
- 同步汇总：`sync-records/template-sync/2026-07-25-sync-template-v1.57.1.md`（本会话）
- 前序 hotspot：`2026-07-25-p0-p1p2-template-batches.md`（同日 P0+P1/P2 实施，已纳入 SUMMARY）
