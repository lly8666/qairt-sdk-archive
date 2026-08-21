#!/usr/bin/env python3
from pathlib import Path
import json, sys, subprocess

H = Path(__file__).resolve().parent
SUPPORT_ROOT = H.parents[2]


def fail(msg):
    print('HANDOFF_LIVE_INVALID ' + msg)
    sys.exit(2)


def load(name):
    p = H / name
    if not p.is_file():
        fail('missing=' + name)
    return json.loads(p.read_text())

live = load('LIVE_STATE.json')
latest = load('LATEST_GENERATION.json')
restore = load('RESTORE_BUNDLE_INDEX.json')

if live['repositories']['main_repo'] != 'lly8666/SimAdmin-Android':
    fail('main_repo')
if live['repositories']['support_repo'] != 'lly8666/qairt-sdk-archive':
    fail('support_repo')
if live['stable_resume_entry'] != 'lly8666/SimAdmin-Android:CURRENT_REV46_HANDOFF.md':
    fail('stable_entry')
if live['science_execution']['external_snapshot_science_execution_authorized'] is not False:
    fail('external_authorization')
if live['exact_next']['action_id'] != 'RUN_QNN_STAGE1_A_B_C_ONLY':
    fail('exact_next')
if live['active_experiment']['ort_stage1'] != 'COMPLETE_ALL_PASS':
    fail('ort_stage')
if live['active_experiment']['qnn_stage1'] != 'NOT_STARTED':
    fail('qnn_stage')
if live['operation']['status'] not in ('IDLE','IN_PROGRESS','STALE'):
    fail('operation_status')
if live['operation']['status'] == 'IN_PROGRESS':
    for k in ('operation_id','expected_units','completed_units','resume_rule'):
        if k not in live['operation']:
            fail('in_progress_missing_' + k)
if latest['current_generation'] != live['handoff_generation']['name']:
    fail('generation_mismatch')
if latest['external_science_execution_authorized'] is not False:
    fail('generation_external_authorization')

ids = [x['id'] for x in live['active_experiment']['candidates']]
if ids != ['A_local_max','B_local_rmse','C_p90_blockmax']:
    fail('candidate_ids')

print('HANDOFF_LIVE_VALID')
print('live_handoff_id=' + live['live_handoff_id'])
print('operation_status=' + live['operation']['status'])
print('main_repo=' + live['repositories']['main_repo'])
print('active=' + live['active_experiment']['id'])
print('exact_next=' + live['exact_next']['action_id'])
print('execution_authorized_now=' + str(live['exact_next']['execution_authorized_now']).lower())
print('remaining_max_gap_pct=%.6f' % live['current_host_best']['remaining_relative_max_reduction_pct'])

if len(sys.argv) == 3 and sys.argv[1] == '--local-validator':
    p = Path(sys.argv[2])
    if not p.is_file():
        fail('missing_local_validator')
    r = subprocess.run([sys.executable, str(p)], text=True, capture_output=True)
    if r.returncode != 0 or 'HANDOFF_V3_VALID' not in r.stdout:
        fail('local_validator_failed')
    print('LOCAL_EXECUTION_STATE_VALID')
