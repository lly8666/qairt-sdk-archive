"""Local single-user trial workspace. Keep this SQLite file outside the public repository."""
import json,math,sqlite3
from datetime import date
from pathlib import Path
from capability import evaluate
DIRECTIONS={'high_salt','ammonia','metal_recovery','organic','evaporation','reuse','external_disposal','membrane_optimization','resource_recovery','capacity_retrofit','new_build_retrofit','procurement_followup'}
STAGES=('未联系','待确认','技术初筛','取样/小试','方案报价','项目推进','已成交','暂缓','关闭')
SCOPES={'feed','permeate','concentrate','process','other'}
BASES={'actual_verified','customer_disclosed','synthetic'}
def open_workspace(path):
    p=Path(path).resolve()
    repo=Path(__file__).resolve().parents[2]
    if p.is_relative_to(repo):raise ValueError('工作区数据库必须在源码仓库外')
    p.parent.mkdir(parents=True,exist_ok=True)
    c=sqlite3.connect(p);c.row_factory=sqlite3.Row
    c.executescript("""
    CREATE TABLE IF NOT EXISTS capabilities(id INTEGER PRIMARY KEY,module TEXT NOT NULL,version INTEGER NOT NULL,directions TEXT NOT NULL,constraints TEXT NOT NULL,notes TEXT NOT NULL,created TEXT DEFAULT CURRENT_TIMESTAMP,UNIQUE(module,version));
    CREATE TABLE IF NOT EXISTS followups(id INTEGER PRIMARY KEY,site_id TEXT NOT NULL,candidate_id TEXT,stage TEXT NOT NULL,owner TEXT NOT NULL,next_action TEXT NOT NULL,next_date TEXT,notes TEXT NOT NULL,created TEXT DEFAULT CURRENT_TIMESTAMP);
    CREATE TABLE IF NOT EXISTS stream_observations(id INTEGER PRIMARY KEY,site_id TEXT NOT NULL,water_id TEXT NOT NULL,parameter TEXT NOT NULL,value REAL NOT NULL,unit TEXT NOT NULL,scope TEXT NOT NULL,basis TEXT NOT NULL,observed_on TEXT NOT NULL,notes TEXT NOT NULL,created TEXT DEFAULT CURRENT_TIMESTAMP);
    CREATE TABLE IF NOT EXISTS preferences(id INTEGER PRIMARY KEY CHECK(id=1),direct_private INTEGER NOT NULL DEFAULT 1,prefer_channels INTEGER NOT NULL DEFAULT 1);
    INSERT OR IGNORE INTO preferences(id) VALUES(1);
    """)
    if 'completed' not in {r['name'] for r in c.execute('PRAGMA table_info(followups)')}:
        c.execute('ALTER TABLE followups ADD COLUMN completed INTEGER NOT NULL DEFAULT 0')
    c.commit()
    return c
def records(c,q,p=()):return [dict(r) for r in c.execute(q,p)]
def save_capability(c,x):
    module=x['module'].strip();directions=x['directions'];constraints=x.get('constraints',[])
    if not module or not directions or not set(directions)<=DIRECTIONS:raise ValueError('填写技术名称及适用方向')
    if constraints:evaluate({'version_id':'validate','constraints':constraints},{})
    version=c.execute('SELECT coalesce(max(version),0)+1 FROM capabilities WHERE module=?',(module,)).fetchone()[0]
    cur=c.execute('INSERT INTO capabilities(module,version,directions,constraints,notes) VALUES(?,?,?,?,?)',(module,version,json.dumps(directions),json.dumps(constraints,ensure_ascii=False),x.get('notes','')))
    c.commit();return {'id':cur.lastrowid,'version':version}
def capabilities(c):
    return [dict(r,directions=json.loads(r['directions']),constraints=json.loads(r['constraints'])) for r in records(c,'SELECT * FROM capabilities ORDER BY module,version DESC')]
def current_capabilities(c):
    latest={r['module']:r['version'] for r in records(c,'SELECT module,max(version) version FROM capabilities GROUP BY module')}
    return [x for x in capabilities(c) if x['version']==latest[x['module']]]
def add_followup(c,market,x):
    site=x['site_id'];candidate=x.get('candidate_id') or None
    if not market.execute('SELECT 1 FROM sites WHERE site_id=?',(site,)).fetchone():raise ValueError('主体不存在')
    if candidate and not market.execute('SELECT 1 FROM v_workbench_candidates WHERE candidate_id=? AND site_id=?',(candidate,site)).fetchone():raise ValueError('商机不属于该主体')
    if x['stage'] not in STAGES or not x.get('next_action','').strip():raise ValueError('填写阶段及下一步')
    cur=c.execute('INSERT INTO followups(site_id,candidate_id,stage,owner,next_action,next_date,notes) VALUES(?,?,?,?,?,?,?)',(site,candidate,x['stage'],x.get('owner',''),x['next_action'],x.get('next_date') or None,x.get('notes','')))
    c.commit();return {'id':cur.lastrowid}
