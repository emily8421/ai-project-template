# TEMPLATE-UPGRADE: check-template 失败诊断输出增强

> 来源：模板维护者（模板仓库内直接发起）。
> 状态：处理中（随 fix/check-template-failure-diagnostics 落地）。
> 目标版本：v1.56.2
> Release impact：patch（自检增强，不改变通过 / 失败判定逻辑、不改变同步结构、不要求派生迁移）。
> Release strategy：单独发布。

## 1. 背景与问题

`scripts/check-template.sh` / `scripts/check-template.ps1` 是模板仓库完整性自检（CI 权威 + Windows 入口）。当某条 `require_contains` / 文件内容断言失败时，旧实现只输出断言 message（如「X 文件应包含 Y」），**不告诉用户失败的具体文件路径、所用的正则风格，也不给复现命令**。

后果：

- **失败定位成本高**：用户看到 message 后，仍需手动翻脚本找对应 `require_contains`、确认文件路径、手敲 `grep` 复现。
- **正则风格陷阱**：`check-template.sh` 的 `require_contains` 用 `grep -Eq`（**ERE**，`|` 表或、`.` 表任意、元字符按字面匹配需转义）；`check-template.ps1` 的 `Select-String -Pattern` 用 **.NET regex**。两者风格不同，但旧失败输出都不提示，导致加断言或排查时容易写错 pattern（该转义的 `.` 没转义，或误用 BRE 语法）。
- 这属于「失败但无法自调试」的自检可用性缺口，与 v1.26.2 / v1.27.4 自检可维护性方向一致（让自检更易定位、更少歧义）。

## 2. 建议方案

失败分支就地补足诊断信息，不改判定逻辑、不改断言集合的通过条件：

- **`scripts/check-template.sh`**：
  - `require_contains` 失败时，除原有 message 外，打印 `file`、`expected ERE pattern`、`reproduce: grep -En -- <pattern> <file>`，并附文件头 5 行预览，便于一眼定位。
  - 新增 `print_pattern_hint` helper 集中上述输出。
  - 在 `require_contains` 上方加注释，明确 `grep -Eq` 使用 ERE（`|` 表或；仅按字面匹配元字符时才转义）。
- **`scripts/check-template.ps1`**：
  - `Invoke-NativeTemplateCheck` 失败时，追加 `(file: <相对路径>; expected .NET regex pattern: <pattern>)`。
  - 上方加注释，明确 `Select-String -Pattern` 使用 .NET regex（与 Bash ERE 风格不同）。
- **自检锁死**：`check_script_entrypoints` 新增 5 条 `require_contains` 断言，锁定上述输出关键词（`expected ERE pattern` / `reproduce: grep -En` / `Extended Regular Expressions` / `Select-String uses .NET regular expressions` / `expected .NET regex pattern`），防止输出被后续改动悄悄回退。

## 3. 拟改范围

- 修改：`scripts/check-template.sh`（新增 `print_pattern_hint` helper、`require_contains` 失败输出、ERE 注释、5 条自检断言）
- 修改：`scripts/check-template.ps1`（失败输出追加 pattern/file + .NET regex 注释）

## 4. 影响面

- `check-template.sh` / `check-template.ps1` 均在 `template-sync.json` 同步清单内，本次改动会下行同步到派生项目。
- 行为变化仅在**失败分支的输出**：通过路径完全不变；既有断言的通过 / 失败判定不变。
- `.ps1` 仍为简化 fallback，不镜像 `.sh` 全部断言（v1.26.2 既定边界，本次不动）。

## 5. 版本影响

`patch`：自检失败诊断输出增强属于「自检增强 / 补断言」，按 CONTRIBUTING §4 默认 patch；不新增下游采用面、不改变默认行为 / 同步结构 / 下游必做流程。`v1.56.1 → v1.56.2`。

## 6. 验证方式

- grep 等价复验 5 条新断言（`require_contains` 语义 = `grep -Eq`）：已 PASS。
- `scripts/check-markdown-clean.ps1 _proposals ai-records`：本提案 / 记录 Markdown 预检。
- CI（`.github/workflows/template-check.yml`）运行完整 `check-template.sh`：权威验证（本地 Windows 受 `require_new_project_local_smoke` 耗时影响，以 CI 为准）。

## 7. 非目标

- 不改通过 / 失败判定逻辑、不改断言集合的判定条件。
- 不改 `template-sync.json` 结构、不新增同步文件。
- 不新增命令入口、不新增 `template-docs` 说明文档（最小方案；输出即文档）。
- 不让 `.ps1` fallback 镜像 `.sh` 全部断言（保持既定边界）。
- 不处理 `require_new_project_local_smoke` 在本地 Windows 耗时较长的问题（独立议题，超出本次范围）。
