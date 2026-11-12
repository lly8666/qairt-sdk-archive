#requires -Version 5.1
<#
  Optional TAS-AN00: run previously reviewed 13-case READ-ONLY perf diagnostics
  from authorized Windows ADB shell. This does NOT run GhostLock, patch the
  kernel, modify protected files, ask for root, or grant privileges.

  Only device mutation: temporarily push a hash-pinned diagnostic ELF to
  /data/local/tmp and remove it in finally.
#>
[CmdletBinding()]
param(
    [string]$Serial = "",
    [string]$AdbPath = "adb.exe",
    [switch]$SelfTest
)

$ErrorActionPreference = 'Stop'
$expectedHash = 'f6d1a7d2747b400994d1a54ef1659d6c3fe01e50fd433b652dd8ef4feff3c6d7'
$remotePath = '/data/local/tmp/tas_batchprobe_readonly'
$probe = Join-Path $PSScriptRoot 'tas_batchprobe_arm64'
if ($SelfTest) {
    if ($expectedHash.Length -ne 64) { throw 'Invalid hash pin' }
    if ($remotePath -ne '/data/local/tmp/tas_batchprobe_readonly') { throw 'Remote destination changed' }
    if (-not $probe.EndsWith('tas_batchprobe_arm64')) { throw 'Probe binary path mismatch' }
    Write-Host 'TAS_WINDOWS_ADB_SHELL_PERF13_SELFTEST_PASS'
    exit 0
}

if (-not (Test-Path -LiteralPath $probe -PathType Leaf)) {
    throw 'Pinned read-only binary missing: tas_batchprobe_arm64. Re-extract the complete distribution ZIP.'
}
$actualHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $probe).Hash.ToLowerInvariant()
if ($actualHash -ne $expectedHash) {
    throw ("Probe SHA256 mismatch: expected {0}, observed {1}. Refusing to run." -f $expectedHash,$actualHash)
}

$localAdb = Join-Path $PSScriptRoot 'platform-tools\adb.exe'
if ($AdbPath -eq 'adb.exe' -and (Test-Path -LiteralPath $localAdb)) { $AdbPath = $localAdb }
$cmd = Get-Command $AdbPath -ErrorAction SilentlyContinue
if (-not $cmd) { throw 'adb.exe missing. Install official Windows Android platform-tools.' }
$AdbPath = $cmd.Source

function Invoke-Adb([string[]]$Args) {
    $previous=$ErrorActionPreference
    $ErrorActionPreference='Continue'
    try {
        $lines=@(& $AdbPath @Args 2>&1 | ForEach-Object { $_.ToString() })
        $code=$LASTEXITCODE
    } finally { $ErrorActionPreference=$previous }
    return [pscustomobject]@{
        Code=[int]$code
        Text=($lines -join [Environment]::NewLine).Trim()
    }
}

$listed=Invoke-Adb @('devices')
if ($listed.Code -ne 0) { throw $listed.Text }
$connected = @(
    foreach ($line in ($listed.Text -split '\r?\n')) {
        if ($line -match '^(\S+)\s+device\s*$') { $Matches[1] }
    }
)
if ($Serial -eq '') {
    if ($connected.Count -ne 1) {
        throw ("Found {0} authorized devices. Approve USB debugging or pass -Serial." -f $connected.Count)
    }
    $Serial=[string]$connected[0]
} elseif ($connected -notcontains $Serial) {
    throw 'Selected ADB serial is not authorized/connected.'
}

$model = Invoke-Adb @('-s',$Serial,'shell','getprop ro.product.model')
$sdk = Invoke-Adb @('-s',$Serial,'shell','getprop ro.build.version.sdk')
if ($model.Code -ne 0 -or $model.Text -ne 'TAS-AN00') { throw "Expected TAS-AN00. Received: $($model.Text)" }
if ($sdk.Code -ne 0 -or $sdk.Text -ne '29') { throw "Expected Android10 SDK29. Received: $($sdk.Text)" }

