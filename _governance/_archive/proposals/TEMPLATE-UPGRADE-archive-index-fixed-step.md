# TEMPLATE-UPGRADE: 归档操作序列补「同步更新归档索引表」固定步

> 来源：模板维护者（pitfall SUMMARY §18 第十四批——archive-index-backfill-drift，同族第三次实证：2026-09-10 #456 归档后 09-15 补登 / 2026-11-10 #542 / 2026-11-12 #547 归档均漏登索引表）
> 状态：已拍板实施（2026-11-16 用户随 pitfall 第十四批 rollup #559 拍板立案，目标 v1.79.1）
> 目标版本：v1.79.1
> Release impact：patch（AI 建议——治理流程文档固定步，不改变默认行为与流程结构）
> Release strategy：单独发布

## 1. 动机（去项目化）

提案归档操作 = `git mv` 到 `_archive/proposals/`，但「同步更新归档索引表」未进操作序列，同族三次实证（#456 归档后 09-15 补登记、#542 与 #547 归档后 2026-11-14 实查发现均未登记，本轮 #552 已为新归档顺带补登 +2 行）——「关键前置未进执行清单」家族第六面：纪律不进操作文档就会重犯。

## 1.1 与既有规则的关系（去重）

- **`CONTRIBUTING.md` §3 改模板流程**：管提案 → 分支 → PR → 合并全流程。**互补不重复**——本提案仅在步骤 6（归档移动）补固定步，不动其他步骤。
- **`ai/prompts/maintainers/11-template-proposal-summary.md` 分析要求 8「归档计划」**：管「哪些应归档」的清单产出。**机制不同**——本提案管「归档时怎么落」的操作步（移动与索引表登记同批完成）。
- **`_governance/_archive/proposals/README.md` 归档原则**：管索引表的内容与定位。**指向**——本提案不定义索引内容，只把「更新它」接进操作序列。
- **pitfall SUMMARY §14 / §18**：观察材料与立案判据。**指向**——本提案即第十四批回流判断的立案兑现（同族第三次实例达口径，与 untracked add 附注 v1.78.2、镜像清尾 v1.78.1 同款「三犯立案」先例）。

**本提案不重复它们**：补的是「归档 mv → 索引表更新」在操作序列中的空白。

## 2. 拟改

1. `CONTRIBUTING.md` §3 步骤 6：归档移动后追加「移动与索引表登记同批完成——`git mv` 后同步更新 `_governance/_archive/proposals/README.md` 归档索引表（批次行 + 落地版本 / PR / squash 锚点），不留『只 rename 未登记』中间态」。
2. `ai/prompts/maintainers/11-template-proposal-summary.md` 分析要求 8「归档计划」：追加同口径固定步，两处同措辞防漂移。

## 3. 版本影响

PATCH（治理流程文档固定步，不改默认行为 / 同步清单 / 断言）。

## 4. 影响面

- `CONTRIBUTING.md` 与 `ai/prompts/maintainers/11-template-proposal-summary.md`（均在 `template-sync.json` `files_all` 同步清单内）——派生项目同步后共享。
- 不新增 `check-template.sh` 断言（索引更新属语义动作，无法机械化；与「避免过度治理」口径一致）。

## 5. 验证方式

- `bash scripts/check-template.sh --summary` 全量自检 + `git diff --check` + md-clean 窄检。
- 人工核对：两处落点同口径不双写；归档索引表既有行格式不受影响。
- PATCH 级豁免 L3 e2e（纯治理流程文档固定步）。
