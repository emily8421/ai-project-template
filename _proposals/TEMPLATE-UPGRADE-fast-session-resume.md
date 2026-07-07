# TEMPLATE-UPGRADE: 快速续接模式与 handoff stale 裁决

> 来源：模板维护者

## 背景

2026-07-07 维护会话中，用户仅要求“读取续接点”，AI 却执行成完整规则重读、远端 issue / PR 复核和历史状态重建，导致恢复耗时过长。根因不是续接文件机制失效，而是缺少“读取续接点”的快速模式、时间盒和 handoff 过期裁决规则。

## 问题

- `.ai/session-handoff.md` 正常结束时可作为续接锚点，但突然中断、上下文耗尽、远端操作后未回写时可能过期。
- 当前 `ai/session-rules.md` 要求恢复时读取完整规则与相关文档，容易把“读取续接点”扩大成完整审计。
- 远端 issue / PR 是可变事实，不应作为快速恢复默认步骤。
- handoff 与 Git 不一致时缺少“立即标记 stale 并停止深挖”的明确退出条件。

## 拟改

1. 在 `ai/session-rules.md` 增加“快速续接模式”：默认本地只读、2 分钟时间盒、不联网、不继续执行任务。
2. 新增 `ai/commands/resume.md`，路由“读取续接点 / 继续上次”。
3. 更新 `ai/commands/README.md`，把自然语言入口指向 `resume`。
4. 更新 `template-docs/session-handoff.example.md`，增加 `Updated at / Status / Branch / HEAD / VERSION / Remote snapshot` 元数据头。
5. 更新 `template-sync.json` 和自检脚本，确保派生项目同步获得该能力。

## 版本影响

- 建议版本：`v1.41.0`
- 类型：模板方法论增强；不改变项目事实文档结构。

## 验证方式

- `git diff --check`
- `powershell.exe -ExecutionPolicy Bypass -File scripts/check-template.ps1`
