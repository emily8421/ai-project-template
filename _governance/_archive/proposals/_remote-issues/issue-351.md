# GitHub Issue #351: TEMPLATE-UPGRADE：按项目形态裁剪目录的执行落地（--shape + 执行步骤 + 审计项 + 根目录地图）

> Source URL: https://github.com/emily8421/ai-project-template/issues/351
> State: OPEN
> Labels: proposal from:web-ui-knowledge-base
> Author: emily8421
> Created: 2026-08-16T16:01:58Z
> Updated: 2026-08-16T16:01:58Z
> Mirrored at: 2026-08-17
> Mirror status: raw remote issue copy for local triage; GitHub issue remains source of comments and closure state.

## Raw Issue Body

# TEMPLATE-UPGRADE：按项目形态裁剪目录的执行落地（--shape + 执行步骤 + 审计项 + 根目录地图）

> 来源：web-ui-knowledge-base（emily8421/web-ui-knowledge-base）派生项目回流

## 1. 动机

模板已有完整的"按项目形态裁剪"规则（`ai/global-rules.md` §5、`ai/doc-standards/project-rules.md` §4 §3、`docs/README.md` 裁剪表），但规则只声明了"应裁剪什么"，没有规定**谁在哪个时点执行、执行后如何检查**。实证案例：一个纯文档型派生项目（知识库仓，零运行时）在初始化 4 个提交后：

- `frontend/` / `backend/` / `tests/` / `docker/` 四个目录仍存在，各仅含 `.gitkeep` + README（8 个占位文件）；
- `docs/06-db-design.md` / `docs/07-api-spec.md` 仍是未填写的模板骨架，而 `ai/project-rules.md` §3 已明确声明两者省略、四目录不启用——**声明与目录结构矛盾持续存在**，doc-standards 自己写着"初始化时应删除本文并在 §3 留下省略原因"，但无执行点；
- 根目录 15 个子目录中，"模板方法论（同步覆盖）/ 模板治理（本地记录）/ 项目产出（项目自有）"三层归属信息分散在 `template-sync.json`（机器可读、人不读）、`ai/project-rules.md` §4（只写特例）、README（无此内容），新用户无法一眼分辨哪些目录可直接写、哪些会被同步覆盖。

根因在 `scripts/new-project.sh`：整仓 `git archive` / `clone` 复制模板（含全部占位目录与骨架文档），裁剪只靠生成 README 里一句"不用的目录后续再删除"——无执行点、无检查项，事实上永远不删。

### 1.1 与既有规则的关系（去重）

| 既有规则 | 关系 |
|---|---|
| `ai/doc-standards/project-rules.md` §4 §3（形态裁剪字段与推导规则） | **互补不重复**：既有规则定义"裁剪什么"（决策字段），本提案补"何时执行、如何检查"（执行机制），不改任何裁剪推导规则。 |
| `ai/global-rules.md` §5（通用目录标准"按项目技术栈与演示形态创建，不必全有"） | **指向**：§5 已允许目录不齐，本提案是该允许项在初始化与审计两个时点的落地。 |
| `docs/README.md` 裁剪规则表 | **对象不同**：该表是生成文档体系时的裁剪对照，本提案把其中"删除并声明省略"从建议升级为带执行点的步骤。 |
| `scripts/new-project.sh` 现有 `--no-examples` 参数 | **机制相同、对象不同**：`--no-examples` 删参考材料，本提案新增的 `--shape` 按 §3 形态字段裁剪代码目录与 06/07。 |
| `ai/commands/post-sync-cleanup.md`（同步后审计） | **合并入**：审计项新增一条进该命令既有清单，不另建命令。 |
| `template-docs/beginner-guide.md` | **合并入**：根目录地图表追加进该指南的目录说明部分。 |
| `template-docs/capability-packages.md` §8（目录调整门槛：需 1-2 个真实案例） | **指向**：本提案即第一个真实专项使用案例（纯文档仓裁剪未执行），满足其启动条件；但不做该节意义上的"目录重组"，只做删占位与说明补充。 |

## 2. 拟改

四项独立可分阶段落地，按优先级排序：

### 2.1 `new-project.sh` 新增 `--shape <形态>` 可选参数（P2，形态已知时的一步到位路径）

- 形态取值与 `ai/doc-standards/project-rules.md` §4 §3 的裁剪推导对齐，至少支持：`docs`（纯文档仓：删 `frontend/ backend/ tests/ docker/` + `docs/06` `docs/07`）、`cli`（CLI / 本地脚本：删 `frontend/ docker/`，保留 `docs/07` 用于命令契约）、`web`（缺省，等价现状不裁剪）。
- 形态在 init 时未定是常态，故 `--shape` **默认缺省不裁剪**，走 2.2 保底路径；两路径产物语义一致（`--shape docs` ≡ 事后执行裁剪步骤）。
- 使用 `--shape` 时在生成 README 的"当前阶段"区块注明已按形态裁剪及依据，避免后续文档生成时再纠结 06/07。

