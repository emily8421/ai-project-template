# GitHub Issue #238: TEMPLATE-UPGRADE: runtime version declaration and check

> Source URL: https://github.com/emily8421/ai-project-template/issues/238
> State: OPEN
> Labels: proposal, from:LUMEN_demo_T2.1
> Author: emily8421
> Created: 2026-07-21T06:54:08Z
> Updated: 2026-07-21T06:54:08Z
> Mirrored at: 2026-07-21 15:05:52 +0800
> Mirror status: raw remote issue copy for local triage; GitHub issue remains source of comments and closure state.

## Raw Issue Body

# TEMPLATE-UPGRADE-runtime-version-declaration-and-check

> 来源：LUMEN_demo_T2.1（emily8421/LUMEN-DEMO）派生项目回流。
> 去项目化说明：本文提炼自派生项目开发者在切换 Node 版本管理器（nvm → volta）后，因 PATH 残留导致版本切换工具失效、而项目模板与派生项目均无任何机制能察觉此类运行时漂移的问题；不包含客户资料、私有路径、机器名、账号或业务敏感信息。

## 1. 背景与问题

模板当前把 Node.js 定位为 “Recommended”（见 `scripts/check-prereqs.ps1`）——只要装了即可，不关心具体版本。环境脚本只做“报告”，不做“校验”：

- `scripts/check-prereqs.ps1`：检测 node 已安装并打印版本号，但**不与任何期望版本对比**，任意版本都通过。
- `scripts/collect-env.ps1`：把本机 node 版本采集进 `docs/env/local-env.md`，但**只记录、不比对**期望值。
- `scripts/bootstrap-dev-env.ps1`：通过 winget 安装缺失的推荐工具，安装得到的 node 版本不可控。
- CI `.github/workflows/project-check.yml`：**无 setup-node / 无 node-version**（当前也不跑 npm 构建）。
- `template-sync.json`：同步清单**不含** `.nvmrc` / `.node-version` / 任何运行时版本声明文件。

派生项目实践中暴露的通病（已去敏）：

- 开发者本机 Node 版本不受约束，同一项目不同成员可能跑在差异很大的主版本上，导致依赖安装行为、lockfile、ESLint / Babel / TypeScript 工具链行为不一致。
- 更隐蔽的是：开发者切换或迁移版本管理器（如 nvm→volta / nvm→fnm / 重装 node）时，常在 PATH 中留下**指向某个固定版本二进制目录的残留路径**，使新的版本切换工具的 shim 被绕过、版本切换完全失效。此时 `node -v` 停在旧版本，`<version-manager> install` 也看似成功却对当前 shell 无效——而**项目模板与派生项目全链路没有任何一处声明“应该是几版”，也没有任何一处对比“实际是几版”**，这类漂移可以长期潜伏无人察觉。

根因：模板缺少“期望运行时版本”的单一事实源，也缺少把“实际版本”与“期望版本”对比的检测点。

## 2. 拟改目标

补齐运行时版本的最小闭环：**声明期望版本 → 检测脚本从“报告”升级到“对比” → 文档化（含版本管理器迁移 / PATH 清理教训）**。

约束口径：

- 保持 “Recommended + 软提醒” 的现有弹性，**不引入硬强制**（不用 `engine-strict` 让 install 直接失败），避免在版本管理器迁移途中卡死开发者。
- 工具链无关：用 `.nvmrc` 作为单一声明源，nvm / fnm / volta / asdf / pnpm 均可读取，不绑死某一种版本管理器。
- 最小侵入：基于现有 `check-prereqs.ps1` / `collect-env.ps1` 增强，不另起炉灶。

## 3. 建议新增 / 修改

### 3.1 声明层：新增 `.nvmrc`

- 模板根目录新增 `.nvmrc`，写入模板维护者推荐的稳定 LTS 基线版本（具体主版本待维护者确认，如当前 Active LTS）。
- 派生项目下行同步后获得该文件，可按本项目实际覆盖为所需版本。
- 单一文件、工具链无关、零运行时依赖。

### 3.2 检测层：脚本升级“报告 → 对比”

`scripts/check-prereqs.ps1`（及对应的 Bash fallback，若存在 / 未来补齐）：

- 读取 `.nvmrc`（若存在）得到期望主版本。
- Node.js 检测项在原有“已安装 + 版本号”基础上，增加“实际 vs 期望主版本”对比。
- 不符时输出 **warning**（如 “期望 Node 22，实际 16.13.0，建议对齐以避免依赖 / 工具链行为漂移”），**不改变退出码、不 fail**。
- 若 `.nvmrc` 不存在，维持现状（只报告版本），保持向后兼容。

`scripts/collect-env.ps1`：

- 在 `docs/env/local-env.md` 的“常用工具”区，Node.js 行增加“期望（来自 .nvmrc）vs 实际 vs 是否一致”三栏信息（无 `.nvmrc` 时标注“未声明”）。
- 便于环境采集快照一眼看出本机是否对齐项目期望版本。

