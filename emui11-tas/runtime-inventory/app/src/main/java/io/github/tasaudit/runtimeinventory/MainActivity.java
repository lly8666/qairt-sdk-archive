package io.github.tasaudit.runtimeinventory;

import android.app.Activity;
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
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.nio.charset.StandardCharsets;

/** Standalone read-only diagnostic app. Does not contain the GhostLock exploit. */
public final class MainActivity extends Activity {
    private TextView report;
    private Button runButton,copyButton,shareButton;
    private volatile boolean running=false;
    private static final String LAST="tas_runtime_last.txt";
    @Override public void onCreate(Bundle state){
        super.onCreate(state);
        LinearLayout layout=new LinearLayout(this);
        layout.setOrientation(LinearLayout.VERTICAL);
        int d=(int)(14*getResources().getDisplayMetrics().density);
        layout.setPadding(d,d,d,d);
        TextView title=new TextView(this);
        title.setText("TAS-AN00 · 固件 / Mali ABI 一键检查");
        title.setTextSize(19);title.setTypeface(Typeface.DEFAULT_BOLD);
        layout.addView(title);
        TextView subtitle=new TextView(this);
        subtitle.setText("一键采集系统文件 SHA-256、可读权限、SELinux 和 Mali r18p0 接口版本。\n不执行 GhostLock、不分配 GPU 内存、不请求 Root、不联网。");
        subtitle.setTextSize(13);
        layout.addView(subtitle);
        runButton=new Button(this);
        runButton.setText("开始一键采集（只读）");
        layout.addView(runButton);
        copyButton=new Button(this);
        copyButton.setText("复制全部报告");
        layout.addView(copyButton);
        shareButton=new Button(this);
        shareButton.setText("系统分享报告");
        layout.addView(shareButton);
        Button previous=new Button(this);
        previous.setText("读取上次报告");
        layout.addView(previous);
        ScrollView scroller=new ScrollView(this);
        report=new TextView(this);
        report.setTypeface(Typeface.MONOSPACE);
        report.setTextSize(11);
        report.setTextIsSelectable(true);
        report.setText(loadLast());
        scroller.addView(report);
        layout.addView(scroller,new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,0,1));
        setContentView(layout);
        runButton.setOnClickListener(v->run());
        copyButton.setOnClickListener(v->{
            ClipboardManager c=(ClipboardManager)getSystemService(Context.CLIPBOARD_SERVICE);
            c.setPrimaryClip(ClipData.newPlainText("TAS_RUNTIME_INVENTORY_V1",report.getText()));
        });
        shareButton.setOnClickListener(v->{
            Intent i=new Intent(Intent.ACTION_SEND);
            i.setType("text/plain");
            i.putExtra(Intent.EXTRA_SUBJECT,"TAS-AN00 Runtime Inventory");
            i.putExtra(Intent.EXTRA_TEXT, report.getText().toString());
            startActivity(Intent.createChooser(i,"分享 TAS 只读报告"));
        });
        previous.setOnClickListener(v->report.setText(loadLast()));
    }
    private void run(){
        if(running)return;
        running=true;runButton.setEnabled(false);
        report.setText("正在采集系统文件和 Mali ABI……\n");
        new Thread(()->{
            String result;
            try{result=ProbeCollector.run(getApplicationContext());}
            catch(Throwable e){result="TAS_RUNTIME_INVENTORY_FAILURE\n"+e+"\n";}
            try(FileOutputStream out=openFileOutput(LAST,MODE_PRIVATE)){
                out.write(result.getBytes(StandardCharsets.UTF_8));
                out.getFD().sync();
            }catch(Exception e){result+="\nREPORT_SAVE_ERROR="+e;}
            final String completed=result;
            runOnUiThread(()->{report.setText(completed);running=false;runButton.setEnabled(true);});
        },"TAS-Runtime-Inventory").start();
    }
    private String loadLast(){
        File f=new File(getFilesDir(),LAST);
        if(!f.isFile())return "未采集：点击「开始一键采集（只读）」\n";
        try(FileInputStream in=new FileInputStream(f)){
            byte[] b=new byte[(int)Math.min(f.length(),512000)];
            int n=in.read(b);return n>0?new String(b,0,n,StandardCharsets.UTF_8):"EMPTY";
        }catch(Exception e){return "无法读取上次报告: "+e;}
    }
}
