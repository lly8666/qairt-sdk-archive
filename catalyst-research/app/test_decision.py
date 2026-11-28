"""B0009: public feed reference and numerical case differentiation."""
import sys,tempfile,json,threading,urllib.request
from http.server import ThreadingHTTPServer
from workbench import make_handler
from projects import set_relationship
from pathlib import Path
from app import connect
from workspace import open_workspace,save_capability,match_market
from decision import feed_groups,reference_checks,rules_normalized,case_similarity,action_cards,report,cost_compare
from product import save_case,similar_cases,diagrams
with connect(sys.argv[1]) as c:
    cards=action_cards(c)
    assert len(cards)==178 and sum(bool(x['priority']) for x in cards)==30
    assert '开发理由' in report(c,'CN0026')
    assert any(d['stream_links'] for d in diagrams(c,'CN0127'))
    # Public design feed evidence exists; outlet, limit, and concentrate are not promoted to feed.
    groups=feed_groups(c,'CN0082','W013-001')
    assert not any(m['parameter']=='TDS' for g in groups for m in g['metrics'])
    sid,wid=c.execute("SELECT site_id,water_id FROM wastewater WHERE water_id='W023-004'").fetchone()
    groups=feed_groups(c,sid,wid)
    assert any(m['parameter']=='全盐量' and m['normalized_value']==5303 for g in groups for m in g['metrics'])
    lo=case_similarity(c,sid,wid,{'parameters':[{'parameter':'全盐量','value':5.303,'unit':'g/L'}]})
    hi=case_similarity(c,sid,wid,{'parameters':[{'parameter':'全盐量','value':200,'unit':'g/L'}]})
    assert lo['similarity']>hi['similarity']
    assert reference_checks(groups,rules_normalized([{'parameter':'全盐量','unit':'g/L','max':10}]))[0]['state']=='reference_candidate'
    assert cost_compare({'cost':{'unit_cost':2,'unit':'m3/a','boundary':'same','period':'2026'}},10,1000,'m3/a','same','2026')['annual_saving']==8000
    assert cost_compare({'cost':{'unit_cost':2,'unit':'m3/a','boundary':'same','period':'2026'}},10,1000,'m3/a','different','2026')['state']=='unknown'
    with tempfile.TemporaryDirectory() as tmp:
        path=Path(tmp)/'private.sqlite'
        with open_workspace(path) as w:
            set_relationship(w,c,{'site_id':'CN0015','relationship':'已服务客户','notes':'SYNTHETIC'})
            v=save_capability(w,{'module':'SYN','directions':['high_salt','ammonia'],'constraints':[{'parameter':'COD','unit':'mg/L','max':100000}]})
            a=match_market(w,c,v['id'])
            assert any(x.get('reference_fit','unknown')!='unknown' for x in a)
            assert all(x['fit']=='unknown' for x in a)
            print('public references:',sum(x.get('reference_fit','unknown')!='unknown' for x in a),'of',len(a))
        srv=ThreadingHTTPServer(('127.0.0.1',0),make_handler(sys.argv[1],path));t=threading.Thread(target=srv.serve_forever,daemon=True);t.start()
        try:
            a=json.load(urllib.request.urlopen('http://127.0.0.1:'+str(srv.server_port)+'/work/cards?id=CN0015',timeout=30))
            assert a[0]['relationship']=='已服务客户'
        finally:srv.shutdown();srv.server_close();t.join()
print('B0009 decision regression PASS')
