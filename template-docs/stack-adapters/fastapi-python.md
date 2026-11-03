# Stack Adapter：FastAPI / Python

> Sync notice: This file is maintained by `ai-project-template` and may be overwritten when a derived project syncs template methodology.
> Do not edit it directly in derived projects; propose reusable changes in `_governance/_proposals/` and upstream them to the template repository.

FastAPI 后端的 Adapter：把 L0（`ai/global-rules.md` §2.1）与质量门口径（`ai/implementation-lifecycle-rules.md` §6.2）落到该栈的可执行写法。每条给出「要求 / 违例信号 / 检查口径」。

## 1. 分层与异常边界

- **要求**：`service` 层不得 import FastAPI 的 `HTTPException`、`Request`、`Response`——业务层抛领域异常（自定义异常类），`api` 层（router / 异常 handler）统一转换为 HTTP 语义。
- **违例信号**：service 模块 import 行出现 `fastapi`。
- **检查口径**：grep `^from fastapi|import fastapi` 于 service / 业务模块（api 层除外）；code review 复核。

## 2. code→HTTP 映射全局唯一

- **要求**：领域异常 code → HTTP 状态码的映射全局唯一（集中在一处异常 handler 或映射表），不得散落在各 router；成功响应使用统一 helper 构造。
- **违例信号**：多个 router 内各自 `raise HTTPException` 处理同一业务异常。
- **检查口径**：grep `HTTPException` 出现文件数（应收敛于 api 层与单一 handler）；review 核对映射唯一性。

## 3. router 注册用列表和循环

- **要求**：应用装配处 router 注册用列表 + 循环 include，避免逐条条件 include 堆叠。
- **检查口径**：review 装配模块（如 `main.py` / `app.py`）。

## 4. 多实现显式契约

- **要求**：demo / 真实等多实现（mock / prod、read-replica / primary）使用 `typing.Protocol` + `@runtime_checkable` 显式契约，配 contract test；禁止仅靠鸭子类型 + docstring 声明接口对齐（与 `ai/implementation-lifecycle-rules.md` §6.2 应用说明第 3 条同口径）。
- **检查口径**：每个多实现接口定位到对应 Protocol 定义与 contract test 文件。

## 5. 依赖注入类型注解

- **要求**：service 的 repository 等依赖形参必须有类型注解（注解到 Protocol 或具体类）。
- **违例信号**：构造函数 / 依赖注入点出现无注解形参。
- **检查口径**：mypy / pyright 类型检查覆盖 service 层（项目按 §6.2 声明是否启用）。

## 6. 配置集中与关键 secret fail-closed

- **要求**：env 读取集中在单一 Pydantic Settings 模块，不散落 `os.getenv`；关键 secret（token 签名密钥、数据库凭证、第三方 API key）启动期校验，缺失或为默认值即启动失败（与 `ai/implementation-lifecycle-rules.md` §6.2 应用说明第 2 条同口径；本地开发 / 测试 / 显式 Mock 场景允许受控替代配置）。
- **违例信号**：service / api 模块内直接 `os.getenv`。
- **检查口径**：grep `os.getenv|os.environ`（应收敛于 settings 模块）；启动冒烟验证缺 secret 即失败。

## 7. import 卫生

- **要求**：import 收敛在文件顶部，不文件中部追加；用 ruff（或等价 linter）检查未使用 import。
- **检查口径**：`ruff check --select F401,F811`（或项目声明的等价命令）。
