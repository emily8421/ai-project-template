# 工作空间根目录结构事实补正与实施前核对清单（minimax-m3）

> **定位**：本文件是 [2026-08-21-workspace-root-structure-meta-eval-minimax-m3.md](./2026-08-21-workspace-root-structure-meta-eval-minimax-m3.md) §6.2 列出的 4 项必做事实审计的产出。**只读核对完成**，事实已与实际文件对齐；本文件**不修改**前面三份评估文件，是它们的"事实补正层"。
> 关联文件：
> - [`2026-08-21-workspace-root-structure-assessment-gpt-5.6-terra.md`](./2026-08-21-workspace-root-structure-assessment-gpt-5.6-terra.md)
> - [`2026-08-21-workspace-root-structure-eval-minimax-m3.md`](./2026-08-21-workspace-root-structure-eval-minimax-m3.md)
> - [`2026-08-21-workspace-root-structure-meta-eval-minimax-m3.md`](./2026-08-21-workspace-root-structure-meta-eval-minimax-m3.md)
> 评估者：minimax-m3。

## 1. 核对结论摘要

| 编号 | 核对项 | 关键发现 | 提案影响 |
|---|---|---|---|
| V-1 | `scripts/new-project.sh` 全文 | 全量复制 + 选择性 `rm -f`/`rmdir`；--shape 已在 root 层裁剪 `frontend/backend/tests/docker` | 方案 B 需更新 --shape 的 rm 路径到 `project/` 子层；并改写脚本生成的 README 模板中所有 `docs/...` 引用 |
| V-2 | `template-sync.json` 全文 | files_all 156 项，其中仅 2 项涉及 `docs/`（`docs/README.md` + `docs/inputs/README.md`）；`description` 字段含 "docs/" 通用声明 | 方案 B 需改 2 处文件路径 + `description` 字段 |
| V-3 | `template-docs/docs-scaffold/` 模板 | 00-09 + decisions/design/inputs/research/vision + README.md 三层定位表 | 方案 B 需把"项目结构定位表"的"项目事实"指向从 `docs/00-09` 改为 `project/docs/00-09`；其他模板可不动 |
| V-4 | `git-guide.md` §5 派生项目同步 | §5.2/§5.8 明示禁止路径含 `docs/00-09` 与 `frontend/backend/tests/docker`；§5.4.1 写明派生项目用 `project-check.yml` | 方案 B 需更新禁止路径正则 + §5 文档中的所有路径引用 |

**总判断**：方案 B 的事实影响面**比 minimax-m3 自评 §6 列出的小**，但**比 minimax-m3 自评描述的更精确**——影响点收敛到 4 类来源：`scripts/new-project.sh`、`template-sync.json`、`docs-scaffold` 文档、`git-guide.md` §5。

---

## 2. V-1：`scripts/new-project.sh` 全文（417 行）核对

### 2.1 实际复制机制

- **本地模式**（第 152 行）：`git -C "$TEMPLATE_DIR" archive --format=tar HEAD | tar -x -C "$TARGET"`
- **远端模式**（第 156-157 行）：`git clone --depth 1 -q "$TEMPLATE_REMOTE" "$TARGET"; rm -rf "$TARGET/.git"`

**订正 minimax-m3 自评 §6 第 1 行**：

> 原：~~`scripts/new-project.sh` 复制根 `docs/` / `frontend/` / `backend/` 等~~
> 正：脚本用 `git archive` 或 `git clone` **全量复制整个模板仓**到 `$TARGET`，再**选择性删除**模板仓专用文件 + 按 `--shape` 裁剪代码目录。

### 2.2 实际裁剪清单

| 阶段 | 操作 | 行号 |
|---|---|---|
| 模板仓专用脚本 | `rm -f` 5 个：`scripts/check-template.sh/.ps1`、`sync-all-derived.sh`、`e2e-sync-check.sh`、`new-project.sh` | 205-209 |
| 模板仓专用文档 | `rm -f` 4 个 + `rmdir`：`template-docs/maintainer/{e2e-regression-checklist.md, e2e-report-template.md, rd-data-chain.md, domain-derived-scenarios-template.md}`；`rmdir template-docs/maintainer` | 214-218 |
| 提案收件箱 | `rm -rf _proposals` + 重写 `_proposals/README.md` | 220-237 |
| GitHub Actions | `write_derived_project_workflow` 删 `template-check.yml` + 写 `project-check.yml` | 84-146 + 239 |
| 派生项目 README | `cat > README.md` **完全覆盖** | 241-348 |
| `--no-examples` | `rm -rf _archive _examples` | 350-352 |
| `--shape docs` | `rm -rf frontend/ backend/ tests/ docker/` + `rm -f docs/06-db-design.md docs/07-api-spec.md` | 356-359 |
| `--shape cli` | `rm -rf frontend/ docker/` | 360-362 |

