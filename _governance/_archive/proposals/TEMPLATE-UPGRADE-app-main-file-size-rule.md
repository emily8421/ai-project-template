# TEMPLATE-UPGRADE: 主应用文件职责边界与业务下沉（吸收 issue #232）

> 来源：issue #232（LUMEN-DEMO 回流，from:LUMEN_demo_T2.1；去项目化提案）。
> 状态：处理中（随 feat/web-app-main-file-responsibility 落地）。
> 目标版本：v1.56.3
> Release impact：patch（Web App Structure Profile 文档增强；不新增能力层级 / 采用面，Profile 框架已存在）。
> Release strategy：单独发布。

## 1. 背景

issue #232（主应用文件膨胀约束：阈值 + 业务下沉 + 自检）提出主应用文件随业务膨胀的通用问题。triage（2026-07-22）发现 #232 §1 描述的「模板未给膨胀阈值数值」**已过时**：

- `template-docs/web-fullstack-profile.md` §5 已落地具体阈值（App 300 / 页面 250 / CSS 300 / service 250 / 测试 300 行）+ 软性治理语义；
- `ai/global-rules.md` §5（line 104）已引用 Web App Structure Profile + 文件膨胀阈值 + 触发条件 + 豁免口径。

故 #232 的阈值诉求已满足；本提案只补 **剩余增量**：主应用文件职责边界与业务下沉约束（#232 §3.2 / §3.3），从源头防膨胀。

## 2. 拟改

- `template-docs/web-fullstack-profile.md` §5 后新增 §5.1「主应用文件职责边界与业务下沉」：主文件只做组合 / 跨域 orchestration / cross-cutting / render；业务状态 / handler / 副作用下沉域 hook；state / handler ~10–15 软上限；业务 hook 不持有跨域 setter（经回调交回主文件）。

## 3. 非目标

- **不加脚本自检**：`check-template` 跑在模板仓，无法检查派生项目 `App.tsx`；保持 §5 既有的 AI / 人工软性治理提醒。
- 不改 `ai/global-rules.md` §5（已引用 Profile，无需改）。
- 不规定具体框架（React / Vue）或状态库（Redux / Zustand）；只约束「主文件膨胀 + 业务下沉」原则。
- 不调整 §6–§8 编号（避免破坏外部引用）；新内容作 §5.1。

## 4. 版本影响

patch：web-fullstack-profile 文档增强（同步清单内，下行同步派生）；不新增能力层级 / 采用面 / 同步结构，不够 minor。

## 5. 验证

- `check-markdown-clean.ps1` 预检。
- CI `template-check`（本次不新增自检断言）。
- 派生项目（LUMEN-DEMO 等）下次同步后，§5.1 作为主文件治理基线。

## 6. issue 闭环

PR 合并后在 #232 评论：阈值已落地（§5）+ 职责边界增量（§5.1）+ 版本 v1.56.3，关闭 #232。
