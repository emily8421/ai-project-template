# TEMPLATE-UPGRADE: Scenario Guide 场景体系整理

> 来源：模板维护者。
> 类型：模板仓库内直接发起的模板优化提案。
> 状态：落地中；当前分支 `change/scenario-guide-clarity` 正在整理 M0 HELP、A9-A12、C5/C6/C7、dev prompt 与 beginner guide。
> 覆盖问题：维护者 C2/C5/C6/C7 不清晰；缺少 HELP / 能力索引；A7 未覆盖 AI 治理示例。

## 1. 背景与问题

`template-docs/scenario-guides.md` 是场景编排层，用于把命令、prompt、脚本和文档串成端到端引导计划。当前 A 使用者场景较完整，但存在以下可理解性问题：

- C2（版本 bump 与发布）标记为待补，缺少专门 command，用户不清楚何时使用。
- C5（维护下行同步机制）表达过宽，缺少具体例子和不适用场景。
- C6（派生同步验收）与 C 区“cwd 均在模板仓库”的前置说明冲突，因为 C6 实际需要在派生项目运行 `check-derived-sync`。
- C7（设计 / 新增模板能力）过宽泛，缺少“提案 → 影响面 → 同步清单 → 自检断言 → PR → 发布”的结构化流程。
- A7 只覆盖 PLM 文档转换，没有体现 AI 治理类横切用法。
- M1 覆盖“用户有具体场景意图”，但没有明确覆盖 `HELP` / “你能做什么” / “怎么用模板”这类能力索引入口。

## 2. 设计目标

- 让维护者场景可读、可选、可执行。
- 修正 C6 的 cwd / 角色混淆。
- 给用户一个明确 HELP 入口，先识别角色，再展示对应场景索引。
- 将 AI 治理作为横切场景或示例，而不是塞入 PLM 文档转换。
- 保持 `scenario-guides` 作为编排层，不复制大段 prompt 正文。

## 3. 建议方案

### 3.1 新增 M0 HELP / 能力索引 / 角色选择

建议新增元场景：

```text
M0 帮助 / 能力索引 / 角色选择
```

触发：

- `help`
- `帮助`
- `你能做什么`
- `怎么用这个模板`
- `列出场景`

执行步骤：

1. 判断 cwd 状态：零资产 / 模板仓库 / 派生项目。
2. 识别或询问用户角色：使用者 / 维护者 / 两者都是 / 不确定。
3. 输出对应场景索引：A 场景、C 场景或两者。
4. 推荐 2-3 个下一步高频入口。
5. 若用户选择某个场景，再交给 M1 输出分步引导计划。

### 3.2 整理 C2 / C5 / C6 / C7

#### C2 版本 bump 与发布

补清楚：

- 何时用：模板改动 PR 合并后，需要发布新版本。
- 不适用：派生项目业务发版。
- 输入：已合并 PR、版本影响判断、`CHANGELOG.md`、`VERSION`。
- 输出：版本号、changelog、tag、release、自检结果。

可考虑新增 command / prompt：

```text
ai/prompts/maintainers/20-release-template-version.md
```

#### C5 维护下行同步机制

补例子：

- 新增同步文件到 `template-sync.json`。
- 修改 `scripts/sync-template.*`。
- 修改 `scripts/check-derived-sync.*`。
- 调整 doc-standards 镜像规则。
- 改同步运行记录路径。

补不适用：

- 派生项目执行同步应走 A13。
- 派生项目同步结果验收应走 A13 / C6（视重构结果）。

#### C6 派生同步验收

建议二选一：

- 方案 A：移入 A13，作为派生项目同步后的验收步骤。
- 方案 B：保留 C6，但标成跨仓场景，明确 cwd 从模板仓切到派生项目，并要求列出目标派生仓库。

推荐方案 A：把 C6 的核心内容并入 A13，C 区只保留维护者如何批量审阅派生同步反馈。

#### C7 新增模板能力

建议改为“模板能力设计流程”：

1. 写去项目化提案。
2. 做影响面分析：规则、prompt、command、scenario、scripts、sync 清单、check-template、docs 骨架。
3. 设计落地计划。
4. 新增 / 修改模板文件。
5. 补同步清单与自检断言。
6. 走 C4 PR。
7. 走 C2 发布。

### 3.3 增加 AI 治理横切场景

建议新增或在 M0 中给出示例：

```text
G1 AI 治理 / 规则与审计
```

覆盖：

- `ai/project-rules.md`：项目专属边界、技术栈、禁区、确认规则。
- `ai/session-rules.md`：会话续接与断点恢复。
- `ai/document-lifecycle-rules.md`：文档链路治理。
- `project-review`：实现合规审查。
- `docs-system-audit`：文档体系审计。
- `submit-proposal` / `submit-feedback`：通用问题回流模板。

该场景不替代 A7；A7 仍专注 PLM 文档转换。

## 4. 拟改范围

- 修改：`template-docs/scenario-guides.md`
- 修改：`ai/commands/scenario.md`
- 可选新增：`ai/commands/help.md`
- 可选新增：`ai/prompts/maintainers/20-release-template-version.md`
- 可选新增：`ai/prompts/maintainers/21-design-template-capability.md`
- 修改：`SOP.md`
- 修改：`README.md` / `template-docs/beginner-guide.md` 的场景入口说明
- 修改：`template-sync.json`
- 修改：`scripts/check-template.sh`，增加新场景 / command 路由断言

## 5. 版本影响

建议作为 minor 版本落地。

理由：新增 HELP 入口与维护者场景重构，提升模板交互方式和治理可理解性。

## 6. 验收口径

- 用户输入 `help` / “你能做什么” 时，AI 能输出角色选择和场景索引。
- M0 与 M1 分工清晰：M0 负责能力索引，M1 负责具体场景引导计划。
- C2/C5/C7 均说明何时用、不适用场景、输入、输出、下一步。
- C6 不再与 C 区 cwd 规则冲突。
- A7 仍聚焦 PLM 转换；AI 治理有独立横切说明或场景。

## 7. 风险与缓解

- **场景数量继续膨胀**：HELP 入口只索引，不复制所有步骤；详细流程仍留在场景条目和 prompt。
- **C 场景与 A 场景边界模糊**：按 cwd 和角色重新标注，派生项目执行类优先归 A，模板仓维护类归 C。
- **AI 治理概念过宽**：先作为横切索引，不急于拆成多个命令。
