# TEMPLATE-UPGRADE: 文档整理（v1.22.3）

> 状态：草案（待维护者评审）
> 提案目标版本：v1.22.3
> 提出日期：2026-07-01
> 维护分支：`change/cleanup-docs-v1.22.3`
> 主题：v1.22.0–2 入口简化后的连带文档整理——操作内容让位 scenario-guides、去重、修陈旧引用、补目录速览

## 1. 动机

v1.22.0 引入 scenario-guides、v1.22.1 README 瘦身、v1.22.2 INIT-PROMPT 指针化后，多份文档出现：
- **操作内容冗余**：SOP 场景索引、beginner-guide 起步/生成/执行章节与 scenario-guides 场景剧本重叠。
- **陈旧引用**（文档自相矛盾）：MAINTAINERS 提「5 分钟路径」、CONTRIBUTING 提「README 方法论同步 section」——README v1.22.1 已删。
- **去重**：CONTRIBUTING §3.1 与 MAINTAINERS「提案组织建议」几乎逐字重复。
- **目录速览缺失**：README 目录速览漏 `_archive/ tasks/ 骨架目录 ai/prompts/ .github/`。
- **git-guide §7** 与 SOP 常用命令重叠，缺交叉引用。

## 2. 拟改（6 项）

### 2.1 SOP 精简
- 场景索引改为「指向 scenario-guides 场景目录」（不再重复场景→命令映射）。
- 保留：常用命令矩阵 + 常见选择 + 使用原则。
- 顶部明确：「场景剧本见 scenario-guides，本文件只做命令速查与快决策」。

### 2.2 CONTRIBUTING / MAINTAINERS 去重 + 修陈旧 + 历史归档
- 去重：「提案组织建议」归 CONTRIBUTING §3.1，MAINTAINERS 改一句引用。
- 修陈旧：MAINTAINERS「5 分钟路径」→「快速开始」；CONTRIBUTING §5「README 方法论同步 section」→「SOP 常用命令 / git-guide §5」；INIT-PROMPT 措辞（已指针化）。
- §8 历史：CONTRIBUTING v1.6.5 前治理 changelog 归档到 `_archive/` 或删（CHANGELOG 是权威）。
- 定位明确：CONTRIBUTING=治理流程规则，MAINTAINERS=维护操作 checklist+细则。

### 2.3 beginner-guide 精简为「理解手册」
- 保留 + 强化：§2 正确预期、§5 开工前准备（什么而非怎么）、§7–§9 目录心智模型、§13–§14 常见错误/问题。
- 精简操作（指 scenario-guides）：§4 起步、§10 生成文档、§11 执行任务、§12 用命令、§3 状态判断、§6/§15 路由。
- 保留环境 keyword（check-template 断言）：并入 §5 或 §4 极简版。

### 2.4 README 目录速览补缺失
- 补：`_archive/`、`tasks/`、骨架目录（`frontend/ backend/ tests/ docker/`，按形态裁剪）、`ai/prompts/`、`.github/`。

### 2.5 git-guide 小幅整理
- §7 命令速查加交叉引用：「脚本命令（check-prereqs/sync-template.ps1 等）见 SOP 常用命令」。
- 不重构（操作 SOP 权威，定位清晰）。

### 2.6 check-template + VERSION
- 断言配套调整（SOP/beginner-guide/CONTRIBUTING/MAINTAINERS 改动连带）。
- VERSION → v1.22.3 + CHANGELOG。

## 3. 非目标

- 不移动物理位置（SOP/git-guide 留根目录，scenario-guides 留 template-docs/）——物理重组另案。
- 不改 scenario-guides（v1.22.0 定稿）。
- 不改规则文件（global-rules/lifecycle/session/project-rules）核心约束。

## 4. 影响

`SOP.md` / `CONTRIBUTING.md` / `MAINTAINERS.md` / `template-docs/beginner-guide.md` / `README.md` / `git-guide.md` / `scripts/check-template.sh` / `VERSION` / `CHANGELOG.md`；提案归档。
