# Token Hotspot 记录：capability package 提案分批落地

> 日期：2026-07-15
> 任务类型：模板维护（提案评估 + 规则 / 脚本 / 文档分批落地）
> 触发条件：`ai/session-rules.md` §4.1（多次完整 check-template + 长规则 / 脚本读取 + 提案多次重写）

## 热点工作

- 多轮完整 `scripts/check-template.ps1`（每次 ~数百行断言输出）：Batch 1.5 / 2.5 / 3 / 2 验证各跑 1–2 次，每次输出 500+ 行。
- 长文件读取：`ai/rules-core.md`、`ai/global-rules.md`、`ai/project-rules.md`、`ai/implementation-lifecycle-rules.md`、`scripts/check-template.ps1`（原 765 行）、提案主文档（多版）。
- 跨 4 分支切换 + 提案文档多次整体重写（4 版）。

## 热点判断

- **主要成本**：`check-template` 完整输出的反复带入（每次 500+ 行），占本轮上下文大头。
- **次要**：长脚本（check-template.ps1 765 行）全文读取（为 Batch 2 方案 A 落地）；提案文档多次整体 Write 重写。
- 总量级：本轮上下文消耗偏高，主要由"验证长输出 + 脚本全文"贡献。

## 质量影响

- 上下文变重后，评估 / 编辑需更谨慎（易遗漏），提案多次重写即是症状。
- `check-template` 长输出反复带入，挤压有效信息空间。

## 优化建议

- **check-template 成功输出只留结论**：exit 0 + "✅ 模板自检通过"即可，不重复全量断言列表（呼应 `session-rules.md` §4.1）。本轮后期已用 `tail -5` 截断，但前几次仍带入全量。
- **长脚本先 grep 结构再读**：Batch 2 评估阶段用了 grep 定位 fallback，落地才全读——此模式应推广。
- **提案文档避免整体重写**：多用精准 Edit，少用整体 Write（本轮 4 次重写累积成本）。
- **check-template 本身可加"quiet 模式"**：成功时只输出结论，失败才展开（这是个脚本增强点，可入未来 Batch）。

## 关联

- 提案：`_proposals/TEMPLATE-UPGRADE-capability-packages-and-profile-contracts.md`
- 相关批次：主线 A 防跑飞（Batch 1.5 `11d8b2c`）、主线 B 分诊（Batch 2.5 `96a19e2` / Batch 3 `c1c6603`）、自检减负（Batch 2 方案 A `e178a79`）。
