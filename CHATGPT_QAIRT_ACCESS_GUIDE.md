# ChatGPT / Agent QAIRT Access Guide v3 — durable host foundation

This private repository is the permanent binary archive and transport broker for QAIRT/QNN and related host dependencies.

## 1. Canonical discovery

Never guess Release tags, asset IDs, byte sizes or checksums from chat history. Always read first:

```text
release-manifest/AGENT_RELEASE_INDEX.json
```

The current index wins over prose copies below. Temporary signed redirect URLs are never authority and must not be persisted.

## 2. Primary long-lived MeanVC2 host foundation

For active SimAdmin MeanVC2/Vocos rev46 host numerical work, the preferred reusable host dependency is the already-qualified foundation Release asset:

```text
Release tag: 20260820.1
asset: qairt244-native-host-foundation-v4.tar.gz
asset id: 521748069
bytes: 377592420
sha256: 44753f03f7b2c0a21ff751258137a3673321bbd10aaa8817ebf1f00badb17b22
```

This payload was validated by an actual deterministic native CPU flow:

```text
qnn-onnx-converter
  -> qnn-model-lib-generator
  -> qnn-net-run --backend libQnnCpu.so
```

It contains the reusable Linux x64 QAIRT 2.44 host closure, frozen CPython/C++ runtime and pinned Python package closure needed by the converter/model-lib/native-QNN path. It is the normal starting point; do not reconstruct this closure from the 1.56 GB SDK for routine rev46 work.

The historical Actions artifact `9392491458` is only evidence of the successful build that produced the same payload. It is not the long-term authority now that the byte-identical payload is in Release.

## 3. Preferred acquisition paths

### A. GitHub Actions / authenticated private GitHub runtime

Resolve the asset from `AGENT_RELEASE_INDEX.json`, download the private Release asset using its asset API ID with `Accept: application/octet-stream`, then require exact byte size and SHA256 above before extraction.

### B. ChatGPT execution runtime without direct private Release byte download

Create a private Issue with exact title:

```text
[sdk-export-qairt244-native-host-foundation]
```

Workflow:

```text
.github/workflows/export-qairt244-native-host-foundation.yml
```

This workflow performs **transport only**:

1. resolves the permanent foundation from the current Release index;
2. downloads the private Release asset inside GitHub Actions;
3. verifies exact bytes and SHA256;
4. verifies `foundation/smoke/FOUNDATION_PASS.txt` contains `QAIRT244_NATIVE_FOUNDATION_PASS=1`;
5. exposes the unchanged Release payload as a short-lived connector-downloadable Actions artifact.

No compilation is performed by this transport workflow. The private Release remains permanent authority.

Recommended local extraction root:

```text
/mnt/data/qairt244-native-host-foundation-v4/
```

Keep other QAIRT versions in separate trees.

## 4. Source/build fallback assets — not the normal runtime dependency

Only use these when rebuilding or auditing the durable foundation:

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

The Gate0D runtime supplies the frozen CPython 3.10.20 host runtime and required C++ shared runtime (`libc++`, `libc++abi`, `libunwind`) used by the qualified foundation.

## 5. ORT 1.27 assets and roles

```text
ORT Linux x64 stock CPU package
  Release: 20260819
  asset: onnxruntime-linux-x64-1.27.0.tgz
  id: 520889056
  bytes: 8831605
  sha256: 547e40a48f1fe73e3f812d7c88a948612c23f896b91e4e2ee1e232d7b468246f
```

The stock package is an exact ORT 1.27 CPU oracle/runtime source. Its provider probe exposes `CPUExecutionProvider`; it must **not** be represented as an ORT QNN-EP build.

An exact ORT 1.27 + QAIRT 2.44 QNN-EP Linux x64 build is a separate frontend-parity/integration control. Native `qnn-net-run + libQnnCpu.so` PASS does not prove ORT-QNN frontend parity, and ORT-QNN PASS does not prove HTP PASS.

## 6. Dependency role separation

Keep these authority classes distinct:

```text
host foundation
  durable Release qairt244-native-host-foundation-v4

source/build inputs
  full QAIRT SDK + wheelhouse + Gate0D runtime

ORT CPU oracle
  official ORT 1.27 Linux x64 stock package

ORT-QNN frontend parity
  separately-qualified ORT 1.27 QNN-EP host bundle

frozen model/fixture inputs
  project authority / Drive / exact SHA, never hidden inside the host foundation

experiment runners/evidence
  Git-tracked scripts/manifests referencing exact dependency and model SHAs
```

This separation is intentional: changing the transport or host packaging must never silently change model identity, QNN semantics, thresholds or device conclusions.

## 7. Current version lock and scientific boundaries

```text
ORT scientific baseline: 1.27.0
QNN runtime baseline: 2.44.0
QAIRT SDK: 2.44.0.260225
```

Do not substitute 2.42/2.48 except explicit version-sensitivity experiments. Formal QNN/HTP gates keep CPU EP fallback disabled. QNN CPU is a reference/integration backend, not a bit-accurate HTP simulator. Strict HTP device evidence remains final truth.

## 8. Security/provenance

- Never print/commit tokens, private signing material, passwords or temporary signed asset redirects.
- Before use, verify the Release asset byte size and SHA256 from the current index.
- Every serious experiment manifest records Release tag, asset ID, payload SHA, model/fixture SHA and execution backend.
- Foundation transport may change; foundation payload identity must not.
- No production integration follows merely from host reference PASS.

## 9. Copy-paste takeover instruction

```text
Read lly8666/qairt-sdk-archive/release-manifest/AGENT_RELEASE_INDEX.json and CHATGPT_QAIRT_ACCESS_GUIDE.md. For current MeanVC2 rev46 host work use Release 20260820.1 asset qairt244-native-host-foundation-v4.tar.gz (id 521748069, sha256 44753f03f7b2c0a21ff751258137a3673321bbd10aaa8817ebf1f00badb17b22) as the primary native QAIRT 2.44 foundation. If the chat runtime cannot directly download a private Release asset, trigger [sdk-export-qairt244-native-host-foundation] for a transport-only artifact. Do not rebuild the 1.56 GB SDK closure unless auditing/rebuilding the foundation; do not confuse native QNN CPU, ORT-QNN frontend parity, or HTP truth.
```