def complete_followup(c,followup_id):
    cur=c.execute('UPDATE followups SET completed=1 WHERE id=?',(int(followup_id),))
    c.commit()
    return cur.rowcount==1
def task_list(c):
    today=date.today().isoformat()
    return {'overdue':records(c,"SELECT * FROM followups WHERE completed=0 AND next_date IS NOT NULL AND next_date<? ORDER BY next_date,id",(today,)),
      'today':records(c,"SELECT * FROM followups WHERE completed=0 AND next_date=? ORDER BY id",(today,)),
      'upcoming':records(c,"SELECT * FROM followups WHERE completed=0 AND next_date>? AND next_date<=date(?,'+7 day') ORDER BY next_date,id",(today,today)),
      'undated':records(c,"SELECT * FROM followups WHERE completed=0 AND (next_date IS NULL OR trim(next_date)='') ORDER BY id DESC"),
      'completed_count':c.execute('SELECT count(*) FROM followups WHERE completed=1').fetchone()[0]}
def save_stream_observation(c,market,x):
    site=x['site_id'];water=x['water_id'];parameter=x['parameter'].strip();unit=x['unit'].strip();scope=x['scope'];basis=x['basis'];value=x['value']
    if not market.execute('SELECT 1 FROM wastewater WHERE site_id=? AND water_id=?',(site,water)).fetchone():raise ValueError('流股不存在')
    if not parameter or not unit or scope not in SCOPES or basis not in BASES:raise ValueError('参数、单位、范围或依据无效')
    if not isinstance(value,(int,float)) or isinstance(value,bool) or not math.isfinite(value):raise ValueError('参数值无效')
    cur=c.execute('INSERT INTO stream_observations(site_id,water_id,parameter,value,unit,scope,basis,observed_on,notes) VALUES(?,?,?,?,?,?,?,?,?)',(site,water,parameter,value,unit,scope,basis,x.get('observed_on') or date.today().isoformat(),x.get('notes','')))
    c.commit();return {'id':cur.lastrowid}
def stream_observations(c,site,water):
    return records(c,'SELECT * FROM stream_observations WHERE site_id=? AND water_id=? ORDER BY observed_on DESC,id DESC',(site,water))
def match_market(c,market,version_id=None):
    versions=capabilities(c)
    if version_id is not None:versions=[v for v in versions if v['id']==int(version_id)]
    else:versions=current_capabilities(c)
    result=[]
    for v in versions:
        for direction in v['directions']:
            candidates=records(market,'SELECT c.*,s.name,s.province,s.subject_scope FROM v_workbench_candidates c JOIN v_workbench_subjects s USING(site_id) WHERE direction=?',(direction,))
            for candidate in candidates:
                signals=records(market,'SELECT * FROM v_workbench_water_signals WHERE site_id=? AND direction=? ORDER BY water_id',(candidate['site_id'],direction))
                if not signals:
                    result.append(dict(candidate,capability_id=v['id'],module=v['module'],version=v['version'],water_id=None,fit='unknown',checks=[],needed=[z['parameter'] for z in v['constraints']]))
                    continue
                for sig in signals:
                    obsrows=stream_observations(c,candidate['site_id'],sig['water_id'])
                    obsmap={}
                    for obs in obsrows:
                        key=obs['parameter']+'|'+obs['scope']
                        if key not in obsmap:obsmap[key]={'value':obs['value'],'unit':obs['unit'],'scope':obs['scope'],'basis':obs['basis']}
                    fit=evaluate({'version_id':str(v['id']),'constraints':v['constraints']},obsmap)
                    missing=[z['parameter'] for z in fit['checks'] if z['state']=='unknown']
                    result.append(dict(candidate,capability_id=v['id'],module=v['module'],version=v['version'],water_id=sig['water_id'],stream=sig['stream'],signal_strength=sig['signal_strength'],fit=fit['state'],checks=fit['checks'],needed=missing))
    return result
def compare_versions(c,market,old,new):
    a=match_market(c,market,old);b=match_market(c,market,new)
    key=lambda r:(r['candidate_id'],r.get('water_id'))
    am={key(r):r for r in a};bm={key(r):r for r in b}
    added=sorted([list(k) for k in bm.keys()-am.keys()])
    removed=sorted([list(k) for k in am.keys()-bm.keys()])
    changed=[{'candidate':list(k),'before':am[k]['fit'],'after':bm[k]['fit']} for k in am.keys()&bm.keys() if am[k]['fit']!=bm[k]['fit']]
    return {'before':len(a),'after':len(b),'added':added,'removed':removed,'changed':changed,'boundary':'按版本、方向、流股比较；参数不足时仍为unknown，不代表工程确认'}
