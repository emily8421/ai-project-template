# TEMPLATE-UPGRADE: A13 同步闭环门禁与报告真实性

> 来源：GitHub issue #148（zhiyan-digital-cs-platform 派生项目回流）
> 状态：Batch 1 已落地；Batch 2 已落地；Batch 3 dry-run 轻量预览设计评估中
> 目标版本：`v1.43.2`（Batch 1）；`v1.43.3`（Batch 2）；Batch 3 实现版本待定
> Release impact：Batch 1 / 2 为 patch；Batch 3 本轮仅设计评估为 none，后续实现预计 minor
> Release strategy：分批落地；先补 A13 收尾门禁，再修 fallback 参数，最后评估 dry-run 预览增强

## 1. 背景与来源

远端 issue #148 反馈：派生项目同步模板后，AI 容易把“同步提交 + 边界验证完成”误说成 “A13 完整闭环完成”，但实际可能尚未完整执行 `post-sync-cleanup`、`docs-system-audit`、提案回流收口和同步报告留痕。

本地镜像：`_proposals/_remote-issues/issue-148.md`。

## 2. Batch 1 落地范围

1. 在 `ai/commands/sync-methodology.md` 中增加 A13 完成判据矩阵门禁，要求最终输出不得把轻量执行 / 未执行写成完整闭环。
2. 在 `ai/prompts/maintainers/12-sync-template.md` 的标准 SOP Prompt 中增加收尾矩阵、状态枚举和提案回流收口矩阵要求。
3. 在 `template-docs/derived-sync-report-template.md` 中补充命令真实性字段、A13 完成判据矩阵和提案回流收口矩阵。
4. 在 `scripts/check-template.sh` / `.ps1` 中增加关键断言，防止后续移除 A13 门禁。
5. 更新 `VERSION` / `CHANGELOG.md`，按 PATCH 发布。

## 3. 非目标 / 后续候选

- 本轮 Batch 3 只做 dry-run 轻量预览设计评估，不直接修改 `scripts/sync-template.*`。
- 不关闭 issue #148；dry-run 预览增强实现合并后再判断是否关闭。

## 3.1 Batch 2：PowerShell fallback 参数修复（2026-07-09）

- 问题复现：`Invoke-NativeTemplateSync` 使用参数名 `$Args`，在 Windows PowerShell 中与自动变量 / 调用语义冲突；调用 `Invoke-NativeTemplateSync -Args @('--commit')` 时函数内数组为空，导致 fallback 静默回到默认 `--dry-run`。
- 修复方案：将 fallback 函数参数改为 `$NativeSyncArgs`，调用处改为 `-NativeSyncArgs $SyncArgs`，避免使用易混淆的 `$Args` 名称。
- 验证要求：用 fake bash 强制 Git Bash probe 失败，运行 `scripts/sync-template.ps1 --commit` 应输出 `Using native PowerShell fallback for --commit`，不得输出 `INFO dry-run`。
- 版本影响：属于脚本 fallback bugfix，按 PATCH 发布。

## 3.2 Batch 3：dry-run 轻量预览设计评估（2026-07-09）

### 目标

让大版本同步在完整 `--dry-run` 逐文件 diff stats 过慢或超时时，仍能快速输出可审计的同步边界，且不改变工作区、不 stage、不提交。

### 参数设计建议

| 参数 | 建议 | 输出内容 | 工作区影响 | A13 报告口径 |
|---|---|---|---|---|
| `--dry-run` | 保留现有完整预览语义 | 同步清单状态 + 每个差异文件的 diff stat | 无 | 完整 dry-run 预览 |
| `--summary` | 建议优先实现 | 目标版本、变更文件清单、按顶层目录聚合的新增 / 修改 / 删除 / 跳过数量、风险路径命中 | 无 | 可作为“等价边界预览” |
| `--list-only` | 建议作为更轻量只读清单模式 | 目标版本、同步清单、每个文件的存在 / 差异 / 跳过状态，不输出目录聚合和 diff stat | 无 | 只能作为“清单核对”，不足以替代完整 dry-run |
| `--no-stat` | 建议作为 `--dry-run --no-stat` 兼容修饰符，行为等价于 `--summary` | 跳过逐文件 diff stat，保留变更文件清单与目录聚合 | 无 | 可作为“等价边界预览” |
| `--max-stat-files N` | 建议延后实现或作为可选增强 | 对前 N 个差异文件输出 diff stat，其余只列清单 | 无 | 部分 dry-run 预览，需记录截断数量 |

### 推荐实现顺序

1. **Batch 3A**：先实现 `--summary` 和 `--no-stat`，覆盖大版本同步最主要的超时场景，并保持输出可审计。
2. **Batch 3B**：若仍需要更轻量清单核对，再实现 `--list-only`。
3. **Batch 3C**：若维护者仍需要部分 diff stat，再评估 `--max-stat-files N`，避免一次性扩大参数面。

### 关键语义约束

- `--summary`、`--list-only`、`--no-stat` 均必须只读，不得修改工作区、不得 stage、不得提交。
- Bash 与 PowerShell fallback 必须保持参数语义和输出字段一致。
- 输出必须标明方向：`local current files -> template <VERSION> (changes that --commit would apply)`。
- 风险路径命中至少覆盖：`README.md`、`ai/project-rules.md`、`docs/00-09`、`frontend/`、`backend/`、`tests/`、`docker/`。
- A13 完成判据矩阵中，完整 `--dry-run` 超时后使用 `--summary` / `--no-stat`，应标为 `等价替代`；只使用 `--list-only` 应标为 `部分完成` 或 `清单核对`，不得直接写成完整 dry-run。

### 后续实现验收建议

- `bash scripts/sync-template.sh --summary` 与 `powershell -ExecutionPolicy Bypass -File scripts/sync-template.ps1 --summary` 输出字段一致。
- `--summary` / `--no-stat` 不调用逐文件 `git diff --no-index --stat`，大版本同步不因 diff stat 输出过多而超时。
- `git status --short` 在 `--summary`、`--list-only`、`--dry-run --no-stat` 前后保持一致。
- `--commit` 行为不变，仍只在显式 commit 模式写入和提交。
- `scripts/check-template.sh` / `.ps1` 增加参数解析与关键输出断言。

## 4. 验收标准

- `sync-methodology` 命令和 12 号 Prompt 均要求输出 A13 完成判据矩阵。
- 同步报告模板能记录每个关键步骤的实际命令、退出结果、是否完整执行、是否为等价替代和是否生成独立报告。
- 提案回流收口不再只依赖 `closed`，而是要求输出“归档 / 保留 / follow-up / 等待”等明确建议。
- `git diff --check`、PowerShell fallback 自检和 Git Bash 完整自检通过。

## 5. 建议后续步骤

1. Batch 1 已合并并评论 issue #148，说明已覆盖 A13 门禁 / 报告真实性 / 提案收口矩阵。
2. Batch 2 合并后，评论 issue #148，说明 `scripts/sync-template.ps1 --commit` fallback 参数修复已覆盖。
3. Batch 3 设计评估完成后，优先实现 `--summary` 与 `--no-stat`；`--list-only` 和 `--max-stat-files N` 延后到后续小批次。
