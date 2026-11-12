import io.github.tasaudit.diag.TargetMatcher;
import java.util.LinkedHashMap;
import java.util.Map;

/** Test fixture synthesized from TAS-AN00 firmware identity; no unique device IDs. */
public final class TargetMatcherTest {
    private static int passed=0;
    private static Map<String,String> sample() {
        Map<String,String> p=new LinkedHashMap<>();
        p.put("ro.product.device","HWTAS");
        p.put("ro.product.board","TAS");
        p.put("ro.product.model","TAS-AN00");
        p.put("uname_machine","aarch64");
        p.put("uname_release","4.14.116");
        p.put("ro.build.version.release","10");
        p.put("ro.build.version.sdk","29");
        p.put("ro.build.display.id","TAS-AN00 11.0.0.185(C00E180R7P11)");
        p.put("ro.build.version.incremental","11.0.0.185C00");
        p.put("ro.build.fingerprint","HUAWEI/TAS-AN00/HWTAS:10/HUAWEITAS-AN00/11.0.0.185C00:user/release-keys");
        p.put("proc_version","UNREADABLE");
        p.put("uname_version","#1 SMP PREEMPT Wed Jul 21 19:39:33 CST 2021");
        return p;
    }
    private static void expect(String reason, Map<String,String> d,String expected) {
        String got=TargetMatcher.verdict(TargetMatcher.assess(d));
        if(!expected.equals(got)) throw new AssertionError(reason+": expected="+expected+" got="+got);
        System.out.println("PASS "+reason+" "+got); ++passed;
    }
    public static void main(String[] args) {
        Map<String,String> a=sample();
        expect("exact TAS-AN00 HWTAS build",a,"IDENTITY_MATCH_NOT_ROOT_VERIFICATION");
        a=sample();a.put("ro.product.device","MRX-W09");
        expect("wrong Huawei family",a,"MISMATCH_DO_NOT_PROCEED");
        a=sample();a.put("ro.product.board","PNM");
        expect("wrong hardware board",a,"MISMATCH_DO_NOT_PROCEED");
        a=sample();a.put("ro.product.device","HWTASPRO");
        expect("deceptive HWTAS prefix",a,"MISMATCH_DO_NOT_PROCEED");
        a=sample();a.put("ro.product.model","TAS-AL00");
        expect("alternate SKU inconsistent with fingerprint",a,"MISMATCH_DO_NOT_PROCEED");
        a=sample();a.put("ro.product.model","Mate 30 Pro");
        expect("different model",a,"MISMATCH_DO_NOT_PROCEED");
        a=sample();a.put("uname_release","4.14.116-foo");
        expect("different Linux suffix",a,"MISMATCH_DO_NOT_PROCEED");
        a=sample();a.put("ro.build.version.sdk","30");
        expect("different Android SDK",a,"MISMATCH_DO_NOT_PROCEED");
        a=sample();a.put("ro.build.display.id","11.0.0.1850");a.put("ro.build.version.incremental","");
        expect("incorrect firmware suffix",a,"MISMATCH_DO_NOT_PROCEED");
        a=sample();a.put("ro.build.display.id","");a.put("ro.build.version.incremental","");
        expect("missing build identifier",a,"INCONCLUSIVE_DO_NOT_PROCEED");
        a=sample();a.put("ro.build.fingerprint","");
        expect("missing fingerprint",a,"INCONCLUSIVE_DO_NOT_PROCEED");
        a=sample();a.put("ro.build.fingerprint","HUAWEI/TAS-AN00/HWTAS:10/HUAWEITAS-AN00/11.0.0.186C00:user/release-keys");
        expect("wrong firmware fingerprint",a,"MISMATCH_DO_NOT_PROCEED");
        a=sample();a.put("uname_version","");
        expect("missing kernel build date",a,"INCONCLUSIVE_DO_NOT_PROCEED");
        a=sample();a.put("proc_version","UNREADABLE");
        expect("proc_version unreadable, uname fallback",a,"IDENTITY_MATCH_NOT_ROOT_VERIFICATION");
        System.out.println("TEST_COUNT="+passed);
    }
}
