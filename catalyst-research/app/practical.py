"""Public market navigation and private local work; no automatic demand or engineering approval."""
import csv,io
from collections import Counter
from workspace import records
from economics import calc,cashflow

TEMPLATES={
 'high_salt':[('TDS','g/L'),('COD','mg/L'),('硬度','mg/L'),('硅','mg/L'),('pH','无量纲'),('温度','°C'),('流量','m3/d')],
 'ammonia':[('氨氮','mg/L'),('TDS','g/L'),('pH','无量纲'),('温度','°C'),('COD','mg/L'),('流量','m3/d')],
 'metal_recovery':[('目标金属','mg/L'),('TDS','g/L'),('pH','无量纲'),('SS','mg/L'),('COD','mg/L'),('流量','m3/d')],
 'organic':[('COD','mg/L'),('TOC','mg/L'),('SS','mg/L'),('TDS','g/L'),('pH','无量纲'),('流量','m3/d')],
 'evaporation':[('TDS','g/L'),('COD','mg/L'),('硬度','mg/L'),('硅','mg/L'),('温度','°C'),('流量','m3/d')],
 'reuse':[('TDS','g/L'),('COD','mg/L'),('SS','mg/L'),('硬度','mg/L'),('流量','m3/d')],
 'external_disposal':[('TDS','g/L'),('COD','mg/L'),('pH','无量纲'),('流量','m3/d')],
 'membrane_optimization':[('TDS','g/L'),('COD','mg/L'),('SS','mg/L'),('流量','m3/d'),('压力','bar'),('回收率','%')]
}
def templates(direction):
    return [{'parameter':p,'unit':u,'scope':'feed' if p not in ('压力','回收率') else 'process'} for p,u in TEMPLATES.get(direction,[('流量','m3/d'),('TDS','g/L'),('COD','mg/L'),('pH','无量纲')])]

def latest_actions(w):
    if w is None:return []
    return records(w,"SELECT * FROM followups f WHERE id=(SELECT max(id) FROM followups g WHERE g.site_id=f.site_id AND coalesce(g.candidate_id,'')=coalesce(f.candidate_id,'')) ORDER BY id DESC")

def sales_list(c,w=None,owner='',direction='',stage='',route='',province=''):
    by_site={};by_direction={}
    for f in latest_actions(w):by_site.setdefault(f['site_id'],[]).append(f)
    for d in records(c,'SELECT site_id,direction,direct_water_records,contextual_water_records,priority_band FROM v_workbench_candidates ORDER BY priority_band IS NULL,direction'):
        by_direction.setdefault(d['site_id'],[]).append(d)
    items=records(c,'SELECT site_id,name,province,city,subject_scope,legal_ownership,group_ownership,usable_channels,site_channels,procurement_count,seed_count,direction_count,cost_count FROM v_workbench_sales_scope WHERE direction_count>0 ORDER BY seed_count DESC,usable_channels DESC,site_id')
    out=[]
    for r in items:
        if province and r['province']!=province:continue
        legal=r['legal_ownership'] or '';group=r['group_ownership'] or ''
        types=(legal+','+group).split(',')
        if owner=='unknown' and (legal or group):continue
        if owner and owner!='unknown' and owner not in types:continue
        if route=='available' and not r['usable_channels']:continue
        if route=='procurement' and not r['procurement_count']:continue
        if route=='missing' and r['usable_channels']:continue
        ds=by_direction.get(r['site_id'],[])
        if direction and not any(x['direction']==direction for x in ds):continue
        fs=by_site.get(r['site_id'],[])
        if direction:fs=[f for f in fs if f['candidate_id'] in (None,r['site_id']+':'+direction)]
        if stage=='untracked' and fs:continue
        if stage and stage!='untracked' and not any(f['stage']==stage for f in fs):continue
        basis='法人证据' if legal else '集团证据（非直接法人）' if group else '待核'
        if len(set(x for x in types if x))>1:hint='存在不同控制权观察，先核时期和范围'
        elif 'private_controlled' in legal.split(','):hint='建议先核环保/生产部门直接沟通路径'
        elif 'central_state_controlled' in types or 'local_state_controlled' in types:hint='建议核正式采购入口、EPC合作及准入'
        elif 'foreign_controlled' in legal.split(','):hint='建议核本地厂区技术、采购及集团审批边界'
        else:hint='先核法人、需求及采购路径'
        out.append(dict(r,ownership_basis=basis,route_hint=hint,directions=ds,actions=fs))
    return out

def sales_csv(items):
    fields=['site_id','name','province','city','subject_scope','legal_ownership','group_ownership','ownership_basis','usable_channels','site_channels','procurement_count','directions','route_hint']
    s=io.StringIO();writer=csv.DictWriter(s,fieldnames=fields,extrasaction='ignore');writer.writeheader()
    for item in items:
        r=dict(item,directions=';'.join(x['direction'] for x in item['directions']))
        writer.writerow({k:("'"+v if isinstance(v,str) and v.startswith(('=','+','-','@')) else v) for k,v in r.items()})
    return s.getvalue()

def gaps(c,w,site,direction):
    sig=records(c,'SELECT * FROM v_workbench_signal_evidence WHERE site_id=? AND direction=? ORDER BY signal_strength,water_id',(site,direction))
    for r in sig:
        obs=records(w,'SELECT parameter,unit,scope,basis FROM stream_observations WHERE site_id=? AND water_id=? ORDER BY observed_on DESC,id DESC',(site,r['water_id'])) if w is not None else []
        latest={}
        for o in obs:latest.setdefault((o['parameter'],o['scope']),o)
        have={(o['parameter'],o['unit'],o['scope']) for o in latest.values() if o['basis'] in ('actual_verified','customer_disclosed')}
        r['missing_parameters']=[p for p in templates(direction) if (p['parameter'],p['unit'],p['scope']) not in have]
        r['next_checks']=['核实际分股流量与采样点','核产水目标及浓水合法去向','核现有设备、运行费和改造接口']
    return sig

def management(w):
    latest=latest_actions(w);active=[x for x in latest if x['stage'] not in ('已成交','关闭','暂缓')]
    return {'stage_counts':dict(Counter(x['stage'] for x in latest)),
            'active_by_owner':dict(Counter(x['owner'] or '未分配' for x in active)),
            'active_directions':len(active),'tracked_sites':len({x['site_id'] for x in latest}),
            'open_tasks':w.execute('SELECT count(*) FROM followups WHERE completed=0').fetchone()[0],
            'boundary':'仅内部跟进记录；任务数非工时，市场候选非销售项目'}

def scenarios(x):
    common=x['common'];cases=x['cases']
    fields=('annual_volume','old_cost','new_cost','incremental_recovery','capex')
    return [{'label':name,**calc(dict(common,**{k:cases[name].get(k) for k in fields})),'cashflow':cashflow(cases[name].get('cash_events'))} for name in ('保守','基准','乐观')]
