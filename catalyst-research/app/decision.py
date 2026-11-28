"""Use public feed reference data for screening; keep private measurements and solution costs separate."""
import re,math,json
from collections import defaultdict
from workspace import records
from capability import evaluate
ALIASES={'tds':'TDS','溶解性总固体':'TDS','总溶解性固体':'TDS','溶解性固体':'TDS','全盐量':'全盐量','含盐量':'全盐量','盐分':'全盐量','cod':'COD','codcr':'COD','化学需氧量':'COD','氨氮':'氨氮','nh3-n':'氨氮','nh₃-n':'氨氮','ph':'pH','ss':'SS','悬浮物':'SS','toc':'TOC','总有机碳':'TOC'}
def param(x):
    t=x.strip();return ALIASES.get(t.lower(),t)
def norm(p,v,u):
    p=param(p);u=u.strip().replace('μ','µ').replace('／','/').replace('³','3')
    if u in ('mg/L','g/L','µg/L'):
        return p,v*{'mg/L':1,'g/L':1000,'µg/L':.001}[u],'mg/L'
    return p,v,u
def feed_groups(c,sid,wid):
    # Explicit feed/raw or exact stream label. No outlet, limit, removal rate or unrelated source.
    w=c.execute('SELECT * FROM wastewater WHERE site_id=? AND water_id=?',(sid,wid)).fetchone()
    if not w:return []
    w=dict(w);groups=defaultdict(list)
    for r in records(c,'SELECT * FROM water_metrics WHERE site_id=? AND water_id=? AND value_num IS NOT NULL',(sid,wid)):
        point=r['point'] or '';kind=r['result_kind'] or '';stat=r['statistic'] or '';notes=r['notes'] or '';txt=r['value_text'] or ''
        if any(t in point for t in ('出水','排口','产水','浓水','冷凝','回用','处理后','接管','地下水','生活','总排','全厂')):continue
        if not ('进水' in point or '原水' in point or point==w['stream'] or (point=='产生' and r['source_id']==w['source_id'])):continue
        if any(t in kind+' '+stat for t in ('限值','上限','标准','目标','负荷','效率','去除率','削减','检出限','协议')):continue
        if any(t in txt for t in ('<','＜','未检出','ND','≤')) or (r['detection_limit'] and r['value_num']<=r['detection_limit']):continue
        p,v,u=norm(r['metric'],r['value_num'],r['unit'] or '')
        if not math.isfinite(v) or u not in ('mg/L','无量纲','°C','m3/d','m3/h','bar'):continue
        if any(t in kind for t in ('设计','预测','类比','源强','衡算','计算','估算')):basis='public_design_reference'
        elif any(t in kind for t in ('实测','监测','检测','验收')) and '非实测' not in notes:basis='public_historical_reference'
        else:continue
        r.update(parameter=p,normalized_value=v,normalized_unit=u,basis=basis)
        groups[(r['source_id'],point,r['period'],basis)].append(r)
    return [{'source_id':k[0],'point':k[1],'period':k[2],'basis':k[3],'metrics':v} for k,v in groups.items()]
def normalized_private(obs):
    out={}
    for key,o in obs.items():
        p=key.split('|')[0];p,v,u=norm(p,o['value'],o['unit']);k=p+'|'+o['scope']
        out.setdefault(k,dict(o,value=v,unit=u))
    return out
def rules_normalized(rules):
    out=[]
    for r in rules:
        p,_,u=norm(r['parameter'],0,r['unit'])
        z=dict(r,parameter=p,unit=u)
        for k in ('min','max'):
            if r.get(k) is not None:z[k]=norm(r['parameter'],r[k],r['unit'])[1]
        out.append(z)
    return out
def reference_checks(groups,rules):
    result=[]
    for g in groups:
        checks=[]
        for r in rules:
            values=[m['normalized_value'] for m in g['metrics'] if m['parameter']==r['parameter'] and m['normalized_unit']==r['unit']] if r.get('scope','feed')=='feed' else []
            state='unknown'
            if values:
                lo=r.get('min');hi=r.get('max')
                state='pass' if all((lo is None or v>=lo) and (hi is None or v<=hi) for v in values) else 'fail'
            checks.append({'parameter':r['parameter'],'unit':r['unit'],'state':state,'values':values,'hard':r.get('hard',True)})
        if not checks or not any(x['values'] for x in checks):continue
        state='reference_outside' if any(x['state']=='fail' and x['hard'] for x in checks) else 'reference_partial' if any(x['state']=='unknown' and x['hard'] for x in checks) else 'reference_candidate'
        result.append(dict(source_id=g['source_id'],point=g['point'],period=g['period'],basis=g['basis'],state=state,checks=checks))
    return result
def assess(c,sid,wid,version,obs):
    rules=rules_normalized(version['constraints']);private=evaluate(dict(version_id=str(version['id']),constraints=rules),normalized_private(obs))
    groups=feed_groups(c,sid,wid)
    refs=reference_checks(groups,rules)
    states={x['state'] for x in refs}
    # Public historical/design data never promotes private engineering fit.
    ref='reference_conflict' if 'reference_candidate' in states and 'reference_outside' in states else 'reference_candidate' if 'reference_candidate' in states else 'reference_outside' if 'reference_outside' in states else 'reference_partial' if states else 'unknown'
    return dict(private,reference_fit=ref,reference_checks=refs,feed_groups=groups)
