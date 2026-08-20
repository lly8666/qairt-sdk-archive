#!/usr/bin/env python3
import argparse, ctypes, hashlib, json, math, os, pathlib, shutil, subprocess, sys, time
import numpy as np

COLD_BYTES=33249679
COLD_SHA='323c194e5da29f0be962ea8b72ca2fa2d1a9fc2481d80b95e5590f79e9485f65'
WARM_BYTES=33243869
WARM_SHA='e2b7ab608a6b37a6dd9896589719cab446edf95287f59dfc7b5693da6ec98f6c'
RAW_BYTES=61440
RAW_SHA='dc58af153c7c0dd6ab0a450a5f77648203e7f82a800a17837e09095ce48c9963'
CHANNELS=80
BINS=321
BLOCKS=48
OVERLAP=160


def sha_file(path):
    h=hashlib.sha256()
    with open(path,'rb') as f:
        for b in iter(lambda:f.read(1<<20),b''): h.update(b)
    return h.hexdigest()


def sha_f32(x):
    a=np.asarray(x,dtype='<f4').reshape(-1)
    return hashlib.sha256(a.tobytes(order='C')).hexdigest()


def verify(path,n,sha):
    p=pathlib.Path(path)
    got_n=p.stat().st_size; got_sha=sha_file(p)
    if got_n!=n or got_sha!=sha:
        raise RuntimeError(f'identity drift {p}: bytes={got_n} sha256={got_sha}, expected={n}/{sha}')
    return {'path':str(p.resolve()),'bytes':got_n,'sha256':got_sha}


def run(cmd,log,env=None,cwd=None):
    log=pathlib.Path(log); log.parent.mkdir(parents=True,exist_ok=True)
    t=time.perf_counter()
    with log.open('w',encoding='utf-8') as f:
        f.write('COMMAND='+json.dumps([str(x) for x in cmd])+'\n')
        f.flush()
        p=subprocess.Popen([str(x) for x in cmd],cwd=cwd,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True,encoding='utf-8',errors='replace')
        for line in p.stdout:
            sys.stdout.write(line); f.write(line)
        rc=p.wait()
        elapsed=(time.perf_counter()-t)*1000.0
        f.write(f'RETURN_CODE={rc}\nELAPSED_MS={elapsed:.6f}\n')
    if rc: raise RuntimeError(f'command failed rc={rc}: {cmd}; log={log}')
    return elapsed


def build_segments(raw):
    raw=np.asarray(raw,dtype=np.float32).reshape(BLOCKS,CHANNELS,4)
    out=[]; cache=None
    for block in range(BLOCKS):
        frames=4 if block==0 else 6
        feat=np.empty((1,CHANNELS,frames),dtype=np.float32)
        if cache is not None:
            feat[0,:,:2]=(cache+np.float32(1.0))*np.float32(0.5)
        feat[0,:,frames-4:]=(raw[block]+np.float32(1.0))*np.float32(0.5)
        cache=raw[block,:,2:4].copy()
        out.append(feat)
    return out


class Dsp:
    def __init__(self,path):
        self.path=pathlib.Path(path)
        self.lib=ctypes.CDLL(str(self.path.resolve()))
        f=self.lib.meanvc2_vocos_istft_c
        f.argtypes=[ctypes.POINTER(ctypes.c_float),ctypes.POINTER(ctypes.c_float),ctypes.c_int,ctypes.POINTER(ctypes.c_float),ctypes.c_int]
        f.restype=ctypes.c_int
        self.f=f
    def istft(self,re,im,frames):
        re=np.ascontiguousarray(re,dtype=np.float32).reshape(-1)
        im=np.ascontiguousarray(im,dtype=np.float32).reshape(-1)
        cap=(frames-1)*160
        out=np.empty(cap,dtype=np.float32)
        n=self.f(re.ctypes.data_as(ctypes.POINTER(ctypes.c_float)),im.ctypes.data_as(ctypes.POINTER(ctypes.c_float)),frames,out.ctypes.data_as(ctypes.POINTER(ctypes.c_float)),cap)
        if n!=cap: raise RuntimeError(f'DSP returned {n}, expected {cap}')
        return out


def overlap(wav,last):
    wav=np.asarray(wav,dtype=np.float32)
    if last is None:
        return wav[:-OVERLAP].copy(),wav[-OVERLAP:].copy()
    out=np.empty(wav.size-OVERLAP,dtype=np.float32)
    i=np.arange(OVERLAP,dtype=np.float32)
    up=i/np.float32(OVERLAP-1); down=np.float32(1.0)-up
    out[:OVERLAP]=last*down+wav[:OVERLAP]*up
    out[OVERLAP:]=wav[OVERLAP:-OVERLAP]
    return out,wav[-OVERLAP:].copy()


