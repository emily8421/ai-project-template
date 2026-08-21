# TEMPLATE-UPGRADE：PowerShell sync fallback UTF-8 compatibility

> 来源：LUMEN_demo_T2.1（emily8421/LUMEN-DEMO）派生项目回流。
> 上游 issue：`https://github.com/emily8421/ai-project-template/issues/92`。

## 1. 背景与问题

模板已为 `scripts/sync-template.ps1` 与 `scripts/check-derived-sync.ps1` 提供 PowerShell fallback，用于 Git Bash / MSYS 无法从 PowerShell 启动的 Windows 环境。但 fallback 中部分 Git 输出仍直接走 PowerShell 原生命令文本管道读取。

在 Windows PowerShell 5.1 中，native command 文本输出可能按系统代码页转换；当 `git show` 读取 UTF-8 JSON、Markdown 或中文文件名时，可能出现乱码、`ConvertFrom-Json` 解析失败，或写回文件内容被错误转码。

## 2. 目标

1. fallback 路径读取 Git 文本输出时统一按 UTF-8 bytes 解码。
2. `sync-template.ps1` 写回模板文件时保留 Git blob 的 UTF-8 文本内容，不额外改写行尾或重复追加换行。
3. `check-derived-sync.ps1` 的提交标题、变更文件清单等 Git 输出使用同一 UTF-8 读取 helper。
4. 文档明确 Windows PowerShell 5.1 代码页风险和 fallback 处理口径。

## 3. 拟改范围

- `scripts/sync-template.ps1`
  - 新增 `Get-GitUtf8Text`，通过重定向到临时 bytes 文件后用 .NET UTF-8 解码。
  - `git show` 读取 `template-sync.json`、`VERSION`、Markdown / 文本文件时使用 UTF-8 helper。
- `scripts/check-derived-sync.ps1`
  - 新增同名 UTF-8 helper，供 fallback 中的 Git 文本读取统一使用。
- `scripts/check-prereqs.ps1`
  - 在 Windows PowerShell 5.1 环境提示 native command 代码页风险及 fallback 处理方式。
- `template-docs/env-setup.md`、`git-guide.md`
  - 补充 fallback 按 UTF-8 bytes 解码 Git 输出的说明。
- `scripts/check-template.ps1`、`scripts/check-template.sh`
  - 增加断言，防止 fallback 回退到直接读取 native 文本输出。

## 4. 版本影响

建议作为 PATCH 版本发布：这是既有 Windows PowerShell fallback 的兼容性脚本修复，不改变同步流程、文档编号体系或新增必填能力。

## 5. 验证计划

1. `git diff --check`。
2. `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/check-prereqs.ps1`。
3. `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/check-template.ps1`。
4. 语法检查：PowerShell 能加载 `scripts/sync-template.ps1` 与 `scripts/check-derived-sync.ps1`。

## 6. 归档计划

本提案随对应 PR 落地并关闭 issue #92 后，保留在 `_archive/proposals/`，不进入 `_proposals/` 待处理队列。
