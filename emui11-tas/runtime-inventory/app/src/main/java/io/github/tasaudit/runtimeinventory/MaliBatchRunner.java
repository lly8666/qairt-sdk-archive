package io.github.tasaudit.runtimeinventory;

import android.content.Context;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.Locale;
import java.util.concurrent.TimeUnit;

/** Runs the six fork-isolated Bifrost 11.16 API probes with durable logs. */
public final class MaliBatchRunner {
    public interface Listener { void onLog(String text); }
    private static final String BIN_NAME="tas_mali_batch_arm64";
    private static final String HASH_NAME="tas_mali_batch.sha256";
    public static final String LOG_NAME="TAS_MALI_COMPAT_V2_last.txt";
    private MaliBatchRunner() {}

    private static byte[] readLimited(InputStream in,int max) throws IOException {
        ByteArrayOutputStream buf=new ByteArrayOutputStream();
        byte[] chunk=new byte[16384];int n;
        while((n=in.read(chunk))!=-1){
            if(buf.size()+n>max)throw new IOException("asset too large");
            buf.write(chunk,0,n);
        }
        return buf.toByteArray();
    }
    private static String sha(byte[] bytes) throws Exception {
        MessageDigest md=MessageDigest.getInstance("SHA-256");
        byte[] hash=md.digest(bytes);
        StringBuilder b=new StringBuilder();
        for(byte x:hash)b.append(String.format(Locale.ROOT,"%02x",x&255));
        return b.toString();
    }
    public static String readLast(Context c){
        File f=new File(c.getFilesDir(),LOG_NAME);
        if(!f.isFile())return "没有 GPU 批量测试历史记录。";
        try(InputStream in=new FileInputStream(f)){
            return new String(readLimited(in,1024*1024),StandardCharsets.UTF_8);
        }catch(Exception e){return "读取失败: "+e;}
    }
    private static File executable(Context context) throws Exception {
        byte[] binary,expected;
        try(InputStream in=context.getAssets().open(BIN_NAME)) {
            binary=readLimited(in,256*1024);
        }
        try(InputStream in=context.getAssets().open(HASH_NAME)) {
            expected=readLimited(in,100);
        }
        String hash=new String(expected,StandardCharsets.US_ASCII).trim();
        if(!hash.matches("[a-f0-9]{64}")||!hash.equals(sha(binary)))
            throw new SecurityException("GPU native executable hash mismatch");
        File output=new File(context.getFilesDir(),"tas_mali_probe_native");
        try(FileOutputStream stream=new FileOutputStream(output,false)){
            stream.write(binary);
            stream.getFD().sync();
        }
        if(!output.setExecutable(true,true))
            throw new IOException("native executable blocked by filesystem / SELinux");
        return output;
    }
    public static void run(Context context,Listener listener){
        final File file=new File(context.getFilesDir(),LOG_NAME);
        java.lang.Process p=null;
        try(FileOutputStream out=new FileOutputStream(file,false)){
            String heading="TAS_MALI_BATCH_RUNNER_BEGIN\n"
                +"test_context=Android_app\n"
                +"danger=GPU_IOCTL_MEM_IMPORT_AND_APP_PRIVATE_PAGE_CACHE_CANARY\n"
                +"system_file_modified=false\n";
            out.write(heading.getBytes(StandardCharsets.UTF_8));out.getFD().sync();
            listener.onLog(heading);
            File binary=executable(context);
            p=new ProcessBuilder(binary.getAbsolutePath(),"--batch",context.getFilesDir().getAbsolutePath())
                .directory(context.getFilesDir()).redirectErrorStream(true).start();
            java.lang.Process running=p;
            Thread reader=new Thread(()->{
                try(BufferedReader in=new BufferedReader(
                        new InputStreamReader(running.getInputStream(),StandardCharsets.UTF_8))){
                    String line;
                    while((line=in.readLine())!=null){
                        byte[] bytes=(line+"\n").getBytes(StandardCharsets.UTF_8);
                        synchronized(out){
                            out.write(bytes);out.getFD().sync();
                        }
                        listener.onLog(line+"\n");
                    }
                }catch(Exception e){listener.onLog("PIPE_READER_ERROR="+e+"\n");}
            },"TAS-Mali-Stdout");
            reader.setDaemon(true);reader.start();
            int exit=-999;
            if(p.waitFor(70,TimeUnit.SECONDS))exit=p.exitValue();
            else{
                p.destroy();if(!p.waitFor(2,TimeUnit.SECONDS))p.destroyForcibly();
                exit=-998;
            }
            reader.join(2000);
            String footer="native_exit_code="+exit+"\nTAS_MALI_BATCH_RUNNER_END\n";
            synchronized(out){out.write(footer.getBytes(StandardCharsets.UTF_8));out.getFD().sync();}
            listener.onLog(footer);
        }catch(Throwable e){
            String error="MALI_RUN_ERROR="+e.getClass().getSimpleName()+": "+e.getMessage()+"\n";
            listener.onLog(error);
            try(FileOutputStream out=new FileOutputStream(file,true)){
                out.write(error.getBytes(StandardCharsets.UTF_8));out.getFD().sync();
            }catch(IOException ignored){}
        }finally{if(p!=null&&p.isAlive())p.destroyForcibly();}
    }
}
