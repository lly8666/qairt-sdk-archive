#!/usr/bin/env python3
from __future__ import annotations

import argparse
import copy
import hashlib
import json
import math
import pathlib
import shutil
from collections import Counter, defaultdict

import numpy as np
import onnx
import onnxruntime as ort
from onnx import TensorProto, helper, numpy_helper

BASELINE_SHA256 = "f946e2daef6265e012d6dd47ad55eaecfd4e84b0c225c1cf225d06fb69a0892a"
COLD0_PREACT_SHA256 = "372bdd40334bc9f04582aeac6d88f028b74151ad0beafbf3eda3b059c653c058"
COLD0_RESIDUAL_SHA256 = "661dbd1d47a4fea34932b199ecbbcfaec3e83c4828d5c47a3a71b9f5a4c69037"
FROZEN_ORACLE_SHA256 = {
    "activation": "0f960e0fb2d746e842478a3b195d33957ffe38c8f414d12499d183f39c22f2e9",
    "pw2": "48a64841d4c4be1dd84479102086db9034cf4516712e66419feca9bd470c1d4d",
    "residual_out": "4436c78905f76d64f305e3fa52fd6b362174baa8fe8a509007cd3c3799c4a8c4",
}
FOCUS_NODE_NAMES = [
    "/backbone/convnext.4/Div",
    "/backbone/convnext.4/Erf",
    "/backbone/convnext.4/Add_1",
    "/backbone/convnext.4/Mul",
    "/backbone/convnext.4/Mul_1",
    "/backbone/convnext.4/MatMul_1",
    "/backbone/convnext.4/Add_2",
    "/backbone/convnext.4/Mul_2",
    "/backbone/convnext.4/Transpose_1",
    "/backbone/convnext.4/Add_3",
]


