#!/usr/bin/env python3
import hashlib, json, math, pathlib
import onnx
from onnx import TensorProto, helper, numpy_helper
import numpy as np

ROOT = pathlib.Path(__file__).resolve().parents[1]
OUT = ROOT / 'app' / 'src' / 'main' / 'assets' / 'models'
SHAPES = {'cold4': [1, 4, 1536], 'warm6': [1, 6, 1536]}
OPSET = 20


def scalar(name, value):
    return numpy_helper.from_array(np.asarray(value, dtype=np.float32), name=name)


def model_for(kind, shape):
    x = helper.make_tensor_value_info('x', TensorProto.FLOAT, shape)
    y = helper.make_tensor_value_info('y', TensorProto.FLOAT, shape)
    nodes = []
    inits = []
    if kind == 'gelu_op':
        nodes.append(helper.make_node('Gelu', ['x'], ['y'], name='gelu_exact'))
    elif kind == 'canonical_erf':
        inits += [scalar('sqrt2', math.sqrt(2.0)), scalar('one', 1.0), scalar('half', 0.5)]
        nodes += [
            helper.make_node('Div', ['x', 'sqrt2'], ['x_div_sqrt2'], name='div_sqrt2'),
            helper.make_node('Erf', ['x_div_sqrt2'], ['erf'], name='erf'),
            helper.make_node('Add', ['erf', 'one'], ['one_plus_erf'], name='add_one'),
            helper.make_node('Mul', ['x', 'one_plus_erf'], ['x_gate'], name='mul_x_gate'),
            helper.make_node('Mul', ['x_gate', 'half'], ['y'], name='mul_half'),
        ]
    elif kind == 'decanonicalized_erf':
        # Same real-valued formula, intentionally different surface/order.
        inits += [scalar('inv_sqrt2', 1.0 / math.sqrt(2.0)), scalar('one', 1.0), scalar('half', 0.5)]
        nodes += [
            helper.make_node('Mul', ['x', 'inv_sqrt2'], ['x_scaled'], name='mul_inv_sqrt2'),
            helper.make_node('Erf', ['x_scaled'], ['erf'], name='erf'),
            helper.make_node('Add', ['one', 'erf'], ['one_plus_erf'], name='add_one_reversed'),
            helper.make_node('Mul', ['x', 'half'], ['x_half'], name='mul_half_early'),
            helper.make_node('Mul', ['x_half', 'one_plus_erf'], ['y'], name='mul_gate_late'),
        ]
    else:
        raise ValueError(kind)
    g = helper.make_graph(nodes, f'rev46_{kind}', [x], [y], initializer=inits)
    m = helper.make_model(g, producer_name='qairt-sdk-archive/rev46-block4-htp-batch',
                          opset_imports=[helper.make_opsetid('', OPSET)])
    m.ir_version = 9
    m.metadata_props.add(key='rev46_role', value=kind)
    m.metadata_props.add(key='shape', value='x'.join(map(str, shape)))
    onnx.checker.check_model(m)
    return m


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    manifest = {
        'schema': 1,
        'purpose': 'MeanVC2 rev46 block4 activation lowering device batch; strict HTP, no CPU fallback',
        'vocos_activation_shape_basis': {'intermediate_dim': 1536, 'cold_frames': 4, 'warm_frames': 6},
        'opset': OPSET,
        'models': []
    }
    for shape_name, shape in SHAPES.items():
        for kind in ('gelu_op', 'canonical_erf', 'decanonicalized_erf'):
            name = f'{shape_name}_{kind}.onnx'
            path = OUT / name
            onnx.save(model_for(kind, shape), path)
            manifest['models'].append({
                'name': name, 'shape_name': shape_name, 'shape': shape, 'kind': kind,
                'bytes': path.stat().st_size, 'sha256': sha(path)
            })
    mpath = OUT.parent / 'MODEL_MANIFEST.json'
    mpath.write_text(json.dumps(manifest, indent=2, sort_keys=True) + '\n', encoding='utf-8')
    print('REV46_GELU_MATRIX_GENERATION_PASS')
    print(mpath.read_text())


if __name__ == '__main__':
    main()
