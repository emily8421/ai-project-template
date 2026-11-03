# GitHub Issue #334: TEMPLATE-UPGRADE：Stack Adapter（R5）—— FastAPI / Python + React / TypeScript

> Source URL: https://github.com/emily8421/ai-project-template/issues/334
> State: OPEN
> Labels: proposal, from:LUMEN_demo_T2.1
> Author: emily8421
> Created: 2026-08-12T06:24:05Z
> Updated: 2026-08-12T06:24:05Z
> Mirrored at: 2026-08-21
> Mirror status: raw remote issue copy for local triage; GitHub issue remains source of comments and closure state.

## Raw Issue Body

> 来源：LUMEN_demo_T2.1（emily8421/LUMEN-DEMO）派生项目回流

# TEMPLATE-UPGRADE：Stack Adapter（R5）—— FastAPI / Python + React / TypeScript

> 本提案是原混合提案 `TEMPLATE-UPGRADE-web-fullstack-code-consistency-baseline.md` 按 governance R1/R3/R5 分层拆分后的 **R5 技术栈 Adapter 部分**。跨项目通用条目见 `TEMPLATE-UPGRADE-universal-code-consistency-supplement.md`（R1/R2），Web 形态契约见 `TEMPLATE-UPGRADE-web-profile-code-consistency.md`（R3）。拆分依据 `docs/research/2026-08-10-rule-consolidation-map.md`；governance §8.3 要求「FastAPI / React / PostgreSQL 示例放进 Adapter」。

## 1. 动机（去项目化）

governance 上位框架定义 **R5 技术栈 Adapter**：把上层原则（R1-R4）翻译成当前语言 / 框架可直接执行的模式、配置和命令——回答「用 FastAPI / React 如何实现上层规则」。Adapter 只说「在该栈怎么做到」，不重复「为什么必须授权 / 为什么不能误删数据」（那是 R1/R4 的事）。

本提案补 `template-docs/stack-adapters/` 载体，把 FastAPI / React 的具体写法从 Web 文档移出；它不把 agent runtime 或具体业务事实纳入模板。

## 1.1 与既有规则的关系（去重）

- Web Profile 提案（R3）定义形态契约；本提案提供栈实现。
- 通用补充提案（R1/R2）定义跨形态原则；本提案提供 FastAPI/React 实现。
- `global-rules.md` §2.1 L0 是跨形态基线；本提案不重复 L0。
- 对应 governance R5；换栈后失效的内容才归入 Adapter。

## 2. 拟改：新建 `template-docs/stack-adapters/`

新建选择矩阵 `README.md`，并新增两份起步 Adapter：`fastapi-python.md` 与 `react-typescript.md`。不引入硬 CI 门禁；具体命令由派生项目按栈声明。

### 2.1 FastAPI / Python Adapter

- service 层不得 import FastAPI 的 `HTTPException`、`Request`、`Response`；业务层抛领域异常，api 层统一转 HTTP。
- `code→HTTP` 映射全局唯一；成功响应使用统一 helper。
- router 注册用列表和循环，避免逐条条件 include。
- demo / 真实等多实现使用 `typing.Protocol` + `@runtime_checkable` 显式契约和 contract test。
- service 的 repository 等依赖形参必须有类型注解。
- env 读取集中在单一 Pydantic Settings 模块，关键 secret 在启动期 fail-closed 校验。
- import 收敛在文件顶部，使用 ruff 等工具检查未使用 import。

### 2.2 React / TypeScript Adapter

- 禁 `any`；泛型从 API client 贯穿到组件。
- 跨层 props 使用 `ReturnType<typeof useXxx>`，避免重复 interface。
- 后端 OpenAPI / `response_model` 是前后端类型单一事实源；前端经 codegen 或基线比对生成类型。

## 3. 版本

模板版本：下一 **MINOR**。新增三个纯文本 Adapter 文件，不修改现有 profile / global-rules / project-rules，不新增 Gate。

## 4. 影响

- 新建 `template-docs/stack-adapters/README.md`、`fastapi-python.md`、`react-typescript.md`。
- 不触碰 Web Profile、L0、implementation lifecycle 或 WSG。
- 新 FastAPI/React 派生项目可对照 Adapter；现有项目可标识已落地或待对齐项。

## 5. 备选（已评估未采）

- 不把栈写法留在 Web Profile，避免形态契约与栈实现混层。
- 不一次铺满 R5 的全部七项，先落选择矩阵和少量成熟 Adapter。
- 不将跨栈仍成立的 secret 校验、多实现契约等原则重复放进 Adapter。
- 不将 Adapter 设成模板层硬 CI 门禁。

## 6. 后续

与 R1/R2 和 R3 提案共同成熟后按 C1 去重、冲突和依赖分析；后续可补 PostgreSQL Adapter。合并并下行同步后，本提案移入 `_archive/proposals/`。
