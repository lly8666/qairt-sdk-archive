package io.github.lly8666.meanvc2.rev46activationv3;

import ai.onnxruntime.*;
import android.app.Activity;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.graphics.Typeface;
import android.net.Uri;
import android.os.Bundle;
import android.view.ViewGroup;
import android.widget.*;
import java.io.*;
import java.nio.*;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.*;
import org.json.*;

public final class MainActivity extends Activity {
    private static final int PREACT=1536, EXPORT_JSON_REQUEST=4603;
    private static final double MATERIAL=0.03;
    private static final String SOURCE_PAYLOAD_SHA="42493454ece1060a5100f28e5bf35a15d09bb48f8b46f82c5b69a12fd0f6a1c9";
    private static final String PUBLIC_QUALIFICATION_COMMIT="daa8b471af9adad0d560374f9f4037724550e918";
    private static final Map<String,String> MODEL_SHA=new LinkedHashMap<>();
    static {
        MODEL_SHA.put("cold4_baseline_contrib_gelu.onnx","96e2e309a22e41cc3040c88e339ddef24065e30cbf5ffa08a8be9550c899f40f");
        MODEL_SHA.put("cold4_candidate_exact_activation.onnx","3825f01208c5ba351bc70cbd6c967025a23014ee74c48b88dbf18552e6ecc1cd");
        MODEL_SHA.put("warm6_baseline_contrib_gelu.onnx","455516875b73b3ffcf3231260030c934ba752489b9eda8400c77f6179ac4a7e1");
        MODEL_SHA.put("warm6_candidate_exact_activation.onnx","00c10909e547e83ab87a70b7b71b4a6108992e5293198e41bc97ad2d508648e7");
    }

    private TextView out;
    private Button runButton,copyButton,exportButton;
    private volatile String fullLog="";

