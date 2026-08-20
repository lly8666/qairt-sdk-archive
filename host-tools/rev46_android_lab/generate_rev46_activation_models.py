#!/usr/bin/env python3
import argparse, pathlib
import numpy as np
import onnx
from onnx import TensorProto, helper, numpy_helper
COEFF=[1.8827368,1.3228317,-0.29206133,0.13110782,-0.06831662,0.03584625,-0.01799377,0.00847207,-0.00371532,0.00151535,-0.00057546,0.00020392,-6.761671e-05,2.1039408e-05,-6.1609157e-06,1.7025046e-06,-4.451437e-07]
def scalar(name,v): return numpy_helper.from_array(np.array(v,dtype=np.float32),name)
def model(variant,T):
    x=helper.make_tensor_value_info('x',TensorProto.FLOAT,[1,T,1536]); y=helper.make_tensor_value_info('y',TensorProto.FLOAT,[1,T,1536])
    n=[]; init=[]
    def S(name,v): init.append(scalar(name,v)); return name
    if variant=='identity': n=[helper.make_node('Identity',['x'],['y'],name='IdentityControl')]
    elif variant=='erf_only':
        rt=S('sqrt2',np.sqrt(2.0)); n=[helper.make_node('Div',['x',rt],['z'],name='DivSqrt2'),helper.make_node('Erf',['z'],['y'],name='ErfOnly')]
    elif variant in ('canonical_gelu','split_exact_gelu'):
        rt=S('sqrt2',np.sqrt(2.0)); half=S('half',0.5); one=S('one',1.0)
        n.append(helper.make_node('Div',['x',rt],['z'],name='DivSqrt2')); n.append(helper.make_node('Erf',['z'],['e'],name='Erf'))
        if variant=='canonical_gelu':
            n += [helper.make_node('Add',['e',one],['p'],name='AddOne'),helper.make_node('Mul',['x','p'],['m'],name='MulX'),helper.make_node('Mul',['m',half],['y'],name='MulHalf')]
        else:
            n += [helper.make_node('Mul',['x',half],['xh'],name='XHalf'),helper.make_node('Mul',['xh','e'],['xe'],name='XHalfErf'),helper.make_node('Add',['xh','xe'],['y'],name='SplitExactAdd')]
    elif variant=='ch60d16_pairwise':
        neg1=S('negone',-1.0); two=S('two',2.0); half=S('half',0.5); inv=S('invclip',1/6); mn=S('min',-6.0); mx=S('max',6.0); negclip=S('negclip',-6.0)
        cs=[S(f'c{i}',v) for i,v in enumerate(COEFF)]
        n += [helper.make_node('Clip',['x',mn,mx],['xc'],name='Clip6'),helper.make_node('Mul',['xc',inv],['scaled'],name='Scale'),helper.make_node('Mul',['scaled','scaled'],['u'],name='U'),helper.make_node('Mul',['u',two],['two_u'],name='TwoU'),helper.make_node('Add',['two_u',neg1],['t'],name='T'),helper.make_node('Mul',['t',two],['two_t'],name='TwoT'),helper.make_node('Mul',[neg1,neg1],['T0'],name='T0')]
        prev2='T0'; prev1='t'; terms=[]
        for k in range(2,17):
            mul=f'T{k}mul'; neg=f'T{k}neg'; tk=f'T{k}'
            n += [helper.make_node('Mul',['two_t',prev1],[mul],name=f'T{k}Mul'),helper.make_node('Mul',[prev2,neg1],[neg],name=f'T{k}Neg'),helper.make_node('Add',[mul,neg],[tk],name=f'T{k}')]
            prev2,prev1=prev1,tk
        terms.append(('t',cs[1]))
        for k in range(2,17): terms.append((f'T{k}',cs[k]))
        termnames=[]
        for k,(src,c) in enumerate(terms,1):
            tn=f'term{k}'; n.append(helper.make_node('Mul',[src,c],[tn],name=f'Term{k}')); termnames.append(tn)
        cur=[cs[0]]+termnames; level=0
        while len(cur)>1:
            nxt=[]
            for i in range(0,len(cur)-1,2):
                out=f'psum{level}_{i//2}'; n.append(helper.make_node('Add',[cur[i],cur[i+1]],[out],name=f'PSum{level}_{i//2}')); nxt.append(out)
            if len(cur)%2: nxt.append(cur[-1])
            cur=nxt; level+=1
        n += [helper.make_node('Mul',['xc',half],['xhalf'],name='XHalf'),helper.make_node('Add',['xhalf',cur[0]],['base'],name='Base'),helper.make_node('Add',['x',negclip],['tailarg'],name='TailArg'),helper.make_node('Relu',['tailarg'],['tail'],name='TailRelu'),helper.make_node('Add',['base','tail'],['y'],name='GeluOut')]
    else: raise ValueError(variant)
    g=helper.make_graph(n,f'rev46_{variant}_T{T}',[x],[y],initializer=init)
    m=helper.make_model(g,opset_imports=[helper.make_operatorsetid('',17)],producer_name='qairt-sdk-archive-rev46-lab')
    m.ir_version=9
    m.doc_string='Focused public MeanVC2 rev46 activation-lowering diagnostic. Not a production model.'
    onnx.checker.check_model(m); return m

def main():
    ap=argparse.ArgumentParser(); ap.add_argument('--out',required=True); a=ap.parse_args(); out=pathlib.Path(a.out); out.mkdir(parents=True,exist_ok=True)
    for T in (4,6):
        for v in ('canonical_gelu','split_exact_gelu','ch60d16_pairwise','erf_only','identity'):
            p=out/f'{v}_t{T}.onnx'; onnx.save(model(v,T),p); print(p)
if __name__=='__main__': main()
