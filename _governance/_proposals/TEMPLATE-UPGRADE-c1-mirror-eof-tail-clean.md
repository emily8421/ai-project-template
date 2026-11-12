# TEMPLATE-UPGRADE: C1 issue 镜像落盘清尾写进 prompt 11 操作序列

> 来源：模板维护者（pitfall SUMMARY 第十二批回流候选；mirror-eof-whitespace-gate 家族：2026-10-31 首证 + 2026-11-09 #526 当场复发）
> 状态：处理中（维护者已拍板随本提案实施）
> 目标版本：v1.78.1
> Release impact：patch（AI 建议，维护者已确认执行）
> Release strategy：单独发布

## 1. 动机（去项目化）

C1 维护者把远端 issue 正文经 `gh issue view --jq .body` 重定向落盘为镜像后，EOF 多余空行与行尾空白两次触发 CI whitespace 门禁（`check-markdown-clean.ps1`）拦截：2026-10-31 首证（#490/#491 实施轮），2026-11-09 当场复发（#526 镜像落盘，清尾后双检通过）。

规避口径（「镜像落盘后立即清尾再检查」）已记入 pitfall SUMMARY 行为纪律（第八批 + 第十二批），但未进 `ai/prompts/maintainers/11-template-proposal-summary.md` 的镜像操作序列——「坑记了、修法也记了，修法不模板化进操作步骤就还会犯」（第十二批模式结论），复发即证。

## 1.1 与既有规则的关系（去重）

- **prompt 11 镜像硬门禁**（现行文本）：规定「远端正文必须先镜像 / 刷新再分析、无镜像不得进分析」，未规定落盘后清尾。**互补不重复**——本提案在既有硬门禁旁补落盘卫生步，不改变镜像门禁语义。
- **`_governance/_proposals/README.md`「远端 issue 本地镜像」刷新规则**：镜像目录 / 刷新规则的人读权威文档，同样无清尾步。**层级不同**——prompt 11 是 AI 执行入口（本提案落点）；README 为治理规则文档，是否同步补随 triage 判断（倾向暂不双写，一处固定步先行实效观察）。
- **`scripts/check-markdown-clean.ps1`**（`files_all` 下行）：whitespace 门禁本体，只拦不提示成因与预防步。**机制不同**——门禁是检测兜底，本提案是操作序列预防步，二者互补。
- **pitfall SUMMARY §8 / §12 行为纪律**：观察材料。**指向**——本提案为第十二批回流候选的立案兑现。

**本提案不重复它们**：把「清尾」从行为纪律自觉提升为 prompt 11 操作序列固定步，补执行入口的空白。

## 2. 拟改

`ai/prompts/maintainers/11-template-proposal-summary.md`「镜像门禁检查」清单 +1 条：

> - 镜像落盘后立即清尾（剥 EOF 多余空行与行尾空白）再进入检查 / 分析与提交（mirror-eof-whitespace-gate 家族两次实证：未清尾镜像会被 CI whitespace 门禁拦截）。

1 行微调，不改动既有门禁条目与硬门禁段落语义。

## 3. 版本影响

PATCH → v1.78.1（AI 建议，维护者已确认）：prompt 11 在 `template-sync.json` `files_all` 同步清单内，属「Prompt 小修」默认 PATCH。

## 4. 影响面

- prompt 11 下行同步后，派生项目维护者会话同样获得该操作步。
- 1 行新增，无脚本 / 断言 / 同步清单结构变更。

## 5. 验证方式

- `bash scripts/check-template.sh --summary` 全量自检 + `git diff --check` + `check-markdown-clean.ps1 _governance/_proposals _governance/ai-records`。
- 人工核对：新增条目位置（镜像门禁检查清单）与既有条目无重复、无语义冲突。
- PATCH 级豁免 L3 e2e（1 行 Prompt 小修，无脚本 / 同步清单 / 断言变更）。
