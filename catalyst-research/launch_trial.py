"""Launch the local trial with the packaged public DB and a private user workspace."""
from pathlib import Path
import sys,subprocess,webbrowser,time,socket
root=Path(__file__).resolve().parent
db=root/'catalyst.sqlite'
workspace=Path.home()/'CatalystWaterWorkspace'/'workspace.sqlite'
if not db.is_file():raise SystemExit('缺少 catalyst.sqlite，请完整解压试用包。')
port=8765
with socket.socket() as s:
    s.bind(('127.0.0.1',0));port=s.getsockname()[1]
p=subprocess.Popen([sys.executable,str(root/'app'/'workbench.py'),str(db),'--workspace',str(workspace),'--port',str(port)])
try:
    for i in range(50):
        if p.poll() is not None:raise SystemExit('启动失败，请查看控制台。')
        try:
            with socket.create_connection(('127.0.0.1',port),timeout=.2):break
        except OSError:time.sleep(.1)
    print('工作区：',workspace,flush=True)
    webbrowser.open('http://127.0.0.1:'+str(port))
    p.wait()
except KeyboardInterrupt:pass
finally:
    if p.poll() is None:p.terminate();p.wait()
