#!/usr/bin/env python3
import hashlib, json, math, pathlib
import numpy as np
import onnx
from onnx import TensorProto, helper, numpy_helper

ROOT=pathlib.Path(__file__).resolve().parents[1]
OUT=ROOT/'app'/'src'/'main'/'assets'/'micro'/'models'
SHAPES={'cold4':[1,4,1536],'warm6':[1,6,1536]}
OPSET=20

def scalar(name,value): return numpy_helper.from_array(np.asarray(value,dtype=np.float32),name=name)

def make(kind,shape):
    x=helper.make_tensor_value_info('x',TensorProto.FLOAT,shape); y=helper.make_tensor_value_info('y',TensorProto.FLOAT,shape)
    nodes=[]; init=[]
    if kind=='gelu_op':
        nodes=[helper.make_node('Gelu',['x'],['y'],name='gelu_exact')]
    elif kind=='canonical_erf':
        init=[scalar('sqrt2',math.sqrt(2.0)),scalar('one',1.0),scalar('half',0.5)]
        nodes=[helper.make_node('Div',['x','sqrt2'],['a']),helper.make_node('Erf',['a'],['b']),helper.make_node('Add',['b','one'],['c']),helper.make_node('Mul',['x','c'],['d']),helper.make_node('Mul',['d','half'],['y'])]
    elif kind=='decanonicalized_erf':
        init=[scalar('inv_sqrt2',1.0/math.sqrt(2.0)),scalar('one',1.0),scalar('half',0.5)]
        nodes=[helper.make_node('Mul',['x','inv_sqrt2'],['a']),helper.make_node('Erf',['a'],['b']),helper.make_node('Add',['one','b'],['c']),helper.make_node('Mul',['x','half'],['d']),helper.make_node('Mul',['d','c'],['y'])]
    else: raise ValueError(kind)
    g=helper.make_graph(nodes,'rev46_micro_'+kind,[x],[y],initializer=init)
    m=helper.make_model(g,producer_name='qairt-sdk-archive/rev46-focused-batch',opset_imports=[helper.make_opsetid('',OPSET)])
    m.ir_version=9; onnx.checker.check_model(m); return m

def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()

def main():
    OUT.mkdir(parents=True,exist_ok=True); models=[]
    for sn,shape in SHAPES.items():
        for kind in ('gelu_op','canonical_erf','decanonicalized_erf'):
            p=OUT/f'{sn}_{kind}.onnx'; onnx.save(make(kind,shape),p)
            models.append({'name':p.name,'shape_name':sn,'shape':shape,'kind':kind,'bytes':p.stat().st_size,'sha256':sha(p)})
    manifest={'schema':1,'role':'micro lowering isolation; not full-model gate','opset':OPSET,'models':models}
    mp=OUT.parent/'MODEL_MANIFEST.json'; mp.write_text(json.dumps(manifest,indent=2,sort_keys=True)+'\n')
    print('REV46_FOCUSED_APK_MICRO_MATRIX_PASS'); print(mp.read_text())
if __name__=='__main__': main()
