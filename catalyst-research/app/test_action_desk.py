"""B0006: public action desk, private follow-up, sampling and scenarios."""
import sys,tempfile,threading,urllib.request,json,sqlite3
from pathlib import Path
from http.server import ThreadingHTTPServer
from app import connect
from workspace import open_workspace,add_followup,save_stream_observation
from practical import sales_list,sales_csv,gaps,templates,management,scenarios
from workbench import browse,make_handler
from backup_workspace import backup
db=sys.argv[1]
with connect(db) as c:
    assert c.execute("SELECT count(*) FROM v_market_ownership_review WHERE site_id='CN0202' AND link_role='legal_subject' AND ownership_class='central_state_controlled'").fetchone()[0]>=1
    assert c.execute("SELECT count(*) FROM v_workbench_sales_scope").fetchone()[0]==375
    assert c.execute("SELECT count(*) FROM v_workbench_signal_evidence").fetchone()[0]==c.execute("SELECT count(*) FROM v_workbench_water_signals").fetchone()[0]
    a=sales_list(c,owner='central_state_controlled')
    assert {'CN0002','CN0003','CN0202'} <= {r['site_id'] for r in a}
    assert all(r['usable_channels']>0 for r in sales_list(c,route='available'))
    assert browse(c,q='贺利氏')['total']>0
    assert 'site_id,name' in sales_csv(a)
    with tempfile.TemporaryDirectory() as tmp:
        path=Path(tmp)/'private.sqlite'
        with open_workspace(path) as w:
            assert management(w)['tracked_sites']==0
            g=gaps(c,w,'CN0015','high_salt')
            r=next(x for x in g if x['water_id']=='W0102')
            assert any(p['parameter']=='TDS' for p in r['missing_parameters'])
            save_stream_observation(w,c,{'site_id':'CN0015','water_id':'W0102','parameter':'TDS','value':50,'unit':'g/L','scope':'feed','basis':'customer_disclosed','notes':'synthetic fixture'})
            r=next(x for x in gaps(c,w,'CN0015','high_salt') if x['water_id']=='W0102')
            assert not any(p['parameter']=='TDS' for p in r['missing_parameters'])
            add_followup(w,c,{'site_id':'CN0015','candidate_id':'CN0015:high_salt','stage':'技术初筛','owner':'SYNTHETIC','next_action':'SYNTHETIC PRIVATE NOTE'})
            assert any(x['site_id']=='CN0015' for x in sales_list(c,w,stage='技术初筛'))
            assert 'SYNTHETIC PRIVATE NOTE' not in sales_csv(sales_list(c,w))
            assert management(w)['active_by_owner']=={'SYNTHETIC':1}
        copy=backup(path,Path(tmp)/'backup.sqlite')
        with sqlite3.connect(copy) as z:assert z.execute('SELECT count(*) FROM followups').fetchone()[0]==1
        common={'scope':'synthetic','period':'2026','cost_boundary':'same','volume_unit':'m3/a','volume_basis':'synthetic'}
        cases={k:{'annual_volume':1000,'old_cost':10,'new_cost':v,'incremental_recovery':0,'capex':10000,'cash_events':[-1000,1500]} for k,v in [('保守',9),('基准',8),('乐观',7)]}
        s=scenarios({'common':common,'cases':cases})
        assert [x['annual_saving'] for x in s]==[1000,2000,3000]
        assert s[1]['payback_years']==5 and s[1]['cashflow']['peak_funding']==1000
        srv=ThreadingHTTPServer(('127.0.0.1',0),make_handler(db,path));t=threading.Thread(target=srv.serve_forever,daemon=True);t.start()
        try:
            url='http://127.0.0.1:'+str(srv.server_port)
            assert '客户开发行动台' in urllib.request.urlopen(url+'/',timeout=30).read().decode()
            assert json.load(urllib.request.urlopen(url+'/work/management',timeout=30))['tracked_sites']==1
            assert 'SYNTHETIC PRIVATE NOTE' not in urllib.request.urlopen(url+'/work/export?stage=unknown',timeout=30).read().decode('utf-8-sig')
            req=urllib.request.Request(url+'/work/scenarios',data=json.dumps({'common':common,'cases':cases}).encode(),headers={'Content-Type':'application/json'})
            assert json.load(urllib.request.urlopen(req,timeout=30))[1]['payback_years']==5
        finally:srv.shutdown();srv.server_close();t.join()
print('B0006 action desk regression PASS')
