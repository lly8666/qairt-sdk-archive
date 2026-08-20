#!/usr/bin/env python3
"""Emit a stable structural/QNN-ownership-risk report for one or more ONNX models.

This is intentionally not a numerical validator. It captures graph-contract changes that can
alter ORT-QNN GetCapability, fusion and partitioning even when CPU semantics are unchanged.
"""
from __future__ import annotations
import argparse, collections, hashlib, json, pathlib
import onnx
from onnx import TensorProto

DTYPE = {v:k for k,v in TensorProto.DataType.items()}
QOPS = {"QuantizeLinear", "DequantizeLinear"}


def sha256(path: pathlib.Path) -> str:
    h=hashlib.sha256()
    with path.open('rb') as f:
        for b in iter(lambda:f.read(1<<20), b''): h.update(b)
    return h.hexdigest()


def dims(value_info):
    t=value_info.type.tensor_type
    out=[]
    for d in t.shape.dim:
        if d.HasField('dim_value'): out.append(int(d.dim_value))
        elif d.HasField('dim_param') and d.dim_param: out.append({'symbol':d.dim_param})
        else: out.append(None)
    return out


def value_sig(v):
    t=v.type.tensor_type
    return {'name':v.name,'dtype':DTYPE.get(t.elem_type,str(t.elem_type)),'shape':dims(v)}


def initializer_sig(t):
    ds=list(t.dims)
    return {
        'name':t.name,
        'dtype':DTYPE.get(t.data_type,str(t.data_type)),
        'shape':ds,
        'elements':int(__import__('math').prod(ds)) if ds else 1,
        'scalar':len(ds)==0 or __import__('math').prod(ds)==1,
    }


def audit(path: pathlib.Path):
    m=onnx.load(str(path), load_external_data=False)
    onnx.checker.check_model(m)
    ops=collections.Counter()
    domains=collections.Counter()
    qdq=0
    for n in m.graph.node:
        domain=n.domain or 'ai.onnx'
        key=f'{domain}::{n.op_type}'
        ops[key]+=1; domains[domain]+=1
        if n.op_type in QOPS: qdq+=1
    inits=[initializer_sig(t) for t in m.graph.initializer]
    io=list(m.graph.input)+list(m.graph.output)
    dynamic=[]
    for v in io:
        sig=value_sig(v)
        if any(not isinstance(x,int) for x in sig['shape']): dynamic.append(sig['name'])
    graph_inputs={v.name for v in m.graph.input}
    init_names={t.name for t in m.graph.initializer}
    runtime_inputs=sorted(graph_inputs-init_names)
    scalar_inits=sorted(x['name'] for x in inits if x['scalar'])
    qdq_nodes=[]
    for i,n in enumerate(m.graph.node):
        if n.op_type in QOPS:
            qdq_nodes.append({'index':i,'op':n.op_type,'domain':n.domain or 'ai.onnx','inputs':list(n.input),'outputs':list(n.output)})
    return {
        'path':str(path),
        'bytes':path.stat().st_size,
        'sha256':sha256(path),
        'ir_version':m.ir_version,
        'producer_name':m.producer_name,
        'producer_version':m.producer_version,
        'opsets':[{'domain':x.domain or 'ai.onnx','version':x.version} for x in m.opset_import],
        'functions':[{'domain':f.domain or 'ai.onnx','name':f.name,'overload':getattr(f,'overload','')} for f in m.functions],
        'inputs':[value_sig(v) for v in m.graph.input],
        'outputs':[value_sig(v) for v in m.graph.output],
        'runtime_inputs':runtime_inputs,
        'dynamic_io_names':sorted(dynamic),
        'node_count':len(m.graph.node),
        'op_counts':dict(sorted(ops.items())),
        'domain_counts':dict(sorted(domains.items())),
        'initializer_count':len(inits),
        'scalar_initializer_names':scalar_inits,
        'qdq_node_count':qdq,
        'qdq_nodes':qdq_nodes,
        'graph_contract_flags':{
            'has_dynamic_io':bool(dynamic),
            'has_qdq':qdq>0,
            'has_scalar_initializer':bool(scalar_inits),
            'multiple_runtime_inputs':len(runtime_inputs)>1,
            'custom_domains':sorted(d for d in domains if d!='ai.onnx'),
        },
    }


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('models', nargs='+', type=pathlib.Path)
    ap.add_argument('--output', type=pathlib.Path)
    args=ap.parse_args()
    reports=[audit(p) for p in args.models]
    out={'schema':1,'purpose':'QNN_GETCAPABILITY_FUSION_PARTITION_GRAPH_CONTRACT_AUDIT','models':reports}
    text=json.dumps(out,indent=2,sort_keys=True)+'\n'
    if args.output: args.output.write_text(text)
    else: print(text,end='')

if __name__=='__main__': main()
