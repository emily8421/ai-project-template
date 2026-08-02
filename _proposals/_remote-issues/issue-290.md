# GitHub Issue #290: TEMPLATE-DEFER: domain-template docs folder reorg (v1.60.0) not merging; revive at Batch 2/3

> Source URL: https://github.com/emily8421/ai-project-template/issues/290
> State: OPEN
> Labels: proposal
> Author: emily8421
> Created: 2026-07-29T10:24:40Z
> Updated: 2026-07-29T10:24:40Z
> Mirrored at: 2026-08-01T23:02:20+08:00
> Mirror status: raw remote issue copy for local triage; GitHub issue remains source of comments and closure state.

## Raw Issue Body

## 决议

v1.60.0「领域模板专用文档分区」（领域模板 L2 文档收拢到 `template-docs/domain-template/`）的完整实现存在于分支 `change/domain-template-docs-folder`（`f9b5637`，22 文件 +435/−329），经评估**决定暂不合并**，main 维持 `v1.59.0`。

## 暂缓理由

- 动机真实但偏弱：领域文档仅 2 个文件、自带「可选中间层」声明、仅 1 个真实领域模板用户（`agent-system-template`）。
- 投入偏重：目录重组 + 兼容跳转 + 同步清单 / 自检断言更新，引入 legacy pointer 长期债 + 断言膨胀（与 `rd-data-chain.md` §4 张力）。
- 治理先行于机制：领域模板本体（inheritance 提案 Batch 2/3/4）未落地。

## 触发重新评估

- Batch 2：第二个领域模板出现。
- Batch 3：多级同步落地。

满足任一条件时，复活 `change/domain-template-docs-folder` 分支重新评估合并。

## 关联

- deferred 决议记录 PR：#289
- 实现分支：`change/domain-template-docs-folder`（`f9b5637`）
- 相关提案：`_proposals/TEMPLATE-UPGRADE-domain-template-inheritance.md`
