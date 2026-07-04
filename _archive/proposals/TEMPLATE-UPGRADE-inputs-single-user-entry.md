# TEMPLATE-UPGRADE: 统一用户输入材料入口

> 来源：模板维护者。
> 类型：模板仓库内直接发起的模板优化提案。
> 状态：已实施并归档；由 2026-07-04 会话中对 `docs/vision/` 与 `docs/inputs/` 入口混淆的复盘形成，实施时扩展为输入材料评审闭环。
> 建议实施批次：独立 PR；建议在同步闭环提案后落地。

## 1. 背景与问题

当前 `docs/README.md` 将 `docs/vision/` 与 `docs/inputs/` 同时列为“人工输入（原料）”：

- `docs/vision/`：产品愿景、叙事、业务背景等输入材料。
- `docs/inputs/`：尚未归类、尚未转成 00-09 的原始输入包。

这对模板维护者和熟悉 PLM 的用户可理解，但对普通用户不友好。用户只想知道“我要给 AI 的原始材料放哪里”，两个入口会造成犹豫：产品想法、brief、愿景、访谈、客户 PRD 到底放 `vision` 还是 `inputs`？

模板应面向用户呈现一个清晰入口：所有用户原始输入先放 `docs/inputs/`。`docs/vision/` 可以保留，但不再作为“用户投递原始材料”的默认入口，而是作为经评审 / 提炼后的产品愿景叙事或长期语义源文档。

## 2. 设计目标

- 面向普通用户只暴露一个输入入口：`docs/inputs/`。
- 避免用户在 `vision` 与 `inputs` 之间犹豫或误放。
- 保留 `docs/vision/product-vision.md` 的兼容性和高级用法。
- 明确 `docs/vision/` 是“整理后的愿景叙事”，不是唯一或默认输入入口。
- 让 review-inputs / generate-docs 优先扫描 `docs/inputs/`，再判断是否需要生成或维护 vision 文档。
- 不破坏已有派生项目中已经使用 `docs/vision/product-vision.md` 的文档链路。

## 3. 推荐目录语义

### 3.1 `docs/inputs/` 作为唯一用户投递入口

用户提供的所有原始材料默认放入：

```text
docs/inputs/
```

包括但不限于：

- 初始 brief、想法草稿、用户口述整理。
- 客户 PRD / SRS / 需求包。
- 访谈记录、会议纪要、外部接口说明。
- 产品愿景草稿、业务叙事、市场材料。
- 现有系统说明、截图说明、流程描述。

建议新手引导直接说：

```text
把你给 AI 的原始材料先放到 docs/inputs/。
```

### 3.2 `docs/vision/` 作为可选整理产物

`docs/vision/` 保留，但定位调整为：

- 可选的产品愿景叙事 / 长期业务图景。
- 通常由 AI 或团队从 `docs/inputs/` 评审、提炼、确认后生成。
- 不直接驱动开发，仍需经 `00-09` 追溯链。
- 不作为普通用户第一投递入口。

推荐口径：

```text
docs/inputs/ 是用户输入入口；docs/vision/ 是可选的整理后愿景叙事。
```

## 4. 入口模式调整建议

当前文档生命周期仍可保留 Vision-first，但应改写触发方式：

- 旧口径：项目可从 `docs/vision/product-vision.md` 开始。
- 新口径：项目默认从 `docs/inputs/` 输入包开始；若输入包中包含完整产品愿景，AI 可提炼为 `docs/vision/product-vision.md`，再进入 Vision-first 或 Scenario-first。

入口模式建议：

| 模式 | 用户材料默认位置 | 说明 |
|---|---|---|
| Inputs-first | `docs/inputs/` | 默认模式，先评审输入包，再判断文档剖面 |
| Vision-first | `docs/inputs/` 或已存在 `docs/vision/product-vision.md` | 若已有成熟愿景叙事，可继续使用；新项目不要求用户先放 vision |
| PRD / SRS-first | `docs/inputs/` | 客户 PRD / SRS 先作为输入包，经评审后进入 00-09 |
| Existing-system | `docs/inputs/` | 现有系统说明、接口草案、迁移材料先进入输入包 |

## 5. 拟改范围

