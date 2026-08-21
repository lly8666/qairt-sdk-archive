#!/usr/bin/env python3
from pathlib import Path
import hashlib,json,sys
H=Path(__file__).resolve().parent
def fail(m): print('HANDOFF_LIVE_INVALID '+m); sys.exit(2)
def load(n):
 p=H/n
 if not p.is_file(): fail('missing='+n)
 return json.loads(p.read_text())
def sha(p): return hashlib.sha256(Path(p).read_bytes()).hexdigest()
for n in ['READ_FIRST.md','LIVE_STATE.json','TASK_STACK.json','PROJECT_MAP.md','OPERATING_RULES.md','LAYOUT.md','RESTORE_BUNDLE_INDEX.json']:
 if not (H/n).is_file(): fail('missing='+n)
for n,lim in {'LIVE_STATE.json':8192,'TASK_STACK.json':8192,'PROJECT_MAP.md':18432,'OPERATING_RULES.md':14336,'READ_FIRST.md':8192}.items():
 if (H/n).stat().st_size>lim: fail('budget_exceeded='+n)
live=load('LIVE_STATE.json'); stack=load('TASK_STACK.json')
if live.get('schema')!=2: fail('live_schema')
if live['repositories']['main_repo']!='lly8666/SimAdmin-Android': fail('main_repo')
if live['repositories']['support_repo']!='lly8666/qairt-sdk-archive': fail('support_repo')
if live['stable_resume_entry']!='lly8666/SimAdmin-Android:CURRENT_REV46_HANDOFF.md': fail('stable_entry')
if live['science_execution']['external_state_authorizes_execution'] is not False: fail('external_authorization')
if live['science_execution']['local_execution_requires']!='HANDOFF_LIVE_SCIENCE_VALID': fail('execution_marker')
levels=stack.get('levels',{})
for k in ('L0_NORTH_STAR','L1_PHASE','L2_MECHANISM','L3_EXPERIMENT','L4_ACTION'):
 if k not in levels: fail('task_stack_missing='+k)
if levels['L4_ACTION']['action_id']!=live['exact_next']['action_id']: fail('task_stack_exact_next_mismatch')
if live['exact_next'].get('execution_authorized_now') is not False: fail('external_exact_next_authorized')
op=live['operation']; st=op['status']
if st not in ('IDLE','IN_PROGRESS','STALE'): fail('operation_status')
if st=='IN_PROGRESS':
 for k in ('operation_id','expected_units','completed_units','resume_rule','output_root'):
  if k not in op: fail('in_progress_missing_'+k)
 if not set(op['completed_units']).issubset(set(op['expected_units'])): fail('completed_units')
print('HANDOFF_LIVE_VALID')
print('operation_status='+st)
print('main_repo='+live['repositories']['main_repo'])
print('active='+live['active_experiment']['id'])
print('exact_next='+live['exact_next']['action_id'])
print('remaining_max_gap_pct=%.6f'%live['current_host_best']['remaining_relative_max_reduction_pct'])
if len(sys.argv)==3 and sys.argv[1]=='--local-root':
 root=Path(sys.argv[2])
 if not root.is_dir(): fail('missing_local_root')
 for chk in live.get('local_artifact_checks',[]):
  p=root/chk['path']
  if not p.is_file(): fail('missing_artifact='+chk['path'])
  if sha(p)!=chk['sha256']: fail('artifact_sha='+chk['path'])
 if st=='IN_PROGRESS':
  done=set(op['completed_units'])
  for unit in op.get('unit_completion_markers',[]):
   marker=root/unit['path']; exists=marker.is_file()
   uid=unit['unit']
   if uid in done and not exists: fail('completed_unit_missing_marker='+uid)
   if uid not in done and exists: fail('unpublished_completed_unit='+uid)
 print('HANDOFF_LIVE_SCIENCE_VALID')
