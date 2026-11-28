"""Local trial workspace, separate from public market SQLite; no company data in repository."""
import sqlite3,json
from pathlib import Path
from capability import evaluate
from economics import calc,cashflow
DIRECTIONS={'high_salt','ammonia','metal_recovery','organic','evaporation','reuse','external_disposal','membrane_optimization','resource_recovery','capacity_retrofit','new_build_retrofit','procurement_followup'}
STAGES=('未联系','待确认','技术初筛','取样/小试','方案报价','项目推进','已成交','暂缓','关闭')
def open_workspace(path):
    p=Path(path).resolve()
    # This is a local, single-user trial; never store internal material inside the source repository.
    repo=Path(__file__).resolve().parents[2]
    if p.is_relative_to(repo):raise ValueError('工作区数据库必须在源码仓库外')
    p.parent.mkdir(parents=True,exist_ok=True)
    c=sqlite3.connect(p);c.row_factory=sqlite3.Row
    c.executescript("""
    CREATE TABLE IF NOT EXISTS capabilities(id INTEGER PRIMARY KEY,module TEXT NOT NULL,version INTEGER NOT NULL,directions TEXT NOT NULL,constraints TEXT NOT NULL,notes TEXT NOT NULL,created TEXT DEFAULT CURRENT_TIMESTAMP,UNIQUE(module,version));
    CREATE TABLE IF NOT EXISTS followups(id INTEGER PRIMARY KEY,site_id TEXT NOT NULL,candidate_id TEXT,stage TEXT NOT NULL,owner TEXT NOT NULL,next_action TEXT NOT NULL,next_date TEXT,notes TEXT NOT NULL,created TEXT DEFAULT CURRENT_TIMESTAMP);
    CREATE TABLE IF NOT EXISTS preferences(id INTEGER PRIMARY KEY CHECK(id=1),direct_private INTEGER NOT NULL DEFAULT 1,prefer_channels INTEGER NOT NULL DEFAULT 1);
    INSERT OR IGNORE INTO preferences(id) VALUES(1);
    """)
    return c
def records(c,q,p=()):return [dict(r) for r in c.execute(q,p)]
def save_capability(c,x):
    module=x['module'].strip();directions=x['directions'];constraints=x.get('constraints',[])
    if not module or not directions or not set(directions)<=DIRECTIONS:raise ValueError('填写技术名称及适用方向')
    # Validate simple constraint ranges once, not on every market scan.
    if constraints:evaluate({'version_id':'validate','constraints':constraints},{})
    version=c.execute('SELECT coalesce(max(version),0)+1 FROM capabilities WHERE module=?',(module,)).fetchone()[0]
    cur=c.execute('INSERT INTO capabilities(module,version,directions,constraints,notes) VALUES(?,?,?,?,?)',(module,version,json.dumps(directions),json.dumps(constraints,ensure_ascii=False),x.get('notes','')))
    c.commit();return {'id':cur.lastrowid,'version':version}
def capabilities(c):
    return [dict(r,directions=json.loads(r['directions']),constraints=json.loads(r['constraints'])) for r in records(c,'SELECT * FROM capabilities ORDER BY module,version DESC')]
def current_capabilities(c):
    return [x for x in capabilities(c) if x['version']==c.execute('SELECT max(version) FROM capabilities WHERE module=?',(x['module'],)).fetchone()[0]]
def add_followup(c,market,x):
    site=x['site_id'];candidate=x.get('candidate_id') or None
    if not market.execute('SELECT 1 FROM sites WHERE site_id=?',(site,)).fetchone():raise ValueError('主体不存在')
    if candidate and not market.execute('SELECT 1 FROM v_workbench_candidates WHERE candidate_id=? AND site_id=?',(candidate,site)).fetchone():raise ValueError('商机不属于该主体')
    if x['stage'] not in STAGES or not x.get('next_action','').strip():raise ValueError('填写阶段及下一步')
    cur=c.execute('INSERT INTO followups(site_id,candidate_id,stage,owner,next_action,next_date,notes) VALUES(?,?,?,?,?,?,?)',(site,candidate,x['stage'],x.get('owner',''),x['next_action'],x.get('next_date') or None,x.get('notes','')))
    c.commit();return {'id':cur.lastrowid}
def match_market(c,market,version_id=None):
    versions=capabilities(c)
    if version_id is not None:
        versions=[v for v in versions if v['id']==int(version_id)]
    else:versions=current_capabilities(c)
    result=[]
    for v in versions:
        for direction in v['directions']:
            for r in records(market,'SELECT c.*,s.name,s.province,s.subject_scope FROM v_workbench_candidates c JOIN v_workbench_subjects s USING(site_id) WHERE direction=?',(direction,)):
                result.append(dict(r,capability_id=v['id'],module=v['module'],version=v['version'],fit='direction_candidate_parameters_unknown',needed=[z['parameter'] for z in v['constraints']]))
    return result
def compare_versions(c,market,old,new):
    a=match_market(c,market,old);b=match_market(c,market,new)
    ka={r['candidate_id'] for r in a};kb={r['candidate_id'] for r in b}
    return {'before':len(ka),'after':len(kb),'added':sorted(kb-ka),'removed':sorted(ka-kb),'boundary':'direction coverage only; no confirmed engineering fit'}
