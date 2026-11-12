package io.github.tasaudit.runtimeinventory;

import android.content.Context;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.Locale;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

/** Exports only a fixed allowlist of system-owned, non-user-private OS files. */
public final class SystemFileExporter {
    private static final String[] ALLOWLIST={
        "/system/bin/bugreportz",
        "/system/bin/toybox",
        "/system/bin/app_process64",
        "/apex/com.android.runtime/lib64/bionic/libc.so",
        "/vendor/etc/selinux/vendor_sepolicy.cil",
        "/vendor/etc/selinux/vendor_file_contexts",
        "/system/bin/dumpstate" // likely EACCES; recorded as skipped
    };
    private SystemFileExporter(){}

    public static File create(Context context) throws Exception {
        File dest=new File(context.getCacheDir(),SystemFileExportProvider.ZIP_NAME);
        StringBuilder summary=new StringBuilder(2000);
        summary.append("TAS_AN00_OS_BINARIES_V1\n")
            .append("Purpose: exact ELF/SELinux file matching to target EMUI 11 firmware.\n")
            .append("Files are system/vendor files only, never user private data.\n")
            .append("No network or upload is performed by the app.\n");
        try(ZipOutputStream zip=new ZipOutputStream(new BufferedOutputStream(
                new FileOutputStream(dest,false)))) {
            byte[] buffer=new byte[32768];
            int fileNo=0;
            for(String path:ALLOWLIST){
                String name=path.startsWith("/")?path.substring(1):path;
                File source=new File(path);
                if(!source.isFile() || source.length()>16*1024*1024L){
                    summary.append("SKIP ").append(path).append(" : not regular, unreadable, or too large\n");
                    continue;
                }
                MessageDigest digest=MessageDigest.getInstance("SHA-256");
                long bytes=0;
                boolean opened=false;
                try(FileInputStream in=new FileInputStream(source)){
                    opened=true;
                    zip.putNextEntry(new ZipEntry("os/"+name));
                    int n;
                    while((n=in.read(buffer))!=-1){
                        zip.write(buffer,0,n);
                        digest.update(buffer,0,n);
                        bytes+=n;
                    }
                    zip.closeEntry();
                }catch(IOException e){
                    if(opened)throw e;
                    summary.append("SKIP ").append(path).append(" : ")
                        .append(e.getClass().getSimpleName()).append('\n');
                    continue;
                }
                StringBuilder sha=new StringBuilder();
                for(byte b:digest.digest())sha.append(String.format(Locale.ROOT,"%02x",b&255));
                summary.append("FILE ").append(path).append(" bytes=").append(bytes)
                    .append(" sha256=").append(sha).append('\n');
                fileNo++;
            }
            if(fileNo<3) throw new IOException("Too few public system files could be read.");
            zip.putNextEntry(new ZipEntry("OS_FILE_MANIFEST.txt"));
            zip.write(summary.toString().getBytes(StandardCharsets.UTF_8));
            zip.closeEntry();
        }
        return dest;
    }
}
