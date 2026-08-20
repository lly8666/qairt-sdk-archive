package io.github.lly8666.meanvc2.rev46batch;

import ai.onnxruntime.*;
import android.app.Activity;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.os.Bundle;
import android.graphics.Typeface;
import android.view.ViewGroup;
import android.widget.*;
import java.io.*;
import java.nio.*;
import java.security.MessageDigest;
import java.util.*;
import org.json.*;

public final class MainActivity extends Activity {
    private static final int WIDTH = 1536;
    private static final String[] KINDS = {"gelu_op", "canonical_erf", "decanonicalized_erf"};
    private static final String[] SHAPES = {"cold4", "warm6"};
    private static final String[] PATTERNS = {"critical", "sweep", "wave"};
    private TextView out;
    private Button runButton, copyButton;
    private volatile String fullLog = "";

    static final class RunResult {
        float[] y;
        double createMs, runMs;
        String error = "";
        boolean ok() { return y != null && error.isEmpty(); }
    }

    static final class Metric {
        double maxAbs, meanAbs, rmse, cosine;
        int maxIndex;
        float refAtMax, candAtMax;
    }

    @Override public void onCreate(Bundle state) {
        super.onCreate(state);
        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setPadding(20,20,20,20);
        TextView title = new TextView(this);
        title.setText("MeanVC2 rev46 · block4 GELU lowering · strict HTP batch");
        title.setTextSize(17); title.setTypeface(Typeface.DEFAULT_BOLD);
        root.addView(title);
        TextView note = new TextView(this);
        note.setText("一次运行：cold4/warm6 × 3 等价 activation 表达 × 3 输入分布 × fresh-session repeat；QNN HTP 禁止 CPU fallback。完成后复制完整日志返回。");
        root.addView(note);
        LinearLayout buttons = new LinearLayout(this);
        buttons.setOrientation(LinearLayout.HORIZONTAL);
        runButton = new Button(this); runButton.setText("运行全部");
        copyButton = new Button(this); copyButton.setText("复制完整日志"); copyButton.setEnabled(false);
        buttons.addView(runButton, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1));
        buttons.addView(copyButton, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1));
        root.addView(buttons);
        ScrollView scroll = new ScrollView(this);
        out = new TextView(this); out.setTypeface(Typeface.MONOSPACE); out.setTextSize(12); out.setTextIsSelectable(true);
        scroll.addView(out);
        root.addView(scroll, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, 0, 1));
        setContentView(root);
        runButton.setOnClickListener(v -> startBatch());
        copyButton.setOnClickListener(v -> {
            ClipboardManager cm = (ClipboardManager)getSystemService(Context.CLIPBOARD_SERVICE);
            cm.setPrimaryClip(ClipData.newPlainText("MeanVC2 rev46 batch log", fullLog));
            Toast.makeText(this, "完整日志已复制", Toast.LENGTH_SHORT).show();
        });
        startBatch();
    }

    private void startBatch() {
        runButton.setEnabled(false); copyButton.setEnabled(false); fullLog = "";
        out.setText("REV46_BLOCK4_HTP_BATCH_RUNNING\n");
        new Thread(() -> {
            String log;
            try { log = runBatch(); }
            catch (Throwable t) { log = "REV46_BLOCK4_HTP_BATCH_FATAL\n" + error(t) + "\n"; }
            fullLog = log;
            final String f = log;
            runOnUiThread(() -> { out.setText(f); runButton.setEnabled(true); copyButton.setEnabled(true); });
        }, "rev46-htp-batch").start();
    }

    private String runBatch() throws Exception {
        StringBuilder b = new StringBuilder(256 * 1024);
        kv(b,"marker","REV46_BLOCK4_HTP_BATCH_START");
        kv(b,"app_version",getPackageManager().getPackageInfo(getPackageName(),0).versionName);
        kv(b,"ort_version","1.27.0"); kv(b,"qnn_runtime_version","2.44.0");
        kv(b,"strict_cpu_fallback_disabled",true);
        kv(b,"htp_performance_mode","burst");
        kv(b,"htp_graph_finalization_optimization_mode","3");
        kv(b,"enable_htp_fp16_precision","1");
        kv(b,"vocos_intermediate_dim",WIDTH);
        kv(b,"providers",String.valueOf(OrtEnvironment.getAvailableProviders()));
        if(!OrtEnvironment.getAvailableProviders().contains(OrtProvider.QNN))
            throw new IllegalStateException("QNN provider unavailable");

        JSONObject manifest = new JSONObject(readTextAsset("MODEL_MANIFEST.json"));
        kv(b,"model_manifest_schema",manifest.getInt("schema"));
        JSONArray ma = manifest.getJSONArray("models");
        for(int i=0;i<ma.length();i++) {
            JSONObject m=ma.getJSONObject(i);
            kv(b,"model_"+m.getString("shape_name")+"_"+m.getString("kind")+"_sha256",m.getString("sha256"));
            kv(b,"model_"+m.getString("shape_name")+"_"+m.getString("kind")+"_bytes",m.getLong("bytes"));
        }

        OrtEnvironment env = OrtEnvironment.getEnvironment();
        int modelFailures=0, htpRuns=0, cpuRuns=0, repeatChecks=0, repeatExact=0;
        double globalMax=0.0;
        for(String shapeName: SHAPES) {
            int frames = shapeName.equals("cold4") ? 4 : 6;
            long[] shape = new long[]{1, frames, WIDTH};
            int count = frames * WIDTH;
            Map<String,float[]> inputs = new LinkedHashMap<>();
            for(String p:PATTERNS) inputs.put(p, makeInput(p,count));
            Map<String,Map<String,RunResult>> cpu = new LinkedHashMap<>();
            Map<String,Map<String,RunResult>> htp1 = new LinkedHashMap<>();
            Map<String,Map<String,RunResult>> htp2 = new LinkedHashMap<>();
            kv(b,"shape_begin",shapeName+"_[1,"+frames+","+WIDTH+"]");

            for(String kind: KINDS) {
                String asset="models/"+shapeName+"_"+kind+".onnx";
                byte[] model=readAsset(asset);
                kv(b,shapeName+"_"+kind+"_asset_sha256",sha256(model));
                Map<String,RunResult> cr = runModelSet(env,model,shape,inputs,false); cpu.put(kind,cr);
                Map<String,RunResult> h1 = runModelSet(env,model,shape,inputs,true); htp1.put(kind,h1);
                Map<String,RunResult> h2 = runModelSet(env,model,shape,inputs,true); htp2.put(kind,h2);
                for(String p:PATTERNS) {
                    RunResult c=cr.get(p), q=h1.get(p), r=h2.get(p);
                    cpuRuns++; htpRuns+=2;
                    prefixRun(b,shapeName,kind,p,"cpu",c);
                    prefixRun(b,shapeName,kind,p,"htp_first",q);
                    prefixRun(b,shapeName,kind,p,"htp_repeat",r);
                    if(!c.ok()||!q.ok()||!r.ok()) { modelFailures++; continue; }
                    Metric m=metric(c.y,q.y); globalMax=Math.max(globalMax,m.maxAbs);
                    prefixMetric(b,shapeName+"_"+kind+"_"+p+"_htp_vs_cpu",m);
                    boolean exact=bitsEqual(q.y,r.y); repeatChecks++; if(exact) repeatExact++;
                    kv(b,shapeName+"_"+kind+"_"+p+"_fresh_session_repeat_exact_bits",exact);
                    Metric rm=metric(q.y,r.y); prefixMetric(b,shapeName+"_"+kind+"_"+p+"_fresh_session_repeat_metric",rm);
                }
            }

            for(String p:PATTERNS) {
                compareVariants(b,shapeName,p,"cpu",cpu);
                compareVariants(b,shapeName,p,"htp",htp1);
            }
            kv(b,"shape_end",shapeName);
        }
        kv(b,"cpu_run_count",cpuRuns); kv(b,"htp_run_count",htpRuns);
        kv(b,"fresh_session_repeat_checks",repeatChecks); kv(b,"fresh_session_repeat_exact_count",repeatExact);
        kv(b,"failed_run_triplets",modelFailures); kv(b,"global_htp_vs_cpu_max_abs",globalMax);
        kv(b,"interpretation_policy","NO_CPU_FALLBACK; micro-batch is a lowering sensitivity probe, not full-Vocos HTP closure; use cross-variant HTP deltas and repeat stability to decide whether full rev25 block4 A/B is justified");
        kv(b,"marker",modelFailures==0?"REV46_BLOCK4_HTP_BATCH_COMPLETE":"REV46_BLOCK4_HTP_BATCH_COMPLETE_WITH_FAILURES");
        return b.toString();
    }

    private static Map<String,RunResult> runModelSet(OrtEnvironment env, byte[] model, long[] shape, Map<String,float[]> inputs, boolean htp) {
        Map<String,RunResult> out=new LinkedHashMap<>();
        long tc=System.nanoTime();
        try(OrtSession.SessionOptions opt=htp?qnnOptions():cpuOptions(); OrtSession s=env.createSession(model,opt)) {
            double create=(System.nanoTime()-tc)/1e6;
            for(Map.Entry<String,float[]> e:inputs.entrySet()) {
                RunResult rr=new RunResult(); rr.createMs=create;
                try {
                    FloatBuffer fb=direct(e.getValue());
                    long tr=System.nanoTime();
                    try(OnnxTensor in=OnnxTensor.createTensor(env,fb,shape); OrtSession.Result result=s.run(Collections.singletonMap("x",in))) {
                        rr.runMs=(System.nanoTime()-tr)/1e6;
                        OnnxValue v=result.get("y").orElseThrow();
                        FloatBuffer ob=((OnnxTensor)v).getFloatBuffer(); ob.rewind(); rr.y=new float[ob.remaining()]; ob.get(rr.y);
                        for(float x:rr.y) if(!Float.isFinite(x)) throw new IllegalStateException("non-finite output");
                    }
                } catch(Throwable t) { rr.error=error(t); }
                out.put(e.getKey(),rr);
            }
        } catch(Throwable t) {
            String er=error(t); double create=(System.nanoTime()-tc)/1e6;
            for(String p:inputs.keySet()) { RunResult rr=new RunResult(); rr.createMs=create; rr.error=er; out.put(p,rr); }
        }
        return out;
    }

    private static OrtSession.SessionOptions cpuOptions() throws OrtException {
        OrtSession.SessionOptions o=new OrtSession.SessionOptions(); o.setInterOpNumThreads(1); o.setIntraOpNumThreads(1); return o;
    }
    private static OrtSession.SessionOptions qnnOptions() throws OrtException {
        OrtSession.SessionOptions o=cpuOptions(); LinkedHashMap<String,String> q=new LinkedHashMap<>();
        q.put("backend_type","htp"); q.put("htp_performance_mode","burst"); q.put("qnn_context_priority","high");
        q.put("htp_graph_finalization_optimization_mode","3"); q.put("enable_htp_fp16_precision","1"); q.put("offload_graph_io_quantization","0");
        o.addQnn(q); o.addConfigEntry("session.disable_cpu_ep_fallback","1"); return o;
    }

    private static void compareVariants(StringBuilder b,String shape,String pattern,String backend,Map<String,Map<String,RunResult>> all) {
        String[][] pairs={{"gelu_op","canonical_erf"},{"canonical_erf","decanonicalized_erf"},{"gelu_op","decanonicalized_erf"}};
        for(String[] pair:pairs) {
            RunResult a=all.get(pair[0]).get(pattern), c=all.get(pair[1]).get(pattern);
            String p=shape+"_"+pattern+"_"+backend+"_"+pair[0]+"_vs_"+pair[1];
            if(a.ok()&&c.ok()) prefixMetric(b,p,metric(a.y,c.y)); else kv(b,p+"_error","comparison unavailable");
        }
    }

    private static float[] makeInput(String kind,int n) {
        float[] x=new float[n];
        if(kind.equals("critical")) {
            float[] v={0f,-0f,1e-6f,-1e-6f,0.01f,-0.01f,0.1f,-0.1f,0.5f,-0.5f,1f,-1f,2f,-2f,3f,-3f,4f,-4f,6f,-6f,8f,-8f};
            for(int i=0;i<n;i++) x[i]=v[i%v.length];
        } else if(kind.equals("sweep")) {
            for(int i=0;i<n;i++) x[i]=-8f+16f*((i%257)/256f);
        } else {
            for(int i=0;i<n;i++) x[i]=(float)(2.6*Math.sin(i*0.017)+0.7*Math.cos(i*0.071)+0.15*Math.sin(i*0.233));
        }
        return x;
    }

    private static Metric metric(float[] ref,float[] cand) {
        if(ref.length!=cand.length) throw new IllegalArgumentException("metric length");
        Metric m=new Metric(); double sum=0,ss=0,dot=0,aa=0,bb=0; int mi=0; double mx=-1;
        for(int i=0;i<ref.length;i++) { double a=ref[i],c=cand[i],d=Math.abs(c-a); sum+=d; ss+=(c-a)*(c-a); dot+=a*c; aa+=a*a; bb+=c*c; if(d>mx){mx=d;mi=i;} }
        m.maxAbs=mx; m.meanAbs=sum/ref.length; m.rmse=Math.sqrt(ss/ref.length); m.cosine=(aa==0||bb==0)?Double.NaN:dot/Math.sqrt(aa*bb); m.maxIndex=mi; m.refAtMax=ref[mi]; m.candAtMax=cand[mi]; return m;
    }
    private static boolean bitsEqual(float[] a,float[] b) { if(a.length!=b.length)return false; for(int i=0;i<a.length;i++) if(Float.floatToRawIntBits(a[i])!=Float.floatToRawIntBits(b[i]))return false; return true; }
    private static FloatBuffer direct(float[] x) { FloatBuffer b=ByteBuffer.allocateDirect(x.length*4).order(ByteOrder.nativeOrder()).asFloatBuffer(); b.put(x).rewind(); return b; }

    private byte[] readAsset(String name) throws IOException { try(InputStream in=getAssets().open(name); ByteArrayOutputStream o=new ByteArrayOutputStream()){ byte[] buf=new byte[1<<16]; for(int r;(r=in.read(buf))>=0;)o.write(buf,0,r); return o.toByteArray(); } }
    private String readTextAsset(String name) throws IOException { return new String(readAsset(name),java.nio.charset.StandardCharsets.UTF_8); }
    private static String sha256(byte[] raw) throws Exception { MessageDigest md=MessageDigest.getInstance("SHA-256"); byte[] d=md.digest(raw); StringBuilder s=new StringBuilder(); for(byte x:d)s.append(String.format(Locale.ROOT,"%02x",x&255)); return s.toString(); }
    private static String error(Throwable t) { StringWriter sw=new StringWriter(); t.printStackTrace(new PrintWriter(sw)); return t.getClass().getName()+":"+String.valueOf(t.getMessage())+" | "+sw.toString().replace('\n',' ').replace('\r',' '); }
    private static void kv(StringBuilder b,String k,Object v){ b.append(k).append('=').append(String.valueOf(v)).append('\n'); }
    private static void prefixRun(StringBuilder b,String shape,String kind,String pattern,String backend,RunResult r){ String p=shape+"_"+kind+"_"+pattern+"_"+backend; kv(b,p+"_ok",r.ok());kv(b,p+"_session_create_ms",r.createMs);kv(b,p+"_run_ms",r.runMs);if(!r.ok())kv(b,p+"_error",r.error); }
    private static void prefixMetric(StringBuilder b,String p,Metric m){ kv(b,p+"_max_abs",m.maxAbs);kv(b,p+"_mean_abs",m.meanAbs);kv(b,p+"_rmse",m.rmse);kv(b,p+"_cosine",m.cosine);kv(b,p+"_max_index",m.maxIndex);kv(b,p+"_ref_at_max",m.refAtMax);kv(b,p+"_cand_at_max",m.candAtMax); }
}
