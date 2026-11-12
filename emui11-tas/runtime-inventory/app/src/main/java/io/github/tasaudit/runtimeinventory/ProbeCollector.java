package io.github.tasaudit.runtimeinventory;

import android.content.Context;
import android.os.Build;
import android.os.Process;
import android.system.ErrnoException;
import android.system.Os;
import android.system.StructStat;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;
import java.util.concurrent.TimeUnit;

/**
 * Single-pass read-only inventory for TAS-AN00. No shell, root, network,
 * partition write, GPU allocation/import, or CVE exploitation.
 */
public final class ProbeCollector {
    static { System.loadLibrary("tas_mali_abi"); }
    public static native String probeMaliNative();

    private static final long MAX_HASH_BYTES=96L * 1024 * 1024;
    private static final String[] PROPERTIES={
        "ro.product.model","ro.product.device","ro.product.board","ro.hardware",
        "ro.build.version.emui","ro.build.display.id","ro.build.version.incremental",
        "ro.build.version.release","ro.build.version.sdk","ro.build.fingerprint",
        "ro.vendor.build.fingerprint","ro.product.cpu.abi",
        "ro.boot.verifiedbootstate","ro.boot.vbmeta.device_state",
        "ro.build.version.security_patch","ro.build.version.huaweiapi","ro.vendor.build.version.sdk"
    };
    private static final String[] SYSTEM_FILES={
        "/system/bin/bugreportz",
        "/system/bin/dumpstate",
        "/system/bin/dumpstatez",
        "/system/bin/toybox",
        "/system/bin/app_process64",
        "/system/lib64/libc.so",
        "/apex/com.android.runtime/lib64/bionic/libc.so",
        "/apex/com.android.runtime/lib64/libc.so",
        "/vendor/bin/hw/android.hardware.graphics.mapper@2.0-service",
        "/vendor/lib64/egl/libGLES_mali.so",
        "/vendor/lib64/libmali.so",
        "/system/build.prop",
        "/vendor/build.prop",
        "/product/build.prop",
        "/system/etc/selinux/plat_sepolicy.cil",
        "/system/etc/selinux/plat_file_contexts",
        "/vendor/etc/selinux/vendor_sepolicy.cil",
        "/vendor/etc/selinux/vendor_file_contexts",
        "/sys/fs/selinux/enforce",
        "/proc/self/attr/current"
    };
    private ProbeCollector() {}

