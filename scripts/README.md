# scripts/ 脚本

本目录放 `ai-project-template` 的自动化脚本：新建项目、下行同步、自检、环境采集与一键安装。

## 脚本说明

| 脚本 | 干什么 | 谁用 / 在哪 |
|---|---|---|
| `new-project.sh` | 从模板派生新项目（本地 + 可选远端） | 使用者 / 维护者 · 在模板仓 |
| `sync-template.sh` / `.ps1` | 下行同步模板方法论到派生项目 | 使用者 · 在派生项目 |
| `check-template.sh` / `.ps1` | **模板仓库**完整性自检（**仅模板仓**用） | 维护者 · 在模板仓 |
| `check-derived-sync.sh` / `.ps1` | **派生项目**同步边界检查（**仅派生**用） | 使用者 · 在派生项目 |
| `collect-env.ps1` | 采集本机环境 → `docs/env/local-env.md` | 使用者 · 在派生项目 |
| `check-prereqs.ps1` | 检查基础工具是否齐 | 使用者 |
| `bootstrap-dev-env.ps1` | 一键安装基础工具 | 使用者 |

> ⚠️ 别用错：`check-template.*` 是**模板仓**自检，`check-derived-sync.*` 才是**派生项目**同步验收。
>
> Windows 优先 `.ps1`；Git Bash 可用时也可用 `.sh`。完整命令矩阵与 Windows 入口选择见 `SOP.md` 常用命令；操作 SOP（新建 / 提交 / 同步）见 `git-guide.md`。
