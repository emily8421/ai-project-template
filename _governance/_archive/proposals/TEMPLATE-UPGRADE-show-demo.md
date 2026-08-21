# TEMPLATE-UPGRADE: show-demo 命令与演示 SOP 模板

> 来源：GitHub issue #160（zhiyan-digital-cs-platform 派生项目回流）；镜像 `_proposals/_remote-issues/issue-160.md`
> 状态：进行中（本维护分支落地）
> 目标版本：v1.45.0
> Release impact：minor
> Release strategy：单独发布

## 1. 背景与来源

issue #160 反馈：派生项目有可运行 Demo / MVP 后，用户常说「查看演示效果 / 启动 Demo / 给我二维码 / 检查 Demo 是否起来」，但模板无统一入口和项目级演示 SOP。结果：README 只有零散启动命令、AI 每次重新猜端口 / 脚本、运行产物（二维码等）易误提交、Demo 效果易被误读为生产能力。

zhiyan 当前在 feature 分支 `docs/local-demo-runbook-qr-startup` 做这件事 = 真实需求驱动。详见 `issue-160.md`。

## 2. 目标

新增 `show-demo` 命令 + `demo-runbook-template`，约定项目级演示 SOP 默认路径 `docs/env/local-demo-runbook.md`。模板只规定结构与方法，不规定端口 / 脚本 / 技术栈；无可运行交付物的项目不强制生成。

## 3. 非目标

- 不规定具体端口 / 脚本 / 二维码实现 / 技术栈 / 演示内容。
- 不强制所有项目生成演示 SOP。
- 不把演示检查替代 `docs/09-verification.md` 正式验收。
- 不动 `scenario-guides.md`（show-demo 作为命令级入口，commands README 触发词足够路由）。
- 不改模板 `.gitignore`（运行产物因项目而异，由 demo-runbook-template 提醒项目自行忽略）。

## 4. 采纳的待确认项（issue #160 §6）

| ID | 决策 |
|---|---|
| DEMO-C-001 | 命令名 `show-demo`；文档 / 模板名 `demo-runbook` |
| DEMO-C-002 | 新增独立 `ai/commands/show-demo.md`（轻量路由） |
| DEMO-C-003 | 默认路径 `docs/env/local-demo-runbook.md`，允许项目按入口命名覆盖 |

## 5. 拟改

### 新增
- `ai/commands/show-demo.md`（仿 collect-env 格式 + AI 执行边界表 + 禁止项）
- `template-docs/demo-runbook-template.md`（八节结构：适用范围 / AI 场景 / 启动前提 / 启动方式 / 访问入口 / 检查验证 / 推荐演示路径 / 安全与边界）

### 引用指针（主线最小改动）
- `ai/commands/README.md`：命令表 + 使用方式触发词加 show-demo / "查看演示效果"
- `docs/README.md` §5：`docs/env/` 命名建议加 `local-demo-runbook.md`
- `ai/document-lifecycle-rules.md` §5.4 附近：加 `docs/env/*demo-runbook*.md` 定位（不替代 09）

### 同步与自检
- `template-sync.json`：加 `ai/commands/show-demo.md` + `template-docs/demo-runbook-template.md`
- `scripts/check-template.sh`：断言两新文件存在 + commands/README 含 show-demo + docs/README 含 local-demo-runbook + document-lifecycle 含 demo-runbook + sync 清单含两新文件

### 版本
- `VERSION` v1.44.3 → v1.45.0；`CHANGELOG` 加条目

## 6. 版本影响判断

**minor（v1.45.0）**。新增命令入口（show-demo）+ 新模板（demo-runbook-template）+ 推荐工作流变化（"查看演示效果"成为一等入口），符合 CONTRIBUTING §4 minor 门槛（新增能力层级 / 下游采用面 / 推荐流程变化）。派生项目同步后会获得新命令和模板。

## 7. 验证

`git diff --check` → `bash -n scripts/check-template.sh` → `bash scripts/check-template.sh`（含新断言全过）→ 人工核对执行边界表 / 八节结构 / "不替代 09" → CI `Template Check`。

## 8. 待确认项

issue #160 的 3 个待确认项已采纳推荐（§4），本轮无新增。
