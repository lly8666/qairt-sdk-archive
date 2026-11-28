"""Regression for 104 market identity layer; mutation probes are rolled back."""
import sqlite3,sys
with sqlite3.connect(sys.argv[1]) as db:
    db.execute('PRAGMA foreign_keys=ON')
    def scalar(q,p=()):
        return db.execute(q,p).fetchone()[0]
    assert scalar('SELECT count(*) FROM v_market_identity_slots')==scalar('SELECT count(*) FROM sites')
    assert scalar('SELECT count(DISTINCT site_id) FROM v_market_identity_slots')==scalar('SELECT count(*) FROM sites')
    assert scalar('SELECT count(*) FROM v_market_legacy_relations')==scalar('SELECT count(*) FROM site_relations')
    assert scalar('SELECT count(*) FROM v_market_seed_opportunities')==scalar('SELECT count(*) FROM commercial_opportunity_screen')
    assert scalar("SELECT count(DISTINCT entity_id) FROM market_identity_links WHERE site_id IN ('CN0085','CN0256') AND link_role='legal_subject'")==1
    assert scalar("SELECT count(DISTINCT entity_id) FROM market_identity_links WHERE site_id IN ('CN0085','CN0256') AND link_role='physical_site'")==2
    assert scalar("SELECT count(*) FROM market_entities WHERE entity_id='MF0004' AND lifecycle='design'")==1
    assert scalar("SELECT count(*) FROM market_entities WHERE entity_id='MP0001' AND entity_kind='project'")==1
    assert scalar("SELECT count(*) FROM market_entity_relations WHERE relation_id='MR0005' AND evidence_stage='design'")==1
    assert scalar("SELECT count(*) FROM market_entity_relations WHERE relation_id='MR0007' AND relation_kind='subsidiary_of'")==1
    assert scalar("SELECT count(*) FROM (SELECT entity_id FROM market_identity_links WHERE site_id IN ('CN0075','CN0194') AND link_state='evidence_linked' GROUP BY entity_id HAVING count(DISTINCT site_id)>1)")==0
    # Same-address unresolved candidates must not be automatically equated by import.
    assert scalar("SELECT count(*) FROM v_market_address_review WHERE legacy_site_ids LIKE '%CN0075%' AND legacy_site_ids LIKE '%CN0194%'")==1
    assert scalar("SELECT count(*) FROM market_entity_relations r JOIN site_relations l ON l.relation_id=r.legacy_relation_id WHERE r.source_id<>l.source_id OR r.anchor_site_id NOT IN(l.site_id,l.other_site_id)")==0
    assert scalar("SELECT count(*) FROM market_identity_links l JOIN market_entities e USING(entity_id) WHERE (l.link_role='physical_site' AND e.entity_kind<>'facility') OR (l.link_role='legal_subject' AND e.entity_kind<>'organization') OR (l.link_role='project_scope' AND e.entity_kind<>'project')")==0
    assert not db.execute('PRAGMA foreign_key_check').fetchall()
    db.execute('SAVEPOINT probe')
    try:
        # Provenance and type constraints reject a fabricated cross-site link.
        for stmt in [
            "INSERT INTO market_identity_links VALUES('TEST104','CN0085','MO0001','physical_site','candidate','test','S027-09','test','test')",
            "INSERT INTO market_identity_links VALUES('TEST104','CN0075','MO0001','legal_subject','candidate','test','S027-09','test','test')",
            "UPDATE market_identity_links SET link_role='physical_site' WHERE link_id='ML0001'",
            "UPDATE market_entities SET entity_kind='facility' WHERE entity_id='MO0001'",
            "INSERT INTO market_ownership_observations VALUES('TEST104','MF0001','unknown','unknown',NULL,'test','candidate','CN0085','S027-09','test','test')"
        ]:
            try: db.execute(stmt)
            except sqlite3.IntegrityError: pass
            else: raise AssertionError('invalid statement accepted: '+stmt)
    finally:
        db.execute('ROLLBACK TO probe');db.execute('RELEASE probe')
print('market identity regression passed')
