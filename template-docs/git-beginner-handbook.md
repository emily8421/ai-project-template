# Git 新手操作手册

> Sync notice: This file is maintained by `ai-project-template` and may be overwritten when a derived project syncs template methodology.
> Do not edit it directly in derived projects; propose reusable changes in `_governance/_proposals/` and upstream them to the template repository.

> 适合第一次接触 Git 的开发人员。
>
> 本手册重点讲清楚：Git 是什么、GitHub/GitLab 是什么，以及 `add`、`commit`、`push`、`pull` 等常用操作到底有什么区别。

**定位与优先级**：本手册只解释 Git 的基础概念和常用命令，帮你建立心智模型；它不是操作 SOP。本模板仓库及派生项目中的 Git / 模板同步操作（分支纪律、同步流程、远端操作、风险约束）以根目录 `git-guide.md` 为权威口径，与本手册表述不一致时以 `git-guide.md` 为准；安装与环境配置见 `template-docs/env-setup.md`。

---

## 1. 先搞清楚：Git、GitHub、GitLab 是什么？

先记住一句话：

> **Git 是管理代码版本的工具；GitHub 和 GitLab 是存放代码、协作开发的平台。**

可以把它们理解成：

```text
                 Git
          ┌───────────────┐
          │ 管理代码版本    │
          │ 记录修改历史    │
          │ 管理分支        │
          └───────┬───────┘
                  │
          可以连接到不同平台
             ┌────┴────┐
             ↓         ↓
         GitHub      GitLab
        代码平台     代码平台
```

### Git

Git 安装在你的电脑上。

例如：

```powershell
git --version
```

如果看到：

```text
git version 2.54.0.windows.1
```

说明 Git 已经安装。

Git 主要负责：

- 记录代码修改
- 保存不同版本
- 创建和管理分支
- 合并代码
- 撤销错误修改

### GitHub

GitHub 是一个在线代码托管和协作平台。

例如：

```text
GitHub
└── knowledge-base
```

你可以把自己的 Git 仓库放到 GitHub 上，与其他人协作。

### GitLab

GitLab 和 GitHub 类似，也是代码托管和协作平台。

很多公司会使用自己的 GitLab 来管理内部项目。

例如：

```text
公司 GitLab
├── OA 项目
├── PLM 项目
├── 内部平台项目
└── 其他研发项目
```

---

## 2. Git 最重要的四个地方

学习 Git 时，最容易混淆的是“代码到底在哪”。

可以先记住下面这张图：

```text
┌──────────────────┐
│ ① 工作区          │
│ 你正在修改的文件   │
└────────┬─────────┘
         │ git add
         ↓
┌──────────────────┐
│ ② 暂存区          │
│ 准备提交的修改     │
└────────┬─────────┘
         │ git commit
         ↓
┌──────────────────┐
│ ③ 本地仓库        │
│ 已保存的版本历史   │
└────────┬─────────┘
         │ git push
         ↓
┌──────────────────┐
│ ④ 远程仓库        │
│ GitHub / GitLab   │
└──────────────────┘
```

还有一个反方向的操作：

```text
GitHub / GitLab
       │
       │ git pull
       ↓
    本地仓库
```

### 用一句话记

```text
工作区 → 暂存区 → 本地仓库 → 远程仓库
         add       commit       push
```

---

## 3. 一次正常开发通常怎么做？

假设你要开发一个功能。

最常见的流程是：

```text
① 拉取最新代码
        ↓
② 修改代码
        ↓
③ 查看修改
        ↓
④ git add
        ↓
⑤ git commit
        ↓
⑥ git push
```

对应命令：

```powershell
git pull
git status
git diff
git add .
git commit -m "完成登录功能"
git push
```

不用一开始把所有命令都背下来。

先掌握：

> **`status → add → commit → push`**

再掌握：

> **`pull`**

这几个是日常使用频率最高的。

---

## 4. `git status`：先看看现在是什么情况

这是非常值得养成的习惯。

执行：

```powershell
git status
```

Git 会告诉你当前有哪些变化。

例如：

```text
modified:   app.js
modified:   README.md
untracked:  test.py
```

意思是：

```text
app.js       修改了
README.md    修改了
test.py      新文件，还没有加入 Git
```

所以：

> **不知道现在该做什么时，先执行 `git status`。**

---

## 5. `git add`：告诉 Git 哪些修改准备提交

假设你修改了：

```text
app.js
README.md
```

执行：

```powershell
git add .
```

意思是：

> 把当前修改放到“暂存区”，准备提交。

注意：

**`git add` 还没有真正保存一个版本。**

只是告诉 Git：

```text
这些修改，我准备提交。
```

也可以只添加一个文件：

```powershell
git add app.js
```

---

## 6. `git commit`：保存一个版本

