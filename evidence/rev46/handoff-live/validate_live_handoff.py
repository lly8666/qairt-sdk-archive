#!/usr/bin/env python3
from pathlib import Path
import hashlib, json, sys

H = Path(__file__).resolve().parent

def fail(msg):
    print('HANDOFF_LIVE_INVALID ' + msg)
    sys.exit(2)

def load_json(name):
    p = H / name
    if not p.is_file(): fail('missing=' + name)
    return json.loads(p.read_text())

def sha256(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()

required = ['READ_FIRST.md','LIVE_STATE.json','TASK_STACK.json','PROJECT_MAP.md','OPERATING_RULES.md','LAYOUT.md','RESTORE_BUNDLE_INDEX.json']
for name in required:
    if not (H / name).is_file(): fail('missing=' + name)

# Enforce live information-density budgets.
budgets = {
    'LIVE_STATE.json': 8 * 1024,
    'TASK_STACK.json': 8 * 1024,
    'PROJECT_MAP.md': 18 * 1024,
    'OPERATING_RULES.md': 14 * 1024,
    'READ_FIRST.md': 8 * 1024,
}
for name, limit in budgets.items():
    size = (H / name).stat().st_size
    if size > limit: fail('budget_exceeded=%s:%d>%d' % (name,size,limit))

live = load_json('LIVE_STATE.json')
stack = load_json('TASK_STACK.json')

if live.get('schema') != 2: fail('live_schema')
if live['repositories']['main_repo'] != 'lly8666/SimAdmin-Android': fail('main_repo')
if live['repositories']['support_repo'] != 'lly8666/qairt-sdk-archive': fail('support_repo')
if live['stable_resume_entry'] != 'lly8666/SimAdmin-Android:CURRENT_REV46_HANDOFF.md': fail('stable_entry')
if live['science_execution']['external_state_authorizes_execution'] is not False: fail('external_authorization')
if live['science_execution']['local_execution_requires'] != 'HANDOFF_LIVE_SCIENCE_VALID': fail('execution_marker')
if live['operation']['status'] not in ('IDLE','IN_PROGRESS','STALE'): fail('operation_status')
if live['operation']['status'] == 'IN_PROGRESS':
    for key in ('operation_id','expected_units','completed_units','resume_rule'):
        if key not in live['operation']: fail('in_progress_missing_' + key)

levels = stack.get('levels', {})
for key in ('L0_NORTH_STAR','L1_PHASE','L2_MECHANISM','L3_EXPERIMENT','L4_ACTION'):
    if key not in levels: fail('task_stack_missing=' + key)
if levels['L4_ACTION']['action_id'] != live['exact_next']['action_id']: fail('task_stack_exact_next_mismatch')
if live['exact_next']['execution_authorized_now'] is not False: fail('external_exact_next_authorized')
if live['active_experiment']['ort_stage1'] != 'COMPLETE_ALL_PASS': fail('ort_stage')
if live['active_experiment']['qnn_stage1'] != 'NOT_STARTED': fail('qnn_stage')
ids = [x['id'] for x in live['active_experiment']['candidates']]
if ids != ['A_local_max','B_local_rmse','C_p90_blockmax']: fail('candidate_ids')

print('HANDOFF_LIVE_VALID')
print('operation_status=' + live['operation']['status'])
print('main_repo=' + live['repositories']['main_repo'])
print('active=' + live['active_experiment']['id'])
print('exact_next=' + live['exact_next']['action_id'])
print('remaining_max_gap_pct=%.6f' % live['current_host_best']['remaining_relative_max_reduction_pct'])

# Optional local science-state validation. External live state alone never reaches this marker.
if len(sys.argv) == 3 and sys.argv[1] == '--local-root':
    root = Path(sys.argv[2])
    if not root.is_dir(): fail('missing_local_root')

    checks = []
    checks.append((live['current_host_best']['model_path'], live['current_host_best']['sha256']))
    exp = live['active_experiment']
    for obj in ('candidate_manifest','prereg','proxy_rank','stage1_ort_semantic'):
        checks.append((exp[obj]['path'], exp[obj]['sha256']))
    for cand in exp['candidates']:
        checks.append((cand['path'], cand['sha256']))

    for rel, expected in checks:
        p = root / rel
        if not p.is_file(): fail('missing_artifact=' + rel)
        if sha256(p) != expected: fail('artifact_sha=' + rel)

    if exp['qnn_stage1'] == 'NOT_STARTED':
        for cid in ids:
            q = root / 'k8_partial_guided_tree_family' / 'stage1' / ('qnn_' + cid)
            if q.exists() and any(q.rglob('Result_14')):
                fail('stale_qnn_results_exist=' + cid)

    print('HANDOFF_LIVE_SCIENCE_VALID')
