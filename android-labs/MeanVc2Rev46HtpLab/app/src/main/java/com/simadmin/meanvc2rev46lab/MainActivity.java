package com.simadmin.meanvc2rev46lab;

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

/** Public model-only diagnostic. Contains no SimAdmin communication/application source. */
public final class MainActivity extends Activity {
    static final String[] VARIANTS={"canonical_gelu","split_exact_gelu","ch60d16_pairwise","erf_only","identity"};
    static final int[] TS={4,6};
    static final String[] PATTERNS={"cold_stats","warm1_stats","warm18_stats","warm47_stats","sweep","zero_dense"};
    static final double[] PROB={0,.001,.01,.1,.25,.5,.75,.9,.99,.999,1};
    static final double[][] Q={
        {-8.4772892,-5.08938971,-3.4461097,-2.1662473,-1.5597198,-.822880179,-.146996483,.370754474,1.34265692,2.17951396,3.53695297},
        {-9.1483593,-5.21358066,-3.38701866,-2.21102405,-1.57639638,-.820299327,-.158971712,.343113333,1.33261229,2.45421657,4.06086397},
        {-8.04026222,-5.2547115,-3.3702436,-2.17303634,-1.48813045,-.793013632,-.147588652,.387338921,1.33351879,2.10703582,2.84715343},
        {-7.23906565,-5.24121452,-3.71751386,-2.4089061,-1.66610691,-.880330354,-.113816034,.461173072,1.39694569,2.49848933,2.89348221}
    };
    static final String[][] CONFIGS={{"prod","1","3"},{"fp32ctl","0","3"},{"opt0ctl","1","0"}};
    private TextView result; private Button run,copy; private volatile String fullLog="";

