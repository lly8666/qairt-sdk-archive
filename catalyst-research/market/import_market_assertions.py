"""Append-only explicit market assertion import into a NEW copy. Never overwrite source DB."""
import argparse,json,sqlite3
from pathlib import Path
TABLES=('market_entities','market_identity_links','market_entity_relations','market_ownership_observations','market_procurement_observations','market_water_scope_reviews')
def import_rows(db, payload):
    if not isinstance(payload,dict) or set(payload)-set(TABLES):
        raise ValueError('unexpected tables')
    counts={}
    db.execute('SAVEPOINT market_import')
    try:
        for t in TABLES:
            cols=[r[1] for r in db.execute('PRAGMA table_info('+t+')')]
            if not cols: raise ValueError('missing table '+t)
            counts[t]=[0,0]
            for row in payload.get(t,[]):
                if not isinstance(row,dict) or set(row)!=set(cols):
                    raise ValueError('explicit complete columns required: '+t)
                vals=tuple(row[c] for c in cols)
                old=db.execute('SELECT * FROM '+t+' WHERE '+cols[0]+'=?',(vals[0],)).fetchone()
                if old is not None:
                    if tuple(old)!=vals: raise ValueError('conflicting stable ID: '+str(vals[0]))
                    counts[t][1]+=1
                else:
                    db.execute('INSERT INTO '+t+' ('+','.join(cols)+') VALUES ('+','.join('?' for c in cols)+')',vals)
                    counts[t][0]+=1
        if db.execute('PRAGMA foreign_key_check').fetchall(): raise ValueError('FK violation')
        db.execute('RELEASE market_import')
    except BaseException:
        db.execute('ROLLBACK TO market_import');db.execute('RELEASE market_import')
        raise
    return counts
def main():
    p=argparse.ArgumentParser();p.add_argument('database');p.add_argument('assertions');p.add_argument('new_database');a=p.parse_args()
    src=Path(a.database).resolve();out=Path(a.new_database).resolve()
    if out.exists() or not src.is_file(): raise SystemExit('source must exist; output must not exist')
    payload=json.loads(Path(a.assertions).read_text(encoding='utf-8'))
    try:
        with sqlite3.connect(src.as_uri()+'?mode=ro',uri=True) as origin,sqlite3.connect(out) as target:
            origin.backup(target);target.execute('PRAGMA foreign_keys=ON')
            print(json.dumps(import_rows(target,payload),ensure_ascii=False))
            assert target.execute('PRAGMA integrity_check').fetchone()[0]=='ok'
    except BaseException:
        out.unlink(missing_ok=True);raise
if __name__=='__main__':main()
