# TEMPLATE-UPGRADE: Windows/Codex 续接、只读核对与补丁调用的失败域分流

> 来源：模板维护者（2026-11-03～11-07 跨 Claude/Codex 会话复盘，去项目化）
> 状态：处理中（2026-11-09 合并 C1 triage 通过——与 #526 及 zhiyan 回流材料 P2 两条聚合实施；原「候选」状态由本入库件取代，独立 worktree 草稿随之作废）
> 目标版本：v1.77.3（聚合 PATCH）
> Release impact：patch（本提案入库不递增版本；聚合轮实施时按 PATCH 发版）
> Release strategy：同主题聚合（#526 `git fetch` 措辞修正 + 本提案三主题 + zhiyan P2-b / 分支 3）

## 0. 摘要

跨 CLI 续接时，模板已经规定显式 UTF-8、远端失败即停、权限预检和 v1.77.1 派生同步前置声明，但仍存在三处具体操作缺口：本地事实与旧 handoff 混作单一新鲜度判断；Windows PowerShell 的多层命令传参未在相应入口提供可靠的只读查询范式；补丁工具包装器参数失真被误报为文件写入失败。建议只补现有入口的证据分级及工具调用提示，保留远端/写入失败即停，不另建一套 Codex 专用规则。

## 1. 动机与实证（去项目化）

1. **续接差异不等于版本冲突**：`Branch/HEAD/VERSION` 与 Git 一致，但另一 CLI 留下一个未跟踪目录、另有会话新建 worktree，旧 handoff 只列一个未跟踪文件并称“无 worktree”。应显式标注“工作区清单过时，归属待确认”，而不是据此推导版本未发布、远端异常或应清理该目录。命中真实分支、HEAD、版本冲突时仍维持 stale 判定和停止。
2. **本地记录不等于远端发布**：`VERSION`、`CHANGELOG`、本地合并提交只证实本地事实，不自动证实当前 GitHub `main`、Release 或 tag。一次 PowerShell 下 `gh api --jq` 的复杂表达式在多层命令包装时被转义破坏，查询实际未成功；先前远端快照不得冒充当前复核。模板现有 remote SOP §3.D.4 已提醒复杂 `--jq` 的风险，执行入口仍需更明确的最小示例和结果分类。
3. **补丁失败域需与权限失败分开**：Windows 本机 `apply_patch.bat` 将 `%*` 传给 `codex.exe --codex-run-as-apply-patch`。将补丁通过 PowerShell 管道传入时报“需要 UTF-8 PATCH 参数”；把多行 here-string 作为 `.bat` 参数传入时报“最后一行必须是 `*** End Patch`”，尽管调用前的变量末行确实是该标记。改为直接将同类补丁作为参数传给原生 Codex 补丁入口后，本地 handoff 写入成功。这证明**该环境的包装器/传参链路会失真**，不证明所有 Windows CLI、所有 Codex 版本都有同一缺陷；更不说明 handoff 文件无写权限。此前空补丁直连返回 `No files were modified.` 且退出码 1，不能拿来当实际写入通过证据。
4. **沙箱与信任边界是另一类问题**：Git 用户级 ignore 文件在受限身份下不可读；另一个账号拥有的 worktree 被 Git 以 dubious ownership 拒绝只读查询，经批准以原所有者身份读取成功。这些不应靠全局 `safe.directory` 放行或关闭沙箱来静默处理；应记录已取得事实、失败项与权限边界。此前派生仓 `.git/FETCH_HEAD` 写入被沙箱拒绝的根因已在 v1.77.1 提案落地，本提案不重开该问题。

## 1.1 与既有规则的关系（去重）

- **跨 CLI 沙箱友好性**（`_governance/_archive/proposals/TEMPLATE-UPGRADE-cross-cli-sandbox-friendliness.md`，已随 v1.77.1 实施）：标注派生仓不读 `MAINTAINERS.md`，同步前声明联网及 `.git` 写权限。**对象不同**——本提案只涉及续接证据裁决和 Windows 命令传参，不再修改同步前置声明。
- **跨 AI CLI 写入确认**（`_governance/_archive/proposals/TEMPLATE-UPGRADE-cross-cli-edit-confirmation.md`）：规定先获用户授权、再审查 diff。**机制不同**——本提案处理已授权后补丁工具如何可靠传参，绝不降低写入确认要求。
- **快速续接**（`ai/session-rules.md` §3.1、`ai/commands/resume.md`）：已有 Git 优先、工作区 dirty 时列冲突、明确远端未复核。**互补不重复**——补充“哪些字段过时”与“是否阻塞当前任务”的分级输出，避免一处新增未跟踪目录使全部历史版本事实作废。
- **远端 SOP**（`template-docs/profiles/remote-ci-sop-profile.md` §3.D.4）：已有 PowerShell 下 `gh --jq` 风险和原始 JSON 建议。**指向**——优先在此处完善一个简短、可验证的只读范式；不复制另一份 GitHub 操作 SOP。
- **Checkpoint / 编码 / 沙箱规则**（`ai/rules-core.md` §4、`ai/session-rules.md` §3.3）：已有 UTF-8 恢复、失败即停和需 `.git`/网络时申请权限。**互补不重复**——补充“主命令失败、警告、可选 no-match、辅助查询失败”的明确结果标签；远端变更及权限失败仍必须停，不新增自动重试例外。
- **zhiyan 回流材料**（issue #526、派生仓研究分析 2026-11-07 及其收缩提案）：#526 措辞缺口与本提案零重叠同轮聚合；其 P2-b（跨仓续接状态分级）并入本提案拟改 1，分支 3（命令构造错误 ≠ 沙箱错误）与 P2-a（PowerShell 分步）并入本提案拟改 3。**互补不重复**——zhiyan 独立复核结论「原 P1 已覆盖」经母仓重评估修正为「分支 1/2 已覆盖、分支 3 未覆盖（本提案认领）」，分级词汇缺口（P2-b）由本提案拟改 1 认领。

