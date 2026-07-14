# TEMPLATE-UPGRADE: 规则分层加载与任务路由入口优化

> 来源：模板维护者
> 状态：本地已落地，待 PR 合并后归档
> 目标版本：v1.50.1
> Release impact：patch（AI 建议；改变规则读取方式，不降低写入确认、Git 事实优先和完整回退门禁）
> Release strategy：先落地最小核心规则 + `ai/index.md` 路由表；后续按真实使用反馈再细分更多命令级规则包。

## 1. 背景

模板规则文件持续增长后，任何非快速续接任务都会触发 `ai/index.md` 全量规则读取。实际使用中，PR / CI 闭环、Git 状态复核、简单 bug 修复等任务经常不需要完整读取文档生命周期大文件，但现有入口把“继续执行任务”与“读取所有规则文件”绑定，导致启动慢、上下文占用高、对话刷屏，并增加用户中断概率。

这不是单次 AI 操作习惯问题，而是入口规则缺少任务路由造成的结构性问题。

## 2. 目标

1. 将 `ai/index.md` 从“全量必读清单”升级为“规则导航与任务路由入口”。
2. 新增短小的 `ai/rules-core.md`，承载所有任务共同硬规则。
3. 让 PR / CI、编码、文档、同步、模板维护等任务按需加载相关规则包。
4. 保留完整规则回退包：任务不明确、规则冲突、修改规则入口或同步机制时仍读取全量规则。
5. 更新入口镜像、自检和同步清单，避免派生项目继续继承旧的全量读取硬编码。

## 3. 非目标

- 不删除现有规则文件。
- 不降低写入确认、Git 事实优先、续接冲突仲裁和验证留痕要求。
- 不把文档生命周期规则从文档任务中移除。
- 不要求一次性重构所有 command 文件和 prompt 文件。

## 4. 拟改范围

| 文件 | 变更 |
|---|---|
| `ai/rules-core.md` | 新增所有任务最小必读硬规则、路由与回退原则、上下文卫生要求。 |
| `ai/index.md` | 改为规则路由入口，增加任务路由表与完整规则回退包。 |
| `AGENTS.md` / `CLAUDE.md` / `.cursor/rules/project-rules.mdc` | 改为指向 `ai/index.md` 路由，不再要求无条件读取全部规则文件。 |
| `ai/session-rules.md` | 将快速续接升级后的“全量读取”改为“按路由读取；不确定时回退全量”。 |
| `ai/commands/README.md` | 命令执行入口改为读取核心规则 + 命令路由包。 |
| `template-sync.json` / `scripts/sync-template.sh` | 纳入 `ai/rules-core.md`，确保派生同步可获得新入口。 |
| `scripts/check-template.sh` / `scripts/check-template.ps1` | 增加分层加载断言，避免回归到旧的全量硬编码。 |

## 5. 预期效果

- “读取续接点”仍走快速续接，不读大规则。
- “闭环 PR CI”只读核心规则、会话规则、实现生命周期、项目规则和命令路由，不再默认读取完整文档生命周期规则。
- “写文档 / 审文档”才读取文档生命周期与对应 doc-standards。
- “编码 / 修 bug”优先读取实现生命周期、项目规则和相关命令。
- “规则 / 同步 / 模板维护”仍强制读取完整回退包，保证高风险维护不漏规则。

## 6. 风险与缓解

| 风险 | 缓解 |
|---|---|
| AI 误判任务类型导致漏读规则 | `ai/rules-core.md` 和 `ai/index.md` 明确“不确定即回退完整规则包”。 |
| 派生项目入口未同步 | 更新 `template-sync.json` 与 `scripts/sync-template.sh` fallback 清单。 |
| 自检无法发现入口退化 | 更新 Bash / PowerShell 自检断言，检查 `rules-core`、任务路由和完整回退包。 |
| 过度优化削弱质量门禁 | 明确只优化读取路径，不删除规则、不降低写入确认和验证要求。 |

## 7. 验证方式

- `scripts/check-markdown-clean.ps1 _proposals ai-records template-docs`
- `git diff --check`
- `scripts/check-template.ps1`
- 如可用 Bash / CI，再运行 `bash scripts/check-template.sh`
