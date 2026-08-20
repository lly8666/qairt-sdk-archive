#!/usr/bin/env python3
import argparse, hashlib, inspect, json, pathlib, shutil, tempfile
from collections import Counter

import numpy as np
import onnx
import onnxruntime as ort
from onnx import TensorProto, helper
from onnxruntime.quantization import CalibrationMethod, QuantType, quantize
from onnxruntime.quantization.execution_providers.qnn import get_qnn_qdq_config, qnn_preprocess_model

PREACT=1536
SHAPES={"cold4":4,"warm6":6}
FIXTURES={"cold4":["cold0"],"warm6":["warm1","warm18","warm47"]}
FINAL_GATE={"max_abs":3e-4,"mean_abs":1e-5,"rmse":2e-5,"cosine":0.99999}
CALIBRATION_POLICY="SYNTHETIC_FIXED_RANGE_ONLY_NO_FROZEN_FIXTURE_CALIBRATION"
CALIBRATION_RANGE=[-16.0,16.0]


def sha256(p):
    h=hashlib.sha256()
    with open(p,'rb') as f:
        for b in iter(lambda:f.read(1<<20),b''): h.update(b)
    return h.hexdigest()


def op_inventory(path):
    m=onnx.load(path)
    return dict(sorted(Counter((n.domain or 'ai.onnx')+':'+n.op_type for n in m.graph.node).items()))


def dynamic_dims(path):
    m=onnx.load(path); out=[]
    for group,name in ((m.graph.input,'input'),(m.graph.output,'output'),(m.graph.value_info,'value_info')):
        for vi in group:
            tt=vi.type.tensor_type
            if not tt.HasField('shape'): continue
            dims=[]; dyn=False
            for d in tt.shape.dim:
                if d.HasField('dim_value'): dims.append(int(d.dim_value))
                elif d.HasField('dim_param'): dims.append(d.dim_param); dyn=True
                else: dims.append('?'); dyn=True
            if dyn: out.append({'kind':name,'name':vi.name,'dims':dims})
    return out


class SyntheticReader:
    def __init__(self,t):
        n=t*PREACT; idx=np.arange(n,dtype=np.float32)
        lo,hi=CALIBRATION_RANGE
        lin=np.linspace(lo,hi,n,dtype=np.float32)
        self.rows=[
            np.zeros(n,dtype=np.float32),
            lin,
            lin[::-1].copy(),
            (16.0*np.sin(idx*0.017)).astype(np.float32),
            (12.0*np.cos(idx*0.031)).astype(np.float32),
            (((idx%257.0)/256.0)*32.0-16.0).astype(np.float32),
            np.where((idx.astype(np.int64)&1)==0,-16.0,16.0).astype(np.float32),
            np.where((idx.astype(np.int64)%3)==0,-8.0,4.0).astype(np.float32),
        ]
        self.t=t; self.i=0
    def get_next(self):
        if self.i>=len(self.rows): return None
        x=self.rows[self.i].reshape(1,self.t,PREACT); self.i+=1
        return {'preact':x}
    def rewind(self): self.i=0


def qnn_quantize(src,dst,t):
    src=pathlib.Path(src); dst=pathlib.Path(dst)
    with tempfile.TemporaryDirectory() as td:
        td=pathlib.Path(td); pre=td/(src.stem+'.pre.onnx')
        changed=qnn_preprocess_model(str(src),str(pre))
        model=str(pre if changed else src)
        reader=SyntheticReader(t)
        kwargs={
            'activation_type':QuantType.QUInt16,
            'weight_type':QuantType.QUInt8,
        }
        sig=inspect.signature(get_qnn_qdq_config)
        if 'calibrate_method' in sig.parameters: kwargs['calibrate_method']=CalibrationMethod.MinMax
        if 'keep_removable_activations' in sig.parameters: kwargs['keep_removable_activations']=True
        cfg=get_qnn_qdq_config(model,reader,**kwargs)
        quantize(model,str(dst),cfg)
    onnx.checker.check_model(onnx.load(dst))


def run(path,x,t):
    s=ort.InferenceSession(str(path),providers=['CPUExecutionProvider'])
    y=s.run(['activation'],{'preact':x.reshape(1,t,PREACT)})[0]
    return np.asarray(y,dtype=np.float32).reshape(-1)


def load_f32(p,count):
    x=np.fromfile(p,dtype='<f4')
    if x.size!=count: raise RuntimeError(f'geometry mismatch {p}: {x.size} != {count}')
    return x.astype(np.float32,copy=False)


def metric(ref,cand):
    a=ref.astype(np.float64); c=cand.astype(np.float64); d=c-a
    na=float(np.linalg.norm(a)); nc=float(np.linalg.norm(c)); cos=1.0 if na==0 and nc==0 else (0.0 if na==0 or nc==0 else float(np.dot(a,c)/(na*nc)))
    return {'max_abs':float(np.max(np.abs(d))),'mean_abs':float(np.mean(np.abs(d))),'rmse':float(np.sqrt(np.mean(d*d))),'cosine':cos}


def gate(m):
    return m['max_abs']<=FINAL_GATE['max_abs'] and m['mean_abs']<=FINAL_GATE['mean_abs'] and m['rmse']<=FINAL_GATE['rmse'] and m['cosine']>=FINAL_GATE['cosine']


