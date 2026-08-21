# REV46 live operating rules

This file governs both scientific focus and handoff size. The live handoff is a **state system**, not a diary.

## 1. Task-stack preflight — prevents tunnel vision
Before any new candidate family or long science operation, read `TASK_STACK.json` from L0 to L4 and answer its five preflight questions. A new action is forbidden if its `parent_alignment`, causal mechanism, closure rule, protected-data boundary, or failure return-level is missing.

Mandatory zoom-out cadence:
- after every scored experiment: check L3 against L2;
- after family closure: return to L2 before proposing a sibling family;
- after two consecutive non-material experiments in one mechanism: stop tuning that mechanism and re-localize causally;
- when a proposed family has only micro-tuning leverage relative to the remaining gate gap: reject the family before running it;
- after the current tree mechanism, at most one further causally distinct exact/equivalent family by default; if it also lacks material progress, return to L1/L0 and activate the preserved learned/student/surrogate contingency.

An exact-next command authorizes only that bounded action. It never authorizes indefinite optimization of the same mechanism.

## 2. Realtime transaction protocol
Before any interruptible operation, publish `LIVE_STATE.operation.status=IN_PROGRESS` with operation ID, expected units, completed units, output locations, idempotent resume rule, and whether scoring is forbidden until completion.

During the operation, synchronize durable completion facts only. Never use partial comparative scores when preregistration forbids early selection. Duplicate executions receive zero additional statistical weight.

After the operation, validate completeness/provenance, score only at the frozen boundary, update best/closure decision, update `LIVE_STATE.json` and `TASK_STACK.json`, then set operation back to `IDLE`. If results are newer than the live state, science stops until handoff is reconciled.

## 3. Information-density budget
The live handoff must remain small enough for a fresh agent to read completely before acting.

Hard design targets:
- `READ_FIRST.md`: <= 1200 words; navigation only.
- `LIVE_STATE.json`: <= 8 KiB; current facts only.
- `TASK_STACK.json`: <= 8 KiB; L0-L4 goals, exits and current strategic budget only.
- `PROJECT_MAP.md`: <= 2500 words; durable causal chain + one-line closed mechanisms + route only.
- `OPERATING_RULES.md`: <= 1800 words; process invariants only.
- restore/integrity indexes may be larger, but are read on recovery/audit demand, not normal science preflight.

If a file exceeds its budget, compact it before adding more content.

## 4. Hot / warm / cold information tiers
**HOT — always read:** `READ_FIRST.md`, `LIVE_STATE.json`, `TASK_STACK.json`, `PROJECT_MAP.md`, `OPERATING_RULES.md`.

**WARM — read only when relevant:** current candidate manifest, layout contract, restore index, current preregistration, current invalid/closed detail.

**COLD — never copy into live state:** raw logs, full result matrices, superseded handoff generations, historical narrative, old candidate-by-candidate tables, device logs. Store them under normal evidence/checkpoint paths and reference them by compact pointer/SHA.

## 5. Compaction rules
- Live files are **overwrite-current**, never append-only histories.
- A closed family gets exactly one durable live sentence: mechanism, closure reason, evidence pointer. Detailed metrics leave the live tier.
- Keep only the current host best and at most one immediate parent baseline in HOT state.
- Keep only the active experiment's candidate SHAs in HOT state; previous candidate lists move to evidence.
- Do not duplicate the same metric/hypothesis in multiple HOT files. `LIVE_STATE` owns exact current facts; `TASK_STACK` owns hierarchy/strategy; `PROJECT_MAP` owns durable causal history.
- Git commit history is the revision history. Do not create `handoff-v4/v5/...` just to preserve edits.
- Version numbers are allowed only inside immutable evidence/artifact identities when technically necessary; they are not part of the normal handoff navigation model.

## 6. Promotion / demotion of information
Promote evidence into HOT state only if it changes at least one of: current best, exact next, task-stack parent goal, closure status, safety constraint, execution authorization, recovery fingerprint.

Demote information from HOT to COLD when it no longer changes a current decision. Summarize it to one line plus pointer before demotion.

## 7. Fresh-agent success criterion
A fresh agent should be able to answer, after reading HOT files only:
1. What is the project trying to achieve?
2. What causal model currently explains the failure?
3. What mechanism is being tested now, and why?
4. What exact action is next, and is it executable now?
5. What closes this experiment/mechanism?
6. What happens one and two levels above if it fails?
7. What must never be rerun or leaked into fitting?

If any answer requires reading historical chat, the handoff is defective.
