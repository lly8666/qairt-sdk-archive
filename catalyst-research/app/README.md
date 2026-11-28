# Practical local workbench
Build the public SQLite database with the repository's standard build script. Start:
```bash
python catalyst-research/app/workbench.py /path/to/catalyst.sqlite --workspace /path/outside/repository/workspace.sqlite
```
Open http://127.0.0.1:8765. Without --workspace the market browser is read-only.
- Business desk: customer search, ownership evidence, procurement route, public business channels and follow-up.
- Technical desk: original wastewater streams, process and membrane evidence; record private stream measurements and compare them with versioned capability ranges.
- Capability: save new technology versions and rescan candidate streams. Numeric fit is conditional screening only; unknown parameters remain unknown.
- Tasks: overdue, today, next seven days and undated follow-ups.
- Economics: same-scope, same-period scenario calculator; no automatic unit conversion or real quote.
- Market: distinguish original water records, unique streams matched, direction hits and company-direction candidates.
Workspace SQLite contains internal notes/measurements and must remain outside this public repository. This is a local single-user trial, not network production or authenticated multi-user deployment. Do not put real customer/private company data in GitHub or CI.
Keyword directions are navigation hints; direct/contextual signal strength is shown separately. A stream may appear in several directions. Ownership is dated and not procurement authority. Procurement stages distinguish historical closed tenders from open tenders. Equipment view normalizes membrane family but retains source wording and application boundary.