def metrics(ref,cand):
    a=np.asarray(ref,dtype=np.float64).reshape(-1); b=np.asarray(cand,dtype=np.float64).reshape(-1)
    if a.shape!=b.shape: raise RuntimeError(f'metric shape mismatch {a.shape} {b.shape}')
    d=b-a; ad=np.abs(d)
    denom=np.linalg.norm(a)*np.linalg.norm(b)
    cos=float(np.dot(a,b)/denom) if denom else (1.0 if np.array_equal(a,b) else float('nan'))
    ref_l2=float(np.linalg.norm(a)); err_l2=float(np.linalg.norm(d))
    return {
      'n':int(a.size),
      'max_abs':float(ad.max(initial=0.0)),
      'mean_abs':float(ad.mean()),
      'rmse':float(np.sqrt(np.mean(d*d))),
      'cosine_similarity':cos,
      'ref_l2':ref_l2,
      'cand_l2':float(np.linalg.norm(b)),
      'error_l2':err_l2,
      'relative_l2':float(err_l2/ref_l2) if ref_l2 else (0.0 if err_l2==0 else float('inf')),
      'p50_abs':float(np.quantile(ad,0.50)),
      'p95_abs':float(np.quantile(ad,0.95)),
      'p99_abs':float(np.quantile(ad,0.99)),
    }


def tool_env(foundation):
    root=pathlib.Path(foundation).resolve()
    qairt=root/'qairt'; py=root/'python'/'bin'/'python3.10'; site=root/'site-packages'
    qbin=qairt/'bin'/'x86_64-linux-clang'; qlib=qairt/'lib'/'x86_64-linux-clang'
    required=[py,qbin/'qnn-onnx-converter',qbin/'qnn-model-lib-generator',qbin/'qnn-net-run',qlib/'libQnnCpu.so']
    for p in required:
        if not p.exists(): raise RuntimeError(f'foundation missing {p}')
    env=os.environ.copy()
    env['QNN_SDK_ROOT']=str(qairt)
    env['PYTHONPATH']=os.pathsep.join([str(site),str(qairt/'lib'/'python'),env.get('PYTHONPATH','')]).rstrip(os.pathsep)
    env['LD_LIBRARY_PATH']=os.pathsep.join([str(root/'python'/'lib'),str(qairt/'bin'/'lib'),str(qlib),env.get('LD_LIBRARY_PATH','')]).rstrip(os.pathsep)
    env['PATH']=os.pathsep.join([str(qbin),env.get('PATH','')])
    return root,qairt,py,qbin,qlib,env


def compile_model(name,onnx_path,work,py,qbin,env):
    d=work/'compiled'/name; d.mkdir(parents=True,exist_ok=True)
    cpp=d/f'{name}.cpp'
    convert_ms=run([py,qbin/'qnn-onnx-converter','--input_network',pathlib.Path(onnx_path).resolve(),'--output_path',cpp],work/'logs'/f'{name}.converter.log',env=env)
    if not cpp.is_file(): raise RuntimeError(f'converter did not create {cpp}')
    args=[qbin/'qnn-model-lib-generator','-c',cpp,'-o',d/'model-lib','-t','x86_64-linux-clang']
    binp=d/f'{name}.bin'
    if binp.is_file(): args += ['-b',binp]
    try:
        model_ms=run(args,work/'logs'/f'{name}.model-lib.log',env=env)
    except RuntimeError:
        model_ms=run([py]+args,work/'logs'/f'{name}.model-lib-python.log',env=env)
    libs=list((d/'model-lib').rglob('*.so'))
    if len(libs)!=1:
        raise RuntimeError(f'expected exactly one generated model .so for {name}, found {libs}')
    return libs[0],{'converter_ms':convert_ms,'model_lib_ms':model_ms,'model_so':str(libs[0].resolve()),'model_so_sha256':sha_file(libs[0])}


def find_tensor_raw(result_dir,tensor,expected_count):
    candidates=[]
    for p in pathlib.Path(result_dir).rglob('*.raw'):
        if p.stat().st_size!=expected_count*4: continue
        norm=p.name.lower().replace('/','_')
        score=0
        if tensor.lower() in norm: score+=10
        if tensor.lower().replace('_','') in norm.replace('_',''): score+=5
        candidates.append((score,p))
    candidates.sort(key=lambda x:(-x[0],str(x[1])))
    if not candidates: raise RuntimeError(f'no {expected_count}-float raw output for {tensor} under {result_dir}')
    best=candidates[0]
    if len(candidates)>1 and best[0]==candidates[1][0] and best[0]==0:
        raise RuntimeError(f'ambiguous output files for {tensor}: {[str(p) for _,p in candidates]}')
    return best[1],np.fromfile(best[1],dtype='<f4')


