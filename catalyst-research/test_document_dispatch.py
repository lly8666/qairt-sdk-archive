"""Regression checks for 073 independent document dispatch (no DB mutation)."""
import sqlite3, sys
db=sqlite3.connect(sys.argv[1])
assert db.execute("PRAGMA integrity_check").fetchone()==('ok',)
assert not db.execute("PRAGMA foreign_key_check").fetchall()
assert db.execute("SELECT count(*) FROM v_research_document_tracks").fetchone()[0]==db.execute("SELECT count(*) FROM research_document_review").fetchone()[0]
assert db.execute("SELECT count(*) FROM v_research_document_tracks WHERE source_id='S072-01' AND track_action='extract_remaining_section'").fetchone()[0]==2
assert db.execute("SELECT count(*) FROM v_research_document_dispatch WHERE site_id='CN0156' AND source_id='turn699489search96' AND prior_track_count>=1 AND document_action!='verify_scope_and_access'").fetchone()[0]==1
assert db.execute("SELECT count(*) FROM v_research_pending_events WHERE event_id IN ('E071-01','E073-01','E073-02','E073-03')").fetchone()[0]==0
assert db.execute("SELECT count(*) FROM water_metrics WHERE source_id='S073-01' AND result_kind='历史在线监测'").fetchone()[0]==180
assert db.execute("SELECT count(*) FROM (SELECT site_id,water_id,point,metric,period,count(*) n FROM water_metrics WHERE source_id='S073-01' GROUP BY 1,2,3,4,5 HAVING n>1)").fetchone()[0]==0
print('073 independent document dispatch and historical monitoring regression: OK')
for r in db.execute("SELECT * FROM v_research_dispatch_audit"): print(*r)
