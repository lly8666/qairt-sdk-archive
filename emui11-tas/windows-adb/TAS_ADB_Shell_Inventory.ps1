#requires -Version 5.1
<#
  TAS-AN00 / EMUI 11 (Android 10): Windows ADB shell-context survey.
  Read-only. Does not request root, trigger dumpstate, or execute an exploit.
  PowerShell 5.1+; adb.exe via PATH or .\platform-tools\adb.exe.
#>
[CmdletBinding()]
param(
    [string]$Serial = "",
    [string]$AdbPath = "adb.exe",
    [switch]$SelfTest,
    [switch]$NoZip
)

$ErrorActionPreference = 'Stop'

$specs = @(
    @{Name='01_model'; Cmd='getprop ro.product.model'},
    @{Name='02_device'; Cmd='getprop ro.product.device'},
    @{Name='03_android_sdk'; Cmd='getprop ro.build.version.sdk'},
    @{Name='04_build'; Cmd='getprop ro.build.display.id'},
    @{Name='05_kernel'; Cmd='uname -r'},
    @{Name='06_build_type'; Cmd='getprop ro.build.type'},
    @{Name='07_secure'; Cmd='getprop ro.secure'},
    @{Name='08_debuggable'; Cmd='getprop ro.debuggable'},
    @{Name='09_verified_boot'; Cmd='getprop ro.boot.verifiedbootstate'},
    @{Name='10_vbmeta_state'; Cmd='getprop ro.boot.vbmeta.device_state'},
    @{Name='11_shell_id'; Cmd='id'},
    @{Name='12_selinux_enforcing'; Cmd='getenforce'},
    @{Name='13_shell_selinux_domain'; Cmd='cat /proc/self/attr/current'},
    @{Name='14_shell_proc_status'; Cmd='cat /proc/self/status'},
    @{Name='15_perf_paranoid'; Cmd='cat /proc/sys/kernel/perf_event_paranoid'},
    @{Name='16_kptr_restrict'; Cmd='cat /proc/sys/kernel/kptr_restrict'},
    @{Name='17_dumpstate_service_prop'; Cmd='getprop init.svc.dumpstate'},
    @{Name='18_dumpstatez_service_prop'; Cmd='getprop init.svc.dumpstatez'},
    @{Name='19_bugreportd_service_prop'; Cmd='getprop init.svc.bugreportd'},
    @{Name='20_bugreport_service_prop'; Cmd='getprop init.svc.bugreport'},
    @{Name='21_dumpstate_file_label'; Cmd='ls -ldZ /system/bin/dumpstate'},
    @{Name='22_bugreportz_file_label'; Cmd='ls -ldZ /system/bin/bugreportz'},
    @{Name='23_dumpstate_socket'; Cmd='ls -ldZ /dev/socket/dumpstate'},
    @{Name='24_dumpstatez_socket'; Cmd='ls -ldZ /dev/socket/dumpstatez'},
    @{Name='25_dumpstate_sha256'; Cmd='sha256sum /system/bin/dumpstate'},
    @{Name='26_bugreportz_sha256'; Cmd='sha256sum /system/bin/bugreportz'},
    @{Name='27_apex_libc_sha256'; Cmd='sha256sum /apex/com.android.runtime/lib64/bionic/libc.so'},
    @{Name='28_service_list'; Cmd='service list'},
    @{Name='29_service_check_bugreport'; Cmd='service check bugreport'},
    @{Name='30_service_check_dumpstate'; Cmd='service check dumpstate'},
    @{Name='31_dumpstate_pid'; Cmd='pidof dumpstate'},
    @{Name='32_dumpstatez_pid'; Cmd='pidof dumpstatez'},
    @{Name='33_process_list'; Cmd='ps -AZ'}
)

