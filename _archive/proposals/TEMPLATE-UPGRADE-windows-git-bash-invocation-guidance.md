# TEMPLATE-UPGRADE: Windows Git Bash 入口调用指引与 .sh 自举 MSYS PATH 守卫

> 来源：模板维护者（codex/claude 在 Windows 上从 PowerShell 调 Git Bash 跑 .sh 脚本时反复踩两个坑的实测复现；详见 `.ai/token-hotspots/2026-07-27-windows-git-bash-invocation-analysis.md` §9）
> 状态：处理中（分支 `fix/windows-git-bash-invocation`）
> 目标版本：v1.58.1
> Release impact：patch（不改同步行为、不加同步结构、不要求派生项目迁移；仅 Windows 健壮性 + 文档补强 + 自检增强）
> Release strategy：单 PR 落地 B1（守卫）+ B2（文档）+ B3（断言）；不拆分（三者互相锁住，分批会引入中间态断言失败）

## 1. 背景

模板维护者在 Windows 上从 PowerShell 调 Git Bash 跑 `.sh` 脚本（check-template / sync-template / new-project）时**反复踩两个坑**，codex 与 claude 频繁切换下避不开。已实测复现并归类（hotspot §9）：

- **坑 1（通用，PS5.1 原生缺陷）**：PowerShell 5.1 把 `bash -lc '..."$var"...'` 里内嵌的双引号弄丢 → bash 收到未加引号变量 → 带空格路径拆词（实测 `ARGCOUNT=2`）。无内嵌双引号时（直接 `bash.exe script.sh`）不复现。
- **坑 2（环境依赖）**：非登录 bash 或 PATH 被沙箱刮掉时，`/usr/bin`（dirname/grep/sed）与 `/mingw64/bin`（git）缺失。精确塌陷点：`check-template.sh` 的 `ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"` —— dirname 塌成空串后雪崩且无诊断。典型 Git for Windows bash.exe 包装器注入 `/mingw64/bin:/usr/bin` 可兜住，codex 沙箱刮继承 PATH 时暴露。

## 2. 目标

1. 让三个 `.sh` 脚本在坑 2 下**自救助跑完**，不靠外部 PATH 配置或登录 shell。
2. 把坑 1 的规避方式**文档化**成单一事实来源（env-setup §8.1）。
3. 用 check-template.sh 断言锁住守卫标记 + 文档关键词，防漂移（MAINTAINERS §5 硬约束）。

## 3. 非目标

- 不改任何 `.ps1`（5 份 .ps1 共享 Find/Test-TemplateBash 双子函数模式；B1 落地后坑 2 在 .sh 层闭环，.ps1 探针升级失去 ROI 且造成不对称）。
- 不强制 bash 登录 shell（`-l` 副作用大，仅作兜底备选）。
- 不抽 sourced helper（sourcing 标准写法 `source "$(dirname …)"` 自己依赖 dirname，PATH 坏时先塌，循环依赖）。
- 不改 sync-template 同步行为、过滤规则、commit 协议；不改 template-sync.json schema 或同步清单。

## 4. 拟改

### 4.1 B1 守卫（坑 2 治本）

三个 `.sh` 各内联同一段守卫（标记 `MSYS_PATH_GUARD`），插在 `set -euo pipefail` 之后、首次 `dirname`/`sed` 之前：

- `scripts/check-template.sh`：`GIT_CONFIG_VALUE_1=false`（L33）后、`ROOT=…dirname…`（L35）前。
- `scripts/sync-template.sh`：`set -euo pipefail`（L20）后、`usage()`（L22）前。
- `scripts/new-project.sh`：`set -euo pipefail`（L19）后、环境变量默认值（L21）前。

