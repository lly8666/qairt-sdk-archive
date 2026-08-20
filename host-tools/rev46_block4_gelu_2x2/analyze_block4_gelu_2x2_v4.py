#!/usr/bin/env python3
from __future__ import annotations

import argparse
import collections
import hashlib
import json
import math
import pathlib
import re

import numpy as np

OP_RE = re.compile(r'Qnn_OpConfigV1_t\s+[^=]+?=\s*\{"([^"]+)",\s*"([^"]+)",\s*"([^"]+)"')
CASE_DIRS = {
    "A": "A_dynamic_erf",
    "B": "B_staticT4_erf",
    "C": "C_dynamic_canonicalGelu",
    "D": "D_staticT4_canonicalGelu",
}
OUTPUTS = ("activation", "pw2", "residual_out")


def sha256(path):
    h=hashlib.sha256()
    with path.open('rb') as f:
        for b in iter(lambda:f.read(1<<20),b''): h.update(b)
    return h.hexdigest()


def load_json(path):
    return json.loads(path.read_text())


def metrics(ref, cand):
    a=np.asarray(ref,dtype=np.float32).reshape(-1); b=np.asarray(cand,dtype=np.float32).reshape(-1)
    if a.size != b.size:
        return {'shape_equal':False,'ref_count':int(a.size),'cand_count':int(b.size)}
    d=b.astype(np.float64)-a.astype(np.float64)
    den=float(np.linalg.norm(a.astype(np.float64))*np.linalg.norm(b.astype(np.float64)))
    cos=float(np.dot(a.astype(np.float64),b.astype(np.float64))/den) if den else 1.0
    return {
        'shape_equal':True,'count':int(a.size),
        'max_abs':float(np.max(np.abs(d))) if d.size else 0.0,
        'mean_abs':float(np.mean(np.abs(d))) if d.size else 0.0,
        'rmse':float(np.sqrt(np.mean(d*d))) if d.size else 0.0,
        'cosine':cos,
        'exact_bits':bool(np.array_equal(a.view(np.uint32),b.view(np.uint32))),
    }


def qnn_cpu_metrics(cdir):
    out={}
    raws=list((cdir/'qnn_cpu').rglob('*.raw')) if (cdir/'qnn_cpu').exists() else []
    for name in OUTPUTS:
        refp=cdir/f'ort_{name}.f32'
        candidates=[p for p in raws if p.stem==name or p.name==f'{name}.raw']
        if len(candidates)!=1:
            # QNN may sanitize or nest result files; use unique substring only as secondary mapping.
            candidates=[p for p in raws if name.lower() in p.name.lower()]
        if len(candidates)==1 and refp.is_file():
            ref=np.fromfile(refp,dtype='<f4'); cand=np.fromfile(candidates[0],dtype='<f4')
            out[name]={'raw':str(candidates[0].relative_to(cdir)),'metric':metrics(ref,cand)}
        else:
            out[name]={'raw':None,'candidate_files':[str(p.relative_to(cdir)) for p in candidates[:20]]}
    return out


