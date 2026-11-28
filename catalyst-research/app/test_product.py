"""B0008 product regression on rebuilt public data and a disposable local workspace."""
import sys,tempfile,threading,json,urllib.request
from pathlib import Path
from http.server import ThreadingHTTPServer
from app import connect
from workspace import open_workspace,save_capability
from product import brief,diagrams,graph,stream_profile,save_case,similar_cases
from workbench import make_handler
db=sys.argv[1]
with connect(db) as c:
    assert c.execute("SELECT count(*) FROM v_market_ownership_review WHERE site_id='CN0247' AND link_role='legal_subject' AND ownership_class='central_state_controlled'").fetchone()[0]>=1
    assert c.execute("SELECT count(*) FROM v_workbench_contact_routes WHERE contact_id LIKE 'BC113-%' AND public_work_channel IS NOT NULL").fetchone()[0]==3
    assert len(brief(c,'CN0127')['directions'])>0
    d=diagrams(c,'CN0127');assert d and all(r['graph']['nodes'] for r in d)
    g=graph('flowchart TD\nA["进水"] -->|产水| B[回用]\nA -.-> C[待核]');assert len(g['edges'])==2 and g['edges'][1]['dotted']
    assert stream_profile(c,'CN0015','W0102')['water']['water_id']=='W0102'
    total=0;unparsed=0
    for (s,) in c.execute('SELECT mermaid FROM v_latest_process_diagrams'):
        g=graph(s);total+=1;unparsed+=bool(g['unparsed'])
    print('graphs',total,'with unparsed lines',unparsed)
    assert unparsed==0
    with tempfile.TemporaryDirectory() as tmp:
        path=Path(tmp)/'workspace.sqlite'
        with open_workspace(path) as w:
            v=save_capability(w,{'module':'SYN','directions':['high_salt'],'constraints':[]})
            r=save_case(w,c,{'title':'SYNTHETIC CASE','site_id':'CN0015','water_id':'W0102','capability_id':v['id'],'directions':['high_salt'],'feed':'synthetic','process':'synthetic','performance':'synthetic','limits_note':'synthetic'})
            a=similar_cases(w,c,r['id']);assert a and all(x['site_id']!='CN0015' for x in a)
        srv=ThreadingHTTPServer(('127.0.0.1',0),make_handler(db,path));t=threading.Thread(target=srv.serve_forever,daemon=True);t.start()
        try:
            url='http://127.0.0.1:'+str(srv.server_port)
            h=urllib.request.urlopen(url+'/',timeout=30).read().decode();assert '工程案例库' in h and "open('home')" in h
            assert json.load(urllib.request.urlopen(url+'/work/brief?id=CN0127',timeout=30))['directions']
            assert json.load(urllib.request.urlopen(url+'/work/diagrams?id=CN0127',timeout=30))[0]['graph']['nodes']
            assert json.load(urllib.request.urlopen(url+'/work/cases',timeout=30))[0]['title']=='SYNTHETIC CASE'
        finally:srv.shutdown();srv.server_close();t.join()
print('B0008 product regression PASS')
