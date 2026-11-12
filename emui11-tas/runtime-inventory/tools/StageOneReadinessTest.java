import io.github.tasaudit.runtimeinventory.StageOneReadiness;

public class StageOneReadinessTest {
    private static void require(boolean ok,String label) { if(!ok)throw new AssertionError(label); }
    private static String sample() {
        return "android_build_model=TAS-AN00\nandroid_build_device=HWTAS\nandroid_sdk=29\n"+
               "ro.build.display.id=TAS-LGRP3-CHN 11.0.0.185\n"+
               "device_0_version_ioctl=PASS\ndevice_0_version_major=11\n"+
               "device_0_version_minor=16\ngetenforce=Enforcing\n"+
               "process_uid=10161\nf01_stat=ERRNO_13\n";
    }
    public static void main(String[] args) {
        String good=StageOneReadiness.evaluate(sample());
        require(good.contains("verdict=READONLY_BASELINE_MATCH_NO_EXPLOIT_PROOF"),"known baseline");
        require(good.contains("protected_page_cache_modification=NOT_TESTED"),"no false CVE proof");
        require(good.contains("root_status=NOT_VERIFIED"),"no false Root proof");
        String mismatch=StageOneReadiness.evaluate(sample().replace("11.0.0.185","11.0.0.235"));
        require(mismatch.contains("verdict=INCONCLUSIVE_OR_TARGET_MISMATCH"),"wrong firmware rejected");
        String noGpu=StageOneReadiness.evaluate(sample().replace("device_0_version_ioctl=PASS","device_0_version_ioctl=FAIL"));
        require(noGpu.contains("mali_11_16_readonly_abi=UNKNOWN_OR_DENIED"),"no inferred Mali PASS");
        String empty=StageOneReadiness.evaluate("");
        require(empty.contains("verdict=INCONCLUSIVE_OR_TARGET_MISMATCH"),"empty input fail closed");
        require(empty.contains("root_status=NOT_VERIFIED"),"empty root fail closed");
        System.out.println("STAGE1_READONLY_PREFLIGHT_SELFTEST_PASS count=5");
    }
}
