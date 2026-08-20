#!/usr/bin/env python3
"""Create the rev46 block4 decanonicalized diagnostic model.

Only ConvNeXt block4 activation is replaced by a deep copy of the mathematically
 equivalent block5-style activation expression. PW1/PW2 and all other graph
 content remain unchanged. Exact output SHA must be supplied for serious runs.
"""
import argparse
import copy
import hashlib
import pathlib
import onnx


def sha_file(path):
    h=hashlib.sha256()
    with open(path,'rb') as f:
        for b in iter(lambda:f.read(1<<20),b''):
            h.update(b)
    return h.hexdigest()


def find_pw1_add(nodes,block):
    key=f'backbone.convnext.{block}.pwconv1.bias'
    return next(i for i,n in enumerate(nodes) if n.op_type=='Add' and key in n.input)


def find_pw2_matmul(nodes,block):
    a=find_pw1_add(nodes,block)
    return next(i for i,n in enumerate(nodes[a+1:],a+1) if n.op_type=='MatMul')


def patch(src,dst):
    model=onnx.load(src)
    nodes=list(model.graph.node)
    b4add=find_pw1_add(nodes,4); b4pw2=find_pw2_matmul(nodes,4)
    b5add=find_pw1_add(nodes,5); b5pw2=find_pw2_matmul(nodes,5)
    s=b4add+1; e=b4pw2-1; ps=b5add+1; pe=b5pw2-1
    b4_in=nodes[b4add].output[0]; b4_out=nodes[e].output[0]
    b5_in=nodes[b5add].output[0]; b5_out=nodes[pe].output[0]
    clones=[]; outmap={}
    for n in nodes[ps:pe+1]:
        c=copy.deepcopy(n)
        outs=[]
        for o in c.output:
            no=b4_out if o==b5_out else o.replace('r24_b5_','r24_diag_b4_')
            outmap[o]=no; outs.append(no)
        del c.output[:]; c.output.extend(outs)
        c.name=c.name.replace('R24_B5','R24_DIAG_B4')
        clones.append(c)
    for c in clones:
        ins=[]
        for x in c.input:
            if x==b5_in: x=b4_in
            ins.append(outmap.get(x,x))
        del c.input[:]; c.input.extend(ins)
    newnodes=nodes[:s]+clones+nodes[e+1:]
    del model.graph.node[:]; model.graph.node.extend(newnodes)
    onnx.checker.check_model(model)
    pathlib.Path(dst).parent.mkdir(parents=True,exist_ok=True)
    onnx.save(model,dst)
    return {
        'input_nodes':len(nodes),'output_nodes':len(newnodes),
        'block4_activation_old_range':[s,e],
        'block5_activation_clone_range':[ps,pe],
        'sha256':sha_file(dst),
    }


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--input',required=True)
    ap.add_argument('--output',required=True)
    ap.add_argument('--expected-sha256')
    args=ap.parse_args()
    info=patch(args.input,args.output)
    if args.expected_sha256 and info['sha256']!=args.expected_sha256:
        raise SystemExit(f"diagnostic identity mismatch {info['sha256']} != {args.expected_sha256}")
    print('BLOCK4_DECANONICALIZED_PASS',info)


if __name__=='__main__':
    main()
