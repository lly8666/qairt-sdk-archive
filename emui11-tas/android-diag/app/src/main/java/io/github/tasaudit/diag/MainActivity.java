package io.github.tasaudit.diag;

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
import android.widget.Toast;
import java.time.Instant;
import java.util.Map;

/** Device identity snapshot only: no permissions, network access or exploit. */
public final class MainActivity extends Activity {
    private Button runButton, copyButton, shareButton;
    private TextView output;
    private volatile String report = "";

    @Override public void onCreate(Bundle state) {
        super.onCreate(state);
        int padding = dp(16);
        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setPadding(padding, padding, padding, padding);
        TextView title = new TextView(this);
        title.setText("Mate 30 / TAS · EMUI 11 诊断\n固件基准：TAS-LGRP3-CHN 11.0.0.185\n内核基准：Linux 4.14.116");
        title.setTextSize(17);
        title.setTypeface(Typeface.DEFAULT_BOLD);
        root.addView(title);
        TextView notice = new TextView(this);
        notice.setText("本应用只读取设备标识和当前进程信息；无网络权限、不请求 Root、不触发内核漏洞、不刷机。采集完成后手动复制/分享文本。若版本不匹配，请勿尝试后续提权实验。");
        notice.setTextSize(13);
        root.addView(notice);
        runButton = new Button(this);
        runButton.setText("一键采集并检查目标固件");
        root.addView(runButton);
        copyButton = new Button(this);
        copyButton.setText("复制完整诊断报告");
        copyButton.setEnabled(false);
        root.addView(copyButton);
        shareButton = new Button(this);
        shareButton.setText("通过系统分享诊断报告");
        shareButton.setEnabled(false);
        root.addView(shareButton);
        ScrollView scroll = new ScrollView(this);
        output = new TextView(this);
        output.setTextSize(12);
        output.setTypeface(Typeface.MONOSPACE);
        output.setTextIsSelectable(true);
        output.setText("READY\n点击采集按钮生成诊断报告。\n");
        scroll.addView(output);
        root.addView(scroll,new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,0,1f));
        setContentView(root);

        runButton.setOnClickListener(v -> start());
        copyButton.setOnClickListener(v -> {
            ClipboardManager cm=(ClipboardManager)getSystemService(Context.CLIPBOARD_SERVICE);
            cm.setPrimaryClip(ClipData.newPlainText("TAS_EMUI11_DIAG",report));
            Toast.makeText(this,"已复制完整报告",Toast.LENGTH_SHORT).show();
        });
        shareButton.setOnClickListener(v -> {
            Intent i=new Intent(Intent.ACTION_SEND);
            i.setType("text/plain");
            i.putExtra(Intent.EXTRA_SUBJECT,"TAS EMUI11 固件诊断结果");
            i.putExtra(Intent.EXTRA_TEXT,report);
            startActivity(Intent.createChooser(i,"手动发送诊断报告"));
        });
    }
    private int dp(int n) { return Math.round(getResources().getDisplayMetrics().density*n); }

    private void start() {
        runButton.setEnabled(false);
        copyButton.setEnabled(false);
        shareButton.setEnabled(false);
        output.setText("正在读取公开设备信息…");
        new Thread(() -> {
            String result;
            try { result = buildReport(); }
            catch(Throwable t) { result="TAS_DIAG_FATAL="+t.getClass().getSimpleName()+": "+t.getMessage(); }
            String completed=result;
            report=completed;
            runOnUiThread(() -> {
                output.setText(completed);
                runButton.setEnabled(true);
                copyButton.setEnabled(true);
                shareButton.setEnabled(true);
            });
        },"TASReadOnlyProbe").start();
    }

    private static String buildReport() {
        Map<String,String> observed=ProbeCollector.collect();
        Map<String,TargetMatcher.Status> checks=TargetMatcher.assess(observed);
        StringBuilder b=new StringBuilder(4000);
        b.append("TAS_EMUI11_DIAG_V1_BEGIN\n");
        line(b,"schema","TAS_EMUI11_DIAG_V1");
        line(b,"tool_version","1.1.0-tas185");
        line(b,"captured_utc",Instant.now().toString());
        line(b,"expected_firmware",TargetMatcher.FIRMWARE);
        line(b,"expected_archive_sha256",TargetMatcher.ZIP_SHA256);
        line(b,"expected_kernel_image_sha256",TargetMatcher.KERNEL_IMAGE_SHA256);
        line(b,"read_only","true");
        line(b,"root_requested","false");
        line(b,"network_permission","false");
        line(b,"cve_triggered","false");
        line(b,"identity_verdict",TargetMatcher.verdict(checks));
        for (Map.Entry<String,TargetMatcher.Status> e : checks.entrySet())
            line(b,"check_"+e.getKey().toLowerCase(java.util.Locale.ROOT).replace(' ','_'),e.getValue().name());
        b.append("[observed]\n");
        for (Map.Entry<String,String> e:observed.entrySet()) line(b,e.getKey(),e.getValue());
        b.append("[/observed]\nTAS_EMUI11_DIAG_V1_END\n");
        b.append("此报告仅证明设备信息的读取结果，不能验证漏洞利用或 Root。\n");
        return b.toString();
    }
    private static void line(StringBuilder b,String key,String value) {
        String safe=value==null?"":value.replace('\r',' ').replace('\n',' ');
        b.append(key).append('=').append(safe).append('\n');
    }
}
