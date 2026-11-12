#!/usr/bin/env python3
"""Read-only Android sparse image header/chunk inspection, without expanding 7+ GiB."""
import collections
import hashlib
import json
import pathlib
import struct
import sys
import math
MAGIC=0xed26ff3a
CT={0xcac1:"RAW",0xcac2:"FILL",0xcac3:"DONTCARE",0xcac4:"CRC32"}
SAMPLES=1024*1024
def entropy(b):
    if not b:return 0.
    c=collections.Counter(b);n=len(b)
    return -sum((v/n)*math.log2(v/n) for v in c.values())
def main():
    p=pathlib.Path(sys.argv[1]);dest=pathlib.Path(sys.argv[2])
    dest.parent.mkdir(parents=True,exist_ok=True)
    with p.open("rb") as f:
        header=f.read(28)
        magic,major,minor,file_hdr,chunk_hdr,block_size,total_blocks,total_chunks,image_crc=struct.unpack("<IHHHHIIII",header)
        if magic!=MAGIC:raise SystemExit("Not an Android sparse image")
        record={"magic":"android_sparse","input_bytes":p.stat().st_size,"major":major,"minor":minor,
          "file_hdr_sz":file_hdr,"chunk_hdr_sz":chunk_hdr,"block_size":block_size,
          "logical_output_bytes":total_blocks*block_size,"chunk_count":total_chunks,"chunks":[]}
        f.seek(file_hdr)
        out_offset=0
        for i in range(total_chunks):
            pos=f.tell()
            h=f.read(chunk_hdr)
            if len(h)<12:raise ValueError(f"truncated chunk header {i}")
            typ,reserved,blocks,total=struct.unpack("<HHII",h[:12])
            data_pos=f.tell();size=total-chunk_hdr
            chunk={"index":i,"type":CT.get(typ,hex(typ)),"input_offset":pos,"output_offset":out_offset,
                "logical_bytes":blocks*block_size,"payload_bytes":size}
            if typ==0xcac1:
                data=f.read(min(size,SAMPLES))
                chunk["first_64_bytes"]=data[:64].hex()
                chunk["sample_entropy"]=round(entropy(data),3)
                chunk["known_headers"]=[]
                for name,signature in [("ELF",b"\x7fELF"),("EROFS",b"\xe2\xe1\xf5\xe0"),
                                       ("EXT4",b"\x53\xef"),("LP_GEOMETRY",b"gDla"),
                                       ("LP_HEADER",b"0PLA"),("HUAWEI",b"HUAWEI"),
                                       ("ANDROID",b"ANDROID!")]:
                    offset=data.find(signature)
                    if offset>=0:chunk["known_headers"].append({"name":name,"sample_offset":offset})
                f.seek(data_pos+size)
            elif typ in (0xcac2,0xcac4):
                val=f.read(min(size,64))
                chunk["fill_value_hex"]=val[:8].hex()
                f.seek(data_pos+size)
            elif typ==0xcac3:
                if size:f.seek(data_pos+size)
            else:
                chunk["unknown_type"]=True
                f.seek(data_pos+max(size,0))
            record["chunks"].append(chunk)
            out_offset+=blocks*block_size
        record["logical_bytes_accounted"]=out_offset
        record["input_bytes_accounted"]=f.tell()
    dest.write_text(json.dumps(record,indent=2,ensure_ascii=False)+"\n")
    print("SPARSE",p, "outputGB",round(out_offset/1e9,2),"chunks",len(record["chunks"]))
    for chunk in record["chunks"]:
        print(f"  {chunk['index']:02d} {chunk['type']:8s} "
              f"out=0x{chunk['output_offset']:x} bytes={chunk['logical_bytes']:,} "
              f"input=0x{chunk['input_offset']:x} entropy={chunk.get('sample_entropy','-')} "
              f"headers={chunk.get('known_headers',[])}")
if __name__=="__main__":main()
