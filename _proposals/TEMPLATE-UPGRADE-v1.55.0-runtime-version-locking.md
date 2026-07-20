# TEMPLATE-UPGRADE-v1.55.0：运行时版本锁定通用机制（Node 首实例）

> 来源：模板维护者
> 状态：处理中
> 目标版本：v1.55.0
> Release impact：minor（AI 建议，待维护者确认）
> Release strategy：单独发布

## 1. 背景

母模板目前没有「运行时版本锁定」机制：

- `template-docs/env-setup.md` 只说"装 Node.js LTS"，无多版本管理约定；
- `ai/project-rules.md` 无运行时版本相关章节（§2.5 是硬件资源，§2.8 是项目自有版本号 VERSION/CHANGELOG）；
- `docs/05-tech-spec.md` 声明层无"锁定版本"维度；`scripts/collect-env.ps1` 只采本机实际版本、不读锁文件。

即将派生的米家插件类项目要求 Node 16.13.0（SDK 约束），其他项目用默认最新版。若只给 Node 打补丁，未来 Python/Java 锁版本项目会零散重复，口径漂移。

本提案与已归档的 v1.6.0「运行环境资源约束」（硬件：CPU/内存/GPU）互补：v1.6.0 解决"机器跑得动吗"，本提案解决"用哪个运行时版本、怎么切换、CI 怎么校验"。

## 2. 目标

1. 建立跨语言的「声明层 + 工具层」分离机制：母模板标准化声明文件，不绑定具体工具（asdf 在 Windows 原生不支持，不能绑死）。
2. Node 作为首个实例走通（米家插件锁 16.13.0），未来 Python/Java 复用同一套。
3. 母模板保持中立：不锁具体版本、不预置声明文件、不脚本化安装版本管理器。
4. 预留领域模板预置接口（`TEMPLATE-BASE.md` `Domain standards scope` 字段），本轮不做领域模板。

## 3. 非目标

- 不规定具体运行时版本（母模板中立）。
- 不绑定具体版本管理器（Volta / pyenv / asdf 自选）。
- 不增强 `collect-env.ps1`（本机事实采集职责不变；本机 vs 声明对照由 tech-env-evaluation 承担）。
- 不新增同步件 `template-docs/runtime-version-locking.md`（内容并入 env-setup）。
- 不改 `sync-template.sh` / `.ps1` / `template-sync.json`（不新增同步件，3 处清单零改动）。
- 不在本轮做领域模板预置。

## 4. 拟改范围

### 新增

- `_proposals/TEMPLATE-UPGRADE-v1.55.0-runtime-version-locking.md`（本提案）

### 修改

| 文件 | 改动 |
|---|---|
| `ai/project-rules.md` | 新增 `## 2.9 运行时版本锁定`（§2.8 后、§3 前），开头点明与 §2.5 区分，7 字段仿 §2.7 |
| `ai/doc-standards/05-tech-spec.md` | §2 最低结构表「技术栈与版本」行扩充，纳入运行时版本锁定子维度 + 引用 §2.9 |
| `template-docs/docs-scaffold/05-tech-spec.md` | §1 撰写提要追加 + 新增 `### 1.1 运行时版本锁定（如启用）`子节 |
| `template-docs/env-setup.md` | 新增 `## 6. 运行时版本管理`（声明文件表 + Windows 工具推荐表 + asdf WSL 限制 + 中立性），原 §6–§10 顺延为 §7–§11 |
| `ai/global-rules.md` | §5 追加 §2.9 路由句（句式仿 §5 既有引用）；顶部版本号 v1.10→v1.11 |
| `ai/prompts/review/20-tech-env-evaluation.md` | L49 运行时版本维度扩充（声明锁定 vs 本机实际对照） |
| `scripts/check-template.sh` | 新增 18 条 `require_contains` 断言（不改 `.ps1`） |
| `VERSION` | v1.54.3 → v1.55.0 |
| `CHANGELOG.md` | 顶部新增 v1.55.0 条目 |

### 不改

`scripts/check-template.ps1`（fallback 显式收窄不镜像内容断言）、`scripts/collect-env.ps1`、`scripts/sync-template.sh` / `.ps1`、`template-sync.json`、`TEMPLATE-BASE.md`（派生项目根文件，本轮不预置）、`ai/document-lifecycle-rules.md` / `ai/implementation-lifecycle-rules.md`（不在生命周期链）、`scripts/new-project.sh`（opt-in 不强制）、scenario-guides / glossary / post-sync-cleanup（本轮不动的低优先级 add-on）。

## 5. 版本策略

**MINOR**。依据 `_proposals/README.md` minor 口径，命中三条触发：①scaffold 新增 §1.1 子节 = 文档骨架必填章节；②env-setup 新增整节 = 推荐工作流变化；③建立"声明层 + 工具层"分离的新方法论能力。直接先例：v1.6.0（§2.5）、v1.51.0（Web App Profile）、v1.53.0（§2.8 项目版本管理）均为结构平行的 MINOR。

## 6. 验证方式

- `bash scripts/check-template.sh`（17 条新断言全绿、无回归）
- `powershell -ExecutionPolicy Bypass -File scripts/check-template.ps1`（fallback 转发 bash）
- `powershell -ExecutionPolicy Bypass -File scripts/check-markdown-clean.ps1 _proposals`
- `git diff --check`
- 行为抽样：米家派生项目声明 Node 16.13.0 流程（project-rules §2.9 + 05-tech-spec §1.1 + 仓库根 `.node-version` + Volta 切换）

## 7. 影响面

- 所有派生项目获得统一的运行时版本锁定机制（opt-in，默认不启用）。
- 米家插件类项目作为首实例：锁 Node 16.13.0 + Volta + `.node-version`。
- 未来 Python / Java 锁版本项目复用同一套（05-tech-spec §1.1 + project-rules §2.9 + env-setup §6）。
- 领域模板未来可在 `TEMPLATE-BASE.md` `Domain standards scope` 预置领域默认锁定。
- 非锁版本项目（多数）不受影响（§2.9 填"不启用"、05 §1.1 填"不适用"）。

## 8. 待维护者确认项

无（4 个关键决策已在计划阶段确认：MINOR、不新增同步件、评估侧同步、global-rules bump v1.11）。
