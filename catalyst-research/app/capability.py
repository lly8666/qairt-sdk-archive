"""Simple version-aware screening against explicitly recorded stream observations."""
import math
def finite(x):return isinstance(x,(int,float)) and not isinstance(x,bool) and math.isfinite(x)
def evaluate(version,observations):
    if not version or not version.get('version_id') or not version.get('constraints'):
        return {'state':'unknown','reason':'technology_not_configured','checks':[]}
    checks=[]
    for rule in version['constraints']:
        key=rule['parameter'];lo=rule.get('min');hi=rule.get('max');scope=rule.get('scope','feed')
        if lo is None and hi is None:raise ValueError('empty constraint')
        if any(v is not None and not finite(v) for v in (lo,hi)) or (lo is not None and hi is not None and lo>hi):raise ValueError('invalid constraint')
        obs=observations.get(key+'|'+str(scope)) or observations.get(key)
        state='unknown';reason='missing_or_not_comparable'
        if obs and obs.get('unit')==rule['unit'] and obs.get('scope')==scope and obs.get('basis') in ('actual_verified','customer_disclosed','synthetic') and finite(obs.get('value')):
            v=obs['value'];state='fail' if (lo is not None and v<lo) or (hi is not None and v>hi) else 'pass';reason='range_check'
        checks.append({'parameter':key,'scope':scope,'state':state,'reason':reason,'hard':bool(rule.get('hard',True))})
    if any(x['hard'] and x['state']=='fail' for x in checks):state='incompatible'
    elif any(x['hard'] and x['state']=='unknown' for x in checks):state='unknown'
    else:state='conditional'
    return {'version_id':version['version_id'],'state':state,'checks':checks,'reason':'screening_only_not_engineering_approval'}
def compare(old,new,observations):
    a=evaluate(old,observations);b=evaluate(new,observations)
    return {'before':a,'after':b,'new_candidate':a['state'] in ('incompatible','unknown') and b['state']=='conditional'}
