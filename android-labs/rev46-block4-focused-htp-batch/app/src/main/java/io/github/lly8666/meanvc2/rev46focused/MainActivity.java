package io.github.lly8666.meanvc2.rev46focused;

import ai.onnxruntime.*;
import android.app.Activity;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.graphics.Typeface;
import android.os.Bundle;
import android.view.ViewGroup;
import android.widget.*;
import java.io.*;
import java.nio.*;
import java.security.MessageDigest;
import java.util.*;
import org.json.*;

public final class MainActivity extends Activity {
    private static final int PREACT=1536, RESIDUAL=320;
    private static final double MATERIAL=0.03;
    private static final String PAYLOAD_MANIFEST_SHA="b29c79b7ea2ae093fc0c69c77ad31519764a026050d997f4f3ddd7ebd86b86c9";
    private static final String[] MODEL_KEYS={"baseline","candidate"};
    private static final String[] OUTPUTS={"activation","pw2","residual_out"};
    private static final String[] MICRO_KINDS={"gelu_op","canonical_erf","decanonicalized_erf"};
    private TextView out;
    private Button runButton,copyButton;
    private volatile String fullLog="";

    static final class Fixture {
        final String id,role; final int t; final String preactAsset,residualAsset; final boolean assetBacked;
        Fixture(String id,String role,int t,String pa,String ra){this.id=id;this.role=role;this.t=t;this.preactAsset=pa;this.residualAsset=ra;this.assetBacked=true;}
        Fixture(String id,String role,int t){this.id=id;this.role=role;this.t=t;this.preactAsset=null;this.residualAsset=null;this.assetBacked=false;}
    }
    static final Fixture[] FIXTURES={
        new Fixture("cold0","FROZEN_VALIDATION_DIAGNOSTIC_NO_FITTING",4,"focused/fixtures/preact_cold0.f32","focused/fixtures/residual_cold0.f32"),
        new Fixture("warm1","FROZEN_VALIDATION_DIAGNOSTIC_NO_FITTING",6,"focused/fixtures/preact_warm1.f32","focused/fixtures/residual_warm1.f32"),
        new Fixture("warm18","FROZEN_VALIDATION_DIAGNOSTIC_NO_FITTING_KNOWN_OUTLIER",6,"focused/fixtures/preact_warm18.f32","focused/fixtures/residual_warm18.f32"),
        new Fixture("warm47","FROZEN_VALIDATION_DIAGNOSTIC_NO_FITTING",6,"focused/fixtures/preact_warm47.f32","focused/fixtures/residual_warm47.f32"),
        new Fixture("stress_critical","NONFINAL_DETERMINISTIC_STRESS",6),
        new Fixture("stress_sweep","NONFINAL_DETERMINISTIC_STRESS",6),
        new Fixture("stress_lcg","NONFINAL_DETERMINISTIC_STRESS",6)
    };
    static final class Cfg {
        final String id,fp16,opt; final boolean repeat,profile;
        Cfg(String id,String fp16,String opt,boolean repeat,boolean profile){this.id=id;this.fp16=fp16;this.opt=opt;this.repeat=repeat;this.profile=profile;}
    }
    static final Cfg[] CONFIGS={
        new Cfg("prod","1","3",true,true),
        new Cfg("fp32ctl","0","3",false,true),
        new Cfg("opt0ctl","1","0",false,true)
    };
    static final class OutputSet {
        final Map<String,float[]> v=new LinkedHashMap<>(); double runMs; String error="";
        boolean ok(){return error.isEmpty()&&v.size()==3;}
    }
    static final class Matrix {
        final Map<String,OutputSet> runs=new LinkedHashMap<>(); double createMs; String error=""; File profileCsv,qnnLog;
    }
    static final class Metric {double max,mean,rmse,cos; int idx; float a,b;}

