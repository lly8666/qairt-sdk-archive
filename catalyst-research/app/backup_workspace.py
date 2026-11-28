"""Copy a consistent local workspace snapshot. Keep backups outside the source repository."""
import sqlite3,argparse
from pathlib import Path
def backup(source,target):
    source=Path(source).resolve();target=Path(target).resolve()
    if not source.is_file():raise ValueError('工作区不存在')
    if target.exists() or target.is_relative_to(Path(__file__).resolve().parents[2]):raise ValueError('备份必须为仓库外的新文件')
    target.parent.mkdir(parents=True,exist_ok=True)
    with sqlite3.connect(str(source)) as a,sqlite3.connect(str(target)) as b:
        a.backup(b)
        if b.execute('PRAGMA integrity_check').fetchone()[0]!='ok':raise ValueError('备份检查失败')
    return target
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('source');p.add_argument('target');a=p.parse_args();print(backup(a.source,a.target))
