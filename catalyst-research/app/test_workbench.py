"""Practical acceptance: all market data, actual local HTTP and anonymous local persistence."""
import json,sqlite3,sys,tempfile,threading,urllib.request
from pathlib import Path
from http.server import ThreadingHTTPServer
from app import connect
from workbench import browse,overview,full_detail,make_handler
from workspace import open_workspace,save_capability,capabilities,add_followup,match_market,compare_versions
db=sys.argv[1]
with connect(db) as c:
    def n(q):return c.execute(q).fetchone()[0]
    assert overview(c)['subjects']==n('SELECT count(*) FROM sites')
    assert n('SELECT count(*) FROM v_workbench_subjects')==n('SELECT count(*) FROM sites')
    assert n('SELECT count(*) FROM v_workbench_relations')==n('SELECT count(*) FROM site_relations')
    assert n('SELECT count(*) FROM v_workbench_candidates')>30
    assert n('SELECT count(DISTINCT site_id) FROM v_workbench_candidates')>30
    assert n("SELECT count(*) FROM v_workbench_contact_routes WHERE public_work_channel IS NOT NULL AND department LIKE '%投资者%'")==0
    assert n('SELECT count(*) FROM market_ownership_observations WHERE observation_id IN (\'OW0013\',\'OW0014\',\'OW0015\',\'OW0016\',\'OW0017\')')==5
    assert browse(c,owner='private_controlled')['total']>0
    assert browse(c,direction='evaporation')['total']>0
    assert full_detail(c,'CN0127')['equipment']
    with tempfile.TemporaryDirectory() as tmp:
        path=Path(tmp)/'workspace.sqlite'
        with open_workspace(path) as w:
            a=save_capability(w,{'module':'SYNTHETIC','directions':['evaporation'],'constraints':[]})
            b=save_capability(w,{'module':'SYNTHETIC','directions':['evaporation','ammonia'],'constraints':[]})
            assert b['version']==2 and len(capabilities(w))==2
            assert match_market(w,c,b['id'])
            assert compare_versions(w,c,a['id'],b['id'])['added']
            # Synthetic follow-up in disposable private workspace, not a customer relationship assertion.
            add_followup(w,c,{'site_id':'CN0127','stage':'待确认','owner':'SYNTHETIC','next_action':'SYNTHETIC TEST','notes':'test only'})
        srv=ThreadingHTTPServer(('127.0.0.1',0),make_handler(db,path));t=threading.Thread(target=srv.serve_forever,daemon=True);t.start()
        try:
            url='http://127.0.0.1:'+str(srv.server_port)
            assert '技术商务工作台' in urllib.request.urlopen(url+'/').read().decode()
            assert json.load(urllib.request.urlopen(url+'/work/overview'))['subjects']>=375
            assert json.load(urllib.request.urlopen(url+'/work/sites?direction=evaporation'))['total']>0
            assert json.load(urllib.request.urlopen(url+'/work/detail?id=CN0127'))['followups']
            assert len(json.load(urllib.request.urlopen(url+'/work/capabilities')))==2
            req=urllib.request.Request(url+'/work/followups',data=json.dumps({'site_id':'CN0127','stage':'技术初筛','owner':'SYNTHETIC','next_action':'test'}).encode(),headers={'Content-Type':'application/json'})
            assert urllib.request.urlopen(req).status==201
            assert len(json.load(urllib.request.urlopen(url+'/work/followups')))==2
        finally:srv.shutdown();srv.server_close();t.join()
    print('workbench overview:',json.dumps(overview(c),ensure_ascii=False))
print('B0004 practical workbench regression passed')