def make_micro(path,t,kind):
    x=helper.make_tensor_value_info('preact',TensorProto.FLOAT,[1,t,PREACT]); y=helper.make_tensor_value_info('activation',TensorProto.FLOAT,[1,t,PREACT])
    nodes=[]; inits=[]
    if kind=='relu': nodes=[helper.make_node('Relu',['preact'],['activation'],name='relu')]
    elif kind=='mul':
        inits=[helper.make_tensor('k',TensorProto.FLOAT,[],[0.75])]; nodes=[helper.make_node('Mul',['preact','k'],['activation'],name='mul')]
    elif kind=='add':
        inits=[helper.make_tensor('k',TensorProto.FLOAT,[],[0.125])]; nodes=[helper.make_node('Add',['preact','k'],['activation'],name='add')]
    elif kind=='clip':
        inits=[helper.make_tensor('lo',TensorProto.FLOAT,[],[-6.0]),helper.make_tensor('hi',TensorProto.FLOAT,[],[6.0])]; nodes=[helper.make_node('Clip',['preact','lo','hi'],['activation'],name='clip')]
    elif kind=='gelu': nodes=[helper.make_node('Gelu',['preact'],['activation'],name='gelu',domain='com.microsoft')]
    else: raise ValueError(kind)
    m=helper.make_model(helper.make_graph(nodes,'rev46_v4_'+kind,[x],[y],initializer=inits),producer_name='qairt-sdk-archive/rev46-q16-v4',opset_imports=[helper.make_opsetid('',21),helper.make_opsetid('com.microsoft',1)])
    m.ir_version=9; onnx.checker.check_model(m); onnx.save(m,path)


def main():
    ap=argparse.ArgumentParser(); ap.add_argument('--v3-dir',required=True); ap.add_argument('--payload-root',required=True); ap.add_argument('--out-dir',required=True); a=ap.parse_args()
    v3=pathlib.Path(a.v3_dir).resolve(); root=pathlib.Path(a.payload_root).resolve(); out=pathlib.Path(a.out_dir).resolve(); out.mkdir(parents=True,exist_ok=True)
    report={'schema':1,'status':'DEVICE_DIAGNOSTIC_READY','ort_cpu_version':ort.__version__,'calibration_policy':CALIBRATION_POLICY,'calibration_range':CALIBRATION_RANGE,'final_gate':FINAL_GATE,'variants':[],'micro_ladder':[],'qualification':{'all_fixed_shape':True,'all_qdq_present':True,'frozen_numeric_gate_all':True}}
    for shape,t in SHAPES.items():
        for model in ('baseline','candidate'):
            src=v3/f'{shape}_{"baseline_contrib_gelu" if model=="baseline" else "candidate_exact_activation"}.onnx'
            dst=out/f'{shape}_{model}_q16_qdq.onnx'; qnn_quantize(src,dst,t)
            ops=op_inventory(dst); dyn=dynamic_dims(dst)
            qdq=('ai.onnx:QuantizeLinear' in ops or 'com.microsoft:QuantizeLinear' in ops) and ('ai.onnx:DequantizeLinear' in ops or 'com.microsoft:DequantizeLinear' in ops)
            report['qualification']['all_fixed_shape'] &= not dyn; report['qualification']['all_qdq_present'] &= qdq
            vr={'shape':shape,'t':t,'model':model,'source_sha256':sha256(src),'qdq_model':dst.name,'qdq_sha256':sha256(dst),'qdq_bytes':dst.stat().st_size,'ops':ops,'dynamic_dims':dyn,'fixtures':[]}
            for fid in FIXTURES[shape]:
                x=load_f32(root/'fixtures'/f'preact_{fid}.f32',t*PREACT); ref=load_f32(root/'oracle'/f'{model}_{fid}_activation.f32',t*PREACT); y=run(dst,x,t); mm=metric(ref,y); gp=gate(mm); report['qualification']['frozen_numeric_gate_all'] &= gp; vr['fixtures'].append({'id':fid,'metric_vs_frozen_oracle':mm,'final_gate_pass':gp})
            report['variants'].append(vr)
    # Fixed T=4 operator capability ladder. Synthetic-only; never used as frozen final qualification.
    for kind in ('relu','mul','add','clip','gelu'):
        f=out/f'cold4_micro_{kind}_float.onnx'; q=out/f'cold4_micro_{kind}_q16_qdq.onnx'; make_micro(f,4,kind); qnn_quantize(f,q,4); f.unlink()
        ops=op_inventory(q); dyn=dynamic_dims(q); qdq=('ai.onnx:QuantizeLinear' in ops or 'com.microsoft:QuantizeLinear' in ops) and ('ai.onnx:DequantizeLinear' in ops or 'com.microsoft:DequantizeLinear' in ops)
        report['qualification']['all_fixed_shape'] &= not dyn; report['qualification']['all_qdq_present'] &= qdq
        report['micro_ladder'].append({'kind':kind,'model':q.name,'sha256':sha256(q),'bytes':q.stat().st_size,'ops':ops,'dynamic_dims':dyn})
    if not report['qualification']['all_fixed_shape'] or not report['qualification']['all_qdq_present']:
        report['status']='FAIL_STRUCTURE'
    elif report['qualification']['frozen_numeric_gate_all']:
        report['status']='PASS_HOST_NUMERIC_AND_STRUCTURE'
    else:
        report['status']='PASS_STRUCTURE_NUMERIC_GATE_NOT_MET_DIAGNOSTIC_ONLY'
    (out/'Q16_V4_MANIFEST.json').write_text(json.dumps(report,indent=2,sort_keys=True)+'\n')
    print('REV46_Q16_V4_PREP_'+report['status']); print(json.dumps(report['qualification'],sort_keys=True));
    if report['status']=='FAIL_STRUCTURE': raise SystemExit(2)

if __name__=='__main__': main()