    @Override public void onCreate(Bundle b){
        super.onCreate(b);
        LinearLayout root=new LinearLayout(this);root.setOrientation(LinearLayout.VERTICAL);root.setPadding(20,20,20,20);
        TextView title=new TextView(this);title.setText("MeanVC2 rev46 · focused block4 strict-HTP batch v2");title.setTextSize(17);title.setTypeface(Typeface.DEFAULT_BOLD);root.addView(title);
        TextView note=new TextView(this);note.setText("一次自动运行：micro lowering + 真实 block4 tail + nonfinal stress + prod/FP32/opt0 controls + fresh-session repeat + detailed profiling。QNN 禁止 CPU fallback。完成后复制完整日志。");root.addView(note);
        LinearLayout buttons=new LinearLayout(this);buttons.setOrientation(LinearLayout.HORIZONTAL);
        runButton=new Button(this);runButton.setText("运行全部");copyButton=new Button(this);copyButton.setText("复制完整日志");copyButton.setEnabled(false);
        buttons.addView(runButton,new LinearLayout.LayoutParams(0,ViewGroup.LayoutParams.WRAP_CONTENT,1));buttons.addView(copyButton,new LinearLayout.LayoutParams(0,ViewGroup.LayoutParams.WRAP_CONTENT,1));root.addView(buttons);
        ScrollView scroll=new ScrollView(this);out=new TextView(this);out.setTypeface(Typeface.MONOSPACE);out.setTextSize(12);out.setTextIsSelectable(true);scroll.addView(out);root.addView(scroll,new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,0,1));setContentView(root);
        runButton.setOnClickListener(v->startBatch());copyButton.setOnClickListener(v->{ClipboardManager cm=(ClipboardManager)getSystemService(Context.CLIPBOARD_SERVICE);cm.setPrimaryClip(ClipData.newPlainText("MeanVC2 rev46 focused log",fullLog));Toast.makeText(this,"完整日志已复制",Toast.LENGTH_SHORT).show();});
        startBatch();
    }

    private void progress(String s){runOnUiThread(()->out.setText("REV46_FOCUSED_HTP_BATCH_RUNNING\nphase="+s+"\n请保持应用前台，完成后会显示完整日志。"));}
    private void startBatch(){runButton.setEnabled(false);copyButton.setEnabled(false);fullLog="";progress("startup");new Thread(()->{String x;try{x=runBatch();}catch(Throwable t){x="REV46_FOCUSED_HTP_BATCH_FATAL\n"+err(t)+"\n";}fullLog=x;String y=x;runOnUiThread(()->{out.setText(y);runButton.setEnabled(true);copyButton.setEnabled(true);});},"rev46-focused-htp-batch").start();}

    private String runBatch() throws Exception {
        StringBuilder b=new StringBuilder(512*1024);
        kv(b,"marker","REV46_FOCUSED_HTP_BATCH_START");
        kv(b,"app_version",getPackageManager().getPackageInfo(getPackageName(),0).versionName);
        kv(b,"ort_version","1.27.0");kv(b,"qnn_runtime_version","2.44.0");kv(b,"material_improvement_threshold",MATERIAL);
        kv(b,"strict_cpu_fallback_disabled",true);kv(b,"frozen_fixture_policy","VALIDATION_DIAGNOSTIC_ONLY_NO_FITTING_NO_SEARCH");
        kv(b,"nonfinal_stress_policy","ELIGIBLE_FOR_STRUCTURAL_SENSITIVITY_NOT_FINAL_QUALIFICATION");
        kv(b,"providers",String.valueOf(OrtEnvironment.getAvailableProviders()));
        if(!OrtEnvironment.getAvailableProviders().contains(OrtProvider.QNN))throw new IllegalStateException("QNN provider unavailable");
        progress("verify-focused-payload");verifyFocusedPayload(b);
        OrtEnvironment env=OrtEnvironment.getEnvironment();
        progress("micro-lowering");runMicro(env,b);
        progress("focused-cpu-oracle-check");
        Matrix baseCpu=runFocused(env,"baseline",null,0,b);Matrix candCpu=runFocused(env,"candidate",null,0,b);
        logCpuOracleChecks(b,"baseline",baseCpu);logCpuOracleChecks(b,"candidate",candCpu);logSemanticDelta(b);
        boolean allProdRepeat=true;int htpMatrices=0;
        for(Cfg cfg:CONFIGS){
            progress("focused-htp-"+cfg.id);
            Matrix base=runFocused(env,"baseline",cfg,0,b);Matrix cand=runFocused(env,"candidate",cfg,0,b);htpMatrices+=2;
            logFocusedComparison(b,cfg.id,base,cand);
            appendProfile(b,cfg.id+"_baseline",base);appendProfile(b,cfg.id+"_candidate",cand);
            if(cfg.repeat){
                progress("focused-htp-"+cfg.id+"-fresh-repeat");
                Matrix br=runFocused(env,"baseline",cfg,1,b),cr=runFocused(env,"candidate",cfg,1,b);htpMatrices+=2;
                boolean be=logRepeat(b,cfg.id+"_baseline",base,br),ce=logRepeat(b,cfg.id+"_candidate",cand,cr);allProdRepeat&=be&&ce;
                appendProfile(b,cfg.id+"_baseline_repeat",br);appendProfile(b,cfg.id+"_candidate_repeat",cr);
            }
        }
        kv(b,"focused_htp_matrix_count",htpMatrices);kv(b,"prod_fresh_session_repeat_all_outputs_exact",allProdRepeat);
        kv(b,"interpretation_guard","FOCUSED_AND_MICRO_DIAGNOSTIC_ONLY;NO_FINAL_FULL_VOCOS_PASS;NO_THRESHOLD_RELAXATION;NO_FROZEN_FIXTURE_FITTING");
        kv(b,"marker","REV46_FOCUSED_HTP_BATCH_COMPLETE");
        return b.toString();
    }

    private void verifyFocusedPayload(StringBuilder b)throws Exception{
        byte[] mr=asset("focused/PAYLOAD_MANIFEST.json");String msh=sha(mr);kv(b,"payload_manifest_sha256",msh);if(!PAYLOAD_MANIFEST_SHA.equals(msh))throw new IllegalStateException("payload manifest drift "+msh);
        JSONObject m=new JSONObject(new String(mr,java.nio.charset.StandardCharsets.UTF_8));JSONArray fs=m.getJSONArray("files");int ok=0;long bytes=0;
        for(int i=0;i<fs.length();i++){JSONObject f=fs.getJSONObject(i);String p=f.getString("path");byte[] raw=asset("focused/"+p);String got=sha(raw);if(raw.length!=f.getLong("bytes")||!got.equals(f.getString("sha256")))throw new IllegalStateException("focused asset drift "+p);ok++;bytes+=raw.length;}
        kv(b,"focused_verified_file_count",ok);kv(b,"focused_verified_payload_bytes",bytes);kv(b,"focused_source_rev25_cold_sha256",m.getJSONObject("source_rev25").getString("cold_sha256"));kv(b,"focused_source_rev25_warm_sha256",m.getJSONObject("source_rev25").getString("warm_sha256"));
    }

    private Matrix runFocused(OrtEnvironment env,String modelKey,Cfg cfg,int repeat,StringBuilder b){
        Matrix mx=new Matrix();String tag=(cfg==null?"cpu":cfg.id)+(repeat>0?"_repeat":"");String prefix="focused_"+modelKey+"_"+tag;
        try{
            byte[] model=asset("focused/models/block4_"+modelKey+".onnx");OrtSession.SessionOptions so;
            if(cfg==null)so=cpuOptions();else{File pd=new File(getFilesDir(),"profiles");pd.mkdirs();File csv=new File(pd,prefix+".csv");deleteQuiet(csv);deleteQuiet(new File(pd,prefix+"_qnn.log"));mx.profileCsv=csv;mx.qnnLog=new File(pd,prefix+"_qnn.log");so=qnnOptions(cfg,csv);}
            long sc=System.nanoTime();
            try(OrtSession.SessionOptions opts=so;OrtSession s=env.createSession(model,opts)){
                mx.createMs=(System.nanoTime()-sc)/1e6;kv(b,prefix+"_session_create_ms",mx.createMs);
                for(Fixture f:FIXTURES){OutputSet r=runFocusedFixture(env,s,f);mx.runs.put(f.id,r);kv(b,prefix+"_"+f.id+"_ok",r.ok());kv(b,prefix+"_"+f.id+"_run_ms",r.runMs);if(!r.ok())kv(b,prefix+"_"+f.id+"_error",r.error);}
            }
        }catch(Throwable t){mx.error=err(t);kv(b,prefix+"_session_error",mx.error);for(Fixture f:FIXTURES){OutputSet r=new OutputSet();r.error=mx.error;mx.runs.put(f.id,r);}}
        return mx;
    }

    private OutputSet runFocusedFixture(OrtEnvironment env,OrtSession s,Fixture f){OutputSet o=new OutputSet();try{
        float[] pre=f.assetBacked?assetFloats(f.preactAsset,f.t*PREACT):stressPreact(f);float[] res=f.assetBacked?assetFloats(f.residualAsset,f.t*RESIDUAL):stressResidual(f);
        FloatBuffer pb=direct(pre),rb=direct(res);long st=System.nanoTime();
        try(OnnxTensor pt=OnnxTensor.createTensor(env,pb,new long[]{1,f.t,PREACT});OnnxTensor rt=OnnxTensor.createTensor(env,rb,new long[]{1,RESIDUAL,f.t})){
            LinkedHashMap<String,OnnxTensor> ins=new LinkedHashMap<>();ins.put("preact",pt);ins.put("residual",rt);
            try(OrtSession.Result rr=s.run(ins)){o.runMs=(System.nanoTime()-st)/1e6;for(String n:OUTPUTS)o.v.put(n,read(rr,n));}
        }
        int ae=f.t*PREACT,re=f.t*RESIDUAL;if(o.v.get("activation").length!=ae||o.v.get("pw2").length!=re||o.v.get("residual_out").length!=re)throw new IllegalStateException("focused output geometry "+f.id);
    }catch(Throwable t){o.error=err(t);}return o;}

    private void logCpuOracleChecks(StringBuilder b,String model,Matrix cpu)throws Exception{
        for(Fixture f:FIXTURES){OutputSet r=cpu.runs.get(f.id);kv(b,"fixture_"+f.id+"_role",f.role);if(!f.assetBacked||r==null||!r.ok())continue;for(String n:OUTPUTS){float[] oracle=assetFloats(oracleAsset(model,f.id,n),r.v.get(n).length);metricKv(b,"cpu_"+model+"_"+f.id+"_"+n+"_vs_host_ort127",metric(oracle,r.v.get(n)));}}
    }
    private void logSemanticDelta(StringBuilder b)throws Exception{for(Fixture f:FIXTURES){if(!f.assetBacked)continue;for(String n:OUTPUTS){float[] a=assetFloats(oracleAsset("baseline",f.id,n),expectedCount(f,n)),c=assetFloats(oracleAsset("candidate",f.id,n),expectedCount(f,n));metricKv(b,"host_semantic_candidate_vs_baseline_"+f.id+"_"+n,metric(a,c));}}}

    private void logFocusedComparison(StringBuilder b,String cfg,Matrix base,Matrix cand)throws Exception{
        for(Fixture f:FIXTURES){OutputSet br=base.runs.get(f.id),cr=cand.runs.get(f.id);if(br==null||cr==null||!br.ok()||!cr.ok()){kv(b,"focused_"+cfg+"_"+f.id+"_comparison","unavailable");continue;}
            for(String n:OUTPUTS){
                float[] teacher=f.assetBacked?assetFloats(oracleAsset("baseline",f.id,n),br.v.get(n).length):cpuFocusedReference("baseline",f,n);
                float[] candOracle=f.assetBacked?assetFloats(oracleAsset("candidate",f.id,n),cr.v.get(n).length):cpuFocusedReference("candidate",f,n);
                Metric be=metric(teacher,br.v.get(n)),ct=metric(teacher,cr.v.get(n)),cb=metric(candOracle,cr.v.get(n));
                String p="focused_"+cfg+"_"+f.id+"_"+n;metricKv(b,p+"_baseline_htp_vs_teacher",be);metricKv(b,p+"_candidate_htp_vs_teacher",ct);metricKv(b,p+"_candidate_backend_vs_own_cpu",cb);metricKv(b,p+"_candidate_htp_vs_baseline_htp",metric(br.v.get(n),cr.v.get(n)));
                double imp=be.rmse==0?Double.NaN:(be.rmse-ct.rmse)/be.rmse;kv(b,p+"_rmse_improvement_fraction",imp);kv(b,p+"_material_ge_3pct",Double.isFinite(imp)&&imp>=MATERIAL);
            }
        }
    }

    private float[] cpuFocusedReference(String model,Fixture target,String output)throws Exception{
        OrtEnvironment env=OrtEnvironment.getEnvironment();Matrix m=new Matrix();byte[] mb=asset("focused/models/block4_"+model+".onnx");try(OrtSession.SessionOptions so=cpuOptions();OrtSession s=env.createSession(mb,so)){OutputSet r=runFocusedFixture(env,s,target);if(!r.ok())throw new IllegalStateException(r.error);return r.v.get(output);} }

    private boolean logRepeat(StringBuilder b,String p,Matrix first,Matrix second){boolean all=true;for(Fixture f:FIXTURES){OutputSet a=first.runs.get(f.id),c=second.runs.get(f.id);if(a==null||c==null||!a.ok()||!c.ok()){all=false;continue;}for(String n:OUTPUTS){boolean ex=bits(a.v.get(n),c.v.get(n));all&=ex;kv(b,p+"_"+f.id+"_"+n+"_repeat_exact_bits",ex);metricKv(b,p+"_"+f.id+"_"+n+"_repeat_metric",metric(a.v.get(n),c.v.get(n)));}}kv(b,p+"_repeat_all_exact",all);return all;}

    private void appendProfile(StringBuilder b,String id,Matrix m)throws Exception{
        File f=m.profileCsv;if(f==null||!f.isFile()){kv(b,"profile_"+id+"_present",false);return;}byte[] raw=fileBytes(f);kv(b,"profile_"+id+"_present",true);kv(b,"profile_"+id+"_bytes",raw.length);kv(b,"profile_"+id+"_sha256",sha(raw));b.append("profile_").append(id).append("_csv_begin\n");String s=new String(raw,java.nio.charset.StandardCharsets.UTF_8);if(s.length()>120000)s=s.substring(0,120000)+"\n[TRUNCATED]\n";b.append(s);if(!s.endsWith("\n"))b.append('\n');b.append("profile_").append(id).append("_csv_end\n");
        if(m.qnnLog!=null&&m.qnnLog.isFile()){byte[] q=fileBytes(m.qnnLog);kv(b,"profile_"+id+"_qnn_log_bytes",q.length);kv(b,"profile_"+id+"_qnn_log_sha256",sha(q));}
    }

    private void runMicro(OrtEnvironment env,StringBuilder b)throws Exception{
        JSONObject mm=new JSONObject(new String(asset("micro/MODEL_MANIFEST.json"),java.nio.charset.StandardCharsets.UTF_8));kv(b,"micro_manifest_schema",mm.getInt("schema"));int failures=0;boolean allRepeat=true;
        for(String shape:new String[]{"cold4","warm6"}){int t=shape.equals("cold4")?4:6;LinkedHashMap<String,float[]> inputs=new LinkedHashMap<>();inputs.put("critical",microInput("critical",t));inputs.put("sweep",microInput("sweep",t));inputs.put("wave",microInput("wave",t));inputs.put("real",assetFloats(shape.equals("cold4")?"focused/fixtures/preact_cold0.f32":"focused/fixtures/preact_warm18.f32",t*PREACT));
            Map<String,Map<String,OutputSet>> cpu=new LinkedHashMap<>(),h1=new LinkedHashMap<>(),h2=new LinkedHashMap<>();
            for(String kind:MICRO_KINDS){byte[] model=asset("micro/models/"+shape+"_"+kind+".onnx");cpu.put(kind,runMicroSession(env,model,t,inputs,null));Cfg prod=new Cfg("microprod","1","3",true,false);h1.put(kind,runMicroSession(env,model,t,inputs,prod));h2.put(kind,runMicroSession(env,model,t,inputs,prod));
                for(String in:inputs.keySet()){OutputSet c=cpu.get(kind).get(in),q=h1.get(kind).get(in),r=h2.get(kind).get(in);String p="micro_"+shape+"_"+kind+"_"+in;if(c==null||q==null||r==null||!c.ok()||!q.ok()||!r.ok()){failures++;kv(b,p+"_complete",false);continue;}metricKv(b,p+"_htp_vs_cpu",metric(c.v.get("y"),q.v.get("y")));boolean ex=bits(q.v.get("y"),r.v.get("y"));allRepeat&=ex;kv(b,p+"_fresh_session_repeat_exact_bits",ex);}}
            for(String in:inputs.keySet())for(String backend:new String[]{"cpu","htp"}){Map<String,Map<String,OutputSet>> src=backend.equals("cpu")?cpu:h1;microPair(b,shape,in,backend,src,"gelu_op","canonical_erf");microPair(b,shape,in,backend,src,"canonical_erf","decanonicalized_erf");microPair(b,shape,in,backend,src,"gelu_op","decanonicalized_erf");}
        }
        kv(b,"micro_failed_triplets",failures);kv(b,"micro_fresh_session_repeat_all_available_exact",allRepeat);
    }
    private Map<String,OutputSet> runMicroSession(OrtEnvironment env,byte[] model,int t,Map<String,float[]> inputs,Cfg cfg){Map<String,OutputSet> out=new LinkedHashMap<>();try(OrtSession.SessionOptions so=cfg==null?cpuOptions():qnnOptions(cfg,null);OrtSession s=env.createSession(model,so)){for(Map.Entry<String,float[]> e:inputs.entrySet()){OutputSet r=new OutputSet();try{FloatBuffer fb=direct(e.getValue());long st=System.nanoTime();try(OnnxTensor x=OnnxTensor.createTensor(env,fb,new long[]{1,t,PREACT});OrtSession.Result rr=s.run(Collections.singletonMap("x",x))){r.runMs=(System.nanoTime()-st)/1e6;r.v.put("y",read(rr,"y"));}}catch(Throwable z){r.error=err(z);}out.put(e.getKey(),r);}}catch(Throwable t0){String er=err(t0);for(String k:inputs.keySet()){OutputSet r=new OutputSet();r.error=er;out.put(k,r);}}return out;}
    private void microPair(StringBuilder b,String shape,String in,String backend,Map<String,Map<String,OutputSet>> m,String a,String c){OutputSet x=m.get(a).get(in),y=m.get(c).get(in);String p="micro_"+shape+"_"+in+"_"+backend+"_"+a+"_vs_"+c;if(x!=null&&y!=null&&x.ok()&&y.ok())metricKv(b,p,metric(x.v.get("y"),y.v.get("y")));else kv(b,p+"_unavailable",true);}

    private float[] microInput(String kind,int t){int n=t*PREACT;float[] x=new float[n];if(kind.equals("critical")){float[] v={0f,-0f,1e-6f,-1e-6f,.01f,-.01f,.1f,-.1f,.5f,-.5f,1f,-1f,2f,-2f,3f,-3f,4f,-4f,6f,-6f,8f,-8f};for(int i=0;i<n;i++)x[i]=v[i%v.length];}else if(kind.equals("sweep")){for(int i=0;i<n;i++)x[i]=-8f+16f*((i%257)/256f);}else for(int i=0;i<n;i++)x[i]=(float)(2.6*Math.sin(i*.017)+.7*Math.cos(i*.071)+.15*Math.sin(i*.233));return x;}
    private float[] stressPreact(Fixture f){float[] x=new float[f.t*PREACT];if(f.id.equals("stress_critical")){float[] v={0f,1e-6f,-1e-6f,.01f,-.01f,.1f,-.1f,.5f,-.5f,1f,-1f,2f,-2f,4f,-4f,8f,-8f};for(int i=0;i<x.length;i++)x[i]=v[i%v.length];}else if(f.id.equals("stress_sweep")){for(int i=0;i<x.length;i++)x[i]=-6f+12f*((i%769)/768f);}else{long s=0x20260820L;for(int i=0;i<x.length;i++){s=(s*6364136223846793005L+1442695040888963407L);x[i]=(float)(((s>>>40)&0xffffff)/(double)0x800000-1.0)*2.5f;}}return x;}
    private float[] stressResidual(Fixture f){float[] x=new float[f.t*RESIDUAL];if(f.id.equals("stress_critical")){for(int i=0;i<x.length;i++)x[i]=(i%9-4)*.125f;}else if(f.id.equals("stress_sweep")){for(int i=0;i<x.length;i++)x[i]=-2f+4f*((i%257)/256f);}else{for(int i=0;i<x.length;i++)x[i]=(float)(1.2*Math.sin(i*.031)+.3*Math.cos(i*.113));}return x;}

    private OrtSession.SessionOptions cpuOptions()throws OrtException{OrtSession.SessionOptions o=new OrtSession.SessionOptions();o.setInterOpNumThreads(1);o.setIntraOpNumThreads(1);return o;}
    private OrtSession.SessionOptions qnnOptions(Cfg cfg,File profile)throws OrtException{OrtSession.SessionOptions o=cpuOptions();LinkedHashMap<String,String> q=new LinkedHashMap<>();q.put("backend_type","htp");q.put("htp_performance_mode","burst");q.put("qnn_context_priority","high");q.put("htp_graph_finalization_optimization_mode",cfg.opt);q.put("enable_htp_fp16_precision",cfg.fp16);q.put("offload_graph_io_quantization","0");if(cfg.profile&&profile!=null){q.put("profiling_level","detailed");q.put("profiling_file_path",profile.getAbsolutePath());}o.addQnn(q);o.addConfigEntry("session.disable_cpu_ep_fallback","1");return o;}

    private String oracleAsset(String model,String fixture,String output){return "focused/oracle/"+model+"_"+fixture+"_"+output+".f32";}
    private int expectedCount(Fixture f,String n){return n.equals("activation")?f.t*PREACT:f.t*RESIDUAL;}
    private byte[] asset(String p)throws IOException{try(InputStream in=getAssets().open(p);ByteArrayOutputStream o=new ByteArrayOutputStream()){byte[] z=new byte[1<<16];for(int n;(n=in.read(z))>=0;)o.write(z,0,n);return o.toByteArray();}}
    private float[] assetFloats(String p,int expected)throws IOException{byte[] raw=asset(p);if(raw.length!=expected*4)throw new IOException("float asset geometry "+p+" bytes="+raw.length+" expected="+(expected*4));FloatBuffer f=ByteBuffer.wrap(raw).order(ByteOrder.LITTLE_ENDIAN).asFloatBuffer();float[] x=new float[expected];f.get(x);return x;}
    private static FloatBuffer direct(float[] x){FloatBuffer b=ByteBuffer.allocateDirect(x.length*4).order(ByteOrder.nativeOrder()).asFloatBuffer();b.put(x).rewind();return b;}
    private static float[] read(OrtSession.Result r,String n)throws Exception{OnnxValue v=r.get(n).orElseThrow();FloatBuffer b=((OnnxTensor)v).getFloatBuffer();b.rewind();float[] x=new float[b.remaining()];b.get(x);for(float z:x)if(!Float.isFinite(z))throw new IllegalStateException("nonfinite "+n);return x;}
    private static Metric metric(float[] a,float[] c){if(a.length!=c.length)throw new IllegalArgumentException("metric geometry");Metric m=new Metric();double sum=0,ss=0,dot=0,aa=0,cc=0,mx=-1;int idx=0;for(int i=0;i<a.length;i++){double d=c[i]-a[i],ad=Math.abs(d);sum+=ad;ss+=d*d;dot+=(double)a[i]*c[i];aa+=(double)a[i]*a[i];cc+=(double)c[i]*c[i];if(ad>mx){mx=ad;idx=i;}}m.max=mx;m.mean=sum/a.length;m.rmse=Math.sqrt(ss/a.length);m.cos=(aa==0||cc==0)?Double.NaN:dot/Math.sqrt(aa*cc);m.idx=idx;m.a=a[idx];m.b=c[idx];return m;}
    private static void metricKv(StringBuilder b,String p,Metric m){kv(b,p+"_max_abs",m.max);kv(b,p+"_mean_abs",m.mean);kv(b,p+"_rmse",m.rmse);kv(b,p+"_cosine",m.cos);kv(b,p+"_max_index",m.idx);kv(b,p+"_ref_at_max",m.a);kv(b,p+"_cand_at_max",m.b);}
    private static boolean bits(float[] a,float[] c){if(a.length!=c.length)return false;for(int i=0;i<a.length;i++)if(Float.floatToRawIntBits(a[i])!=Float.floatToRawIntBits(c[i]))return false;return true;}
    private static byte[] fileBytes(File f)throws IOException{try(InputStream in=new FileInputStream(f);ByteArrayOutputStream o=new ByteArrayOutputStream()){byte[] z=new byte[1<<16];for(int n;(n=in.read(z))>=0;)o.write(z,0,n);return o.toByteArray();}}
    private static void deleteQuiet(File f){if(f!=null&&f.exists())f.delete();}
    private static String sha(byte[] x)throws Exception{MessageDigest md=MessageDigest.getInstance("SHA-256");byte[] d=md.digest(x);StringBuilder s=new StringBuilder();for(byte z:d)s.append(String.format(Locale.ROOT,"%02x",z&255));return s.toString();}
    private static String err(Throwable t){StringWriter sw=new StringWriter();t.printStackTrace(new PrintWriter(sw));return t.getClass().getName()+":"+String.valueOf(t.getMessage())+" | "+sw.toString().replace('\n',' ').replace('\r',' ');}
    private static void kv(StringBuilder b,String k,Object v){b.append(k).append('=').append(String.valueOf(v)).append('\n');}
}
