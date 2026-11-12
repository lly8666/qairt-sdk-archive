package io.github.tasaudit.diag;

import java.util.LinkedHashMap;
import java.util.Map;

/** Pure Java, deterministic, fail-closed target identity checker. */
public final class TargetMatcher {
    public static final String FIRMWARE = "TAS-LGRP3-CHN 11.0.0.185";
    public static final String ZIP_SHA256 = "fb4cec6aa905416ede031cca602783bc1e59fdd89ee96ba1aaa54dbdaf351b0f";
    public static final String KERNEL_IMAGE_SHA256 = "d4b6f00aff4a4e05a3d5d794552165b0c950913aa841b356cae9bc69ae8ea2e5";
    private TargetMatcher() {}
    public enum Status { PASS, FAIL, UNKNOWN }

    public static Map<String, Status> assess(Map<String, String> p) {
        Map<String, Status> out = new LinkedHashMap<>();
        String device = p.get("ro.product.device");
        String model = p.get("ro.product.model");
        String arch = p.get("uname_machine");
        String release = p.get("uname_release");
        String build = visible(p.get("ro.build.display.id")) + " " + visible(p.get("ro.build.version.incremental"));
        String version = visible(p.get("proc_version")) + " " + visible(p.get("uname_version"));
        out.put("TAS device family", prefixOrUnknown(device, "TAS"));
        out.put("Huawei Mate 30 model", modelOrUnknown(model));
        out.put("ARM64 architecture", exactOrUnknown(arch, "aarch64", "arm64"));
        out.put("Linux exact release 4.14.116", exactOrUnknown(release, "4.14.116"));
        out.put("Android 10", exactOrUnknown(p.get("ro.build.version.release"), "10"));
        out.put("Android SDK 29", exactOrUnknown(p.get("ro.build.version.sdk"), "29"));
        out.put("EMUI 11.0.0.185 build", buildMatch(build));
        out.put("2021-07-21 kernel build", buildDateMatch(version));
        return out;
    }

    private static String visible(String x) { return missing(x) ? "" : x; }
    private static boolean missing(String x) {
        return x == null || x.trim().isEmpty() || "UNREADABLE".equalsIgnoreCase(x.trim());
    }
    private static Status exactOrUnknown(String input, String... expected) {
        if (missing(input)) return Status.UNKNOWN;
        for (String e : expected) if (e.equalsIgnoreCase(input.trim())) return Status.PASS;
        return Status.FAIL;
    }
    private static Status prefixOrUnknown(String input, String prefix) {
        if (missing(input)) return Status.UNKNOWN;
        return input.toUpperCase(java.util.Locale.ROOT).startsWith(prefix) ? Status.PASS : Status.FAIL;
    }
    private static Status modelOrUnknown(String model) {
        if (missing(model)) return Status.UNKNOWN;
        String s = model.toUpperCase(java.util.Locale.ROOT);
        return (s.equals("HUAWEI MATE 30") || s.equals("MATE 30")
                || s.equals("TAS-AL00") || s.equals("TAS-TL00")) ? Status.PASS : Status.FAIL;
    }
    private static Status buildMatch(String build) {
        if (build.trim().isEmpty()) return Status.UNKNOWN;
        String marker = "11.0.0.185";
        for (int from = 0; (from = build.indexOf(marker, from)) >= 0; from++) {
            int end = from + marker.length();
            if (end == build.length() || !Character.isDigit(build.charAt(end))) return Status.PASS;
        }
        return Status.FAIL;
    }
    private static Status buildDateMatch(String version) {
        if (version.trim().isEmpty()) return Status.UNKNOWN;
        return version.contains("Jul 21 19:39:33") && version.contains("2021") ? Status.PASS : Status.FAIL;
    }
    public static String verdict(Map<String, Status> checks) {
        boolean unknown = false;
        for (Status s : checks.values()) {
            if (s == Status.FAIL) return "MISMATCH_DO_NOT_PROCEED";
            if (s == Status.UNKNOWN) unknown = true;
        }
        return unknown ? "INCONCLUSIVE_DO_NOT_PROCEED" : "IDENTITY_MATCH_NOT_ROOT_VERIFICATION";
    }
}