执行：

```powershell
git commit -m "完成登录功能"
```

意思是：

> 把暂存区里的修改保存成一个版本。

例如：

```text
第一次提交
↓
初始化项目

第二次提交
↓
完成登录页面

第三次提交
↓
修复登录 Bug
```

每一次 commit 都会留下记录。

以后查看历史：

```powershell
git log
```

---

## 7. `commit` 和 `push` 有什么区别？

这是新手最容易混淆的地方。

### commit

```text
修改代码
   ↓
git add
   ↓
git commit
   ↓
保存到自己的电脑
```

### push

```text
电脑上的 commit
       ↓
   git push
       ↓
GitHub / GitLab
```

所以：

> **commit = 保存到本地 Git**
>
> **push = 上传到远程仓库**

例如：

```text
你的电脑
┌────────────────┐
│ commit 1       │
│ commit 2       │
│ commit 3       │
└───────┬────────┘
        │
     git push
        ↓
┌────────────────┐
│ GitHub / GitLab│
│ commit 1       │
│ commit 2       │
│ commit 3       │
└────────────────┘
```

---

## 8. `git push`：把代码上传到远程仓库

执行：

```powershell
git push
```

就是把本地已经 commit 的内容上传到 GitHub 或 GitLab。

例如：

```text
本地
  │
  │ git push
  ↓
GitHub
```

注意：

```text
git push
```

通常不会帮你提交没有 commit 的修改。

也就是说，如果你只是：

```powershell
git add .
```

还没有：

```powershell
git commit
```

那么通常不能靠 `git push` 把这些修改直接作为一个版本上传。

完整流程是：

```powershell
git add .
git commit -m "完成 XXX 功能"
git push
```

---

## 9. `git pull`：把远程最新代码拿到本地

假设你和同事一起开发。

同事：

```text
修改代码
   ↓
commit
   ↓
push
   ↓
GitLab
```

这时候 GitLab 上的代码比你电脑上的新。

你执行：

```powershell
git pull
```

就可以把远程的新内容拉到本地。

```text
同事电脑
   │
   │ push
   ↓
GitLab
   │
   │ pull
   ↓
你的电脑
```

所以很好记：

```text
push = 往远程放

pull = 从远程拿
```

---

## 10. `git clone`：第一次把项目拿到电脑

如果电脑上还没有这个项目，可以：

```powershell
git clone <项目地址>
```

例如：

```powershell
git clone https://github.com/xxx/knowledge-base.git
```

它会把远程项目复制到电脑。

所以：

```text
clone = 第一次拿项目

pull = 已经有项目，再更新
```

可以这样理解：

```text
GitHub
   │
   │ git clone
   ↓
电脑
```

以后代码有更新：

```text
GitHub
   │
   │ git pull
   ↓
电脑
```

---

## 11. `git fetch`：只把远程变化拿回来看看

`fetch` 和 `pull` 很像，但有一个重要区别。

```powershell
git fetch
```

作用是：

> 获取远程仓库的最新信息，但先不把这些变化合并到当前代码。

而：

```powershell
git pull
```

通常相当于：

```text
获取远程变化
+
把变化合并到当前分支
```

新手阶段可以简单记：

```text
fetch = 先看看远程有什么变化

pull = 把远程变化拿下来并更新本地
```

日常开发中，如果只是想保持代码最新，通常直接用：

```powershell
git pull
```

---

## 12. `git branch`：分支是什么？

分支可以理解成：

> **从当前代码复制出一条独立的开发线路。**

例如：

```text
main
 │
 ● A
 │
 ● B
 │
 ● C
```

现在要开发“登录功能”。

可以创建：

```text
main
 │
 ● A
 │
 ● B
 │
 ● C
      \
       ● D
       │
       ● E
     feature-login
```

这样你可以在 `feature-login` 上开发，而不会直接影响 `main`。

查看分支：

```powershell
git branch
```

---

## 13. `git switch`：切换分支

创建并切换到新分支：

```powershell
git switch -c feature-login
```

以后切回 main：

```powershell
git switch main
```

切回登录功能分支：

```powershell
git switch feature-login
```

可以记成：

```text
branch = 分支

switch = 换到另一个分支
```

---

## 14. `git merge`：合并分支

假设你已经完成登录功能：

```text
main
 │
 A
 │
 B
 │
 C
      \
       D
       │
       E
    feature-login
```

现在要把登录功能合并到 main：

```powershell
git switch main
git merge feature-login
```

结果：

```text
main
 │
 A
 │
 B
 │
 C
 │
 D
 │
 E
```

也就是：

> **merge = 把一个分支的修改合并到另一个分支。**

---

## 15. GitHub 的 PR 和 GitLab 的 MR

团队开发时，经常不会直接把功能分支 merge 到 main。

