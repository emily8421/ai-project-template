# GitHub Issue #464: TEMPLATE-UPGRADE：CI paths 过滤必须覆盖产物的全部输入目录

> Source URL: https://github.com/emily8421/ai-project-template/issues/464
> State: OPEN
> Labels: proposal, from:LUMEN_demo_T2.1
> Author: emily8421
> Created: 2026-09-14T07:59:48Z
> Updated: 2026-09-14T07:59:48Z
> Mirrored at: 2026-09-16
> Mirror status: raw remote issue copy for local triage; GitHub issue remains source of comments and closure state.

## Raw Issue Body

> 来源：LUMEN-DEMO（emily8421/LUMEN-DEMO）派生项目回流

# TEMPLATE-UPGRADE：CI paths 过滤必须覆盖产物的全部输入目录

## 1. 动机

打包型 CI workflow 的 `paths` 触发过滤通常只枚举「产物主目录」，而实际产物往往由**多个目录的输入共同构建**。当输入目录之一变更而 paths 未覆盖时，workflow 静默不触发，构建产物与代码悄悄脱节——无报错、无告警，只能靠人工发现「装包后行为没变」才暴露。

派生项目实证（1 份，通用面清晰）：某桌面壳项目安装包由壳源码 + 内置设置页（前端源码构建产物）+ 依赖锁文件等多目录输入打包；CI `paths` 只声明了壳目录，改内置页面源码后 NSIS 包不自动重出，artifact 与代码脱节。在 paths 补齐全部输入目录后同 PR 实测触发恢复。证据链完整（现象 → 根因 → 修复 → 实测），归类为 CI 配置缺口：**paths 过滤只看「改动发生的目录」，未看「产物的全部输入目录」**。

## 1.1 与既有规则的关系（去重）

- 与 remote-ci-sop-profile（PR / CI 收口操作流程）：**对象不同**——SOP 管 checks 查看 / 轮询 / 失败定位等操作侧流程，本条管 workflow 触发条件（paths 配置面）的完整性检查点；互补不重复。
- 与 web-fullstack-profile §9（质量门口径 / 工程化护栏）：**层级不同**——该节管「哪些自动检查作为门」，本条管「改动是否触发含产物的 workflow」，属触发面而非质量门。
- 与既有 workflow 样板（如有打包 / 发布类模板）：**机制不同**——样板给触发语法，本条给「从产物反向枚举输入目录」的编写检查点，可作样板注释或 SOP 条目，由维护者 triage 定落点。

## 2. 拟改

候选落点（维护者 triage 择一或合并）：

1. **remote-ci-sop-profile 增一条检查点**：编写 / 修改打包型 workflow 的 `paths` 时，从 CI 产物反向枚举全部输入目录（主源码 + 内置页面 / 资源 + 依赖锁文件 + 构建配置），逐项声明进 paths；新增产物输入目录的改动必须同步检查相关 workflow paths。
2. **打包类 workflow 样板注释**（如模板含该类样板）：在 paths 段注释「从产物反向枚举输入目录」提示。

一句话判据：**「CI 产物 = 多目录输入打包」场景，paths 必须覆盖全部输入目录；新增输入目录的 PR 必须自查 paths。**

## 3. 版本影响

PATCH（规则 / 文档条目增补，不改既有语义）。

## 4. 影响面

- 模板维护的 CI / SOP 类文档或样板（落点 1-2 处）。
- 派生项目下行同步后获得该检查点；不引入新 CI 门、不改变既有 workflow 行为。
- 无脚本 / 自检改动（检查点属人工编写时点约定，同「无自检门禁、避免过度治理」口径）。

## 5. 验证方式

- 文档层：条目落入指定文档且被 INDEX / 相关章节引用可达。
- 实证层：派生项目已提供 1 份完整证据链（paths 缺口 → artifact 脱节 → 补齐后同 PR 实测触发）；模板侧无需新建复现环境。
