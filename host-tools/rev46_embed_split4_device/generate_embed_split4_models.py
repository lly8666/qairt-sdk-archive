#!/usr/bin/env python3
"""Generate a focused frozen REV46 embed-Conv split4 device diagnostic.

This is deliberately NOT a full-Vocos promotion gate.  It extracts the unchanged
80->320 kernel-7 embed Conv from the SHA-locked rev25 warm6 authority model and
materializes two mathematically equivalent focused graphs:

  * canonical_embed_conv.onnx -- original Conv including original bias
  * split4_embed_conv.onnx    -- four contiguous 20-channel Conv branches,
                                no branch bias, balanced Add tree, bias once

The split4 topology matches the frozen family documented by
20260821-embed-conv-split-stage1-pass.md.  No final A/B/C fixture, warm18 block,
or seed-20260814 fitting/search input is consumed by this generator.
"""
from __future__ import annotations

import argparse
import copy
import hashlib
import json
from pathlib import Path

import numpy as np
import onnx
from onnx import TensorProto, helper, numpy_helper

REV25_WARM_SHA256 = "e2b7ab608a6b37a6dd9896589719cab446edf95287f59dfc7b5693da6ec98f6c"
FROZEN_FULL_SOURCE_SHA256 = "5d933a1a13f9147287f05958577b298b367a7b6b288570f94dd09939fd535c6c"
FROZEN_PARENT_EXEC_SHA256 = "d2efac4f266b312024b0e0b59feeeffa04716dbeaf54ad4763c7950ac9c3fb23"
FROZEN_FAMILY = "embed Conv 80->320 kernel=7 contiguous input-channel split4"
FROZEN_STAGE1_MAX_IMPROVEMENT_PCT = 23.6364
FROZEN_STAGE2_MAX_CHANGE_PCT = 0.3322259136212624
FROZEN_STAGE2_RMSE_IMPROVEMENT_PCT = 7.87
FROZEN_STAGE2_MEAN_IMPROVEMENT_PCT = 12.54


def sha_bytes(b: bytes) -> str:
    return hashlib.sha256(b).hexdigest()


def sha_file(p: Path) -> str:
    return sha_bytes(p.read_bytes())


def tensor_bytes(a: np.ndarray) -> bytes:
    return np.ascontiguousarray(a).tobytes(order="C")


def copy_attr_dict(node: onnx.NodeProto) -> dict:
    out = {}
    for a in node.attribute:
        out[a.name] = helper.get_attribute_value(a)
    return out


def find_embed_conv(model: onnx.ModelProto):
    init = {x.name: x for x in model.graph.initializer}
    matches = []
    for n in model.graph.node:
        if n.op_type != "Conv" or len(n.input) < 2 or n.input[1] not in init:
            continue
        w = numpy_helper.to_array(init[n.input[1]])
        if w.ndim == 3 and tuple(w.shape) == (320, 80, 7):
            b = None
            if len(n.input) >= 3 and n.input[2] in init:
                b = numpy_helper.to_array(init[n.input[2]])
            matches.append((n, w, b))
    if len(matches) != 1:
        raise RuntimeError(f"expected exactly one [320,80,7] Conv, found {len(matches)}")
    n, w, b = matches[0]
    if b is None or tuple(b.shape) != (320,):
        raise RuntimeError(f"embed Conv bias shape mismatch: {None if b is None else b.shape}")
    return n, np.asarray(w, dtype=np.float32), np.asarray(b, dtype=np.float32)


def base_model_like(src: onnx.ModelProto, graph: onnx.GraphProto) -> onnx.ModelProto:
    m = helper.make_model(graph)
    m.ir_version = src.ir_version
    del m.opset_import[:]
    for x in src.opset_import:
        y = m.opset_import.add()
        y.domain = x.domain
        y.version = x.version
    if src.producer_name:
        m.producer_name = "simadmin-rev46-frozen-embed-split4-device"
    return m


def make_canonical(src: onnx.ModelProto, conv: onnx.NodeProto, w: np.ndarray, b: np.ndarray):
    attrs = copy_attr_dict(conv)
    w_name = "embed_weight"
    b_name = "embed_bias"
    node = helper.make_node("Conv", ["x", w_name, b_name], ["y"], name="FrozenEmbedCanonical", **attrs)
    graph = helper.make_graph(
        [node],
        "REV46_FROZEN_EMBED_CONV_CANONICAL",
        [helper.make_tensor_value_info("x", TensorProto.FLOAT, [1, 80, 6])],
        [helper.make_tensor_value_info("y", TensorProto.FLOAT, [1, 320, 6])],
        [numpy_helper.from_array(w, w_name), numpy_helper.from_array(b, b_name)],
    )
    return base_model_like(src, graph)


