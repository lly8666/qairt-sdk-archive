"""Check revisit mechanics on a disposable connection; no synthetic live records."""
import sqlite3, sys
c=sqlite3.connect(sys.argv[1])
c.execute('PRAGMA foreign_keys=ON')
c.execute('BEGIN')
try:
    assert c.execute('SELECT count(*) FROM v_research_dispatch').fetchone()[0]==c.execute('SELECT count(*) FROM sites').fetchone()[0]
    # Historical fixtures can legitimately be consumed by later migrations.
    for event_id, consumed in c.execute("SELECT event_id,consumed_by_attempt FROM research_reopen_events WHERE event_id LIKE 'E071-%'"):
        assert c.execute('SELECT count(*) FROM v_research_pending_events WHERE event_id=?',(event_id,)).fetchone()[0] == (0 if consumed else 1)
    # Simulate a genuine event on an existing track; rollback at end.
    a=c.execute("SELECT site_id,scope_key,gap,route_key,checked_on FROM research_revisit_attempts WHERE attempt_id='A070-001'").fetchone()
    sid,scope,gap,route,day=a
    source=c.execute("SELECT source_id FROM site_sources WHERE site_id=? LIMIT 1",(sid,)).fetchone()[0]
    # A new independent event without any earlier attempt must be visible.
    c.execute("INSERT INTO research_reopen_events VALUES(?,?,?,?,?,?,?,?,?,NULL)",('TEST_UNATTEMPTED',sid,'test_new_scope','test_new_gap','test_new_route','test',source,day,'synthetic independent event, rolled back'))
    assert c.execute("SELECT count(*) FROM v_research_pending_events WHERE event_id='TEST_UNATTEMPTED' AND prior_attempt_id IS NULL").fetchone()[0]==1
    c.execute("INSERT INTO research_reopen_events VALUES(?,?,?,?,?,?,?,?,?,NULL)",('TEST_ONLY',sid,scope,gap,route,'test',source,day,'synthetic test, rolled back'))
    assert c.execute("SELECT revisit_status FROM v_research_revisit_due WHERE attempt_id='A070-001'").fetchone()[0]=='event_ready'
    try:
        c.execute("UPDATE research_reopen_events SET consumed_by_attempt='A070-004' WHERE event_id='TEST_ONLY'")
        raise AssertionError('wrong track accepted')
    except sqlite3.IntegrityError:
        pass
    c.execute("UPDATE research_reopen_events SET consumed_by_attempt='A070-001' WHERE event_id='TEST_ONLY'")
    assert c.execute("SELECT count(*) FROM v_research_pending_events WHERE event_id='TEST_ONLY'").fetchone()[0]==0
    assert c.execute("SELECT revisit_status FROM v_research_revisit_due WHERE attempt_id='A070-001'").fetchone()[0]=='event_only'
    assert not c.execute('PRAGMA foreign_key_check').fetchall()
finally:
    c.rollback()
print('revisit event tests passed (rollback)')
