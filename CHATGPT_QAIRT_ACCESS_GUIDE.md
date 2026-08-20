# ChatGPT / Agent QAIRT Access Guide v5 — public reusable model/tool/test workspace

This repository is the reusable QAIRT/QNN host-tooling, model-development, Android model-test and numerical-evidence workspace used by the MeanVC2/Vocos investigation.

## 1. Public-repository rule

Treat `lly8666/qairt-sdk-archive` as a **public build/runtime/model-test workspace**.

Allowed here:

- open-source-derived ONNX models and model variants;
- generated model libraries, context binaries, diagnostics and numerical evidence;
- standalone model/QNN Android test applications, their source, fixtures, generated assets and APK build workflows/artifacts;
- model-development scripts copied or refactored out of SimAdmin when they do not contain the small private communication/business layer;
- QAIRT/QNN dependency manifests and reproducible build scripts;
- public build dependencies fetched by GitHub Actions;
- Actions artifacts used to move generated files between agents/runs.

Do **not** commit or print secrets: GitHub tokens, signing keys, passwords, private credentials, temporary signed URLs, personal data, or the small unrelated SimAdmin communication/business source that the user has not authorized for publication.

Model-development and model-test files are not treated as private merely because they are generated during SimAdmin work. The model source/test work is open-source-derived and may be published here. The privacy boundary is the unrelated communication/business code and secrets, not the model/test code.

## 2. Canonical dependency discovery

Never guess Release tags, asset IDs, byte sizes or checksums from chat history. Read first:

```text
release-manifest/AGENT_RELEASE_INDEX.json
```

The current index wins over prose copies below.

## 3. Primary long-lived MeanVC2 host foundation

For active MeanVC2/Vocos rev46 host numerical work, reuse the already-qualified foundation Release asset:

```text
Release tag: 20260820.1
asset: qairt244-native-host-foundation-v4.tar.gz
asset id: 521748069
bytes: 377592420
sha256: 44753f03f7b2c0a21ff751258137a3673321bbd10aaa8817ebf1f00badb17b22
```

Qualified flow:

```text
qnn-onnx-converter
  -> qnn-model-lib-generator
  -> qnn-net-run --backend libQnnCpu.so
```

This payload contains the reusable Linux x64 QAIRT 2.44 host closure, CPython/C++ runtime and Python package closure. Routine work must reuse it instead of rebuilding the 1.56 GB SDK closure.

Historical Actions artifact IDs are build evidence/transport only; the Release payload SHA is the long-term identity.

## 4. Preferred acquisition

Because this repository is intended for public reusable tooling, prefer ordinary public GitHub Release download by asset URL/name, then verify exact byte size and SHA256 from `AGENT_RELEASE_INDEX.json` before use.

Recommended extraction root:

```text
/mnt/data/qairt244-native-host-foundation-v4/
```

Keep other QAIRT versions in separate trees.

If an execution environment cannot conveniently download the Release asset directly, an Actions transport artifact may be used. Transport must not rebuild or silently modify the qualified foundation payload.

## 5. GitHub Actions network/dependency policy

GitHub Actions may and should fetch **public external dependencies directly** when that is faster and simpler. Examples include:

```text
apt / Ubuntu packages
PyPI wheels/sdists
Maven Central Android AAR/JAR dependencies
GitHub source archives and Releases
official toolchain archives
public CMake dependencies
```

For scientific/reproducible paths:

1. pin meaningful dependency versions;
2. record source URL/repository and version/commit;
3. record SHA256 for frozen binary/archive inputs when practical;
4. freeze the final qualified closure as a Release asset when it is expensive or stable;
5. do not rebuild a qualified long-lived foundation on every experiment.

Offline wheelhouses/mirrors are optional reproducibility/cache tools, **not evidence that Actions lacks Internet access**.

Heavy model compilation, QNN conversion, repeated inference, Saver/optrace generation and other CPU/memory-intensive jobs should normally run here in GitHub Actions when that avoids exhausting the interactive sandbox.

## 6. SimAdmin-Android Actions prohibition and publication boundary

Do **not** use GitHub Actions in `lly8666/SimAdmin-Android` for this investigation.

`SimAdmin-Android` remains the private application/project authority, but model/model-test work should be extracted to this public repository when useful. In particular, standalone MeanVC2/QNN test applications, model surgery/generation code, fixtures, analyzers and generated APKs may be public here.

The publication boundary is:

- **public permitted:** model code, model-test code, numerical tools/evidence, standalone model-test Android code, generated model/test artifacts;
- **keep private:** unrelated communication/business code, credentials, signing secrets, personal/private application data.

