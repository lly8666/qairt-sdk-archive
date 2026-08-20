#!/usr/bin/env python3
import argparse, ctypes, hashlib, json, pathlib, platform, sys, time
import numpy as np

COLD_BYTES=33249679
COLD_SHA='323c194e5da29f0be962ea8b72ca2fa2d1a9fc2481d80b95e5590f79e9485f65'
WARM_BYTES=33243869
WARM_SHA='e2b7ab608a6b37a6dd9896589719cab446edf95287f59dfc7b5693da6ec98f6c'
RAW_BYTES=61440
RAW_SHA='dc58af153c7c0dd6ab0a450a5f77648203e7f82a800a17837e09095ce48c9963'
ORT_VERSION='1.27.0'
CHANNELS=80; BINS=321; OVERLAP=160; BLOCKS=48


def sha256_file(p):
    h=hashlib.sha256()
    with open(p,'rb') as f:
        for b in iter(lambda:f.read(1<<20),b''): h.update(b)
    return h.hexdigest()

def sha_f32(x):
    a=np.asarray(x,dtype='<f4').reshape(-1)
    return hashlib.sha256(a.tobytes(order='C')).hexdigest()

def verify(p,n,h):
    p=pathlib.Path(p); got_n=p.stat().st_size; got_h=sha256_file(p)
    if got_n!=n or got_h!=h: raise RuntimeError(f'identity drift {p}: bytes={got_n} sha={got_h}, expected {n} {h}')
    return {'path':str(p.resolve()),'bytes':got_n,'sha256':got_h}

def segments(raw):
    raw=np.asarray(raw,dtype=np.float32).reshape(BLOCKS,CHANNELS,4)
    out=[]; cache=None
    for block in range(BLOCKS):
        frames=4 if block==0 else 6
        feat=np.empty((CHANNELS,frames),dtype=np.float32)
        if cache is not None: feat[:,:2]=(cache+np.float32(1.0))*np.float32(0.5)
        feat[:,frames-4:]=(raw[block]+np.float32(1.0))*np.float32(0.5)
        cache=raw[block,:,2:4].copy()
        out.append(feat[np.newaxis,:,:])
    return out

class Dsp:
    def __init__(self,path):
        self.path=pathlib.Path(path); self.lib=ctypes.CDLL(str(self.path.resolve()))
        f=self.lib.meanvc2_vocos_istft_c
        f.argtypes=[ctypes.POINTER(ctypes.c_float),ctypes.POINTER(ctypes.c_float),ctypes.c_int,ctypes.POINTER(ctypes.c_float),ctypes.c_int]
        f.restype=ctypes.c_int; self.f=f
    def istft(self,re,im,frames):
        re=np.ascontiguousarray(re,dtype=np.float32).reshape(-1); im=np.ascontiguousarray(im,dtype=np.float32).reshape(-1)
        cap=(frames-1)*160; out=np.empty(cap,dtype=np.float32)
        n=self.f(re.ctypes.data_as(ctypes.POINTER(ctypes.c_float)),im.ctypes.data_as(ctypes.POINTER(ctypes.c_float)),frames,out.ctypes.data_as(ctypes.POINTER(ctypes.c_float)),cap)
        if n!=cap: raise RuntimeError(f'host DSP failure {n}, expected {cap}')
        return out

def overlap(wav,last):
    wav=np.asarray(wav,dtype=np.float32)
    if last is None: return wav[:-OVERLAP].copy(), wav[-OVERLAP:].copy()
    out=np.empty(wav.size-OVERLAP,dtype=np.float32)
    i=np.arange(OVERLAP,dtype=np.float32)
    up=i/np.float32(OVERLAP-1); down=np.float32(1.0)-up
    out[:OVERLAP]=last*down+wav[:OVERLAP]*up
    out[OVERLAP:]=wav[OVERLAP:-OVERLAP]
    return out,wav[-OVERLAP:].copy()

