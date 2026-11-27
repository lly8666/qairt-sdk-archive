"""Check process/membrane extension on an already rebuilt SQLite database.
Checks structure and linkage, not truth of evidence, completeness, or Mermaid rendering.
"""
import sqlite3, sys
db = sqlite3.connect(sys.argv[1])
db.execute("PRAGMA foreign_keys=ON")
checks = {
    'diagram evidence cross-site': """SELECT e.evidence_id FROM process_diagram_evidence e
        JOIN process_diagrams d USING(diagram_id) JOIN wastewater w USING(water_id)
        WHERE d.site_id<>w.site_id""",
    'review diagram boundary mismatch': """SELECT r.review_id FROM membrane_reviews r JOIN process_diagrams d USING(diagram_id)
        WHERE r.site_id<>d.site_id OR r.scope_key<>d.scope_key OR r.stage<>d.stage OR r.period<>d.period""",
    'confirmed present without identified/unspecified unit': """SELECT r.review_id FROM membrane_reviews r
        WHERE r.presence='confirmed_present' AND NOT EXISTS(SELECT 1 FROM membrane_units u WHERE u.review_id=r.review_id)""",
    'confirmed absent/not applicable with membrane unit': """SELECT r.review_id FROM membrane_reviews r
        WHERE r.presence IN ('confirmed_absent','not_applicable') AND EXISTS(SELECT 1 FROM membrane_units u WHERE u.review_id=r.review_id)""",
    'diagram without evidence mapping': """SELECT d.diagram_id FROM process_diagrams d
        WHERE NOT EXISTS(SELECT 1 FROM process_diagram_evidence e WHERE e.diagram_id=d.diagram_id)""",
    'source not linked to site': """SELECT x.ident FROM (
        SELECT diagram_id AS ident,site_id,source_id FROM process_diagrams
        UNION ALL SELECT e.evidence_id,d.site_id,e.source_id FROM process_diagram_evidence e JOIN process_diagrams d USING(diagram_id)
        UNION ALL SELECT review_id,site_id,source_id FROM membrane_reviews WHERE source_id IS NOT NULL
        UNION ALL SELECT u.unit_id,r.site_id,u.source_id FROM membrane_units u JOIN membrane_reviews r USING(review_id)
        ) x WHERE NOT EXISTS(SELECT 1 FROM site_sources s WHERE s.site_id=x.site_id AND s.source_id=x.source_id)""",
    'unscored assessment with no missing input explanation': """SELECT assessment_id FROM v_membrane_retrofit_rating
        WHERE difficulty='unknown' AND length(trim(missing_inputs))=0""",
    'score without basis': """SELECT assessment_id FROM membrane_retrofits
        WHERE (feed_risk IS NOT NULL OR pretreatment_risk IS NOT NULL OR concentrate_risk IS NOT NULL OR integration_risk IS NOT NULL OR operational_risk IS NOT NULL OR compliance_economics_risk IS NOT NULL)
        AND length(trim(score_basis))=0"""
}
errors = 0
integrity = db.execute('PRAGMA integrity_check').fetchall()
fk = db.execute('PRAGMA foreign_key_check').fetchall()
print('integrity:', integrity, 'foreign key errors:', len(fk))
errors += int(integrity != [('ok',)]) + len(fk)
for label, sql in checks.items():
    bad = db.execute(sql).fetchall()
    print(label, len(bad), bad[:20])
    errors += len(bad)
print('queue: total, no diagram, no review, unresolved retrofit scopes')
print(db.execute("""SELECT count(*),sum(diagram_count=0),sum(membrane_review_count=0),sum(reviews_without_retrofit)
    FROM v_process_membrane_queue""").fetchone())
print('review status by stage:', db.execute("""SELECT stage,presence,count(*) FROM v_latest_membrane_reviews GROUP BY 1,2""").fetchall())
print('difficulty/feasibility:', db.execute("""SELECT difficulty,feasibility,count(*) FROM v_membrane_retrofit_rating GROUP BY 1,2""").fetchall())
db.close()
sys.exit(1 if errors else 0)
