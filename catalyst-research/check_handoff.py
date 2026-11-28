"""Validate bounded handoff and byte-exact sealed history (stdlib only)."""
from pathlib import Path
import hashlib, json, re
root = Path(__file__).resolve().parent
archive = root / 'archive' / 'research-001-103'
def blob_sha(p):
    b = p.read_bytes()
    return hashlib.sha1(b'blob ' + str(len(b)).encode() + b'\0' + b).hexdigest()
manifest = json.loads((archive / 'manifest.json').read_text(encoding='utf-8'))
assert len(manifest['blobs']) == 14
for name, sha in manifest['blobs'].items():
    assert blob_sha(archive / name) == sha, ('sealed archive changed', name)
for name in ('AGENTS.md','PROGRESS.md','WORKPLAN.md','APP_DESIGN.md','METHODOLOGY.md','EVIDENCE_POLICY.md','PROCESS_MEMBRANE.md','HISTORY.md','LONG_TERM_PROMPT.md','README.md'):
    assert (root / name).is_file(), name
p = root / 'PROGRESS.md'
assert p.stat().st_size <= 8192, 'rewrite current snapshot; do not append history'
assert (root / 'AGENTS.md').stat().st_size <= 12288, 'keep handoff entry concise'
s = p.read_text(encoding='utf-8')
def field(key):
    matches = re.findall(r'^- '+re.escape(key)+r': (.+)$',s,re.M)
    assert len(matches)==1, key
    return matches[0].strip()
batch, nxt = field('batch'),field('next_batch')
assert re.fullmatch(r'B\d{4,}',batch) and re.fullmatch(r'B\d{4,}',nxt)
n = int(batch[1:])
assert int(nxt[1:]) == n+1
rel = Path(field('batch_log'))
assert rel.parts[:2] == ('history','batches') and len(rel.parts)==4
assert rel.parts[2] == f'{n//100*100:04d}-{n//100*100+99:04d}'
assert rel.name.startswith(batch+'_') and rel.suffix=='.md'
assert (root/rel).is_file(), rel
assert (root/rel).stat().st_size <= 8192, 'put large detail in linked artifacts'
assert len(list((root/'history'/'batches').glob('*/'+batch+'_*.md')))==1
migration = max(int(x.name.split('_')[0]) for x in (root/'migrations').glob('*.sql'))
assert int(field('migration')) == migration, 'snapshot migration mismatch'
for k in ('phase','data_verified_head','updated_on'):
    field(k)
print('handoff OK:',batch,'next',nxt,'migration',migration,'sealed files',len(manifest['blobs']),'snapshot bytes',p.stat().st_size)
