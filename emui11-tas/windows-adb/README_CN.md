# TAS-AN00：Windows 一键批量 ADB Shell 上下文采集

**目的：** 对比此前 APK 的 `untrusted_app_27` 与 Windows 授权 `adb shell` 的 **UID、SELinux、能力集、Perf 环境和 dumpstate 服务可见性**。采集脚本无 Root、无漏洞利用、不修改手机文件，也不主动启动 `dumpstate` 或 `bugreportz`。

## 环境

- Windows 10/11，系统自带 PowerShell 5.1；不需要 WSL / Python / Android Studio。
- <https://developer.android.com/tools/releases/platform-tools> 官方 Windows Platform-Tools，提供 `adb.exe`。
- 手机上的开发者选项 → **USB 调试**已开启，首次连接时允许电脑 RSA 调试授权。
- **只连接一台手机**。也支持手动指定序列号，避免误操作其他设备。

## Windows 使用方法

1. 解压整个包。把 `adb.exe` 的 `platform-tools` 文件夹放在解压目录内，或把 `platform-tools` 加入 Windows PATH。必须保留 `TAS_ADB_Shell_Inventory.ps1` 和 `Run_TAS_ADB_Shell_Inventory.cmd` 在同一个目录。
2. USB 连接 TAS-AN00，打开调试授权，双击 **`Run_TAS_ADB_Shell_Inventory.cmd`**。
3. 脚本检查设备是否为 `TAS-AN00`、Android SDK 29；检查不通过将中止，不对其他机型批量执行。
4. 在本目录的 `TAS_ADB_Results\日期时间\` 中找到每一项命令的原始输出、`SUMMARY.txt`、`RESULTS.json`，同级还有自动压缩的 `TAS_ADB_Shell_Context_日期时间.zip`。
5. **只需要向我提供 ZIP（先检查里面是否有不愿分享的信息）**，我会据此对比此前 APK 阶段的结果。

如果双击失败，在该文件夹打开 PowerShell：

```powershell
.\TAS_ADB_Shell_Inventory.ps1
```

如果有多个设备：

```powershell
.\TAS_ADB_Shell_Inventory.ps1 -Serial "你从 adb devices 查到的序列号"
```

如果 `adb.exe` 不在 PATH 或同目录的 `platform-tools`：

```powershell
.\TAS_ADB_Shell_Inventory.ps1 -AdbPath "C:\platform-tools\adb.exe"
```

自检（**不需要连接手机**）：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\TAS_ADB_Shell_Inventory.ps1 -SelfTest
```

注：`.cmd` 仅针对**本次 PowerShell 进程**设置执行策略，不更改 Windows 全局安全策略。也可以在 PowerShell 中运行 `Get-Content .\TAS_ADB_Shell_Inventory.ps1` 先查看全部命令。不会自动下载程序或联网上传日志。

## 可选：第二组批量 ADB shell Perf 13 项实测

如果想真正比较此前 APK 四项 `perf_event_open EACCES` 与 **ADB shell** 上下文的差异，可以在完成第一组采集后，单独双击 **`Run_TAS_ADB_Shell_Perf13.cmd`**。

这一步会严格校验包内的 `tas_batchprobe_arm64` SHA-256 为：

`f6d1a7d2747b400994d1a54ef1659d6c3fe01e50fd433b652dd8ef4feff3c6d7`

该程序来自本项目先前通过的 [Android 10 ARM64 诊断构建](https://github.com/lly8666/qairt-sdk-archive/actions/runs/43170972015)，源码为 [`ghostlock-root-test/native/tas_batch_probe.c`](../ghostlock-root-test/native/tas_batch_probe.c)。

**与第一组完全只读不同，第二组需要明确的临时操作：**使用 `adb push` 将校验过的诊断 ELF 放在手机 `/data/local/tmp/tas_batchprobe_readonly`，`chmod 700` 后以 `adb shell` 执行 `--batch`，最后通过 `rm -f` 只删除该固定路径上的临时 ELF。不会修改系统、启动 Root 服务、触发 GhostLock UAF、写内核内存或执行凭据变更。

其 13 项检测包括：进程/SELinux 环境、Perf 系统限制、受限接口可读性，以及 4 种 Perf 打开/采样状态；**不输出任何内核地址**。每项子测试独立运行，有单独的超时隔离。

结果写入 `TAS_ADB_Results\Perf13_日期时间\`，自动生成 `TAS_ADB_Shell_Perf13_日期时间.zip`。脚本会显示 `SHELL_PERF_ALL_FOUR_EACCES`、`SHELL_PERF_EXACT_OPENED_NOT_ROOT` 或其他需要复核的分类。**即使在 shell 下允许采样，也不代表已进入高权限服务，更不意味着取得 Root。**

如果设备连接不稳定、或者你只愿意做完全不写设备文件的检查，**只运行第一组即可，不用运行此可选第二组**。

## 会运行什么，不会运行什么

脚本固定执行 **33 条只读 `adb shell` 命令**，包括：

- `id`、`getenforce`、`cat /proc/self/attr/current`、筛选后的 `/proc/self/status`；
- `cat /proc/sys/kernel/perf_event_paranoid`、`cat /proc/sys/kernel/kptr_restrict`；
- `getprop` 获取系统版本、验证启动状态和 `init.svc.dumpstate*`；
- `ls -ldZ`、`sha256sum` 观察 `dumpstate`、`bugreportz`、APEX libc 是否能从 ADB shell 读取；
- `service list`、`service check`、`pidof`、**经过关键词筛选的** `ps -AZ`。

个别命令可能出现 `Permission denied`、`No such file` 或其他非零退出码：**这是有价值的诊断结果，脚本会保留，不会尝试绕过**。

**第一组采集**不执行：`adb root`、`adb remount`、`su`、`setprop`、`chmod`、`push`、`install`、`bugreportz`、`dumpstate`、Kernel Exploit、GPU 修改和 Root 权限切换；也不读取相册、账号、短信、应用数据。**第二组可选 Perf 诊断仅对固定临时 ELF 执行 push/chmod/rm**，详见上文。日志均保存在你的电脑上，不自动上传。

## 重要的实验边界

**ADB shell 上下文不是 Root，也不是普通 APK 上下文。** 在同一设备上，ADB shell 能访问文件，只能说明该上下文具有某些权限；不代表 `untrusted_app_27` 或设想中的高权限服务也一定允许。此前 APK 四项 Perf 都 EACCES；本脚本采集的是 **不同起点**的静态权限和服务可见性，不能独立证明 GhostLock 内核地址泄露或 Root。

本项目当前目标：优先对照已成功的 **MRX-W09 / Kirin990 / Linux4.14.116**，而非旧版 Android 不兼容的通用 GhostLock APK；并遵守手机最终不激活 Root 的验收要求。

建议先保留所有原始输出，不要在 GitHub 公开发布原始设备序列号或专有 ELF。该脚本默认不会采集设备序列号到结果文件，也不会拉取完整系统可执行文件。
