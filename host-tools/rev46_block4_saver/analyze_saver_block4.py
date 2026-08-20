#!/usr/bin/env python3
"""Compare QAIRT/QNN Saver replay C files for rev46 block4 activation lowering.

This analyzer is structural only. It does not claim HTP numerical equivalence.
"""
import argparse
import collections
import json
import pathlib
import re

OP_RE = re.compile(
    r'Qnn_OpConfigV1_t context_0_cold_.*?_v1 = '
    r'\{"([^"]+)", "([^"]+)", "([^"]+)"'
)


def parse(path: pathlib.Path):
    text = path.read_text(errors="replace")
    ops = [
        {"name": name, "package": package, "type": op_type}
        for name, package, op_type in OP_RE.findall(text)
    ]
    block4_indices = [i for i, op in enumerate(ops) if "convnext_4" in op["name"]]
    if not block4_indices:
        raise RuntimeError(f"no convnext_4 ops found in {path}")
    lo, hi = min(block4_indices), max(block4_indices)
    block4_span = ops[lo : hi + 1]
    explicit = [
        op for op in ops
        if "_R24_B4_" in op["name"] or "_R24_DIAG_B4_" in op["name"]
    ]
    anonymous = [op for op in block4_span if op["name"].startswith("_elementwiseneuron_")]
    return {
        "path": str(path),
        "total_graph_add_ops": len(ops),
        "block4_span_start": lo,
        "block4_span_end": hi,
        "block4_span": [f'{op["type"]}:{op["name"]}' for op in block4_span],
        "block4_explicit_activation_ops": len(explicit),
        "block4_explicit_activation_type_counts": dict(
            collections.Counter(op["type"] for op in explicit)
        ),
        "block4_anonymous_elementwise_neuron": anonymous,
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--canonical", required=True)
    ap.add_argument("--decanonicalized", required=True)
    ap.add_argument("--out")
    args = ap.parse_args()

    result = {
        "schema": 1,
        "canonical": parse(pathlib.Path(args.canonical)),
        "decanonicalized": parse(pathlib.Path(args.decanonicalized)),
    }
    result["delta_total_graph_add_ops"] = (
        result["decanonicalized"]["total_graph_add_ops"]
        - result["canonical"]["total_graph_add_ops"]
    )
    result["structural_interpretation"] = (
        "Canonical block4 collapses its activation into an anonymous ElementWiseNeuron, "
        "while the decanonicalized diagnostic preserves the explicit activation chain. "
        "Confirm the anonymous neuron's operation parameter from Saver replay or QnnOpDef.h "
        "before labeling it GELU."
    )
    text = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.out:
        pathlib.Path(args.out).write_text(text)
    print(text, end="")


if __name__ == "__main__":
    main()
