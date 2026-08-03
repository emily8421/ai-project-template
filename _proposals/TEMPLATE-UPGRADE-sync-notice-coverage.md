# TEMPLATE-UPGRADE: Sync notice 覆盖扩展到脚本 / mdc + json 自声明

> 来源：模板维护者
> 状态：候选（v2，已吸收评审 P1-3 / P2-3 / P2-4）
> 目标版本：待确认（AI 建议：patch → v1.59.3，或并入 `project-rules-layering` 同版本）
> Release impact：patch（AI 建议，待维护者确认）
> Release strategy：单独发布（自洽闭环）/ 并入 `project-rules-layering` 同 PR
> 关联：由 `TEMPLATE-UPGRADE-project-rules-layering.md` §10.2 拆出并吸收 json 自声明（P2-4）；Sync notice 规则见 `MAINTAINERS.md` L62

## 1. 背景与问题

`MAINTAINERS.md` L62 规定同步文件须含 Sync notice，但 `check-template.sh` 与 **`check-template.ps1`** 的强制检查（L294-298）**只匹配 `*.md`**，外加三个硬编码入口。核实清单内非 md 文件大多无"会被覆盖/勿改"声明：`new-project.sh`、`collect-env.ps1`、`check-prereqs.ps1` 等脚本，以及 `template-sync.json` 本身。`VERSION`（纯版本号）和 `template-sync.json`（json 不能加注释）需特殊处理。

本提案负责**让所有"会被下行同步覆盖"的文件都有勿改声明**，自洽闭环（P2-4）：可注释文件（`.md/.mdc/.sh/.ps1`）加头部 notice；不可注释的 json 靠 `description` 字段自声明。

## 2. 设计目标

- 所有会被同步覆盖的可注释文件（`.md/.mdc/.sh/.ps1`）带"勿直接改、同步会覆盖"声明。
- json 文件用 `description` 字段承载同等声明（不能内嵌注释）。
- 不破坏 `.mdc` frontmatter、`VERSION` 语义。
- 自检（`check-template.sh` **+ `check-template.ps1`**）强制覆盖扩展后范围，防回归。

## 3. 建议方案

### 3.1 扩展强制范围（Bash + PowerShell）

`check-template.sh` 的 `require_sync_notice()`（L210-223）**与 `check-template.ps1` 的 notice 循环（L294-298）** 都从仅 `*.md` 扩展到 `*.md` / `*.mdc` / `*.sh` / `*.ps1`（P1-3）。两脚本必须成对改（MAINTAINERS L68）。

### 3.2 各文件 notice 形式与位置

- `.md`：现有 `> Sync notice: ...` blockquote（不变）。
- `.mdc`：**notice 必须在 frontmatter 之后**（`.cursor/rules/project-rules.mdc` 第 1 行是 `---` frontmatter，notice 现位于 `:7`，结构正确，保持）（P2-3）。
- `.sh`：shebang 之后 `# Sync notice: ...` 注释块。
- `.ps1`：合并进现有 `<# ... #>` 头部注释块（不新开，避免重复）。

notice 文案统一含义："本文件由 ai-project-template 模板同步维护，派生项目同步时会被覆盖；不应直接修改，通用改进请经 `_proposals/` 回流模板仓库。"

### 3.3 json 自声明（P2-4，从主提案移入）

`template-sync.json` 无法内嵌注释，其"会被覆盖/勿改"声明改由 `description` 字段承载：

```
"description": "ai-project-template 下行同步的模板方法论文件清单；派生项目同步时这些文件会被覆盖，不应直接修改（通用改进请经 _proposals/ 回流）；项目专属内容（ai/project-rules.md / ai/domain-rules.md / docs/ / 业务代码）不在此列。"
```

这让 json 文件与其它同步文件一样有"勿改"声明，补全 notice 体系的 json 侧缺口。

### 3.4 豁免（不加内嵌 notice，显式说明）

- `VERSION`：程序读取的纯版本号，加注释破坏语义；豁免，并在自检维护豁免名单；其"会被覆盖"语义由 `template-sync.json` 的 description（§3.3）间接覆盖。
- `upstream/CHANGELOG*.md`：sync 自动生成的继承参考，属派生自有产物；核实后决定是否豁免。

### 3.5 自检豁免名单

`check-template.sh`+`.ps1` 增豁免名单（`VERSION` 等），明确"因格式原因不加内嵌 notice，声明由 `template-sync.json` description 承载"。

## 4. 拟改范围

- `scripts/check-template.sh` **+ `scripts/check-template.ps1`**：notice 强制后缀扩展（`.mdc/.sh/.ps1`）+ 豁免名单（P1-3）。
- 各清单内 `.sh`/`.ps1` 脚本：补头部 Sync notice（`new-project.sh`、`collect-env.ps1`、`check-prereqs.ps1` 等）。
- `template-sync.json`：`description` 字段补自声明（§3.3）（P2-4）。
- `MAINTAINERS.md` L62：Sync notice 规则从"Markdown 文件"扩展为"可注释方法论文件（.md/.mdc/.sh/.ps1）+ json 用 description 自声明"，记录豁免（VERSION）。
- `git-guide.md` / `CONTRIBUTING.md`：边界说明同步（脚本/json 也会被覆盖）。

## 5. 验收口径

- 清单内所有 `.md`/`.mdc`/`.sh`/`.ps1` 文件含 Sync notice；`.mdc` 的 notice 在 frontmatter 之后（不要求第一行）（P2-3）。
- `template-sync.json` 的 `description` 含"会被覆盖/勿改"自声明（P2-4）。
- `VERSION` 在豁免名单内，自检不报缺 notice。
- `check-template.sh` **+ `check-template.ps1`** 均通过；新增/删除清单内脚本时 notice 缺失会被两脚本拦截（P1-3）。
- 各脚本 notice 不破坏执行（shebang 之后、正确注释语法）；`.mdc` frontmatter 保持最前。

## 6. 风险与缓解

- **脚本 notice 破坏执行**：notice 在 shebang 之后、正确注释语法；落地后实跑各脚本验证。
- **`.ps1` 注释冲突**：合并进现有 `<# #>` 块，不新开。
- **`.mdc` frontmatter 误伤**：验收口径明确"frontmatter 之后含 notice"，不要求第一行（P2-3）。
- **json description 语义漂移**：description 是程序读取字段，改其文案不影响解析（`files`/`files_all` 等字段不变）；落地后 `check-template.sh`+`.ps1` 确认 json 仍解析正常。
- **清单演进遗漏**：两脚本强制范围扩展后，新加清单的脚本忘加 notice 会被拦截（本提案目的）。
- **与主提案边界**：本提案管"notice 文本覆盖 + json 自声明"；三组分类、派生 TEMPLATE-BASE 指针归 `project-rules-layering` §10，不在此重复。