def sha256(path: pathlib.Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for b in iter(lambda: f.read(1 << 20), b""):
            h.update(b)
    return h.hexdigest()


def fail_unless_sha(path: pathlib.Path, expected: str) -> None:
    actual = sha256(path)
    if actual != expected:
        raise RuntimeError(f"identity mismatch {path}: {actual} != {expected}")


def dims(vi):
    out = []
    tt = vi.type.tensor_type
    if not tt.HasField("shape"):
        return out
    for d in tt.shape.dim:
        if d.HasField("dim_value"):
            out.append(int(d.dim_value))
        elif d.HasField("dim_param") and d.dim_param:
            out.append(d.dim_param)
        else:
            out.append(None)
    return out


def op_inventory(model) -> dict[str, int]:
    c = Counter(f"{n.domain or 'ai.onnx'}::{n.op_type}" for n in model.graph.node)
    return dict(sorted(c.items()))


def vi_map(model):
    return {v.name: v for group in (model.graph.input, model.graph.output, model.graph.value_info) for v in group}


def inferred_shape_map(model):
    try:
        inf = onnx.shape_inference.infer_shapes(copy.deepcopy(model), strict_mode=False, data_prop=True)
        error = None
    except Exception as e:
        inf = copy.deepcopy(model)
        error = f"{type(e).__name__}: {e}"
    mp = {v.name: dims(v) for group in (inf.graph.input, inf.graph.output, inf.graph.value_info) for v in group}
    return inf, mp, error


def unresolved_node_outputs(model, shape_map):
    unresolved = []
    for n in model.graph.node:
        for o in n.output:
            d = shape_map.get(o)
            if not d or any(x is None for x in d):
                unresolved.append({"node": n.name, "op": n.op_type, "output": o, "shape": d})
    return unresolved


def focus_shape_report(model):
    _, sm, err = inferred_shape_map(model)
    by_name = {n.name: n for n in model.graph.node}
    focus = {}
    for name in FOCUS_NODE_NAMES:
        n = by_name.get(name)
        if n is None:
            focus[name] = {"present": False}
        else:
            focus[name] = {
                "present": True,
                "op": n.op_type,
                "outputs": [{"name": o, "shape": sm.get(o)} for o in n.output],
            }
    unresolved = unresolved_node_outputs(model, sm)
    return {
        "shape_inference_error": err,
        "focus": focus,
        "unresolved_node_output_count": len(unresolved),
        "unresolved_node_outputs_sample": unresolved[:64],
    }


def tensor_scalar(model, name):
    for t in model.graph.initializer:
        if t.name == name:
            a = numpy_helper.to_array(t)
            if a.size == 1:
                return float(a.reshape(-1)[0])
    for n in model.graph.node:
        if n.op_type == "Constant" and name in n.output:
            for a in n.attribute:
                if a.name == "value" and a.type == onnx.AttributeProto.TENSOR:
                    x = numpy_helper.to_array(a.t)
                    if x.size == 1:
                        return float(x.reshape(-1)[0])
                if a.name == "value_float":
                    return float(a.f)
    return None


def other_input(node, known):
    if len(node.input) != 2:
        return None
    if node.input[0] == known:
        return node.input[1]
    if node.input[1] == known:
        return node.input[0]
    return None


def single_consumer(consumers, tensor, op_type=None):
    xs = consumers.get(tensor, [])
    if op_type:
        xs = [x for x in xs if x[1].op_type == op_type]
    return xs[0] if len(xs) == 1 else None


def find_exact_erf_gelu_pattern(model):
    nodes = list(model.graph.node)
    consumers = defaultdict(list)
    producers = {}
    for i, n in enumerate(nodes):
        for x in n.input:
            if x:
                consumers[x].append((i, n))
        for o in n.output:
            producers[o] = (i, n)

    erfs = [(i, n) for i, n in enumerate(nodes) if n.op_type == "Erf"]
    named = [(i, n) for i, n in erfs if n.name == "/backbone/convnext.4/Erf"]
    if len(named) == 1:
        erf_i, erf = named[0]
    elif len(erfs) == 1:
        erf_i, erf = erfs[0]
    else:
        raise RuntimeError(f"expected one target Erf, found named={len(named)} all={len(erfs)}")

    div_info = producers.get(erf.input[0])
    if not div_info or div_info[1].op_type != "Div":
        raise RuntimeError("Erf input is not produced by Div")
    div_i, div = div_info
    if len(div.input) != 2:
        raise RuntimeError("target Div is not binary")
    x = div.input[0]
    denom = tensor_scalar(model, div.input[1])
    if denom is None or not math.isclose(denom, math.sqrt(2.0), rel_tol=2e-6, abs_tol=2e-6):
        # Handle reversed input only to diagnose clearly; reversed division is not GELU.
        alt = tensor_scalar(model, div.input[0])
        raise RuntimeError(f"target Div denominator is not sqrt(2): denom={denom} alt={alt}")

    add_info = single_consumer(consumers, erf.output[0], "Add")
    if not add_info:
        raise RuntimeError("Erf output does not have exactly one Add consumer")
    add_i, add = add_info
    one_name = other_input(add, erf.output[0])
    one = tensor_scalar(model, one_name) if one_name else None
    if one is None or not math.isclose(one, 1.0, rel_tol=0.0, abs_tol=2e-7):
        raise RuntimeError(f"GELU Add scalar is not 1: {one}")

    # Common PyTorch exact GELU: Div -> Erf -> Add -> Mul(x, gate) -> Mul(0.5).
    gate_mul_info = single_consumer(consumers, add.output[0], "Mul")
    if not gate_mul_info:
        raise RuntimeError("GELU Add output does not have exactly one Mul consumer")
    gate_i, gate = gate_mul_info
    gate_other = other_input(gate, add.output[0])

    removed = {div_i, erf_i, add_i, gate_i}
    if gate_other == x:
        half_info = single_consumer(consumers, gate.output[0], "Mul")
        if not half_info:
            raise RuntimeError("GELU gate Mul does not have exactly one final Mul consumer")
        half_i, half = half_info
        half_name = other_input(half, gate.output[0])
        half_value = tensor_scalar(model, half_name) if half_name else None
        if half_value is None or not math.isclose(half_value, 0.5, rel_tol=0.0, abs_tol=2e-7):
            raise RuntimeError(f"GELU final Mul scalar is not 0.5: {half_value}")
        removed.add(half_i)
        final_node = half
        form = "Div(x,sqrt2)->Erf->Add(1)->Mul(x)->Mul(0.5)"
    else:
        # Alternate exact layout: x*0.5 computed before final gate multiply.
        prod = producers.get(gate_other)
        if not prod or prod[1].op_type != "Mul":
            raise RuntimeError(f"GELU gate Mul does not consume original x: other={gate_other}")
        half_i, half = prod
        half_other = other_input(half, x)
        half_value = tensor_scalar(model, half_other) if half_other else None
        if half_value is None or not math.isclose(half_value, 0.5, rel_tol=0.0, abs_tol=2e-7):
            raise RuntimeError(f"alternate GELU x*half scalar is not 0.5: {half_value}")
        removed.add(half_i)
        final_node = gate
        form = "Div(x,sqrt2)->Erf->Add(1);Mul(x,0.5)->Mul(gate)"

    final_output = final_node.output[0]
    # No intermediate value may escape the replacement subgraph.
    removed_nodes = [nodes[i] for i in sorted(removed)]
    removed_outputs = {o for n in removed_nodes for o in n.output}
    for n in removed_nodes:
        for o in n.output:
            if o == final_output:
                continue
            external = [(i, c.name, c.op_type) for i, c in consumers.get(o, []) if i not in removed]
            if external:
                raise RuntimeError(f"GELU intermediate {o} has external consumers {external}")

    return {
        "node_indices": sorted(removed),
        "node_names": [nodes[i].name for i in sorted(removed)],
        "node_ops": [nodes[i].op_type for i in sorted(removed)],
        "input": x,
        "output": final_output,
        "form": form,
        "constants": {"sqrt2": denom, "one": one, "half": 0.5},
    }


def ensure_opset(model, domain, version):
    for x in model.opset_import:
        if x.domain == domain:
            if x.version < version:
                x.version = version
            return
    model.opset_import.append(helper.make_opsetid(domain, version))


def copy_shape_value_info(src_model, dst_model, tensor_name):
    inferred, _, _ = inferred_shape_map(src_model)
    candidates = vi_map(inferred)
    src_vi = candidates.get(tensor_name)
    if src_vi is None:
        return False
    for group in (dst_model.graph.input, dst_model.graph.output, dst_model.graph.value_info):
        for i, v in enumerate(group):
            if v.name == tensor_name:
                group[i].CopyFrom(src_vi)
                return True
    dst_model.graph.value_info.append(copy.deepcopy(src_vi))
    return True


def canonicalize_gelu(model):
    src_for_shape = copy.deepcopy(model)
    pat = find_exact_erf_gelu_pattern(model)
    nodes = list(model.graph.node)
    first = min(pat["node_indices"])
    remove = set(pat["node_indices"])
    gelu = helper.make_node(
        "Gelu", [pat["input"]], [pat["output"]],
        name="rev46_block4_canonical_qnn_gelu",
        domain="com.microsoft",
    )
    new_nodes = []
    for i, n in enumerate(nodes):
        if i == first:
            new_nodes.append(gelu)
        if i not in remove:
            new_nodes.append(n)
    del model.graph.node[:]
    model.graph.node.extend(new_nodes)
    ensure_opset(model, "com.microsoft", 1)
    shape_preserved = copy_shape_value_info(src_for_shape, model, pat["output"])
    onnx.checker.check_model(model)
    pat["replacement"] = {
        "name": gelu.name,
        "domain": "com.microsoft",
        "op": "Gelu",
        "shape_value_info_preserved": shape_preserved,
    }
    return model, pat


def set_dim_value(dim, value):
    dim.dim_value = value
    if dim.HasField("dim_param"):
        dim.ClearField("dim_param")


def staticize_t4(model):
    by_name = {v.name: v for v in model.graph.input}
    if "preact" not in by_name or "residual" not in by_name:
        raise RuntimeError(f"expected public inputs preact/residual; have {sorted(by_name)}")
    p = by_name["preact"].type.tensor_type.shape.dim
    r = by_name["residual"].type.tensor_type.shape.dim
    if len(p) != 3 or len(r) != 3:
        raise RuntimeError("unexpected input rank")
    symbols = set()
    for d in (p[1], r[2]):
        if d.HasField("dim_param") and d.dim_param:
            symbols.add(d.dim_param)
    set_dim_value(p[1], 4)
    set_dim_value(r[2], 4)
    replaced = 2
    if symbols:
        for group in (model.graph.input, model.graph.output, model.graph.value_info):
            for vi in group:
                for d in vi.type.tensor_type.shape.dim:
                    if d.HasField("dim_param") and d.dim_param in symbols:
                        set_dim_value(d, 4)
                        replaced += 1
    try:
        model = onnx.shape_inference.infer_shapes(model, strict_mode=False, data_prop=True)
        infer_error = None
    except Exception as e:
        infer_error = f"{type(e).__name__}: {e}"
    # Reassert public input shapes after inference.
    by_name = {v.name: v for v in model.graph.input}
    set_dim_value(by_name["preact"].type.tensor_type.shape.dim[1], 4)
    set_dim_value(by_name["residual"].type.tensor_type.shape.dim[2], 4)
    onnx.checker.check_model(model)
    return model, {"t": 4, "symbols": sorted(symbols), "replaced_dim_occurrences": replaced, "shape_inference_error": infer_error}


def make_session(path):
    so = ort.SessionOptions()
    so.intra_op_num_threads = 1
    so.inter_op_num_threads = 1
    so.execution_mode = ort.ExecutionMode.ORT_SEQUENTIAL
    return ort.InferenceSession(str(path), sess_options=so, providers=["CPUExecutionProvider"])


def metrics(ref, cand):
    a = np.asarray(ref, dtype=np.float32).reshape(-1)
    b = np.asarray(cand, dtype=np.float32).reshape(-1)
    if a.shape != b.shape:
        return {"shape_equal": False, "ref_count": int(a.size), "cand_count": int(b.size)}
    d = b.astype(np.float64) - a.astype(np.float64)
    den = float(np.linalg.norm(a.astype(np.float64)) * np.linalg.norm(b.astype(np.float64)))
    cosine = float(np.dot(a.astype(np.float64), b.astype(np.float64)) / den) if den else 1.0
    return {
        "shape_equal": True,
        "count": int(a.size),
        "max_abs": float(np.max(np.abs(d))) if d.size else 0.0,
        "mean_abs": float(np.mean(np.abs(d))) if d.size else 0.0,
        "rmse": float(np.sqrt(np.mean(d * d))) if d.size else 0.0,
        "cosine": cosine,
        "exact_bits": bool(np.array_equal(a.view(np.uint32), b.view(np.uint32))),
    }


def run_cpu(model_path, preact_path, residual_path):
    sess = make_session(model_path)
    p = np.fromfile(preact_path, dtype="<f4").astype(np.float32, copy=False).reshape(1, 4, 1536)
    r = np.fromfile(residual_path, dtype="<f4").astype(np.float32, copy=False).reshape(1, 320, 4)
    feed = {"preact": p, "residual": r}
    names = [o.name for o in sess.get_outputs()]
    ys = sess.run(names, feed)
    return {n: np.asarray(y, dtype=np.float32) for n, y in zip(names, ys)}


def case_record(case_id, model_path, axis, transform):
    m = onnx.load(model_path)
    onnx.checker.check_model(m)
    io = {
        "inputs": [{"name": v.name, "shape": dims(v)} for v in m.graph.input],
        "outputs": [{"name": v.name, "shape": dims(v)} for v in m.graph.output],
    }
    return {
        "id": case_id,
        "axis": axis,
        "model": model_path.name,
        "bytes": model_path.stat().st_size,
        "sha256": sha256(model_path),
        "node_count": len(m.graph.node),
        "op_inventory": op_inventory(m),
        "io": io,
        "transform": transform,
        "shape_report": focus_shape_report(m),
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--payload-root", required=True)
    ap.add_argument("--out-dir", required=True)
    args = ap.parse_args()
    payload = pathlib.Path(args.payload_root).resolve()
    out = pathlib.Path(args.out_dir).resolve()
    out.mkdir(parents=True, exist_ok=True)

    src = payload / "models" / "block4_baseline.onnx"
    preact = payload / "fixtures" / "preact_cold0.f32"
    residual = payload / "fixtures" / "residual_cold0.f32"
    fail_unless_sha(src, BASELINE_SHA256)
    fail_unless_sha(preact, COLD0_PREACT_SHA256)
    fail_unless_sha(residual, COLD0_RESIDUAL_SHA256)
    for name, expected in FROZEN_ORACLE_SHA256.items():
        fail_unless_sha(payload / "oracle" / f"baseline_cold0_{name}.f32", expected)

    base = onnx.load(src)
    baseline_inputs = [v.name for v in base.graph.input]
    baseline_outputs = [v.name for v in base.graph.output]
    if baseline_inputs != ["preact", "residual"]:
        raise RuntimeError(f"unexpected focused public inputs: {baseline_inputs}")
    if baseline_outputs != ["activation", "pw2", "residual_out"]:
        raise RuntimeError(f"unexpected focused public outputs: {baseline_outputs}")

    cases = {}
    # A is byte-identical immutable baseline.
    a_dir = out / "A_dynamic_erf"; a_dir.mkdir(exist_ok=True)
    a_path = a_dir / "model.onnx"; shutil.copy2(src, a_path)
    fail_unless_sha(a_path, BASELINE_SHA256)
    shutil.copy2(preact, a_dir / "preact_cold0.f32")
    shutil.copy2(residual, a_dir / "residual_cold0.f32")
    cases["A"] = (a_path, {"shape": "dynamic", "gelu": "original_erf_decomposition"}, {"immutable_baseline": True})

    # B = shape axis only.
    b_dir = out / "B_staticT4_erf"; b_dir.mkdir(exist_ok=True)
    bm, btrans = staticize_t4(copy.deepcopy(base))
    b_path = b_dir / "model.onnx"; onnx.save(bm, b_path)
    shutil.copy2(preact, b_dir / "preact_cold0.f32"); shutil.copy2(residual, b_dir / "residual_cold0.f32")
    cases["B"] = (b_path, {"shape": "static_T4", "gelu": "original_erf_decomposition"}, {"staticize": btrans})

    # C = GELU representation axis only.
    c_dir = out / "C_dynamic_canonicalGelu"; c_dir.mkdir(exist_ok=True)
    cm, ctrans = canonicalize_gelu(copy.deepcopy(base))
    c_path = c_dir / "model.onnx"; onnx.save(cm, c_path)
    shutil.copy2(preact, c_dir / "preact_cold0.f32"); shutil.copy2(residual, c_dir / "residual_cold0.f32")
    cases["C"] = (c_path, {"shape": "dynamic", "gelu": "com.microsoft::Gelu"}, {"canonical_gelu": ctrans})

    # D = both factors.
    d_dir = out / "D_staticT4_canonicalGelu"; d_dir.mkdir(exist_ok=True)
    dm, dgelu = canonicalize_gelu(copy.deepcopy(base))
    dm, dshape = staticize_t4(dm)
    d_path = d_dir / "model.onnx"; onnx.save(dm, d_path)
    shutil.copy2(preact, d_dir / "preact_cold0.f32"); shutil.copy2(residual, d_dir / "residual_cold0.f32")
    cases["D"] = (d_path, {"shape": "static_T4", "gelu": "com.microsoft::Gelu"}, {"canonical_gelu": dgelu, "staticize": dshape})

    report = {
        "schema": 4,
        "purpose": "REV46_BLOCK4_DYNAMIC_STATIC_T4_X_ERF_CANONICAL_GELU_2X2_HOST_MATRIX_V4",
        "authority_action": "BUILD_HOST_ONLY_BLOCK4_GELU_2X2_SIMULATION_MATRIX_V4",
        "baseline_sha256": BASELINE_SHA256,
        "ort_version": ort.__version__,
        "cpu_provider": "CPUExecutionProvider",
        "cpu_threads": 1,
        "semantic_policy": {
            "A_vs_frozen_oracle": "exact_bits required",
            "B_vs_A": "exact_bits required (shape metadata only)",
            "C_D_vs_A": "max_abs <= 1e-6 for every public output; same tolerance previously used by activation-v3 canonical contrib-GELU host control",
        },
        "cases": {},
    }

    cpu = {}
    for cid, (path, axis, trans) in cases.items():
        report["cases"][cid] = case_record(cid, path, axis, trans)
        cpu[cid] = run_cpu(path, preact, residual)
        cdir = path.parent
        for name, arr in cpu[cid].items():
            arr.astype("<f4", copy=False).tofile(cdir / f"ort_{name}.f32")
        # QNN input-list uses exact historical cold0 raw payload.
        (cdir / "input_list.txt").write_text(
            "preact:=preact_cold0.f32 residual:=residual_cold0.f32\n", encoding="utf-8"
        )

    report["cpu_semantics"] = {"A_vs_frozen_oracle": {}, "cases_vs_A": {}}
    a_oracle_pass = True
    for name in baseline_outputs:
        frozen = np.fromfile(payload / "oracle" / f"baseline_cold0_{name}.f32", dtype="<f4")
        m = metrics(frozen, cpu["A"][name])
        report["cpu_semantics"]["A_vs_frozen_oracle"][name] = m
        a_oracle_pass &= bool(m.get("exact_bits"))
    report["cpu_semantics"]["A_vs_frozen_oracle_pass"] = a_oracle_pass

    semantic_pass = {"A": a_oracle_pass}
    for cid in ("B", "C", "D"):
        per = {}
        ok = True
        for name in baseline_outputs:
            m = metrics(cpu["A"][name], cpu[cid][name])
            per[name] = m
            if cid == "B":
                ok &= bool(m.get("exact_bits"))
            else:
                ok &= bool(m.get("shape_equal")) and float(m.get("max_abs", math.inf)) <= 1e-6
        report["cpu_semantics"]["cases_vs_A"][cid] = per
        semantic_pass[cid] = ok
    report["cpu_semantics"]["case_pass"] = semantic_pass
    report["pre_qairt_pass"] = all(semantic_pass.values())

    out_json = out / "MATRIX_PRE_QAIRT_REPORT.json"
    out_json.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print("REV46_BLOCK4_GELU_2X2_PRE_QAIRT_" + ("PASS" if report["pre_qairt_pass"] else "FAIL"))
    print(out_json)
    if not report["pre_qairt_pass"]:
        raise SystemExit(2)


if __name__ == "__main__":
    main()
