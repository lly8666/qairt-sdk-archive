"""Local-only, read-only public market browser; no auth or private-data support yet."""
import argparse, json, sqlite3
from pathlib import Path
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import urlsplit,parse_qs
ROOT=Path(__file__).resolve().parent
def connect(path):
    c=sqlite3.connect(Path(path).resolve().as_uri()+'?mode=ro',uri=True)
    c.row_factory=sqlite3.Row
    c.execute('PRAGMA query_only=ON')
    return c
def rows(c,q,p=()):
    return [dict(x) for x in c.execute(q,p)]
def list_sites(c,q='',province='',ownership='',seed=False,limit=30,offset=0):
    if not 1<=limit<=100 or offset<0: raise ValueError('invalid page')
    if ownership not in ('','unknown','private_controlled','central_state_controlled','local_state_controlled','foreign_controlled','mixed_control_unclear','other'):raise ValueError('invalid ownership')
    filters=[];p=[]
    if q:
        filters.append("(instr(lower(name),lower(?))>0 OR instr(lower(coalesce(category,'')),lower(?))>0 OR instr(lower(coalesce(city,'')),lower(?))>0 OR EXISTS(SELECT 1 FROM market_identity_links l JOIN market_entities e USING(entity_id) WHERE l.site_id=a.site_id AND instr(lower(e.name),lower(?))>0))")
        p.extend([q]*4)
    if province:filters.append('province=?');p.append(province)
    if seed:filters.append('seed_count>0')
    if ownership=='unknown':filters.append('legal_ownership_count=0')
    elif ownership:
        filters.append("EXISTS(SELECT 1 FROM v_market_ownership_review o WHERE o.site_id=a.site_id AND o.link_role='legal_subject' AND o.evidence_state='evidence_linked' AND o.ownership_class=?)");p.append(ownership)
    where=' WHERE '+' AND '.join(filters) if filters else ''
    total=c.execute('SELECT count(*) FROM v_market_app_catalog a'+where,p).fetchone()[0]
    items=rows(c,'SELECT * FROM v_market_app_catalog a'+where+' ORDER BY seed_count DESC,name,site_id LIMIT ? OFFSET ?',p+[limit,offset])
    for x in items:
        x['ownership_evidence']=rows(c,"SELECT DISTINCT ownership_class,effective_period,link_role FROM v_market_ownership_review WHERE site_id=? AND observation_id IS NOT NULL AND evidence_state='evidence_linked' ORDER BY link_role,effective_period",(x['site_id'],))
    return {'total':total,'items':items,'limit':limit,'offset':offset,'boundary':'legacy research anchors; ownership filter matches dated direct legal-subject evidence, not verified current control'}
def detail(c,sid):
    site=rows(c,'SELECT * FROM v_market_app_catalog WHERE site_id=?',(sid,))
    if not site:return None
    d={'site':site[0]}
    queries={
      'entities':"SELECT l.link_role,l.link_state,l.evidence_period AS link_period,l.source_id AS link_source,l.boundary AS link_boundary,e.* FROM market_identity_links l JOIN market_entities e USING(entity_id) WHERE l.site_id=? ORDER BY l.link_id",
      'ownership':'SELECT * FROM v_market_ownership_review WHERE site_id=?',
      'relations':"SELECT DISTINCT r.* FROM market_entity_relations r JOIN market_identity_links l ON l.entity_id IN(r.from_entity_id,r.to_entity_id) WHERE l.site_id=?",
      'procurement':'SELECT * FROM v_market_procurement_evidence WHERE site_id=?',
      'production':'SELECT * FROM v_market_production_observations WHERE site_id=?',
      'projects':'SELECT * FROM v_market_project_observations WHERE site_id=?',
      'water':'SELECT * FROM v_market_water_observations WHERE site_id=? ORDER BY water_id',
      'streams':'SELECT * FROM market_streams WHERE site_id=? ORDER BY stream_id',
      'systems':'SELECT * FROM market_treatment_systems WHERE site_id=? ORDER BY system_id',
      'connections':'SELECT * FROM market_stream_system_links WHERE site_id=? ORDER BY link_id',
      'measurement_groups':'SELECT * FROM v_market_measurement_groups WHERE site_id=?',
      'diagrams':'SELECT * FROM v_latest_process_diagrams WHERE site_id=?',
      'membrane_reviews':'SELECT * FROM v_latest_membrane_reviews WHERE site_id=?',
      'retrofits':'SELECT * FROM v_membrane_retrofit_rating WHERE site_id=?',
      'seeds':'SELECT * FROM v_market_seed_opportunities WHERE site_id=?',
      'sources':'SELECT x.* FROM site_sources ss JOIN sources x USING(source_id) WHERE ss.site_id=? ORDER BY x.source_id',
      'contact_routes':'SELECT organization,contact_scope,department,channel_type,verification_status,use_boundary,source_id FROM business_contacts WHERE site_id=?'
    }
    for key,query in queries.items():d[key]=rows(c,query,(sid,))
    return d
def metrics(c,sid,limit=100,offset=0):
    if not 1<=limit<=100 or offset<0:raise ValueError('invalid page')
    total=c.execute('SELECT count(*) FROM water_metrics WHERE site_id=?',(sid,)).fetchone()[0]
    return {'total':total,'items':rows(c,'SELECT * FROM v_market_water_quality_observations WHERE site_id=? ORDER BY metric_id LIMIT ? OFFSET ?',(sid,limit,offset))}
def handler(database):
    class Handler(BaseHTTPRequestHandler):
        def send(self,status,body,kind='application/json; charset=utf-8'):
            self.send_response(status);self.send_header('Content-Type',kind);self.send_header('Cache-Control','no-store');self.send_header('X-Content-Type-Options','nosniff');self.send_header('Content-Security-Policy',"default-src 'none'; style-src 'unsafe-inline'; script-src 'unsafe-inline'; connect-src 'self'; base-uri 'none'; frame-ancestors 'none'");self.end_headers();self.wfile.write(body)
        def do_GET(self):
            # Prevent DNS-rebinding access to local read-only research browser.
            host=self.headers.get('Host','').split(':')[0]
            if host not in ('127.0.0.1','localhost'):return self.send(403,b'{}')
            u=urlsplit(self.path);a=parse_qs(u.query)
            def get(k,d=''):return a.get(k,[d])[0]
            try:
                if u.path=='/':return self.send(200,(ROOT/'index.html').read_bytes(),'text/html; charset=utf-8')
                with connect(database) as c:
                    if u.path=='/api/sites':result=list_sites(c,get('q')[:200],get('province'),get('ownership'),get('seed')=='1',int(get('limit','30')),int(get('offset','0')))
                    elif u.path=='/api/site':result=detail(c,get('id'))
                    elif u.path=='/api/metrics':result=metrics(c,get('id'),int(get('limit','100')),int(get('offset','0')))
                    else:result=None
                return self.send(200 if result is not None else 404,json.dumps(result,ensure_ascii=False).encode())
            except (ValueError,OverflowError):return self.send(400,b'{"error":"invalid parameter"}')
        def do_POST(self):return self.send(405,b'{"error":"read only"}')
    return Handler
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('database');p.add_argument('--port',type=int,default=8765);a=p.parse_args()
    with connect(a.database) as c:c.execute('SELECT count(*) FROM v_market_app_catalog').fetchone()
    print('Local public-data preview: http://127.0.0.1:'+str(a.port))
    ThreadingHTTPServer(('127.0.0.1',a.port),handler(a.database)).serve_forever()
