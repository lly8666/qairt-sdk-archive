"""Rebuild through migration 019, apply later migrations incrementally, compare full DB.
No external dependencies; no mutation of canonical CSV or historical migrations."""
from pathlib import Path
from tempfile import TemporaryDirectory
import shutil, sqlite3, subprocess, sys
from collections import Counter
root = Path(__file__).resolve().parent
full = Path(sys.argv[1]).resolve()
cutoff = int(sys.argv[2]) if len(sys.argv) > 2 else 19
with TemporaryDirectory() as tmp:
    work = Path(tmp)
    for name in ('build.py','schema.sql'):
        shutil.copy2(root/name, work/name)
    shutil.copytree(root/'data',work/'data')
    (work/'migrations').mkdir()
    patches = sorted((root/'migrations').glob('*.sql'))
    before = [p for p in patches if int(p.name.split('_')[0]) <= cutoff]
    after = [p for p in patches if int(p.name.split('_')[0]) > cutoff]
    assert before and after
    for p in before: shutil.copy2(p,work/'migrations'/p.name)
    inc=work/'incremental.sqlite'
    subprocess.run([sys.executable,str(work/'build.py'),str(inc)],check=True)
    with sqlite3.connect(inc) as a, sqlite3.connect(full) as b:
        a.execute('PRAGMA foreign_keys=ON')
        for p in after: a.executescript(p.read_text(encoding='utf-8'))
        for db in (a,b):
            assert db.execute('PRAGMA integrity_check').fetchall()==[('ok',)]
            assert not db.execute('PRAGMA foreign_key_check').fetchall()
        query="SELECT type,name FROM sqlite_master WHERE type IN ('table','view') AND name NOT LIKE 'sqlite_%' ORDER BY 1,2"
        objects=a.execute(query).fetchall()
        assert objects==b.execute(query).fetchall()
        for typ,name in objects:
            quoted='"'+name.replace('"','""')+'"'
            assert a.execute('PRAGMA table_info('+quoted+')').fetchall()==b.execute('PRAGMA table_info('+quoted+')').fetchall(), name
            # Counter compares both directions, including duplicate multiplicities and NULLs.
            aa=Counter(a.execute('SELECT * FROM '+quoted))
            bb=Counter(b.execute('SELECT * FROM '+quoted))
            assert aa==bb,(typ,name,len(aa-bb),len(bb-aa))
        print('incremental equivalence:', len(objects), 'tables/views; cutoff',cutoff,'applied',len(after),'patches; all rows and multiplicities match')
