# TEMPLATE-UPGRADE: README 补术语表入口与场景数修正

> 来源：模板维护者（用户审核 README 要求）
> 状态：进行中（本维护分支落地）
> 目标版本：不 bump
> Release impact：none
> Release strategy：单独发布

## 1. 背景

审核根 `README.md` 发现：

- **术语表无独立入口**：`template-docs/glossary.md` 仅在「目录速览」`template-docs/` 行内以反引号路径出现一次，无独立入口、无说明它是什么 / 给谁用。`beginner-guide.md` §7 有「查术语 → glossary」导航，但 README（主入口）缺失。
- **场景数过时**：「快速开始」写「23 场景剧本」，但 `scenario-guides.md` 现状为 A0–A20（含 A5.5 / A7.5 / A8.5）+ C1–C8 + M0 / M1，「23」不准确。

## 2. 拟改（根 `README.md`，不在 sync 清单）

- 「快速开始」新增入口「**查术语什么意思** → `template-docs/glossary.md`（PLM / SRS / REQ-ID / Phase / Sprint 等核心术语短定义 + 权威源指针）」。
- 「快速开始」场景数 `23 场景剧本` → `覆盖 A0–A20 / C1–C8 / 元场景`（避免数字漂移）。
- 「目录速览」`template-docs/` 行：`glossary.md`（反引号路径）→ `glossary（术语表）`（与 scenario-guides 等命名 + 说明风格一致）。

## 3. 版本影响

**none**：根 `README.md` 不在 `template-sync.json`（MAINTAINERS §4：派生项目根 README 是项目专属，不参与下行同步）。本次只改模板仓入口文档的导航，不改 sync 范围文件、不改模板行为、不影响下游同步判断，故不 bump `VERSION`。

## 4. 验证

`bash scripts/check-template.sh`（README 相关断言仍过，本次只增入口不减现有导航）；人工核对术语表入口与场景数描述。
