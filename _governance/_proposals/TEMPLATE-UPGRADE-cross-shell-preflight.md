# TEMPLATE-UPGRADE: 跨 Shell 路径预检与失败域隔离

> 来源：LUMEN_demo_T2.1（emily8421/LUMEN-DEMO）派生项目回流，GitHub issue #423。
> 状态：实施已获维护者确认（2026-09-01）。
> Release impact：patch（已确认）。
> Release strategy：独立 PATCH。

## 1. 动机

Windows PowerShell、Bash 及会聚合子命令结果的 AI 工具，对路径通配、字面路径和独立只读检查的失败传播并不相同。可选路径未命中不应掩盖同批已确认的 Git 或版本事实，但该边界不得放宽构建、测试、权限、网络、CI、远端或写入失败即停。

## 1.1 与既有规则的关系（去重）

- `ai/rules-core.md` 的“预检精确查询与失败域隔离”已规定精确查询、关键事实与辅助检查分批及不共享 all-or-nothing 结果。本提案补跨 Shell 路径探测、字面路径读取和预期性可选结果的可执行边界，互补不重复。
- `ai/rules-core.md` 的失败即停规则仍适用于命令、权限、sandbox、网络、超时、构建、测试、CI、远端和写入失败；本提案只约束无副作用的路径定位。
- issue #423 的本地镜像见 `_governance/_proposals/_remote-issues/issue-423.md`；其引用的历史提案在当前归档目录未找到，不作为本次实现依据。

## 2. 拟改文件

| 文件 | 修改 |
|---|---|
| `ai/rules-core.md` | 增加跨 Shell 无副作用路径预检规则：标明 Shell 前提、优先精确 / 字面路径 API、一次不同的只读定位查询，以及 `pass` / `fail` / `not-found` / `no-match` / `not-checked` 的独立结果语义。 |
| `ai/commands/README.md` | 增加命令示例编写约定，要求标明 Shell 前提，不假设通配语义，并将可选辅助读取与关键事实按失败域拆分。 |

## 3. 边界与风险

- 不改 `ai/session-rules.md`，避免重复 Checkpoint Mode 的失败即停正文。
- 不改同步清单、脚本、版本号或远端 issue。
- 不把 `not-found` / `no-match` 泛化为成功：只有预期性的可选只读结果可按语义报告；必需路径缺失仍须报告并停止后续状态变更。

## 4. 验证与归档

1. 运行 `git diff --check` 与 `scripts/check-markdown-clean.ps1` 的提案窄范围检查。
2. 运行模板自检，确认规则入口与同步范围未漂移。
3. 人工核对 Bash / PowerShell 示例均标明适用 Shell，且规则明确排除状态变更失败。
4. PR 合并后归档本提案；远端 issue #423 是否关闭须单独复核和确认。
