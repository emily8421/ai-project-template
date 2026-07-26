# TEMPLATE-UPGRADE: AI 观察记录生命周期与处置边界

> 来源：模板维护者（2026-07-26 registry PR closure 会话暴露的 hotspot 处置歧义）
> 状态：已落地 v1.57.2（P0+P1+P2）；P3 物理归档延后候选池
> 目标版本：v1.57.2
> Release impact：patch（治理说明补强 + 可选观察材料路径调整，不改默认行为、不要求派生迁移）
> Release strategy：同主题聚合；与 `ai/session-rules.md` / `template-docs/rd-data-chain.md` / `.gitignore` 的观察记录治理合并 v1.57.2 发布

## 1. 背景

2026-07-26 的 registry PR closure 会话中，AI 按 `ai/session-rules.md` §4.1 询问并写入了一条 token hotspot 记录。随后用户判断该记录不必提交远端，AI 将“不提交远端”误解为“删除本地记录以恢复干净工作区”，导致用户追问为什么没有遵循“只在本地记录，不提交远端”的预期。

这暴露出当前模板在 AI 观察记录上存在一个明确歧义：规则说明了何时提示、何时写入、隐私过滤和 summary rollup 阈值，但没有定义写入后的处置选择，也没有定义“本地记录”“可提交记录”“已汇总记录”“已转提案记录”的生命周期边界。

## 2. 当前审计发现

### 2.1 已有规则

- `.ai/session-handoff.md` / `NEXT-STEPS.md`：明确是本地续接记录，已 gitignore，不进入正式提交。
- `ai-records/token-hotspots/`：在 `ai/session-rules.md` §4.1 中定义为可选 AI 协作观察记录；写入前需要询问；不得包含 token、密钥、完整对话或敏感信息。
- `ai-records/token-hotspots/SUMMARY.md`：在 §4.2 中定义 rollup 机制；3 份及以上未被 summary 覆盖的记录触发提示。
- `template-docs/rd-data-chain.md`：把 `ai-records/token-hotspots/` 定位为 meta 观察材料，生命周期写为“观察，rollup”，并说明可转写为 `_proposals/TEMPLATE-UPGRADE-*.md`。

### 2.2 歧义点

| ID | 歧义 | 现有后果 |
|---|---|---|
| AIL-001 | 写入 token hotspot 后，默认是仅本地保留、提交 PR，还是等待用户再决策？ | AI 可能把“写入确认”扩大解释为“后续提交确认”，也可能把“不提交”误解为“删除”。 |
| AIL-002 | `ai-records/token-hotspots/` 不在 `.gitignore`，但规则又称其为可选观察材料。 | 如果只本地保留，会长期 `untracked` / dirty；如果提交，又可能为了元记录制造低收益 PR。 |
| AIL-003 | `汇总状态` 当前是“可选增加”，不是必填。 | AI 判断 rollup 阈值时可能重复统计已处理记录，或漏掉未覆盖记录。 |
| AIL-004 | `SUMMARY.md` 没有强制列出“已覆盖记录清单 / 下一次 rollup 起点”。 | 后续会话可能重复分析旧记录，尤其是旧记录状态字段不一致时。 |
| AIL-005 | 已转成 `_proposals/` 的 hotspot 没有统一关闭语义。 | 已经回流为提案的问题仍可能被下一次 summary 或审计重复分析。 |
| AIL-006 | 没有归档策略。 | 记录越积越多时，AI 可能为了判断阈值反复读取旧记录，增加上下文成本。 |

## 3. 目标

1. 明确 AI 观察记录写入后的处置协议，避免不同 AI 对“只本地记录 / 不提交远端 / 删除”的理解漂移。
2. 明确 token hotspot 记录的生命周期：新建、保留、本地未提交、提交入库、已汇总、已转提案、归档。
3. 降低后续 AI 重复分析已汇总或已转提案记录的概率。
4. 保持机制轻量，不把所有观察材料变成强制门禁。

## 4. 非目标

- 不要求所有历史 hotspot 记录立即迁移或重写。
- 不把 `ai-records/token-hotspots/` 改成项目事实权威文档。
- 不强制每次 hotspot 都提交 PR。
- 不取消已有 `SUMMARY.md` 或已提交 hotspot 记录。
- 不引入重型数据库、索引脚本或强制 CI 门禁；如需脚本化检查，另案评估。

## 5. 拟改规则

### 5.1 写入后处置协议

建议在 `ai/session-rules.md` §4.1 增加：

1. 写入单条 hotspot 记录后，AI 必须明确提示该记录当前是“本地新文件 / 已跟踪修改 / 已提交记录”中的哪一种。
2. “不提交远端”不得自动解释为“删除本地文件”。
3. 除非用户已经明确授权提交，否则新建或修改 hotspot 后，AI 必须给出三种处置选择：
   - 保留本地未提交记录。
   - 作为观察材料提交并走 PR。
   - 删除本地记录。
