# TEMPLATE-UPGRADE: domain template docs folder

> 来源：模板维护者（ai-project-template）现场维护建议
> 状态：已实现但暂缓合并（deferred，2026-07-29）
> Release impact：minor（若合并；新增同步范围内的领域模板专用文档目录，并调整推荐入口）
> Release strategy：单独小批次；兼容保留旧顶层入口

## 背景

`template-docs/` 同时服务普通 L1→L3 派生项目和可选的 L1→L2→领域 L3 路径。领域模板相关文档继续放在顶层，会让普通使用者更容易误读为三层路径是默认主路径。

## 目标

1. 新增 `template-docs/domain-template/` 作为领域模板专用文档区。
2. 将领域模板方法论正文迁到 `template-docs/domain-template/README.md`。
3. 将 L2-to-L3 playbook template 迁到 `template-docs/domain-template/domain-derived-scenarios-template.md`。
4. 保留旧顶层路径为兼容跳转，避免旧链接和旧派生同步突然断。
5. 更新当前权威引用、同步清单、Bash fallback 和 `check-template.*` 断言。

## 非目标

- 不改普通 L1→L3 主路径。
- 不新增领域 scaffold。
- 不实现 `new-project --profile <domain>`。
- 不改母模板同步协议或多级同步自动化。

## 暂缓合并说明（2026-07-29）

本提案的完整实现存在于分支 `change/domain-template-docs-folder`（`f9b5637`，22 文件 +435/−329），经评估**决定暂不合并**，main 维持 `v1.59.0`。实现分支保留作可复用资产。

**暂缓理由**：

- 动机（降低普通使用者误读三层为默认主路径）真实但偏弱：领域文档仅 2 个文件、各自已带「可选中间层」声明，且当前只有 1 个真实领域模板用户（`agent-system-template`）。
- 投入偏重：目录重组 + 兼容跳转 + 同步清单 / 自检断言更新，引入 legacy pointer 长期维护债与自检断言膨胀（与 `template-docs/rd-data-chain.md` §4「避免过度治理」存在张力）。
- 治理先行于机制：领域模板本体（`_proposals/TEMPLATE-UPGRADE-domain-template-inheritance.md` Batch 2 建仓 / scaffold、Batch 3 多级同步自动化、Batch 4 `new-project --profile`）尚未落地，先细化其文档分区属倒序投入。

**触发重新评估的条件**：Batch 2（第二个领域模板出现）或 Batch 3（多级同步落地）。

**不合并的影响**：零。main 维持 v1.59.0，领域模板文档在顶层（`template-docs/domain-templates.md`、`template-docs/domain-derived-scenarios-template.md`）仍完整可用；领域模板机制不受影响。

> 本文件为 main 上的暂缓决议记录；实现分支上的同名提案保留原始状态，随分支一同保留，待复活时再同步状态。
