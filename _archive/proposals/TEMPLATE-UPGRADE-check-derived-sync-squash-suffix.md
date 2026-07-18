# TEMPLATE-UPGRADE: check-derived-sync 容忍 squash 合并 (#N) 后缀

> Release impact: patch（AI 建议，待维护者确认）
> Release strategy: 单独发布
> 来源：派生项目 sync PR 经 `gh pr merge --squash` 合并到 main 后，check-derived-sync 对 HEAD 误报「提交信息不像模板同步提交」（digital-cs-demo v1.54.2 同步 PR#35、LUMEN-DEMO PR#82 等均复现）。

## 动机

派生项目 sync PR 用 `gh pr merge --squash` 合并到 main 后，main HEAD 的提交信息变为：

```
sync template vX.Y.Z from ai-project-template (#N)
```

（GitHub squash 默认在 PR 标题后追加 ` (#<PR 号>)`。）

而 `scripts/check-derived-sync.sh` / `.ps1` 的「提交信息是模板同步提交」判定用严格正则：

```
^sync template v... from ai-project-template$
```

`$` 结尾不容忍任何后缀 → 对 squash 合并到 main 的 HEAD 误报「提交信息不像模板同步提交」（EXIT 1，非真实边界问题）。脚本自身已提示「HEAD 是 merge commit 时改传实际 sync commit」，但每次同步后跑 check-derived-sync 都会命中此假阳性，制造混乱，且可能掩盖真实边界失败。

## 拟改

放宽 3 处 sync-commit 识别正则，允许可选 ` (#N)` 后缀：

1. `scripts/check-derived-sync.sh:114`（Bash ERE）：结尾 `$` 前加 `([[:space:]]\(#[0-9]+\))?`
2. `scripts/check-derived-sync.ps1:266`（PowerShell `-match`）：结尾 `$` 前加 `(\s+\(#[0-9]+\))?`
3. `scripts/new-project.sh:112`（生成的 project-check.yml 模板同款 Bash 正则）：同 #1

新正则仍拒绝任意其他后缀（如 `... fix`、`... (#35) extra`），只容忍 GitHub squash 默认的 ` (#N)`。

不修改 `scripts/check-template.sh` / `.ps1`：其 `require_doc_standards_mirror` 自检构造的是标准 sync 提交（无 (#N)），放宽后仍匹配，自检不受影响；不新增独立回归断言（避免 BRE/ERE 误用往返，留候选池）。

## 版本影响

- Release impact: **patch** —— 兼容性脚本修复（CONTRIBUTING §4 表「修同步脚本 bug」），不改变默认同步行为、不要求派生项目迁移、不新增采用面。
- VERSION: v1.54.2 → **v1.54.3**
- CHANGELOG: 新增 v1.54.3 条目。

## 影响面

- 下行同步：`check-derived-sync.sh` / `.ps1` 在 `template-sync.json` 清单内，下次同步自动到达所有派生项目。
- project-check.yml：`new-project.sh` 生成的版本含放宽正则；**存量**派生项目的 project-check.yml 不在 `template-sync.json`（项目专属，由 new-project.sh 生成），不会自动更新——存量项目下次同步只拿到 check-derived-sync 的修复（主信号），project-check.yml 内正则保持旧版（次要：仅影响 squash 合并 sync commit 到 main 时是否触发边界 CI，非阻断）。
- 无破坏性：放宽只新增对 `(#N)` 后缀的接受，标准 sync 提交仍匹配。

## 验证

- `bash scripts/check-template.sh` / `check-template.ps1` 自检 pass（`require_doc_standards_mirror` 不受影响）。
- 手工构造 `(#N)` 后缀 subject 验证 check-derived-sync 接受：标准 `sync template v1.54.3 from ai-project-template` 与 `... (#99)` 均判为同步提交；`... fix` 仍拒绝。
- 回流后下行同步到派生项目验证（后续 sync）。