function Test-ReadOnlyCommand([string]$Command) {
    if ($Command -match '[;&|><]') { return $false }
    if ($Command -match '^getprop [a-zA-Z0-9._]+$') { return $true }
    if ($Command -match '^(id|getenforce|uname -r|service list|service check (bugreport|dumpstate)|pidof (dumpstate|dumpstatez)|ps -AZ)$') {
        return $true
    }
    if ($Command -match '^cat /(proc/self/(attr/current|status)|proc/sys/kernel/(perf_event_paranoid|kptr_restrict))$') {
        return $true
    }
    if ($Command -match '^ls -ldZ /(system/bin/(dumpstate|bugreportz)|dev/socket/(dumpstate|dumpstatez))$') {
        return $true
    }
    if ($Command -match '^sha256sum /(system/bin/(dumpstate|bugreportz)|apex/com.android.runtime/lib64/bionic/libc.so)$') {
        return $true
    }
    return $false
}

foreach ($item in $specs) {
    if (-not (Test-ReadOnlyCommand $item.Cmd)) { throw "Unsafe survey command blocked: $($item.Cmd)" }
}
if ($SelfTest) {
    if ($specs.Count -ne 33) { throw "Expected 33 fixed read-only commands" }
    if (Test-ReadOnlyCommand 'setprop persist.sys.root 1') { throw "Mutating command not blocked" }
    if (Test-ReadOnlyCommand 'su -c id') { throw "Root command not blocked" }
    if (Test-ReadOnlyCommand 'cat /data/system/packages.xml') { throw "Private file read not blocked" }
    if (Test-ReadOnlyCommand 'id; reboot') { throw "Command chaining not blocked" }
    if (Test-ReadOnlyCommand 'bugreportz') { throw "Service trigger not blocked" }
    Write-Host 'TAS_WINDOWS_ADB_SHELL_INVENTORY_SELFTEST_PASS'
    exit 0
}

$localAdb = Join-Path $PSScriptRoot 'platform-tools\adb.exe'
if ($AdbPath -eq 'adb.exe' -and (Test-Path -LiteralPath $localAdb)) {
    $AdbPath = $localAdb
}
$adbCommand = Get-Command $AdbPath -ErrorAction SilentlyContinue
if (-not $adbCommand) {
    throw "adb.exe not found. Put Android platform-tools into PATH, or put platform-tools\adb.exe beside this script. Option: -AdbPath C:\path\adb.exe"
}
$AdbPath = $adbCommand.Source

$deviceLines = @(& $AdbPath devices 2>&1 | ForEach-Object { $_.ToString() })
$connected = @(
    foreach ($line in $deviceLines) {
        if ($line -match '^(\S+)\s+device\s*$') { $Matches[1] }
    }
)
if ($Serial -eq '') {
    if ($connected.Count -ne 1) {
        throw ("Expected exactly one authorized ADB device; found {0}. Run adb devices, approve USB debugging, or specify -Serial. ADB output: {1}" -f $connected.Count, ($deviceLines -join '; '))
    }
    $Serial = [string]$connected[0]
} elseif ($connected -notcontains $Serial) {
    throw "Selected serial is not in the authorized device list."
}

function Invoke-Read([string]$RemoteCommand) {
    if (-not (Test-ReadOnlyCommand $RemoteCommand)) {
        throw "Read-only allowlist rejected command: $RemoteCommand"
    }
    $previous = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        $lines = @(& $AdbPath -s $Serial shell $RemoteCommand 2>&1 | ForEach-Object { $_.ToString() })
        $exitCode = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $previous
    }
    return [pscustomobject]@{ExitCode=[int]$exitCode; Output=($lines -join [Environment]::NewLine).Trim()}
}

$modelResult = Invoke-Read 'getprop ro.product.model'
$sdkResult = Invoke-Read 'getprop ro.build.version.sdk'
if ($modelResult.ExitCode -ne 0 -or $modelResult.Output -ne 'TAS-AN00') {
    throw ("Wrong handset or model unavailable: {0}. Refusing to collect." -f $modelResult.Output)
}
if ($sdkResult.ExitCode -ne 0 -or $sdkResult.Output -ne '29') {
    throw ("Unexpected Android SDK: {0}. Expected API29; refusing to collect." -f $sdkResult.Output)
}

$stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$folderRoot = Join-Path $PSScriptRoot 'TAS_ADB_Results'
$folder = Join-Path $folderRoot $stamp
New-Item -ItemType Directory -Path $folder -Force | Out-Null

$entries = @()
foreach ($item in $specs) {
    Write-Host ("[{0}/{1}] adb shell {2}" -f ($entries.Count+1),$specs.Count,$item.Cmd)
    $result = Invoke-Read $item.Cmd
    $output = $result.Output
    if ($item.Name -in @('28_service_list','33_process_list')) {
        $output = (@($output -split '\r?\n' | Where-Object {
            $_ -match '(?i)(NAME|PID|dumpstate|bugreport|incident|adbd|perfgenius)'
        })) -join [Environment]::NewLine
    }
    if ($item.Name -eq '14_shell_proc_status') {
        $output = (@($output -split '\r?\n' | Where-Object {
            $_ -match '^(Name|Uid|Gid|Cap(Inh|Prm|Eff|Bnd|Amb)|Seccomp|NoNewPrivs):'
        })) -join [Environment]::NewLine
    }
    $log = Join-Path $folder ($item.Name+'.txt')
    $body = ("adb shell {0}{1}ExitCode={2}{1}{1}{3}{1}" -f $item.Cmd,
             [Environment]::NewLine,$result.ExitCode,$output)
    [System.IO.File]::WriteAllText($log,$body,[System.Text.Encoding]::UTF8)
    $entries += [pscustomobject]@{
        Name=$item.Name
        Command=$item.Cmd
        ExitCode=$result.ExitCode
        File=($item.Name+'.txt')
        Status=if ($result.ExitCode -eq 0) {'OK'} else {'DENIED_OR_UNAVAILABLE'}
    }
}

$summary = @(
    'TAS_AN00_WINDOWS_ADB_SHELL_CONTEXT_V1',
    "CapturedLocal=$((Get-Date).ToString('s'))",
    'Device=TAS-AN00',
    'AndroidAPI=29',
    'SourceContext=authorized_adb_shell_not_app',
    'NoRootRequested=true',
    'NoKernelExploit=true',
    'NoServiceStart=true',
    'NoDeviceFileWrites=true',
    'Caution=ADB shell read permission does not imply kernel privileges',
    '',
    'Entries:'
) + @($entries | ForEach-Object { '{0}: exit={1} status={2}' -f $_.Name,$_.ExitCode,$_.Status })
[System.IO.File]::WriteAllLines((Join-Path $folder 'SUMMARY.txt'), [string[]]$summary, [System.Text.Encoding]::UTF8)
$manifest = [pscustomobject]@{
    Schema='TAS_WINDOWS_ADB_SHELL_CONTEXT_V1'
    Device='TAS-AN00'
    AndroidAPI=29
    SourceContext='authorized_adb_shell'
    NoRootRequested=$true
    NoKernelExploit=$true
    Entries=$entries
}
$manifest | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $folder 'RESULTS.json') -Encoding UTF8

Write-Host ''
Write-Host 'Finished: no root, no exploit, no protected files written.'
Write-Host "Result folder: $folder"
if (-not $NoZip) {
    $zip = Join-Path $folderRoot ("TAS_ADB_Shell_Context_{0}.zip" -f $stamp)
    Compress-Archive -Path (Join-Path $folder '*') -DestinationPath $zip -Force
    $digest = (Get-FileHash -Algorithm SHA256 -LiteralPath $zip).Hash
    Write-Host "ZIP: $zip"
    Write-Host "ZIP SHA256: $digest"
}
Write-Host 'Before sharing logs, review the contents for personal data.'
