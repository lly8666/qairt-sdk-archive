"""Product-facing evidence cards, original flowcharts and private case library."""
import json,re
from workspace import records,capabilities,match_market,DIRECTIONS
from projects import site,water
ADVICE={
'high_salt':'分流后核盐种、TDS、硬度和硅，比较膜预浓缩与既有浓缩/蒸发接口。',
'ammonia':'核氨氮、pH、温度及游离氨，比较氨回收或预处理后膜分离；不默认膜可直接脱氨。',
'metal_recovery':'先核目标金属形态、浓度及杂质，比较选择性分离、资源回收和浓水回收路线。',
'organic':'核COD/TOC、溶剂及膜相容性，先明确前处理和污染控制。',
'evaporation':'确认进入蒸发器的实际量及单位能耗，比较旁路膜预浓缩、浓水回蒸发。',
'reuse':'核实际回用水质目标及需求，比较预处理与膜深度处理。',
'external_disposal':'核外委废液实量、成分及处置单价，评估减量后残液合规去向。',
'membrane_optimization':'核已有膜用途、进水、通量、回收率和清洗周期，优先运行优化。',
'resource_recovery':'确认回收物品质、销路、回收收益及残液去向。',
'capacity_retrofit':'核实际负荷和扩容瓶颈，评估分流或膜扩容。',
'new_build_retrofit':'确认设计阶段、项目业主与设计/EPC接口，比较工艺方案。',
'procurement_followup':'核采购包、截止时间、准入条件及后续服务需求。'}
def brief(c,sid):
    s=c.execute('SELECT * FROM v_workbench_sales_scope WHERE site_id=?',(sid,)).fetchone()
    if not s:return None
    out=[]
    for r in records(c,'SELECT * FROM v_workbench_candidates WHERE site_id=? ORDER BY priority_band IS NULL,priority_band,direct_water_records DESC,direction',(sid,)):
        sig=records(c,"SELECT * FROM v_workbench_signal_evidence WHERE site_id=? AND direction=? ORDER BY signal_strength='direct' DESC,same_source_concentration_records DESC,linked_cost_records DESC,water_id",(sid,r['direction']))
        r['examples']=sig[:3]
        r['technical_entry']=ADVICE.get(r['direction'],'先确认具体流股、处理目标和现有设施。')
        r['why']=r['evidence_signal'] or ('公开废水记录命中该方向，共'+str(r['water_records'])+'条；其中直接词命中'+str(r['direct_water_records'])+'条。')
        out.append(r)
    return {'directions':out,'legal_ownership':s['legal_ownership'],'group_ownership':s['group_ownership'],'usable_channels':s['usable_channels'],'procurement_count':s['procurement_count'],'boundary':'公开证据初筛及通用技术建议；不是已确认需求或适配。'}
# Parse the actual repository flowchart subset, retain direction and dotted edges.
NODE=re.compile(r'^\s*([A-Za-z0-9_]+)(?:\[(?:"([^"]*)"|([^\]]*))\])?\s*$')
ARROW=re.compile(r'\s*(-->|-\.\->)(?:\s*\|([^|]*)\|)?\s*')
def graph(text):
    nodes={};edges=[];unparsed=[]
    def n(part):
        m=NODE.fullmatch(part)
        if not m:return None
        k=m[1];label=m[2] if m[2] is not None else m[3]
        if label is not None:nodes[k]=label
        else:nodes.setdefault(k,k)
        return k
    for line in text.splitlines():
        line=line.strip()
        if not line or line.startswith(('flowchart ','graph ')):continue
        line=re.sub(r'-\.\s*"([^"]*)"\s*\.\->',lambda m:'-.->|'+m[1]+'|',line)
        parts=ARROW.split(line)
        if len(parts)==1:
            if n(line) is None:unparsed.append(line)
            continue
        # Parse whole line before keeping its edges.
        ids=[n(parts[i]) for i in range(0,len(parts),3)]
        if None in ids:unparsed.append(line);continue
        for i,(a,b) in enumerate(zip(ids,ids[1:])):
            edges.append({'from':a,'to':b,'label':parts[3*i+2] or '', 'dotted':parts[3*i+1]!='-->'})
    # Breadth-first layout; nodes in cycles stay visible, edges are never invented.
    rank={};incoming={e['to'] for e in edges}
    queue=[k for k in nodes if k not in incoming]
    for k in queue:rank[k]=0
    for k in queue:
        for e in edges:
            if e['from']==k and e['to'] not in rank:rank[e['to']]=rank[k]+1;queue.append(e['to'])
    for k in nodes:rank.setdefault(k,0)
    return {'nodes':[{'id':k,'label':v,'rank':rank[k]} for k,v in nodes.items()],'edges':edges,'unparsed':unparsed}