def parse_saver(cdir):
    root=cdir/'saver_capture'
    files=[p for p in root.rglob('*') if p.is_file()] if root.exists() else []
    ops=[]; gelu_symbol=False; texts=[]
    for p in files:
        if p.stat().st_size > 20_000_000:
            continue
        try: txt=p.read_text(errors='replace')
        except Exception: continue
        if 'Qnn_OpConfig' in txt or 'ElementWiseNeuron' in txt or 'GELU' in txt or 'Gelu' in txt:
            texts.append((p,txt))
        if 'QNN_OP_ELEMENT_WISE_NEURON_OPERATION_GELU' in txt or 'QNN_Gelu' in txt:
            gelu_symbol=True
        for name,pkg,typ in OP_RE.findall(txt):
            ops.append({'name':name,'package':pkg,'type':typ,'file':str(p.relative_to(cdir))})
    counts=collections.Counter(x['type'] for x in ops)
    neuron_idx=[i for i,x in enumerate(ops) if x['type']=='ElementWiseNeuron']
    fc_idx=[i for i,x in enumerate(ops) if x['type']=='FullyConnected']
    boundary=False
    for ni in neuron_idx:
        if any(fi < ni for fi in fc_idx) and any(fi > ni for fi in fc_idx):
            boundary=True; break
    # Capture a compact neighborhood around the first neuron for causal inspection.
    neighborhoods=[]
    for ni in neuron_idx[:4]:
        lo=max(0,ni-5); hi=min(len(ops),ni+6)
        neighborhoods.append([f"{x['type']}:{x['name']}" for x in ops[lo:hi]])
    return {
        'capture_file_count':len(files),
        'parsed_graph_add_ops':len(ops),
        'op_type_counts':dict(sorted(counts.items())),
        'elementwise_neuron_count':len(neuron_idx),
        'fully_connected_count':len(fc_idx),
        'fc_neuron_fc_order_present':boundary,
        'gelu_symbol_present':gelu_symbol,
        'neuron_neighborhoods':neighborhoods,
        'text_evidence_files':[str(p.relative_to(cdir)) for p,_ in texts[:30]],
    }


