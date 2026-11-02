#!/usr/bin/env python3
"""Juphoon v6: frozen offline RPC proof and SYNTHETIC localhost TLS PCAP.
No vendor login, no external network probe, no captured personal data.
"""
import hashlib,json,pathlib,subprocess,tempfile,zipfile,socket,ssl,threading,time,os,sys
P="菊风SDK_v6/"
SHA="1ba353c5dc71cdc92e6852b9efc853dfbeb63bda2d3d74636af4a52b73457627"
def command(*argv,**kw):
    return subprocess.run(list(map(str,argv)),check=True,text=True,**kw)
def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()
def verdict(path,record):
    path.write_text(json.dumps(record,indent=2,ensure_ascii=False)+"\n")
def static(zippath,out):
    assert zippath.stat().st_size==59488232 and sha(zippath)==SHA
    with zipfile.ZipFile(zippath) as z, tempfile.TemporaryDirectory() as tmp:
        assert z.testzip() is None
        d=pathlib.Path(tmp)
        paths=["binaries/libmtc.so","analysis/rpc_operation_xrefs.py",
               "analysis/map_rpc_unwind_functions.py","analysis/rpc_selector_references.json",
               "analysis/rpc_selector_function_ranges.json"]
        for p in paths:
            dest=d/p;dest.parent.mkdir(parents=True,exist_ok=True)
            dest.write_bytes(z.read(P+p))
        lib=d/"binaries/libmtc.so"; original=d/"analysis"
        assert b"AArch64" in command("readelf","-h",lib,capture_output=True).stdout.encode()
        replay=d/"replay";replay.mkdir()
        command(sys.executable,original/"rpc_operation_xrefs.py",lib,replay,capture_output=True)
        command(sys.executable,original/"map_rpc_unwind_functions.py",lib,replay,capture_output=True)
        for p in ("rpc_selector_references.json","rpc_selector_function_ranges.json"):
            assert (replay/p).read_bytes()==(original/p).read_bytes(),p
        refs=json.loads((replay/"rpc_selector_references.json").read_text())["references"]
        fde=json.loads((replay/"rpc_selector_function_ranges.json").read_text())["method_xrefs"]
        assert len(refs)==29 and len(set(r["rpc"] for r in refs))==29
        assert len(fde)==29 and all(int(x["fde_begin"],16)<=int(x["adrp_va"],16)<int(x["fde_end"],16) for x in fde)
        blob=bytearray(lib.read_bytes());loc=int(refs[0]["literal_va"],16)
        assert blob[loc:loc+len(refs[0]["rpc"])]==refs[0]["rpc"].encode()
        blob[loc]=33
        bad=d/"lib-corrupt.so";bad.write_bytes(blob)
        negative=d/"negative";negative.mkdir()
        command(sys.executable,original/"rpc_operation_xrefs.py",bad,negative,capture_output=True)
        assert len(json.loads((negative/"rpc_selector_references.json").read_text())["references"])==28
        verdict(out/"static.json",{
            "status":"PASS","release_sha256":SHA,"libmtc_sha256":sha(lib),
            "rpc_selectors":29,"fde_mappings":29,"negative_corruption_ref_count":28,
            "scope":"offline ABI and code xrefs only; no wire protocol or vendor access"
        })
def synthetic(out):
    with tempfile.TemporaryDirectory() as tmp:
        tmp=pathlib.Path(tmp);crt=tmp/"cert.pem";key=tmp/"key.pem"
        command("openssl","req","-x509","-newkey","rsa:2048","-nodes","-days","1",
                "-subj","/CN=localhost","-addext","subjectAltName=DNS:localhost,IP:127.0.0.1",
                "-keyout",key,"-out",crt,stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
        listener=socket.socket();listener.bind(("127.0.0.1",0));listener.listen(2)
        listener.settimeout(6);port=listener.getsockname()[1]
        ctx=ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER);ctx.load_cert_chain(crt,key)
        seen=[]
        def serve():
            try:
                for _ in range(2):
                    raw,_=listener.accept()
                    try:
                        with ctx.wrap_socket(raw,server_side=True) as c:
                            seen.append(c.recv(2048))
                            c.sendall(b"LAB-ACK\n")
                    except ssl.SSLError:pass
            finally:listener.close()
        worker=threading.Thread(target=serve,daemon=True);worker.start()
        pcap=out/"synthetic-loopback-only.pcap"
        cmd=["tcpdump","-i","lo","-U","-s","0","-w",str(pcap),"tcp","and","port",str(port)]
        if os.geteuid()!=0:cmd=["sudo","-n",*cmd]
        proc=subprocess.Popen(cmd,stdout=subprocess.DEVNULL,stderr=subprocess.PIPE,text=True)
        try:
            for _ in range(8):
                line=proc.stderr.readline()
                if "listening on" in line:break
            else:raise RuntimeError("tcpdump not ready")
            # Give the capture process one scheduling quantum on the hosted runner.
            time.sleep(0.5)
            trusted=ssl.create_default_context(cafile=str(crt))
            with socket.create_connection(("127.0.0.1",port),timeout=3) as sock:
                with trusted.wrap_socket(sock,server_hostname="localhost") as conn:
                    conn.sendall(b"LAB-HELLO\n")
                    assert conn.recv(64)==b"LAB-ACK\n"
            rejected=False
            try:
                with socket.create_connection(("127.0.0.1",port),timeout=3) as sock:
                    with ssl.create_default_context().wrap_socket(sock,server_hostname="localhost"):pass
            except ssl.SSLCertVerificationError:rejected=True
            assert rejected
            worker.join(6);assert not worker.is_alive() and seen==[b"LAB-HELLO\n"]
        finally:
            # Let -U flush frames before stopping the capture.
            time.sleep(0.7)
            proc.terminate()
            try:proc.wait(timeout=5)
            except subprocess.TimeoutExpired:proc.kill()
        packets=command("tcpdump","-n","-r",pcap,capture_output=True).stdout.splitlines()
        if not (pcap.stat().st_size>300 and len(packets)>=6):
            raise AssertionError("capture diagnostics: bytes="+str(pcap.stat().st_size)+
                                 " packets="+str(len(packets)))
        assert all("127.0.0.1." in p for p in packets if "IP " in p)
        verdict(out/"synthetic.json",{"status":"PASS","endpoint":"127.0.0.1",
            "packet_count":len(packets),"pcap_sha256":sha(pcap),
            "scope":"Synthetic TLS fixture ONLY; not Juphoon protocol, vendor server or actual SMS/call"})
if __name__=="__main__":
    inp=pathlib.Path(sys.argv[1]);out=pathlib.Path(sys.argv[2]);out.mkdir(parents=True,exist_ok=True)
    static(inp,out);print("OFFLINE_RPCS_PASS_29",flush=True)
    synthetic(out);print("SYNTHETIC_LOCALHOST_TLS_PCAP_PASS",flush=True)