4. 若用户说“只本地记录”，默认保留本地文件，并说明工作区会保持 dirty / untracked；若希望不污染 Git 状态，应另行确认使用被 gitignore 的本地路径。
5. 若用户说“提交 / 走 PR”，AI 才按模板维护流程切分支、提交、push、创建 PR。

### 5.2 路径分层（建议）

为避免“本地记录”与“可入库观察材料”混用，建议引入两层路径：

| 类型 | 建议路径 | Git 语义 |
|---|---|---|
| 本地一次性 hotspot | `.ai/token-hotspots/YYYY-MM-DD-<slug>.md` | gitignored，仅本地续接 / 观察 |
| 可入库 hotspot | `ai-records/token-hotspots/YYYY-MM-DD-<slug>.md` | 可提交，需用户明确确认并走 PR |
| 汇总 | `ai-records/token-hotspots/SUMMARY.md` | 可提交，需用户确认 |

兼容策略：保留现有 `ai-records/token-hotspots/` 历史记录；新增规则只约束后续 AI 默认行为。若不想新增 `.ai/token-hotspots/`，也可保守落地为：继续写 `ai-records/token-hotspots/`，但必须在写入后询问保留 / 提交 / 删除。

### 5.3 生命周期状态字段

建议将 `汇总状态` 从“可选增加”改为新记录必填，最小状态集：

```text
- 汇总状态：未汇总 / 已纳入 SUMMARY.md（<日期或范围>） / 已转提案 <path-or-url> / 本地保留不提交 / 已归档 <path>
```

建议同时增加可选字段：

```text
- 处置状态：本地未提交 / 已提交 PR #<n> / 已合并 <commit> / 已删除（用户确认）
```

### 5.4 SUMMARY 覆盖清单

建议在 `ai-records/token-hotspots/SUMMARY.md` 最小结构中增加：

```text
## 0. 覆盖边界

- 已覆盖记录：
  - <path>
- 未覆盖记录：
  - <path>
- 下一次 rollup 起点：
  - 从 <path/date> 开始，只统计 `汇总状态：未汇总` 的记录
```

规则补充：

- 已纳入 SUMMARY 的记录不得再次计入 3 份阈值。
- 已转成 `_proposals/` 的记录不得再次作为同一问题的 summary 输入，除非用户明确要求复盘。
- 若旧记录状态缺失，AI 应先按 `SUMMARY.md` 覆盖边界判断；无法判断时列为“需人工确认”，不得直接重复纳入。

### 5.5 归档策略

建议先采用轻量归档，不立即强制搬历史文件：

1. 短期：用 `SUMMARY.md` 覆盖清单 + 单条记录状态字段实现逻辑归档。
2. 中期：当目录继续膨胀或未汇总判断成本变高时，引入物理归档目录：

```text
ai-records/token-hotspots/_archive/YYYY/
```

3. 物理归档前必须先评估下游引用、`SUMMARY.md` 链接和已有提案引用，不做静默搬迁。

## 6. 影响文件

### 建议修改

- `ai/session-rules.md`
  - §4.1：补充写入后处置协议、路径分层、不得自动删除规则。
  - §4.2：补充 `SUMMARY.md` 覆盖清单、阈值只统计未汇总记录、已转提案不重复分析。
- `template-docs/rd-data-chain.md`
  - 把 `token-hotspots` 生命周期从“观察，rollup”细化为“本地观察 / 可提交记录 / rollup / 转提案 / 归档”。
- `template-docs/session-handoff.example.md`（可选）
  - 若引入 `.ai/token-hotspots/`，补一句本地观察材料位置与边界。
- `.gitignore`（可选）
  - 若采用 `.ai/token-hotspots/`，补充忽略规则。

### 暂不建议修改

- 不建议直接把 `ai-records/token-hotspots/` 全目录加入 `.gitignore`，因为历史记录和 `SUMMARY.md` 已经作为可入库观察材料使用。
- 不建议立即迁移历史文件到 `_archive/`，避免一次大变更扩大风险。

## 7. 验收标准

- 新规则能明确回答：
  - hotspot 写入后是否提交远端？
  - 用户说“不提交”时是否保留本地文件？
  - 用户说“只本地记录”时文件放哪里？
  - 哪些记录计入下一次 SUMMARY rollup？
  - 已转提案的问题是否再次分析？
- AI 在写入 hotspot 后不得直接删除本地记录，除非用户明确说删除。
- `SUMMARY.md` 能让后续 AI 不读全目录也判断 rollup 起点。
- 旧记录兼容：历史 `ai-records/token-hotspots/*.md` 不需要一次性改写，也不影响现有 PR / SUMMARY 链接。

