# TEMPLATE-UPGRADE-v1.56.0：运行时版本健康检测与预检门禁（声明层之上的检测 / 门禁层）

> 来源：模板维护者
> 状态：处理中
> 目标版本：v1.56.0
> Release impact：minor（AI 建议，待维护者确认；阶段 1 轻检测子集可独立作 patch 先行）
> Release strategy：分阶段（阶段 1 可独立 PATCH 先行；阶段 2 为本提案主体 MINOR）
> 前置：v1.55.0 运行时版本锁定（已合并 PR #236、提案归档 PR #237）。本提案补上 v1.55.0 刻意推迟的「检测 / 门禁层」。
> 关联：GitHub issue #238（`from:LUMEN_demo_T2.1` 回流，"runtime version declaration and check"，本地镜像 `_proposals/_remote-issues/issue-238.md`，Updated 2026-07-21T06:54:08Z / Mirrored 2026-07-21 15:05:52 +0800）。#238 独立验证同一缺口，本提案将其吸收为「阶段 1 轻检测」来源；#238 中与 v1.55.0 重叠或冲突的部分按 §1.1 / §8 裁决处理，PR 合并后 #238 关闭并随归档。

## 1. 背景

v1.55.0 建立了运行时版本锁定的**声明层**（`package.json#volta` / `.node-version` / `ai/project-rules.md` §2.9 / `docs/05-tech-spec.md` §1.1 / `template-docs/env-setup.md` §6），回答"我们想要哪个版本"。它刻意把"声明版本 vs 本机实际版本"的对照留给 `tech-env-evaluation`（人工 / AI 驱动），并明确不改 `collect-env.ps1`。

实际运维暴露的缺口：**运行时版本变更往往由外部用户自行切换**（换版本管理器、重装 Node、PATH 残留），既非项目主动也非模板主动。而模板对 Node 的所有检查都是**纯存在性检查**：

| 脚本 | 现状 | 缺口 |
|---|---|---|
| `check-prereqs.ps1` | `Test-CommandExists "node"` 只查"在不在" | 不查 manager、不查解析路径、不查声明 vs 实际 |
| `collect-env.ps1` | 记 `node --version`（本机事实） | 不读锁文件、不查 manager（v1.55.0 SoC） |
| `bootstrap-dev-env.ps1` | `Test-CommandExists "node"` 为真即跳过安装 | "在但错"的 node 被当"已装"放过，永不修 |
| `check-template.sh` | 只断言 env-setup.md **提到** Volta / `.node-version` | 纯文档存在性，无运行时行为 |

后果：当外部用户把 Node 管理搅乱（PATH 把固定版本二进制目录前插、绕过 manager shim；nvm / Volta 混用残留；版本钉死在 image 目录），**这些检查全部静默通过**，直到下游（AI CLI 跑不起来、派生 Node 项目 build 挂）才暴露，且只能靠手工 PATH 取证定位。

"模板失效"的真实入口经校准有两条，机制落点不同：

1. **AI CLI 路径**：`claude` / `codex` 是 Node 程序、用户自装。Node 一坏，模板"把文档 / Prompt 交给 AI 执行"的整个工作流出不去。
2. **派生 Node 项目路径**：锁版本项目（如米家插件类锁 Node 16.x）在成员 manager 不一致时 build / run / CI 漂移。

模板**自带核心脚本**（`new-project.sh`、`sync-template.*`、`check-template.*`、`collect-env.ps1` 等）是 Bash + PowerShell，自身运行**不依赖 Node**。因此本提案不针对"模板脚本自身跑不起来"，而针对"把静默失效变成响亮、可诊断的信号"。

### 1.1 与 issue #238 的关系（去重 / 冲突）

issue #238（LUMEN_demo_T2.1 回流）独立撞到同一缺口，并精确描述了"nvm→volta 迁移后 PATH 残留绕过 shim"的实战病灶——是本缺口真实且值得修的硬验证。但 #238 在 LUMEN 的 **v1.54.1** 基线上起草（LUMEN 尚未同步 v1.55.0），因而部分内容与已发布的 v1.55.0 重叠或冲突，本提案按下表吸收 / 裁决：

