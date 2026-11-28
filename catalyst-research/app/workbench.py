"""Practical public market + optional local single-user workspace."""
import argparse,json
from http.server import ThreadingHTTPServer
from urllib.parse import urlsplit,parse_qs
from pathlib import Path
from app import connect,rows,detail,metrics,handler
from workspace import open_workspace,records,save_capability,capabilities,add_followup,match_market,compare_versions,STAGES
from capability import evaluate
from economics import calc,cashflow
ROOT=Path(__file__).resolve().parent
def browse(c,q='',province='',direction='',owner='',queue='',limit=40,offset=0,prefer_private=True,prefer_channels=True):
    where=[];args=[]
    if q:
        where.append("(instr(lower(s.name||' '||coalesce(s.category,'')||' '||coalesce(s.city,'')),lower(?))>0 OR EXISTS(SELECT 1 FROM market_identity_links l JOIN market_entities e USING(entity_id) WHERE l.site_id=s.site_id AND instr(lower(e.name),lower(?))>0))");args.extend([q,q])
    if province:where.append('s.province=?');args.append(province)
    if direction:where.append('EXISTS(SELECT 1 FROM v_workbench_candidates x WHERE x.site_id=s.site_id AND x.direction=?)');args.append(direction)
    if queue:where.append('s.research_queue=?');args.append(queue)
    if owner=='unknown':where.append('s.legal_ownership_count=0')
    elif owner:
        where.append("EXISTS(SELECT 1 FROM v_market_ownership_review o WHERE o.site_id=s.site_id AND o.link_role='legal_subject' AND o.evidence_state='evidence_linked' AND o.ownership_class=?)");args.append(owner)
    clause=' WHERE '+' AND '.join(where) if where else ''
    total=c.execute('SELECT count(*) FROM v_workbench_priority s'+clause,args).fetchone()[0]
    order="CASE research_queue WHEN 'seed_review' THEN 0 WHEN 'signal_and_channel' THEN 1 WHEN 'signal_review' THEN 2 WHEN 'scope_review' THEN 3 ELSE 4 END"
    if prefer_private:order+=", CASE WHEN EXISTS(SELECT 1 FROM v_market_ownership_review o WHERE o.site_id=s.site_id AND o.link_role='legal_subject' AND o.ownership_class='private_controlled' AND o.evidence_state='evidence_linked') THEN 0 ELSE 1 END"
    if prefer_channels:order+=', contact_count DESC'
    items=rows(c,'SELECT * FROM v_workbench_priority s'+clause+' ORDER BY '+order+',site_id LIMIT ? OFFSET ?',args+[min(max(limit,1),100),max(offset,0)])
    for r in items:
        r['directions']=rows(c,'SELECT direction,water_records,priority_band FROM v_workbench_candidates WHERE site_id=? ORDER BY priority_band IS NULL,direction',(r['site_id'],))
        r['ownership']=rows(c,"SELECT DISTINCT ownership_class,effective_period,link_role FROM v_market_ownership_review WHERE site_id=? AND evidence_state='evidence_linked' ORDER BY link_role,effective_period",(r['site_id'],))
    return {'total':total,'items':items}
def overview(c):
    return {'subjects':c.execute('SELECT count(*) FROM sites').fetchone()[0],
      'water_sites':c.execute('SELECT count(DISTINCT site_id) FROM wastewater').fetchone()[0],
      'signal_sites':c.execute('SELECT count(DISTINCT site_id) FROM v_workbench_candidates').fetchone()[0],
      'signals':c.execute('SELECT count(*) FROM v_workbench_candidates').fetchone()[0],
      'ownership_sites':c.execute('SELECT count(*) FROM v_workbench_priority WHERE legal_ownership_count>0').fetchone()[0],
      'directions':rows(c,'SELECT direction,count(*) AS n FROM v_workbench_candidates GROUP BY direction ORDER BY n DESC,direction'),
      'provinces':rows(c,"SELECT DISTINCT province FROM sites WHERE coalesce(province,'')<>'' ORDER BY province"),
      'queues':rows(c,'SELECT research_queue,count(*) AS n FROM v_workbench_priority GROUP BY research_queue')}
