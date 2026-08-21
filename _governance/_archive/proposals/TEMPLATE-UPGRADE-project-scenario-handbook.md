# 提案：派生项目特有场景手册指引（project-specific scenario handbook）

> 来源：web-ui-knowledge-base（emily8421/web-ui-knowledge-base）派生项目回流
> 状态：候选
> 目标版本：待确认
> Release impact：patch（AI 建议，待维护者确认）
> Release strategy：单独发布 / 同主题聚合

## 1. 动机（去项目化）

派生项目在运营中会积累出母模板场景目录（A0–A28 / C1–C8）不覆盖的**项目特有操作剧本**（如知识库项目特有的「收集一个设计参考」「上游语料同步」）。当前指引只说了不写哪：

- `template-docs/scenario-guides.md` §8：「项目专属场景不写 here，写项目自己的 `docs/` 或 `ai/project-rules.md`」。

但**没说写哪、什么格式、怎么防同步覆盖、编号怎么隔离**。第一个遇到此需求的项目（web-ui-knowledge-base，2026-08-16）自行做了四个判断：

1. 手册放**项目自有目录**（不在 `template-sync.json` 清单内），避免同步覆盖；
2. **编号空间与母模板 A/C/M 隔离**（该项目用 K 前缀），避免未来同步对齐冲突；
3. **条目格式沿用母模板三层步骤表结构**（说明 / 触发 / cwd·前置 / 做什么 / 为什么 / 机器执行 / 完成判据 / 下一步 / cmd 指针），保证 AI 消费方式一致；
4. 在 `ai/project-rules.md` §4 目录特例登记该手册位置。

这四个判断每个派生项目都会重新踩一遍（尤其「scenario-guides 在同步清单内会被覆盖」这个坑）。提案把它提炼为**轻量指引**，不做重机制（不建新模板文件、不加强制检查）。

## 1.1 与既有规则的关系（去重）

- **scenario-guides §8 维护说明**（`template-docs/scenario-guides.md`，active）：管「母模板场景编排层自身的维护」。**指向**——本提案不新建机制，只在 §8 补「项目特有场景写哪 / 格式 / 编号」三件事，把该节从「只说禁止」补成「给出去处」。
- **domain-derived-scenarios-template.md**（`template-docs/`，active）：L2 领域模板专用的 L2→L3 剧本模板。**对象不同**——那是领域模板层（L2）给领域派生项目（L3）的剧本；本提案管**普通派生项目自己积累**的项目特有场景（L3 自有），层级与用途都不同。
- **ai/project-rules.md §4 目录特例**（种子实例字段，active）：管项目自有目录结构声明。**互补不重复**——本提案指引场景手册的选址原则（自有目录 / 同步清单外），登记动作仍走 §4 既有字段。
- **capability-packages.md MECH-SCEN-001 场景引导机制**（`template-docs/`，active）：管场景引导机制本身的负责人与产出。**层级不同**——机制注册管「能力是什么」，本提案管「项目超出该能力边界时内容写哪」。
- **knowledge 记录机制（MECH-KNOW-001）**：无关——本提案不是知识治理，是场景编排层的项目侧延伸指引。

**本提案不重复它们**：现有文件只覆盖「母模板场景」与「领域模板剧本」两类，普通派生项目的自有场景**选址 / 格式 / 编号隔离**是空白。差异化：本提案是三句话级别的轻量指引，落在 §8 一处 + new-project 引导一句，不建新文件、不加自检断言。

## 2. 拟改

**改动 1**：`template-docs/scenario-guides.md` §8 第三条，从：

> 派生项目同步模板后获得本文件；项目专属场景不写 here，写项目自己的 `docs/` 或 `ai/project-rules.md`。

改为：

> 派生项目同步模板后获得本文件；项目专属场景不写 here（本文件在同步清单内，会被覆盖）。项目积累出本目录未覆盖的特有操作剧本时，在**同步清单外的项目自有目录**建立项目特有场景手册（如 `docs/` 子目录或项目自管目录），并在 `ai/project-rules.md` §4 登记其位置；编号空间与 A/C/M 隔离（自选前缀），条目格式沿用本文件三层步骤表结构，便于 AI 以相同方式消费。首个实例：web-ui-knowledge-base 的 `knowledge/scenarios.md`（K1–K3）。

**改动 2**：`ai/prompts/setup/14-new-project.md` 步骤 9「下一步待办」追加一条：

> 项目运营中积累出模板场景未覆盖的专属操作剧本时，在同步清单外建项目特有场景手册（见 scenario-guides §8），不写母模板 scenario-guides。

（`ai/commands/new-project.md` 不改——命令文件只列必读与流程，指引细节在 prompt。）

## 3. 版本影响

- Release impact：**patch**——纯指引补充，不改同步结构、不加新文件、不改默认行为、不要求下游迁移；已同步项目下次同步自动获得。
- 不入 `template-sync.json` 变更（两文件均已在清单内）。

## 4. 影响面

| 文件 | 变更 |
|---|---|
| `template-docs/scenario-guides.md` §8 | 1 条改写（约 3 行 → 5 行） |
| `ai/prompts/setup/14-new-project.md` 步骤 9 | 追加 1 条待办 |

影响范围：维护者（§8 维护口径）、新派生项目（知晓去处）。无脚本 / 自检 / 同步机制变更。

## 5. 验证方式

- `bash scripts/check-template.sh` / `powershell scripts/check-template.ps1` 全量通过（无新增断言，既有断言不受影响）。
- `check-markdown-clean.ps1` 对两改动文件通过。
- 人工核对：改动 1 与 §2.1 三层路径矩阵（领域剧本）表述无冲突；改动 2 与 14-new-project 既有「禁止事项」风格一致。

## 6. 落地流程

切维护分支 → 修改两文件 → check-template → commit → PR → CI 绿 → 合并 → 版本 PATCH 递增 → 归档本提案到 `_archive/proposals/`。可与同期其他 patch 提案聚合发布。
