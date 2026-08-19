# QAIRT 2.44.0.260225 verified agent tool paths

Verified on 2026-08-19 from the indexed private Release asset:

```text
Release tag: 20260819
Asset: QAIRT.v2.44.0.260225.zip
Asset ID: 520887827
Bytes: 1560450667
SHA256: 52a5b0cc051eb2896848c9fd46e704612b1dc06e7d2f5d0d9a79fd8bcdd344bb
```

The workflow `.github/workflows/export-indexed-qairt-244-tools.yml` successfully downloaded and verified the full SDK, extracted the agent subset, and produced artifact `qairt-2.44.0.260225-agent-tools`.

A connector download of that artifact was independently inspected. Verified paths:

```text
bin/x86_64-linux-clang/qnn-net-run
bin/x86_64-linux-clang/qnn-context-binary-generator
bin/x86_64-linux-clang/qnn-profile-viewer

lib/x86_64-linux-clang/libQnnCpu.so
lib/x86_64-linux-clang/libQnnHtp.so
lib/x86_64-linux-clang/libQnnSystem.so
lib/x86_64-linux-clang/libQnnSaver.so
lib/x86_64-linux-clang/libQnnHtpOptraceProfilingReader.so

lib/aarch64-android/libQnnCpu.so
lib/aarch64-android/libQnnHtp.so
lib/aarch64-android/libQnnSystem.so
lib/aarch64-android/libQnnSaver.so
lib/aarch64-android/libQnnHtpOptraceProfilingReader.so

include/QNN/QnnInterface.h
include/QNN/QnnTypes.h
include/QNN/QnnBackend.h
include/QNN/QnnDevice.h

SOURCE_PROVENANCE.txt
SELECTION_MANIFEST.json
EXTRACTED_SHA256SUMS.txt
```

The inspected connector artifact ZIP contained 2724 entries and had local ZIP byte size 375566073 bytes. That ZIP size is transport-specific and is **not** the permanent SDK identity; the permanent authority is the full Release asset SHA256 above plus the per-file extracted manifest.

Agent rule:

1. Read `release-manifest/AGENT_RELEASE_INDEX.json` first.
2. For current MeanVC2/QNN work, use the QAIRT 2.44 asset listed above.
3. If direct private Release access is inconvenient, trigger Issue `[sdk-export-qairt-2.44-tools]` and download the one-day artifact.
4. Verify `SOURCE_PROVENANCE.txt` and `EXTRACTED_SHA256SUMS.txt` after download.
5. Use x86_64 files for host QNN CPU/Saver/profile analysis; use Android/aarch64 files only when the target-side experiment explicitly needs them.
6. QNN CPU is a reference backend, not a bit-accurate HTP simulator; strict device HTP remains final truth.