def full_detail(c,sid):
    d=detail(c,sid)
    if d is None:return None
    for key,query in {
      'directions':'SELECT * FROM v_workbench_candidates WHERE site_id=? ORDER BY priority_band IS NULL,direction',
      'signals':'SELECT * FROM v_workbench_water_signals WHERE site_id=? ORDER BY direction,water_id',
      'equipment':'SELECT * FROM v_workbench_equipment WHERE site_id=?',
      'costs':'SELECT * FROM water_economics WHERE site_id=?',
      'legacy_relations':'SELECT * FROM v_workbench_relations WHERE site_id=? OR other_site_id=?',
      'channels':'SELECT * FROM v_workbench_contact_routes WHERE site_id=?'
    }.items():d[key]=rows(c,query,(sid,sid) if key=='legacy_relations' else (sid,))
    return d
def make_handler(database,workspace=None):
    Base=handler(database)
    class Handler(Base):
        def allowed(self):
            return self.headers.get('Host','').split(':')[0] in ('localhost','127.0.0.1')
        def answer(self,data,status=200):
            return self.send(status,json.dumps(data,ensure_ascii=False).encode())
        def do_GET(self):
            if not self.allowed():return self.answer({'error':'local only'},403)
            u=urlsplit(self.path);a=parse_qs(u.query);get=lambda k,d='':a.get(k,[d])[0]
            if u.path=='/':return self.send(200,(ROOT/'workbench.html').read_bytes(),'text/html; charset=utf-8')
            if not u.path.startswith('/work/'):return super().do_GET()
            try:
                with connect(database) as c:
                    if u.path=='/work/overview':return self.answer(dict(overview(c),workspace=bool(workspace)))
                    if u.path=='/work/sites':return self.answer(browse(c,get('q'),get('province'),get('direction'),get('owner'),get('queue'),int(get('limit','40')),int(get('offset','0')),get('private','1')=='1',get('channels','1')=='1'))
                    if u.path=='/work/detail':
                        d=full_detail(c,get('id'))
                        if d is None:return self.answer({'error':'not found'},404)
                        if workspace:
                            with open_workspace(workspace) as w:d['followups']=records(w,'SELECT * FROM followups WHERE site_id=? ORDER BY id DESC',(get('id'),))
                        return self.answer(d)
                    if not workspace:return self.answer({'error':'workspace not configured'},403)
                    with open_workspace(workspace) as w:
                        if u.path=='/work/capabilities':return self.answer(capabilities(w))
                        if u.path=='/work/matches':return self.answer(match_market(w,c,get('version') or None))
                        if u.path=='/work/compare':return self.answer(compare_versions(w,c,get('old'),get('new')))
                        if u.path=='/work/followups':return self.answer(records(w,'SELECT * FROM followups ORDER BY id DESC'))
                return self.answer({'error':'not found'},404)
            except (ValueError,KeyError) as e:return self.answer({'error':str(e)},400)
        def do_POST(self):
            if not self.allowed() or not workspace:return self.answer({'error':'local workspace required'},403)
            # Browser form writes are limited to same-origin JSON requests.
            if self.headers.get('Content-Type','').split(';')[0]!='application/json':return self.answer({'error':'JSON required'},400)
            origin=self.headers.get('Origin')
            if origin and origin!='http://'+self.headers.get('Host',''):return self.answer({'error':'origin'},403)
            try:
                x=json.loads(self.rfile.read(int(self.headers.get('Content-Length','0'))))
                with open_workspace(workspace) as w,connect(database) as c:
                    if self.path=='/work/capabilities':return self.answer(save_capability(w,x),201)
                    if self.path=='/work/followups':return self.answer(add_followup(w,c,x),201)
                    if self.path=='/work/evaluate':
                        v=next((r for r in capabilities(w) if r['id']==int(x['id'])),None)
                        return self.answer(evaluate(dict(version_id=str(v['id']),constraints=v['constraints']) if v else None,x.get('observations',{})))
                    if self.path=='/work/economics':return self.answer(dict(calc(x),cashflow=cashflow(x.get('cash_events'))))
                return self.answer({'error':'not found'},404)
            except (ValueError,KeyError,TypeError) as e:return self.answer({'error':str(e)},400)
    return Handler
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('database');p.add_argument('--workspace');p.add_argument('--port',type=int,default=8765);a=p.parse_args()
    if a.workspace:
        if Path(a.workspace).resolve()==Path(a.database).resolve():raise SystemExit('workspace must be separate')
        with open_workspace(a.workspace):pass
    print('http://127.0.0.1:'+str(a.port)+' — local single-user trial')
    ThreadingHTTPServer(('127.0.0.1',a.port),make_handler(a.database,a.workspace)).serve_forever()