def has_op(case_rec, key):
    return int(case_rec.get('op_inventory',{}).get(key,0)) > 0


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--matrix-root',required=True)
    ap.add_argument('--graph-audit',required=True)
    ap.add_argument('--full-vocos-saver-evidence',required=True)
    ap.add_argument('--out',required=True)
    args=ap.parse_args()
    root=pathlib.Path(args.matrix_root).resolve()
    pre=load_json(root/'MATRIX_PRE_QAIRT_REPORT.json')
    audit=load_json(pathlib.Path(args.graph_audit))
    full=load_json(pathlib.Path(args.full_vocos_saver_evidence))

    by_sha={m['sha256']:m for m in audit['models']}
    cases={}
    for cid,dn in CASE_DIRS.items():
        cdir=root/dn
        q=load_json(cdir/'QAIRT_STATUS.json')
        pre_case=pre['cases'][cid]
        ar=by_sha.get(pre_case['sha256'])
        saver=parse_saver(cdir)
        canonical = not has_op(pre_case,'ai.onnx::Erf') and has_op(pre_case,'com.microsoft::Gelu')
        runtime_chain = bool(q['converter_default_pass'] and q['model_lib_pass'] and q['qnn_cpu_pass'] and q['saver_pass'])
        structural = {
            'onnx_canonical_gelu':canonical,
            'onnx_erf_present':has_op(pre_case,'ai.onnx::Erf'),
            'saver':saver,
            'known_good_full_vocos_reference':{
                'canonical_total_graph_add_ops':full['saver']['canonical_total_graph_add_ops'],
                'canonical_block4_sequence':full['saver']['canonical_block4_sequence'],
                'canonical_gelu_op':'ElementWiseNeuron',
                'canonical_gelu_operation_parameter_uint32':full['saver']['canonical_anonymous_neuron']['operation_parameter_uint32'],
                'canonical_gelu_qnn_op_def':full['saver']['canonical_anonymous_neuron']['qnn_op_def'],
            },
            'relevant_fusion_boundary_match': bool(canonical and saver['elementwise_neuron_count']>=1 and saver['fc_neuron_fc_order_present']),
        }
        cases[cid]={
            'axis':pre_case['axis'],
            'onnx_sha256':pre_case['sha256'],
            'pre_qairt_semantic_pass':pre['cpu_semantics']['case_pass'][cid],
            'graph_audit':ar,
            'qairt':q,
            'default_runtime_chain_pass':runtime_chain,
            'qnn_cpu_vs_ort':qnn_cpu_metrics(cdir),
            'structural':structural,
        }

    def conv(cid): return cases[cid]['qairt']['converter_default_pass']
    def key(cid): return cases[cid]['qairt']['converter_matmul_to_fc_keyerror']
    def shape(cid): return cases[cid]['qairt']['converter_mentions_cannot_get_shape']
    def chain(cid): return cases[cid]['default_runtime_chain_pass']
    def fusion(cid): return cases[cid]['structural']['relevant_fusion_boundary_match']

    c_qualified = bool(pre['pre_qairt_pass'] and chain('C') and fusion('C'))
    d_qualified = bool(pre['pre_qairt_pass'] and chain('D') and fusion('D'))
    recovery_qualified = c_qualified or d_qualified
    selected = 'C' if c_qualified else ('D' if d_qualified else None)

    # Factor effects are stated only from observed default converter/runtime behavior.
    causal={
        'shape_only_A_to_B':{
            'A_converter_pass':conv('A'),'B_converter_pass':conv('B'),
            'A_matmul_to_fc_keyerror':key('A'),'B_matmul_to_fc_keyerror':key('B'),
            'A_cannot_get_shape':shape('A'),'B_cannot_get_shape':shape('B'),
            'interpretation':(
                'static T=4 alone changes the converter failure class or enables conversion'
                if (conv('A')!=conv('B') or key('A')!=key('B') or shape('A')!=shape('B'))
                else 'static T=4 alone does not change the observed default converter classification'
            ),
        },
        'gelu_only_A_to_C':{
            'A_converter_pass':conv('A'),'C_converter_pass':conv('C'),
            'A_matmul_to_fc_keyerror':key('A'),'C_matmul_to_fc_keyerror':key('C'),
            'A_cannot_get_shape':shape('A'),'C_cannot_get_shape':shape('C'),
            'C_runtime_chain_pass':chain('C'),'C_fusion_boundary_match':fusion('C'),
            'interpretation':(
                'canonical GELU alone is sufficient for the complete default QAIRT CPU+Saver host funnel'
                if c_qualified else
                'canonical GELU alone is not sufficient for the complete default QAIRT CPU+Saver host funnel'
            ),
        },
        'combined_D':{
            'D_converter_pass':conv('D'),'D_runtime_chain_pass':chain('D'),'D_fusion_boundary_match':fusion('D'),
            'interpretation':(
                'static T=4 plus canonical GELU survives semantics, converter, model-lib, QNN CPU, Saver, and relevant full-Vocos fusion-boundary checks'
                if d_qualified else
                'combined static T=4 plus canonical GELU does not clear the complete host funnel'
            ),
        },
    }

    result={
        'schema':4,
        'purpose':'REV46_BLOCK4_GELU_2X2_QAIRT244_HOST_SIMULATION_MATRIX_V4',
        'scientific_boundary':'host-only causal simulation; QNN CPU/Saver are not target HTP truth; no APK/device action authorized by this report',
        'qairt':'2.44.0.260225',
        'pre_qairt_report_sha256':sha256(root/'MATRIX_PRE_QAIRT_REPORT.json'),
        'graph_audit_sha256':sha256(pathlib.Path(args.graph_audit)),
        'full_vocos_saver_evidence_sha256':sha256(pathlib.Path(args.full_vocos_saver_evidence)),
        'cases':cases,
        'causal_factor_readout':causal,
        'canonical_only_qualified':c_qualified,
        'combined_staticT4_canonical_qualified':d_qualified,
        'recovery_qualified_for_full_vocos_host_integration':recovery_qualified,
        'selected_minimal_host_recovery_case':selected,
        'device_gate':'BLOCKED' if not recovery_qualified else 'STILL_BLOCKED_UNTIL_FULL_VOCOS_HOST_GATES_PASS',
        'status':'PASS' if recovery_qualified else 'FAIL',
    }
    out=pathlib.Path(args.out)
    out.write_text(json.dumps(result,indent=2,sort_keys=True)+'\n')
    print('REV46_BLOCK4_GELU_2X2_HOST_SIMULATION_'+result['status'])
    print('selected_minimal_host_recovery_case=',selected)
    print('report=',out)
    if not recovery_qualified:
        raise SystemExit(2)

if __name__=='__main__': main()