**本提案不重复它们**：把散在既有规则里的边界落到具体的 Windows 续接/只读查询/补丁调用入口；将本轮尚未解决的工具层失误与已落地的模板修复分开。

## 2. 拟改（2026-11-09 合并 triage 后为实施口径）

1. `ai/session-rules.md` §3.1 与 `ai/commands/resume.md`：将 handoff 新鲜度按 `Branch/HEAD/VERSION`、工作区文件、stash/worktree、远端快照逐项输出 `一致 / 过时 / 未复核`。工作区新增已知跨 CLI 目录时只记待确认归属、不直接下结论清理；分支/HEAD/版本真实冲突仍按既有 stale 规则停止。跨仓续接区分「本地已提交 / 已推送 / PR 已合并 / 仅本地跟踪快照」（吸收 zhiyan P2-b；§3.1 为主落点，resume.md 输出契约跟随小改）。
2. `template-docs/profiles/remote-ci-sop-profile.md` §3.D.4：补 PowerShell 只读查询的精简示例，优先取原始 JSON 后解析；示例须明确验证 HTTP/CLI 退出码与响应字段，并分别报告 `GitHub main`、Release、tag 的 `已核实 / 未核实`，不把本地 `VERSION` 写成远端事实。
3. 在既有 `template-docs/ai-cli-setup.md` 或相邻 CLI 故障排查段补一张“小症状 → 可核验证据 → 安全处置”表：编码乱码、用户级 Git ignore 警告、worktree 所有权、`.bat` 多行补丁参数失真。明确先用当前 CLI 原生补丁工具；若没有对应入口，先核查 wrapper 参数契约，不将 `| apply_patch` 当作通用替代；本地写入成功必须以目标文件改动核验，不以无改动探针为证。命令构造 / 补丁格式错误归类为「命令域」，不按沙箱 / 权限故障处理（吸收 zhiyan 分支 3 与 P2-a）。不硬编码用户目录、临时包装器路径或某一 Codex 版本内部命令。
4. 如 C1 认定前 3 项已足够，不再改 `ai/rules-core.md`；只有存在无法在入口解决的失败域歧义时，才合并进 §4 既有条目，避免新建一条宽泛失败重试规则。（triage 维持：不改 `rules-core.md`。）

## 3. 版本、影响面与边界

- 候选提案入库：`none`，不修改 `VERSION`、`CHANGELOG` 或同步清单。
- 聚合轮实施（与 #526 合并）：`patch`（四项均为既有同步范围内文件措辞 / 示例级补强，无新门禁、脚本或清单变更；先例 v1.76.1 双提案同口径）。
- 影响消费者：模板维护者和跨 CLI 使用者；`session-rules.md` / `remote-ci-sop-profile.md` / `ai-cli-setup.md` 均属下行同步范围，派生项目下次同步获得；未授权覆盖派生仓规则，也不更改远端 GitHub 权限、沙箱配置或全量 CI 门禁。
- 排除：重开 v1.77.1 已落地议题、放宽远端写入确认、全局添加 `safe.directory`、在模板内固定私人绝对路径、将所有命令失败都归因于 Codex 沙箱、回改 zhiyan 派生仓文件（其两处论证失准的修正随合并 triage 报告落档，不回写派生仓）。

## 4. 验证与验收建议

1. 人工续接情景：`HEAD/VERSION` 一致但增加另一个 CLI 目录或 worktree；摘要应准确报告差异、不清理文件、不误报远端；若真实版本/分支冲突则按现有规则停。
2. Windows PowerShell 只读远端情景：查询成功才报告远端字段；解析错误须标 `未核实`，不误报 GitHub 未发布；不做联网自动连续重试。
3. 补丁情景：优先原生补丁入口，对小范围已授权本地改动核验目标文件与 Git 状态；`.bat`/shell 转发失败时报工具参数问题，不能误诊为权限失败，也不能把空补丁退出码 1 当通过（验证边界采信 zhiyan 口径：字节级失真机制视为未定位，不写进模板）。
4. worktree 情景：用户身份不符时报权限/所有权待确认，不写入全局安全例外；各工作区归属由对应会话确认。
5. 若实际实施改动涉及同步范围内规则文件，按模板要求做窄范围 diff、Markdown 检查及非沙箱/CI 自检（全量自检 2131 基线）；同步预检「只读」措辞经 #526 修正后检索应无歧义残留。

## 5. 落地流程

入库 PR（本文件 + issue #526 镜像）→ 聚合实施 PR（v1.77.3：#526 措辞 + 本提案拟改 1-3 + VERSION/CHANGELOG/CHANGELOG-PLAIN + 关闭 #526 附锚点）→ 归档 PR（本文件与镜像移入 `_governance/_archive/proposals/`）。独立 worktree `change/codex-checkpoint-portability` 的未跟踪草稿由本入库件取代，处置随收尾轮交由用户确认。
