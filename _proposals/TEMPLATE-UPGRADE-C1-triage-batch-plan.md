# TEMPLATE-UPGRADE: C1 提案收件箱 triage 与分批计划

> 来源：模板维护者（C1 提案收件箱处理，2026-07-22）
> 状态：进行中（B0 / B1 待执行；B2–B4 候选；延后池另列）
> 目标版本：分批确认（见各 Batch）
> Release impact：none（本文件为 triage / 分批治理总纲，不直接改同步范围；各 Batch 落地时各自判断 patch / minor）
> Release strategy：分批（B0 清理 → B1 token hotspot rollup → B2 sync 体验 → B3 check-template 维护 → B4 web 主文件膨胀；延后池另列）

## 0. 本轮 triage 输入

### 0.1 本地提案（`_proposals/TEMPLATE-UPGRADE-*.md`，10 份）

- TEMPLATE-UPGRADE-token-hotspot-records.md
- TEMPLATE-UPGRADE-docs-scaffold-followups.md
- TEMPLATE-UPGRADE-domain-template-inheritance.md
- TEMPLATE-UPGRADE-capability-packages-and-profile-contracts.md
- TEMPLATE-UPGRADE-capability-packages-and-profile-contracts-batch1.5-patch.md
- TEMPLATE-UPGRADE-project-registry-and-web-app-runway.md
- TEMPLATE-UPGRADE-sync-proxy-guidance.md
- TEMPLATE-UPGRADE-post-sync-version-checklist.md
- TEMPLATE-UPGRADE-template-check-maintainability.md
- TEMPLATE-UPGRADE-windows-sync-output-noise.md

### 0.2 参与分析的 issue 镜像（`_proposals/_remote-issues/`）

| 镜像 | Updated（远端） | Mirrored at（本地） | 新鲜度 |
|---|---|---|---|
| issue-232.md | 2026-07-19T01:02:35Z | 2026-07-20 15:21 +08:00 | 鲜活（updated 未变） |
| issue-234.md | 2026-07-19T07:59:13Z | 2026-07-20 15:21 +08:00 | 鲜活 |
| issue-235.md | 2026-07-19T08:01:11Z | 2026-07-20 15:21 +08:00 | 鲜活 |
| issue-238.md | 2026-07-21T06:54:08Z | 2026-07-21 15:05 +08:00 | **过期**（远端已 CLOSED，镜像 State 仍 OPEN）|

远端 open proposal issue 仅 #232 / #234 / #235（**#238 已 CLOSED**，见 §1 / §5.1 / §5.4）；本地镜像 #232 / #234 / #235 鲜活，#238 镜像过期（State: OPEN，远端实际 CLOSED，B0 归档）。

## 1. 状态分类（关键发现：多份「已落地但未归档」）

| 提案 / issue | 实际状态 | triage 处置 |
|---|---|---|
| capability-...-batch1.5-patch | 已落地 commit `11d8b2c`（old→new 审计记录）| **B0 归档** |
| sync-proxy-guidance | 已落地 `v1.54.2` | **B0 归档** |
| capability-...-contracts（主）| 主体已发布 `v1.52.4`（Batch 1/1.5/2/2.5/3）；**Batch 4（Web App Profile）= 真待办**（CAP-007 活跃观察，§11 标准）；Batch 5 暂缓 | **留剩余标记，不归档**（§12 明示；待 CAP-007 结案）|
| project-registry-and-web-app-runway | Batch 0–6 + C-001 全落地（v1.47.3~v1.54.1）；剩余 Batch 7 无限期搁置、提案 B 第三类场景由 domain-template 承接 | **B0 整体归档**（注明 Batch 7 / 领域派生见 domain-template）|
| docs-scaffold-followups | P1 已落地 v1.43.0，P2 候选 | 保留 P2 候选 |
| domain-template-inheritance | 部分落地（多级同步自动化待独立仓库试验）| **延后池** |
| **issue #238** | **远端已 CLOSED**（2026-07-21T08:33Z）：维护者评估 4 处冲突裁决（不采纳 `.nvmrc`、沿用 v1.55.0 `.node-version`+`package.json#volta`，因 Volta 不读 .nvmrc）；核心诉求由 #239（v1.55.1）满足，深度诊断由 #240（v1.56.0）跟踪。**本地镜像过期（State: OPEN）** | **B0 归档过期镜像**（远端无需操作）|

## 2. 去重 / 冲突 / 依赖

- **去重**：issue **#234 + #235** 高度重叠（token hotspot 累计 summary / rollup 触发，来自 LUMEN-DEMO + zhiyan）→ B1 合并为单一工作，结合本地 `token-hotspot-records.md` 未落地的 summary 闭环。
- **冲突（改同一批文件）**：`scripts/check-template.*` 被 capability(已落地) / sync-proxy(已落地) / template-check-maintainability / windows-sync-output-noise 触及；`git-guide §5.7` + `sync-template.*` 被 sync-proxy(已落地) + windows-sync-output-noise 共改 → B2 落地需与已落地的 sync-proxy 协调。
- **依赖**：post-sync-version-checklist 的领域模板差异章节依赖 domain-template-inheritance 的 `--domain-template`（延后池）→ post-sync-version-checklist 一并延后。

