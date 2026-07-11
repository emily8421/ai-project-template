# TEMPLATE-UPGRADE: 普通派生项目版本治理

> 来源：模板维护者（2026-07-11 B 阶段 agent-system-template 同步试跑 + 派生版本管理设计讨论）
> 状态：部分落地（DV-001 路线 A 已定；DV-003 / DV-004 最小机制已进入 v1.46.0；试点反馈待补）
> 目标版本：v1.46.0（普通派生双版本最小机制）
> Release impact：minor（改变普通派生项目版本语义与同步脚本行为；向后兼容旧语义）
> Release strategy：**单独一条线**——只管「母模板 → 普通派生项目」；领域模板版本治理在 inheritance Batch 3 / C-004 独立处理，不在本提案混入（避免污染）

## 1. 背景

`v1.42.1` 的 `version-governance`（已归档）确立了 `VERSION` 作为「派生项目同步审计入口」——派生项目 `VERSION` = 同步到的母模板版本。该机制保证同步可审计，但**只考虑了母模板自身版本治理（验证模板用），没有考虑普通派生项目自身的版本管理需求**。

普通派生项目（如 `zhiyan-digital-cs-platform` v1.43.0、`digital-cs-demo` v1.30.4）有自己的功能演进，需要记录自身版本。但当前 `VERSION` 被 sync 占用（记继承版本），自身版本无处记录；且每次 sync 覆盖 `VERSION`。

结论：**普通派生项目需要双版本——继承的母模板版本 + 项目自身版本**。当前母模板没有这个规范。

**范围边界（重要）**：本提案只管「母模板 → 普通派生项目」这条线。「母模板 → 领域模板 → 领域派生项目」是**独立另一条线**，其版本治理在 `_proposals/TEMPLATE-UPGRADE-domain-template-inheritance.md` Batch 3 / C-004 + `domain-template-lab` 独立处理，**不在本提案混入**，避免两条线互相污染。

## 2. 目标

1. 建立普通派生项目的双版本治理：既记录继承的母模板版本，又维护项目自身版本。
2. 明确 `VERSION` 语义（路线 A：`VERSION` 记自身版本），消除 sync 覆盖冲突。
3. 提供自身版本 + 继承版本的记录位置，避免每个项目自治发明。
4. 让 sync 不破坏项目自身版本。
5. 向后兼容：现有派生项目可不强制立即迁移。

## 3. 非目标

- **不处理领域模板的版本治理**（见 inheritance Batch 3 / C-004，独立线）。
- 不强制所有现有派生项目立即迁移；v1.46.0 先提供可选兼容机制，试点反馈后再评估是否设为硬默认。
- 不推翻三段式版本号（`vMAJOR.MINOR.PATCH`）。
- 不改变 sync 提交格式 `sync template vX.Y.Z`。
- 不强制历史派生项目重写版本。
- 不改变领域模板版本治理；普通派生项目的精简 `TEMPLATE-BASE.md` 不等同于领域模板 `TEMPLATE-BASE.md`。

## 4. 设计候选（普通派生项目线）

### 4.1 双版本语义（路线 A，已定 DV-001）

| 维度 | 含义 | 记录位置 | 更新方 |
|---|---|---|---|
| 项目自身版本 | 派生项目自己的演进版本 | `VERSION` | 项目自治 bump |
| 继承版本 | 同步到的母模板版本 | `TEMPLATE-BASE.md`（或类似） | sync 更新 |

### 4.2 继承版本记录位置

普通派生项目用一个文件（候选 `TEMPLATE-BASE.md`）记录继承关系：
- 继承自哪个母模板（仓库 + 远端）
- base version（派生时的母模板版本，溯源锚点）
- 当前同步到（最近一次 sync 的母模板版本）

> **与领域模板的区别（两条线独立）**：领域模板的 `TEMPLATE-BASE.md` 含「叠加领域标准件」字段；普通派生项目**无此字段**。普通派生的是精简版（只记继承关系），不和领域模板混。