def make_split4(src: onnx.ModelProto, conv: onnx.NodeProto, w: np.ndarray, b: np.ndarray):
    attrs = copy_attr_dict(conv)
    nodes = []
    inits = []
    branches = []
    for i in range(4):
        lo, hi = i * 20, (i + 1) * 20
        starts = f"slice{i}_starts"; ends = f"slice{i}_ends"; axes = f"slice{i}_axes"; steps = f"slice{i}_steps"
        inits.extend([
            numpy_helper.from_array(np.array([lo], dtype=np.int64), starts),
            numpy_helper.from_array(np.array([hi], dtype=np.int64), ends),
            numpy_helper.from_array(np.array([1], dtype=np.int64), axes),
            numpy_helper.from_array(np.array([1], dtype=np.int64), steps),
        ])
        sx = f"x_c{i}"
        nodes.append(helper.make_node("Slice", ["x", starts, ends, axes, steps], [sx], name=f"FrozenEmbedSplit4_Slice{i}"))
        wn = f"embed_weight_c{i}"
        inits.append(numpy_helper.from_array(np.ascontiguousarray(w[:, lo:hi, :]), wn))
        yo = f"partial{i}"
        # Frozen family invariant: branch Conv has no bias.
        nodes.append(helper.make_node("Conv", [sx, wn], [yo], name=f"FrozenEmbedSplit4_Conv{i}", **attrs))
        branches.append(yo)

    # Frozen fixed balanced tree for 4 leaves: (0+1) + (2+3).
    nodes.append(helper.make_node("Add", [branches[0], branches[1]], ["sum01"], name="FrozenEmbedSplit4_Add01"))
    nodes.append(helper.make_node("Add", [branches[2], branches[3]], ["sum23"], name="FrozenEmbedSplit4_Add23"))
    nodes.append(helper.make_node("Add", ["sum01", "sum23"], ["sum0123"], name="FrozenEmbedSplit4_AddAll"))
    bias3 = np.ascontiguousarray(b.reshape(1, 320, 1))
    inits.append(numpy_helper.from_array(bias3, "embed_bias_once"))
    nodes.append(helper.make_node("Add", ["sum0123", "embed_bias_once"], ["y"], name="FrozenEmbedSplit4_BiasOnce"))

    graph = helper.make_graph(
        nodes,
        "REV46_FROZEN_EMBED_CONV_SPLIT4",
        [helper.make_tensor_value_info("x", TensorProto.FLOAT, [1, 80, 6])],
        [helper.make_tensor_value_info("y", TensorProto.FLOAT, [1, 320, 6])],
        inits,
    )
    return base_model_like(src, graph)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--rev25-warm", required=True)
    ap.add_argument("--out", required=True)
    args = ap.parse_args()
    src_path = Path(args.rev25_warm)
    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)

    got = sha_file(src_path)
    if got != REV25_WARM_SHA256:
        raise SystemExit(f"rev25 warm authority mismatch {got} != {REV25_WARM_SHA256}")
    src = onnx.load(str(src_path))
    conv, w, b = find_embed_conv(src)
    canonical = make_canonical(src, conv, w, b)
    split4 = make_split4(src, conv, w, b)
    onnx.checker.check_model(canonical)
    onnx.checker.check_model(split4)

    cp = out / "canonical_embed_conv.onnx"
    sp = out / "split4_embed_conv.onnx"
    onnx.save(canonical, str(cp))
    onnx.save(split4, str(sp))

    manifest = {
        "schema": 1,
        "scope": "FOCUSED_FROZEN_SPLIT4_MECHANISM_DIAGNOSTIC_NOT_FULL_MODEL_GATE",
        "source_rev25_warm_sha256": REV25_WARM_SHA256,
        "source_conv_name": conv.name,
        "source_conv_inputs": list(conv.input),
        "source_conv_attributes": {k: repr(v) for k, v in copy_attr_dict(conv).items()},
        "weight_shape": list(w.shape),
        "weight_f32_bytes_sha256": sha_bytes(tensor_bytes(w)),
        "bias_shape": list(b.shape),
        "bias_f32_bytes_sha256": sha_bytes(tensor_bytes(b)),
        "frozen_family": FROZEN_FAMILY,
        "frozen_full_model_source_authority_sha256": FROZEN_FULL_SOURCE_SHA256,
        "frozen_parent_execution_sha256": FROZEN_PARENT_EXEC_SHA256,
        "frozen_stage1_max_improvement_pct": FROZEN_STAGE1_MAX_IMPROVEMENT_PCT,
        "frozen_stage2_max_change_pct": FROZEN_STAGE2_MAX_CHANGE_PCT,
        "frozen_stage2_rmse_improvement_pct": FROZEN_STAGE2_RMSE_IMPROVEMENT_PCT,
        "frozen_stage2_mean_improvement_pct": FROZEN_STAGE2_MEAN_IMPROVEMENT_PCT,
        "canonical_model_sha256": sha_file(cp),
        "split4_model_sha256": sha_file(sp),
        "split4_invariant": {
            "groups": [[0, 20], [20, 40], [40, 60], [60, 80]],
            "branch_bias": False,
            "reduction_tree": "(0+1)+(2+3)",
            "original_bias_added_once": True,
        },
        "protected_inputs_used": False,
        "final_abc_used": False,
        "warm18_used": False,
        "seed_20260814_used": False,
    }
    (out / "MODEL_PROVENANCE.json").write_text(json.dumps(manifest, indent=2, sort_keys=True) + "\n")
    print("REV46_EMBED_SPLIT4_MODEL_GENERATION_PASS")
    print(json.dumps(manifest, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
