#!/usr/bin/env python3
import argparse, hashlib, json, math, pathlib, tempfile
from collections import Counter

import numpy as np
import onnx
import onnxruntime as ort
from onnxruntime.quantization import CalibrationDataReader, CalibrationMethod, QuantType, quantize
from onnxruntime.quantization.execution_providers.qnn import get_qnn_qdq_config, qnn_preprocess_model

PREACT=1536
SHAPES={"cold4":4,"warm6":6}
FROZEN={"cold4":["cold0"],"warm6":["warm1","warm18","warm47"]}
FINAL_GATE={"max_abs":3e-4,"mean_abs":1e-5,"rmse":2e-5,"cosine":0.99999}


def sha256(p):
    h=hashlib.sha256()
    with open(p,'rb') as f:
        for b in iter(lambda:f.read(1<<20),b''): h.update(b)
    return h.hexdigest()


def inventory(path):
    m=onnx.load(path)
    return dict(sorted(Counter((n.domain or 'ai.onnx')+':'+n.op_type for n in m.graph.node).items()))


def load_f32(path,count):
    x=np.fromfile(path,dtype='<f4')
    if x.size!=count: raise RuntimeError(f'geometry mismatch {path}: {x.size} != {count}')
    return x.astype(np.float32,copy=False)


def metric(ref,cand):
    a=ref.astype(np.float64).reshape(-1); b=cand.astype(np.float64).reshape(-1); d=b-a
    na=float(np.linalg.norm(a)); nb=float(np.linalg.norm(b))
    cos=1.0 if na==0.0 and nb==0.0 else (0.0 if na==0.0 or nb==0.0 else float(np.dot(a,b)/(na*nb)))
    return {"max_abs":float(np.max(np.abs(d))),"mean_abs":float(np.mean(np.abs(d))),"rmse":float(np.sqrt(np.mean(d*d))),"cosine":cos}


def passes(m):
    return m['max_abs']<=FINAL_GATE['max_abs'] and m['mean_abs']<=FINAL_GATE['mean_abs'] and m['rmse']<=FINAL_GATE['rmse'] and m['cosine']>=FINAL_GATE['cosine']


def synthetic_calibration(t):
    n=t*PREACT
    critical=np.array([-12,-8,-6,-4,-3,-2,-1.5,-1,-0.75,-0.5,-0.25,-0.1,-0.01,0,0.01,0.1,0.25,0.5,0.75,1,1.5,2,3,4,6,8,12],dtype=np.float32)
    a=np.resize(critical,n).reshape(1,t,PREACT)
    b=np.linspace(-12.0,12.0,n,dtype=np.float32).reshape(1,t,PREACT)
    z=np.arange(n,dtype=np.float64)
    c=(5.0*np.sin(z*0.017)+3.0*np.cos(z*0.031)+1.5*np.sin(z*0.071)).astype(np.float32).reshape(1,t,PREACT)
    state=np.uint32(0x6D2B79F5 ^ (t<<16)); r=np.empty(n,dtype=np.float32)
    for i in range(n):
        state=np.uint32((np.uint64(state)*1664525+1013904223)&0xffffffff)
        r[i]=(float(state)/4294967295.0*24.0-12.0)
    d=r.reshape(1,t,PREACT)
    e=np.resize(np.array([-12.0,12.0,-6.0,6.0,-2.0,2.0,-0.5,0.5,0.0],dtype=np.float32),n).reshape(1,t,PREACT)
    f=(0.35*np.sin(z*0.113)+0.15*np.cos(z*0.049)).astype(np.float32).reshape(1,t,PREACT)
    return [a,b,c,d,e,f]


def synthetic_holdout(t):
    n=t*PREACT; z=np.arange(n,dtype=np.float64)
    a=(7.0*np.sin(z*0.023+0.7)+2.0*np.cos(z*0.041+0.2)).astype(np.float32).reshape(1,t,PREACT)
    state=np.uint32(0xA5A5C3D7 ^ (t<<8)); r=np.empty(n,dtype=np.float32)
    for i in range(n):
        state=np.uint32((np.uint64(state)*1103515245+12345)&0xffffffff)
        r[i]=(float(state)/4294967295.0*20.0-10.0)
    b=r.reshape(1,t,PREACT)
    c=np.linspace(-9.5,9.5,n,dtype=np.float32).reshape(1,t,PREACT)
    return [("holdout_wave",a),("holdout_lcg",b),("holdout_sweep",c)]


