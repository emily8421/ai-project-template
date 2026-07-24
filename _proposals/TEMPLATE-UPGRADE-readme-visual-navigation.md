# TEMPLATE-UPGRADE：README 轻量可视化导航（mermaid）

> 来源：模板维护者（双 AI 综合评估 P2，见 `TEMPLATE-UPGRADE-2026-07-24-batch-overview.md`）
> 状态：候选（待评估 → 处理中）
> 目标版本：待确认（建议 patch）
> Release impact：patch（AI 建议，待维护者确认）—— 文档导航补强，不改默认行为
> Release strategy：同主题聚合（可与 `engineering-diagram-review` 同窗口）

## 1. 动机（WHY）

模板仓根 `README.md` 全文纯文字，无架构图、流程图、交互图。新访客（使用者 / 维护者）难以一眼把握「模板分层结构、文档驱动设计流程、使用与维护流程」。补 2-3 个轻量 mermaid 图可显著降低上手门槛，且与模板既有图表偏好（`project-rules §2.6` 默认 mermaid、`document-lifecycle-rules §13`）一致。

约束：根 README 是模板仓自身文档，**不纳入下行同步清单**（`ai/global-rules.md:102`：各项目自维护 README）。因此图要兼顾两个目的：① 让模板仓访客看懂；② 可同步的部分放 `template-docs/` 供派生项目参考。

## 2. 现状证据（file:line）

| 现状 | 证据 |
|---|---|
| README 纯文字，无图 | 根 `README.md`（能力 / 快速开始 / 目录速览，无任何图） |
| 根 README 不进同步清单 | `ai/global-rules.md:102` |
| 细节文档已存在（图应指向它们） | `template-docs/beginner-guide.md`、`template-docs/scenario-guides.md`、`template-docs/template-methodology.md` |
| 模板默认图表格式 mermaid | `ai/project-rules.md:62-66`（§2.6）、`ai/document-lifecycle-rules.md:530-546`（§13） |

## 3. 拟改（WHAT）

在 `README.md` 加 **2-3 个轻量 mermaid 图**，保持 README 简洁，细节指向已有文档：

1. **模板分层架构图**：`ai/`（规则层）/ `docs/`（事实层）/ `template-docs/`（手册层）/ `scripts/`（能力层）/ `_proposals/`+`sync`（治理与双向闭环）的分层与依赖关系。
2. **文档驱动设计流程图**：`docs/inputs/ → vision → 00-09 → design → 08 Sprint → 09 验收 → 代码` 的主链（对齐 `document-lifecycle-rules §2` PLM 链）。
3. **使用 / 维护流程图**：使用者路径（场景 → 命令 → 文档 → 代码）与维护者路径（提案 → 分支 → PR → 同步）的双向闭环（对齐 `CONTRIBUTING §2`）。

原则：
- 图保持轻量（每张 ≤ ~15 节点），**不展开维护细节**，细节留 `beginner-guide` / `scenario-guides` / `template-methodology`。
- 用 mermaid（默认），确保 GitHub / IDE 可渲染。
- 同时在 `template-docs/` 放一份可同步的「模板架构」图源（如 `template-docs/template-architecture.md` 或并入 `template-methodology.md`），供派生项目参考模板分层。

## 4. 版本影响

**patch**。文档导航补强，不改默认行为、不改同步清单结构。新增 `template-docs/` 图源属补充说明。

## 5. 影响面（拟改文件）

| 文件 | 改动 |
|---|---|
| `README.md` | 加 2-3 个 mermaid 图（分层架构 / 设计流程 / 使用维护流程） |
| `template-docs/template-methodology.md`（或新增 `template-architecture.md`） | 可同步的架构图源 |
| `template-sync.json` | 若新增 template-docs 图源文件，登记同步 |

## 6. 待确认项

| ID | 待确认 | AI 建议 | 依据 |
|---|---|---|---|
| RV-1 | 图内联 README vs 引用 template-docs | README 内联轻量版 + template-docs 存可同步源 | README 不进同步但访客要看 |
| RV-2 | 几张图、各自范围 | 3 张：分层架构 / 设计流程 / 使用维护 | 覆盖提案 2 三个诉求 |
| RV-3 | 是否新增独立 template-architecture.md | 并入 template-methodology.md，避免文件膨胀 | CONTRIBUTING §7 文件不膨胀 |

## 7. 落地流程

1. 确认 §6 后，在维护分支改 README + template-docs。
2. 本地预览 mermaid 渲染（GitHub 风格）。
3. `scripts/check-template.sh` 自检。
4. PR 评审（重点：图是否过重、是否与 §13/§2.6 一致、细节是否正确指向已有文档）。
5. 合并后 patch 版本递增 + CHANGELOG，下行同步（template-docs 图源部分）。

## 8. 验证方式

- `scripts/check-template.sh` 通过。
- README mermaid 在 GitHub 可渲染、节点数克制。
- 图中流程与 `document-lifecycle-rules §2`、`CONTRIBUTING §2` 文字描述一致。

## 9. 关联

- 评估总览：`TEMPLATE-UPGRADE-2026-07-24-batch-overview.md`（提案 2）。
- 关联 `engineering-diagram-review`：README 图也遵循「可渲染 / 可追溯」准则，可作为模板自身 dogfood 样本。
