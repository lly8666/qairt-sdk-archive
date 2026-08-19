# ChatGPT / Agent QAIRT SDK Access Guide v2

This private repository is the permanent binary archive and transport broker for QAIRT/QNN and related host diagnostic dependencies.

## 1. Canonical discovery rule

Do **not** guess private Release tags, asset IDs, file sizes, or checksums from chat history.

Every agent must first read:

```text
lly8666/qairt-sdk-archive
  release-manifest/AGENT_RELEASE_INDEX.json
```

Optional human-readable view:

```text
release-manifest/AGENT_RELEASE_INDEX.md
```

The index is automatically regenerated from the private GitHub Release API by:

```text
.github/workflows/refresh-agent-release-index.yml
```

It is refreshed on Release publish/edit/release, on main updates, or via Issue title:

```text
[sdk-refresh-release-index]
```

The index contains only stable non-secret metadata: Release tag/name, asset name/id/bytes/digest, browser download URL and asset API URL. It never commits temporary signed redirect credentials.

---

## 2. Current MeanVC2 / Vocos pinned dependency Release

The current indexed Release is:

```text
tag: 20260819
name: QAIRT 2.44 and others
```

For current SimAdmin MeanVC2 QNN/HTP numerical work, the authoritative QAIRT SDK asset is:

```text
QAIRT.v2.44.0.260225.zip
asset id: 520887827
bytes: 1560450667
sha256: 52a5b0cc051eb2896848c9fd46e704612b1dc06e7d2f5d0d9a79fd8bcdd344bb
```

Companion assets currently indexed in the same Release:

```text
Netron-9.2.2-amd64.deb
  id: 520888082
  bytes: 102880024
  sha256: 0959a638b54a40ad95927d75c286bbba49dd2b8b39dda79491d57e1615cb51f4

linux-amd64.zip
  id: 520887945
  bytes: 13102121
  sha256: a5354a4a133cc629bb398da53c95515e5a49d4bd96edfebe1ebc3221c85d936f

onnxruntime-linux-x64-1.27.0.tgz
  id: 520889056
  bytes: 8831605
  sha256: 547e40a48f1fe73e3f812d7c88a948612c23f896b91e4e2ee1e232d7b468246f

onnxruntime-linux-aarch64-1.27.0.tgz
  id: 520889218
  bytes: 7797972
  sha256: 3e4d83ac06924a32a07b6d7f91ce6f852876153fc0bbdf931bf517a140bfbe48
```

Before use, re-read `AGENT_RELEASE_INDEX.json`; if metadata changed, the current index wins over this prose copy.

The generic `linux-amd64.zip` filename is intentionally treated as an opaque companion tool until its extracted provenance/content is checked. Do not label it as Perfetto or another package solely from the filename.

---

## 3. Current project version lock

For the active SimAdmin MeanVC2 numerical investigation:

```text
ORT: 1.27.0
QNN / QAIRT: 2.44.0 / QAIRT 2.44.0.260225
Android QNN runtime baseline: 2.44.0
```

Do not substitute QAIRT 2.42 or 2.48 for the current scientific conclusion. Those versions may be used only for explicit runtime/version-sensitivity A/B experiments.

---

## 4. Preferred agent path: one-day verified QAIRT 2.44 subset

Most ChatGPT execution environments should **not** pull the 1.56 GB SDK into the chat runtime.

Create a private Issue with exact title:

```text
[sdk-export-qairt-2.44-tools]
```

Workflow:

```text
.github/workflows/export-indexed-qairt-244-tools.yml
```

The workflow:

1. reads `AGENT_RELEASE_INDEX.json`;
2. requires exactly one `QAIRT.v2.44.0.260225.zip` asset;
3. obtains its asset ID, size and GitHub SHA256 digest from the index;
4. downloads the full private Release asset inside GitHub Actions using `GITHUB_TOKEN`;
5. verifies full ZIP byte size and SHA256;
6. extracts only the numerical-analysis/host subset;
7. requires the key QAIRT files listed below;
8. writes source provenance and extracted per-file SHA256 manifest;
9. uploads a one-day connector-downloadable Actions artifact.

Artifact name:

```text
qairt-2.44.0.260225-agent-tools
```

Required files checked by the workflow:

```text
qnn-net-run
qnn-context-binary-generator
qnn-profile-viewer
libQnnCpu.so
libQnnHtp.so
libQnnSystem.so
libQnnSaver.so
libQnnHtpOptraceProfilingReader.so
QnnInterface.h
QnnTypes.h
QnnBackend.h
QnnDevice.h
```

Selected subtrees include relevant portions of:

```text
bin/x86_64-linux-clang/
lib/x86_64-linux-clang/
lib/aarch64-android/
lib/python/
include/QNN/
share/QNN/
```

After connector download, verify:

```text
SOURCE_PROVENANCE.txt
EXTRACTED_SHA256SUMS.txt
SELECTION_MANIFEST.json
```

The temporary artifact is transport only. The private Release remains permanent authority.

---

## 5. Direct private Release download path

If an agent/runtime can authenticate directly to the private Release asset API, it may use the `api_url` / asset ID from `AGENT_RELEASE_INDEX.json`.

Required rules:

1. authenticate with GitHub access to this private repository;
2. request `Accept: application/octet-stream`;
3. verify byte size against the current index;
4. verify SHA256 against `digest` from the current index;
5. never persist temporary signed redirect URLs in Git, issues, logs, or documentation;
6. keep each QAIRT version in a separate extraction tree.

Recommended extraction isolation:

```text
/mnt/data/qairt-2.44.0.260225/
/mnt/data/qairt-2.42.0.251225/
/mnt/data/qairt-2.48.40.260702/
```

Never overwrite one with another.

---

## 6. What each dependency is for

### QAIRT 2.44 full SDK

Primary current dependency. Use for:

- QNN CPU reference backend;
- QNN Saver / API replay diagnostics;
- qnn-net-run;
- context binary generation;
- qnn-profile-viewer;
- HTP optrace/QHAS parsing support;
- QNN headers;
- exact-version host/target library inspection.

### ORT 1.27.0 Linux x64

Use only as a host ORT 1.27 reference/runtime starting point when compatible with the required QNN EP build/configuration. Do not assume the stock archive contains the QNN EP unless verified.

### ORT 1.27.0 Linux aarch64

Use for explicit ARM64 Linux compatibility work only. It does not replace the Android QNN AAR/runtime already frozen in SimAdmin.

### Netron 9.2.2

Graph visualization aid only. It is not numerical truth and must not be used to infer compiled HTP fusion boundaries.

### linux-amd64.zip

Opaque companion Linux tool asset until extracted content/provenance is verified. Once identified, document its exact role in the experiment manifest. Do not infer package identity from the filename.

---

## 7. Historical QAIRT archive

Historical private Release tag:

```text
qairt-sdk-archive-v1
```

Contains:

```text
qairt-2.42.0.251225.zip
qairt-2.48.40.260702.zip.part-00
qairt-2.48.40.260702.zip.part-01
qairt-2.48.40.260702.zip.part-02
```

Historical canonical hashes remain in:

```text
release-manifest/SHA256SUMS
```

Older fixed-ID broker/export workflows remain only for reproducing closed 2.42/2.48 experiments. New work must prefer the agent index and indexed workflows.

---

## 8. Security and provenance rules

- Never print or commit private signing key bytes, passwords, tokens, JWTs or temporary signed Release URLs.
- Release `browser_download_url`, asset ID, byte size and SHA256 digest are metadata and may be indexed in this private repo.
- Verify SHA256 before using a full SDK or exported subset.
- Record exact Release tag + asset ID + SHA256 in every serious numerical experiment manifest.
- QNN CPU backend is a reference implementation, **not** a bit-accurate HTP simulator.
- Strict device HTP remains the final source of truth for numerical and performance qualification.

---

## 9. Copy-paste instruction for another agent

```text
Read lly8666/qairt-sdk-archive/release-manifest/AGENT_RELEASE_INDEX.json and CHATGPT_QAIRT_ACCESS_GUIDE.md first; for current MeanVC2 work use only the indexed QAIRT.v2.44.0.260225.zip from Release tag 20260819, and if the full private asset is inconvenient trigger [sdk-export-qairt-2.44-tools] to obtain the verified one-day qairt-2.44.0.260225-agent-tools artifact; always verify provenance/SHA256 and never treat QNN CPU as HTP truth.
```