Compute jobs must use either:

- this qairt-sdk-archive Actions workspace for publishable model/tool/numerical/Android-test work; or
- the interactive sandbox/local environment when it is faster and safe for the workload.

## 7. APK build/test selection and device-test economy

APK build/test chooses the **faster practical execution path** between the interactive sandbox/local build environment and this public Actions workspace. Benchmark with observed wall time; never assume one is always faster.

Rules:

- never invoke SimAdmin-Android Actions;
- standalone model/QNN test APK source is eligible to live and build here publicly;
- if local/sandbox Gradle caches and checked-out source make local build faster, use local/sandbox;
- if Actions is faster or avoids sandbox pressure, build here;
- avoid saturating the interactive sandbox: serialize heavy jobs, avoid duplicate builds, and reuse compiled assets/caches;
- **minimize manual device installations/runs:** before asking for a phone test, combine all scientifically compatible A/B variants, input regimes, cold/warm shapes, fresh-session repeats, timing/partition/profiling evidence and failure controls into one batch APK whenever this does not confound interpretation;
- a device run should answer several predeclared questions, not one tiny question that could have been bundled with adjacent probes;
- do not avoid a scientifically necessary redesign, compiler investigation or difficult implementation merely because it is inconvenient. Engineering difficulty is not a rejection criterion; correctness and interpretable evidence are.

Current public batch APK workspace:

```text
android-labs/rev46-block4-htp-batch/
workflow: Build MeanVC2 rev46 Block4 HTP Batch APK
artifact family: MeanVc2Rev46Block4HtpBatch-v1
```

## 8. Source/build fallback assets

Use these only when rebuilding/auditing the durable foundation:

```text
QAIRT full SDK
  Release: 20260819
  asset: QAIRT.v2.44.0.260225.zip
  id: 520887827
  bytes: 1560450667
  sha256: 52a5b0cc051eb2896848c9fd46e704612b1dc06e7d2f5d0d9a79fd8bcdd344bb

QAIRT Python wheelhouse v2
  Release: 20260819.4
  asset: qairt244-py310-wheelhouse.v2.tar
  id: 521019740
  bytes: 103860736
  sha256: eb3d0b500d7021a05ec111bf6afc14262d97282a5bb5a4481c88c7865b38d19f

Gate0D CPython 3.10 / C++ runtime
  Release: gate0d-host-toolchain-v1
  asset: gate0d-cpython310-runtime.tar.gz
  id: 514367357
  bytes: 29226747
  sha256: 1d94b18b7956b3c5e55aa359254ee884e270d51fd75814eae455813f2f8b8b1d
```

## 9. ORT 1.27 roles

Official ORT Linux x64 stock CPU package:

```text
Release: 20260819
asset: onnxruntime-linux-x64-1.27.0.tgz
id: 520889056
bytes: 8831605
sha256: 547e40a48f1fe73e3f812d7c88a948612c23f896b91e4e2ee1e232d7b468246f
```

It is the exact ORT 1.27 CPU oracle/runtime source and is not an ORT QNN-EP build.

Exact ORT 1.27 + QAIRT 2.44 QNN-EP is a separate frontend-parity control. Native `qnn-net-run + libQnnCpu.so` PASS does not prove ORT-QNN parity, and ORT-QNN PASS does not prove HTP PASS.

## 10. Scientific boundaries

```text
ORT scientific baseline: 1.27.0
QNN runtime baseline: 2.44.0
QAIRT SDK: 2.44.0.260225
```

Do not substitute 2.42/2.48 except explicit version-sensitivity experiments. Formal QNN/HTP gates keep CPU EP fallback disabled. QNN CPU is a reference/integration backend, not a bit-accurate HTP simulator. Strict device HTP remains final truth.

No numerical threshold relaxation follows from changing compute/transport location.

## 11. Takeover instruction

```text
Read release-manifest/AGENT_RELEASE_INDEX.json and CHATGPT_QAIRT_ACCESS_GUIDE.md. Reuse Release 20260820.1 qairt244-native-host-foundation-v4.tar.gz (sha256 44753f03f7b2c0a21ff751258137a3673321bbd10aaa8817ebf1f00badb17b22). Public dependencies may be fetched directly in qairt-sdk-archive Actions. Model/model-test source, standalone test APK code and generated evidence may be public; only unrelated communication/business code and secrets stay private. Never use SimAdmin-Android Actions. For APK build/test choose the faster route from measured wall time and batch compatible device probes so each manual installation answers multiple questions. Do not reject a correct engineering path because it is difficult.
```