def diagrams(c,sid):
    a=records(c,'SELECT * FROM v_latest_process_diagrams WHERE site_id=? ORDER BY stage,period,diagram_id',(sid,))
    for r in a:
        r['graph']=graph(r['mermaid'])
        r['stream_links']=records(c,'SELECT water_id,element_ids,locator,detail,source_id FROM process_diagram_evidence WHERE diagram_id=? AND water_id IS NOT NULL',(r['diagram_id'],))
    return a
def stream_profile(c,sid,wid):
    r=c.execute('SELECT * FROM v_market_water_observations WHERE site_id=? AND water_id=?',(sid,wid)).fetchone()
    if not r:return None
    return {'water':dict(r),'metrics':records(c,'SELECT * FROM water_metrics WHERE site_id=? AND water_id=? ORDER BY period,point,metric_id',(sid,wid)),'costs':records(c,'SELECT * FROM water_economics WHERE site_id=? AND water_id=?',(sid,wid)),'signals':records(c,'SELECT * FROM v_workbench_water_signals WHERE site_id=? AND water_id=?',(sid,wid))}
def init_cases(w):
    w.execute("""CREATE TABLE IF NOT EXISTS engineering_cases(id INTEGER PRIMARY KEY,title TEXT NOT NULL,site_id TEXT,water_id TEXT,capability_id INTEGER NOT NULL,directions TEXT NOT NULL,feed TEXT NOT NULL,process TEXT NOT NULL,performance TEXT NOT NULL,limits_note TEXT NOT NULL,created TEXT DEFAULT CURRENT_TIMESTAMP)""")
    if 'profile' not in {r['name'] for r in w.execute('PRAGMA table_info(engineering_cases)')}:
        w.execute("ALTER TABLE engineering_cases ADD COLUMN profile TEXT NOT NULL DEFAULT '{}'")
def cases(w):
    a=records(w,'SELECT * FROM engineering_cases ORDER BY id DESC')
    for r in a:r['directions']=json.loads(r['directions']);r['profile']=json.loads(r['profile'])
    return a
def save_case(w,c,x):
    title=x['title'].strip();sid=x.get('site_id') or None;wid=x.get('water_id') or None;cap=int(x['capability_id']);dirs=list(dict.fromkeys(x['directions']))
    v=next((v for v in capabilities(w) if v['id']==cap),None)
    if not title or not v or not dirs or not set(dirs)<=set(v['directions']):raise ValueError('填写案例名称、技术版本及对应方向')
    if sid:site(c,sid)
    if wid:water(c,sid,wid)
    fields=[x.get(k,'').strip() for k in ('feed','process','performance','limits_note')]
    if not all(fields):raise ValueError('填写进水、工艺、实际表现及适用限制')
    cur=w.execute('INSERT INTO engineering_cases(title,site_id,water_id,capability_id,directions,feed,process,performance,limits_note) VALUES(?,?,?,?,?,?,?,?,?)',(title,sid,wid,cap,json.dumps(dirs))+tuple(fields));w.execute('UPDATE engineering_cases SET profile=? WHERE id=?',(json.dumps(x.get('profile',{}),ensure_ascii=False),cur.lastrowid));w.commit();return {'id':cur.lastrowid}
def similar_cases(w,c,case_id):
    r=next((r for r in cases(w) if r['id']==int(case_id)),None)
    if not r:raise ValueError('案例不存在')
    a=[x for x in match_market(w,c,r['capability_id']) if x['direction'] in r['directions'] and x['site_id']!=r['site_id']]
    from decision import case_similarity
    for x in a:x['case_similarity']=case_similarity(c,x['site_id'],x.get('water_id'),r['profile'])
    return sorted(a,key=lambda x:(x['fit']=='incompatible',x['case_similarity']['similarity'] is None,-x['case_similarity']['coverage'],-(x['case_similarity']['similarity'] or 0),x['site_id'],x.get('water_id') or ''))
