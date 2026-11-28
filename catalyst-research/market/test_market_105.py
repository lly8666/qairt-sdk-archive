"""105: idempotency, conflict rejection, ownership and quantity semantics."""
import sqlite3,sys
from import_market_assertions import import_rows
with sqlite3.connect(sys.argv[1]) as db:
    db.row_factory=sqlite3.Row
    db.execute('PRAGMA foreign_keys=ON')
    def n(q):return db.execute(q).fetchone()[0]
    assert n('SELECT count(*) FROM v_market_water_observations')==n('SELECT count(*) FROM wastewater')
    assert n('SELECT count(*) FROM v_market_water_quality_observations')==n('SELECT count(*) FROM water_metrics')
    assert n("SELECT count(*) FROM commercial_opportunity_screen o JOIN v_market_water_observations w ON w.water_id=o.anchor_water_id WHERE w.scope_class<>'unknown'") == n('SELECT count(*) FROM commercial_opportunity_screen')
    assert n("SELECT count(*) FROM v_market_water_observations WHERE eligible_annual_volume IS NOT NULL")==0
    assert n("SELECT count(*) FROM v_market_water_observations WHERE water_id='W013-001' AND quantity_status='capacity_not_flow'")==1
    assert n("SELECT count(*) FROM v_market_water_observations WHERE water_id='W027-H12024' AND quantity_status='reported_quantity_not_eligible_volume'")==1
    assert n("SELECT count(*) FROM v_market_procurement_evidence WHERE opening_status<>'not_open_verified'")==0
    assert n("SELECT count(*) FROM market_ownership_observations WHERE ownership_class='private_controlled'")>=3
    assert n("SELECT count(*) FROM market_ownership_observations WHERE ownership_class='local_state_controlled'")>=2
    assert n("SELECT count(*) FROM market_ownership_observations WHERE ownership_class='central_state_controlled'")>=1
    row=dict(db.execute("SELECT * FROM market_entities WHERE entity_id='MO0001'").fetchone())
    assert import_rows(db,{'market_entities':[row]})['market_entities']==[0,1]
    db.execute('SAVEPOINT test')
    try:
        clone=dict(row,entity_id='TEST105',name='Synthetic test organization')
        assert import_rows(db,{'market_entities':[clone]})['market_entities']==[1,0]
        assert import_rows(db,{'market_entities':[clone]})['market_entities']==[0,1]
        try: import_rows(db,{'market_entities':[dict(clone,name='conflict')]})
        except ValueError:pass
        else:raise AssertionError('conflict overwritten')
        assert n("SELECT count(*) FROM market_entities WHERE entity_id='TEST105' AND name='Synthetic test organization'")==1
        r=dict(db.execute("SELECT * FROM market_entity_relations WHERE relation_id='MR0007'").fetchone())
        try: import_rows(db,{'market_entity_relations':[dict(r,relation_id='TEST_BAD_REL',from_entity_id='MO0001')]})
        except sqlite3.IntegrityError:pass
        else:raise AssertionError('cross-pair accepted')
        w=dict(db.execute("SELECT * FROM market_water_scope_reviews LIMIT 1").fetchone())
        try: import_rows(db,{'market_water_scope_reviews':[dict(w,review_id='TEST_BAD_W',site_id='CN0075',review_date='test')]})
        except sqlite3.IntegrityError:pass
        else:raise AssertionError('cross-site water accepted')
    finally:
        db.execute('ROLLBACK TO test');db.execute('RELEASE test')
    assert not db.execute('PRAGMA foreign_key_check').fetchall()
print('105 market import, evidence and scope regression: OK')
