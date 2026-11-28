"""Local project and service records. Public data remains read-only."""
import json
from workspace import records,capabilities,match_market,compare_versions
from practical import scenarios
STAGES=('资格确认','技术初筛','取样','小试','方案报价','项目推进','实施验收','售后','暂缓','关闭')
RELATIONS=('潜在客户','已服务客户','合作伙伴','暂缓')
SAMPLE_STATES=('计划','已取样','已检测','取消')
TRIAL_STATES=('计划','进行中','完成','取消')
def init(w):
    w.executescript("""
    CREATE TABLE IF NOT EXISTS customer_relationships(site_id TEXT PRIMARY KEY,relationship TEXT NOT NULL,notes TEXT NOT NULL,updated TEXT DEFAULT CURRENT_TIMESTAMP);
    CREATE TABLE IF NOT EXISTS private_projects(id INTEGER PRIMARY KEY,site_id TEXT NOT NULL,candidate_id TEXT,water_id TEXT,title TEXT NOT NULL,owner TEXT NOT NULL,stage TEXT NOT NULL,next_action TEXT NOT NULL,notes TEXT NOT NULL,created TEXT DEFAULT CURRENT_TIMESTAMP);
    CREATE TABLE IF NOT EXISTS project_events(id INTEGER PRIMARY KEY,project_id INTEGER NOT NULL REFERENCES private_projects(id),stage TEXT NOT NULL,next_action TEXT NOT NULL,notes TEXT NOT NULL,created TEXT DEFAULT CURRENT_TIMESTAMP);
    CREATE TABLE IF NOT EXISTS project_samples(id INTEGER PRIMARY KEY,project_id INTEGER NOT NULL REFERENCES private_projects(id),water_id TEXT NOT NULL,sample_label TEXT NOT NULL,owner TEXT NOT NULL,state TEXT NOT NULL,sampled_on TEXT,notes TEXT NOT NULL);
    CREATE TABLE IF NOT EXISTS project_trials(id INTEGER PRIMARY KEY,project_id INTEGER NOT NULL REFERENCES private_projects(id),sample_id INTEGER NOT NULL REFERENCES project_samples(id),capability_id INTEGER REFERENCES capabilities(id),objective TEXT NOT NULL,state TEXT NOT NULL,result TEXT NOT NULL);
    CREATE TABLE IF NOT EXISTS project_scenarios(id INTEGER PRIMARY KEY,project_id INTEGER NOT NULL REFERENCES private_projects(id),inputs TEXT NOT NULL,results TEXT NOT NULL,created TEXT DEFAULT CURRENT_TIMESTAMP);
    """)
def site(c,s):
    if not c.execute('SELECT 1 FROM sites WHERE site_id=?',(s,)).fetchone():raise ValueError('客户不存在')
def water(c,s,w):
    if not c.execute('SELECT 1 FROM wastewater WHERE site_id=? AND water_id=?',(s,w)).fetchone():raise ValueError('流股不属于客户')
def set_relationship(w,c,x):
    site(c,x['site_id'])
    if x['relationship'] not in RELATIONS:raise ValueError('客户关系无效')
    w.execute("INSERT INTO customer_relationships(site_id,relationship,notes) VALUES(?,?,?) ON CONFLICT(site_id) DO UPDATE SET relationship=excluded.relationship,notes=excluded.notes,updated=CURRENT_TIMESTAMP",(x['site_id'],x['relationship'],x.get('notes','')))
    w.commit();return {'saved':True}
def create_project(w,c,x):
    s=x['site_id'];site(c,s);cid=x.get('candidate_id') or None;wid=x.get('water_id') or None
    if cid and not c.execute('SELECT 1 FROM v_workbench_candidates WHERE candidate_id=? AND site_id=?',(cid,s)).fetchone():raise ValueError('方向不属于客户')
    if wid:water(c,s,wid)
    if cid and wid and not c.execute('SELECT 1 FROM v_workbench_water_signals WHERE site_id=? AND water_id=? AND direction=(SELECT direction FROM v_workbench_candidates WHERE candidate_id=?)',(s,wid,cid)).fetchone():raise ValueError('流股与该方向无公开关联；可不选方向')
    if not x['title'].strip() or not x['next_action'].strip() or x['stage'] not in STAGES:raise ValueError('填写项目、阶段及下一步')
    cur=w.execute('INSERT INTO private_projects(site_id,candidate_id,water_id,title,owner,stage,next_action,notes) VALUES(?,?,?,?,?,?,?,?)',(s,cid,wid,x['title'],x.get('owner',''),x['stage'],x['next_action'],x.get('notes','')))
    pid=cur.lastrowid;w.execute('INSERT INTO project_events(project_id,stage,next_action,notes) VALUES(?,?,?,?)',(pid,x['stage'],x['next_action'],x.get('notes','')));w.commit();return {'id':pid}
def project(w,pid):
    r=w.execute('SELECT * FROM private_projects WHERE id=?',(int(pid),)).fetchone()
    if not r:raise ValueError('项目不存在')
    return dict(r)
