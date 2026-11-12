package io.github.tasaudit.runtimeinventory;

import android.content.Context;
import android.os.Build;
import android.os.Process;
import android.system.ErrnoException;
import android.system.Os;
import android.system.StructStat;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.TimeUnit;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.ArrayList;

/**
 * Non-invasive, single-pass TAS-AN00 dumpstate/binder/service runtime survey.
 * Only reads properties, public process state, accessible file metadata and
 * SELinux labels. No root requests, no start/stop of services, no GPU ioctls.
 */
public final class ServiceSurvey {
    public static final String LOG_NAME="TAS_SERVICE_CONTEXT_V2_last.txt";
    private static final String[] PROPERTIES={
        "ro.product.model",
        "ro.hardware",
        "ro.build.display.id",
        "ro.build.type",
        "ro.debuggable",
        "ro.secure",
        "ro.boot.verifiedbootstate",
        "ro.boot.vbmeta.device_state",
        "init.svc.dumpstate",
        "init.svc.dumpstatez",
        "init.svc.bugreportz",
        "init.svc.bugreport",
        "init.svc.bugreportd",
        "init.svc.bugreportm",
        "init.svc.bugreportplus",
        "init.svc.bugreportremote",
        "init.svc.adbd",
        "init.svc.vendor.dumpstate",
        "init.svc.dmesgd",
        "sys.bugreportd.args",
        "ctl.start",
        "persist.sys.usb.config",
        "ro.vendor.build.fingerprint",
        "ro.build.fingerprint",
    };
    private static final String[] TARGETS={
        "/system/bin/bugreportz",
        "/system/bin/dumpstate",
        "/system/bin/dumpstatez",
        "/system/bin/toybox",
        "/system/lib64/libc.so",
        "/apex/com.android.runtime/lib64/bionic/libc.so",
        "/dev/mali0",
        "/dev/socket/dumpstate",
        "/dev/socket/dumpstatez",
        "/dev/socket/dumpstatez_callback",
        "/dev/socket/dumpstatez_ppid",
        "/system/etc/init/dumpstate.rc",
        "/system/etc/init/bugreport.rc",
        "/system/etc/init/bugreportd.rc",
        "/system/etc/init/bugreportplus.rc",
        "/vendor/etc/init/hw/init.kirin990.rc",
        "/vendor/etc/init/hw/init.kirin990E.rc",
        "/system/etc/init/dumpstatez.rc",
        "/vendor/etc/init/dumpstate.rc",
        "/vendor/etc/init/dumpstatez.rc",
        "/system/etc/selinux/plat_sepolicy.cil",
        "/vendor/etc/selinux/vendor_sepolicy.cil",
        "/proc/net/unix",
        "/proc/1/attr/current",
        "/proc/self/attr/current",
    };
    private ServiceSurvey(){}

