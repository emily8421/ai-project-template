# scripts/ 脚本

本目录放 `ai-project-template` 的自动化脚本：新建项目、下行同步、自检、环境采集、一键安装、批量同步与回归检查。

## 脚本说明

| 脚本 | 干什么 | 运行位置 | 读/写 | 谁用 |
|---|---|---|---|---|
| `new-project.sh` | 从模板派生新项目（本地 + 可选远端） | 模板仓 | 写入（生成项目） | 使用者 / 维护者 |
| `sync-template.sh` / `.ps1` | 下行同步模板方法论到派生项目 | 派生项目 | 写入（同步文件） | 使用者 |
| `check-template.sh` / `.ps1` | **模板仓库**完整性自检（**仅模板仓**用） | 模板仓 | 只读 | 维护者 |
| `check-derived-sync.sh` / `.ps1` | **派生项目**同步边界检查（**仅派生**用） | 派生项目 | 只读 | 使用者 |
| `collect-env.ps1` | 采集本机环境 → `docs/env/local-env.md` | 派生项目 | 写入（生成文件） | 使用者 |
| `check-prereqs.ps1` | 检查基础工具是否齐 | 任意 | 只读 | 使用者 |
| `check-runtime.ps1` | Node 运行时健康深度诊断（解析路径 / manager / 声明 vs 实际漂移） | 任意 | 只读 | 使用者 |
| `bootstrap-dev-env.ps1` | 一键安装基础工具 | 本地 | 写入（安装软件） | 使用者 |
| `sync-all-derived.sh` | 批量同步父目录下所有派生项目 | 父目录 | 写入（各派生项目） | 维护者 |
| `e2e-sync-check.sh` | L3 端到端回归检查门 | 模板仓 | 只读 | 维护者 |

> ⚠️ 别用错：`check-template.*` 是**模板仓**自检，`check-derived-sync.*` 才是**派生项目**同步验收。

## Windows 脚本入口选择

`.sh` 文件是**主实现 / 权威逻辑**，适用于 CI、Git Bash 和类 Unix 环境。

`.ps1` 文件是 **Windows 友好包装入口**，遵循以下原则：

- **优先委托 Git Bash**：先尝试启动 Git Bash 并运行对应的 `.sh` 脚本
- **PowerShell fallback**：Git Bash 无法启动时，走原生 PowerShell 结构性检查（非完整等价）
- **幂等性保证**：Bash 和 fallback 路径产生相同的检查结果类别（通过/失败）

### 权威性说明

- **完整权威检查**：Bash `check-template.sh` + CI（模板仓）
- **结构性兜底检查**：PowerShell native fallback（Git Bash 无法启动时最低保障）
- **等价性**：fallback 通过 ≠ 完整自检通过；发布前仍应以 CI 或 Bash 自检为准

### 故障排查

| 入口 | 运行位置 | Git Bash 依赖 | 失败时优先排查 |
|---|---|---|---|
| `scripts/check-template.ps1` | 模板仓 | 可 fallback 到 PowerShell 结构检查 | 若 Bash 启动失败，先看输出中的 fallback 结果 |
| `scripts/sync-template.ps1` | 派生项目 | 优先 Git Bash；失败时可 PowerShell fallback | 输出中的 fallback 标识；若 fallback 也失败再修 Git for Windows / MSYS |
| `scripts/check-derived-sync.ps1` | 派生项目 | 优先 Git Bash；失败时可 PowerShell fallback | 输出中的 fallback 标识；若 fallback 也失败再修 Git for Windows / MSYS |

完整命令矩阵见 `SOP.md` 常用命令；操作 SOP（新建 / 提交 / 同步）见 `git-guide.md`。