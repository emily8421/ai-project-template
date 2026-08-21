# TEMPLATE-UPGRADE: 文档体验审核修复（A+B 回写 + bug）

> 来源：模板维护者（3 个 UX 审核 agent 报告驱动）
> 状态：进行中（PR1 已落地 A+B；PR2 待办 C+D）
> 目标版本：v1.45.1（PR1）/ 后续（PR2）
> Release impact：patch
> Release strategy：PR1（A+B）+ PR2（C+D）

## 1. 背景

用户要求「除 README 外，根目录导航/指导文档 + template-docs 场景/方法论文档都重新梳理，让用户更容易操作」。3 个审核 agent（根目录操作 / template-docs 核心 / 工具模板）从六维度（可发现性 / 步骤清晰 / 一致性 / 过时 / 冗余 / 新手友好）发现 5 类共性问题：

1. 场景码体系漂移（SOP 停 A0-A14、scenario 索引漏 A8.5、"23 场景"硬编码 3 处）。
2. 新能力回写不完整（show-demo 四文档缺席、domain-templates 部分回写、A20 在 SOP 缺席）。
3. 锚点 / 命令 bug（git-guide 3 锚点错、e2e 建仓重复 gh repo create、ai-cli-setup §8 重号）。
4. 可填模板缺范例行。
5. 文档内冗余 + 旧名残留。

用户确认全部 A+B+C+D 落地。

## 2. PR1 已落地（A+B，commit 8af69ab）

### 批次 A（回写 + 场景码一致性）
- show-demo 回写：scenario-guides 新增 A21 轻量场景（引用命令，不双写）、beginner §3/§7、glossary 演示 SOP 条目（演示≠09 验收）。
- domain-templates：进 template-methodology §2 权威源表 + beginner §7 导航。
- 场景码统一「A0–A21（含 .5）/ C1–C8 / M0–M1」，删"23 场景"硬编码；scenario 索引补 A8.5；SOP 场景表对齐（补 16 漏码 + 修 A5/A6、A8/A10 共享码歧义）。
- template-methodology §2 补 implementation-lifecycle-rules / session-rules。

### 批次 B（正确性 bug）
- git-guide：3 锚点（§7→§8、§1.2/§1.3→§1 第 2/3 条）+ 速查表 scenario 码桥接列。
- e2e-regression-checklist：建仓命令重复触发修复 + "bootstrap sync 脚本"改真实命令。
- ai-cli-setup：§8 重号→§9。
- smoke-test / report：旧根名→template-docs/ + 步骤对齐。
- INIT-PROMPT：删 v1.22.2 + 补 ai/index.md 自动读取说明。

## 3. PR2 待办（C+D）

- **批次 C（模板易填性）**：ui-prototype-strategy-template / derived-sync-report-template 补范例行。
- **批次 D（防漂移断言）**：check-template 加断言（新能力回写 + 场景索引一致性 + 权威源表对齐），防未来再漂移。

## 4. 版本影响

**patch**：文档对齐 / 回写 / 修复，不新增能力层级（show-demo / domain-templates 已发版，本次是回写对齐 + bug 修复）。

## 5. 留后续（未做）

- SOP「使用原则 / 文档入口 / 常见选择」三写冗余精简（中优先级，PR1 未做，避免重构风险）。

## 6. 验证

`bash scripts/check-template.sh` 全过（A+B 后 + SOP 断言关键词补回后）；CI Template Check。
