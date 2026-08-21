# Runtime and tensor contracts

## QAIRT/QNN 2.44 host
Expected recovered foundation root: `/mnt/data/rev46_sandbox/foundation/foundation`.

Required toolchain identity:
- QAIRT/QNN `2.44.0 / 2.44.0.260225`
- host foundation SHA256 `44753f03f7b2c0a21ff751258137a3673321bbd10aaa8817ebf1f00badb17b22`
- QNN CPU backend `libQnnCpu.so`

Recovered local tools:
- converter: `$F/qairt/bin/x86_64-linux-clang/qnn-onnx-converter`
- model-lib generator: `$F/qairt/bin/x86_64-linux-clang/qnn-model-lib-generator`
- qnn-net-run: `$F/qairt/bin/x86_64-linux-clang/qnn-net-run`

Environment:
```bash
F=/mnt/data/rev46_sandbox/foundation/foundation
export QNN_SDK_ROOT="$F/qairt"
export PYTHONPATH="$F/site-packages:$F/qairt/lib/python"
export LD_LIBRARY_PATH="$F/cxx:$F/python/lib:$F/qairt/bin/lib:$F/qairt/lib/x86_64-linux-clang"
```

## ORT authority
Expected portable authority runtime:
- Python 3.11
- ORT 1.27.0
- numpy 1.26.4
- onnx 1.17.0

Recovered local Python path: `/mnt/data/rev46_sandbox/ort127_runtime/python311/bin/python3.11`. Runtime library path must include `/mnt/data/rev46_sandbox/ort127_runtime/python311/lib`.

## Critical layout contract
- ONNX/ORT warm input logical shape: **`[1,80,6]`**.
- QNN warm input must use the already-prepared **physical raw buffers** referenced by the frozen QNN input list; never reinterpret them as ORT raw tensors.
- QNN full-Vocos output physical shape: **`[1,6,321]`**.
- ORT output logical shape: **`[1,321,6]`**.
- Before scoring, reshape QNN output to `[1,6,321]`, then transpose `(0,2,1)` to logical `[1,321,6]`.
- Current Stage1 input list: `k8_reduce_tree_family/split/stage1_qnn_input_list.txt`.
- **Do not regenerate current Stage1 inputs.**

Authority warm18 QNN physical input SHA256: `5b425b7e31a80d33dfb135059593549781fdccd56ff1691f1965255d888b5dea`.

A fresh agent that cannot state this ORT/QNN layout distinction is not safe to resume numerical work.