    private static String sanitize(String v) {
        if(v==null)return "";
        return v.replace("\r","").replace("\0","").replace("\n","|");
    }
    private static String exec(long timeoutMs, String... argv){
        java.lang.Process child=null;
        StringBuilder b=new StringBuilder();
        try {
            child=new ProcessBuilder(argv).redirectErrorStream(true).start();
            final java.lang.Process started=child;
            Thread reader=new Thread(()->{
                try(BufferedReader in=new BufferedReader(
                    new InputStreamReader(started.getInputStream(),StandardCharsets.UTF_8))){
                    String line;
                    while((line=in.readLine())!=null){
                        synchronized(b) {
                            if(b.length()<10000)b.append(line).append('\n');
                        }
                    }
                }catch(Exception ex){
                    synchronized(b){b.append("\nREAD_EXCEPTION=").append(ex.getClass().getSimpleName());}
                }
            },"TAS-Service-Read");
            reader.setDaemon(true);
            reader.start();
            if(!child.waitFor(timeoutMs, TimeUnit.MILLISECONDS)) {
                child.destroyForcibly();
                child.waitFor(300,TimeUnit.MILLISECONDS);
                return "TIMEOUT_"+timeoutMs+"ms";
            }
            reader.join(350);
            String raw;
            synchronized(b){raw=b.toString();}
            StringBuilder out=new StringBuilder();
            out.append("EXIT_").append(child.exitValue()).append(":");
            String[] lines=raw.split("\n");
            int matched=0;
            for(String line:lines) {
                String low=line.toLowerCase(Locale.ROOT);
                if(argv.length>0 && argv[0].contains("ps") &&
                    !(low.contains("dumpstate")||low.contains("bugreport")||low.contains("adbd")||
                      low.contains("mali")||low.contains("perfgenius")||low.contains("hisi")||
                      low.startsWith("label")||low.startsWith("u:r:"))) continue;
                if(argv.length>1 && "list".equals(argv[1]) && argv[0].contains("service") &&
                    !(low.contains("dumpstate")||low.contains("bugreport")||
                      low.contains("incident")||low.contains("total"))) continue;
                if(line.isEmpty())continue;
                if(++matched>55)break;
                if(out.length()+line.length()>11000)break;
                out.append(" ").append(line.trim());
            }
            return sanitize(out.toString());
        }catch(Throwable ex){return "EXCEPTION_"+ex.getClass().getSimpleName()+":"+sanitize(ex.getMessage());}
        finally{if(child!=null && child.isAlive()) child.destroyForcibly();}
    }
    private static String readFiltered(String path,String term,int maxBytes){
        try(FileInputStream f=new FileInputStream(path)){
            byte[] data=new byte[maxBytes];
            int n=f.read(data);
            if(n<=0)return "EMPTY";
            String s=new String(data,0,n,StandardCharsets.UTF_8);
            StringBuilder b=new StringBuilder();
            for(String line:s.split("\n")){
                if(term.isEmpty()||line.toLowerCase(Locale.ROOT).contains(term.toLowerCase(Locale.ROOT))){
                    if(b.length()+line.length()>2800)break;
                    b.append(line.trim()).append(" | ");
                }
            }
            return sanitize(b.length()==0?"NO_MATCH":b.toString());
        }catch(Throwable ex){return "READ_"+ex.getClass().getSimpleName()+":"+sanitize(ex.getMessage());}
    }
    private static String stat(String path){
        try {
            StructStat s=Os.lstat(path);
            StringBuilder b=new StringBuilder();
            b.append("OK mode=").append(Integer.toOctalString(s.st_mode&07777));
            b.append(" type=").append(Integer.toOctalString(s.st_mode&0170000));
            b.append(" uid=").append(s.st_uid).append(" gid=").append(s.st_gid);
            b.append(" bytes=").append(s.st_size);
            if((s.st_mode&0170000)==0120000) {
                try{b.append(" symlink=").append(Os.readlink(path));}catch(Throwable ignored){}
            }
            try{
                byte[] label=Os.getxattr(path,"security.selinux");
                b.append(" label=").append(sanitize(new String(label,StandardCharsets.US_ASCII)));
            }catch(Throwable ex){b.append(" selinux_label=").append(ex.getClass().getSimpleName());}
            return b.toString();
        }catch(ErrnoException e){return "ERRNO_"+e.errno+":"+sanitize(e.getMessage());}
        catch(Throwable e){return e.getClass().getSimpleName()+":"+sanitize(e.getMessage());}
    }
    private static void row(StringBuilder b,String key,String val){
        b.append(key).append('=').append(sanitize(val)).append('\n');
    }
    public static String collect(Context context){
        StringBuilder b=new StringBuilder(10000);
        b.append("TAS_SERVICE_CONTEXT_V2_BEGIN\n");
        row(b,"scope","app_sandbox_service_metadata_read_only");
        row(b,"root_triggered","false");
        row(b,"dumpstate_service_started","false");
        row(b,"system_modified","false");
        row(b,"mali_ioctl_called","false");
        row(b,"app_uid",Integer.toString(Process.myUid()));
        row(b,"device",Build.MODEL);
        row(b,"android_sdk",Integer.toString(Build.VERSION.SDK_INT));
        b.append("[properties]\n");
        for(String p:PROPERTIES){
            row(b,p,exec(1200,"/system/bin/getprop",p));
        }
        b.append("[/properties]\n");
        b.append("[file_labels]\n");
        for(int i=0;i<TARGETS.length;i++){
            row(b,"f"+String.format(Locale.ROOT,"%02d",i)+"_"+TARGETS[i],stat(TARGETS[i]));
        }
        b.append("[/file_labels]\n");
        b.append("[init_rc_content]\n");
        row(b,"read_only_source","fixed_service_configuration_files");
        row(b,"file_system_state_changes","none");
        final String[] configFiles={
            "/system/etc/init/dumpstate.rc",
            "/system/etc/init/bugreport.rc",
            "/system/etc/init/bugreportd.rc",
            "/system/etc/init/bugreportplus.rc",
            "/vendor/etc/init/hw/init.kirin990.rc",
            "/vendor/etc/init/hw/init.kirin990E.rc"
        };
        for(int i=0;i<configFiles.length;i++){
            String k="rc"+String.format(Locale.ROOT,"%02d",i);
            row(b,k+"_path",configFiles[i]);
            row(b,k+"_content",readFiltered(configFiles[i],configFiles[i].contains("kirin990")?"dumpstate":"",131072));
        }
        b.append("[/init_rc_content]\n");
        b.append("[service_manager]\n");
        row(b,"service_check_dumpstate",exec(3000,"/system/bin/service","check","dumpstate"));
        row(b,"service_check_bugreport",exec(3000,"/system/bin/service","check","bugreport"));
        row(b,"service_check_dumpstatez",exec(3000,"/system/bin/service","check","dumpstatez"));
        row(b,"service_check_incident",exec(3000,"/system/bin/service","check","incident"));
        row(b,"service_list_filtered",exec(3800,"/system/bin/service","list"));
        b.append("[/service_manager]\n");
        b.append("[process_visibility]\n");
        row(b,"ps_AZ",exec(3500,"/system/bin/ps","-AZ"));
        row(b,"pidof_dumpstate",exec(1300,"/system/bin/pidof","dumpstate"));
        row(b,"pidof_dumpstatez",exec(1300,"/system/bin/pidof","dumpstatez"));
        row(b,"proc_net_unix_dumpstate",readFiltered("/proc/net/unix","dumpstate",32768));
        row(b,"proc_self_context",readFiltered("/proc/self/attr/current","",256));
        row(b,"proc_1_context",readFiltered("/proc/1/attr/current","",256));
        b.append("[/process_visibility]\n");
        b.append("TAS_SERVICE_CONTEXT_V2_END\n");
        return b.toString();
    }
    public static void persist(Context ctx,String report) throws Exception {
        try(FileOutputStream file=new FileOutputStream(new File(ctx.getFilesDir(),LOG_NAME),false)){
            file.write(report.getBytes(StandardCharsets.UTF_8));
            file.getFD().sync();
        }
    }
    public static String last(Context ctx) {
        File f=new File(ctx.getFilesDir(),LOG_NAME);
        if(!f.exists())return "暂无服务环境采集日志。";
        try(FileInputStream in=new FileInputStream(f)){
            byte[] raw=new byte[(int)Math.min(f.length(),128000)];
            int n=in.read(raw);
            return n>0?new String(raw,0,n,StandardCharsets.UTF_8):"EMPTY";
        }catch(Exception e){return "读取服务环境日志失败: "+e;}
    }
}
