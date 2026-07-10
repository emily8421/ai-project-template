# TEMPLATE-UPGRADE: 领域模板派生场景引导

> 来源：2026-07-09 维护会话中关于 `agent-system-template` 独立领域模板创建流程的复盘
> 状态：已在本 PR 落地，合并后归档
> 目标版本：`v1.44.2`
> Release impact：patch（新增可选场景路由说明，不改变默认流程、不新增 scaffold、不改脚本）
> Release strategy：单独发布；先补 scenario guide 路由，后续实际创建 `agent-system-template` 在独立仓库执行

## 1. 背景

用户确认 `agent-system-template` 应作为独立领域模板仓库创建，不再往母模板 `ai-project-template` 中加入 agent scaffold。随后需要一个通用场景入口，帮助 AI 在用户说“创建 agent 系统模板 / 从母模板派生领域模板”时，不误走普通业务项目创建，也不把领域 scaffold 写回母模板。

现有 `template-docs/scenario-guides.md` 已覆盖 A2 新建普通派生项目、C 维护场景和 A15 回流提案，但缺少“母模板 → 领域模板”的专门路由。

## 2. 目标

- 新增 A20「领域模板派生」场景。
- 明确领域模板派生与普通项目创建的区别。
- 强制先做 Phase 0 预检：脚本能力、目标目录、远端仓库名、工具链、权限。
- 明确推荐独立 `*-template` 仓库，不把领域 scaffold 直接塞进母模板。
- 给出后续创建方案输出契约，但不在本 PR 创建任何新仓库。

## 3. 非目标

- 不创建 `agent-system-template` 仓库。
- 不新增 agent scaffold 文件。
- 不修改 `scripts/new-project.sh`。
- 不新增 `new-project --profile agent-system`。
- 不改变母模板默认项目创建流程。

## 4. 修改范围

| 文件 | 修改 |
|---|---|
| `template-docs/scenario-guides.md` | 新增 A20 领域模板派生场景；A 使用者范围从 A0-A19 扩展到 A0-A20。 |
| `scripts/check-template.sh` | 增加 A20 和关键短语断言，防止场景路由漂移。 |
| `VERSION` / `CHANGELOG.md` | 按 patch 记录本次场景路由增强。 |

## 5. 验收标准

- `template-docs/scenario-guides.md` 包含 A20 领域模板派生。
- A20 明确“母模板 → 领域模板 → 具体项目”三层关系。
- A20 明确先做 Phase 0 预检，再执行创建。
- A20 明确不向母模板新增领域 scaffold。
- `scripts/check-template.sh` 通过。

## 6. 后续动作

本 PR 合并后，用户若继续执行 `agent-system-template` 创建，应进入 A20：

1. 复核 `scripts/new-project.sh` 能力。
2. 确认目标目录和远端仓库名。
3. 从母模板父目录创建独立仓库。
4. 在新仓库中写 `TEMPLATE-BASE.md`、`README.md`、agent scaffold MVP。