## 8. 验证方式

- `git diff --check`
- `powershell -ExecutionPolicy Bypass -File scripts/check-markdown-clean.ps1 _proposals ai-records`
- 若后续修改同步范围内规则：`bash scripts/check-template.sh --summary` 或 CI `Template Check`
- 人工复核一次典型流程：
  1. 用户确认写 hotspot。
  2. AI 写本地记录。
  3. 用户说“不提交远端”。
  4. AI 应保留本地记录并说明状态，而不是删除。
  5. 用户说“删除本地记录”时，AI 才删除。

## 9. 开放问题

| ID | 待确认项 | AI 建议 | 建议依据 | 备选方案 | 取舍影响 / 阻塞关系 |
|---|---|---|---|---|---|
| AIL-C-001 | 是否新增 `.ai/token-hotspots/` 作为默认本地-only 路径？ | 建议新增，避免本地-only 记录污染 Git 工作区。 | `.ai/session-handoff.md` 已是本地临时状态路径；hotspot 单条记录常是过程性材料。 | 继续使用 `ai-records/token-hotspots/`，写入后让用户选择保留 / 提交 / 删除。 | 新增路径需补 `.gitignore` 和规则；不新增路径则 dirty 工作区问题仍存在。 |
| AIL-C-002 | `SUMMARY.md` 是否必须同步更新单条记录的 `汇总状态`？ | 建议优先在 SUMMARY 中列覆盖清单，单条状态可在新记录中必填，旧记录逐步补。 | 历史文件多，批量改写成本高；覆盖清单可先解决重复分析。 | 强制每次 summary 同步 patch 所有单条状态。 | 强同步更准确，但会造成更大 diff 和更多冲突。 |
| AIL-C-003 | 是否立即引入物理归档目录？ | 建议暂缓，先逻辑归档。 | 当前主要风险是重复分析，不是目录性能瓶颈。 | 立即新增 `_archive/YYYY/` 并迁移已覆盖记录。 | 立即迁移会改大量文件和链接，适合后续单独 PR。 |

## 10. 建议落地顺序

1. P0：澄清写入后处置协议，增加“不提交不等于删除”的硬规则。
2. P1：把新记录 `汇总状态` 改为必填，给 `SUMMARY.md` 增加覆盖边界。
3. P2：评估 `.ai/token-hotspots/` 本地-only 路径。
4. P3：观察目录规模，再决定是否引入物理归档。

## 11. 落地决策（v1.57.2，2026-07-26）

本提案以 v1.57.2 patch 落地，最终方案（经维护者确认）：

- **路径分层（AIL-C-001 → 采用）**：单条记录默认写本地 `.ai/token-hotspots/`（gitignore，不问不上传）；汇总 `SUMMARY.md` / `summaries/` 入库。`.gitignore` 加 `.ai/token-hotspots/`。核心考量：用户诉求是“别问、别传、不脏工作区”，路径分层一劳永逸；汇总（提炼后的有价值结论）仍入库以保留跨会话 / 跨项目参考价值。
- **P0 简化**：去掉“每次三选一”，单条默认本地直接写入；保留“不提交≠删除”兜底硬规则（上次事故的直接教训）；三选一仅用于入库决策。
- **P1 保留（AIL-C-002 → 覆盖清单优先）**：汇总循环“本地攒若干条 → 提炼 SUMMARY 入库 → 本地可清”；汇总状态字段新记录必填（旧记录不强制）；SUMMARY 加 `## 0. 覆盖清单`；已汇总 / 已转提案不重复计数；字段必填属写入自觉，不引入 `check-template` 自检门禁（与 rd-data-chain §4 协调）。
- **物理归档（AIL-C-003 → P3 延后）**：当前规模未到瓶颈，逻辑归档（覆盖清单 + 状态字段）先行。
- **历史记录迁移**：`ai-records/token-hotspots/` 下 20 条单条记录移至本地 `.ai/token-hotspots/`（从当前快照移出，git 历史保留，不丢历史）；`SUMMARY.md` + `summaries/`（4 份）+ `project-registry` + `e2e-reports` 保留入库；SUMMARY 顶部加单条去向自洽说明。
- **派生项目 .gitignore 缺口**：`.gitignore` 不纳入下行同步（各项目自定义）；派生项目启用此机制需自行补 `.ai/token-hotspots/`（规则已在 `ai/session-rules.md` §4.1 写明）。

实际影响文件：`ai/session-rules.md` §4.1/§4.2、`template-docs/rd-data-chain.md` §2/§4、`.gitignore`、`VERSION`、`CHANGELOG.md`、`CHANGELOG-PLAIN.md`、`ai-records/token-hotspots/SUMMARY.md`（单条去向说明）、20 条单条记录迁移至 `.ai/token-hotspots/`。