## 3. 分批计划

| Batch | 范围 | 主要文件 | 验证 | issue 闭环 | 状态 |
|---|---|---|---|---|---|
| **B0 清理**（低风险）| 归档已落地提案：batch1.5-patch、sync-proxy、**project-registry**（Batch 0-6 全落地）；capability **留剩余标记不归档**（Batch 4 真待办）；归档 #238 过期镜像 | `git mv` → `_archive/proposals/` | check-template | 归档 #238 过期镜像（远端已 CLOSED）| 待执行 |
| **B1 token hotspot rollup** | 落地 summary / rollup 触发闭环（合并 #234+#235 + token-hotspot-records）| `ai/session-rules.md` §4.1、可能新增 summary 模板、`check-template.*` 断言、`template-sync.json`（若新增模板）| check-template + 行为抽样 | 合并 #234 + #235 → 关闭 | 待执行 |
| **B2 sync 体验** | `windows-sync-output-noise`（#9）| `git-guide §5.7`、`sync-template.*`、`check-derived-sync.*` | dry-run 行为抽样 | — | 候选 |
| **B3 check-template 维护** | `template-check-maintainability`（失败诊断增强 P1）| `check-template.sh` / `.ps1` | 失败用例抽样 | — | 候选 |
| **B4 web 主文件膨胀** | issue **#232**（阈值 + 业务下沉 + 自检）| `ai/global-rules.md` §5 / `template-docs/web-fullstack-profile.md` / 自检 | 派生项目阈值验证 | 关闭 #232 | 候选 |

## 4. 延后池

- `domain-template-inheritance`（待独立仓库试验多级同步自动化 + 领域 scaffold）
- `capability-...-contracts` Batch 4（等 CAP-007 真实任务观察）/ Batch 5（暂缓）
- `docs-scaffold-followups` P2（docs-scaffold 辅助模板）
- `post-sync-version-checklist`（依赖 domain-template 的 `--domain-template`）

## 5. 待确认 / 风险点

1. **#238（已查证 2026-07-22，远端已 CLOSED）**：远端 2026-07-21T08:33Z 已关闭——维护者评估做 4 处冲突裁决（不采纳 .nvmrc、沿用 v1.55.0 .node-version+volta，因 Volta 不读 .nvmrc；核心由 #239 满足、深度由 #240 跟踪）。**本地镜像过期（State: OPEN）**，B0 只需归档过期镜像，远端无需操作。「Volta 不读 .nvmrc」分析与维护者评论一致。
2. **B0 归档范围**：`project-registry` / `capability` 是否真有未落地项，需读提案正文确认（摘要显示主体已发布）。
3. **B1 summary 模板是否新增同步文件**：若新增 `template-docs/token-hotspot-summary.example.md` 需更新 `template-sync.json` + 自检（issue #234 / #235 §3 均提到）。

### 5.4 完整性自检结论（2026-07-22）

- **#238 远端已 CLOSED**（本地镜像过期）—— 自检发现，已修正 §1 / §3 / §5.1。
- **Agent「已落地」判断经 CHANGELOG / git log 佐证准确**：sync-proxy v1.54.2、capability v1.52.4、project-registry v1.54.1（ca71b8f）、batch1.5（#210 / 1190932）。
- **capability / project-registry 剩余项已确认（2026-07-22 agent 读正文）**：capability **留剩余标记不归档**（Batch 4 Web App Profile = 真待办，CAP-007 活跃观察，§11 标准，§12 明示不归档）；project-registry **可整体归档**（Batch 0-6 全落地，Batch 7 无限期搁置、提案 B 第三类场景由 domain-template 承接）。另：batch1.5-patch 引用 `11d8b2c` 是 feat-branch 哈希，squash 后 main 上为 `1190932`（#210），内容一致非出入。
- **远端 closed proposal issue（#81–#221）无遗漏配对**（均已有对应归档 / 处理）。
- **patch 文件**：本地仅 batch1.5-patch 一份，无遗漏。
- **方法论教训**：①issue 状态查 `--state all` 不只 open，本地镜像 State 会过期；②读 issue 评论不只 body（关闭评论常含 triage 决策——#238 关闭评论已记录完整 4 处裁决，本轮重复了该分析）；③「X 被 Y 覆盖」须查 Y 实际实现 + X 远端实际状态；④矛盾信号必追查（open 列表缺 238 但镜像说 OPEN = 过期）。

## 6. 执行状态跟踪

> 每批执行后在此更新；Batch 完成并归档后，本文件整体移入 `_archive/proposals/`。

| Batch | 状态 | 分支 | PR | 合并提交 | issue 关闭 |
|---|---|---|---|---|---|
| B0 | ✅ 完成（2026-07-22）| chore/archive-c1-b0-proposals（已删）| #242 | 5eab88c | issue-238 镜像归档（#238 远端已 CLOSED）|
| B1 | ✅ 完成（2026-07-22，v1.56.1）| chore/c1-b1-token-hotspot-rollup | 本 PR | v1.56.1 | 合并 #234 + #235（rollup 触发落地 §4.2）|
| B2 | 候选 | — | — | — | — |
| B3 | 候选 | — | — | — | — |
| B4 | 候选 | — | — | — | — |