```bash
# MSYS PATH 自举守卫（MSYS_PATH_GUARD）：非登录 bash 或 PATH 被沙箱刮掉时，
# /usr/bin（dirname/grep/sed）与 /mingw64/bin（git）可能不在 PATH 上，导致
# ROOT 计算等早期 dirname 调用塌成空串、后续雪崩。只用 bash 内建判定
# （command -v / [[ -d ]]），不依赖 uname 等外部工具——触发场景本身就是 /usr/bin 缺失。
# 三种 canonical 调用方式见 template-docs/env-setup.md §8.1。
if [[ -z "${MSYS_PATH_GUARD:-}" ]] && ! command -v dirname >/dev/null 2>&1; then
  for _guard_dir in /usr/bin /mingw64/bin /mingw32/bin; do
    [[ -d "$_guard_dir" ]] || continue
    case ":${PATH:-}:" in
      *":$_guard_dir:"*) ;;
      *) PATH="$_guard_dir:$PATH" ;;
    esac
  done
  export PATH MSYS_PATH_GUARD=1
fi
```

设计要点：纯内建判定（无 uname 依赖——修正了初版守卫用 `case "$(uname -s)"` 门控、但坑 2 下 uname 同在 /usr/bin 也缺失导致不触发的缺陷）；`set -euo pipefail` 友好；`MSYS_PATH_GUARD` + `case ":$PATH:"` 去重幂等；健康系统 dirname 已在 → 永不触发；连带保 `/mingw64/bin`（git）避免"救了 dirname 丢了 git"。

### 4.2 B1 附带：增厚 check-template.sh 早退诊断

`check-template.sh` 早退 echo 块补「见 env-setup §8.1」指针 + 复现命令加 `git`/`uname -s`（不动逻辑、不改退出码）。

### 4.3 B2 文档（坑 1）

- `template-docs/env-setup.md`：§8「关于 Git Bash / PowerShell 入口」段尾后新增 §8.1「在 Windows 上调用 .sh 脚本的三种 canonical 方式」——(a) 直接执行 .sh（推荐）/ (b) 带空格路径·变量：避开 `bash -lc '...$var...'`，改用继承 CWD / env 变量 / wrapper 文件 / (c) 需登录 shell·完整工具箱：`-l` / `env.exe`（PATH 必须含 `/mingw64/bin`，否则丢 git）/ wrapper 追加 `export PATH="/usr/bin:/mingw64/bin:$PATH"`。
- `git-guide.md` §5、`MAINTAINERS.md` §5：各 1 行指针 → env-setup §8.1（MAINTAINERS 点名 `MSYS_PATH_GUARD`）。

### 4.4 B3 断言（防漂移）

`check-template.sh` sync-template 断言簇尾新增 5 断言：三脚本含 `MSYS_PATH_GUARD` + env-setup §8.1 引用守卫关键词 + §8.1 提供三种 canonical 调用关键词。

## 5. 影响面

- 改动文件全部已在 template-sync.json 清单内 → 下行同步到派生项目；派生无需迁移，下次 sync 自动收到守卫 + 文档。
- 守卫 `case "$(uname -s)"`… 实为内建判定，Linux/macOS dirname 已在 → 永不触发，零影响。
- 不改 .ps1；CI template-check 多 5 条断言，正常路径零影响。

## 6. 验收

- `bash -n` 三脚本通过。
- 模拟坑 2（`env.exe PATH=/c/Windows/System32:/c/Windows bash check-template.sh --summary`）：守卫自救、跑完，退出码与正常路径一致。
- `check-template.sh --summary`（含 5 新断言）+ `check-template.ps1` fallback 全过。
- 派生烟测：`sync-template.sh --dry-run` 守卫无额外输出；`new-project.sh` 带空格路径走 (a) 不拆词。
- CI template-check 绿。

## 7. 衔接

- 承接 hotspot 记录（PS→bash 调用反复失败）的根因侧；与 `TEMPLATE-UPGRADE-template-check-maintainability.md` P2.3「Windows fallback smoke checklist」互补（P2.3 解决 fallback 时怎么判断，本提案解决不 fallback 时怎么自救）。
- 完成后归档到 `_archive/proposals/`。
