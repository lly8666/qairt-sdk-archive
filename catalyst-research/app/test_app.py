"""B0003 tests on rebuilt DB and real loopback HTTP; synthetic calculations only."""
import sys,sqlite3,threading,json,urllib.request
from pathlib import Path
from http.server import ThreadingHTTPServer
from app import connect,list_sites,detail,metrics,handler
from capability import evaluate,compare
from economics import calc,cashflow
db=sys.argv[1]
with connect(db) as c:
    def n(q):return c.execute(q).fetchone()[0]
    assert n('SELECT count(*) FROM v_market_app_catalog')==n('SELECT count(*) FROM sites')
    assert n('SELECT count(*) FROM v_market_production_observations')==n('SELECT count(*) FROM capacity')
    assert n('SELECT count(*) FROM v_market_project_observations')==n('SELECT count(*) FROM projects')
    assert n('SELECT sum(metric_count) FROM v_market_measurement_groups')==n('SELECT count(*) FROM water_metrics')
    assert n('SELECT count(*) FROM market_streams')>=26
    assert n('SELECT count(*) FROM market_treatment_systems')>=7
    assert n('SELECT count(*) FROM market_stream_system_links')>=24
    assert n("SELECT count(*) FROM market_streams WHERE water_id IN ('W060-17','W060-18','W060-19')")==0
    assert n("SELECT count(*) FROM market_stream_system_links WHERE stream_id='ST-W060-10'")==0
    assert n("SELECT count(*) FROM market_stream_system_links WHERE stream_id LIKE 'ST-W059-%' AND relation<>'designed_to_feed'")==0
    assert n("SELECT count(*) FROM market_ownership_observations WHERE observation_id IN ('OW0007','OW0008','OW0009','OW0010','OW0011','OW0012')")==6
    assert n("SELECT count(*) FROM market_procurement_observations WHERE procurement_id IN ('PR0009','PR0010','PR0011')")==3
    assert list_sites(c,limit=100)['total']==n('SELECT count(*) FROM sites')
    assert list_sites(c,seed=True)['total']==n('SELECT count(*) FROM commercial_opportunity_screen')
    assert any(x['site_id']=='CN0308' for x in list_sites(c,q='博苑',ownership='private_controlled')['items'])
    assert list_sites(c,q="' OR 1=1 --")['total']==0
    assert detail(c,'CN0127')['streams'] and detail(c,'CN0127')['connections']
    assert detail(c,'CN0000') is None
    assert metrics(c,'CN0127')['total']==n("SELECT count(*) FROM water_metrics WHERE site_id='CN0127'")
    assert not c.execute('PRAGMA foreign_key_check').fetchall()
with sqlite3.connect(db) as c:
    c.execute('PRAGMA foreign_keys=ON');c.execute('SAVEPOINT probe')
    try:
        for query in ["INSERT INTO market_stream_system_links VALUES('TEST','ST-W060-01','SY-W059-04','CN0127','W06S01','feeds','synthetic invalid')","UPDATE market_streams SET site_id='CN0075' WHERE stream_id='ST-W060-01'"]:
            try:c.execute(query)
            except sqlite3.IntegrityError:pass
            else:raise AssertionError('invalid cross-site accepted')
    finally:c.execute('ROLLBACK TO probe');c.execute('RELEASE probe')
s=ThreadingHTTPServer(('127.0.0.1',0),handler(db));t=threading.Thread(target=s.serve_forever,daemon=True);t.start()
try:
    url='http://127.0.0.1:'+str(s.server_port)
    assert '市场情报' in urllib.request.urlopen(url+'/').read().decode()
    assert json.load(urllib.request.urlopen(url+'/api/sites?limit=2'))['total']>=375
    assert json.load(urllib.request.urlopen(url+'/api/site?id=CN0127'))['streams']
    assert 'items' in json.load(urllib.request.urlopen(url+'/api/metrics?id=CN0127'))
    for req,code in [(url+'/api/sites?limit=999',400),(url+'/api/site?id=NOTFOUND',404),(urllib.request.Request(url+'/api/sites',data=b'{}'),405)]:
        try:urllib.request.urlopen(req)
        except urllib.error.HTTPError as e:assert e.code==code
        else:raise AssertionError('bad request accepted')
finally:s.shutdown();s.server_close();t.join()
v={'version_id':'SYN-1','constraints':[{'parameter':'TDS','unit':'g/L','scope':'feed','max':10}]}
w={'version_id':'SYN-2','constraints':[{'parameter':'TDS','unit':'g/L','scope':'feed','max':20}]}
o={'TDS':{'value':15,'unit':'g/L','scope':'feed','basis':'synthetic'}}
assert evaluate(None,o)['state']=='unknown'
assert evaluate(v,o)['state']=='incompatible'
assert compare(v,w,o)['new_candidate']
assert evaluate(w,{'TDS':dict(o['TDS'],unit='mg/L')})['state']=='unknown'
x={'volume_unit':'t/a','scope':'synthetic stream','period':'synthetic','cost_boundary':'same boundary','volume_basis':'synthetic','annual_volume':1000,'old_cost':30,'new_cost':10,'incremental_recovery':0,'capex':40000}
assert calc(x)['payback_years']==2
assert calc(dict(x,volume_basis='capacity'))['state']=='unknown'
assert calc(dict(x,new_cost=40))['payback_years'] is None
assert cashflow([-100,30,90])=={'net':20,'peak_funding':100}
print('B0003 12-task regression: PASS')
