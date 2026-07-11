# TEMPLATE-UPGRADE: Windows 新手 smoke-test 真实体验跟进

> 来源：模板维护者
> 状态：候选 / 小修待落地
> 目标版本：待确认
> Release impact：patch（AI 建议，待维护者确认）
> Release strategy：优先修复 2026-07-10 本地 smoke-test 发现的入口提示偏差，不改变模板治理流程或同步边界

## 1. 背景

2026-07-10 按 `template-docs/smoke-test.md` 执行 Windows 本地新手链路烟测，主链路通过：

- `scripts/check-prereqs.ps1` 可运行并输出 Required / Recommended / Optional / Summary / Suggested next steps。
- 使用 Git Bash 全路径可运行 `scripts/new-project.sh smoke-demo --local --no-remote`，成功创建本地项目并生成初始提交。
- 派生项目内 `scripts/collect-env.ps1` 可生成 `docs/env/local-env.md`。
- 派生项目 README 能引导环境准备、环境采集、输入材料、`ai/project-rules.md`、`/run review-inputs` 与 `/run generate-docs`。

同时发现 3 个新手体验偏差，均属于提示层小修，不涉及规则重构。

## 2. 发现问题

1. 当前机器上 PowerShell 的 `bash` 命令解析到 Windows / WSL stub，运行时报 `E_ACCESSDENIED`；`template-docs/smoke-test.md` 只写了“找不到 bash 时改用 Git Bash”，未覆盖“找得到但不可用”的情况。
2. `scripts/check-prereqs.ps1` 在 Required 全部通过时仍默认建议运行 `scripts/bootstrap-dev-env.ps1`，容易让新手误以为还必须安装或重装工具。
3. `scripts/new-project.sh` 完成提示仍写“填写 docs/00-scenario.md ~ 02-srs.md，运行 collect-env，再按 README 推进”，与当前 README 的“先环境采集 / 准备输入 / review-inputs / generate-docs”链路不完全一致。

## 3. 拟改范围

| 文件 | 拟改 |
|---|---|
| `template-docs/smoke-test.md` | 补充 `bash` 指向 WSL stub 或报 `E_ACCESSDENIED` 时改用 Git Bash 全路径；常见失败点同步更新。 |
| `scripts/check-prereqs.ps1` | Required 全通过时不再默认建议运行 bootstrap；仅在缺 Required 或想补 Recommended 工具时提示 bootstrap。 |
| `scripts/new-project.sh` | 更新创建完成后的后续提示，指向环境采集、输入材料、`ai/project-rules.md`、`review-inputs` / `generate-docs`。 |

## 4. 非目标

- 不调整 `ai/index.md` 或生命周期规则。
- 不改变 `scripts/new-project.sh` 的建仓逻辑。
- 不改变 `template-sync.json` 同步清单。
- 不解决 Linux / macOS smoke-test 覆盖问题。

## 5. 验证方式

1. 运行 `powershell -ExecutionPolicy Bypass -File scripts/check-prereqs.ps1`，确认 Required 全通过时下一步不再误导用户必须跑 bootstrap。
2. 使用 Git Bash 全路径运行 `scripts/new-project.sh smoke-demo --local --no-remote`，确认完成提示与 README 链路一致。
3. 在 `smoke-demo` 中运行 `scripts/collect-env.ps1`，检查 `docs/env/local-env.md` 与 README 入口。
4. 清理 `smoke-demo/`。
5. 运行模板自检。

## 6. 待确认项

| ID | 待确认项 | AI 建议 | 建议依据 | 备选方案 | 取舍影响 / 阻塞关系 |
|---|---|---|---|---|---|
| C-001 | 是否把 WSL stub 识别写入前置检查脚本 | 建议写入，并作为 Conditional 提示而非 Required 阻塞 | 本地烟测实证 `bash` 可存在但不可用于模板 Bash 脚本；Git Bash 全路径可用 | 只在 smoke-test 文档说明 | 脚本输出更直接；不阻塞本地 smoke-test |
| C-002 | Required 全通过时是否仍提示 bootstrap | 建议不再默认提示，只在缺 Required 或补 Recommended 时提示 | 默认提示 bootstrap 会让新手误判“还缺步骤” | 保留原提示 | 原提示简单但误导；修正后 next steps 更符合实际 |
| C-003 | new-project 完成提示是否直接提 docs/00-02 | 建议改为先看 README 的环境与输入评审链路 | 当前 README 已把输入评审和 generate-docs 作为入口，直接填写 00-02 容易绕过评审 | 保留旧提示 | 修正后与 README / SOP 更一致 |

## 7. 验收标准

- 新手在 Required 全通过时能看出可以继续本地 smoke-test，而不是必须运行 bootstrap。
- `bash` 存在但不可用时，用户能从 smoke-test / check-prereqs 输出知道改用 Git Bash 全路径。
- `new-project.sh` 完成提示与派生项目 README 的快速开始链路一致。
- 模板自检通过。