| #238 条目 | v1.55.0 现状 | 本提案处置 |
|---|---|---|
| §3.3 env-setup 新增"运行时版本管理"小节 | **已存在**（`env-setup.md` §6，含 PATH 清理指引） | 不重复新增；阶段 2 仅在 §6 追加"混合 manager 团队"口径与 check-runtime 输出说明 |
| §3.1 期望版本单一事实源（用 `.nvmrc`） | 已建立，但用 `.node-version` + `package.json#volta` | **裁决 A**：不引入 `.nvmrc`（见下） |
| §3.1+§3.4 模板根预置 `.nvmrc` 并下行 | v1.55.0 非目标"母模板不预置任何版本声明文件" | **裁决 B**：继续保持中立，不预置 |
| §3.2 `check-prereqs.ps1` 声明 vs 实际 warning | （新） | **吸收为阶段 1** |
| §3.2 `collect-env.ps1` 三栏期望 / 实际 / 一致 | v1.55.0 非目标"不改 collect-env.ps1（本机事实职责）" | **裁决 D**：不改 collect-env.ps1；可见性由 check-prereqs warning（阶段 1）/ check-runtime（阶段 2）提供 |
| §1 真病灶 = shim 被绕过 | （#238 方案检测不到"为什么"） | **裁决 C**：阶段 2 `check-runtime.ps1` 诊断解析路径补此缺口 |

**裁决 A（声明文件，含事实硬伤）**：#238 称"`.nvmrc` 被 nvm / fnm / volta / asdf / pnpm 均可读取"不准确——**Volta 不读 `.nvmrc` 也不读 `.node-version`，只认 `package.json#volta`**（见 `env-setup.md` §6 行 287）；asdf 原生读 `.tool-versions`。致命点：#238 的前提是 nvm→volta 迁移，而它推荐的 `.nvmrc` 恰恰 Volta 不认——照做会让 Volta 项目声明被静默忽略，重演 #238 自己要消灭的"静默漂移"。故保留 v1.55.0 口径（Volta 用 `package.json#volta`、其余用 `.node-version`），不新增第三个声明文件。

## 2. 目标

在 v1.55.0 声明层之上补**检测 / 门禁层**，manager 中立，跨 Volta / nvm / fnm / 系统安装都能用。分两阶段：

- **阶段 1（轻检测，吸收自 #238）**：`check-prereqs.ps1` 把 Node 检查从"报告"升级到"声明 vs 实际对比 + warning"，不新增脚本、不新增同步件，向后兼容。
- **阶段 2（深度诊断 + 门禁，本提案主体）**：新增 `scripts/check-runtime.ps1` 诊断解析路径 / manager 健康 / 会话注入 vs 持久污染；扩 env-setup §6 混合 manager 口径；派生项目 opt-in 接入 CI / smoke / build 前预检。

## 3. 非目标

- **不保证在任意被搅乱的机器上正确运行**：模板无法控制用户机器。诚实契约是"声明意图 + 检测漂移 + 大声失败并给修复提示"，不是"无论怎样都能跑"（符合既有"声称据实"原则，见 `env-setup.md` §9）。
- 不自动修复用户 PATH / 不自动改 manager 配置（PATH 与 manager 是用户领地；脚本只诊断 + 提示）。
- 不改 `collect-env.ps1` 职责（延续 v1.55.0 SoC；#238 的三栏需求由 check-prereqs / check-runtime 承接，裁决 D）。
- 不强制具体 manager / 不预置声明文件（延续 v1.55.0 中立；不采纳 #238 的模板根 `.nvmrc`，裁决 B）。
- 不引入 `engine-strict` / install 期硬强制（采纳 #238 约束口径）。
- 不在本轮做 AI CLI 自动安装或自动修复（只加可选 smoke 提示）。
- 不绑定具体运行时语言（Node 首实例；Python / Java 复用同一检测框架，本轮不实现）。
- 不在本轮加 CI `setup-node`（采纳 #238 立场：等 CI 真正跑构建时再独立提案）。

## 4. 拟改范围

### 阶段 1（轻检测，吸收自 #238；可独立作 PATCH）

| 文件 | 改动 |
|---|---|
| `scripts/check-prereqs.ps1` | Node 检测项读取声明版本（`package.json#volta.node` → 否则 `.node-version` → 否则跳过；**不读 `.nvmrc`**，裁决 A），增加"实际 vs 期望主版本"对比；不符输出 **warning**（如"期望 Node 22，实际 16.13.0，建议对齐"），**不改退出码、不 fail**；无声明文件时维持现状 |
| `scripts/check-template.sh` | 新增 `require_contains` 断言：check-prereqs.ps1 含声明 vs 实际对比逻辑关键词（不改 `.ps1` fallback，延续 v1.55.0 先例） |

