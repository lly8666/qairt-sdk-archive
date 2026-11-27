"""Build SQLite from canonical CSV, then apply ordered migrations. Python 3 stdlib."""
import csv, sqlite3, pathlib, sys
root=pathlib.Path(__file__).resolve().parent
out=pathlib.Path(sys.argv[1]) if len(sys.argv)>1 else root/'catalyst.sqlite'
if out.exists():
    raise SystemExit('Refusing to overwrite existing database: '+str(out))
db=sqlite3.connect(out)
try:
    db.executescript((root/'schema.sql').read_text(encoding='utf-8'))
    for table in ('sites','sources','site_sources','capacity','wastewater','projects','tasks','coverage'):
        with (root/'data'/f'{table}.csv').open(encoding='utf-8-sig',newline='') as f:
            reader=csv.DictReader(f)
            cols=reader.fieldnames
            expected=[r[1] for r in db.execute(f'PRAGMA table_info({table})')]
            assert cols==expected,(table,cols,expected)
            db.executemany(f"INSERT INTO {table} VALUES ({','.join('?' for _ in cols)})",([r[k] if r[k]!='' else None for k in cols] for r in reader))
    db.commit()
    for patch in sorted((root/'migrations').glob('*.sql')):
        db.executescript(patch.read_text(encoding='utf-8'))
    assert db.execute('PRAGMA integrity_check').fetchall()==[('ok',)]
    assert not db.execute('PRAGMA foreign_key_check').fetchall()
    for table in ('sites','capacity','wastewater','sources','tasks'):
        print(table,db.execute(f'SELECT count(*) FROM {table}').fetchone()[0])
    db.commit()
finally:
    db.close()
