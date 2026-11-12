import io.github.tasaudit.diag.TargetMatcher;
import java.util.LinkedHashMap;
import java.util.Map;

public final class TargetMatcherTest {
    private static int passed=0;
    private static Map<String,String> sample() {
        Map<String,String> p=new LinkedHashMap<>();
        p.put("ro.product.device","TAS-AL00");
        p.put("ro.product.model","HUAWEI Mate 30");
        p.put("uname_machine","aarch64");
        p.put("uname_release","4.14.116");
        p.put("ro.build.version.release","10");
        p.put("ro.build.version.sdk","29");
        p.put("ro.build.display.id","TAS-LGRP3-CHN 11.0.0.185(C00E185R6P2)");
        p.put("ro.build.version.incremental","11.0.0.185");
        p.put("proc_version","Linux version 4.14.116 Wed Jul 21 19:39:33 CST 2021");
        return p;
    }
    private static void expect(String reason, Map<String,String> d,String expected) {
        String got=TargetMatcher.verdict(TargetMatcher.assess(d));
        if(!expected.equals(got)) throw new AssertionError(reason+": expected="+expected+" got="+got);
        System.out.println("PASS "+reason+" "+got); passed++;
    }
    public static void main(String[] args) {
        Map<String,String> a=sample();
        expect("same build",a,"IDENTITY_MATCH_NOT_ROOT_VERIFICATION");
        a=sample(); a.put("ro.product.device","MRX-W09");
        expect("wrong family",a,"MISMATCH_DO_NOT_PROCEED");
        a=sample(); a.put("uname_release","4.14.116-foobar");
        expect("different kernel suffix",a,"MISMATCH_DO_NOT_PROCEED");
        a=sample(); a.put("uname_release","4.14.1169");
        expect("deceptive kernel prefix",a,"MISMATCH_DO_NOT_PROCEED");
        a=sample(); a.put("ro.build.version.release","11");
        expect("wrong Android version",a,"MISMATCH_DO_NOT_PROCEED");
        a=sample(); a.put("ro.build.display.id","TAS 11.0.0.1850");a.put("ro.build.version.incremental","");
        expect("wrong version suffix",a,"MISMATCH_DO_NOT_PROCEED");
        a=sample(); a.put("ro.build.display.id","");a.put("ro.build.version.incremental","");
        expect("missing build inconclusive",a,"INCONCLUSIVE_DO_NOT_PROCEED");
        a=sample(); a.put("proc_version","UNREADABLE"); a.put("uname_version","");
        expect("missing compile date inconclusive",a,"INCONCLUSIVE_DO_NOT_PROCEED");
        a=sample(); a.put("ro.product.model","");
        expect("missing model inconclusive",a,"INCONCLUSIVE_DO_NOT_PROCEED");
        a=sample(); a.put("ro.product.model","Mate 30 Pro");
        expect("different model rejected",a,"MISMATCH_DO_NOT_PROCEED");
        System.out.println("TEST_COUNT="+passed);
    }
}
