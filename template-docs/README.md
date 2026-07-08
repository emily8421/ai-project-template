# template-docs/ 模板手册

本目录放 `ai-project-template` 给**人读**的手册与模板（场景引导、上手指南、环境安装、烟测、方法论说明、运行记录模板）。规则正文（给 AI 读的短 / 准 / 可执行规则）在 `ai/`；项目事实在 `docs/`。

## 手册导航

| 文档 | 看什么 |
|---|---|
| `scenario-guides.md` | 场景剧本：说一个场景意图 → AI 给「做什么 + 为什么」引导计划 |
| `beginner-guide.md` | 第一次用的全貌心智模型（是什么 / 准备 / 怎么用 / 输入→文档→代码 / 目录 / 常见错误） |
| `env-setup.md` | 装基础工具与环境（check-prereqs / bootstrap） |
| `ai-cli-setup.md` | 装 AI CLI（Claude / Codex）+ 公司中转站衔接 |
| `smoke-test.md` | 新手烟测流程 |
| `smoke-test-report-template.md` | 烟测结果记录模板 |
| `template-methodology.md` | 模板为什么这么设计（设计原则与各子系统 why） |
| `session-handoff.example.md` | 会话续接文件样例 |
| `derived-sync-report-template.md` | 派生项目同步模板后的运行记录模板 |
| `ui-prototype-strategy-template.md` | UI 原型策略 / 实现前原型记录模板 |

> 这些手册随模板下行同步（见 `template-sync.json`）；派生项目同步后获得最新版，不要在派生项目直接改，通用改进走 `_proposals/` 回流。操作走 `scenario-guides.md` 场景引导，命令速查看 `SOP.md`。
