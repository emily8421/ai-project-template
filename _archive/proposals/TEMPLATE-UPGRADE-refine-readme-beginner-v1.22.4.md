# TEMPLATE-UPGRADE: README 通俗化 + beginner-guide 5 章精简（v1.22.4）

> 状态：草案（待维护者评审）
> 提案目标版本：v1.22.4
> 提出日期：2026-07-02
> 维护分支：`change/refine-readme-beginner-v1.22.4`

## 1. 动机

- **README 首句术语化**（文档驱动 / 规则分层 / 只增不改 / Sprint / 多入口），没说清模板能力与目的；用户看不出「能做什么 / 为什么用」。模板实际能力（按软件工程规范生成文档 + 文档约束 AI 代码 + 跨项目复用）缺一处集中说明。
- **beginner-guide 15 章**，v1.22.3 把操作章节（§3/§10/§11/§12/§15）精简为「指 scenario-guides」一句话后，这些章变空；§4「路径 A：推荐，AI CLI 引导模式」框架是 v1.22.0 前遗留，不直观（不如直接引导 scenario-guides）；§6 路由表与 §15 重叠。

## 2. 拟改

### 2.1 README 开头通俗化 + 能力段
- 重写首段：通俗说明「用 AI 按软件工程规范开发软件」+ 解决的问题（AI 代码难维护）+ 目的（过程文档 + 代码可审查）。
- 新增「它能做什么」能力段，6 条（基于模板实际能力梳理）：生成工程文档体系（多入口）/ 文档约束代码 + 六维度合规审查 / 分阶段交付（Demo→MVP→产品）/ 场景引导（23 场景剧本）/ 跨项目复用 + 经验回流 / 多 AI 工具 + 会话续接。

### 2.2 beginner-guide 15 章 → 5 章
- 合并 + 删空/冗余章：
  - §1 适合谁 + §2 正确预期 → **1. 适合谁 + 正确预期**
  - §4 起步（简化为直接引导 scenario-guides + 环境 keyword）→ **2. 怎么起步**
  - §5 准备 → **3. 开工前准备**
  - §7 + §8 + §9 目录理解合并 → **4. 文档与目录怎么理解**
  - §13 + §14 合并 → **5. 常见错误与常见问题**
- 删：§3（状态判断，并入 §2）、§6（路由表，与 §15 重叠）、§10/§11/§12（操作，v1.22.3 已指 scenario-guides，单章变空）、§15（后续入口，README 已是入口）。
- 保留所有环境 keyword（check-template 断言）：check-prereqs / env-setup / bootstrap / smoke-test / smoke-test-report-template / lemesh / 官方文档安装并登录 Claude CLI 或 Codex CLI / ai-cli-setup / newbie AI CLI onboarding path。

## 3. 非目标
- 不改 scenario-guides / SOP / 规则文件。
- 不动物理位置（仍按 v1.22.3 决定，物理重组另案不做）。

## 4. 影响
`README.md` / `template-docs/beginner-guide.md` / `VERSION` / `CHANGELOG.md`；提案归档。
