package io.github.tasaudit.diag;

import android.os.Build;
import android.system.Os;
import android.system.StructUtsname;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/** Strictly read-only. Whitelisted system properties and procfs paths only. */
public final class ProbeCollector {
    private static final String[] PROPERTIES = {
        "ro.product.model", "ro.product.device", "ro.product.board", "ro.product.cpu.abi",
        "ro.build.version.emui", "ro.build.version.release", "ro.build.version.sdk",
        "ro.build.display.id", "ro.build.version.incremental", "ro.build.fingerprint",
        "ro.boot.verifiedbootstate", "ro.boot.vbmeta.device_state", "ro.build.version.security_patch"
    };
    private ProbeCollector() {}

    public static Map<String,String> collect() {
        Map<String,String> p = new LinkedHashMap<>();
        try {
            StructUtsname u = Os.uname();
            p.put("uname_sysname", scrub(u.sysname));
            p.put("uname_release", scrub(u.release));
            p.put("uname_version", scrub(u.version));
            p.put("uname_machine", scrub(u.machine));
        } catch (Exception t) { p.put("uname_error", t.getClass().getSimpleName()); }
        p.put("proc_version", firstLine("/proc/version"));
        p.put("proc_self_attr_current", firstLine("/proc/self/attr/current"));
        p.put("selinux_enforcing", selinux());
        p.put("proc_self_uid", fieldFromProcStatus("Uid:"));
        p.put("proc_self_cap_eff", fieldFromProcStatus("CapEff:"));
        p.put("proc_self_no_new_privs", fieldFromProcStatus("NoNewPrivs:"));
        p.put("proc_self_seccomp", fieldFromProcStatus("Seccomp:"));
        for (String k: PROPERTIES) p.put(k, getprop(k));
        // Public Android APIs are a fallback when EMUI blocks getprop execution.
        if (empty(p.get("ro.product.board"))) p.put("ro.product.board", scrub(Build.BOARD));
        if (empty(p.get("ro.product.cpu.abi")) && Build.SUPPORTED_ABIS.length > 0)
            p.put("ro.product.cpu.abi", scrub(Build.SUPPORTED_ABIS[0]));
        if (empty(p.get("ro.build.display.id"))) p.put("ro.build.display.id", scrub(Build.DISPLAY));
        if (empty(p.get("ro.build.version.incremental")))
            p.put("ro.build.version.incremental", scrub(Build.VERSION.INCREMENTAL));
        if (empty(p.get("ro.build.version.security_patch")))
            p.put("ro.build.version.security_patch", scrub(Build.VERSION.SECURITY_PATCH));
        if (empty(p.get("ro.product.model"))) p.put("ro.product.model", scrub(Build.MODEL));
        if (empty(p.get("ro.product.device"))) p.put("ro.product.device", scrub(Build.DEVICE));
        if (empty(p.get("ro.build.version.release"))) p.put("ro.build.version.release", scrub(Build.VERSION.RELEASE));
        if (empty(p.get("ro.build.version.sdk"))) p.put("ro.build.version.sdk", Integer.toString(Build.VERSION.SDK_INT));
        if (empty(p.get("ro.build.fingerprint"))) p.put("ro.build.fingerprint", scrub(Build.FINGERPRINT));
        return p;
    }

    private static boolean empty(String s) { return s==null || s.trim().isEmpty() || s.equals("UNREADABLE"); }
    private static String scrub(String value) {
        if (value==null) return "";
        StringBuilder b = new StringBuilder();
        for (int i=0; i<value.length() && b.length()<450; i++) {
            char c = value.charAt(i);
            b.append((c=='\n'||c=='\r'||Character.isISOControl(c))?' ':c);
        }
        return b.toString().trim();
    }
    private static String firstLine(String filename) {
        try (BufferedReader r = new BufferedReader(new FileReader(filename))) {
            String s = r.readLine();
            return s==null ? "UNREADABLE" : scrub(s);
        } catch (Exception e) { return "UNREADABLE"; }
    }
    private static String fieldFromProcStatus(String key) {
        try (BufferedReader r = new BufferedReader(new FileReader("/proc/self/status"))) {
            String line;
            while ((line=r.readLine())!=null) {
                if (line.startsWith(key)) return scrub(line.substring(key.length()).trim());
            }
        } catch (Exception ignored) {}
        return "UNREADABLE";
    }
    private static String selinux() {
        String raw = firstLine("/sys/fs/selinux/enforce");
        return "1".equals(raw)?"yes":"0".equals(raw)?"no":"UNREADABLE";
    }
    private static String getprop(String property) {
        Process process = null;
        try {
            process = new ProcessBuilder("/system/bin/getprop",property).redirectErrorStream(true).start();
            if (!process.waitFor(2, TimeUnit.SECONDS)) {
                process.destroyForcibly();
                return "UNREADABLE";
            }
            try (BufferedReader r = new BufferedReader(new InputStreamReader(
                    process.getInputStream(), StandardCharsets.UTF_8))) {
                String s=r.readLine();
                return s==null?"":scrub(s);
            }
        } catch (Exception ignored) { return "UNREADABLE"; }
        finally { if (process!=null) process.destroy(); }
    }
}
