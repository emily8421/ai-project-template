# TEMPLATE-UPGRADE: 领域模板方法论独立文档（可选中间层）

> 来源：模板维护者
> 状态：进行中（本维护分支落地）
> 目标版本：v1.44.3
> Release impact：patch（AI 建议，待维护者确认）
> Release strategy：单独发布

## 1. 背景

领域模板（domain template）这一层是后期插入的：PR #155（`TEMPLATE-UPGRADE-domain-template-inheritance.md`，候选 / 待评估）、#156、#157（`scenario-guides.md` A20「领域模板派生」，v1.44.2 已发布）。

但它目前**只活在「场景引导 A20 + 候选提案」里，未进入方法论主线**：

- `template-docs/glossary.md` **零**三层术语（母模板 / 领域模板 / domain template / TEMPLATE-BASE 一个都没收录，§7 全是两层语义）。
- `template-docs/template-methodology.md` §5「模板治理与同步边界」是「模板 ↔ 派生项目」两层硬定义。
- 现有派生项目均为**两层直连**母模板。
- `TEMPLATE-BASE.md` 仅作为概念被提及，仓库内**不存在该文件**，`new-project.sh` 也不生成。
- inheritance 提案（三层设计源头）状态仍为**候选 / 待评估**，Batch 2-4（建仓、同步链路、自动化）未落地。

结论：领域模板作为「可选中间层」在方法论上**没有权威落点**，既无法被稳定引用，也容易让现有使用者产生「两层是否过时」的歧义。

## 2. 目标

1. 把「领域模板可选中间层」补进方法论，**独立成册**为单一权威源（`template-docs/domain-templates.md`），主线文件**只引用、不改两层叙述**。
2. 明确「两层是默认主路径、三层是可选增强」的定位，消除现有使用者的理解歧义。
3. 填补 glossary 术语真空（最小化：仅 1 个条目 + 指针）。
4. 给领域模板主题一个可被 `scenario-guides.md` A20、`template-methodology.md`、`glossary.md`、`README.md` 稳定引用的权威入口。

## 3. 非目标

- **不重写** `template-methodology.md` §5、`CONTRIBUTING.md` §2/§5/§6、`MAINTAINERS.md`、`git-guide.md` §5/§6、`global-rules.md` §9 的两层叙述（两层语义在三层模型下仍是「直接派生」特例，语义不变）。
- **不创建** `TEMPLATE-BASE.md` 产物，**不改** `new-project.sh` / `sync-template.sh` / `check-derived-sync.sh`。
- **不做** `--profile` 参数、多级同步自动化（属 inheritance 提案 Batch 2-4，未落地）。
- **不强制**所有项目经过领域模板；不要求现有派生项目迁移。
- 不把候选 / 未落地能力写成已启用。

## 4. 拟改

### 4.1 新建 `template-docs/domain-templates.md`（核心）

领域模板主题单一权威源（反双写，见 `document-lifecycle-rules.md §7`）。结构：

- 顶部 Sync notice + **定位声明**：可选增强层指引；领域模板层尚候选 / 演进中（Batch 2-4 未落地）；**主线治理仍为母模板 ↔ 派生项目两层**；现有派生项目无需迁移；非强制。
- §1 三层模型图：`母模板 → [可选 领域模板] → 项目`；两层默认主路径，三层可选增强。
- §2 何时该用领域模板（判定标准）：多同类项目 + 需自己的版本/scaffold/自检 + 共享一组领域标准件（如 agent 的 tool permission / memory / trace / eval）；否则直连母模板。
- §3 三层职责边界：引用 inheritance 提案 §4.1/4.2/4.3 结论，不复制正文。
- §4 同步 / 继承关系：领域模板双重身份（对母模板是下游、对项目是上游）；两级回流；明确当前 `sync-template.sh` / `check-derived-sync.sh` 仍按两端校验，多级同步自动化属 Batch 3 **未落地**。
- §5 TEMPLATE-BASE.md 约定：领域模板溯源文件；**标注当前为约定、产物未生成、`new-project.sh` 不生成、待 Batch 2**。
- §6 操作入口：创建领域模板的步骤见 `scenario-guides.md` A20（反向引用，不复制步骤）。
- §7 状态与演进：对应 inheritance 提案 Batch 1；Batch 2-4 待办；成熟后再提升主线地位。

### 4.2 引用指针（主线零内容改动，仅指针级）

1. `template-sync.json`：files 数组加 `"template-docs/domain-templates.md"`。
2. `template-docs/glossary.md` §7：新增 1 个条目「领域模板（domain template）」+ 指针。
3. `template-docs/template-methodology.md` §5 末：加 1 句指针（不重写两层叙述）。
4. `template-docs/scenario-guides.md` A20：加反向引用「方法论定位见 domain-templates.md」。
5. `README.md` 目录速览：`template-docs/` 行追加 `domain-templates`（标可选）。

### 4.3 自检断言（最轻，防文档滞后）

`scripts/check-template.sh`：仿现有 `:1283-1286` A20 断言风格，断言 `domain-templates.md` 存在 + 含稳定关键词（「可选中间层」「主线仍为两层」「母模板 → 领域模板」），防回退为强制三层或文案漂移。不加 TEMPLATE-BASE.md 产物断言、不加 glossary 多术语断言。

## 5. 版本影响判断

建议 **patch（v1.44.3）**。依据 `CONTRIBUTING.md` §4 兼容性默认规则：本次仅新增一个**可选指引文件**并纳入同步清单，**默认行为 / 同步清单结构 / 下游必做流程均不变**，现有派生项目零迁移。不满足 minor 门槛（无新增能力层级 / 下游采用面 / 同步结构 / 推荐流程变化的强制证据）。

## 6. 与 inheritance 提案的关系

本提案落地 inheritance 提案 **Batch 1（机制设计）的方法论文档化部分**：把三层模型、职责边界、同步继承关系固化为可引用的方法论文件。inheritance 提案的 Batch 2（建 `agent-system-template` 仓）/ Batch 3（领域模板自检与同步链路）/ Batch 4（profile / 自动化）仍为候选，由 `domain-templates.md` §7 显式列为待办，不阻塞本次发布。

## 7. 验证

`git diff --check` → `bash -n scripts/check-template.sh` → `bash scripts/check-template.sh`（含新断言全过）→ 人工核对主线文件仅指针级改动、未落地项无写成已启用 → CI `Template Check` 通过。

## 8. 待确认项

| ID | 待确认项 | AI 建议 | 建议依据 | 备选方案 | 取舍影响 / 阻塞关系 |
|---|---|---|---|---|---|
| C-001 | 版本影响 patch vs minor | patch（v1.44.3） | CONTRIBUTING §4 兼容性默认规则：新增可选指引、默认行为/同步结构/下游必做流程不变 | minor | minor 需强制迁移/默认行为变化证据，本案无 |
| C-002 | 是否顺手补归档 `TEMPLATE-UPGRADE-domain-template-derivation-scenario.md`（已合并 v1.44.2 但未归档） | 本次一并补归档到 `_archive/proposals/` | CONTRIBUTING §3 step 6 已处理提案应归档；影响面分析发现遗漏 | 单独处理 | 不阻塞，属清理项 |
