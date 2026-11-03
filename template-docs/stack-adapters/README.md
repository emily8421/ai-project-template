# Stack Adapters（技术栈 Adapter 索引）

> Sync notice: This file is maintained by `ai-project-template` and may be overwritten when a derived project syncs template methodology.
> Do not edit it directly in derived projects; propose reusable changes in `_governance/_proposals/` and upstream them to the template repository.

本目录是技术栈 Adapter 载体：把上层原则翻译成具体语言 / 框架可直接执行的模式、配置与命令——只回答「在该栈怎么做到」，不重复「为什么必须做到」（那是上层文件的事，见下方层级表）。

## 层级与去重边界

| 层 | 文件 | 职责 |
|---|---|---|
| L0 通用基线 | `ai/global-rules.md` §2.1 | 跨语言、跨栈成立的写代码基本功 |
| 质量门口径 | `ai/implementation-lifecycle-rules.md` §6.2 | 哪些检查是 Gate、如何按形态裁剪与声明 |
| Web 形态契约 | `template-docs/profiles/web-fullstack-profile.md` | Web 形态的结构契约（App Shell / API client ↔ API-ID / vertical slice 等） |
| **技术栈 Adapter（本目录）** | 各 `*.md` | 该栈的具体写法：分层模式、异常边界、配置与类型管理、检查命令 |

换栈后失效的内容才属于 Adapter；栈无关原则在各上层文件，本目录不重复定义。

## 选择矩阵

| 你的项目栈 | 读这份 | 覆盖 |
|---|---|---|
| FastAPI + Python（后端） | [fastapi-python.md](fastapi-python.md) | 分层与异常边界 / 响应映射 / 依赖类型 / 配置与 secret / import 卫生 |
| React + TypeScript（前端） | [react-typescript.md](react-typescript.md) | 类型贯穿 / 单一事实源 |

- 未覆盖的栈（PostgreSQL 等数据库、Vue 等其他前端框架）暂无 Adapter；需要时按 `_governance/_proposals/` 回流提案新增。
- Adapter 只荐模式与检查手段，**不引入硬 CI 门禁**；具体质量命令由派生项目按 `ai/implementation-lifecycle-rules.md` §6.2 自行声明。