    static final class Fixture {
        final String id,role,shape,preactAsset; final int t; final boolean assetBacked;
        Fixture(String id,String role,String shape,int t,String preactAsset){this.id=id;this.role=role;this.shape=shape;this.t=t;this.preactAsset=preactAsset;this.assetBacked=true;}
        Fixture(String id,String role,String shape,int t){this.id=id;this.role=role;this.shape=shape;this.t=t;this.preactAsset=null;this.assetBacked=false;}
    }
    static final Fixture[] FIXTURES={
        new Fixture("cold0","FROZEN_VALIDATION_DIAGNOSTIC_NO_FITTING","cold4",4,"fixtures/preact_cold0.f32"),
        new Fixture("warm1","FROZEN_VALIDATION_DIAGNOSTIC_NO_FITTING","warm6",6,"fixtures/preact_warm1.f32"),
        new Fixture("warm18","FROZEN_VALIDATION_DIAGNOSTIC_NO_FITTING_KNOWN_OUTLIER","warm6",6,"fixtures/preact_warm18.f32"),
        new Fixture("warm47","FROZEN_VALIDATION_DIAGNOSTIC_NO_FITTING","warm6",6,"fixtures/preact_warm47.f32"),
        new Fixture("stress4_critical","NONFINAL_DETERMINISTIC_STRESS","cold4",4),
        new Fixture("stress4_sweep","NONFINAL_DETERMINISTIC_STRESS","cold4",4),
        new Fixture("stress6_critical","NONFINAL_DETERMINISTIC_STRESS","warm6",6),
        new Fixture("stress6_sweep","NONFINAL_DETERMINISTIC_STRESS","warm6",6),
        new Fixture("stress6_lcg","NONFINAL_DETERMINISTIC_STRESS","warm6",6)
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
    static final class OutputSet {float[] y; double runMs; String error=""; boolean ok(){return error.isEmpty()&&y!=null;}}
    static final class Matrix {final Map<String,OutputSet> runs=new LinkedHashMap<>();double createMs;String error="";File profileCsv,qnnLog;}
    static final class Metric {double max,mean,rmse,cos;int idx;float a,b;}

    @Override public void onCreate(Bundle b){
        super.onCreate(b);
        LinearLayout root=new LinearLayout(this);root.setOrientation(LinearLayout.VERTICAL);root.setPadding(20,20,20,20);
        TextView title=new TextView(this);title.setText("MeanVC2 rev46 · fixed-shape activation strict-HTP v3");title.setTextSize(17);title.setTypeface(Typeface.DEFAULT_BOLD);root.addView(title);
        TextView note=new TextView(this);note.setText("固定 T=4/T=6 activation-only；prod/FP32/opt0 + fresh-session repeat；严格禁止 CPU fallback。完成后可复制文本或直接导出 UTF-8 JSON。");root.addView(note);
        LinearLayout row1=new LinearLayout(this);row1.setOrientation(LinearLayout.HORIZONTAL);
        runButton=new Button(this);runButton.setText("运行全部");copyButton=new Button(this);copyButton.setText("复制日志");copyButton.setEnabled(false);
        row1.addView(runButton,new LinearLayout.LayoutParams(0,ViewGroup.LayoutParams.WRAP_CONTENT,1));row1.addView(copyButton,new LinearLayout.LayoutParams(0,ViewGroup.LayoutParams.WRAP_CONTENT,1));root.addView(row1);
        exportButton=new Button(this);exportButton.setText("导出 JSON");exportButton.setEnabled(false);root.addView(exportButton,new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,ViewGroup.LayoutParams.WRAP_CONTENT));
        ScrollView scroll=new ScrollView(this);out=new TextView(this);out.setTypeface(Typeface.MONOSPACE);out.setTextSize(12);out.setTextIsSelectable(true);scroll.addView(out);root.addView(scroll,new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,0,1));setContentView(root);
        runButton.setOnClickListener(v->startBatch());
        copyButton.setOnClickListener(v->{ClipboardManager cm=(ClipboardManager)getSystemService(Context.CLIPBOARD_SERVICE);cm.setPrimaryClip(ClipData.newPlainText("MeanVC2 rev46 activation v3 log",fullLog));Toast.makeText(this,"完整日志已复制",Toast.LENGTH_SHORT).show();});
        exportButton.setOnClickListener(v->startJsonExport());
        startBatch();
    }

    private void progress(String s){runOnUiThread(()->out.setText("REV46_ACTIVATION_V3_RUNNING\nphase="+s+"\n请保持应用前台，完成后可导出 JSON。"));}
    private void startBatch(){runButton.setEnabled(false);copyButton.setEnabled(false);exportButton.setEnabled(false);fullLog="";progress("startup");new Thread(()->{String x;try{x=runBatch();}catch(Throwable t){x="marker=REV46_ACTIVATION_V3_FATAL\nfatal_error="+err(t)+"\n";}fullLog=x;String y=x;runOnUiThread(()->{out.setText(y);runButton.setEnabled(true);copyButton.setEnabled(true);exportButton.setEnabled(true);});},"rev46-activation-v3").start();}

    private void startJsonExport(){
        if(fullLog==null||fullLog.isEmpty()){Toast.makeText(this,"尚无可导出的日志",Toast.LENGTH_SHORT).show();return;}
        Intent i=new Intent(Intent.ACTION_CREATE_DOCUMENT);i.addCategory(Intent.CATEGORY_OPENABLE);i.setType("application/json");i.putExtra(Intent.EXTRA_TITLE,"meanvc2-rev46-activation-v3-"+System.currentTimeMillis()+".json");startActivityForResult(i,EXPORT_JSON_REQUEST);
    }
    @Override protected void onActivityResult(int requestCode,int resultCode,Intent data){
        super.onActivityResult(requestCode,resultCode,data);
        if(requestCode!=EXPORT_JSON_REQUEST||resultCode!=RESULT_OK||data==null||data.getData()==null)return;
        Uri u=data.getData();
        try(OutputStream os=getContentResolver().openOutputStream(u,"w")){
            if(os==null)throw new IOException("openOutputStream returned null");
            byte[] raw=buildJsonExport(fullLog).getBytes(StandardCharsets.UTF_8);os.write(raw);os.flush();Toast.makeText(this,"JSON 日志已导出",Toast.LENGTH_LONG).show();
        }catch(Throwable t){Toast.makeText(this,"JSON 导出失败: "+t.getClass().getSimpleName(),Toast.LENGTH_LONG).show();}
    }
    private String buildJsonExport(String raw)throws Exception{
        JSONObject root=new JSONObject();root.put("schema",1);root.put("app_version",getPackageManager().getPackageInfo(getPackageName(),0).versionName);root.put("exported_at_epoch_ms",System.currentTimeMillis());root.put("raw_log_sha256",sha(raw.getBytes(StandardCharsets.UTF_8)));
        JSONArray a=new JSONArray();String[] lines=raw.split("\\n",-1);for(int i=0;i<lines.length;i++){if(i==lines.length-1&&lines[i].isEmpty())continue;String line=lines[i];int p=line.indexOf('=');JSONObject e=new JSONObject();e.put("index",i);if(p>=0){e.put("key",line.substring(0,p));e.put("value",line.substring(p+1));}else{e.put("key",JSONObject.NULL);e.put("value",line);}a.put(e);}root.put("entries",a);root.put("raw_log",raw);return root.toString(2)+"\n";
    }

    private String runBatch()throws Exception{
        StringBuilder b=new StringBuilder(512*1024);
        kv(b,"marker","REV46_ACTIVATION_V3_START");kv(b,"app_version",getPackageManager().getPackageInfo(getPackageName(),0).versionName);kv(b,"ort_version","1.27.0");kv(b,"qnn_runtime_version","2.44.0");kv(b,"material_improvement_threshold",MATERIAL);kv(b,"strict_cpu_fallback_disabled",true);kv(b,"source_payload_sha256",SOURCE_PAYLOAD_SHA);kv(b,"public_host_qualification_commit",PUBLIC_QUALIFICATION_COMMIT);kv(b,"frozen_fixture_policy","VALIDATION_DIAGNOSTIC_ONLY_NO_FITTING_NO_SEARCH");kv(b,"nonfinal_stress_policy","ELIGIBLE_FOR_STRUCTURAL_SENSITIVITY_NOT_FINAL_QUALIFICATION");kv(b,"providers",String.valueOf(OrtEnvironment.getAvailableProviders()));
        if(!OrtEnvironment.getAvailableProviders().contains(OrtProvider.QNN))throw new IllegalStateException("QNN provider unavailable");
        progress("verify-assets");verifyModelAssets(b);
        OrtEnvironment env=OrtEnvironment.getEnvironment();
        progress("cpu-reference");
        Map<String,Matrix> baseCpu=new LinkedHashMap<>(),candCpu=new LinkedHashMap<>();
        for(String shape:new String[]{"cold4","warm6"}){Matrix bm=runShape(env,shape,"baseline",null,0,b),cm=runShape(env,shape,"candidate",null,0,b);baseCpu.put(shape,bm);candCpu.put(shape,cm);logCpuOracleChecks(b,shape,"baseline",bm);logCpuOracleChecks(b,shape,"candidate",cm);logSemanticDelta(b,shape);}
        int htpSessionOk=0,htpSessionFail=0;boolean prodRepeatAll=true;
        for(Cfg cfg:CONFIGS){
            for(String shape:new String[]{"cold4","warm6"}){
                progress("htp-"+cfg.id+"-"+shape);
                Matrix bm=runShape(env,shape,"baseline",cfg,0,b),cm=runShape(env,shape,"candidate",cfg,0,b);
                if(bm.error.isEmpty())htpSessionOk++;else htpSessionFail++;if(cm.error.isEmpty())htpSessionOk++;else htpSessionFail++;
                logComparison(b,cfg.id,shape,bm,cm,baseCpu.get(shape),candCpu.get(shape));appendProfile(b,cfg.id+"_"+shape+"_baseline",bm);appendProfile(b,cfg.id+"_"+shape+"_candidate",cm);
                if(cfg.repeat){
                    progress("htp-"+cfg.id+"-"+shape+"-fresh-repeat");
                    Matrix br=runShape(env,shape,"baseline",cfg,1,b),cr=runShape(env,shape,"candidate",cfg,1,b);
                    if(br.error.isEmpty())htpSessionOk++;else htpSessionFail++;if(cr.error.isEmpty())htpSessionOk++;else htpSessionFail++;
                    boolean be=logRepeat(b,cfg.id+"_"+shape+"_baseline",bm,br),ce=logRepeat(b,cfg.id+"_"+shape+"_candidate",cm,cr);prodRepeatAll&=be&&ce;appendProfile(b,cfg.id+"_"+shape+"_baseline_repeat",br);appendProfile(b,cfg.id+"_"+shape+"_candidate_repeat",cr);
                }
            }
        }
        kv(b,"htp_session_success_count",htpSessionOk);kv(b,"htp_session_failure_count",htpSessionFail);kv(b,"prod_fresh_session_repeat_all_outputs_exact",prodRepeatAll);kv(b,"interpretation_guard","ACTIVATION_ONLY_DIAGNOSTIC;NO_FINAL_FULL_VOCOS_PASS;NO_THRESHOLD_RELAXATION;NO_FROZEN_FIXTURE_FITTING;NO_CPU_FALLBACK");kv(b,"marker","REV46_ACTIVATION_V3_COMPLETE");return b.toString();
    }

    private void verifyModelAssets(StringBuilder b)throws Exception{
        int ok=0;for(Map.Entry<String,String> e:MODEL_SHA.entrySet()){byte[] raw=asset("models/"+e.getKey());String got=sha(raw);kv(b,"model_"+e.getKey()+"_bytes",raw.length);kv(b,"model_"+e.getKey()+"_sha256",got);if(!got.equals(e.getValue()))throw new IllegalStateException("model drift "+e.getKey()+" "+got);ok++;}kv(b,"verified_model_count",ok);
    }
    private String modelAsset(String shape,String model){return "models/"+shape+"_"+(model.equals("baseline")?"baseline_contrib_gelu":"candidate_exact_activation")+".onnx";}
    private Matrix runShape(OrtEnvironment env,String shape,String model,Cfg cfg,int repeat,StringBuilder b){
        Matrix mx=new Matrix();String tag=(cfg==null?"cpu":cfg.id)+(repeat>0?"_repeat":"");String prefix="activation_"+model+"_"+shape+"_"+tag;
        try{byte[] mb=asset(modelAsset(shape,model));OrtSession.SessionOptions so;if(cfg==null)so=cpuOptions();else{File pd=new File(getFilesDir(),"profiles");pd.mkdirs();File csv=new File(pd,prefix+".csv"),ql=new File(pd,prefix+"_qnn.log");deleteQuiet(csv);deleteQuiet(ql);mx.profileCsv=csv;mx.qnnLog=ql;so=qnnOptions(cfg,csv);}long sc=System.nanoTime();try(OrtSession.SessionOptions opts=so;OrtSession s=env.createSession(mb,opts)){mx.createMs=(System.nanoTime()-sc)/1e6;kv(b,prefix+"_session_create_ms",mx.createMs);for(Fixture f:FIXTURES){if(!f.shape.equals(shape))continue;OutputSet r=runFixture(env,s,f);mx.runs.put(f.id,r);kv(b,prefix+"_"+f.id+"_ok",r.ok());kv(b,prefix+"_"+f.id+"_run_ms",r.runMs);if(!r.ok())kv(b,prefix+"_"+f.id+"_error",r.error);}}}
        catch(Throwable t){mx.error=err(t);kv(b,prefix+"_session_error",mx.error);for(Fixture f:FIXTURES)if(f.shape.equals(shape)){OutputSet r=new OutputSet();r.error=mx.error;mx.runs.put(f.id,r);}}return mx;
    }
    private OutputSet runFixture(OrtEnvironment env,OrtSession s,Fixture f){OutputSet o=new OutputSet();try{float[] x=f.assetBacked?assetFloats(f.preactAsset,f.t*PREACT):stressPreact(f);FloatBuffer fb=direct(x);long st=System.nanoTime();try(OnnxTensor pt=OnnxTensor.createTensor(env,fb,new long[]{1,f.t,PREACT});OrtSession.Result rr=s.run(Collections.singletonMap("preact",pt))){o.runMs=(System.nanoTime()-st)/1e6;o.y=read(rr,"activation");}if(o.y.length!=f.t*PREACT)throw new IllegalStateException("activation geometry "+f.id);}catch(Throwable t){o.error=err(t);}return o;}

    private void logCpuOracleChecks(StringBuilder b,String shape,String model,Matrix cpu)throws Exception{for(Fixture f:FIXTURES){if(!f.shape.equals(shape))continue;kv(b,"fixture_"+f.id+"_role",f.role);OutputSet r=cpu.runs.get(f.id);if(!f.assetBacked||r==null||!r.ok())continue;float[] oracle=assetFloats("oracle/"+model+"_"+f.id+"_activation.f32",r.y.length);metricKv(b,"cpu_"+model+"_"+f.id+"_activation_vs_frozen_host_ort127",metric(oracle,r.y));}}
    private void logSemanticDelta(StringBuilder b,String shape)throws Exception{for(Fixture f:FIXTURES){if(!f.shape.equals(shape)||!f.assetBacked)continue;float[] a=assetFloats("oracle/baseline_"+f.id+"_activation.f32",f.t*PREACT),c=assetFloats("oracle/candidate_"+f.id+"_activation.f32",f.t*PREACT);metricKv(b,"host_semantic_candidate_vs_baseline_"+f.id+"_activation",metric(a,c));}}
    private void logComparison(StringBuilder b,String cfg,String shape,Matrix base,Matrix cand,Matrix baseCpu,Matrix candCpu)throws Exception{for(Fixture f:FIXTURES){if(!f.shape.equals(shape))continue;OutputSet br=base.runs.get(f.id),cr=cand.runs.get(f.id);String p="activation_"+cfg+"_"+shape+"_"+f.id;if(br==null||cr==null||!br.ok()||!cr.ok()){kv(b,p+"_comparison","unavailable");continue;}float[] teacher=f.assetBacked?assetFloats("oracle/baseline_"+f.id+"_activation.f32",br.y.length):requireCpuReference(baseCpu,f);float[] candOracle=f.assetBacked?assetFloats("oracle/candidate_"+f.id+"_activation.f32",cr.y.length):requireCpuReference(candCpu,f);Metric be=metric(teacher,br.y),ct=metric(teacher,cr.y),cb=metric(candOracle,cr.y);metricKv(b,p+"_baseline_htp_vs_teacher",be);metricKv(b,p+"_candidate_htp_vs_teacher",ct);metricKv(b,p+"_candidate_backend_vs_own_cpu",cb);metricKv(b,p+"_candidate_htp_vs_baseline_htp",metric(br.y,cr.y));double imp=be.rmse==0?Double.NaN:(be.rmse-ct.rmse)/be.rmse;kv(b,p+"_rmse_improvement_fraction",imp);kv(b,p+"_material_ge_3pct",Double.isFinite(imp)&&imp>=MATERIAL);}}
    private static float[] requireCpuReference(Matrix cpu,Fixture f){OutputSet r=cpu.runs.get(f.id);if(r==null||!r.ok()||r.y==null)throw new IllegalStateException("missing CPU reference "+f.id);return r.y;}
    private boolean logRepeat(StringBuilder b,String p,Matrix first,Matrix second){boolean all=true;for(Fixture f:FIXTURES){OutputSet a=first.runs.get(f.id),c=second.runs.get(f.id);if(a==null&&c==null)continue;if(a==null||c==null||!a.ok()||!c.ok()){all=false;continue;}boolean ex=bits(a.y,c.y);all&=ex;kv(b,p+"_"+f.id+"_repeat_exact_bits",ex);metricKv(b,p+"_"+f.id+"_repeat_metric",metric(a.y,c.y));}kv(b,p+"_repeat_all_exact",all);return all;}
    private void appendProfile(StringBuilder b,String id,Matrix m)throws Exception{File f=m.profileCsv;if(f==null||!f.isFile()){kv(b,"profile_"+id+"_present",false);return;}byte[] raw=fileBytes(f);kv(b,"profile_"+id+"_present",true);kv(b,"profile_"+id+"_bytes",raw.length);kv(b,"profile_"+id+"_sha256",sha(raw));b.append("profile_").append(id).append("_csv_begin\n");String s=new String(raw,StandardCharsets.UTF_8);if(s.length()>120000)s=s.substring(0,120000)+"\n[TRUNCATED]\n";b.append(s);if(!s.endsWith("\n"))b.append('\n');b.append("profile_").append(id).append("_csv_end\n");if(m.qnnLog!=null&&m.qnnLog.isFile()){byte[] q=fileBytes(m.qnnLog);kv(b,"profile_"+id+"_qnn_log_bytes",q.length);kv(b,"profile_"+id+"_qnn_log_sha256",sha(q));}}

    private float[] stressPreact(Fixture f){int n=f.t*PREACT;float[] x=new float[n];if(f.id.contains("critical")){float[] v={0f,-0f,1e-6f,-1e-6f,.01f,-.01f,.1f,-.1f,.5f,-.5f,1f,-1f,2f,-2f,3f,-3f,4f,-4f,6f,-6f,8f,-8f};for(int i=0;i<n;i++)x[i]=v[i%v.length];}else if(f.id.contains("sweep")){for(int i=0;i<n;i++)x[i]=-8f+16f*((i%257)/256f);}else{long s=0x20260820L;for(int i=0;i<n;i++){s=s*6364136223846793005L+1442695040888963407L;x[i]=(float)((((s>>>40)&0xffffff)/(double)0x800000)-1.0)*2.5f;}}return x;}
    private OrtSession.SessionOptions cpuOptions()throws OrtException{OrtSession.SessionOptions o=new OrtSession.SessionOptions();o.setInterOpNumThreads(1);o.setIntraOpNumThreads(1);return o;}
    private OrtSession.SessionOptions qnnOptions(Cfg cfg,File profile)throws OrtException{OrtSession.SessionOptions o=cpuOptions();LinkedHashMap<String,String> q=new LinkedHashMap<>();q.put("backend_type","htp");q.put("htp_performance_mode","burst");q.put("qnn_context_priority","high");q.put("htp_graph_finalization_optimization_mode",cfg.opt);q.put("enable_htp_fp16_precision",cfg.fp16);q.put("offload_graph_io_quantization","0");if(cfg.profile&&profile!=null){q.put("profiling_level","detailed");q.put("profiling_file_path",profile.getAbsolutePath());}o.addQnn(q);o.addConfigEntry("session.disable_cpu_ep_fallback","1");return o;}

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