def case_similarity(c,sid,wid,profile,groups=None):
    # Compare like-named numerical feed parameters only, never infer TDS from total salt.
    targets={}
    for r in profile.get('parameters',[]):
        p,v,u=norm(r['parameter'],r['value'],r['unit']);targets[(p,u)]=v
    best=None
    for g in (groups if groups is not None else feed_groups(c,sid,wid)):
        diffs=[]
        for (p,u),v in targets.items():
            vals=[m['normalized_value'] for m in g['metrics'] if m['parameter']==p and m['normalized_unit']==u]
            if vals:
                # Relative similarity, transparent 0..1, no imputation.
                mean=sum(vals)/len(vals);score=1-abs(mean-v)/max(abs(mean),abs(v),1e-9)
                diffs.append({'parameter':p,'unit':u,'case_value':v,'reference_value':mean,'similarity':round(score,3)})
        if not diffs:continue
        score=sum(x['similarity'] for x in diffs)/len(diffs)
        r={'similarity':round(score,3),'coverage':len(diffs),'target_count':len(targets),'comparisons':diffs,'point':g['point'],'period':g['period'],'source_id':g['source_id'],'basis':g['basis']}
        if best is None or (r['coverage'],r['similarity'])>(best['coverage'],best['similarity']):best=r
    return best or {'similarity':None,'coverage':0,'target_count':len(targets),'comparisons':[]}
def cost_compare(profile,old,volume,unit,boundary,period):
    base=profile.get('cost') or {}
    if not all([boundary,period,unit]) or base.get('boundary')!=boundary or base.get('unit')!=unit or base.get('period')!=period:return {'state':'unknown','reason':'不同处理边界、单位或期间'}
    new=base.get('unit_cost')
    if not all(isinstance(x,(int,float)) and math.isfinite(x) and x>=0 for x in (new,old,volume)):return {'state':'unknown','reason':'缺少可比费用或年量'}
    return {'state':'scenario','annual_saving':(old-new)*volume,'unit_saving':old-new,'boundary':boundary,'period':period,'unit':unit,'reason':'按输入假设比较完整方案；不是报价'}
def action_cards(c,site_id=None):
    from product import brief
    ids=[site_id] if site_id else [r[0] for r in c.execute("SELECT site_id FROM v_workbench_sales_scope WHERE direction_count>0 ORDER BY seed_count DESC,usable_channels DESC,site_id")]
    out=[]
    for sid in ids:
        s=c.execute('SELECT * FROM v_workbench_sales_scope WHERE site_id=?',(sid,)).fetchone()
        if not s:continue
        s=dict(s);b=brief(c,sid);seed=records(c,'SELECT * FROM commercial_opportunity_screen WHERE site_id=?',(sid,))
        channels=records(c,'SELECT * FROM v_workbench_contact_routes WHERE site_id=? AND public_work_channel IS NOT NULL',(sid,))
        projects=records(c,'SELECT project,status,date,water_change,source_id FROM projects WHERE site_id=? ORDER BY date DESC LIMIT 4',(sid,))
        cost=records(c,'SELECT item,value,unit,basis,period,source_id FROM water_economics WHERE site_id=? ORDER BY period DESC LIMIT 4',(sid,))
        first=b['directions'][0] if b['directions'] else {}
        out.append({'site_id':sid,'name':s['name'],'province':s['province'],'city':s['city'],'subject_scope':s['subject_scope'],'ownership':s['legal_ownership'],'group_ownership':s['group_ownership'],'priority':seed[0]['priority_band'] if seed else None,'why':seed[0]['evidence_signal'] if seed else first.get('why','暂无明确线索'),'entry':first.get('technical_entry','先核需求'),'next_action':seed[0]['outreach_hypothesis'] if seed else '核实际生产状态、分股水量、水质、设施及采购计划','gap':seed[0]['qualification_gap'] if seed else '核分股实际参数、处理成本及浓水去向','source_id':seed[0]['source_id'] if seed else (first.get('examples') or [{}])[0].get('source_id'),'channels':channels,'events':projects,'costs':cost,'directions':b['directions'],'department_hint':'建议核环保/生产技术/工程采购；未确认具体负责人'})
    return out
def report(c,sid):
    a=action_cards(c,sid)
    if not a:return ''
    r=a[0];lines=['# '+r['name']+' — 技术商务初筛','地区：'+str(r['province'])+' '+str(r['city']),'法人/集团所有制：'+str(r['ownership'] or '待核')+' / '+str(r['group_ownership'] or '待核'),'开发理由：'+r['why'],'证据：'+str(r['source_id'] or '见流股'),'建议：'+r['entry'],'下一步：'+r['next_action'],'缺口：'+r['gap'],'## 方向及证据']
    for d in r['directions']:
        lines.append('- '+d['direction']+'：'+d['technical_entry'])
        for s in d['examples']:lines.append('  - '+str(s['water_id'])+' '+str(s['stream'])+' '+str(s['flow'])+' '+str(s['flow_unit'])+' '+str(s['flow_basis'])+' / '+str(s['source_id']))
    lines+=['## 公开渠道']+[str(x['organization'])+' '+str(x['public_work_channel'])+' / '+str(x['source_id']) for x in r['channels']]
    lines+=['## 项目时机（历史记录，当前状态待核）']+[str(x['date'])+' '+str(x['project'])+' '+str(x['status'])+' / '+str(x['source_id']) for x in r['events']]
    lines+=['## 费用参考（非当前可比成本）']+[str(x['item'])+' '+str(x['value'])+' '+str(x['unit'])+' '+str(x['period'])+' / '+str(x['source_id']) for x in r['costs']]
    lines+=['公开资料初筛，不代表采购需求、工程适配或报价。']
    return '\n\n'.join(lines)