    @Override public void onCreate(Bundle b){
        super.onCreate(b);
        LinearLayout root=new LinearLayout(this);root.setOrientation(LinearLayout.VERTICAL);root.setPadding(20,20,20,20);
        TextView title=new TextView(this);title.setText("MeanVC2 rev46 · HTP lowering batch lab\n一次运行：5图族 × T4/T6 × 6输入 × CPU/3 HTP配置 + prod fresh-session repeat");title.setTypeface(Typeface.DEFAULT_BOLD);title.setTextSize(16);root.addView(title);
        run=new Button(this);run.setText("运行全部 Rev46 批量诊断");root.addView(run);
        copy=new Button(this);copy.setText("复制完整 UTF-8 日志");copy.setEnabled(false);root.addView(copy);
        ScrollView sv=new ScrollView(this);result=new TextView(this);result.setTypeface(Typeface.MONOSPACE);result.setTextSize(11);result.setTextIsSelectable(true);result.setText("READY\n严格策略：HTP + session.disable_cpu_ep_fallback=1；不做最终 full-model gate。\n");sv.addView(result);root.addView(sv,new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,0,1f));setContentView(root);
        run.setOnClickListener(v->start());
        copy.setOnClickListener(v->{ClipboardManager cm=(ClipboardManager)getSystemService(Context.CLIPBOARD_SERVICE);cm.setPrimaryClip(ClipData.newPlainText("MeanVC2 rev46 HTP lab",fullLog));Toast.makeText(this,"完整日志已复制",Toast.LENGTH_SHORT).show();});
    }
    private void start(){run.setEnabled(false);copy.setEnabled(false);result.setText("RUNNING...\n");new Thread(()->{String s;try{s=runAll();}catch(Throwable t){StringWriter w=new StringWriter();t.printStackTrace(new PrintWriter(w));s="REV46_HTP_BATCH_FATAL\n"+w;}fullLog=s;String x=s;runOnUiThread(()->{result.setText(x);run.setEnabled(true);copy.setEnabled(true);});},"Rev46HtpBatch").start();}

    private String runAll() throws Exception {
        StringBuilder o=new StringBuilder(256*1024);long all=System.nanoTime();
        kv(o,"marker","REV46_HTP_LOWERING_BATCH_BEGIN");kv(o,"scope","FOCUSED_PUBLIC_MODEL_ONLY_DIAGNOSTIC_NOT_FINAL_FULL_MODEL_GATE");kv(o,"ort_version",OrtEnvironment.getVersion());kv(o,"providers",OrtEnvironment.getAvailableProviders());kv(o,"qnn_runtime_requested","2.44.0");kv(o,"cpu_fallback_disabled",true);kv(o,"threshold_relaxation",false);kv(o,"production_integration",false);
        if(!OrtEnvironment.getAvailableProviders().contains(OrtProvider.QNN)){kv(o,"marker_final","REV46_HTP_LOWERING_BATCH_QNN_PROVIDER_MISSING");return o.toString();}
        OrtEnvironment env=OrtEnvironment.getEnvironment();Map<String,float[]> cpu=new HashMap<>(),prod=new HashMap<>(),prodRepeat=new HashMap<>();Map<String,RunMeta> meta=new LinkedHashMap<>();
        for(int T:TS)for(String v:VARIANTS){String model=materializeModel(v,T,o);try(OrtSession.SessionOptions so=cpuOptions()){long c0=System.nanoTime();try(OrtSession s=env.createSession(model,so)){RunMeta rm=new RunMeta();rm.createMs=ms(c0);rm.ok=true;for(String p:PATTERNS){long r0=System.nanoTime();float[] y=execute(env,s,input(p,T),T);rm.execMs+=ms(r0);cpu.put(key(T,v,p),y);}meta.put("cpu/T"+T+"/"+v,rm);}}}
        appendCpuSemanticCross(o,cpu);
        for(String[] cfg:CONFIGS){String id=cfg[0];boolean fp16="1".equals(cfg[1]);int opt=Integer.parseInt(cfg[2]);for(int T:TS)for(String v:VARIANTS){String base="qnn/"+id+"/T"+T+"/"+v;try(OrtSession.SessionOptions so=qnnOptions(fp16,opt)){long c0=System.nanoTime();try(OrtSession s=env.createSession(modelPath(v,T),so)){RunMeta rm=new RunMeta();rm.createMs=ms(c0);rm.ok=true;for(String p:PATTERNS){long r0=System.nanoTime();float[] y=execute(env,s,input(p,T),T);rm.execMs+=ms(r0);String k=key(T,v,p);appendMetric(o,base+"/"+p+"/vs_cpu",metric(cpu.get(k),y));if("prod".equals(id))prod.put(k,y);}meta.put(base,rm);}}catch(Throwable t){RunMeta rm=new RunMeta();rm.error=err(t);meta.put(base,rm);kv(o,base+"/session_error",rm.error);}}}
        for(int T:TS)for(String v:VARIANTS){String base="qnn/prod_repeat/T"+T+"/"+v;try(OrtSession.SessionOptions so=qnnOptions(true,3)){long c0=System.nanoTime();try(OrtSession s=env.createSession(modelPath(v,T),so)){RunMeta rm=new RunMeta();rm.createMs=ms(c0);rm.ok=true;for(String p:PATTERNS){float[] y=execute(env,s,input(p,T),T);String k=key(T,v,p);prodRepeat.put(k,y);kv(o,base+"/"+p+"/exact_bits",bitsEqual(prod.get(k),y));}meta.put(base,rm);}}catch(Throwable t){RunMeta rm=new RunMeta();rm.error=err(t);meta.put(base,rm);kv(o,base+"/session_error",rm.error);}}
        appendQnnCross(o,prod,cpu);
        for(Map.Entry<String,RunMeta> e:meta.entrySet()){kv(o,e.getKey()+"/create_ms",e.getValue().createMs);kv(o,e.getKey()+"/exec_ms_total",e.getValue().execMs);if(e.getValue().error!=null)kv(o,e.getKey()+"/error",e.getValue().error);}
        boolean allProdRepeat=!prod.isEmpty();for(String k:prod.keySet())allProdRepeat&=bitsEqual(prod.get(k),prodRepeat.get(k));kv(o,"prod_fresh_session_repeat_exact_all_completed",allProdRepeat);kv(o,"elapsed_ms_total",ms(all));kv(o,"marker_final","REV46_HTP_LOWERING_BATCH_EVIDENCE_COMPLETE");kv(o,"interpretation_guard","DO_NOT_TREAT_FOCUSED_ACTIVATION_RESULT_AS_FINAL_FULL_VOCOS_ACCEPTANCE");return o.toString();
    }
    private void appendCpuSemanticCross(StringBuilder o,Map<String,float[]> cpu){for(int T:TS)for(String p:PATTERNS){appendMetric(o,"cpu/T"+T+"/"+p+"/split_exact_vs_canonical",metric(cpu.get(key(T,"canonical_gelu",p)),cpu.get(key(T,"split_exact_gelu",p))));appendMetric(o,"cpu/T"+T+"/"+p+"/ch60d16_vs_canonical",metric(cpu.get(key(T,"canonical_gelu",p)),cpu.get(key(T,"ch60d16_pairwise",p))));}}
    private void appendQnnCross(StringBuilder o,Map<String,float[]> q,Map<String,float[]> cpu){for(int T:TS)for(String p:PATTERNS){float[] c=q.get(key(T,"canonical_gelu",p)),s=q.get(key(T,"split_exact_gelu",p)),poly=q.get(key(T,"ch60d16_pairwise",p));if(c!=null&&s!=null){appendMetric(o,"qnn/prod/T"+T+"/"+p+"/split_exact_vs_canonical",metric(c,s));Metric mc=metric(cpu.get(key(T,"canonical_gelu",p)),c),ms=metric(cpu.get(key(T,"split_exact_gelu",p)),s);kv(o,"qnn/prod/T"+T+"/"+p+"/split_vs_canonical_rmse_ratio",mc.rmse==0?"inf":ms.rmse/mc.rmse);}if(c!=null&&poly!=null)appendMetric(o,"qnn/prod/T"+T+"/"+p+"/ch60d16_vs_canonical",metric(c,poly));}}
    private static OrtSession.SessionOptions cpuOptions()throws OrtException{OrtSession.SessionOptions s=new OrtSession.SessionOptions();s.setInterOpNumThreads(1);s.setIntraOpNumThreads(1);return s;}
    private static OrtSession.SessionOptions qnnOptions(boolean fp16,int opt)throws OrtException{OrtSession.SessionOptions s=cpuOptions();LinkedHashMap<String,String> q=new LinkedHashMap<>();q.put("backend_type","htp");q.put("htp_performance_mode","burst");q.put("qnn_context_priority","high");q.put("htp_graph_finalization_optimization_mode",Integer.toString(opt));q.put("enable_htp_fp16_precision",fp16?"1":"0");q.put("offload_graph_io_quantization","0");s.addQnn(q);s.addConfigEntry("session.disable_cpu_ep_fallback","1");return s;}
    private float[] execute(OrtEnvironment env,OrtSession s,float[] x,int T)throws Exception{FloatBuffer b=ByteBuffer.allocateDirect(x.length*4).order(ByteOrder.nativeOrder()).asFloatBuffer();b.put(x).rewind();try(OnnxTensor t=OnnxTensor.createTensor(env,b,new long[]{1,T,1536});OrtSession.Result r=s.run(Collections.singletonMap("x",t))){OnnxValue v=r.get("y").orElseThrow();FloatBuffer f=((OnnxTensor)v).getFloatBuffer();f.rewind();float[] y=new float[f.remaining()];f.get(y);for(float z:y)if(!Float.isFinite(z))throw new IllegalStateException("non-finite output");return y;}}
    private String materializeModel(String v,int T,StringBuilder o)throws Exception{File d=new File(getFilesDir(),"rev46-models");if(!d.isDirectory()&&!d.mkdirs())throw new IOException("mkdir");File f=new File(d,v+"_t"+T+".onnx");try(InputStream in=getAssets().open("models/"+v+"_t"+T+".onnx");OutputStream out=new FileOutputStream(f)){byte[] b=new byte[8192];for(int n;(n=in.read(b))>0;)out.write(b,0,n);}kv(o,"model/"+v+"_t"+T+"/sha256",sha(f));return f.getAbsolutePath();}
    private String modelPath(String v,int T){return new File(new File(getFilesDir(),"rev46-models"),v+"_t"+T+".onnx").getAbsolutePath();}
    private static String key(int T,String v,String p){return T+"|"+v+"|"+p;}
    private static float[] input(String p,int T){int n=T*1536;float[] x=new float[n];if("sweep".equals(p)){for(int i=0;i<n;i++)x[i]=(float)(-10.0+15.0*i/(double)Math.max(1,n-1));return x;}if("zero_dense".equals(p)){for(int i=0;i<n;i++)x[i]=(float)(-0.25+0.5*((i*1315423911L&0x7fffffffL)/(double)0x7fffffffL));return x;}int qi="cold_stats".equals(p)?0:"warm1_stats".equals(p)?1:"warm18_stats".equals(p)?2:3;long st=0x9e3779b97f4a7c15L^(T*1009L)^(qi*65537L);for(int i=0;i<n;i++){st^=st<<13;st^=st>>>7;st^=st<<17;double u=((st>>>11)&((1L<<53)-1))/(double)(1L<<53);x[i]=(float)interp(Q[qi],u);}return x;}
    private static double interp(double[] q,double u){if(u<=0)return q[0];if(u>=1)return q[q.length-1];int j=1;while(j<PROB.length&&u>PROB[j])j++;double a=PROB[j-1],b=PROB[j];return q[j-1]+(q[j]-q[j-1])*(u-a)/(b-a);}
    private static Metric metric(float[] a,float[] b){if(a==null||b==null||a.length!=b.length)return Metric.nan();double max=0,sum=0,sq=0,dot=0,aa=0,bb=0;for(int i=0;i<a.length;i++){double d=(double)b[i]-a[i],ad=Math.abs(d);max=Math.max(max,ad);sum+=ad;sq+=d*d;dot+=(double)a[i]*b[i];aa+=(double)a[i]*a[i];bb+=(double)b[i]*b[i];}return new Metric(max,sum/a.length,Math.sqrt(sq/a.length),aa==0||bb==0?1:dot/Math.sqrt(aa*bb));}
    private static boolean bitsEqual(float[] a,float[] b){if(a==null||b==null||a.length!=b.length)return false;for(int i=0;i<a.length;i++)if(Float.floatToRawIntBits(a[i])!=Float.floatToRawIntBits(b[i]))return false;return true;}
    private static void appendMetric(StringBuilder o,String k,Metric m){kv(o,k+"/max_abs",m.max);kv(o,k+"/mean_abs",m.mean);kv(o,k+"/rmse",m.rmse);kv(o,k+"/cosine",m.cos);}
    private static void kv(StringBuilder o,String k,Object v){o.append(k).append('=').append(String.valueOf(v)).append('\n');}
    private static double ms(long start){return (System.nanoTime()-start)/1e6;}
    private static String err(Throwable t){return t.getClass().getName()+":"+String.valueOf(t.getMessage()).replace('\n',' ');}
    private static String sha(File f)throws Exception{MessageDigest d=MessageDigest.getInstance("SHA-256");try(InputStream in=new FileInputStream(f)){byte[] b=new byte[8192];for(int n;(n=in.read(b))>0;)d.update(b,0,n);}StringBuilder s=new StringBuilder();for(byte x:d.digest())s.append(String.format(Locale.ROOT,"%02x",x));return s.toString();}
    static final class Metric{final double max,mean,rmse,cos;Metric(double a,double b,double c,double d){max=a;mean=b;rmse=c;cos=d;}static Metric nan(){return new Metric(Double.NaN,Double.NaN,Double.NaN,Double.NaN);}}
    static final class RunMeta{boolean ok;double createMs,execMs;String error;}
}