- `docs/README.md`：将“人工输入（原料）”入口改为 `docs/inputs/`；`docs/vision/` 改为可选整理产物 / 产品愿景叙事。
- `ai/global-rules.md`：调整产品愿景源文档规则，说明用户原始材料先放 `docs/inputs/`，需要长期愿景叙事时再提炼到 `docs/vision/product-vision.md`。
- `ai/document-lifecycle-rules.md`：新增或重命名入口模式为 Inputs-first；Vision-first 保留为兼容和高级路径。
- `ai/prompts/docs/01-review-inputs.md`：优先扫描 `docs/inputs/`，识别输入包类型；如材料含完整愿景，建议生成 / 更新 `docs/vision/product-vision.md`。
- `ai/prompts/docs/00-generate-or-complete-docs.md`：默认从 `docs/inputs/` 判断入口模式与文档剖面，不要求用户先创建 `docs/vision/`。
- `ai/commands/review-inputs.md` / `ai/commands/generate-docs.md`：更新用户说法和输入路径提示。
- `template-docs/scenario-guides.md`：新手 / 准备输入材料 / A7.1 场景统一引导用户把原始材料放到 `docs/inputs/`。
- `ai/doc-standards/README.md` 或相关标准说明：避免把 `docs/vision/` 描述为同等原始输入入口。
- `scripts/check-template.sh`：增加关键断言，防止用户入口重新漂移成双入口。
- `template-sync.json`：确认修改文件在同步清单中。
- `VERSION` / `CHANGELOG.md`：按实际落地范围更新。

## 6. 兼容策略

- 不删除 `docs/vision/` 目录规范。
- 不迁移已有派生项目中的 `docs/vision/product-vision.md`。
- 对已有 `docs/vision/product-vision.md` 的项目，继续作为上游输入锚点使用。
- 对新项目和新手引导，默认只告诉用户使用 `docs/inputs/`。
- 如果用户已经把材料放在 `docs/vision/`，AI 应能兼容读取，但建议后续把原始材料归档或引用到 `docs/inputs/`，保留 vision 作为整理后的叙事。

## 7. 验收口径

- 新手文档和场景引导明确：用户原始输入放 `docs/inputs/`。
- `docs/README.md` 不再把 `docs/vision/` 与 `docs/inputs/` 并列为同等“人工输入”入口。
- `docs/vision/` 被描述为可选整理产物 / 产品愿景叙事，不是默认投递入口。
- `review-inputs` 优先扫描 `docs/inputs/`，并能建议是否需要提炼 `docs/vision/product-vision.md`。
- `generate-docs` 不要求用户先创建 vision 文档；可从 inputs 包推导文档剖面。
- 旧项目已有 vision 文档仍兼容，不被要求迁移或删除。

## 8. 风险与缓解

- **破坏已有 Vision-first 习惯**：保留 Vision-first，只改变用户默认入口表达。
- **丢失愿景叙事价值**：vision 不删除，只改为整理后的语义源文档。
- **输入包变得过杂**：`review-inputs` 负责归类、锚定和建议拆分，必要时生成 vision / decisions / research / meetings。
- **文档引用更新范围大**：通过 `scripts/check-template.sh` 加断言，确保 README、prompts、scenario 口径一致。

## 9. 实施补充：输入材料评审闭环

实施时按人工补充要求，将本提案从“入口统一”扩展为“任意输入 → 愿景就绪评估 → 缺口补齐 → 复评 → product-vision → 00-09”的闭环机制：

- `docs/inputs/` 为空时，AI 不得编造愿景或 00-09，必须输出最小输入内容清单供用户逐项确认。
- 任意输入材料先经 `ai/prompts/docs/01-review-inputs.md` 评估是否足以生成 / 更新 `docs/vision/product-vision.md`。
- 不足时输出评估报告建议路径：`docs/inputs/input-review-report.md` 或 `docs/inputs/<topic>/input-review-report.md`。
- 评估报告必须包含缺口矩阵、AI 建议与依据、最小补充清单和需人工确认项。
- 用户补齐后必须再次走输入评审流程，评审通过后再生成 / 更新 product-vision，并由 product-vision 驱动 00-09 文档体系。

## 10. 归档与 issue 处理

- 本提案落地并经 PR 合并后，移动到 `_archive/proposals/`。
- 若实施中发现需要迁移已有标准文档或示例，应在本提案中记录兼容策略，不直接删除旧入口。
