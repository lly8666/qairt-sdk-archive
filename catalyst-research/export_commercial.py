#!/usr/bin/env python3
"""Export the commercial screening layer from a rebuilt SQLite database."""
import argparse
import csv
import sqlite3
from pathlib import Path

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("database", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    with sqlite3.connect(args.database.resolve().as_uri() + "?mode=ro", uri=True) as db:
        assert db.execute("PRAGMA integrity_check").fetchone()[0] == "ok"
        assert not db.execute("PRAGMA foreign_key_check").fetchall()
        assert db.execute("SELECT count(*) FROM v_commercial_market_overview").fetchone()[0] == db.execute("SELECT count(*) FROM sites").fetchone()[0]
        assert db.execute("SELECT count(*) FROM v_commercial_priority_30").fetchone()[0] == db.execute("SELECT count(*) FROM commercial_opportunity_screen").fetchone()[0]
        for name, query in [
            ("commercial_overview.csv", "SELECT * FROM v_commercial_market_overview ORDER BY commercial_queue,site_id"),
            ("commercial_priority.csv", "SELECT * FROM v_commercial_priority_30 ORDER BY priority_band,site_id"),
            ("commercial_scenarios.csv", "SELECT * FROM v_commercial_scenario_economics ORDER BY site_id,scenario_id"),
        ]:
            cursor = db.execute(query)
            with (args.output / name).open("w", encoding="utf-8-sig", newline="") as f:
                writer = csv.writer(f)
                writer.writerow([col[0] for col in cursor.description])
                writer.writerows(cursor)
        print(db.execute("SELECT commercial_queue,count(*) FROM v_commercial_market_overview GROUP BY 1").fetchall())

if __name__ == "__main__":
    main()
