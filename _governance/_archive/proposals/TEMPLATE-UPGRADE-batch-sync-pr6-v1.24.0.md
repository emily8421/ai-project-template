# TEMPLATE-UPGRADE：批量同步派生项目 PR-6（v1.24.0）

> 去项目化提案。覆盖用户诉求 #15（23 场景未覆盖的「维护者一条指令批量更新派生项目」缺口）。v1.24 infrastructure release 第 1 个 PR。

## 动机

23 个场景里**没有覆盖**：维护者发新模板版本后，想一条指令批量更新指定目录下所有派生项目，不用逐个进派生项目终端。现有 A13（同步）是单派生、使用者视角（在派生项目内跑）；C6（验收）是单个；无批量维护者场景。是真实缺口。

## 拟改

- **`scripts/sync-all-derived.sh`**（template-local，不进 `template-sync.json`）：
  - 用法 `bash scripts/sync-all-derived.sh [父目录] [--dry-run|--commit] [--template <url>]`。
  - 遍历父目录子目录 → 判定派生项目（`VERSION`+`scripts/sync-template.sh`+`docs/`，排除模板本体 `_examples/`）→ 逐个 `git diff --quiet HEAD` 干净检查 → 跑该项目 `TEMPLATE_REMOTE=… bash scripts/sync-template.sh $MODE` → `--commit` 模式再跑 `check-derived-sync.sh` → 汇总（成功 / 跳过 / 失败）。
  - 默认 `--dry-run`；工作区有未提交跟踪改动 / 非派生 / 失败 自动跳过。`--commit` 在每个派生当前分支提交（PR-per-project 流程仍走 A13）。
- **新场景 C8 批量同步所有派生项目**（`scenario-guides.md`）：触发「批量同步 / sync all derived」；4 步 确认 → dry-run → commit → 汇总。
- **交叉引用**：scenario-guides（C8 + 速查索引 + §5 C 头）、SOP 场景索引 C8、MAINTAINERS 下行同步节、git-guide §5。
- **check-template 防滞后断言**：`require_file scripts/sync-all-derived.sh` + scenario-guides C8 + SOP/MAINTAINERS `sync-all-derived`。

## 版本影响

- v1.23.7 → **v1.24.0**（MINOR：新增脚本 + 场景，新功能）。v1.23 文档重构系列收官后的首个 feature release。
- 新增 4 条 check-template 断言；最小自测通过（2 假派生 + 非派生 + 模板本体）。**完整验证留维护者在真实多派生项目环境跑**。

## 影响面

- 非同步件：`scripts/sync-all-derived.sh`（template-local，类似 `check-template`）。
- 同步件：`scenario-guides.md`、`SOP.md`、`MAINTAINERS.md`、`git-guide.md`（加 C8 / 批量引用，派生项目下次同步获得）。
- 不影响：同步机制、`template-sync.json`、现有脚本行为。

## 落地流程

从 main（v1.23.7）切分支 `change/batch-sync-pr6-v1.24` → 写脚本 + 最小自测 → C8 场景 + 4 交叉引用 → check-template 加断言 → VERSION/CHANGELOG/提案 → PR-6。之后 PR-7（#9 测试基础设施 → v1.24.1）。
