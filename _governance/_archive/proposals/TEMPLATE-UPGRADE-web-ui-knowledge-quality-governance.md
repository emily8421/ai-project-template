# TEMPLATE-UPGRADE：Web UI 知识 Batch 2A——来源链接核验与质量基线（质量治理）

> 来源：模板维护者（Web UI 知识 Batch 2 质量治理启动评估，2026-08-14）
> 状态：已处理（本 PR 内与落地一并归档）
> 目标版本：v1.62.1（PATCH）
> Release impact：patch（已确认）
> Release strategy：单独发布

## 1. 动机（去项目化）

v1.62.0 建立的 `template-docs/ui-knowledge/` 核心层存在三个质量基线缺口：

1. **来源链接未核验**：6 条 `SRC-*` 来源记录只有 URL，无可追溯的链接 / 发布方 / 许可口径核验记录；12 条模式已标 `reviewed`，但「reviewed 的证据口径」不可追溯。
2. **链接失效无状态字段**：记录字段没有「链接核验状态」，来源失效时只能改生命周期状态，混淆「内容评审」与「链接可用性」两件事。
3. **自检不覆盖知识结构**：`check-template.sh` 对 ui-knowledge 只查文件存在性与少量关键词，不查 `SRC-*` / `PAT-*` 编号唯一性、`PAT-* -> SRC-*` 引用登记、来源链接核验状态字段。

**Batch 2A 范围（质量基线）**：只做来源 / 许可 / 链接核验元数据、reviewed 状态证据澄清、不绑定长文案的结构校验。core 晋升、证据升级 / 降级、重复模式合并、模式扩充与外部语料层仍留在 Batch 2 后续，等 v1.62.0 在 ≥2 派生项目实际使用后再推进。

## 1.1 与既有规则的关系（去重）

- **`TEMPLATE-UPGRADE-web-ui-design-knowledge-base.md`**（`_archive/proposals/`，已归档 v1.62.0）：**指向**——Batch 1 建 schema 与首批内容，明确把「链接失效检查 / 证据升降级」留给 Batch 2；本提案是 Batch 2 中不依赖使用数据、可独立早做的质量基线子集（Batch 2A）。
- **`template-docs/ui-knowledge/README.md` §7 §8 §9**（现行）：**互补不重复**——§7 §8 已有版权落盘与许可状态机，本提案在其上补「链接核验状态」独立字段与「唯一依赖暂时不可用来源的模式不得保持 reviewed / core」规则，并把核验事实落进 `source-registry.md`。
- **`check-template.sh` ui-knowledge 断言（v1.62.0）**：**对象不同**——现有断言查文件存在性与同步清单一致性；本提案新增的结构校验查记录间引用完整性（编号唯一 / 引用登记 / 字段在场），属新增维度，不重复。
- **`ai/session-rules.md` §4.x pitfall / hotspot 观察机制**：**机制不同**——观察机制记过程坑，本提案是模板内容与自检的结构性质量基线。

**本提案不重复它们**：补的是「来源可核验性 + 链接可用性与生命周期分离 + 结构校验」这块空白。差异化：让 reviewed 状态有可追溯的核验证据，且结构校验不绑定长文案（遵守自检断言哲学）。

## 2. 拟改（已实施）

1. **`template-docs/ui-knowledge/source-registry.md`**：
   - 对 6 条公开来源做只读链接 / 发布方 / 可见许可口径复核（2026-08-14）：W3C APG、WCAG 2.2、GOV.UK Design System、USWDS、awesome-design-md 共 5 条可访问；Microsoft HAX Toolkit 请求失败（2026-08-15 复核仍超时），标「暂时不可用」，未重试超过用户授权次数。
   - 生命周期与链接核验分开记录：新增「链接核验」字段；所有 Source 生命周期仍为 candidate（链接可访问 ≠ 人工评审通过）。
   - 许可口径：USWDS 只保存摘要与链接（其资产含 CC0 / 公版 / Apache / OFL / MIT 等多种许可）；awesome-design-md 不镜像其引用站点的第三方素材。
2. **`template-docs/ui-knowledge/README.md`**：
   - §4.1 Source 字段规范新增「链接核验状态」；§7 补规则：仅依赖「暂时不可用」来源的 Pattern / Principle 必须降为 candidate；§9 首批说明更新为 Batch 2A 复核口径。
3. **`template-docs/ui-knowledge/interaction-patterns.md`**：`PAT-INT-006`（AI 建议纠错与人工接管，唯一来源 `SRC-HAI-001` = Microsoft HAX Toolkit）由 reviewed 降为 candidate，注明降级原因与恢复条件；其余 6 条交互模式维持 reviewed。
4. **`scripts/check-template.sh`**：新增 `check_ui_knowledge_structure` —— 检查 `SRC-*` 编号唯一、每条来源有链接核验状态（已核验：可访问 / 暂时不可用）、`PAT-*` 编号唯一（visual + interaction 跨文件不重复）、`PAT-*` 引用的 `SRC-*` 均已登记、视觉 / 交互模式的稳定字段（适用条件 / 不适用条件 / 来源 / 证据等级 / 状态）在场；不检查长文案语义。

## 3. 版本影响

- PATCH（v1.62.1）：已有同步范围内文件的内容补强 + 自检增强，不新增同步结构文件 / 目录、不新增必填入口、不改变默认行为与推荐流程；判据 `CONTRIBUTING §4`（自检增强默认 patch）。patch 豁免 L3 端到端回归。

## 4. 影响面

- **改动文件**：`template-docs/ui-knowledge/README.md`、`source-registry.md`、`interaction-patterns.md`、`scripts/check-template.sh`（+ 本提案归档 + VERSION + 两份 CHANGELOG）。
- **不触碰**：`template-sync.json`（无新增 / 删除同步文件）、`visual-patterns.md`（6 条视觉模式状态不变）、CI workflow、既有 Gate。
- **下游影响**：派生项目同步后获得核验过的来源元数据与更严的结构自检；`PAT-INT-006` 降级不影响既有项目参考分析（项目采纳决定本就不回写模板）。

## 5. 验证方式

- `bash -n scripts/check-template.sh` 语法通过。
- `bash scripts/check-template.sh` 全量通过（2049 项 / 0 失败，含新增 UI 知识结构检查）。
- `powershell -ExecutionPolicy Bypass -File scripts/check-template.ps1` 通过（2049 项 / 0 失败）。
- `git diff --check` 无空白错误；`check-markdown-clean.ps1 _proposals ai-records` 通过。
- 人工核对：`PAT-INT-001` ~ `005` / `007` 为 reviewed、`PAT-INT-006` 为 candidate；6 条来源链接核验状态与最后核验日期一致。

## 6. 后续（Batch 2 剩余，不属本提案）

- Microsoft HAX Toolkit 链接恢复后复核，`PAT-INT-006` 再评审。
- core 晋升（需跨 ≥2 项目实证）、证据升级 / 降级、重复模式合并、模式扩充、外部语料层——依赖派生项目对 v1.62.0 的实际使用反馈。
