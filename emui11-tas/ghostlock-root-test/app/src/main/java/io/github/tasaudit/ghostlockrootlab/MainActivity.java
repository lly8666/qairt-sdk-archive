package io.github.tasaudit.ghostlockrootlab;

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

/** Experimental on-device launcher for pinned TAS-AN00 GhostLock core. */
public final class MainActivity extends Activity {
    private TextView output;
    private Button identity,leak,attempt;
    private volatile boolean busy=false;
    private final StringBuilder live=new StringBuilder();
    private static final int MAX_UI=150000;
    @Override public void onCreate(Bundle savedState) {
        super.onCreate(savedState);
        LinearLayout root=new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        int padding=Math.round(12*getResources().getDisplayMetrics().density);
        root.setPadding(padding,padding,padding,padding);
        TextView heading=new TextView(this);
        heading.setText("GhostLock · TAS-AN00 Root 实验版\nHuawei Mate 30 · EMUI 11.0.0.185 · Linux 4.14.116");
        heading.setTextSize(17);heading.setTypeface(Typeface.DEFAULT_BOLD);root.addView(heading);
        TextView info=new TextView(this);
        info.setText("本安装包包含针对 TAS 内核编译的 GhostLock 原生研究核心。只有‘实验性 Root’会尝试内核利用；可能直接卡死、重启或变砖。静态适配不等于 Root 已验证。应用没有网络和自动上传功能。");
        info.setTextSize(13);root.addView(info);
        identity=button(root,"1. 原生核心 / 型号门禁检查（不触发漏洞）");
        leak=button(root,"2. 内核地址读取路径测试");
        attempt=button(root,"3. 实验性临时 Root（高风险）");
        Button previous=button(root,"查看上次运行日志（重启后可看）");
        Button copy=button(root,"复制日志");
        Button share=button(root,"系统分享日志");
        ScrollView scroll=new ScrollView(this);
        output=new TextView(this);output.setTextSize(11);
        output.setTypeface(Typeface.MONOSPACE);output.setTextIsSelectable(true);
        output.setText("READY\n"+NativeRunner.readLast(this));
        scroll.addView(output);
        root.addView(scroll,new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,0,1));
        setContentView(root);
        identity.setOnClickListener(v->run("--tas-profile",15));
        leak.setOnClickListener(v->run("--leak",40));
        attempt.setOnClickListener(v->new AlertDialog.Builder(this)
            .setTitle("运行实验性内核提权？")
            .setMessage("核心尚未在 TAS-AN00 上验证。可能导致 kernel panic、卡在开机或系统损坏。你的设备为专用测试机。是否执行实验？")
            .setNegativeButton("取消",null)
            .setPositiveButton("执行 Root 实验",(dialog,which)->run("--root",180)).show());
        previous.setOnClickListener(v->output.setText(NativeRunner.readLast(this)));
        copy.setOnClickListener(v->{
            ClipboardManager c=(ClipboardManager)getSystemService(Context.CLIPBOARD_SERVICE);
            c.setPrimaryClip(ClipData.newPlainText("TAS_GHOSTLOCK_ROOTLAB",output.getText()));
            Toast.makeText(this,"日志已复制",Toast.LENGTH_SHORT).show();
        });
        share.setOnClickListener(v->{
            Intent i=new Intent(Intent.ACTION_SEND);
            i.setType("text/plain");
            i.putExtra(Intent.EXTRA_SUBJECT,"TAS-AN00 GhostLock 实验日志");
            i.putExtra(Intent.EXTRA_TEXT,output.getText().toString());
            startActivity(Intent.createChooser(i,"发送实验日志"));
        });
    }
    private Button button(LinearLayout group,String label) {
        Button b=new Button(this);b.setText(label);group.addView(b);return b;
    }
    private void setBusy(boolean active) {
        identity.setEnabled(!active);leak.setEnabled(!active);attempt.setEnabled(!active);
    }
    private void run(String mode,int timeout) {
        if(busy)return;
        busy=true;setBusy(true);
        synchronized(live){live.setLength(0);}
        output.setText("RUNNING "+mode+"...\n");
        new Thread(()->{
            NativeRunner.run(getApplicationContext(),mode,timeout,chunk->{
                String snapshot;
                synchronized(live) {
                    if(live.length()<MAX_UI)live.append(chunk);
                    snapshot=live.toString();
                }
                runOnUiThread(()->output.setText(snapshot));
            });
            runOnUiThread(()->{busy=false;setBusy(false);});
        },"TAS-GhostLock-Runner").start();
    }
}
