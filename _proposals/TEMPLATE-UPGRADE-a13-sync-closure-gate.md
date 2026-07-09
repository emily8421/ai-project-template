# TEMPLATE-UPGRADE: A13 同步闭环门禁与报告真实性

> 来源：GitHub issue #148（zhiyan-digital-cs-platform 派生项目回流）
> 状态：Batch 1 已落地；Batch 2 fallback 参数修复落地中；dry-run 预览增强待后续评估
> 目标版本：`v1.43.2`（Batch 1）；`v1.43.3`（Batch 2）
> Release impact：patch（同步流程 Prompt / 报告模板 / 自检增强，不新增同步文件）
> Release strategy：分批落地；先补 A13 收尾门禁，再评估脚本行为改动

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

- 不在本批次新增 `--list-only` / `--summary` / `--no-stat` 等 dry-run 预览模式。
- 不关闭 issue #148；Batch 2 合并后应继续在 issue 中说明已覆盖 fallback 参数修复，dry-run 预览增强继续保留。

## 3.1 Batch 2：PowerShell fallback 参数修复（2026-07-09）

- 问题复现：`Invoke-NativeTemplateSync` 使用参数名 `$Args`，在 Windows PowerShell 中与自动变量 / 调用语义冲突；调用 `Invoke-NativeTemplateSync -Args @('--commit')` 时函数内数组为空，导致 fallback 静默回到默认 `--dry-run`。
- 修复方案：将 fallback 函数参数改为 `$NativeSyncArgs`，调用处改为 `-NativeSyncArgs $SyncArgs`，避免使用易混淆的 `$Args` 名称。
- 验证要求：用 fake bash 强制 Git Bash probe 失败，运行 `scripts/sync-template.ps1 --commit` 应输出 `Using native PowerShell fallback for --commit`，不得输出 `INFO dry-run`。
- 版本影响：属于脚本 fallback bugfix，按 PATCH 发布。

## 4. 验收标准

- `sync-methodology` 命令和 12 号 Prompt 均要求输出 A13 完成判据矩阵。
- 同步报告模板能记录每个关键步骤的实际命令、退出结果、是否完整执行、是否为等价替代和是否生成独立报告。
- 提案回流收口不再只依赖 `closed`，而是要求输出“归档 / 保留 / follow-up / 等待”等明确建议。
- `git diff --check`、PowerShell fallback 自检和 Git Bash 完整自检通过。

## 5. 建议后续步骤

1. Batch 1 已合并并评论 issue #148，说明已覆盖 A13 门禁 / 报告真实性 / 提案收口矩阵。
2. Batch 2 合并后，评论 issue #148，说明 `scripts/sync-template.ps1 --commit` fallback 参数修复已覆盖。
3. 单独评估大版本同步 `--list-only` / `--summary` / `--no-stat` 轻量预览模式。
