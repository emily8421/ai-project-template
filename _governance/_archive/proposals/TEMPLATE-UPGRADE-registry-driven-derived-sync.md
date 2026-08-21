# TEMPLATE-UPGRADE: registry 驱动的派生项目下行同步

> 来源：模板维护者
> 状态：已处理（随 PR #272 落地）
> 目标版本：v1.57.3
> Release impact：patch（AI 建议，待维护者确认）
> Release strategy：单独发布

## 1. 背景

`ai-records/project-registry/` 已作为维护者侧派生项目索引落地，但 `sync-methodology` 和 A13 同步 SOP 仍默认从“当前已经在派生项目根目录”开始。维护者在模板仓目录下主动说“同步到派生项目 / 同步 4 派生”时，AI 不会先读取 registry，而是临时全盘找目录或等待用户提醒。

这会带来两个问题：

- 已登记的派生项目仍可能遗漏。
- 跨父目录项目（如 LUMEN）无法被 `sync-all-derived.sh <父目录>` 自动发现。

## 2. 拟改

- 扩展 registry 字段：aliases、sync mode、local path、path status。
- 明确 local path 是维护者本机定位信息，项目事实仍以派生项目内 `TEMPLATE-BASE.md` / `VERSION` 为准。
- 在 `sync-methodology` 和 `12-sync-template` 中新增“模板仓发起模式”：当前仓库是 `ai-project-template` 且用户要求同步派生项目时，必须先读取 `ai-records/project-registry/README.md` 与 `registry.md` 解析目标和路径。
- 在 `git-guide.md` / `MAINTAINERS.md` 中把批量同步说明改成“registry 优先，父目录扫描 fallback”。
- 补 `check-template.sh` 稳定关键词断言，防止 registry 流程再次从 SOP 中漂移。

## 3. 非目标

- 不改 `sync-template.*` 核心同步协议。
- 不让 registry 下行同步到派生项目。
- 不强制团队其他使用者登记项目。
- 不把 registry 的 point-in-time 版本字段当作 live 事实；live 仍回到各派生仓库读取。

## 4. 验证

- `git diff --check`
- `bash scripts/check-template.sh --summary`

## 5. 待确认项

| ID | 待确认项 | AI 建议 | 建议依据 | 备选方案 | 取舍影响 / 阻塞关系 |
|---|---|---|---|---|---|
| RDS-C-001 | registry 是否记录绝对本地路径 | 允许记录，但必须标注为维护者本机索引，并用 `Path status` 区分 verified / missing / stale-risk | 当前 registry 已有 LUMEN 绝对路径；从模板仓发起同步需要路径定位 | 改用 gitignored `.ai/project-paths.json` 存路径 | 更隐私，但同步前多一层读取；本次先兼容现状 |
| RDS-C-002 | 是否新增脚本自动读取 registry | 暂不新增，先修 SOP 和自检；脚本化另起提案 | 当前问题是 AI 流程未读取 registry，不是同步脚本能力不足 | 改 `sync-all-derived.sh` 支持 registry | 需要解析 Markdown / 本地路径，风险更高 |