### 3.3 文档层：`template-docs/env-setup.md` 增补一节

新增“运行时版本管理”小节，覆盖：

1. 项目期望 Node 版本以根目录 `.nvmrc` 为准，版本管理器（nvm / fnm / volta / asdf）会自动读取。
2. 切换或迁移版本管理器后，务必清理 PATH 中**指向固定版本二进制目录的残留路径**，否则版本切换工具的 shim 会被绕过、`<manager> install` 对当前 shell 无效。
3. 自检命令：运行 `scripts/check-prereqs.ps1`，观察 Node 版本对比行的 warning。

### 3.4 同步与自检层

- `template-sync.json`：新增 `.nvmrc` 到同步文件清单（属模板方法论基线，应下行）。
- 自检脚本 `scripts/check-template.sh` / `.ps1`：增加轻量断言——**若模板提供了 `.nvmrc`，则它出现在 `template-sync.json` 中**（一致性，不强制派生项目必须有）。
- 自检不扫描派生项目实际 node 版本，也不要求派生项目必须保留模板基线版本。

## 4. 建议修改位置

1. **新增** `.nvmrc`（模板根）。
2. `scripts/check-prereqs.ps1`：Node.js 检测项增加期望版本对比 + warning。
3. `scripts/collect-env.ps1`：`local-env.md` 模板的 Node.js 行增加期望 / 实际 / 一致三栏。
4. `template-docs/env-setup.md`：增补“运行时版本管理”小节。
5. `template-sync.json`：登记 `.nvmrc`。
6. `scripts/check-template.sh` / `scripts/check-template.ps1`：新增 `.nvmrc ∈ template-sync.json` 一致性断言。

## 5. 验收标准

- 模板与派生项目根目录存在 `.nvmrc`，版本管理器可据此自动切换。
- `check-prereqs.ps1` 在 node 实际版本与 `.nvmrc` 期望主版本不符时，输出 warning 且退出码不变；`.nvmrc` 缺失时维持原行为。
- `collect-env.ps1` 生成的 `local-env.md` 能体现 Node 期望 / 实际 / 是否一致。
- `env-setup.md` 含运行时版本管理与 PATH 清理指引。
- 自检能覆盖 Bash 与 PowerShell fallback 两侧的 `.nvmrc ∈ template-sync.json` 断言。
- 不引入 `engine-strict` 硬强制；不在版本管理器迁移途中阻塞开发者。

### 5.1 验证方式

- 本地规则自检：`bash scripts/check-template.sh` 或 `powershell -ExecutionPolicy Bypass -File scripts/check-template.ps1`。
- Markdown 清洁检查：`powershell -ExecutionPolicy Bypass -File scripts/check-markdown-clean.ps1 _proposals`。
- 行为抽样：在测试项目分别用对齐 / 不对齐 `.nvmrc` 的 node 版本跑 `check-prereqs.ps1`，确认 warning 触发且退出码为 0。

## 6. 影响面

- 影响范围：所有派生项目（获得版本声明 + 软检测）。
- 风险：低；新增的是声明文件 + 软 warning + 文档，不改变任何默认硬约束，不阻塞 install / 构建。
- 下行同步：派生项目获得运行时版本一致性可见性，减少“版本漂移长期潜伏”。
- 不适用场景：不使用 Node 的项目，`.nvmrc` 可删除或忽略，软检测在文件缺失时自动退回原行为。

## 7. 版本影响建议

建议作为 **PATCH** 落地：新增可选声明文件 + 软检测 warning + 文档，默认行为弹性不变。

若维护者选择把 CI 纳入 `setup-node` 锁定、或把 Node 提升为 “Required” 级别，再评估是否升为 MINOR。

## 8. 待维护者确认项

1. `.nvmrc` 基线版本写哪个主版本（当前 Active LTS 如 24？或更保守的 22？）。派生项目可覆盖。
2. 软检测对比的是“主版本”还是“完整版本号”（建议主版本，避免 patch 差异频繁告警）。
3. `check-prereqs` 是否需要补一个 Bash fallback（当前疑似仅 `.ps1`），以保证非 Windows 环境同样有版本对比。
4. `bootstrap-dev-env.ps1` 是否在安装 node 时尝试对齐 `.nvmrc`（当前 winget 装的版本不可控），还是仅在检测层提醒。
5. CI 是否在本提案内就加 `setup-node`（本提案立场是**暂不加**，等 CI 真正跑构建时再说），还是作为后续独立提案。

## 9. 非目标

- 不引入 `engine-strict` / install 期硬强制。
- 不绑定某一种版本管理器（nvm / volta / fnm / asdf）。
- 不在 CI 强制 node 版本（当前 CI 不跑构建）。
- 不自动安装或切换 node 版本（只声明 + 检测 + 提醒）。
- 不采集或上传开发者机器的私有路径、机器名等隐私信息。