### 2.3 方案 B 实施时的 `--shape` 改造

如果实施"frontend/backend/tests/docker/tasks 进 `project/`"，`--shape` 裁剪路径需改为：

```bash
if [[ "$SHAPE" == "docs" ]]; then
  rm -rf "$TARGET/project/src/frontend" "$TARGET/project/src/backend" \
         "$TARGET/project/tests" "$TARGET/project/docker"
  rm -f "$TARGET/project/docs/06-db-design.md" "$TARGET/project/docs/07-api-spec.md"
  SHAPE_REMOVED="project/src/{frontend,backend} project/tests project/docker + project/docs/06-db-design.md + project/docs/07-api-spec.md"
elif [[ "$SHAPE" == "cli" ]]; then
  rm -rf "$TARGET/project/src/frontend" "$TARGET/project/docker"
  SHAPE_REMOVED="project/src/frontend project/docker（project/docs/07-api-spec.md 保留）"
fi
```

### 2.4 方案 B 实施时脚本生成的 README 需改路径

`new-project.sh` 第 241-348 行生成的派生项目 README 内嵌约 **30+ 处** `docs/...` 引用，全部需改为 `project/docs/...`。主要位置：

- 快速开始：第 273 行 `docs/inputs/`、第 274 行 `ai/project-rules.md`（不变）、第 275 行 `docs/vision/product-vision.md`、`docs/00-09`、`docs/design/`
- `ai/project-rules.md` checklist：第 296 行 `docs/06-db-design.md` 与 `docs/07-api-spec.md`
- 文档入口段：第 301-311 行（`docs/00-scenario.md`、`docs/inputs/`、`docs/vision/`、`docs/01-09`、`docs/README.md`、`docs/env/local-env.md`、`docs/design/`、`docs/08-dev-plan.md`、`docs/09-verification.md`）
- 模板关系段：第 331 行 "三层区" 表格中 `docs/` → `project/docs/`

**改造成本**：约 1 处 read 全文 + 30+ 处 sed/replace。属于"必须改但机械"的类型。

---

## 3. V-2：`template-sync.json` 全文（163 行）核对

### 3.1 关键观察

- `files_all`：156 项（实际文件路径白名单）
- `files_ordinary`：空数组
- `files_domain`：2 项（`ai/doc-standards/domain-rules.md`、`template-docs/maintainer/domain-derived-scenarios-template.md`）
- `description` 字段明示："项目专属内容（ai/project-rules.md / ai/domain-rules.md / **docs/** / 业务代码）不在此列"

### 3.2 涉及 `docs/` 的同步清单项

精确数：**仅 2 项**：

| 行号 | 当前路径 | 同步目的 | 方案 B 改造 |
|---|---|---|---|
| 143 | `docs/README.md` | 派生项目文档分区规则（治理元数据） | `project/docs/README.md` |
| 144 | `docs/inputs/README.md` | 派生项目输入评审入口说明 | `project/docs/inputs/README.md` |

**`docs/00-scenario.md` ~ `docs/09-verification.md` 不在 files_all**——这是 `description` 字段"docs/ 不在此列"的实证：项目事实文档由派生项目自有维护，模板只同步"规则基线"到 `ai/doc-standards/`，不同步项目事实。

### 3.3 方案 B 实施时 `template-sync.json` 改造

- 改 2 处路径（第 143、144 行）
- `description` 字段第 3 行的 `docs/` 字面引用改为 `project/docs/`
- `check-template.sh` 的 `require_contains "template-sync.json" '"files_all"' ...` 断言不涉及具体路径，**不需要改**

---

## 4. V-3：`template-docs/docs-scaffold/` 核对

### 4.1 目录结构

```text
docs-scaffold/
├── README.md            # 三层定位权威表（项目事实 / 人读结构 / AI 规则基线）
├── 00-scenario.md
├── 01-user-requirements.md
├── 02-srs.md
├── 03-prd.md
├── 04-architecture.md
├── 05-tech-spec.md
├── 06-db-design.md
├── 07-api-spec.md
├── 08-dev-plan.md
├── 09-verification.md
├── decisions/
│   └── ADR-template.md
├── design/
│   ├── frontend-experience-brief.md
│   ├── frontend-interaction.md
│   ├── subsystem-design.md
│   └── ui-prototype-strategy.md
├── inputs/
│   └── input-review-report.md
├── research/
│   ├── docs-open-items.md
│   ├── tech-env-evaluation.md
│   └── ui-prototype-exploration.md
└── vision/
    └── product-vision.md
```

