# REV46 LIVE HANDOFF — stable entry

Main/production authority: `lly8666/SimAdmin-Android`.
Host-science/evidence/recovery authority: `lly8666/qairt-sdk-archive`.

Start from `lly8666/SimAdmin-Android/CURRENT_REV46_HANDOFF.md`, then come here. Do not choose a handoff version; superseded/versioned handoffs are historical evidence only.

## Normal read: five HOT files
1. `READ_FIRST.md` — navigation and authority.
2. `LIVE_STATE.json` — exact NOW state, best artifact, operation boundary and exact-next.
3. `TASK_STACK.json` — L0 north star -> L1 phase -> L2 mechanism -> L3 experiment -> L4 action, including exits and route switches.
4. `PROJECT_MAP.md` — compact durable fault map, closed mechanisms and host->device->production route.
5. `OPERATING_RULES.md` — zoom-out cadence, realtime synchronization, anti-rabbit-hole rules and compaction policy.

Read all five before science. A handoff that restores only the next command or only the broad roadmap is incomplete.

## WARM files: execution/recovery only
- `LAYOUT.md`
- `RESTORE_BUNDLE_INDEX.json`
- `INTEGRITY_MANIFEST.json`
- `validate_live_handoff.py`

## Rules
`LIVE_STATE.json` is the sole external NOW pointer. `TASK_STACK.json` is the sole live hierarchy/strategy pointer. Live files are current-state documents, not diaries; Git history and evidence/checkpoint paths preserve history.

External live state authorizes restoration/audit only. Reconstruct local artifacts/environment, verify identities/fingerprints, then pass the stable live validator before science execution.

Keep HOT state compact: closed work becomes one line plus evidence pointer; raw logs, old result tables, superseded candidate lists and old handoff snapshots stay in COLD evidence.