一般会：

```text
开发分支
    ↓
git push
    ↓
GitHub / GitLab
    ↓
提交代码审核
    ↓
审核通过
    ↓
合并到 main
```

GitHub 叫：

> **Pull Request（PR）**

GitLab 叫：

> **Merge Request（MR）**

它们的用途非常接近：

```text
我写好了代码
      ↓
请别人帮我检查
      ↓
检查通过
      ↓
合并到主分支
```

---

## 16. `git stash`：代码写一半，临时收起来

假设你正在开发：

```text
feature-A
```

代码写了一半，还不能 commit。

突然需要切去修一个紧急 Bug。

这时候可以：

```powershell
git stash
```

Git 会暂时把当前修改收起来。

然后你可以切换分支：

```powershell
git switch main
```

处理完其他事情后，再恢复：

```powershell
git stash pop
```

可以记成：

```text
stash = 暂时收起来

stash pop = 再拿回来
```

---

## 17. `git log`：查看历史记录

执行：

```powershell
git log
```

可以看到之前的提交。

例如：

```text
commit 8a32...
修复登录 Bug

commit 5b21...
增加登录功能

commit 1c42...
初始化项目
```

可以理解成项目的“修改历史”。

---

## 18. `git diff`：看看自己到底改了什么

执行：

```powershell
git diff
```

Git 会显示具体修改。

例如：

```diff
- const name = "Tom";
+ const name = "Jack";
```

意思是：

```text
旧内容：Tom
新内容：Jack
```

所以：

```text
git status
    ↓
看哪些文件改了

git diff
    ↓
看具体改了什么
```

---

## 19. `git restore`：放弃没有提交的修改

假设你修改了：

```text
app.js
```

后来发现改错了，而且这些修改还没有 commit。

可以使用：

```powershell
git restore app.js
```

把文件恢复到之前的状态。

注意：

> **这个操作可能会直接丢掉未提交的修改。**

所以使用前一定确认自己真的不需要这些修改。

---

## 20. `git revert`：撤销已经提交的修改

假设：

```text
A → B → C
```

发现 C 有问题。

使用：

```powershell
git revert <commit>
```

Git 会创建一个新的提交，用来抵消之前那个提交的效果。

大致变成：

```text
A → B → C → D
          错误   ↑
                 撤销 C
```

它不会直接删除历史。

团队协作时，`revert` 通常比直接修改历史更安全。

---

## 21. `git reset`：回退历史

`reset` 也可以用于回退，但它会改变当前分支的历史位置。

例如：

```text
A → B → C → D
```

回退之后可能变成：

```text
A → B
```

因为它涉及 Git 历史和提交指针，使用时需要特别小心。

**新手阶段不要随便使用 `git reset --hard`。**

---

## 22. `git remote`：远程仓库在哪里？

一个本地 Git 项目可以连接远程仓库。

查看远程仓库：

```powershell
git remote -v
```

可能看到：

```text
origin  https://github.com/xxx/project.git
origin  https://github.com/xxx/project.git
```

这里的：

```text
origin
```

只是远程仓库的一个名字。

可以理解成：

```text
origin
   ↓
GitHub 上的那个项目
```

所以：

```powershell
git push origin main
```

意思就是：

> 把本地 `main` 分支推送到叫 `origin` 的远程仓库。

---

## 23. `git init`：让一个普通文件夹开始使用 Git

假设你有：

```text
D:\my-project
```

它原来只是普通文件夹。

进入这个文件夹：

```powershell
cd D:\my-project
```

执行：

```powershell
git init
```

Git 就开始管理这个项目。

通常会出现一个：

```text
.git
```

目录。

这个目录保存 Git 的版本信息。

---

## 24. 最常用命令速查表

| 命令 | 简单理解 | 使用频率 |
|---|---|---|
| `git status` | 看当前状态 | ⭐⭐⭐⭐⭐ |
| `git add` | 准备提交 | ⭐⭐⭐⭐⭐ |
| `git commit` | 保存一个版本 | ⭐⭐⭐⭐⭐ |
| `git push` | 上传到远程 | ⭐⭐⭐⭐⭐ |
| `git pull` | 更新本地代码 | ⭐⭐⭐⭐⭐ |
| `git clone` | 第一次下载项目 | ⭐⭐⭐⭐ |
| `git branch` | 查看/管理分支 | ⭐⭐⭐⭐ |
| `git switch` | 切换分支 | ⭐⭐⭐⭐ |
| `git merge` | 合并分支 | ⭐⭐⭐ |
| `git diff` | 查看具体修改 | ⭐⭐⭐⭐ |
| `git log` | 查看提交历史 | ⭐⭐⭐ |
| `git stash` | 临时收起修改 | ⭐⭐⭐ |
| `git fetch` | 获取远程变化 | ⭐⭐ |
| `git remote` | 查看远程仓库 | ⭐⭐ |
| `git restore` | 放弃未提交修改 | ⭐⭐ |
| `git revert` | 撤销已提交修改 | ⭐⭐ |
| `git reset` | 回退历史 | ⭐ |

