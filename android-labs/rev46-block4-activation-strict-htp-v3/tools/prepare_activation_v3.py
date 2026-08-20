#!/usr/bin/env python3
import argparse, hashlib, json, math, pathlib, shutil, tempfile
from collections import Counter

import numpy as np
import onnx
import onnxruntime as ort
from onnx import TensorProto, helper
from onnx.utils import extract_model

PREACT=1536
SHAPES={"cold4":4,"warm6":6}
FIXTURES={"cold4":["cold0"],"warm6":["warm1","warm18","warm47"]}


def sha256(p):
    h=hashlib.sha256()
    with open(p,'rb') as f:
        for b in iter(lambda:f.read(1<<20),b''): h.update(b)
    return h.hexdigest()


def op_inventory(model):
    return dict(sorted(Counter((n.domain or 'ai.onnx')+':'+n.op_type for n in model.graph.node).items()))


def dynamic_dims(model):
    out=[]
    for group,name in ((model.graph.input,'input'),(model.graph.output,'output'),(model.graph.value_info,'value_info')):
        for vi in group:
            tt=vi.type.tensor_type
            if not tt.HasField('shape'): continue
            dims=[]
            dyn=False
            for d in tt.shape.dim:
                if d.HasField('dim_value'): dims.append(int(d.dim_value))
                elif d.HasField('dim_param'): dims.append(d.dim_param); dyn=True
                else: dims.append('?'); dyn=True
            if dyn: out.append({"kind":name,"name":vi.name,"dims":dims})
    return out


def freeze_symbolic_dims(model,t):
    for group in (model.graph.input,model.graph.output,model.graph.value_info):
        for vi in group:
            tt=vi.type.tensor_type
            if not tt.HasField('shape'): continue
            for d in tt.shape.dim:
                if d.HasField('dim_param') and d.dim_param:
                    d.dim_value=t
                    d.ClearField('dim_param')
    return model


def make_contrib_gelu(t):
    x=helper.make_tensor_value_info('preact',TensorProto.FLOAT,[1,t,PREACT])
    y=helper.make_tensor_value_info('activation',TensorProto.FLOAT,[1,t,PREACT])
    node=helper.make_node('Gelu',['preact'],['activation'],name='rev46_v3_baseline_contrib_gelu',domain='com.microsoft')
    graph=helper.make_graph([node],'rev46_v3_baseline_contrib_gelu',[x],[y])
    model=helper.make_model(graph,producer_name='qairt-sdk-archive/rev46-activation-v3',
        opset_imports=[helper.make_opsetid('',20),helper.make_opsetid('com.microsoft',1)])
    model.ir_version=9
    onnx.checker.check_model(model)
    return model


def load_f32(p,count):
    x=np.fromfile(p,dtype='<f4')
    if x.size!=count: raise RuntimeError(f'geometry mismatch {p}: {x.size} != {count}')
    return x.astype(np.float32,copy=False)


def run_model(path,x,t):
    s=ort.InferenceSession(str(path),providers=['CPUExecutionProvider'])
    y=s.run(['activation'],{'preact':x.reshape(1,t,PREACT)})[0]
    return np.asarray(y,dtype=np.float32).reshape(-1)


