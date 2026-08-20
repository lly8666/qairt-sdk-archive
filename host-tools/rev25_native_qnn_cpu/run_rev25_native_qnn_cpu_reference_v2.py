#!/usr/bin/env python3
"""Rev25 native QNN CPU reference v2.

Corrects two host-contract details in v1 without changing model math/backend/thresholds:
1. QAIRT converter must preserve ONNX app I/O layout. Default conversion exposes
   [1,T,80] / [1,T,321], while the frozen Android/ORT contract is
   [1,80,T] / [1,321,T].
2. The durable foundation's frozen C++ runtime directory is included in
   LD_LIBRARY_PATH.

All evidence/metrics/gates remain implemented by the v1 authority module.
"""
import os
import pathlib

import run_rev25_native_qnn_cpu_reference as base


def tool_env(foundation):
    root=pathlib.Path(foundation).resolve()
    qairt=root/'qairt'
    py=root/'python'/'bin'/'python3.10'
    site=root/'site-packages'
    qbin=qairt/'bin'/'x86_64-linux-clang'
    qlib=qairt/'lib'/'x86_64-linux-clang'
    required=[
        py,
        qbin/'qnn-onnx-converter',
        qbin/'qnn-model-lib-generator',
        qbin/'qnn-net-run',
        qlib/'libQnnCpu.so',
        root/'cxx'/'libc++.so.1',
        root/'cxx'/'libc++abi.so.1',
        root/'cxx'/'libunwind.so.1',
    ]
    for p in required:
        if not p.exists():
            raise RuntimeError(f'foundation missing {p}')
    env=os.environ.copy()
    env['QNN_SDK_ROOT']=str(qairt)
    env['PYTHONPATH']=os.pathsep.join([
        str(site), str(qairt/'lib'/'python'), env.get('PYTHONPATH','')
    ]).rstrip(os.pathsep)
    env['LD_LIBRARY_PATH']=os.pathsep.join([
        str(root/'cxx'), str(root/'python'/'lib'), str(qairt/'bin'/'lib'),
        str(qlib), env.get('LD_LIBRARY_PATH','')
    ]).rstrip(os.pathsep)
    env['PATH']=os.pathsep.join([str(qbin),env.get('PATH','')])
    return root,qairt,py,qbin,qlib,env


def compile_model(name,onnx_path,work,py,qbin,env):
    d=work/'compiled'/name
    d.mkdir(parents=True,exist_ok=True)
    cpp=d/f'{name}.cpp'
    convert_ms=base.run([
        py, qbin/'qnn-onnx-converter',
        '--input_network', pathlib.Path(onnx_path).resolve(),
        '--output_path', cpp,
        '--preserve_io', 'layout',
    ],work/'logs'/f'{name}.converter.log',env=env)
    if not cpp.is_file():
        raise RuntimeError(f'converter did not create {cpp}')

    # Guard the physical app I/O contract so a future converter default cannot
    # silently reintroduce the channel-last transport bug.
    txt=cpp.read_text(errors='replace')
    frames='4' if 'cold4' in name else '6'
    expected_in=f'uint32_t dimensions_features[] = {{1, 80, {frames}}};'
    expected_re=f'uint32_t dimensions_spec_real[] = {{1, 321, {frames}}};'
    expected_im=f'uint32_t dimensions_spec_imag[] = {{1, 321, {frames}}};'
    for marker in (expected_in,expected_re,expected_im):
        if marker not in txt:
            raise RuntimeError(f'QAIRT preserved-I/O contract drift: missing {marker}')

    args=[qbin/'qnn-model-lib-generator','-c',cpp,'-o',d/'model-lib','-t','x86_64-linux-clang']
    binp=d/f'{name}.bin'
    if binp.is_file():
        args += ['-b',binp]
    try:
        model_ms=base.run(args,work/'logs'/f'{name}.model-lib.log',env=env)
    except RuntimeError:
        model_ms=base.run([py]+args,work/'logs'/f'{name}.model-lib-python.log',env=env)
    libs=list((d/'model-lib').rglob('*.so'))
    if len(libs)!=1:
        raise RuntimeError(f'expected exactly one generated model .so for {name}, found {libs}')
    return libs[0],{
        'converter_ms':convert_ms,
        'model_lib_ms':model_ms,
        'model_so':str(libs[0].resolve()),
        'model_so_sha256':base.sha_file(libs[0]),
        'converter_preserve_io_layout':True,
        'app_io_contract':{
            'features':[1,80,int(frames)],
            'spec_real':[1,321,int(frames)],
            'spec_imag':[1,321,int(frames)],
        },
    }


base.tool_env=tool_env
base.compile_model=compile_model

if __name__=='__main__':
    base.main()
