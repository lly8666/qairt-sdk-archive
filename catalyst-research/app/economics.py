"""Bounded scenario calculation, not a quote; only explicit comparable inputs."""
import math
def calc(x):
    if x.get('volume_unit') not in ('t/a','m3/a') or not x.get('scope') or not x.get('period') or not x.get('cost_boundary') or x.get('volume_basis') not in ('actual_verified','customer_disclosed','explicit_assumption','synthetic'):
        return {'state':'unknown','annual_saving':None,'payback_years':None}
    fields=('annual_volume','old_cost','new_cost','incremental_recovery','capex')
    vals=[x.get(k) for k in fields]
    if any(v is None for v in vals):return {'state':'unknown','annual_saving':None,'payback_years':None}
    if any(not isinstance(v,(int,float)) or isinstance(v,bool) or not math.isfinite(v) for v in vals):raise ValueError('invalid numbers')
    volume,old,new,recovery,capex=vals
    if min(volume,old,new,capex)<0:raise ValueError('negative nonnegative input')
    saving=volume*(old-new)+recovery
    if not math.isfinite(saving):raise ValueError('overflow')
    return {'state':'scenario','annual_saving':saving,'payback_years':capex/saving if saving>0 else None,'volume_basis':x['volume_basis'],'boundary':x['cost_boundary']}
def cashflow(events):
    """Explicit signed net payments by chronological sequence; no inferred cashflow."""
    if events is None:return {'net':None,'peak_funding':None}
    net=0;peak=0
    for value in events:
        if not isinstance(value,(int,float)) or isinstance(value,bool) or not math.isfinite(value):raise ValueError('invalid event')
        net+=value;peak=max(peak,-net)
    return {'net':net,'peak_funding':peak}
