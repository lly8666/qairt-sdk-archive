# REV46 LIVE HANDOFF — stable entrypoint

This is the **stable, version-independent handoff entry** for the active MeanVC2 REV46 workstream.

Main/production authority: `lly8666/SimAdmin-Android`.
Supporting host-science/evidence/recovery authority: `lly8666/qairt-sdk-archive`.

A fresh agent must start from the main repository file `CURRENT_REV46_HANDOFF.md`, then follow its pointer here. Do not choose a historical handoff version manually.

## Mandatory read order
1. `LIVE_STATE.json` — sole externally published NOW pointer.
2. `REALTIME_SYNC_PROTOCOL.md` — handoff is a mandatory concurrent task during development, not an end-of-session summary.
3. `RESUME_RULES.md` — what to do if an operation was interrupted or the sandbox disappeared.
4. `LATEST_GENERATION.json` — exact versioned handoff generation backing the live state.
5. The generation's NORTH STAR / NEXT HORIZON / NOW documents referenced there.
6. `RESTORE_BUNDLE_INDEX.json` — machine-readable reconstruction sources and fingerprints.
7. `INTEGRITY_MANIFEST.json` — external publication identity.

## Authority rule
- `LIVE_STATE.json` decides the externally visible current breakpoint.
- If a matching local sandbox exists, science execution requires the current local validator PASS marker stated in `LIVE_STATE.json`.
- If the sandbox is absent, the external live package is sufficient to restore/audit state but **never by itself authorizes science execution**. Restore the local environment/artifacts, validate, then continue.

## Three scales that must always be restored
- **NORTH STAR:** project mission, causal fault history, closed branches, host→device→production roadmap and contingency route.
- **NEXT HORIZON:** the next 2–4 decision nodes, pass/fail exits and anti-rabbit-hole route-switch conditions.
- **NOW:** exact best artifact, active experiment, completed/unstarted work, one exact next action, and any in-progress resume boundary.

A handoff is defective if it can recover the next command but not NEXT HORIZON, or recover NEXT HORIZON but not the exact current stage boundary.