### 2.2 §3 裁剪决策的显式执行步骤（P1，保底路径，形态后定时）

- 在 `ai/doc-standards/project-rules.md` §4 §3（或 `ai/document-lifecycle-rules.md` 对应入口流程）明确：`ai/project-rules.md` §3 裁剪决策**人工确认后、生成 docs/03-09 前**，存在一个显式执行动作——按决策删除不启用的代码目录与省略的 06/07 骨架，并把执行事实回填 `ai/project-rules.md` §4（何时删了什么）。
- 生成 README 的 checklist 对应行从"不用的目录后续再删除"改为指向该步骤的明确时点（后续 → 生成 docs 前确认 §3 时）。

### 2.3 `post-sync-cleanup` 新增审计项（P1，防回潮）

- `ai/commands/post-sync-cleanup.md` 与 `ai/prompts/maintainers/15-post-sync-cleanup.md` 的审计清单各加一条：**"§3 声明不启用 / 省略，但目录或骨架文档仍存在"**（列具体路径），发现即提示执行裁剪。
- 该审计同样适用于普通项目自查，不限于同步后。

### 2.4 `beginner-guide.md` 增加根目录三层地图（P1，可读性）

在目录说明部分补一张通用表格：

| 层 | 典型目录 / 文件 | 同步时 | 派生项目怎么用 |
|---|---|---|---|
| 模板方法论 | `ai/`（除 project-rules / domain-rules）、`template-docs/`、`scripts/`、`template-sync.json` | 覆盖 | 不直接改；改进走 `_proposals/` 回流 |
| 模板治理（本地记录） | `sync-records/`、`ai-records/`、`_proposals/`、`.ai/` | 不覆盖 | 按各自 README 记录 |
| 项目产出 | `docs/`、`knowledge/` 或其他业务目录、代码目录、`ai/project-rules.md`、README | 不覆盖 | 项目自有，直接写 |

注：表是导航说明不是新规则；各目录同步属性的唯一机器事实源仍是 `template-sync.json`。

## 3. 版本影响

- 模板版本：MINOR（新增可选脚本参数 + 规则步骤 + 审计项 + 说明表；不破坏既有派生项目——缺省行为不变）。
- 同步清单：`new-project.sh`、`ai/doc-standards/project-rules.md`、`ai/commands/post-sync-cleanup.md`、`ai/prompts/maintainers/15-post-sync-cleanup.md`、`template-docs/beginner-guide.md` 均已在 `template-sync.json` 内，无清单变更。
- 自检影响：`scripts/check-template.*` 若有对 `--shape` 使用说明的引用需同步断言（建议不新增断言，维持 rd-data-chain §4"无自检门禁、避免过度治理"口径）。

## 4. 影响面

- **模板仓**：`scripts/new-project.sh`（新增参数与裁剪逻辑）、`ai/doc-standards/project-rules.md`、`ai/commands/post-sync-cleanup.md`、`ai/prompts/maintainers/15-post-sync-cleanup.md`、`template-docs/beginner-guide.md`、`CHANGELOG.md` / `CHANGELOG-PLAIN.md` / `VERSION`。
- **既有派生项目**：无强制影响；下次同步后可获得新审计项，据此自行补执行裁剪。
- **新派生项目**：形态已知时 init 即得干净根目录；形态未定时不劣于现状。
- **风险**：`--shape` 删目录属于破坏性动作，须在脚本输出中明示删了什么；误删可通过 git 历史恢复（init 后首提交含全量）。`--shape cli` 对 06/07 的取舍（CLI 保留 07）已按 doc-standards 既有推导，无新语义。

## 5. 验证方式

- `--shape` 各取值在 `--no-remote --local` 模式下烟测：目录 / 骨架删除符合预期，`--shape web` 与现状 diff 为空。
- 2.2 执行步骤写进 doc-standards 后，`scripts/check-template.*` 通过（含章节编号连续性 advisory）。
- 2.3 审计项用一个"声明省略但 06 仍存在"的故意样本验证能命中。
- 回流后下行同步到实证案例项目，跑 `post-sync-cleanup` 确认无告警（该仓已完成手工裁剪）。

## 6. 状态

- 起草于派生项目实证（纯文档型知识库仓，v0.1.1 手工完成同等裁剪）；待提交模板仓 `_proposals/` 收件箱。
