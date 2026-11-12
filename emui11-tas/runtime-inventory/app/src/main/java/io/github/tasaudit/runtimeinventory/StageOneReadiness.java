package io.github.tasaudit.runtimeinventory;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

/** Pure Java, fail-closed interpretation of read-only, non-exploit evidence. */
public final class StageOneReadiness {
    private StageOneReadiness() {}

    static Map<String,String> parse(String text) {
        Map<String,String> result=new HashMap<>();
        if (text==null) return result;
        for (String line:text.split("\n")) {
            int eq=line.indexOf('=');
            if(eq>0) {
                String key=line.substring(0,eq).trim();
                if(!result.containsKey(key)) result.put(key,line.substring(eq+1).trim());
            }
        }
        return result;
    }

    private static String value(Map<String,String> items,String key) {
        String v=items.get(key);
        return v==null ? "" : v;
    }

    private static String status(boolean confirmed,boolean mismatch,String whenUnknown) {
        return confirmed ? "PASS" : mismatch ? "MISMATCH" : whenUnknown;
    }

    /** Never treats driver ABI success, app-owned canaries, or permissions as proof of a CVE. */
    public static String evaluate(String raw) {
        Map<String,String> m=parse(raw);
        String model=value(m,"android_build_model").toUpperCase(Locale.ROOT);
        String device=value(m,"android_build_device").toUpperCase(Locale.ROOT);
        String sdk=value(m,"android_sdk");
        String build=value(m,"ro.build.display.id")+" "+
                value(m,"ro.build.version.incremental")+" "+value(m,"ro.build.fingerprint");
        boolean modelOk=model.equals("TAS-AN00")||model.equals("HUAWEI MATE 30");
        boolean deviceOk=device.equals("HWTAS")||device.equals("TAS");
        String identity=status(modelOk&&deviceOk,(!model.isEmpty()&&!modelOk)||(!device.isEmpty()&&!deviceOk),"UNKNOWN");
        String sdkStatus=status(sdk.equals("29"),!sdk.isEmpty()&&!sdk.equals("29"),"UNKNOWN");
        boolean buildMatch=build.contains("11.0.0.185");
        String buildStatus=status(buildMatch,!build.trim().isEmpty()&&!buildMatch,"UNKNOWN");
        String nativeStatus=value(m,"device_0_version_ioctl");
        String major=value(m,"device_0_version_major");
        String minor=value(m,"device_0_version_minor");
        boolean maliOk=nativeStatus.equals("PASS")&&major.equals("11")&&minor.equals("16");
        boolean maliMismatch=nativeStatus.equals("PASS")&&(!major.equals("11")||!minor.equals("16"));
        String maliStatus=status(maliOk,maliMismatch,"UNKNOWN_OR_DENIED");

        StringBuilder b=new StringBuilder(2300);
        b.append("TAS_STAGE1_READONLY_VERDICT_V1_BEGIN\n");
        b.append("scope=NON_EXPLOIT_DEVICE_PREFLIGHT_ONLY\n");
        b.append("device_family=").append(identity).append("\n");
        b.append("android_sdk29=").append(sdkStatus).append("\n");
        b.append("emui_11_0_0_185=").append(buildStatus).append("\n");
        b.append("mali_11_16_readonly_abi=").append(maliStatus).append("\n");
        b.append("selinux_getenforce=").append(value(m,"getenforce")).append("\n");
        b.append("current_process_uid=").append(value(m,"process_uid")).append("\n");
        b.append("dumpstate_lstat=").append(value(m,"f01_stat")).append("\n");
        b.append("apex_libc_sha256=").append(value(m,"f06_sha256")).append("\n");
        b.append("app_private_canary_this_run=NOT_RUN\n");
        b.append("protected_page_cache_modification=NOT_TESTED\n");
        b.append("privileged_process_effect=NOT_TESTED\n");
        b.append("cve_2021_44828_patch_state=UNKNOWN\n");
        b.append("root_status=NOT_VERIFIED\n");
        b.append("runtime_kernel_sha256_verified=false\n");
        b.append("device_or_system_files_modified=false\n");
        b.append("exploit_operations=false\n");
        String verdict=(identity.equals("PASS")&&sdkStatus.equals("PASS")&&
                buildStatus.equals("PASS")&&maliStatus.equals("PASS"))
                ? "READONLY_BASELINE_MATCH_NO_EXPLOIT_PROOF"
                : "INCONCLUSIVE_OR_TARGET_MISMATCH";
        b.append("verdict=").append(verdict).append("\n");
        b.append("interpretation=ABI or identity matches do NOT prove protected memory access, CVE exploitability, privileged execution, or Root\n");
        b.append("TAS_STAGE1_READONLY_VERDICT_V1_END\n");
        return b.toString();
    }
}