class Reader(CalibrationDataReader):
    def __init__(self,samples): self.samples=samples; self.i=0
    def get_next(self):
        if self.i>=len(self.samples): return None
        x=self.samples[self.i]; self.i+=1; return {"preact":x}
    def rewind(self): self.i=0


def run(path,x):
    s=ort.InferenceSession(str(path),providers=['CPUExecutionProvider'])
    return np.asarray(s.run(['activation'],{'preact':x})[0],dtype=np.float32)


def quantize_one(src,dst,t,tmp):
    pre=tmp/(src.stem+'.pre.onnx')
    changed=qnn_preprocess_model(str(src),str(pre))
    model_to_quantize=pre if changed else src
    reader=Reader(synthetic_calibration(t))
    cfg=get_qnn_qdq_config(
        str(model_to_quantize),reader,
        calibrate_method=CalibrationMethod.MinMax,
        activation_type=QuantType.QUInt16,
        weight_type=QuantType.QUInt8,
        activation_symmetric=False,
        weight_symmetric=True,
        per_channel=False,
        keep_removable_activations=True,
    )
    quantize(str(model_to_quantize),str(dst),cfg)
    onnx.checker.check_model(onnx.load(dst))


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--float-root',required=True)
    ap.add_argument('--payload-root',required=True)
    ap.add_argument('--out-dir',required=True)
    a=ap.parse_args()
    fr=pathlib.Path(a.float_root).resolve(); pr=pathlib.Path(a.payload_root).resolve(); out=pathlib.Path(a.out_dir).resolve(); out.mkdir(parents=True,exist_ok=True)
    report={
      'schema':1,
      'status':'RUNNING',
      'role':'single prescribed QDQ-v4 qualification; synthetic-only calibration; frozen fixtures validation-only; no fitting/search; no threshold relaxation',
      'ort_version':ort.__version__,
      'quantization':{'format':'QDQ','activation_type':'QUInt16','weight_type':'QUInt8','calibration':'deterministic synthetic only','calibration_range_design':'fixed [-12,12] plus critical/wave/small-signal coverage','search_or_sweep':False},
      'final_gate':FINAL_GATE,
      'variants':[],
      'all_frozen_pass':True,
      'all_holdout_pass':True,
    }
    with tempfile.TemporaryDirectory() as td:
      td=pathlib.Path(td)
      for shape,t in SHAPES.items():
        for model in ('baseline','candidate'):
          src=fr/f'{shape}_{"baseline_contrib_gelu" if model=="baseline" else "candidate_exact_activation"}.onnx'
          dst=out/f'{shape}_{model}_qdq_u16.onnx'
          quantize_one(src,dst,t,td)
          v={'shape':shape,'t':t,'model':model,'float_sha256':sha256(src),'qdq_sha256':sha256(dst),'qdq_bytes':dst.stat().st_size,'float_ops':inventory(src),'qdq_ops':inventory(dst),'holdout':[],'frozen':[]}
          for hid,x in synthetic_holdout(t):
            ref=run(src,x); cand=run(dst,x); m=metric(ref,cand); ok=passes(m); report['all_holdout_pass'] &= ok; v['holdout'].append({'id':hid,'metric':m,'gate_pass':ok})
          for fid in FROZEN[shape]:
            x=load_f32(pr/'fixtures'/f'preact_{fid}.f32',t*PREACT).reshape(1,t,PREACT)
            oracle=load_f32(pr/'oracle'/f'{model}_{fid}_activation.f32',t*PREACT).reshape(1,t,PREACT)
            cand=run(dst,x); m=metric(oracle,cand); ok=passes(m); report['all_frozen_pass'] &= ok; v['frozen'].append({'id':fid,'metric':m,'gate_pass':ok})
          report['variants'].append(v)
    report['status']='PASS' if report['all_frozen_pass'] and report['all_holdout_pass'] else 'REVIEW'
    mp=out/'QDQ_V4_MANIFEST.json'; mp.write_text(json.dumps(report,indent=2,sort_keys=True)+'\n')
    print('REV46_QDQ_V4_HOST_QUALIFICATION_'+report['status'])
    print(mp.read_text())
    if report['status']!='PASS': raise SystemExit(2)

if __name__=='__main__': main()
