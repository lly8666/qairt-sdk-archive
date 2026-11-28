"""B0007: private project lifecycle and public ownership/volume review."""
import sys,tempfile,threading,json,urllib.request
from pathlib import Path
from http.server import ThreadingHTTPServer
from app import connect
from workspace import open_workspace,save_capability,save_stream_observation
from projects import set_relationship,create_project,advance,save_sample,save_trial,save_scenarios,list_projects,project_detail,upgrade_list
from practical import sales_list,sales_csv
from workbench import make_handler
db=sys.argv[1]
with connect(db) as c:
    assert c.execute("SELECT count(*) FROM v_market_ownership_review WHERE site_id='CN0207' AND link_role='legal_subject' AND ownership_class='private_controlled'").fetchone()[0]==1
    assert c.execute("SELECT count(*) FROM v_market_ownership_review WHERE site_id='CN0063' AND link_role='legal_subject' AND ownership_class='central_state_controlled'").fetchone()[0]==1
    assert c.execute('SELECT count(*) FROM v_workbench_actual_review').fetchone()[0]==14
    with tempfile.TemporaryDirectory() as tmp:
        path=Path(tmp)/'workspace.sqlite'
        with open_workspace(path) as w:
            site='CN0015';wid='W0102';cid=site+':high_salt'
            set_relationship(w,c,{'site_id':site,'relationship':'已服务客户','notes':'SYNTHETIC PRIVATE'})
            assert next(r for r in sales_list(c,w) if r['site_id']==site)['relationship']=='已服务客户'
            assert 'SYNTHETIC PRIVATE' not in sales_csv(sales_list(c,w))
            p=create_project(w,c,{'site_id':site,'candidate_id':cid,'water_id':wid,'title':'SYNTHETIC PROJECT','stage':'取样','next_action':'sample'})
            pid=p['id'];advance(w,{'project_id':pid,'stage':'小试','next_action':'test'})
            v1=save_capability(w,{'module':'SYN','directions':['high_salt'],'constraints':[{'parameter':'TDS','unit':'g/L','scope':'feed','max':10}]})
            v2=save_capability(w,{'module':'SYN','directions':['high_salt','ammonia'],'constraints':[{'parameter':'TDS','unit':'g/L','scope':'feed','max':100}]})
            save_stream_observation(w,c,{'site_id':site,'water_id':wid,'parameter':'TDS','unit':'g/L','scope':'feed','basis':'synthetic','value':50})
            assert any(r['water_id']==wid and r['change']=='new_conditional' for r in upgrade_list(w,c,v1['id'],v2['id']))
            s=save_sample(w,c,{'project_id':pid,'water_id':wid,'sample_label':'SYN-1','state':'计划'})
            save_sample(w,c,{'id':s['id'],'project_id':pid,'water_id':wid,'sample_label':'SYN-1','state':'已检测'})
            t=save_trial(w,{'project_id':pid,'sample_id':s['id'],'capability_id':v2['id'],'objective':'synthetic','state':'计划'})
            save_trial(w,{'id':t['id'],'project_id':pid,'sample_id':s['id'],'objective':'synthetic','state':'完成','result':'synthetic'})
            common={'scope':'synthetic','period':'2026','cost_boundary':'same','volume_unit':'m3/a','volume_basis':'synthetic'}
            cases={k:{'annual_volume':1000,'old_cost':10,'new_cost':v,'incremental_recovery':0,'capex':10000,'cash_events':[-1000,1500]} for k,v in [('保守',9),('基准',8),('乐观',7)]}
            save_scenarios(w,{'project_id':pid,'common':common,'cases':cases})
            d=project_detail(w,c,pid)
            assert len(d['events'])==2 and d['samples'][0]['state']=='已检测' and d['trials'][0]['state']=='完成'
            assert d['scenarios'][0]['results'][1]['payback_years']==5
        srv=ThreadingHTTPServer(('127.0.0.1',0),make_handler(db,path));t=threading.Thread(target=srv.serve_forever,daemon=True);t.start()
        try:
            url='http://127.0.0.1:'+str(srv.server_port)
            assert '客户项目' in urllib.request.urlopen(url+'/',timeout=30).read().decode()
            assert len(json.load(urllib.request.urlopen(url+'/work/projects',timeout=30)))==1
            assert json.load(urllib.request.urlopen(url+'/work/project?id='+str(pid),timeout=30))['trials'][0]['state']=='完成'
            assert len(json.load(urllib.request.urlopen(url+'/work/actual-review',timeout=30)))==14
        finally:srv.shutdown();srv.server_close();t.join()
print('B0007 project lifecycle regression PASS')
