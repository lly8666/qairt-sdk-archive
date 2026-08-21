package com.simadmin.meanvc2rev46embedsplit4;

import ai.onnxruntime.*;
import android.app.Activity;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.graphics.Typeface;
import android.os.Bundle;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;
import java.io.*;
import java.nio.*;
import java.security.MessageDigest;
import java.util.*;

/** Focused frozen REV46 embed-Conv split4 mechanism diagnostic; not a full-model gate. */
public final class MainActivity extends Activity {
    private static final String BASE="canonical_embed_conv.onnx";
    private static final String SPLIT="split4_embed_conv.onnx";
    private static final String PROV="MODEL_PROVENANCE.json";
    private static final String[] PATTERNS={"zero","half","sweep","sine","seed20260821","spike_mix"};
    private static final String[][] CONFIGS={{"prod_fp16_opt3","1","3"},{"fp32ctl_opt3","0","3"},{"prod_fp16_opt0","1","0"}};
    private TextView result; private Button run,copy; private volatile String fullLog="";

    @Override public void onCreate(Bundle b){
        super.onCreate(b);
        LinearLayout root=new LinearLayout(this); root.setOrientation(LinearLayout.VERTICAL); root.setPadding(20,20,20,20);
        TextView title=new TextView(this);
        title.setText("MeanVC2 REV46 · Frozen Embed Conv Split4\nFocused HTP A/B · canonical vs split4\n不打开 warm18 / final A/B/C，不是 full-model 晋级门");
        title.setTypeface(Typeface.DEFAULT_BOLD); title.setTextSize(16); root.addView(title);
        run=new Button(this); run.setText("运行 Frozen Split4 HTP A/B"); root.addView(run);
        copy=new Button(this); copy.setText("复制完整 UTF-8 日志"); copy.setEnabled(false); root.addView(copy);
        ScrollView sv=new ScrollView(this); result=new TextView(this); result.setTypeface(Typeface.MONOSPACE); result.setTextSize(11); result.setTextIsSelectable(true);
        result.setText("READY\n严格策略：QNN HTP + session.disable_cpu_ep_fallback=1。\n结果只回答 embed split4 在本机 HTP 的 focused 数值行为。\n");
        sv.addView(result); root.addView(sv,new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,0,1f)); setContentView(root);
        run.setOnClickListener(v->start());
        copy.setOnClickListener(v->{ClipboardManager cm=(ClipboardManager)getSystemService(Context.CLIPBOARD_SERVICE);cm.setPrimaryClip(ClipData.newPlainText("REV46 frozen embed split4",fullLog));Toast.makeText(this,"完整日志已复制",Toast.LENGTH_SHORT).show();});
    }

    private void start(){
        run.setEnabled(false); copy.setEnabled(false); result.setText("RUNNING...\n");
        new Thread(()->{String s;try{s=runAll();}catch(Throwable t){StringWriter w=new StringWriter();t.printStackTrace(new PrintWriter(w));s="REV46_EMBED_SPLIT4_FATAL\n"+w;}fullLog=s;String x=s;runOnUiThread(()->{result.setText(x);run.setEnabled(true);copy.setEnabled(true);});},"Rev46EmbedSplit4").start();
    }

    private String runAll() throws Exception {
        StringBuilder o=new StringBuilder(128*1024); long all=System.nanoTime();
        kv(o,"marker","REV46_FROZEN_EMBED_SPLIT4_DEVICE_BEGIN");
        kv(o,"scope","FOCUSED_FROZEN_SPLIT4_MECHANISM_DIAGNOSTIC_NOT_FULL_MODEL_GATE");
        kv(o,"frozen_full_model_source_authority_sha256","5d933a1a13f9147287f05958577b298b367a7b6b288570f94dd09939fd535c6c");
        kv(o,"frozen_parent_execution_sha256","d2efac4f266b312024b0e0b59feeeffa04716dbeaf54ad4763c7950ac9c3fb23");
        kv(o,"historical_stage1_max_improvement_pct",23.6364);
        kv(o,"historical_stage2_max_change_pct",0.3322259136212624);
        kv(o,"historical_stage2_rmse_improvement_pct",7.87);
        kv(o,"historical_stage2_mean_improvement_pct",12.54);
        kv(o,"protected_inputs_used",false); kv(o,"warm18_used",false); kv(o,"final_abc_used",false); kv(o,"seed_20260814_used",false);
        kv(o,"ort_version",OrtEnvironment.getVersion()); kv(o,"providers",OrtEnvironment.getAvailableProviders()); kv(o,"qnn_runtime_requested","2.44.0"); kv(o,"cpu_fallback_disabled",true);
        String base=materialize(BASE,o), split=materialize(SPLIT,o); appendAssetText(PROV,o);
        if(!OrtEnvironment.getAvailableProviders().contains(OrtProvider.QNN)){kv(o,"marker_final","REV46_FROZEN_EMBED_SPLIT4_QNN_PROVIDER_MISSING");return o.toString();}

        OrtEnvironment env=OrtEnvironment.getEnvironment();
        LinkedHashMap<String,float[]> cpuBase=new LinkedHashMap<>(),cpuSplit=new LinkedHashMap<>();
        try(OrtSession.SessionOptions so=cpuOptions(); OrtSession sb=env.createSession(base,so); OrtSession.SessionOptions so2=cpuOptions(); OrtSession ss=env.createSession(split,so2)){
            for(String p:PATTERNS){float[] x=input(p);float[] a=execute(env,sb,x),b=execute(env,ss,x);cpuBase.put(p,a);cpuSplit.put(p,b);appendMetric(o,"cpu/"+p+"/split4_vs_canonical",metric(a,b));}
        }
        double cpuMax=0; for(String p:PATTERNS) cpuMax=Math.max(cpuMax,metric(cpuBase.get(p),cpuSplit.get(p)).max);
        kv(o,"cpu_semantic_aggregate_max_abs",cpuMax); kv(o,"cpu_semantic_gate_le_5e-6",cpuMax<=5e-6);
        if(cpuMax>5e-6){kv(o,"marker_final","REV46_FROZEN_EMBED_SPLIT4_CPU_SEMANTIC_FAIL");return o.toString();}

        LinkedHashMap<String,float[]> prodBase=new LinkedHashMap<>(),prodSplit=new LinkedHashMap<>();
        for(String[] cfg:CONFIGS){String id=cfg[0];boolean fp16="1".equals(cfg[1]);int opt=Integer.parseInt(cfg[2]);
            runQnnConfig(o,env,id,fp16,opt,base,split,cpuBase,cpuSplit,"prod_fp16_opt3".equals(id)?prodBase:null,"prod_fp16_opt3".equals(id)?prodSplit:null);
        }
        // Fresh-session repeat for the production HTP control; exact bits are useful stability evidence.
        LinkedHashMap<String,float[]> repBase=new LinkedHashMap<>(),repSplit=new LinkedHashMap<>();
        runQnnConfig(o,env,"prod_fp16_opt3_repeat",true,3,base,split,cpuBase,cpuSplit,repBase,repSplit);
        boolean repeat=true; for(String p:PATTERNS){repeat &= bitsEqual(prodBase.get(p),repBase.get(p));repeat &= bitsEqual(prodSplit.get(p),repSplit.get(p));kv(o,"repeat/"+p+"/canonical_exact_bits",bitsEqual(prodBase.get(p),repBase.get(p)));kv(o,"repeat/"+p+"/split4_exact_bits",bitsEqual(prodSplit.get(p),repSplit.get(p)));}
        kv(o,"prod_fresh_session_repeat_exact_all",repeat);
        kv(o,"elapsed_ms_total",ms(all)); kv(o,"marker_final","REV46_FROZEN_EMBED_SPLIT4_DEVICE_EVIDENCE_COMPLETE");
        kv(o,"interpretation_guard","FOCUSED_EMBED_CONV_RESULT_ONLY; DO_NOT_PROMOTE_OR_REJECT_FULL_VOCOS_FROM_THIS APK ALONE");
        return o.toString();
    }

    private void runQnnConfig(StringBuilder o,OrtEnvironment env,String id,boolean fp16,int opt,String base,String split,Map<String,float[]> cpuBase,Map<String,float[]> cpuSplit,Map<String,float[]> keepBase,Map<String,float[]> keepSplit)throws Exception{
        String prefix="qnn/"+id; long c0=System.nanoTime();
        try(OrtSession.SessionOptions sbo=qnnOptions(fp16,opt); OrtSession sb=env.createSession(base,sbo); OrtSession.SessionOptions sso=qnnOptions(fp16,opt); OrtSession ss=env.createSession(split,sso)){
            kv(o,prefix+"/sessions_create_ms",ms(c0));
            double sumBaseMax=0,sumSplitMax=0,sumBaseMean=0,sumSplitMean=0,sumBaseRmse=0,sumSplitRmse=0;int n=0;
            for(String p:PATTERNS){float[] x=input(p);long r0=System.nanoTime();float[] qb=execute(env,sb,x);double bms=ms(r0);r0=System.nanoTime();float[] qs=execute(env,ss,x);double sms=ms(r0);if(keepBase!=null)keepBase.put(p,qb);if(keepSplit!=null)keepSplit.put(p,qs);
                Metric mb=metric(cpuBase.get(p),qb),ms=metric(cpuSplit.get(p),qs),cross=metric(qb,qs),sem=metric(cpuBase.get(p),cpuSplit.get(p));
                appendMetric(o,prefix+"/"+p+"/canonical_vs_own_cpu",mb);appendMetric(o,prefix+"/"+p+"/split4_vs_own_cpu",ms);appendMetric(o,prefix+"/"+p+"/split4_qnn_vs_canonical_qnn",cross);appendMetric(o,prefix+"/"+p+"/cpu_semantic",sem);
                kv(o,prefix+"/"+p+"/canonical_exec_ms",bms);kv(o,prefix+"/"+p+"/split4_exec_ms",sms);
                kv(o,prefix+"/"+p+"/max_improvement_pct",improve(mb.max,ms.max));kv(o,prefix+"/"+p+"/mean_improvement_pct",improve(mb.mean,ms.mean));kv(o,prefix+"/"+p+"/rmse_improvement_pct",improve(mb.rmse,ms.rmse));
                sumBaseMax+=mb.max;sumSplitMax+=ms.max;sumBaseMean+=mb.mean;sumSplitMean+=ms.mean;sumBaseRmse+=mb.rmse;sumSplitRmse+=ms.rmse;n++;
            }
            kv(o,prefix+"/aggregate_mean_of_case_max_canonical",sumBaseMax/n);kv(o,prefix+"/aggregate_mean_of_case_max_split4",sumSplitMax/n);kv(o,prefix+"/aggregate_mean_of_case_max_improvement_pct",improve(sumBaseMax,sumSplitMax));
            kv(o,prefix+"/aggregate_mean_abs_canonical",sumBaseMean/n);kv(o,prefix+"/aggregate_mean_abs_split4",sumSplitMean/n);kv(o,prefix+"/aggregate_mean_abs_improvement_pct",improve(sumBaseMean,sumSplitMean));
            kv(o,prefix+"/aggregate_rmse_canonical",sumBaseRmse/n);kv(o,prefix+"/aggregate_rmse_split4",sumSplitRmse/n);kv(o,prefix+"/aggregate_rmse_improvement_pct",improve(sumBaseRmse,sumSplitRmse));
        }catch(Throwable t){kv(o,prefix+"/session_error",err(t));if(keepBase!=null)keepBase.clear();if(keepSplit!=null)keepSplit.clear();}
    }

    private static OrtSession.SessionOptions cpuOptions()throws OrtException{OrtSession.SessionOptions s=new OrtSession.SessionOptions();s.setInterOpNumThreads(1);s.setIntraOpNumThreads(1);return s;}
    private static OrtSession.SessionOptions qnnOptions(boolean fp16,int opt)throws OrtException{OrtSession.SessionOptions s=cpuOptions();LinkedHashMap<String,String> q=new LinkedHashMap<>();q.put("backend_type","htp");q.put("htp_performance_mode","burst");q.put("qnn_context_priority","high");q.put("htp_graph_finalization_optimization_mode",Integer.toString(opt));q.put("enable_htp_fp16_precision",fp16?"1":"0");q.put("offload_graph_io_quantization","0");s.addQnn(q);s.addConfigEntry("session.disable_cpu_ep_fallback","1");return s;}

    private static float[] execute(OrtEnvironment env,OrtSession s,float[] x)throws Exception{FloatBuffer b=ByteBuffer.allocateDirect(x.length*4).order(ByteOrder.nativeOrder()).asFloatBuffer();b.put(x).rewind();try(OnnxTensor t=OnnxTensor.createTensor(env,b,new long[]{1,80,6});OrtSession.Result r=s.run(Collections.singletonMap("x",t))){OnnxValue v=r.get("y").orElseThrow();FloatBuffer f=((OnnxTensor)v).getFloatBuffer();f.rewind();float[] y=new float[f.remaining()];f.get(y);for(float z:y)if(!Float.isFinite(z))throw new IllegalStateException("non-finite output");return y;}}

    private static float[] input(String p){int n=80*6;float[] x=new float[n];if("zero".equals(p))return x;if("half".equals(p)){Arrays.fill(x,0.5f);return x;}if("sweep".equals(p)){for(int i=0;i<n;i++)x[i]=(float)(-3.0+6.0*i/(double)(n-1));return x;}if("sine".equals(p)){for(int i=0;i<n;i++)x[i]=(float)(1.5*Math.sin(i*0.173)+0.35*Math.cos(i*0.071));return x;}if("spike_mix".equals(p)){for(int i=0;i<n;i++)x[i]=(i%97==0)?3.25f:(i%89==0)?-2.75f:(float)(0.1*Math.sin(i));return x;}long st=20260821L^0x9e3779b97f4a7c15L;for(int i=0;i<n;i++){st^=st<<13;st^=st>>>7;st^=st<<17;double u=((st>>>11)&((1L<<53)-1))/(double)(1L<<53);x[i]=(float)(-2.5+5.0*u);}return x;}

    private String materialize(String name,StringBuilder o)throws Exception{File d=new File(getFilesDir(),"models");if(!d.isDirectory()&&!d.mkdirs())throw new IOException("mkdir models");File f=new File(d,name);try(InputStream in=getAssets().open("models/"+name);OutputStream out=new FileOutputStream(f)){byte[] b=new byte[8192];for(int n;(n=in.read(b))>0;)out.write(b,0,n);}kv(o,"model/"+name+"/sha256",sha(f));kv(o,"model/"+name+"/bytes",f.length());return f.getAbsolutePath();}
    private void appendAssetText(String name,StringBuilder o)throws Exception{StringBuilder s=new StringBuilder();try(BufferedReader r=new BufferedReader(new InputStreamReader(getAssets().open("models/"+name)))){for(String line;(line=r.readLine())!=null;)s.append(line).append('\n');}kv(o,"model_provenance_json",s.toString().replace("\n","\\n"));}
    private static Metric metric(float[] a,float[] b){if(a==null||b==null||a.length!=b.length)return Metric.nan();double max=0,sum=0,sq=0,dot=0,aa=0,bb=0;for(int i=0;i<a.length;i++){double d=(double)b[i]-a[i],ad=Math.abs(d);max=Math.max(max,ad);sum+=ad;sq+=d*d;dot+=(double)a[i]*b[i];aa+=(double)a[i]*a[i];bb+=(double)b[i]*b[i];}return new Metric(max,sum/a.length,Math.sqrt(sq/a.length),aa==0||bb==0?1:dot/Math.sqrt(aa*bb));}
    private static double improve(double base,double cand){return base==0?(cand==0?0:Double.NEGATIVE_INFINITY):(base-cand)*100.0/base;}
    private static boolean bitsEqual(float[] a,float[] b){if(a==null||b==null||a.length!=b.length)return false;for(int i=0;i<a.length;i++)if(Float.floatToRawIntBits(a[i])!=Float.floatToRawIntBits(b[i]))return false;return true;}
    private static void appendMetric(StringBuilder o,String k,Metric m){kv(o,k+"/max_abs",m.max);kv(o,k+"/mean_abs",m.mean);kv(o,k+"/rmse",m.rmse);kv(o,k+"/cosine",m.cos);}
    private static void kv(StringBuilder o,String k,Object v){o.append(k).append('=').append(String.valueOf(v)).append('\n');}
    private static double ms(long start){return (System.nanoTime()-start)/1e6;}
    private static String err(Throwable t){return t.getClass().getName()+":"+String.valueOf(t.getMessage()).replace('\n',' ');}
    private static String sha(File f)throws Exception{MessageDigest d=MessageDigest.getInstance("SHA-256");try(InputStream in=new FileInputStream(f)){byte[] b=new byte[8192];for(int n;(n=in.read(b))>0;)d.update(b,0,n);}StringBuilder s=new StringBuilder();for(byte x:d.digest())s.append(String.format(Locale.ROOT,"%02x",x));return s.toString();}
    static final class Metric{final double max,mean,rmse,cos;Metric(double a,double b,double c,double d){max=a;mean=b;rmse=c;cos=d;}static Metric nan(){return new Metric(Double.NaN,Double.NaN,Double.NaN,Double.NaN);}}
}
