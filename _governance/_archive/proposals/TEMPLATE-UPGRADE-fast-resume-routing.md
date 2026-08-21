# TEMPLATE-UPGRADE: 快速续接优先路由

> 来源：模板维护者
> 状态：处理中

## 动机

`v1.41.0` 已新增快速续接模式，但入口规则仍容易被理解为“任何场景都先完整读取 `ai/index.md` 列出的全部规则文件”。当用户只说“读取续接点 / 继续上次 / resume”时，AI 可能把纯恢复摘要扩展成完整规则审计，导致响应变慢，并与快速续接“约 2 分钟内给出可行动恢复摘要”的目标冲突。

## 拟改

- 在 `ai/index.md` 和三类 AI 入口文件中明确：纯快速续接是场景化例外，不等于开始分析、设计或编码。
- 在 `ai/session-rules.md` §3 / §3.1 中明确快速续接优先裁剪：只读最小规则与本地状态；若用户随后要求继续执行任务，再切回完整恢复流程。
- 在 `ai/commands/README.md` 与 `ai/commands/resume.md` 中补充 resume 命令路由例外，避免通用命令流程覆盖快速续接。
- 在 `scripts/check-template.sh` / `.ps1` 增加防回归断言。
- 递增 `VERSION` 并更新 `CHANGELOG.md`。

## 版本影响

建议 `PATCH`：该变更是既有快速续接能力的路由与文案修正，不新增同步文件，不改变文档编号体系或核心开发流程。

## 影响面

- 下游派生项目同步后，AI 在纯恢复摘要场景会更快给出结论。
- 分析、设计、编码、同步、远端 issue / PR 处理、提交、清理等任务仍必须读取完整规则并按写入确认边界执行。

## 验证方式

- `git diff --check`
- `powershell.exe -ExecutionPolicy Bypass -File scripts/check-template.ps1`
- 如环境具备 Git Bash，再运行 `bash scripts/check-template.sh`

