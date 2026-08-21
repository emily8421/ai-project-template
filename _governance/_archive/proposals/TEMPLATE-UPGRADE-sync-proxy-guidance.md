# TEMPLATE-UPGRADE: sync-template 受限网络代理配置提示 + git-guide §5.7

> 来源：派生项目国内网络同步踩坑回流（多次踩 `git fetch` reset、`gh` 不读 `git http.proxy`）
> 状态：本 PR 同步落地（文档 + 脚本提示 + 自检断言）
> 目标版本：v1.54.2
> Release impact：patch（文档增强 + 非阻断提示，不改变同步语义）
> Release strategy：git-guide §5.7 文档 + sync-template fetch 失败提示 + check-template 防回归断言，一次性落地

## 1. 背景

受限网络（如国内直连 GitHub）下，派生项目执行 `sync-template` 时 `git fetch` 模板远端常被重置（症状：HTTPS `curl 16 framing` / `curl 52 empty reply`、连接 reset）。`sync-template` fetch 失败的现有提示只覆盖「模板仓库私有 / gh 账号」，未覆盖「网络 / 代理」这一更常见原因；`git-guide.md §5`（派生项目同步 SOP 权威文档）也完全没代理配置说明。

派生项目多次踩坑：`git fetch`/`push` 走 `http.proxy`，但 `gh` 不读 `git http.proxy`，命令必须单独带 `HTTPS_PROXY`/`HTTP_PROXY`。这个坑在多份 sync-record / handoff 里反复出现「建议回流」，但一直没落地。

## 2. 目标

1. `git-guide.md §5` 增加网络与代理配置小节，说明受限网络下 git / gh 的代理配置差异。
2. `sync-template.sh` / `.ps1` fetch 失败时，提示除「私有仓库」外的「网络/代理」原因 + 配置命令 + 指向 git-guide §5.7。
3. `check-template.sh` / `.ps1` 加防回归断言，确保双脚本含代理提示关键词。

## 3. 非目标

- 不改变同步语义、同步清单、版本机制。
- 不强制特定代理工具或端口（端口以用户本机为准，用占位）。
- 不为 `gh` 自动注入代理（`gh` 不读 git config 是 GitHub CLI 设计，文档提示即可）。

## 4. 拟改

| 文件 | 改动 |
|---|---|
| `git-guide.md` | §5 新增 §5.7「网络与代理配置（受限网络环境）」：git fetch/push 走 `http.proxy`/`https.proxy`；`gh` 不读 git http.proxy，命令带 `HTTPS_PROXY`/`HTTP_PROXY`；失败症状；端口占位。 |
| `scripts/sync-template.sh` | fetch 失败提示从「私有仓库」扩展为「①私有/账号 ②网络/代理」两类，附配置命令 + 指向 git-guide §5.7。 |
| `scripts/sync-template.ps1` | PowerShell fallback 对称扩展（英文复刻）。 |
| `scripts/check-template.sh` | 加 2 条断言：`sync-template.sh` / `.ps1` 含代理提示关键词（`HTTPS_PROXY` / `http.proxy`）。 |
| `scripts/check-template.ps1` | 镜像断言（若该 fallback 含对应断言区）。 |
| `VERSION` / `CHANGELOG.md` | v1.54.1 → v1.54.2（patch）。 |

## 5. 去项目化

- 端口用 `<代理端口>` / `<proxy-port>` 占位，不写死任何本机端口。
- 不引用具体派生项目名、客户、路径、业务。
- 来源标识：派生项目国内网络同步踩坑回流（泛化）。

## 6. 风险与缓解

| 风险 | 影响 | 缓解 |
|---|---|---|
| 代理提示过长影响脚本输出 | 低 | 仅 fetch 失败时输出，正常流程无影响 |
| 断言关键词过窄误报 | 中 | 用 `HTTPS_PROXY`（gh 代理坑核心）+ `http.proxy` 双关键词 OR 匹配 |
| `.ps1` fallback 使用率低 | 低 | 仍对称加，保持双脚本镜像约定 |

## 7. 验收标准

- git-guide §5.7 含 git 代理 + gh 代理差异 + 失败症状。
- sync-template 双脚本 fetch 失败提示含网络/代理原因 + 配置命令。
- `check-template.sh` 自检 EXIT 0（含新断言）。
- 无具体端口 / 项目 / 客户信息。

## 8. 后续

- 若实际使用中代理配置有更优模式（如自动检测系统代理），再提案。