def metrics(a,b):
    a=np.asarray(a,dtype=np.float64).reshape(-1); b=np.asarray(b,dtype=np.float64).reshape(-1)
    if a.shape!=b.shape: raise RuntimeError(f'metric shape mismatch {a.shape} {b.shape}')
    d=b-a; ad=np.abs(d); n=a.size
    denom=np.linalg.norm(a)*np.linalg.norm(b)
    cos=float(np.dot(a,b)/denom) if denom>0 else (1.0 if np.array_equal(a,b) else float('nan'))
    return {'n':int(n),'max_abs':float(ad.max(initial=0)),'mean_abs':float(ad.mean()),'rmse':float(np.sqrt(np.mean(d*d))), 'cosine_similarity':cos, 'ref_l2':float(np.linalg.norm(a)), 'cand_l2':float(np.linalg.norm(b))}

def run_pair(ort, cold, warm, segs, dsp, providers, provider_options=None, strict_qnn=False):
    so=ort.SessionOptions(); so.inter_op_num_threads=1; so.intra_op_num_threads=1
    if strict_qnn: so.add_session_config_entry('session.disable_cpu_ep_fallback','1')
    kwargs={'sess_options':so,'providers':providers}
    if provider_options is not None: kwargs['provider_options']=provider_options
    t0=time.perf_counter(); cs=ort.InferenceSession(str(cold),**kwargs); cold_create=(time.perf_counter()-t0)*1000
    t0=time.perf_counter(); ws=ort.InferenceSession(str(warm),**kwargs); warm_create=(time.perf_counter()-t0)*1000
    if list(cs.get_inputs())[0].name!='features' or list(ws.get_inputs())[0].name!='features': raise RuntimeError('input contract drift: expected features')
    for s in (cs,ws):
        names={o.name for o in s.get_outputs()}
        if not {'spec_real','spec_imag'}.issubset(names): raise RuntimeError(f'output contract drift: {names}')
    spec_chunks=[]; wave_chunks=[]; last=None; block_stats=[]
    for i,feat in enumerate(segs):
        sess=cs if i==0 else ws; frames=4 if i==0 else 6
        t=time.perf_counter(); out=sess.run(['spec_real','spec_imag'],{'features':feat}); run_ms=(time.perf_counter()-t)*1000
        re=np.asarray(out[0],dtype=np.float32).reshape(-1); im=np.asarray(out[1],dtype=np.float32).reshape(-1)
        expect=BINS*frames
        if re.size!=expect or im.size!=expect: raise RuntimeError(f'spectrum geometry drift block {i}: {re.size}/{im.size} expect {expect}')
        spec_chunks.extend([re,im])
        wav=dsp.istft(re,im,frames); emit,last=overlap(wav,last); wave_chunks.append(emit)
        block_stats.append({'block':i,'route':'cold4' if i==0 else 'warm6','frames':frames,'run_ms':run_ms,'spec_real_sha256':sha_f32(re),'spec_imag_sha256':sha_f32(im),'emitted_sha256':sha_f32(emit)})
    if last is None: raise RuntimeError('missing tail')
    wave_chunks.append(last)
    spectrum=np.concatenate(spec_chunks).astype(np.float32,copy=False)
    waveform=np.concatenate(wave_chunks).astype(np.float32,copy=False)
    if waveform.size!=30560: raise RuntimeError(f'waveform geometry drift {waveform.size}')
    return {'spectrum':spectrum,'waveform':waveform,'block_stats':block_stats,'cold_create_ms':cold_create,'warm_create_ms':warm_create,'providers_cold':cs.get_providers(),'providers_warm':ws.get_providers()}

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--cold',required=True); ap.add_argument('--warm',required=True); ap.add_argument('--raw-mel',required=True); ap.add_argument('--dsp-lib',required=True); ap.add_argument('--out',required=True)
    a=ap.parse_args(); cold=pathlib.Path(a.cold); warm=pathlib.Path(a.warm); rawp=pathlib.Path(a.raw_mel); outdir=pathlib.Path(a.out); outdir.mkdir(parents=True,exist_ok=True)
    ids={'cold':verify(cold,COLD_BYTES,COLD_SHA),'warm':verify(warm,WARM_BYTES,WARM_SHA),'raw_mel':verify(rawp,RAW_BYTES,RAW_SHA),'dsp':{'path':str(pathlib.Path(a.dsp_lib).resolve()),'sha256':sha256_file(a.dsp_lib)}}
    raw=np.fromfile(rawp,dtype='<f4')
    if raw.size!=BLOCKS*CHANNELS*4 or not np.isfinite(raw).all(): raise RuntimeError('raw mel geometry/nonfinite drift')
    segs=segments(raw); dsp=Dsp(a.dsp_lib)
    import onnxruntime as ort
    if ort.__version__!=ORT_VERSION: raise RuntimeError(f'ORT version drift {ort.__version__}')
    available=ort.get_available_providers()
    if 'QNNExecutionProvider' not in available: raise RuntimeError(f'QNNExecutionProvider unavailable: {available}')
    cpu=run_pair(ort,cold,warm,segs,dsp,['CPUExecutionProvider'])
    qnn_opts={'backend_type':'cpu','offload_graph_io_quantization':'0'}
    qnn=run_pair(ort,cold,warm,segs,dsp,['QNNExecutionProvider'],[qnn_opts],strict_qnn=True)
    np.save(outdir/'cpu_spectrum.npy',cpu['spectrum'],allow_pickle=False); np.save(outdir/'qnn_cpu_spectrum.npy',qnn['spectrum'],allow_pickle=False)
    np.save(outdir/'cpu_waveform.npy',cpu['waveform'],allow_pickle=False); np.save(outdir/'qnn_cpu_waveform.npy',qnn['waveform'],allow_pickle=False)
    ev={
      'schema':1,'safe_start':'SIMADMIN_AGENT_SAFE_START_REQUIRED=1','production_integration':False,'cpu_fallback_authorized':False,'threshold_relaxation_authorized':False,
      'identity':ids,'runtime':{'onnxruntime':ort.__version__,'available_providers':available,'qnn_provider_options':qnn_opts,'session_disable_cpu_ep_fallback':True,'python':sys.version,'platform':platform.platform()},
      'contract':{'blocks':48,'route':'cold4 -> warm6 x47','input_transform':'each raw mel value -> (x+1)/2; warm6 prefixes prior raw block last two frames then applies same transform','features_shapes':['1x80x4','1x80x6'],'outputs':['spec_real','spec_imag'],'dsp':'exact host build of repository meanvc2_vocos_dsp.cpp semantics'},
      'cpu':{'cold_create_ms':cpu['cold_create_ms'],'warm_create_ms':cpu['warm_create_ms'],'providers_cold':cpu['providers_cold'],'providers_warm':cpu['providers_warm'],'spectrum_sha256':sha_f32(cpu['spectrum']),'waveform_sha256':sha_f32(cpu['waveform'])},
      'qnn_cpu':{'cold_create_ms':qnn['cold_create_ms'],'warm_create_ms':qnn['warm_create_ms'],'providers_cold':qnn['providers_cold'],'providers_warm':qnn['providers_warm'],'spectrum_sha256':sha_f32(qnn['spectrum']),'waveform_sha256':sha_f32(qnn['waveform'])},
      'qnn_cpu_vs_cpu':{'spectrum':metrics(cpu['spectrum'],qnn['spectrum']),'waveform':metrics(cpu['waveform'],qnn['waveform'])},
      'blocks':{'cpu':cpu['block_stats'],'qnn_cpu':qnn['block_stats']}
    }
    (outdir/'qnn_cpu_semantic.json').write_text(json.dumps(ev,indent=2,sort_keys=True)+'\n')
    (outdir/'qnn_cpu_semantic.sha256').write_text(sha256_file(outdir/'qnn_cpu_semantic.json')+'  qnn_cpu_semantic.json\n')
    print(json.dumps(ev['qnn_cpu_vs_cpu'],indent=2)); print('EVIDENCE',outdir/'qnn_cpu_semantic.json')
if __name__=='__main__': main()
