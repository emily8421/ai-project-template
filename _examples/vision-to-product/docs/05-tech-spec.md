# 05 技术方案

> 明确技术栈、关键决策和 Phase 技术约束；版本不确定时标“待确认”，不虚构。

## 1. 技术栈与版本

- 语言：Python 3.11
- 数据库：SQLite（Python 标准库 `sqlite3`）
- CLI：Python 标准库 `argparse`
- 路径处理：Python 标准库 `pathlib`
- 测试：pytest（待确认；若不引入依赖，可先用标准库 `unittest`）
- AI / 摘要：Phase1 默认规则摘要或 mock 摘要；真实模型接入待人工确认

## 2. 关键技术决策

- 使用本地 SQLite 文件保存知识条目，默认路径可由 CLI 参数或环境变量指定。
- CLI 层只负责参数解析和格式化输出，不直接写 SQL。
- 业务服务层统一调用摘要模块和 repository 层。
- 摘要模块定义可替换接口，Phase1 实现规则摘要，避免在线模型依赖。
- 搜索采用 SQLite `LIKE` 关键词匹配；语义检索放到愿景阶段。

## 3. Phase 技术约束

- 允许：标准库、SQLite、CLI、同步处理、规则摘要。
- 禁止：Web 框架、ORM、向量数据库、后台任务、真实在线模型默认接入。
- 如需引入第三方依赖，必须先更新 `ai/project-rules.md` §2 并经人工确认。

## 4. 编码约定

- Python 文件、函数、变量使用 snake_case；类名使用 PascalCase。
- `backend/cli.py`：CLI 参数解析与输出。
- `backend/service.py`：业务流程编排。
- `backend/repository.py`：SQLite 数据访问。
- `backend/db.py`：连接、建表、初始化。
- `backend/summarizer.py`：摘要策略。
- 测试命名采用 `tests/test_*.py`。