### 4.2 README.md 三层定位表（节选）

README 第 10-19 行表头：

| 位置 | 是否作为项目事实 | 是否作为规则权威源 |
|---|---|---|
| `docs/00-09` | 是 | 否 |
| `template-docs/docs-scaffold/vision/*` | 否 | 否 |
| `template-docs/docs-scaffold/inputs/*` | 否 | 否 |
| `template-docs/docs-scaffold/00-09` | 否 | 否 |
| ... | ... | ... |

**第 49-62 行**的"00-09 核心链路"文件清单明确：每个 scaffold 文件 → 对应项目事实 `docs/00-XX.md`。

### 4.3 方案 B 实施时 `docs-scaffold/` 改造

最小改动原则——这些模板本身**不动**，只改 README.md 的"项目事实"列：

- 第 12 行：`docs/00-09` → `project/docs/00-09`
- 第 49-62 行：8 处 `docs/...` → `project/docs/...`（仅改"对应项目事实文档"列）
- 第 66-74 行（design / decisions / research）：表里也有"推荐落盘位置"列含 `docs/...`，需对应改

**注意**：scaffold 模板的内部内容（如 00-scenario.md 的"上游输入：docs/vision/product-vision.md"等路径）**不动**——这些是项目文档自身的内容，应跟随项目事实文档进 `project/docs/`，由派生项目按需更新。

---

## 5. V-4：`git-guide.md` §5 派生项目同步（141-313 行）核对

### 5.1 §5.2 第 188-191 行（**关键**）

```text
确认 `--dry-run` 输出只涉及 `template-sync.json` 中的模板方法论文件；尤其不应出现：
- `README.md`
- `ai/project-rules.md`
- `docs/00-scenario.md` ~ `docs/09-verification.md`
- `frontend/`、`backend/`、`tests/`、`docker/` 等业务代码或项目专属目录
```

这是**权威声明**：哪些路径绝对不能被 sync-template 改动。

### 5.2 §5.8 第 307 行（**关键**）

```bash
禁止路径：`grep -nE 'README\.md|ai/project-rules\.md|docs/00-09|frontend/|backend/|tests/|docker/' sync.log`
```

这是大同步 dry-run 的"快速判断命令"，grep 命中即视为越界。

### 5.3 §5.4.1 第 248-254 行（CI 行为）

- 模板仓 `.github/workflows/template-check.yml` 只服务模板仓自身
- 派生项目用 `scripts/new-project.sh` 生成的 `.github/workflows/project-check.yml`
- 旧派生项目若有 `template-check.yml` 应迁移或禁用

### 5.4 §5.5 第 263 行（项目件语义）

"根 `README.md` 是项目件，`ai/project-rules.md` 与领域模板仓的 `ai/domain-rules.md` 是项目 / 领域专属规则，均不在 `template-sync.json` 中，不参与模板下行同步。"

**注意**：本句是"项目件**不**参与同步"的声明，方案 B 实施后根 `README.md` 仍为项目件（不变），但 `project/README.md` 是**新文件**，需在 §5 增补说明：`project/README.md` 是项目件，同步不进。

### 5.5 方案 B 实施时 `git-guide.md` §5 改造

| 行号 | 当前 | 改造 |
|---|---|---|
| 188-191 | 禁止路径含 `docs/00-scenario.md ~ docs/09-verification.md` + `frontend/ backend/ tests/ docker/` | 改为 `project/docs/00-scenario.md ~ project/docs/09-verification.md` + `project/src/frontend/ project/src/backend/ project/tests/ project/docker/` |
| 193 | "旧项目残留的 `docs/_scaffold/00-09` 仅作兼容参考" | 增加 "旧项目 `project/docs/_scaffold/00-09` 仅作兼容参考"（如有 scaffold 残留） |
| 252 | "`scripts/new-project.sh` 会为新派生项目生成 `.github/workflows/project-check.yml`" | 不变（脚本行为只在 §6 改） |
| 254 | "旧派生项目若仍保留 `.github/workflows/template-check.yml`" | 不变 |
| 263 | 根 `README.md` 是项目件；`ai/project-rules.md` 是项目专属规则 | 增加 `project/README.md` 是项目件说明 |
| 307 | grep 正则含 `docs/00-09` + `frontend/\|backend/\|tests/\|docker/` | 改为 `project/docs/00-09` + `project/src/frontend/\|project/src/backend/\|project/tests/\|project/docker/` |

**改造成本**：5 处 edit + 1 处说明增补。

---

## 6. 实施前核对清单（提案起草者按此逐项过）