阶段 1 不新增脚本、不新增同步件、不改 `collect-env.ps1`；声明文件沿用 v1.55.0（派生按 §2.9 自放，模板不预置）。

### 阶段 2（深度诊断 + 门禁；本提案主体 MINOR）

#### 新增

| 文件 | 内容 |
|---|---|
| `scripts/check-runtime.ps1` | manager 中立运行时健康诊断（PowerShell-primary，仿 `collect-env.ps1`；只读，不写持久 PATH）：node 解析来源类型（Volta shim / image 直连 / nvm symlink / 系统安装 / 未知）+ 检测到的 manager + 声明 vs 实际 + 漂移判定 + 会话注入 vs 持久污染区分 + 可操作提示 |

#### 修改

| 文件 | 改动 |
|---|---|
| `template-docs/env-setup.md` | §6 增加"混合 manager 团队"声明口径（`.node-version` + `package.json#volta` 并用 + 由 check-runtime 断言一致）；新增"运行时健康检测"小节，说明 check-runtime 输出语义与在哪接门禁 |
| `ai/project-rules.md` | §2.9 增一行指向 `scripts/check-runtime.ps1`（句式仿 §2.9 既有 env-setup 引用） |
| `scripts/README.md` | 脚本表新增 `check-runtime.ps1` 行（只读、运行位置=派生项目 / 任意、用途=运行时健康诊断） |
| `template-sync.json` | `files` 清单新增 `scripts/check-runtime.ps1`（使派生项目经同步获得） |
| `scripts/check-prereqs.ps1` | 追加 warning：node 在但解析到非 shim 固定路径 / 未检测到 manager（**仅告警**；与阶段 1 的版本对比 warning 合并到同一处） |
| `scripts/check-template.sh` | 追加断言：env-setup §6 混合 manager 口径关键词、`scripts/check-runtime.ps1` 存在、`scripts/README.md` 表含 check-runtime |
| `VERSION` | v1.55.0 → v1.56.0（阶段 2 落地时） |
| `CHANGELOG.md` | 顶部新增条目（阶段 1 PATCH + 阶段 2 MINOR 分别登记） |

#### 不改（全阶段）

`collect-env.ps1`（职责不变，裁决 D）、`bootstrap-dev-env.ps1` 安装逻辑（不在 bootstrap 自动改 PATH；仅可能在 prereqs 侧告警）、`check-template.ps1`（fallback 显式收窄不镜像内容断言，延续 v1.55.0）、`sync-template.*` 同步机制本身（仅向 `template-sync.json` 增加一行同步件）、`TEMPLATE-BASE.md`、生命周期规则、scenario-guides / glossary。

#### 可选扩展（待维护者确认是否纳入）

- `ai/commands/check-runtime.md`：仿 `ai/commands/collect-env.md` 的命令入口文档（若纳入则同步件 +1）。
- AI CLI smoke：在 `check-prereqs.ps1` 或 smoke 加软检查"claude / codex 能否启动 + 跑在哪个 node"。
- `check-runtime.sh` 最小子集：为 CI / 类 Unix 提供可移植检测（Windows 深度 PATH-scope 诊断仍需 `.ps1`，因 User / Machine / 会话三层区分依赖 `[Environment]::GetEnvironmentVariable`）。
- `check-prereqs` 的 Bash fallback（#238 待确认项 3）：当前 check-prereqs 仅 `.ps1`；若要非 Windows 也有版本对比需补 `.sh`。

## 5. 版本策略

**分阶段发布**：

- **阶段 1 = PATCH**（吸收 #238，符合 #238 自荐 PATCH）：新增软 warning + 断言，不新增同步件、不改默认行为、不阻塞 install / 构建。命中 `_proposals/README.md` patch 口径（自检增强 + 兼容性软能力）。可直接先行发布（如 v1.55.1）。
- **阶段 2 = MINOR**（本提案主体）：新增同步件 `scripts/check-runtime.ps1`（= 新下游采用面）+ 新增"检测 / 门禁层"能力层级 + env-setup §6 推荐工作流变化（混合 manager 口径）。命中 README minor 口径；直接先例 v1.55.0 / v1.6.0 / v1.51.0。

若维护者选择不拆阶段、一次性以 MINOR 落地全部，亦可；阶段标记仅用于"想先快上轻检测"的选项。