### 4.3 sync 版本保留（DV-003）

路线 A 下 `VERSION` 记自身版本，sync 不能再覆盖 `VERSION`。机制候选：
- v1.46.0 落地：`scripts/sync-template.* --preserve-project-version` 在普通派生项目中跳过 `VERSION` / `CHANGELOG.md`，并新增 / 更新 `TEMPLATE-BASE.md` 记录继承模板版本；提交信息仍保持 `sync template vX.Y.Z from ai-project-template`。
- 兼容旧语义：不传 `--preserve-project-version` 时，仍按 `template-sync.json` 同步 `VERSION` / `CHANGELOG.md`，用于尚未迁移或人工明确沿用旧语义的项目。

### 4.4 迁移（DV-004）

现有派生项目（`VERSION` 当前记继承版本）切换到路线 A 的最小指引：
- 先确认当前项目是否需要自身版本；若需要，后续同步命令改用 `--preserve-project-version`。
- 第一次采用路线 A 时，脚本会新增 `TEMPLATE-BASE.md`，将本次目标模板版本写为 `Current synced template version`；`VERSION` 保留为项目自身版本起点，通常可沿用迁移前的三段式值，不强制重写历史。
- 后续同步报告记录 `VERSION`（项目自身版本）与 `TEMPLATE-BASE.md`（继承模板版本）两个字段。
- 若项目暂不需要自身版本，可继续旧语义，但应在同步报告中说明。

## 5. 待确认项

| ID | 待确认项 | AI 建议 | 建议依据 | 备选 | 取舍 |
|---|---|---|---|---|---|
| DV-001 ✅ | `VERSION` 语义 | **已定路线 A**：`VERSION` 记自身版本，继承版本用 `TEMPLATE-BASE.md` | 自身版本是项目主权，应占主版本位 | ~~路线 B~~ | 改 `VERSION` 语义影响现有派生项目（见 DV-004） |
| DV-003 ✅ | sync 版本保留机制 | v1.46.0 已落地：`--preserve-project-version` 跳过 `VERSION`/`CHANGELOG.md` 并维护 `TEMPLATE-BASE.md` | 不拆新清单，脚本行为显式 opt-in，兼容旧项目 | 专属同步清单；自动角色识别 | opt-in 需要 Prompt / 报告提示，避免用户忘加参数 |
| DV-004 ✅ | 现有派生项目迁移指引 | v1.46.0 已落地最小迁移指引；不强制历史项目立即迁移 | 平滑过渡；减少破坏性版本重写 | 强制迁移 | 不强制则新旧并存一段，需在同步报告中说明 |

## 6. 与其他提案 / 线的关系（不混）

- **version-governance（v1.42.1 已归档）**：本提案是其演进——补全「普通派生项目自身版本」维度。
- **inheritance Batch 3 / C-004（独立线）**：管领域模板版本治理。本提案**不重复、不混入**。两条线独立。
- **domain-template-lab（独立线）**：领域模板实验线，不涉及普通派生。

## 7. 验收标准（候选阶段）

- 能说明普通派生项目为何需要双版本，并指出 `version-governance` 盲区。
- 能给出 `VERSION` 语义（路线 A）+ 继承版本记录位置。
- 能说明与领域模板版本治理（inheritance）的边界——两条线独立不混。
- v1.46.0 后可通过 `--preserve-project-version` 路径验证 DV-003 / DV-004；试点反馈后再决定是否归档本提案。

## 8. 建议后续步骤

1. 在 1-2 个普通派生项目（如 zhiyan）试点 `--preserve-project-version` 路线 A。
2. 观察 `TEMPLATE-BASE.md` 字段是否足够、同步报告是否能清楚区分项目版本 / 继承版本。
3. 若试点稳定，再评估是否把普通派生项目同步默认命令永久切到 `--preserve-project-version`，并归档本提案。
