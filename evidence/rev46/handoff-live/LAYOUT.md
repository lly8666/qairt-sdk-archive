# Current runtime and tensor contract

Read this only when executing/restoring host science; it is WARM, not part of normal strategic preflight.

Toolchain: QAIRT/QNN `2.44.0 / 2.44.0.260225`; ORT `1.27.0`; numpy `1.26.4`; onnx `1.17.0`; host foundation SHA256 `44753f03f7b2c0a21ff751258137a3673321bbd10aaa8817ebf1f00badb17b22`.

Critical tensor contract:
- ORT warm input logical shape: `[1,80,6]`.
- QNN warm input uses the frozen prepared physical raw buffers from the current QNN input list; never reinterpret them as ORT raw tensors.
- QNN full-Vocos output physical shape: `[1,6,321]`.
- ORT output logical shape: `[1,321,6]`.
- Before scoring: reshape QNN output to `[1,6,321]`, then transpose `(0,2,1)` to `[1,321,6]`.
- Current Stage1 input list: `k8_reduce_tree_family/split/stage1_qnn_input_list.txt`.
- Do not regenerate current Stage1 inputs.

Authority warm18 QNN physical input SHA256: `5b425b7e31a80d33dfb135059593549781fdccd56ff1691f1965255d888b5dea`.

Expected restored local roots:
- QAIRT foundation: `/mnt/data/rev46_sandbox/foundation/foundation`
- ORT authority Python: `/mnt/data/rev46_sandbox/ort127_runtime/python311/bin/python3.11`

Science execution still requires the stable live validator path and all artifact identities in `RESTORE_BUNDLE_INDEX.json` to match.