## 6. 验证方式

- `powershell -ExecutionPolicy Bypass -File scripts/check-template.ps1`（fallback 转发 bash）+ `bash scripts/check-template.sh`（新断言全绿、无回归）。
- `powershell -ExecutionPolicy Bypass -File scripts/check-markdown-clean.ps1 _proposals template-docs ai`。
- `git diff --check`。
- **阶段 1 行为抽样**：项目有声明（pin 22）+ 本机 16 → check-prereqs 输出 warning 且退出码 0；无声明文件 → 维持原行为（#238 §5.1）。
- **阶段 2 行为抽样**（核心）：在以下环境跑 `check-runtime.ps1`：
  1. 健康 Volta：node 走 shim、声明 = 实际 → PASS；
  2. 声明 vs 实际漂移：pin 16.13.0 但本机默认 24 → DRIFT 提示；
  3. 解析异常：node 解析到固定 image 目录绕过 shim（会话注入）或持久 PATH 残留 → 明确区分"会话注入 vs 持久污染"并给修复提示。
- 跨 manager 抽样：同一项目放 `.node-version` + `package.json#volta` 并存，check-runtime 断言两者一致；故意改一个 → 报漂移。

## 7. 影响面

- 所有派生项目经同步获得阶段 2 的 `check-runtime.ps1`，可 opt-in 接入 CI / smoke / build 前预检；阶段 1 的 check-prereqs warning 随 prereqs 同步自动获得。
- 锁版本项目（Node 首实例）获得"声明 vs 实际 + manager 健康"自动信号，不再依赖人工记得跑 tech-env-evaluation。
- 混合 manager 团队（Volta + nvm 共存）获得可移植声明口径 + 一致性断言。
- 非锁版本项目：check-runtime 报"未启用锁定"；prereqs 告警仅在检测到异常解析 / 版本漂移时出现，默认无噪声。
- `check-prereqs.ps1` 告警为软告警，不改既有"必备缺失才 fail"退出码契约。
- 模板核心脚本自身仍 Node 无关，本提案不改变其运行前提。
- **对 #238**：#238 的声明层 / 文档层诉求已被 v1.55.0 满足，检测层诉求被本提案阶段 1 + 阶段 2 吸收；#238 在本提案 PR 合并后关闭。

## 8. 决策记录（2026-07-21 维护者确认）

**A. 已确认（维护者明确拍板）**：

1. **发布节奏**：分两步——阶段 1（轻检测）先作 **PATCH**（如 v1.55.1）先行；阶段 2（深度诊断）作本提案主体 **MINOR**（v1.56.0）。
2. **声明文件（裁决 A）**：**不引入 `.nvmrc`**，沿用 v1.55.0（Volta 用 `package.json#volta`、其余用 `.node-version`）。理由：Volta 不读 `.nvmrc` / `.node-version`，本场景正是 Volta，`.nvmrc` 会被静默忽略。
3. **模板预置（裁决 B）**：母模板**继续不预置**声明文件，保持中立；派生按 §2.9 自放。
4. **检测深度（裁决 C）**：两层——阶段 1 = "声明 vs 实际"版本对比 warning；阶段 2 = shim 绕过等解析路径深度诊断（`check-runtime.ps1`）。
5. **collect-env.ps1（裁决 D）**：**不改**，延续 v1.55.0 SoC（只记录本机事实）；版本可见性由 check-prereqs（阶段 1）/ check-runtime（阶段 2）承接。

**B. 建议默认（未异议则按此执行）**：

6. `check-runtime.ps1` 进 `template-sync.json`（阶段 2），派生经同步获得——本缺口闭环的核心。
7. 阶段 1 对比粒度：按**主版本**（避免 patch 差异频繁告警）。
8. `check-prereqs.ps1` 告警：纯 **warning**（不改退出码，不破坏"必备缺失才 fail"契约）。
9. 本轮**不纳入**可选扩展：`ai/commands/check-runtime.md`、AI CLI smoke、`check-runtime.sh` 可移植子集、`check-prereqs` Bash fallback —— 作为后续候选。
10. 本轮**不加** CI `setup-node`（独立提案）；**不扩** Python / Java 同框架（Node 走通后再说）。
11. 混合 manager 口径：`.node-version` + `package.json#volta` 并用 + check-runtime 断言一致；在 env-setup §6 写明分境（单 manager=单文件 / 混合团队=双文件+断言）。
