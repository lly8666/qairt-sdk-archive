"""B0005 practical data and workflow regression."""
import json,sys,tempfile,threading,urllib.request
from pathlib import Path
from http.server import ThreadingHTTPServer
from app import connect
from workbench import browse,overview,full_detail,make_handler
from workspace import open_workspace,save_capability,capabilities,add_followup,match_market,compare_versions,save_stream_observation,task_list,complete_followup
from economics import calc
db=sys.argv[1]
with connect(db) as c:
    def n(q):return c.execute(q).fetchone()[0]
    o=overview(c)
    assert o['subjects']==n('SELECT count(*) FROM sites')==375
    assert o['water_records']==n('SELECT count(*) FROM wastewater')==1387
    assert o['signal_streams']==n('SELECT count(DISTINCT water_id) FROM v_workbench_water_signals')
    assert o['signal_hits']==n('SELECT count(*) FROM v_workbench_water_signals')
    assert o['signals']==n('SELECT count(*) FROM v_workbench_candidates')
    assert n("SELECT count(*) FROM market_ownership_observations WHERE observation_id IN ('OW0018','OW0019','OW0020')")==3
    assert n("SELECT count(*) FROM sources WHERE url LIKE '%2026-11/20/nw.D110000zgzqb_20261120_1-B015.htm'")==1
    assert n("SELECT count(*) FROM market_identity_links WHERE link_id='ML0061'")==0
    assert n("SELECT count(*) FROM capacity WHERE site_id='CN0184' AND source_id='S108-02'")==4
    assert c.execute("SELECT sum(value) FROM capacity WHERE site_id='CN0184' AND source_id='S108-02'").fetchone()[0]==500
    assert c.execute("SELECT address FROM market_entities WHERE entity_id='MF0011'").fetchone()[0]=='南京化学工业园区赵桥河南路139号'
    assert n("SELECT count(*) FROM v_market_ownership_review WHERE site_id='CN0184' AND ownership_class='foreign_controlled' AND evidence_state='evidence_linked'")>0
    assert n("SELECT count(*) FROM v_market_ownership_review WHERE site_id='CN0308' AND ownership_class='private_controlled' AND effective_period='2026-06-30报告期末'")>0
    assert n("SELECT count(*) FROM v_market_ownership_review WHERE site_id='CN0026' AND effective_period='2026-11-20股份过户完成'")>0
    assert n("SELECT count(*) FROM market_procurement_observations WHERE procurement_id='PR0012' AND procurement_stage='solicitation_historical'")==1
    assert n("SELECT count(*) FROM v_workbench_contact_routes WHERE site_id='CN0127' AND channel_type='supplier_portal' AND public_work_channel IS NOT NULL")==1
    assert n("SELECT count(*) FROM v_workbench_water_signals WHERE direction='external_disposal' AND water_id='W0001'")==0
    assert n("SELECT count(*) FROM market_screen_terms WHERE term IN ('ED','UF','RO')")==0
    assert n("SELECT count(*) FROM v_workbench_equipment WHERE technology_family='pressure_membrane'")>0
    assert n("SELECT count(*) FROM v_workbench_economics WHERE economics_group<>'other_reference'")>0
    assert browse(c,owner='private_controlled')['total']>0
    assert browse(c,direction='evaporation')['total']>0
    assert full_detail(c,'CN0184')['equipment']==[]
    assert any(x['review_id']=='R027-04' and x['presence']=='not_identified' for x in full_detail(c,'CN0184')['membrane_reviews'])
    assert browse(c,q='贺利氏')['total']>0
    assert n("SELECT count(*) FROM capacity WHERE site_id='CN0184' AND source_id='S109-01'")==12
    assert c.execute("SELECT sum(value) FROM capacity WHERE site_id='CN0184' AND source_id='S109-01'").fetchone()[0]==3852.5
    assert n("SELECT count(*) FROM market_treatment_systems WHERE site_id='CN0184' AND source_id='S109-01'")==4
    assert n("SELECT count(*) FROM market_stream_system_links WHERE site_id='CN0184' AND source_id='S109-01'")==4
    assert n("SELECT count(*) FROM process_diagrams WHERE diagram_id='D027-04'")==1
    assert n("SELECT count(*) FROM membrane_retrofits WHERE assessment_id='A027-04'")==1
    assert n("SELECT count(*) FROM market_ownership_observations WHERE observation_id='OW0021' AND controlling_entity_id='MO0036'")==1
    with tempfile.TemporaryDirectory() as tmp:
        path=Path(tmp)/'workspace.sqlite'
        with open_workspace(path) as w:
            v1=save_capability(w,{'module':'SYNTHETIC','directions':['high_salt'],'constraints':[{'parameter':'TDS','unit':'g/L','scope':'feed','min':0,'max':100,'hard':True}]})
            v2=save_capability(w,{'module':'SYNTHETIC','directions':['high_salt','ammonia'],'constraints':[{'parameter':'TDS','unit':'g/L','scope':'feed','min':0,'max':120,'hard':True}]})
            assert v2['version']==2 and len(capabilities(w))==2
            save_stream_observation(w,c,{'site_id':'CN0015','water_id':'W0102','parameter':'TDS','value':50,'unit':'g/L','scope':'feed','basis':'actual_verified','observed_on':'2026-11-27','notes':'synthetic test only'})
            m=match_market(w,c,v1['id'])
            r=next(x for x in m if x['site_id']=='CN0015' and x.get('water_id')=='W0102')
            assert r['fit']=='conditional'
            save_stream_observation(w,c,{'site_id':'CN0015','water_id':'W0102','parameter':'TDS','value':150,'unit':'g/L','scope':'feed','basis':'actual_verified','observed_on':'2026-11-28','notes':'synthetic test only'})
            m=match_market(w,c,v1['id']);r=next(x for x in m if x['site_id']=='CN0015' and x.get('water_id')=='W0102')
            assert r['fit']=='incompatible'
            cmp=compare_versions(w,c,v1['id'],v2['id']);assert cmp['added'] or cmp['changed']
            add_followup(w,c,{'site_id':'CN0015','stage':'待确认','owner':'SYNTHETIC','next_action':'synthetic due task','next_date':'2000-01-01'})
            assert len(task_list(w)['overdue'])==1
            assert complete_followup(w,1) and len(task_list(w)['overdue'])==0
        econ=calc({'annual_volume':1000,'volume_unit':'m3/a','scope':'same stream','period':'2026','volume_basis':'synthetic','cost_boundary':'same','old_cost':10,'new_cost':8,'incremental_recovery':0,'capex':10000})
        assert econ['annual_saving']==2000 and econ['payback_years']==5
        srv=ThreadingHTTPServer(('127.0.0.1',0),make_handler(db,path));t=threading.Thread(target=srv.serve_forever,daemon=True);t.start()
        try:
            url='http://127.0.0.1:'+str(srv.server_port)
            assert '技术商务工作台' in urllib.request.urlopen(url+'/').read().decode()
            assert json.load(urllib.request.urlopen(url+'/work/overview'))['subjects']==375
            assert json.load(urllib.request.urlopen(url+'/work/tasks'))['overdue']==[]
            assert json.load(urllib.request.urlopen(url+'/work/matches?version='+str(v1['id'])))
            req=urllib.request.Request(url+'/work/observations',data=json.dumps({'site_id':'CN0015','water_id':'W0102','parameter':'pH','value':7,'unit':'','scope':'feed','basis':'synthetic'}).encode(),headers={'Content-Type':'application/json'})
            # Blank units are intentionally rejected by the UI/service.
            try:urllib.request.urlopen(req);raise AssertionError('blank unit accepted')
            except urllib.error.HTTPError as e:assert e.code==400
            req=urllib.request.Request(url+'/work/economics',data=json.dumps({'annual_volume':1000,'volume_unit':'m3/a','scope':'same','period':'2026','volume_basis':'synthetic','cost_boundary':'same','old_cost':10,'new_cost':8,'incremental_recovery':0,'capex':10000}).encode(),headers={'Content-Type':'application/json'})
            assert json.load(urllib.request.urlopen(req))['payback_years']==5
        finally:srv.shutdown();srv.server_close();t.join()
    print('B0005 overview:',json.dumps(o,ensure_ascii=False))
print('B0005 practical workbench regression passed')
