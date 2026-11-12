# TAS-AN00 v0.2: confirmed KASLR leak entry denial (app context)

Actual test hardware: HUAWEI TAS-AN00 / HWTAS / TAS, EMUI 11.0.0.185, Android 10, kernel 4.14.116.

## Read-only batch results (user-provided 2026-11-12)

- SELinux context: `u:r:untrusted_app_27:s0:c512,c768`
- `perf_event_paranoid=3`
- `perf_task_user_result=error` / `errno=13`
- `perf_cpu_user_result=error` / `errno=13`
- `perf_cpu_kernel_only_result=error` / `errno=13`
- `perf_exact_result=error` / `errno=13`
- `/proc/kallsyms`, `/proc/sys/kernel/kptr_restrict`, `/proc/sys/kernel/dmesg_restrict` and `/sys/fs/selinux/enforce` reads: EACCES
- `/proc/sys/kernel/random/boot_id` readable
- Current app process UID nonzero, CapEff all zero, Seccomp mode 2.
- Existing GhostLock `--root` result: `KASLR leak failed`, exit code 1. No exploit primitive/root achieved.

**Conclusion:** The reference `perf_event_open`-based kernel text-address leak cannot start in this Android app security context. EACCES alone is not a unique signature of the responsible control; it may reflect kernel perf sysctl, SELinux, or their combination.

## Next test, without changing the exploit

Run the existing v0.2 `tas_batchprobe_arm64` under an authorized ADB shell, which has a different SELinux domain, and compare outputs. No need to reinstall the APK or rerun `--root` while this prerequisite is unresolved.

Host bundle contains a Windows PowerShell runner, a POSIX runner, the exact verified Android 10 ARM64 binary, and a Python parser that classifies results as:
- `BOTH_CONTEXTS_DENY_PERF`
- `SHELL_PERF_OPEN_ONLY`
- `SHELL_PERF_SAMPLING_AVAILABLE`
- `SHELL_PERF_OTHER_RESULT`

The shell test is read-only: device identity verification; push into `/data/local/tmp`; execute the 13 self-contained diagnostics. It does not change perf sysctl, SELinux, boot partitions, or kernel memory.

Test bundle binary SHA256: `f6d1a7d2747b400994d1a54ef1659d6c3fe01e50fd433b652dd8ef4feff3c6d7`.

GitHub Actions v0.2 build: https://github.com/lly8666/qairt-sdk-archive/actions/runs/43170972015.

The user-provided diagnostic log is summarized, not replicated in full in this public repository.
