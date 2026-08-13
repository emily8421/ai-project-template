# TEMPLATE-UPGRADE：本地预检覆盖 CI check-markdown-clean（gap）

> 来源：模板维护者（pitfall rollup 2026-08-13，2 次实证）
> 状态：候选（待 triage）
> 目标版本：待确认（落地建议 PATCH）
> Release impact：none（本稿仅提案；若落地按 PATCH 论证，待维护者确认）
> Release strategy：单独发布

## 1. 动机（去项目化）

本地 `scripts/check-template.ps1` 全绿（1995 项 / 0 失败）≠ CI 绿。CI `template-check` job 含两个独立 step：`check-template` + `check-markdown-clean _proposals ai-records`（后者查 `_proposals/` / `ai-records/` 下 md 末尾换行等整洁度）。本地常规落地流程只跑 `check-template.ps1`，不覆盖 `check-markdown-clean`，形成本地预检盲区——本地 PASS 后 push 仍可能 CI fail。

**2 次实证**（详见 `ai-records/pitfalls/SUMMARY.md` §1）：

- 2026-08-11 pitfall 机制落地 PR：提案文件缺末尾换行，本地全绿、CI fail，返工一轮。
- 2026-08-13 #332 落地 v1.61.4：同类，提案文件缺末尾换行，CI fail 10s，修复后绿。

**跨派生通用**：`check-markdown-clean.ps1` 在 `template-sync.json files_all`（下行同步），任何派生项目落地 `_proposals/` md 都会踩同名 CI step。

## 1.1 与既有规则的关系（去重）

- **`check-template.ps1` / `check-markdown-clean.ps1`**（`scripts/`，现行）：前者查 files_all 同步结构（1995 项），后者查 `_proposals` / `ai-records` md 整洁度。**机制不同**——两者覆盖范围不重叠，本提案不合并脚本，只让本地落地流程同时跑两者。
- **`implementation-lifecycle-rules §6.2`**（质量门口径）：**对象不同**——§6.2 管「项目代码质量门」，本提案管「模板文件整洁度预检」。
- **`template-docs/remote-ci-sop-profile.md`**（CI SOP）：**层级不同**——profile 管 CI 侧步骤，本提案补本地侧预检对齐 CI。
- **`session-rules §4.3` pitfall observation log**（v1.61.1）：**机制不同**——§4.3 是事后坑观察记录，本提案是事前预检补强（防坑）。
- **`agent-command-preflight §6`（#317）**：**对象不同**——#317 管命令执行前失败域隔离预检，本提案管模板文件落地前整洁度预检。
- **`MAINTAINERS §3` 步骤 10**（已固定 `check-markdown-clean _proposals ai-records` 参数）：**指向**——本提案让本地预检与该 CI 固定参数对齐。

**本提案不重复它们**：脚本不改、CI 不改、§6.2 不碰；独有价值是「本地落地流程补跑 check-markdown-clean，对齐 CI 覆盖」。差异化：把 MAINTAINERS §3 步骤 10 的 CI 参数下沉为本地预检命令，消除「本地全绿 CI fail」返工。

## 2. 拟改（候选落地路径，待 triage 选一或组合）

让本地落地预检覆盖 `check-markdown-clean _proposals ai-records`，三选一：

- **(a) `check-template.ps1` 末尾追加调用** `check-markdown-clean.ps1 _proposals ai-records`：本地一键预检即覆盖 CI 两 step。改动最小、最直接防坑，但 check-template 语义略扩（原本只查同步结构）。
- **(b) `implementation-lifecycle-rules` / `remote-ci-sop-profile` 本地验证清单补一条**：文档说明落地前跑两脚本。不改脚本，靠规则自觉。
- **(c) `commands/` 或 SOP 命令模板固化** `check-template + check-markdown-clean` 两脚本为标准落地预检命令。

AI 倾向 **(a)**（最直接防坑，本地一键对齐 CI）；(b) 为补。(a) 需改 `scripts/check-template.ps1` + `scripts/check-template.sh`（双语对照）。最终方案由模板维护者 triage 定。

## 3. 版本影响

- **本稿**：`none`（仅 `_proposals/` 草案）。
- **若落地 (a)**：PATCH（自检脚本增强，本地预检多跑一步；不改 CI、不改同步结构、不新增对模板文件的强制断言——`check-markdown-clean` 本就在 CI 跑），判据 `CONTRIBUTING §4`。
- **若落地 (b)**：PATCH（规则文档补一条说明）。

## 4. 影响面

- **候选改动文件**（按 §2 选项）：`scripts/check-template.ps1` + `scripts/check-template.sh`（a）；或 `ai/implementation-lifecycle-rules.md` / `template-docs/remote-ci-sop-profile.md`（b）。
- **不触碰**：CI workflow、`check-markdown-clean.ps1` 本身、`template-sync.json` 结构、VERSION 机制。
- **预期效果**：本地落地预检与 CI 覆盖对齐，消除「本地全绿 CI fail」返工；派生项目同步后同样受益（check-markdown-clean 下行同步）。

## 5. 验证方式

- 落地后本地 `check-template.ps1`（含 check-markdown-clean 调用，若选 a）全绿 + 与 CI 同款。
- 故障注入：临时去掉一个 `_proposals` md 末尾换行，确认本地预检能抓到（对齐 CI）。
- 双语对照（`.ps1` / `.sh`）行为一致；`check-markdown-clean _proposals ai-records` 严格限定参数（不扩 `_archive`，见 token-hotspots SUMMARY §3）。

## 6. 后续

待 triage：选 (a) / (b) / (c)。若采纳落地，合并后归档本提案到 `_archive/proposals/`。实证见 `ai-records/pitfalls/SUMMARY.md` §1（08-11 + 08-13 同类 2 次）。
