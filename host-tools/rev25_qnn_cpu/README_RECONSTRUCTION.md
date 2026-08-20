# Frozen rev25 deterministic reconstruction

The frozen rev25 ONNX identity is reconstructed in two stages without protobuf reserialization of the rev25 patch itself.

1. Start from exact frozen base cold4/warm6 ONNX bytes.
2. Apply the corresponding SHA-locked binary-splice manifest with `apply_binary_splice_manifest.py`.
3. Verify the exact rev25 output SHA before any converter/QNN experiment.
4. For the rev46 block4 diagnostic only, run `../rev46_block4_saver/make_block4_decanonicalized.py` on the exact rev25 ONNX and require the known diagnostic SHA.

Frozen identities:

```text
base cold4  d32cb4b116bfe6aeee12f2ab726cf617b3aca6e8043bdf4d533c843769e00a7f
rev25 cold4 323c194e5da29f0be962ea8b72ca2fa2d1a9fc2481d80b95e5590f79e9485f65
base warm6  5981bfc5d6850baaef7f44af2da18ecd149782e0ffcabf731bcf658d953e0909
rev25 warm6  e2b7ab608a6b37a6dd9896589719cab446edf95287f59dfc7b5693da6ec98f6c

diagnostic cold4 efda4b2b563a667b1c751eee53339085532ca1007209c42c23325ce109f09432
diagnostic warm6 a605520bca2c2b6bd1d513ab62b987f76cce522eaaa1c9e21a212fd37608c275
```

The model/test/generated assets may be public in this repository. Do not include credentials, signing material, temporary signed URLs, or unrelated application/private data in reconstruction manifests or Actions logs.