---

## 25. 一张图记住常用命令

```text
                    GitHub / GitLab
                           ↑
                           │
                        git push
                           │
                           │
┌──────────────────────────┴────────────────────┐
│                       本地                     │
│                                               │
│  工作区       暂存区       本地仓库            │
│                                               │
│  修改文件 ──add──→ 准备提交 ──commit──→ 版本   │
│                                               │
│     ↑                                         │
│     │                                         │
│   restore                                     │
│                                               │
└───────────────────────┬───────────────────────┘
                        │
                      git pull
                        │
                        ↓
                 GitHub / GitLab
```

---

## 26. 最重要的一套日常操作

如果你现在刚开始学 Git，不需要一次掌握几十个命令。

先把下面这套练熟：

### 第一步：看看状态

```powershell
git status
```

### 第二步：修改代码

```text
修改文件
```

### 第三步：看看改了什么

```powershell
git diff
```

### 第四步：准备提交

```powershell
git add .
```

### 第五步：保存版本

```powershell
git commit -m "完成 XXX 功能"
```

### 第六步：上传

```powershell
git push
```

完整就是：

```text
修改代码
   ↓
git status
   ↓
git diff
   ↓
git add .
   ↓
git commit -m "完成 XXX 功能"
   ↓
git push
```

---

## 27. 如果同事已经修改了代码

开始工作前，可以：

```powershell
git pull
```

然后再修改。

一天的常见工作流程：

```text
开始工作
   ↓
git pull
   ↓
修改代码
   ↓
git status
   ↓
git diff
   ↓
git add .
   ↓
git commit
   ↓
git push
```

---

## 28. 新手最容易混淆的几组命令

### `commit` vs `push`

```text
commit
= 保存到本地

push
= 上传到 GitHub/GitLab
```

---

### `pull` vs `clone`

```text
clone
= 电脑还没有项目，第一次下载

pull
= 电脑已经有项目，更新到最新
```

---

### `fetch` vs `pull`

```text
fetch
= 获取远程变化，先不合并

pull
= 获取远程变化并更新本地
```

---

### `branch` vs `switch`

```text
branch
= 管理分支

switch
= 切换到某个分支
```

---

### `merge` vs `push`

```text
merge
= 本地把两个分支合并

push
= 把本地内容上传到远程
```

两件事情完全不同。

---

### `revert` vs `reset`

```text
revert
= 创建一个新的提交来撤销之前的修改

reset
= 回退 Git 的历史位置
```

新手优先使用 `revert`，使用 `reset` 前先确认自己知道它会产生什么结果。

---

## 29. 新手学习顺序

建议按照这个顺序学习：

### 第一阶段：先会正常提交代码

```text
git status
git add
git commit
git push
git pull
```

### 第二阶段：学会分支

```text
git branch
git switch
git merge
```

### 第三阶段：学会查看和临时处理

```text
git diff
git log
git stash
git fetch
```

### 第四阶段：再学习撤销

```text
git restore
git revert
git reset
```

---

## 30. 最后只记住这张表

| 我想做什么 | 用什么 |
|---|---|
| 看现在什么情况 | `git status` |
| 看具体改了什么 | `git diff` |
| 准备提交修改 | `git add` |
| 保存一个版本 | `git commit` |
| 上传到 GitHub/GitLab | `git push` |
| 获取远程最新代码 | `git pull` |
| 第一次下载项目 | `git clone` |
| 查看分支 | `git branch` |
| 创建分支 | `git branch` / `git switch -c` |
| 切换分支 | `git switch` |
| 合并分支 | `git merge` |
| 查看历史 | `git log` |
| 临时收起修改 | `git stash` |
| 恢复 stash | `git stash pop` |
| 获取远程变化但先不合并 | `git fetch` |
| 放弃未提交修改 | `git restore` |
| 撤销已经提交的修改 | `git revert` |
| 回退历史 | `git reset` |

---

## 一句话总结

```text
Git = 管理代码版本

GitHub / GitLab = 存放 Git 仓库、团队协作

status = 看情况
add = 准备提交
commit = 保存版本
push = 上传
pull = 更新
clone = 第一次下载
branch = 分支
switch = 切换
merge = 合并
stash = 暂时收起来
revert = 撤销提交
reset = 回退历史
```

日常开发最核心的一条线：

```text
git pull
    ↓
修改代码
    ↓
git status
    ↓
git add .
    ↓
git commit -m "完成 XXX"
    ↓
git push
```
