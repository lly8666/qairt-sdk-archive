#!/usr/bin/env python3
from pathlib import Path
import json, hashlib, sys
H=Path(__file__).resolve().parent
ROOT=H.parent

def sha(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def fail(msg):
    print('HANDOFF_V3_INVALID '+msg)
    sys.exit(2)

req=['READ_FIRST.md','REPOSITORY_MAP.md','PROJECT_GLOBAL_CONTEXT.md','ROADMAP_AND_DECISION_TREE.md','NEXT_HORIZON.json','ANTI_RABBIT_HOLE.md','CURRENT_STATE.json','EXACT_NEXT.json','CANDIDATE_MANIFEST.json','ENVIRONMENT_AND_LAYOUT.md','INVALID_AND_CLOSED_SUMMARY.md','RECOVERY_ANCHORS.md']
for n in req:
    if not (H/n).is_file(): fail('missing='+n)

s=json.loads((H/'CURRENT_STATE.json').read_text())
e=json.loads((H/'EXACT_NEXT.json').read_text())
h=json.loads((H/'NEXT_HORIZON.json').read_text())
c=json.loads((H/'CANDIDATE_MANIFEST.json').read_text())

if s.get('schema')!=3: fail('schema')
if s['repositories']['primary_main_repo']!='lly8666/SimAdmin-Android': fail('main_repo')
if s['repositories']['support_repo']!='lly8666/qairt-sdk-archive': fail('support_repo')
if e.get('action_id')!='RUN_QNN_STAGE1_A_B_C_ONLY' or not e.get('allowed'): fail('exact_next')
if s['active_experiment']['stage1_ort_all_pass'] is not True or s['active_experiment']['qnn_stage1_started'] is not False: fail('stage_boundary_state')
if c['stage1_ort_all_pass'] is not True or c['qnn_stage1_started'] is not False: fail('candidate_stage_boundary')
if [x['id'] for x in c['candidates']]!=['A_local_max','B_local_rmse','C_p90_blockmax']: fail('candidate_ids')

for cid in ['A_local_max','B_local_rmse','C_p90_blockmax']:
    q=ROOT/'k8_partial_guided_tree_family'/'stage1'/f'qnn_{cid}'
    if q.exists() and any(q.rglob('Result_14')): fail('stale_qnn_results_exist='+cid)

for cand in c['candidates']:
    p=ROOT/cand['model_path']
    if not p.is_file(): fail('missing_candidate='+cand['id'])
    if sha(p)!=cand['sha256']: fail('candidate_sha='+cand['id'])

for rel,expected in [
    (s['active_experiment']['stage1_ort_semantic_path'],s['active_experiment']['stage1_ort_semantic_sha256']),
    (s['active_experiment']['prereg_path'],s['active_experiment']['prereg_sha256']),
    (s['active_experiment']['proxy_rank_path'],s['active_experiment']['proxy_rank_sha256'])
]:
    p=ROOT/rel
    if not p.is_file() or sha(p)!=expected: fail('artifact='+rel)

if h['decision_nodes'][0]['id']!='H1_CURRENT_FAMILY_STAGE1': fail('horizon')

print('HANDOFF_V3_VALID')
print('handoff_id='+s['handoff_id'])
print('main_repo='+s['repositories']['primary_main_repo'])
print('support_repo='+s['repositories']['support_repo'])
print('active='+s['active_experiment']['id'])
print('exact_next='+e['action_id'])
print('next_horizon='+','.join(x['id'] for x in h['decision_nodes']))
print('remaining_max_gap_pct=%.6f'%s['strategy']['remaining_max_reduction_pct'])
