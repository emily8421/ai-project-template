# ai-project-template

跨项目复用的 AI 编程项目模板。默认路径是：先准备产品愿景或其他上游输入、采集本机环境，再让 AI 多入口生成 / 补齐工程文档体系，最后按 Sprint 小步开发。

## 5 分钟最小路径

```bash
bash scripts/new-project.sh my-demo --local --no-remote
cd my-demo
powershell -ExecutionPolicy Bypass -File scripts/collect-env.ps1
```

然后：

1. 把产品愿景写入 `docs/vision/product-vision.md`。
2. 补齐 `docs/env/local-env.md` 的人工确认项。
3. 初填 `ai/project-rules.md` 的项目名称、Phase1 目标、技术栈倾向、运行环境约束和项目形态裁剪。
4. 复制 `ai/prompts/docs/01-review-inputs.md` 给 AI 评审输入材料；评审通过后复制 `ai/prompts/docs/00-generate-or-complete-docs.md`，多入口生成 / 补齐 `docs/00-09`、必要的 `docs/design/` 详细设计、项目 README 与 Sprint1。
5. 人工确认 `docs/03-prd.md` §3 阶段路线图、交付物形态和 `docs/05-tech-spec.md` 的本机 Demo 可行性，再用 `ai/prompts/dev/02-run-task.md` 执行第一个 Sprint。

> Demo / MVP 默认优先在本机运行。若 `docs/env/local-env.md` 显示资源不足，AI 必须在 `docs/05-tech-spec.md` 写明降级 / Mock 策略或服务器资源预案。

## 我该看哪个文件

| 你要做什么 | 看哪里 |
|---|---|
| 新建项目 | 本 README 的“5 分钟最小路径” |
| 多入口生成 / 补齐文档体系 | `ai/prompts/docs/00-generate-or-complete-docs.md` |
| 执行第一个 Sprint | `ai/prompts/dev/02-run-task.md` |
| 判断 docs / 代码目录如何裁剪 | `docs/README.md` |
| 查标准操作流程入口 | `SOP.md` |
| 同步模板到派生项目 | `SOP.md`、`git-guide.md` §5 |
| 修改模板本身 | `CONTRIBUTING.md`、`MAINTAINERS.md` |
| 查看完整版本记录 | `CHANGELOG.md` |

## 常用命令

```bash
# 新建本地烟测项目
bash scripts/new-project.sh my-demo --local --no-remote

# 新建远端项目
bash scripts/new-project.sh my-demo --account <GitHub账号> --visibility private

# 模板自检
powershell -ExecutionPolicy Bypass -File scripts/check-template.ps1

# 派生项目同步模板方法论（v1.6.8+ 后续同步；旧项目首次同步见 git-guide.md §5）
powershell -ExecutionPolicy Bypass -File scripts/sync-template.ps1 --dry-run
powershell -ExecutionPolicy Bypass -File scripts/sync-template.ps1 --commit
powershell -ExecutionPolicy Bypass -File scripts/check-derived-sync.ps1
```

## 目录速览

| 路径 | 作用 |
|---|---|
| `ai/` | AI 行为规范；AI 每次任务先读 `ai/index.md` |
| `docs/` | 项目事实、需求、设计、计划与验证；分区规则见 `docs/README.md` |
| `tasks/` | 复杂 Sprint 拆分后的任务单 |
| `SOP.md` | 标准操作流程索引 |
| `INIT-PROMPT.md` / `ai/prompts/` | Prompt 索引与按场景拆分的可复制 Prompt 模板 |
| `CONTRIBUTING.md` | 模板变更治理流程 |
| `MAINTAINERS.md` | 模板维护者说明、发布 checklist、同步清单维护规则 |
| `CHANGELOG.md` | 完整版本记录 |
| `template-sync.json` | 下行同步方法论文件清单 |
| `scripts/` | 新建项目、同步模板、自检、环境采集脚本 |
| `_examples/` | 已填好的参考样例项目 |
| `_proposals/` | 模板优化提案收件箱 |

## 轻量项目路径

若项目是小脚本、一次性实验或纯工具库，仍保留基本边界与验证口径即可：

1. 写最小 `docs/vision/product-vision.md`。
2. 运行 `scripts/collect-env.ps1`，确认本机可运行边界。
3. 按 `docs/README.md` 的裁剪表决定是否省略 `docs/06`、`docs/07` 和代码目录。
4. 保留最小版 `docs/03-prd.md`、`04-architecture.md`、`05-tech-spec.md`、`08-dev-plan.md`、`09-verification.md`。
5. 每次只实现一个小任务；验证结果记录到 `docs/09-verification.md` 或当前 Sprint。

## 当前版本

当前模板版本见 `VERSION`。最近版本摘要：

- v1.9.0：拆分 Prompt Library，`INIT-PROMPT.md` 改为轻量索引，完整 Prompt 按场景迁移到 `ai/prompts/`。
- v1.8.0：新增文档生命周期规则与 `docs/inputs/` 原始输入包，支持多入口生成 / 补齐文档体系，强化全链追溯、变更传播、横切事实一致性和外部文档接入。
- v1.7.1：跟进阶段双维度，修正新项目 README 与样例项目的交付物形态说明，并将样例一致性纳入自检。
- v1.7.0：新增阶段双维度（功能范围 + 交付物形态），强化 vision→docs 的 REQ 全覆盖、产品红线和“声称据实”约束。
- v1.6.9：区分旧派生项目首次同步与 v1.6.8+ 后续同步；新增 `check-derived-sync` 派生边界检查，避免把模板仓库自检用于派生项目验收。
- v1.6.8：新增 `INIT-PROMPT.md` §15「同步后项目整理」，用于派生项目同步方法论后审计 docs 分区、README、project-rules 与运行环境约束。
- v1.6.7：补充模板同步文件的覆盖说明；明确派生项目根 `README.md` 不参与模板下行同步；标准化派生 README 版块；补齐样例 docs 分区结构。

完整记录见 `CHANGELOG.md`。
