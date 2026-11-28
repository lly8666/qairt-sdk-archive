"""Read-only reproducible dictionary + identity exception export (Python stdlib)."""
import argparse, csv, json, sqlite3
from pathlib import Path
def quote(name):
    return '"' + name.replace('"', '""') + '"'
def rows(db, query):
    return [dict(r) for r in db.execute(query)]
def audit(path, out):
    out=Path(out)
    out.mkdir(parents=True, exist_ok=True)
    with sqlite3.connect(Path(path).resolve().as_uri()+'?mode=ro',uri=True) as db:
        db.row_factory=sqlite3.Row
        assert db.execute('PRAGMA integrity_check').fetchone()[0]=='ok'
        assert not db.execute('PRAGMA foreign_key_check').fetchall()
        dictionary=[]
        for obj in rows(db,"SELECT name,type,sql FROM sqlite_master WHERE type IN ('table','view') AND name NOT LIKE 'sqlite_%' ORDER BY type,name"):
            n=quote(obj['name'])
            obj['row_count']=db.execute('SELECT count(*) FROM '+n).fetchone()[0]
            obj['columns']=rows(db,'PRAGMA table_info('+n+')')
            obj['foreign_keys']=rows(db,'PRAGMA foreign_key_list('+n+')')
            obj['indexes']=rows(db,'PRAGMA index_list('+n+')')
            for ix in obj['indexes']:
                ix['columns']=rows(db,'PRAGMA index_info('+quote(ix['name'])+')')
            dictionary.append(obj)
        queries={
         'record_types':"SELECT record_type,count(*) AS n FROM sites GROUP BY 1 ORDER BY 1",
         'review_scopes':"SELECT review_scope,count(*) AS n FROM v_market_identity_slots GROUP BY 1 ORDER BY 1",
         'mapping_states':"SELECT mapping_state,count(*) AS n FROM v_market_identity_slots GROUP BY 1 ORDER BY 1",
         'entity_kinds':"SELECT entity_kind,lifecycle,count(*) AS n FROM market_entities GROUP BY 1,2 ORDER BY 1,2",
         'identity_gaps':"SELECT gap,count(*) AS n FROM v_market_identity_review_queue GROUP BY 1 ORDER BY 1",
         'address_collisions':"SELECT * FROM v_market_address_review ORDER BY province,city,address",
         'permit_collisions':"SELECT trim(permit_id) AS permit_id,count(*) AS n FROM sites WHERE trim(coalesce(permit_id,''))<>'' GROUP BY 1 HAVING count(*)>1",
         'metric_cross_site':"SELECT m.metric_id,m.site_id,w.site_id AS water_site_id FROM water_metrics m JOIN wastewater w USING(water_id) WHERE m.site_id<>w.site_id",
         'seed_cross_site':"SELECT o.site_id,o.anchor_water_id FROM commercial_opportunity_screen o JOIN wastewater w ON w.water_id=o.anchor_water_id WHERE o.site_id<>w.site_id",
         'source_url_duplicates':"SELECT url,count(*) AS n FROM sources WHERE trim(coalesce(url,''))<>'' GROUP BY url HAVING count(*)>1",
         'flow_units_and_basis':"SELECT flow_unit,flow_basis,count(*) AS n FROM wastewater WHERE flow IS NOT NULL GROUP BY 1,2 ORDER BY 1,2",
         'metric_result_types':"SELECT result_kind,count(*) AS n FROM water_metrics GROUP BY 1 ORDER BY 1",
         'diagram_stages':"SELECT stage,coverage,count(*) AS n FROM process_diagrams GROUP BY 1,2 ORDER BY 1,2",
         'missing_permit':"SELECT count(*) AS n FROM sites WHERE trim(coalesce(permit_id,''))=''",
         'shared_station_signals':"SELECT count(*) AS n,count(DISTINCT site_id) AS sites FROM wastewater WHERE stream LIKE '%共享%' OR process LIKE '%共享%' OR destination LIKE '%共享%' OR notes LIKE '%共享%'"
        }
        report={k:rows(db,q) for k,q in queries.items()}
        report['warning']='Review signals, not confirmed factories or duplicate identities. Shared-station keyword hits are not resolved topology.'
        for name,data in [('data_dictionary.json',dictionary),('market_audit.json',report)]:
            (out/name).write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
        for filename,query in [('identity_slots.csv','SELECT * FROM v_market_identity_slots ORDER BY site_id'),('identity_review_queue.csv','SELECT * FROM v_market_identity_review_queue ORDER BY site_id,gap'),('legacy_relations.csv','SELECT * FROM v_market_legacy_relations ORDER BY relation_id'),('seed_opportunities.csv','SELECT * FROM v_market_seed_opportunities ORDER BY seed_id')]:
            cur=db.execute(query)
            with (out/filename).open('w',encoding='utf-8-sig',newline='') as f:
                writer=csv.writer(f);writer.writerow([x[0] for x in cur.description]);writer.writerows(cur)
        print(json.dumps({k:report[k] for k in ('record_types','mapping_states','entity_kinds','identity_gaps','shared_station_signals')},ensure_ascii=False))
if __name__=='__main__':
    p=argparse.ArgumentParser()
    p.add_argument('database');p.add_argument('output')
    a=p.parse_args();audit(a.database,a.output)
