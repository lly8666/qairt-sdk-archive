# 工业水处理市场助手 — 本地试用
## 启动
下载专项CI的 catalyst-market-trial 产物，完整解压。安装 Python 3.10+。Windows 双击启动-Windows.bat；macOS/Linux 在解压目录执行 python3 launch_trial.py。自动打开浏览器，私有工作区在用户主目录 CatalystWaterWorkspace/workspace.sqlite，关闭控制台停止服务。也可从仓库根目录运行 python catalyst-research/app/workbench.py /path/catalyst.sqlite --workspace /仓库外/workspace.sqlite。
## 使用
首页进入客户/商机/技术/管理；客户档案提供公开证据、技术切入理由、原工艺图及同记录量质费；商机包含开发清单、项目、待办；技术包含版本、工程案例、经济测算；管理包含阶段、人员及市场概览。案例绑定已有技术版本，方向筛查不等于确认适配。工艺图按原Mermaid节点与箭头绘制，原文可查，不补猜连接。
实际公司案例、参数、成本、跟进仅在私有工作区录入，试用包未预置。已有历史数据、匿名测试均保留在仓库。备份使用 app/backup_workspace.py 源文件 新备份文件。当前仅本地单用户；多人共享前须在授权公司环境实现基本登录及备份，不做复杂审批。旧版 app.py 仍为只读。