$stamp=Get-Date -Format 'yyyyMMdd_HHmmss'
$root=Join-Path $PSScriptRoot 'TAS_ADB_Results'
$folder=Join-Path $root ('Perf13_'+$stamp)
New-Item -ItemType Directory -Force -Path $folder | Out-Null
$uploaded=$false
$probeResult=$null
try {
    Write-Host 'Uploading ONLY verified read-only perf diagnostic to /data/local/tmp ...'
    $push=Invoke-Adb @('-s',$Serial,'push',$probe,$remotePath)
    if ($push.Code -ne 0) { throw ("adb push failed: "+$push.Text) }
    $uploaded=$true
    $chmod=Invoke-Adb @('-s',$Serial,'shell',"chmod 700 $remotePath")
    if ($chmod.Code -ne 0) { throw ("Unable to mark diagnostic executable: "+$chmod.Text) }
    Write-Host 'Running 13 isolated read-only cases under authorized ADB shell ...'
    $probeResult=Invoke-Adb @('-s',$Serial,'shell',"$remotePath --batch")
    if ($probeResult.Code -ne 0) {
        Write-Host ("Diagnostic returned nonzero: {0}; retaining output." -f $probeResult.Code)
    }
} finally {
    if ($uploaded) {
        $cleanup=Invoke-Adb @('-s',$Serial,'shell',"rm -f $remotePath")
        Write-Host ("Temporary probe cleanup: exit={0}" -f $cleanup.Code)
        if ($cleanup.Code -ne 0) { Write-Warning 'Manual cleanup may be needed for the exact /data/local/tmp/tas_batchprobe_readonly file.' }
    }
}

if ($null -eq $probeResult) { throw 'Probe did not execute; nothing to interpret.' }
$report=$probeResult.Text
[System.IO.File]::WriteAllText((Join-Path $folder 'TAS_Shell_Perf_13Case.txt'),$report,[System.Text.Encoding]::UTF8)
$counts=[regex]::Matches($report,'(?m)^CASE_END=\d\d:').Count
$denied=[regex]::Matches($report,'(?m)^perf_(?:task_user|cpu_user|cpu_kernel_only|exact)_errno=13\r?$').Count
$opened=($report -match '(?m)^perf_exact_result=open_ok\r?$')
$status = if ($counts -ne 13) { 'INCOMPLETE_DIAGNOSTIC' }
          elseif ($denied -eq 4) { 'SHELL_PERF_ALL_FOUR_EACCES' }
          elseif ($opened) { 'SHELL_PERF_EXACT_OPENED_NOT_ROOT' }
          else { 'MIXED_OR_OTHER_NEEDS_REVIEW' }
$summary=@(
    'TAS_AN00_WINDOWS_ADB_SHELL_PERF13_V1',
    'SourceContext=ADB_SHELL_NOT_APP',
    'OriginalAppPerf=FOUR_EACCES',
    "ShellPerf=$status",
    "CaseEndCount=$counts",
    "PerfEACCESCount=$denied",
    "ProbeSHA256=$actualHash",
    "ExitCode=$($probeResult.Code)",
    'KernelExploitTriggered=false',
    'KernelMemoryWritten=false',
    'RootRequested=false',
    'RootVerified=false',
    'DeviceFilesModified=TEMP_BINARY_ONLY_THEN_CLEANED'
)
$summary | Set-Content -LiteralPath (Join-Path $folder 'SUMMARY.txt') -Encoding UTF8
$zip=Join-Path $root ('TAS_ADB_Shell_Perf13_'+$stamp+'.zip')
Compress-Archive -Path (Join-Path $folder '*') -DestinationPath $zip -Force
Write-Host ('RESULT: '+$status)
Write-Host ('ZIP: '+$zip)
Write-Host ('ZIP SHA256: '+(Get-FileHash -Algorithm SHA256 -LiteralPath $zip).Hash)
Write-Host 'This is a precondition check under shell; it is not Root or a GhostLock exploit.'
