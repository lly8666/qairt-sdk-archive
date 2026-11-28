"""Package public-only local trial; Python 3.10+ on user device."""
from pathlib import Path
import sys,zipfile
root=Path(__file__).resolve().parent
with zipfile.ZipFile(sys.argv[2],'w',zipfile.ZIP_DEFLATED) as z:
    for p in sorted((root/'app').iterdir()):
        if p.suffix in ('.py','.html') and not p.name.startswith('test_'):z.write(p,'app/'+p.name)
    z.write(sys.argv[1],'catalyst.sqlite')
    z.write(root/'launch_trial.py','launch_trial.py')
    z.writestr('启动-Windows.bat','@echo off\r\ncd /d "%~dp0"\r\npy -3 launch_trial.py\r\npause\r\n')
    z.writestr('启动-macOS.command','#!/bin/sh\ncd "$(dirname "$0")"\npython3 launch_trial.py\n')
    z.writestr('使用说明.txt','工业水处理市场助手 - 本地试用\n安装 Python 3.10 或更高版本（Windows 安装时勾选 Python Launcher）。完整解压。Windows 双击启动-Windows.bat；macOS/Linux 在解压目录运行 python3 launch_trial.py。浏览器自动打开。关闭控制台停止服务。内部工作区位于用户主目录 CatalystWaterWorkspace/workspace.sqlite；请备份，不要上传。试用包只含公开数据和通用代码，未预置公司内部案例。仅本地单用户，不可用作联网多人部署。\n')
print(sys.argv[2])
