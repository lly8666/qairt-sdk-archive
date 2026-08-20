#!/usr/bin/env python3
"""Apply a SHA-locked binary splice manifest used by frozen MeanVC2 rev25 ONNX files.

The manifest is intentionally byte-oriented: verify base bytes/SHA, apply ordered
splices against original offsets, then verify exact output bytes/SHA. This avoids
protobuf reserialization drift when reconstructing a frozen model identity.
"""
import argparse
import hashlib
import json
import pathlib


def sha256(b: bytes) -> str:
    return hashlib.sha256(b).hexdigest()


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--base',required=True)
    ap.add_argument('--manifest',required=True)
    ap.add_argument('--out',required=True)
    args=ap.parse_args()

    base_path=pathlib.Path(args.base)
    manifest_path=pathlib.Path(args.manifest)
    out_path=pathlib.Path(args.out)
    m=json.loads(manifest_path.read_text())
    src=base_path.read_bytes()

    if len(src)!=int(m['base_bytes']) or sha256(src)!=m['base_sha256']:
        raise SystemExit(
            f"base identity mismatch bytes={len(src)} sha256={sha256(src)} "
            f"expected={m['base_bytes']}/{m['base_sha256']}"
        )

    splices=sorted(m['splices'],key=lambda x:int(x['offset']))
    last=0
    chunks=[]
    for s in splices:
        off=int(s['offset']); delete=int(s['delete_bytes'])
        if off<last or off>len(src) or off+delete>len(src):
            raise SystemExit(f'invalid/overlapping splice {s}')
        chunks.append(src[last:off])
        chunks.append(bytes.fromhex(s['insert_hex']))
        last=off+delete
    chunks.append(src[last:])
    dst=b''.join(chunks)

    got_sha=sha256(dst)
    if len(dst)!=int(m['output_bytes']) or got_sha!=m['output_sha256']:
        raise SystemExit(
            f"output identity mismatch bytes={len(dst)} sha256={got_sha} "
            f"expected={m['output_bytes']}/{m['output_sha256']}"
        )
    out_path.parent.mkdir(parents=True,exist_ok=True)
    out_path.write_bytes(dst)
    print(f"REV25_BINARY_SPLICE_PASS bytes={len(dst)} sha256={got_sha} out={out_path}")


if __name__=='__main__':
    main()
