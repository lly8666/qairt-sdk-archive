package io.github.tasaudit.runtimeinventory;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.nio.charset.StandardCharsets;

/** TAS firmware reader + isolated reference Mali API compatibility research launcher. */
public final class MainActivity extends Activity {
    private TextView report;
    private Button inventory,gpuTest,exportButton;
    private volatile boolean running=false;
    private final StringBuilder live=new StringBuilder();
    private static final String LAST="tas_runtime_last.txt";
    @Override public void onCreate(Bundle state){
        super.onCreate(state);
        LinearLayout layout=new LinearLayout(this);
        layout.setOrientation(LinearLayout.VERTICAL);
        int d=(int)(10*getResources().getDisplayMetrics().density);
        layout.setPadding(d,d,d,d);
        TextView title=new TextView(this);
        title.setText("TAS-AN00 · Mali 11.16 / 固件实测 v1.1");
        title.setTextSize(18);title.setTypeface(Typeface.DEFAULT_BOLD);
        layout.addView(title);
        TextView subtitle=new TextView(this);
        subtitle.setText("1. 固件读取不改系统文件。\n2. GPU 实验按参考工程调用 SET_FLAGS、MEM_ALLOC、MEM_IMPORT、JOB_SUBMIT，在应用自有测试文件验证页缓存效果；可能引发系统崩溃。\n3. 导出 toybox/bugreportz/libc ELF 后可继续离线适配。");
        subtitle.setTextSize(12);
        layout.addView(subtitle);
        inventory=button(layout,"1. 一键读取固件 / Mali 基本 ABI（只读）");
        gpuTest=button(layout,"2. 批量 GPU 内存接口及自有文件缓存测试（高风险）");
        exportButton=button(layout,"3. 导出 toybox / bugreportz / libc 原始文件 ZIP");
        Button previousGpu=button(layout,"查看最近一次 GPU 批量测试日志");
        Button previousInventory=button(layout,"查看最近一次只读固件报告");
        Button copy=button(layout,"复制屏幕日志");
        ScrollView scroller=new ScrollView(this);
        report=new TextView(this);
        report.setTypeface(Typeface.MONOSPACE);
        report.setTextSize(11);
        report.setTextIsSelectable(true);
        report.setText(MaliBatchRunner.readLast(this)+"\n\n"+loadLast());
        scroller.addView(report);
        layout.addView(scroller,new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,0,1));
        setContentView(layout);
        inventory.setOnClickListener(v->runReadOnly());
        gpuTest.setOnClickListener(v->new AlertDialog.Builder(this)
            .setTitle("确认运行 Mali 11.16 原生实验？")
            .setMessage("将测试 GPU 内存分配、用户缓冲区导入、任务提交，并尝试修改应用自己创建的临时文件页缓存。不修改系统分区，但 GPU 漏洞行为可能导致手机崩溃或重启。")
            .setNegativeButton("取消",null)
            .setPositiveButton("执行批量实验",(dialog,which)->runGpu()).show());
        exportButton.setOnClickListener(v->exportSystemFiles());
        previousGpu.setOnClickListener(v->report.setText(MaliBatchRunner.readLast(this)));
        previousInventory.setOnClickListener(v->report.setText(loadLast()));
        copy.setOnClickListener(v->{
            ClipboardManager c=(ClipboardManager)getSystemService(Context.CLIPBOARD_SERVICE);
            c.setPrimaryClip(ClipData.newPlainText("TAS-AN00-LOG",report.getText()));
            Toast.makeText(this,"日志已复制",Toast.LENGTH_SHORT).show();
        });
    }
    private Button button(LinearLayout parent,String label){
        Button b=new Button(this);b.setText(label);parent.addView(b);return b;
    }
    private void busy(boolean state){
        running=state;inventory.setEnabled(!state);gpuTest.setEnabled(!state);
        exportButton.setEnabled(!state);
    }
    private void runReadOnly(){
        if(running)return;
        busy(true);report.setText("采集固件和 Mali 版本……\n");
        new Thread(()->{
            String result;
            try{result=ProbeCollector.run(getApplicationContext());}
            catch(Throwable e){result="TAS_RUNTIME_INVENTORY_FAILURE\n"+e+"\n";}
            try(FileOutputStream out=openFileOutput(LAST,MODE_PRIVATE)){
                out.write(result.getBytes(StandardCharsets.UTF_8));out.getFD().sync();
            }catch(Exception e){result+="\nREPORT_SAVE_ERROR="+e;}
            final String text=result;
            runOnUiThread(()->{report.setText(text);busy(false);});
        },"TAS-Runtime-Inventory").start();
    }
    private void runGpu(){
        if(running)return;
        busy(true);
        synchronized(live){live.setLength(0);}
        report.setText("Mali 11.16 原生实验开始；每项子进程最长 6 秒。\n");
        new Thread(()->{
            MaliBatchRunner.run(getApplicationContext(),chunk->{
                final String view;
                synchronized(live){
                    if(live.length()<100000)live.append(chunk);
                    view=live.toString();
                }
                runOnUiThread(()->report.setText(view));
            });
            runOnUiThread(()->{busy(false);report.setText(MaliBatchRunner.readLast(this));});
        },"TAS-GPU-Batch").start();
    }
    private void exportSystemFiles(){
        if(running)return;
        busy(true);report.setText("正在打包固定白名单的系统 ELF 文件……");
        new Thread(()->{
            File zip=null;Exception err=null;
            try{zip=SystemFileExporter.create(getApplicationContext());}
            catch(Exception e){err=e;}
            final File finished=zip;final Exception failure=err;
            runOnUiThread(()->{
                busy(false);
                if(failure!=null){
                    report.setText("系统 ELF 导出失败: "+failure);
                    return;
                }
                report.setText("系统 ELF ZIP 已生成："+finished.length()+" 字节\n"
                    +"只包含系统/厂商的可读文件；不会自动上传，请通过系统分享发送 ZIP。");
                Intent share=new Intent(Intent.ACTION_SEND);
                share.setType("application/zip");
                share.putExtra(Intent.EXTRA_STREAM,SystemFileExportProvider.CONTENT_URI);
                share.setClipData(ClipData.newUri(getContentResolver(),"TAS system ELF",
                    SystemFileExportProvider.CONTENT_URI));
                share.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                startActivity(Intent.createChooser(share,"分享 TAS-AN00 系统 ELF ZIP"));
            });
        },"TAS-ELF-Export").start();
    }
    private String loadLast(){
        File f=new File(getFilesDir(),LAST);
        if(!f.isFile())return "无只读固件报告。";
        try(FileInputStream in=new FileInputStream(f)){
            byte[] b=new byte[(int)Math.min(f.length(),512000)];
            int n=in.read(b);return n>0?new String(b,0,n,StandardCharsets.UTF_8):"EMPTY";
        }catch(Exception e){return "读取固件报告失败: "+e;}
    }
}