def advance(w,x):
    p=project(w,x['project_id'])
    if x['stage'] not in STAGES or not x['next_action'].strip():raise ValueError('填写阶段和下一步')
    w.execute('UPDATE private_projects SET stage=?,next_action=?,owner=? WHERE id=?',(x['stage'],x['next_action'],x.get('owner',p['owner']),p['id']))
    w.execute('INSERT INTO project_events(project_id,stage,next_action,notes) VALUES(?,?,?,?)',(p['id'],x['stage'],x['next_action'],x.get('notes','')));w.commit();return {'saved':True}
def save_sample(w,c,x):
    p=project(w,x['project_id']);water(c,p['site_id'],x['water_id'])
    if p['water_id'] and p['water_id']!=x['water_id']:raise ValueError('样品与项目流股不同')
    if x['state'] not in SAMPLE_STATES or not x['sample_label'].strip():raise ValueError('填写样品及状态')
    vals=(x['state'],x.get('sampled_on') or None,x.get('notes',''))
    if x.get('id'):
        r=w.execute('UPDATE project_samples SET state=?,sampled_on=?,notes=? WHERE id=? AND project_id=? AND water_id=?',vals+(x['id'],p['id'],x['water_id']))
        if not r.rowcount:raise ValueError('样品不存在')
        sid=x['id']
    else:sid=w.execute('INSERT INTO project_samples(project_id,water_id,sample_label,owner,state,sampled_on,notes) VALUES(?,?,?,?,?,?,?)',(p['id'],x['water_id'],x['sample_label'],x.get('owner',''))+vals).lastrowid
    w.commit();return {'id':sid}
def save_trial(w,x):
    p=project(w,x['project_id']);sid=x['sample_id']
    if not w.execute('SELECT 1 FROM project_samples WHERE id=? AND project_id=?',(sid,p['id'])).fetchone():raise ValueError('样品不属于项目')
    cap=x.get('capability_id') or None
    if cap and not w.execute('SELECT 1 FROM capabilities WHERE id=?',(cap,)).fetchone():raise ValueError('技术版本不存在')
    if x['state'] not in TRIAL_STATES or not x['objective'].strip() or (x['state']=='完成' and not x.get('result','').strip()):raise ValueError('填写目标、状态及完成结果')
    if x.get('id'):
        r=w.execute('UPDATE project_trials SET state=?,result=? WHERE id=? AND project_id=? AND sample_id=?',(x['state'],x.get('result',''),x['id'],p['id'],sid))
        if not r.rowcount:raise ValueError('小试不存在')
        tid=x['id']
    else:tid=w.execute('INSERT INTO project_trials(project_id,sample_id,capability_id,objective,state,result) VALUES(?,?,?,?,?,?)',(p['id'],sid,cap,x['objective'],x['state'],x.get('result',''))).lastrowid
    w.commit();return {'id':tid}
def save_scenarios(w,x):
    p=project(w,x['project_id']);r=scenarios(x)
    sid=w.execute('INSERT INTO project_scenarios(project_id,inputs,results) VALUES(?,?,?)',(p['id'],json.dumps({'common':x['common'],'cases':x['cases']},ensure_ascii=False),json.dumps(r,ensure_ascii=False))).lastrowid
    w.commit();return {'id':sid,'results':r}
def list_projects(w,c,site_id=''):
    a=records(w,'SELECT * FROM private_projects'+(' WHERE site_id=?' if site_id else '')+' ORDER BY id DESC',(site_id,) if site_id else ())
    for p in a:
        p['customer_name']=c.execute('SELECT name FROM sites WHERE site_id=?',(p['site_id'],)).fetchone()[0]
    return a
def project_detail(w,c,pid):
    p=project(w,pid)
    for key,table in [('events','project_events'),('samples','project_samples'),('trials','project_trials'),('scenarios','project_scenarios')]:
        p[key]=records(w,'SELECT * FROM '+table+' WHERE project_id=? ORDER BY id DESC',(p['id'],))
    for r in p['scenarios']:r['inputs']=json.loads(r['inputs']);r['results']=json.loads(r['results'])
    p['water_options']=records(c,'SELECT water_id,stream,stage FROM wastewater WHERE site_id=? ORDER BY water_id',(p['site_id'],))
    p['capabilities']=capabilities(w)
    return p
def upgrade_list(w,c,old,new):
    a=match_market(w,c,old);b=match_market(w,c,new);key=lambda r:(r['candidate_id'],r.get('water_id'))
    am={key(r):r for r in a};out=[]
    for r in b:
        prev=am.get(key(r))
        if prev is None or (prev['fit'],prev.get('reference_fit'))!=(r['fit'],r.get('reference_fit')):
            out.append(dict(r,before=prev['fit'] if prev else 'not_scanned',reference_before=prev.get('reference_fit') if prev else None,change='new_conditional' if r['fit']=='conditional' and (not prev or prev['fit']!='conditional') else 'review'))
    return sorted(out,key=lambda x:(x['change']!='new_conditional',x['site_id'],x.get('water_id') or ''))
