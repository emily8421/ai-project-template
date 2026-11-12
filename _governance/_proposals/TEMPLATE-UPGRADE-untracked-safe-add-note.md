# TEMPLATE-UPGRADE: git-guide §3.1 补 untracked 安全 add 附注

> 来源：模板维护者（pitfall SUMMARY 第三次实证：2026-08-12 `.ai/tmp` / 2026-08-21 归档评估稿 / 2026-11-10 add-a-untracked-draft-stage）
> 状态：候选（待 C1 triage 与维护者拍板）
> 目标版本：待确认
> Release impact：patch（AI 建议，待维护者确认——流程文档附注级补强，不改变默认行为与流程结构）
> Release strategy：同主题聚合候选（可与其他 git-guide / 流程文档微调聚合为一个发布边界）

## 1. 动机（去项目化）

`git add -A` 在工作区存在**刻意未跟踪**文件（草稿 / 原稿 / 本地记录）时会将其一并暂存，同一模式已三次实证（pitfall SUMMARY 第四批两次 + 2026-11-10 第三次，均靠事后 `diff --stat` 对照复核拦下，未产生错误提交，但每次构成入库险情）：

1. 2026-08-12：`.ai/tmp` 临时文件被卷入 commit；
2. 2026-08-21：刻意未跟踪的 7 份评估稿被 `git add -A` 卷入 commit，push 后才发现，reset 重加修正；
3. 2026-11-10：untracked CJK 原稿（提案声明保留不入库）被暂存，`diff --stat` 发现 1293 行新文件后 reset 退出。

pitfall SUMMARY 第四批既定口径「复发第三次时转 git-guide / SOP 附注级窄提案」——第三次实证已达立案条件。前两次的处理只落在行为纪律层（AI 自觉），第三次仍复发，说明纪律未进操作文档就会重犯（「关键前置未进执行清单」家族口径）。

## 1.1 与既有规则的关系（去重）

- **`git-guide.md` §3.1 标准流程 / 合并后清理纪律**（v1.77.2 补后收尾顺序纪律）：管合并后的流程顺序。**互补不重复**——本提案管同一节内 add / commit 步的暂存范围纪律，同节不同面。
- **pitfall SUMMARY 第四批行为纪律**（「明确路径 `git add <清单>` + commit 后 `git show --stat` 复核」）：观察材料，未进操作文档。**机制不同**——本提案把行为纪律固化为操作文档附注（纪律 → 操作序列化）。
- **`template-docs/git-beginner-handbook.md`**（v1.78.0）：新手概念手册，头部已声明操作争议以 `git-guide.md` 权威 SOP 为准。**指向**——附注落 git-guide 权威位即可，不改手册。

**本提案不重复它们**：补的是「暂存范围安全」在操作文档中的空白——现行 §3.1 有流程顺序纪律，无 untracked 暂存范围提醒。

## 2. 拟改

`git-guide.md` §3.1「代码修改完成后的标准流程」add / commit 步骤附近补 1-2 行附注：

- 工作区有已知 untracked 草稿 / 原稿 / 本地记录时，禁用 `git add -A` / `git add .`，改显式路径 `git add <文件清单>`；
- 多文件提交前用 `git diff --stat`（暂存后 `git diff --cached --stat`）对照本次触碰文件清单，发现多出文件先 reset 核对再继续。

`SOP.md` 是否同步补一句随 triage 判断（倾向不双写：§3.1 是操作细节权威位，SOP 为入口索引时以指针衔接即可），避免双写漂移。

## 3. 版本影响

PATCH（AI 建议）：纯附注文案，不改变默认行为、流程结构、脚本或断言。

## 4. 影响面

- `git-guide.md`（在 `template-sync.json` `files_all` 同步清单内）——下游派生项目同步后共享。
- 不新增 `check-template.sh` 断言（附注为操作提醒，无机械可断言对象；与「无自检门禁、避免过度治理」口径一致）。

## 5. 验证方式

- `bash scripts/check-template.sh --summary` 全量自检 + `git diff --check` + `check-markdown-clean.ps1 _governance/_proposals _governance/ai-records`。
- 人工核对：附注与 §3.1 既有顺序纪律（v1.77.2）及 `ai/session-rules.md` §3.3「commit 前状态核对」衔接一致，不双写、不冲突。
- PATCH 级豁免 L3 e2e（纯文档附注，无脚本 / 同步清单 / 断言变更）。