```text
□ V-2 改 2 处 template-sync.json 路径 + 1 处 description 字段
□ V-2 在 files_all 增 1 项 project/README.md（如需同步）或明确不进清单
□ V-1 改 new-project.sh --shape 裁剪路径（4 行）
□ V-1 改 new-project.sh 生成的派生项目 README 模板（30+ 处路径）
□ V-1 验证新 --shape 路径在三种形态下（web/docs/cli）都不破坏首提交
□ V-3 改 docs-scaffold/README.md 三层定位表 + 00-09 落盘表（约 12 处）
□ V-3 验证 scaffold 模板内部"上游输入 / 下游输出"路径无需改（项目事实文档自带）
□ V-4 改 git-guide.md §5.2 禁止路径清单（2 处）
□ V-4 改 git-guide.md §5.8 grep 正则（1 处）
□ V-4 增补 git-guide.md §5.5 project/README.md 项目件说明（1 处）
□ check-template.sh 的 require_doc_standards_mirror 断言路径从 docs/ → project/docs/（参考 §6.2 重新跑实测）
□ check-template.sh 的 check_scripts_sync_boundary 不受影响（scripts/ 不动）
□ README.md 目录速览表加 project/ 段、移除已迁项
□ SOP.md / MAINTAINERS.md / CONTRIBUTING.md 路径引用巡检
□ _examples/* 内部 docs/ 子路径巡检（按 README 内 [_示例] 已存在）
□ 派生仓同步验收脚本 check-derived-sync 的禁止路径正则同步更新
□ 在临时分支模拟迁移后跑本地 check-template + check-derived-sync 全绿
```

---

## 7. 事实补正对 minimax-m3 自评 §6 的订正

| §6 行 | 订正前 | 订正后 |
|---|---|---|
| 1（new-project.sh） | "复制根 docs/ / frontend/ / backend/" | 全量 `git archive`/`git clone` + 选择性 rm；--shape 已 rm 根目录代码骨架 |
| 2（template-sync.json） | "files_all/files_ordinary/files_domain 三组的实际内容" | files_all 156 项；只有 2 项含 `docs/`；files_ordinary 空；files_domain 2 项 |
| 9（sync-template 后的路径预期） | "派生仓期望根 docs/" | 派生仓期望 `docs/`（但只 2 项同步，含 README），项目事实文档由派生仓自有 |
| 11（模板自身 docs/research/） | "4 份现成材料 + 旧路径留 stub" | 4 份（gpt + 3 份 C1 triage）+ minimax-m3 自评 + meta-eval + 本核对清单 = 共 **7 份**（待本核对清单落盘后） |

---

## 8. 本核对清单自身的方法论声明

- 本核对清单由 minimax-m3 在已读取 4 份文件全文后产出。**未跑** `check-template.sh` 实测路径变更影响——这是下一步提案 PR 起草前的最后一道关卡。
- 7 个文件名计数声明（§7）基于本核对清单落盘前的实际 `docs/research/` 目录列表；落盘后该数字应递增到 7（如 minimax-m3 自评 §7 第 4 项 ROOT-C-006 提案方向一致）。
- 不修改前面三份评估文件——这三份文件保留其原始事实陈述与作者署名；本文件作为"事实补正层"独立存在，避免历史改写。

---

## 9. 下一步建议

1. **本轮（已落盘）**：本核对清单已存档至 `docs/research/2026-08-21-workspace-root-structure-fact-verification-minimax-m3.md`；4 份评估/核对文件均保持未跟踪（`??` 状态）。
2. **下一会话（提案起草）**：按 §6 清单逐项起草 `_proposals/TEMPLATE-UPGRADE-workspace-project-container.md`；提案正文需**回引本核对清单的 §2-§5** 作为影响面权威源，**不直接引用 minimax-m3 自评 §6**（其中含错误）。
3. **再下一会话（提案评审）**：用户拍板 ROOT-C-001~006；本核对清单的 §6 改造项须逐一对应到 PR 实施步骤。
4. **实施前实测**：临时分支模拟迁移后跑本地 `bash scripts/check-template.sh` + `powershell -ExecutionPolicy Bypass -File scripts/check-derived-sync.ps1`，全绿后再开 PR。

**重要**：本核对清单确认了 minimax-m3 自评 §6 影响审计"大方向对、细节有错"的判断——**方案 B 的影响面比自评描述更收敛**（主要是 4 类来源文件），但**--shape 与 README 模板的改造量比自评估计的更大**（30+ 处路径替换）。这是之前评估低估的部分。

---

**维护提示**：本文为事实补正层，按 `docs/README.md` §5 归 `docs/research/`。提案正文应引用本文件作为权威；不应修改或覆盖前 3 份评估文件。