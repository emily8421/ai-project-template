# Stack Adapter：React / TypeScript

> Sync notice: This file is maintained by `ai-project-template` and may be overwritten when a derived project syncs template methodology.
> Do not edit it directly in derived projects; propose reusable changes in `_governance/_proposals/` and upstream them to the template repository.

React 前端的 Adapter：与 `fastapi-python.md`（同项目后端）配合使用；前后端类型的单一事实源见第 3 条。每条给出「要求 / 违例信号 / 检查口径」。

## 1. 禁 `any`，泛型贯穿

- **要求**：禁用 `any`；类型从 API client 的响应定义起用泛型贯穿到组件 props，不在中间层退化为宽类型。
- **违例信号**：`: any`、`as any`、`any[]`。
- **检查口径**：`tsc --noEmit` + eslint `@typescript-eslint/no-explicit-any`（项目按 `ai/implementation-lifecycle-rules.md` §6.2 声明启用）。

## 2. 跨层 props 复用派生类型

- **要求**：跨层传递的数据形状用 `ReturnType<typeof useXxx>` 从 hook 返回值派生，避免手写重复 interface 导致两处漂移。
- **违例信号**：同一响应形状存在 ≥2 份手写 interface。
- **检查口径**：review 组件 props 类型来源（应可追溯到 API client / hook 派生）。

## 3. 后端 OpenAPI 是类型单一事实源

- **要求**：后端 FastAPI `response_model` / OpenAPI schema 是前后端类型的单一事实源；前端经 codegen（如 openapi-typescript）或对生成基线的比对校验保持同步，不手写平行类型定义。
- **违例信号**：前端手写 interface 与后端 schema 字段不一致（contract 变更后前端未重生成）。
- **检查口径**：CI 或本地脚本比对生成类型与后端 schema 的一致性；后端契约变更的 PR 必须同步触发前端类型再生成（与 L0-12「先契约后实现」衔接）。