    private static void ln(StringBuilder b, String k,String v) {
        b.append(k).append('=').append(v==null?"":v.replace("\n"," ").replace("\r"," ")).append('\n');
    }
    private static String cmd(String... args) {
        java.lang.Process p=null;
        try{
            p=new ProcessBuilder(args).redirectErrorStream(true).start();
            boolean done=p.waitFor(1800,TimeUnit.MILLISECONDS);
            if(!done){p.destroyForcibly();return "TIMEOUT";}
            StringBuilder b=new StringBuilder();
            try(BufferedReader r=new BufferedReader(new InputStreamReader(p.getInputStream(),StandardCharsets.UTF_8))){
                String s;
                while((s=r.readLine())!=null&&b.length()<1000)b.append(s).append(' ');
            }
            if(p.exitValue()!=0)return "EXIT_"+p.exitValue()+":"+b.toString().trim();
            return b.toString().trim();
        }catch(Exception e){return e.getClass().getSimpleName()+":"+e.getMessage();}
        finally{if(p!=null && p.isAlive())p.destroyForcibly();}
    }
    private static String digest(File f) throws Exception {
        if(!f.isFile()) return "NOT_REGULAR_FILE";
        long bytes=f.length();
        if(bytes>MAX_HASH_BYTES) return "SKIPPED_GT_96MIB";
        MessageDigest md=MessageDigest.getInstance("SHA-256");
        try(FileInputStream in=new FileInputStream(f)) {
            byte[] chunk=new byte[65536];long total=0;int n;
            while((n=in.read(chunk))!=-1) {
                total+=n;
                if(total>MAX_HASH_BYTES)return "SKIPPED_GT_96MIB";
                md.update(chunk,0,n);
            }
        }
        StringBuilder hex=new StringBuilder();
        for(byte item:md.digest())hex.append(String.format(Locale.ROOT,"%02x",item&255));
        return hex.toString();
    }
    private static void examine(StringBuilder b,String path,int index) {
        String prefix="f"+String.format(Locale.ROOT,"%02d_",index);
        ln(b,prefix+"path",path);
        File f=new File(path);
        try{
            StructStat st=Os.lstat(path);
            ln(b,prefix+"stat","OK");
            ln(b,prefix+"mode",String.format(Locale.ROOT,"%o",st.st_mode&07777));
            ln(b,prefix+"uid",Long.toString(st.st_uid));
            ln(b,prefix+"gid",Long.toString(st.st_gid));
            ln(b,prefix+"size",Long.toString(st.st_size));
            if((st.st_mode&0170000)==0120000) {
                try{ln(b,prefix+"symlink",Os.readlink(path));}
                catch(Exception e){ln(b,prefix+"symlink","UNREADABLE_"+e.getClass().getSimpleName());}
            }
        }catch(ErrnoException e){
            ln(b,prefix+"stat","ERRNO_"+e.errno);
        }catch(Exception e){
            ln(b,prefix+"stat",e.getClass().getSimpleName());
        }
        try{ln(b,prefix+"sha256",digest(f));}
        catch(Exception e){
            ln(b,prefix+"sha256","UNREADABLE_"+e.getClass().getSimpleName()+":"+e.getMessage());
        }
    }
    private static String readLimited(String path,int max) {
        try(FileInputStream in=new FileInputStream(path)){
            byte[] b=new byte[max];int n=in.read(b);
            if(n<=0)return "EMPTY";
            return new String(b,0,n,StandardCharsets.UTF_8).trim();
        }catch(Exception e){return "UNREADABLE_"+e.getClass().getSimpleName()+":"+e.getMessage();}
    }
    public static String run(Context context) {
        StringBuilder b=new StringBuilder(16000);
        b.append("TAS_RUNTIME_INVENTORY_V1_BEGIN\n");
        ln(b,"schema","TAS_RUNTIME_INVENTORY_V1");
        ln(b,"tool_version","1.0.0-tas-super-runtime");
        SimpleDateFormat date=new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'",Locale.ROOT);
        date.setTimeZone(TimeZone.getTimeZone("UTC"));
        ln(b,"captured_utc",date.format(new Date()));
        ln(b,"read_only","true");
        ln(b,"root_executed","false");
        ln(b,"network_permission","false");
        ln(b,"gpu_memory_allocated","false");
        ln(b,"system_file_modified","false");
        ln(b,"process_uid",Integer.toString(Process.myUid()));
        ln(b,"android_build_model",Build.MODEL);
        ln(b,"android_build_device",Build.DEVICE);
        ln(b,"android_sdk",Integer.toString(Build.VERSION.SDK_INT));
        b.append("[properties]\n");
        for(String key:PROPERTIES)ln(b,key,cmd("/system/bin/getprop",key));
        b.append("[/properties]\n");
        b.append("[runtime]\n");
        ln(b,"getenforce",cmd("/system/bin/getenforce"));
        ln(b,"proc_self_context",readLimited("/proc/self/attr/current",256));
        ln(b,"proc_version",readLimited("/proc/version",256));
        ln(b,"proc_self_status",readLimited("/proc/self/status",4096).replace('\n','|'));
        b.append("[/runtime]\n");
        b.append("[files]\n");
        for(int i=0;i<SYSTEM_FILES.length;i++)examine(b,SYSTEM_FILES[i],i);
        b.append("[/files]\n");
        try{b.append(probeMaliNative());}
        catch(Throwable e){ln(b,"mali_native_error",e.getClass().getSimpleName()+":"+e.getMessage());}
        b.append("TAS_RUNTIME_INVENTORY_V1_END\n");
        return b.toString();
    }
}