def metric(ref,cand):
    d=cand.astype(np.float64)-ref.astype(np.float64)
    return {
        'max_abs':float(np.max(np.abs(d))),
        'mean_abs':float(np.mean(np.abs(d))),
        'rmse':float(np.sqrt(np.mean(d*d))),
        'exact_bits':bool(np.array_equal(ref.view(np.uint32),cand.view(np.uint32)))
    }


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--payload-root',required=True)
    ap.add_argument('--out-dir',required=True)
    a=ap.parse_args()
    root=pathlib.Path(a.payload_root).resolve(); out=pathlib.Path(a.out_dir).resolve(); out.mkdir(parents=True,exist_ok=True)
    src_base=root/'models'/'block4_baseline.onnx'; src_cand=root/'models'/'block4_candidate.onnx'
    baseline_src=onnx.load(src_base); candidate_src=onnx.load(src_cand)
    report={
        'schema':1,
        'role':'fixed-shape activation-only strict-HTP model preparation; no threshold relaxation; no CPU fallback device policy change',
        'source':{
            'baseline_sha256':sha256(src_base),'candidate_sha256':sha256(src_cand),
            'baseline_ops':op_inventory(baseline_src),'candidate_ops':op_inventory(candidate_src),
            'baseline_dynamic_dims':dynamic_dims(baseline_src),'candidate_dynamic_dims':dynamic_dims(candidate_src)
        },
        'ort_cpu_version':ort.__version__,
        'variants':[],
        'qualification':{'candidate_exact_all':True,'baseline_contrib_gelu_max_abs_le_1e6_all':True}
    }
    with tempfile.TemporaryDirectory() as td:
        td=pathlib.Path(td)
        extracted=td/'candidate_activation_dynamic.onnx'
        extract_model(str(src_cand),str(extracted),['preact'],['activation'],check_model=True)
        extracted_model=onnx.load(extracted)
        report['source']['candidate_activation_extracted_ops']=op_inventory(extracted_model)
        report['source']['candidate_activation_dynamic_dims']=dynamic_dims(extracted_model)
        for shape,t in SHAPES.items():
            bpath=out/f'{shape}_baseline_contrib_gelu.onnx'
            cpath=out/f'{shape}_candidate_exact_activation.onnx'
            onnx.save(make_contrib_gelu(t),bpath)
            cm=onnx.load(extracted)
            freeze_symbolic_dims(cm,t)
            cm=onnx.shape_inference.infer_shapes(cm)
            freeze_symbolic_dims(cm,t)
            onnx.checker.check_model(cm)
            onnx.save(cm,cpath)
            variant={
                'shape':shape,'t':t,
                'baseline_model':bpath.name,'baseline_sha256':sha256(bpath),'baseline_bytes':bpath.stat().st_size,
                'candidate_model':cpath.name,'candidate_sha256':sha256(cpath),'candidate_bytes':cpath.stat().st_size,
                'baseline_ops':op_inventory(onnx.load(bpath)),'candidate_ops':op_inventory(onnx.load(cpath)),
                'baseline_dynamic_dims':dynamic_dims(onnx.load(bpath)),'candidate_dynamic_dims':dynamic_dims(onnx.load(cpath)),
                'fixtures':[]
            }
            if variant['baseline_dynamic_dims'] or variant['candidate_dynamic_dims']:
                raise RuntimeError(f'dynamic dims survived in {shape}')
            for fixture in FIXTURES[shape]:
                x=load_f32(root/'fixtures'/f'preact_{fixture}.f32',t*PREACT)
                boracle=load_f32(root/'oracle'/f'baseline_{fixture}_activation.f32',t*PREACT)
                coracle=load_f32(root/'oracle'/f'candidate_{fixture}_activation.f32',t*PREACT)
                bout=run_model(bpath,x,t); cout=run_model(cpath,x,t)
                bm=metric(boracle,bout); cmtr=metric(coracle,cout)
                report['qualification']['candidate_exact_all'] &= cmtr['exact_bits']
                report['qualification']['baseline_contrib_gelu_max_abs_le_1e6_all'] &= bm['max_abs'] <= 1e-6
                variant['fixtures'].append({'id':fixture,'baseline_vs_frozen_oracle':bm,'candidate_vs_frozen_oracle':cmtr})
            report['variants'].append(variant)
    report['status']='PASS' if report['qualification']['candidate_exact_all'] and report['qualification']['baseline_contrib_gelu_max_abs_le_1e6_all'] else 'REVIEW'
    mp=out/'ACTIVATION_V3_MANIFEST.json'; mp.write_text(json.dumps(report,indent=2,sort_keys=True)+'\n')
    print('REV46_ACTIVATION_V3_HOST_QUALIFICATION_'+report['status'])
    print(mp.read_text())
    if report['status']!='PASS': raise SystemExit(2)

if __name__=='__main__': main()
