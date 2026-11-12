package io.github.tasaudit.ghostlockrootlab;

import android.content.Context;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.concurrent.TimeUnit;

/** Pinned native binary launcher; persists logs across kernel panic/reboot if storage survives. */
public final class NativeRunner {
    public interface Listener { void onLog(String text); }
    private static final String EXEC_ASSET="ghostlock_tas_an00_arm64";
    private static final String HASH_ASSET="ghostlock_tas.sha256";
    private static final String BATCH_EXEC_ASSET="tas_batchprobe_arm64";
    private static final String BATCH_HASH_ASSET="tas_batchprobe.sha256";
    private static final int LIMIT_BYTES=1024*1024;
    private NativeRunner() {}

    private static String sha256(byte[] bytes) throws Exception {
        byte[] hash=MessageDigest.getInstance("SHA-256").digest(bytes);
        StringBuilder out=new StringBuilder();
        for(byte b:hash) out.append(String.format(java.util.Locale.ROOT,"%02x",b & 0xff));
        return out.toString();
    }
    private static byte[] readAll(InputStream input) throws IOException {
        ByteArrayOutputStream out=new ByteArrayOutputStream();
        byte[] buffer=new byte[32768]; int n;
        while((n=input.read(buffer))!=-1) {
            if(out.size()+n>2*1024*1024) throw new IOException("native payload too big");
            out.write(buffer,0,n);
        }
        return out.toByteArray();
    }
    private static File prepare(Context context, String mode) throws Exception {
        boolean batch="--batch".equals(mode);
        String execAsset=batch?BATCH_EXEC_ASSET:EXEC_ASSET;
        String shaAsset=batch?BATCH_HASH_ASSET:HASH_ASSET;
        byte[] binary;
        try(InputStream in=context.getAssets().open(execAsset)) {binary=readAll(in);}
        String actual=sha256(binary);
        String wanted;
        try(InputStream in=context.getAssets().open(shaAsset)) {
            wanted=new String(readAll(in),StandardCharsets.US_ASCII).trim();
        }
        if(!wanted.matches("[0-9a-f]{64}") || !wanted.equals(actual))
            throw new SecurityException("native payload SHA256 mismatch");
        File target=new File(context.getFilesDir(),batch?"tas_batchprobe_native":"tas_ghostlock_native");
        try(FileOutputStream out=new FileOutputStream(target,false)) {out.write(binary);out.getFD().sync();}
        if(!target.setExecutable(true,true))
            throw new IOException("execution permission blocked by filesystem / SELinux");
        return target;
    }
    public static File lastLog(Context c){return new File(c.getFilesDir(),"tas_ghostlock_last.txt");}
    public static String readLast(Context c) {
        File p=lastLog(c);
        if(!p.exists()) return "尚无实验日志";
        try(FileInputStream in=new FileInputStream(p)) {
            return new String(readAll(in),StandardCharsets.UTF_8);
        }catch(Exception e){return "读取历史日志失败："+e;}
    }
    public static void run(Context context,String mode,int timeoutSeconds,Listener listener) {
        String header="TAS_GHOSTLOCK_ROOTLAB_BEGIN\nmode="+mode+"\nrun_context=app_sandbox\n";
        File file=lastLog(context);
        Process p=null;
        int exit=-999;
        try(FileOutputStream log=new FileOutputStream(file,false)) {
            log.write(header.getBytes(StandardCharsets.UTF_8));log.getFD().sync();
            listener.onLog(header);
            File executable=prepare(context,mode);
            p=new ProcessBuilder(executable.getAbsolutePath(),mode)
                .directory(context.getFilesDir()).redirectErrorStream(true).start();
            Process running=p;
            Thread reader=new Thread(()->{
                try(BufferedReader input=new BufferedReader(
                        new InputStreamReader(running.getInputStream(),StandardCharsets.UTF_8))) {
                    String line;int count=0,bytes=0;
                    while((line=input.readLine())!=null) {
                        String value=line+"\n";
                        byte[] raw=value.getBytes(StandardCharsets.UTF_8);
                        if(bytes+raw.length>LIMIT_BYTES) continue;
                        bytes+=raw.length;
                        synchronized(log) {log.write(raw);if(++count%8==0)log.getFD().sync();}
                        listener.onLog(value);
                    }
                }catch(IOException e){listener.onLog("READER_ERROR="+e+"\n");}
            },"TASGhostLockReader");
            reader.setDaemon(true);reader.start();
            if(!p.waitFor(timeoutSeconds,TimeUnit.SECONDS)) {
                listener.onLog("NATIVE_TIMEOUT="+timeoutSeconds+"s\n");
                p.destroy();
                if(!p.waitFor(2,TimeUnit.SECONDS))p.destroyForcibly();
                exit=-998;
            }else exit=p.exitValue();
            reader.join(1500);
            String footer="native_exit_code="+exit+"\nTAS_GHOSTLOCK_ROOTLAB_END\n";
            synchronized(log){log.write(footer.getBytes(StandardCharsets.UTF_8));log.getFD().sync();}
            listener.onLog(footer);
        }catch(Throwable t){
            String failure="LAUNCH_OR_RUNTIME_ERROR="+t.getClass().getSimpleName()+": "+t.getMessage()+"\n";
            listener.onLog(failure);
            try(FileOutputStream out=new FileOutputStream(file,true)){
                out.write(failure.getBytes(StandardCharsets.UTF_8));out.getFD().sync();
            }catch(IOException ignored){}
        }finally{if(p!=null && p.isAlive())p.destroyForcibly();}
    }
}