def qnn_run(model_so,input_list,outdir,log,qbin,qlib,env):
    outdir=pathlib.Path(outdir)
    if outdir.exists(): shutil.rmtree(outdir)
    outdir.mkdir(parents=True)
    return run([qbin/'qnn-net-run','--backend',qlib/'libQnnCpu.so','--model',model_so,'--input_list',input_list,'--output_dir',outdir],log,env=env)


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--foundation',required=True,help='extracted qairt244-native-host-foundation/foundation directory')
    ap.add_argument('--cold',required=True)
    ap.add_argument('--warm',required=True)
    ap.add_argument('--raw-mel',required=True)
    ap.add_argument('--out',required=True)
    ap.add_argument('--dsp-source',default=None)
    ap.add_argument('--oracle-npz',default=None,help='optional exact FP32 oracle npz with spectrum and waveform arrays')
    args=ap.parse_args()

    out=pathlib.Path(args.out).resolve(); out.mkdir(parents=True,exist_ok=True)
    work=out/'work'; work.mkdir(exist_ok=True)
    ids={
      'cold':verify(args.cold,COLD_BYTES,COLD_SHA),
      'warm':verify(args.warm,WARM_BYTES,WARM_SHA),
      'raw_mel':verify(args.raw_mel,RAW_BYTES,RAW_SHA),
    }
    root,qairt,py,qbin,qlib,env=tool_env(args.foundation)
    foundation_pass=root/'smoke'/'FOUNDATION_PASS.txt'
    if not foundation_pass.is_file() or 'QAIRT244_NATIVE_FOUNDATION_PASS=1' not in foundation_pass.read_text(errors='replace'):
        raise RuntimeError('foundation has no qualified tiny QNN CPU PASS marker')

    raw=np.fromfile(args.raw_mel,dtype='<f4')
    if raw.size!=BLOCKS*CHANNELS*4 or not np.isfinite(raw).all(): raise RuntimeError('raw mel geometry/nonfinite drift')
    segs=build_segments(raw)
    input_root=work/'inputs'; input_root.mkdir(exist_ok=True)
    cold_path=input_root/'cold4_block000.raw'; segs[0].astype('<f4').tofile(cold_path)
    cold_list=input_root/'cold4.input_list.txt'; cold_list.write_text(f'features:={cold_path}\n')
    warm_list=input_root/'warm6.input_list.txt'
    warm_lines=[]
    for i in range(1,BLOCKS):
        p=input_root/f'warm6_block{i:03d}.raw'; segs[i].astype('<f4').tofile(p); warm_lines.append(f'features:={p}')
    warm_list.write_text('\n'.join(warm_lines)+'\n')

    cold_so,cold_build=compile_model('rev25_cold4',args.cold,work,py,qbin,env)
    warm_so,warm_build=compile_model('rev25_warm6',args.warm,work,py,qbin,env)
    cold_ms=qnn_run(cold_so,cold_list,work/'qnn-cold',work/'logs'/'cold.qnn-net-run.log',qbin,qlib,env)
    warm_ms=qnn_run(warm_so,warm_list,work/'qnn-warm',work/'logs'/'warm.qnn-net-run.log',qbin,qlib,env)

    # Build exact host DSP from repository source unless an explicit source is supplied.
    dsp_src=pathlib.Path(args.dsp_source) if args.dsp_source else pathlib.Path(__file__).resolve().parent.parent/'rev25_qnn_cpu'/'meanvc2_vocos_dsp.cpp'
    if not dsp_src.is_file(): raise RuntimeError(f'missing exact DSP source {dsp_src}')
    dsp_lib=work/'libmeanvc2_vocos_dsp_host.so'
    run(['g++','-std=c++17','-O2','-fPIC','-shared',dsp_src,'-o',dsp_lib],work/'logs'/'dsp-build.log')
    dsp=Dsp(dsp_lib)

    block_stats=[]; specs=[]; waves=[]; last=None
    result_dirs=[work/'qnn-cold'/'Result_0']+[work/'qnn-warm'/f'Result_{i}' for i in range(BLOCKS-1)]
    for block,res in enumerate(result_dirs):
        if not res.is_dir():
            # Some qnn-net-run builds zero-pad or use a nested output path; resolve by ordinal.
            base=work/'qnn-cold' if block==0 else work/'qnn-warm'
            dirs=sorted([p for p in base.rglob('Result_*') if p.is_dir()],key=lambda p:int(p.name.split('_')[-1]))
            idx=0 if block==0 else block-1
            if idx>=len(dirs): raise RuntimeError(f'missing QNN result directory for block {block}; found {dirs}')
            res=dirs[idx]
        frames=4 if block==0 else 6; n=BINS*frames
        rp,re=find_tensor_raw(res,'spec_real',n); ip,im=find_tensor_raw(res,'spec_imag',n)
        if not np.isfinite(re).all() or not np.isfinite(im).all(): raise RuntimeError(f'nonfinite QNN output block {block}')
        specs.extend([re,im])
        wav=dsp.istft(re,im,frames); emit,last=overlap(wav,last); waves.append(emit)
        block_stats.append({'block':block,'route':'cold4' if block==0 else 'warm6','frames':frames,'spec_real_path':str(rp),'spec_imag_path':str(ip),'spec_real_sha256':sha_f32(re),'spec_imag_sha256':sha_f32(im),'emit_sha256':sha_f32(emit)})
    waves.append(last)
    spectrum=np.concatenate(specs).astype(np.float32,copy=False)
    waveform=np.concatenate(waves).astype(np.float32,copy=False)
    if waveform.size!=30560: raise RuntimeError(f'waveform geometry drift {waveform.size}')
    np.save(out/'qnn_cpu_spectrum.npy',spectrum,allow_pickle=False)
    np.save(out/'qnn_cpu_waveform.npy',waveform,allow_pickle=False)

    tool_ids={}
    for name in ('qnn-onnx-converter','qnn-model-lib-generator','qnn-net-run','qnn-context-binary-generator','qnn-profile-viewer'):
        p=qbin/name
        if p.is_file(): tool_ids[name]={'path':str(p),'sha256':sha_file(p)}
    for name in ('libQnnCpu.so','libQnnSystem.so','libQnnSaver.so'):
        p=qlib/name
        if p.is_file(): tool_ids[name]={'path':str(p),'sha256':sha_file(p)}

    ev={
      'schema':1,
      'safe_start':'SIMADMIN_AGENT_SAFE_START_REQUIRED=1',
      'route':'cold4 once -> warm6 x47',
      'backend':'native qnn-net-run / libQnnCpu.so',
      'cpu_fallback_authorized':False,
      'threshold_relaxation_authorized':False,
      'production_integration':False,
      'identity':ids,
      'foundation':{'path':str(root),'provenance_sha256':sha_file(root/'FOUNDATION_PROVENANCE.txt') if (root/'FOUNDATION_PROVENANCE.txt').is_file() else None,'tools':tool_ids},
      'build':{'cold':cold_build,'warm':warm_build},
      'runtime':{'cold_qnn_net_run_ms':cold_ms,'warm47_qnn_net_run_ms':warm_ms},
      'qnn_cpu':{'spectrum_sha256':sha_f32(spectrum),'spectrum_count':int(spectrum.size),'waveform_sha256':sha_f32(waveform),'waveform_count':int(waveform.size)},
      'blocks':block_stats,
      'fp32_oracle_comparison':{'status':'NOT_PROVIDED'},
    }
    if args.oracle_npz:
        op=pathlib.Path(args.oracle_npz); oracle=np.load(op,allow_pickle=False)
        if set(('spectrum','waveform'))-set(oracle.files): raise RuntimeError(f'oracle npz must contain spectrum,waveform; got {oracle.files}')
        ospec=np.asarray(oracle['spectrum'],dtype=np.float32).reshape(-1); owav=np.asarray(oracle['waveform'],dtype=np.float32).reshape(-1)
        ev['fp32_oracle_comparison']={
          'status':'MEASURED',
          'oracle_path':str(op.resolve()),
          'oracle_sha256':sha_file(op),
          'spectrum':metrics(ospec,spectrum),
          'waveform':metrics(owav,waveform),
          'frozen_android_gate':{'max_abs_le':3e-4,'mean_abs_le':1e-5,'rmse_le':2e-5,'cosine_similarity_ge':0.99999},
        }
    evidence=out/'native_qnn_cpu_semantic.json'; evidence.write_text(json.dumps(ev,indent=2,sort_keys=True)+'\n')
    (out/'native_qnn_cpu_semantic.sha256').write_text(sha_file(evidence)+'  native_qnn_cpu_semantic.json\n')
    with (out/'SHA256SUMS.txt').open('w') as f:
        for p in sorted(out.iterdir()):
            if p.is_file() and p.name!='SHA256SUMS.txt': f.write(f'{sha_file(p)}  {p.name}\n')
    print(json.dumps({'qnn_cpu':ev['qnn_cpu'],'comparison':ev['fp32_oracle_comparison']},indent=2))
    print('NATIVE_QNN_CPU_REFERENCE_FREEZE_PASS=1')

if __name__=='__main__': main()
