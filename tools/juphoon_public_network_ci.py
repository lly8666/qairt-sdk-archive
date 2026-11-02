#!/usr/bin/env python3
"""Bounded, unauthenticated observations of vendor-DOCUMENTED public servers.

No app login, no credentials, no token, no replay, no endpoint discovery,
no router RPC payload. NEVER log response bodies, cookies, or raw packets.
The fixed target list may only be changed following a documented review.
Python 3.10+ stdlib.
"""
import argparse
import datetime as dt
import hashlib
import json
import pathlib
import re
import socket
import ssl

# Explicitly published in Juphoon JCClientLoginParam docs.
ROUTERS = (
    ("cn.router.justalkcloud.com", 8080),
    ("intl.router.justalkcloud.com", 8080),
)
# Official publicly readable documentation / policy pages, GET once.
HTTPS_PAGES = (
    ("developer.juphoon.com", "/cn/document/V2.0/oto_audio/quick-start/ios.php"),
    ("www.jegotrip.com.cn", "/wyx/web/protocol/protocol.html"),
    ("cdn.jegotrip.com.cn", "/static/app/protocol/tempProcotolPrivacy.html"),
)
TIMEOUT = 6

def dns(host):
    try:
        ips=sorted({a[4][0] for a in socket.getaddrinfo(host,None,socket.AF_INET,socket.SOCK_STREAM)})
        # Limit printed addresses; never persist private data.
        return {"ok":bool(ips),"ipv4":ips[:6],"ipv4_count":len(ips)}
    except (socket.gaierror,OSError) as e:
        return {"ok":False,"error":type(e).__name__}

def read_headers(sock,limit=6000):
    data=bytearray()
    try:
        while len(data)<limit and b"\r\n\r\n" not in data:
            part=sock.recv(min(1024,limit-len(data)))
            if not part:break
            data+=part
    except (socket.timeout,TimeoutError):pass
    return bytes(data)

def http_result(raw):
    match=re.match(rb"HTTP/\d(?:\.\d)?\s+(\d{3})\b",raw[:100])
    result={"protocol":"HTTP" if match else "no_standard_http_status","status":int(match.group(1)) if match else None}
    if match:
        for line in raw.split(b"\r\n")[1:]:
            key,sep,val=line.partition(b":")
            if sep and key.lower() in (b"server",b"content-type"):
                # Strictly limited to printable safe metadata.
                text=val.decode("latin1","replace").strip()[:80]
                text=re.sub(r"[^A-Za-z0-9_./;() =+-]","?",text)
                result[key.lower().decode()]=text
    return result

def router(host,port):
    res={"host":host,"port":port,"documented_protocol":"http","dns":dns(host),
         "test":"single TCP connect + HTTP HEAD /; no login and no payload"}
    if not res["dns"]["ok"]:
        res["reachability"]="DNS_ERROR";return res
    try:
        with socket.create_connection((host,port),timeout=TIMEOUT) as s:
            res["reachability"]="CONNECTED"
            s.settimeout(TIMEOUT)
            request=("HEAD / HTTP/1.1\r\nHost: "+host+
                     "\r\nUser-Agent: SchemeC-public-network-verification/1.0"+
                     "\r\nAccept: */*\r\nConnection: close\r\n\r\n").encode("ascii")
            s.sendall(request)
            res["http"]=http_result(read_headers(s,2048))
    except (OSError,TimeoutError,ssl.SSLError) as e:
        res["reachability"]=res.get("reachability","FAILED")
        res["error_type"]=type(e).__name__
    return res

def public_https(host,path):
    res={"host":host,"path":path,"port":443,"dns":dns(host),
         "test":"single TLS verified GET of official public document; response body discarded"}
    if not res["dns"]["ok"]:
        res["reachability"]="DNS_ERROR";return res
    try:
        context=ssl.create_default_context()
        with socket.create_connection((host,443),timeout=TIMEOUT) as raw:
            with context.wrap_socket(raw,server_hostname=host) as s:
                res["reachability"]="TLS_VERIFIED"
                res["tls_version"]=s.version()
                cert=s.getpeercert(binary_form=True)
                if cert:res["certificate_sha256"]=hashlib.sha256(cert).hexdigest()
                s.settimeout(TIMEOUT)
                request=("GET "+path+" HTTP/1.1\r\nHost: "+host+
                    "\r\nUser-Agent: SchemeC-public-network-verification/1.0"+
                    "\r\nAccept: text/html\r\nConnection: close\r\n\r\n").encode("ascii")
                s.sendall(request)
                res["http"]=http_result(read_headers(s))
    except (OSError,TimeoutError,ssl.SSLError) as e:
        res["reachability"]=res.get("reachability","FAILED")
        res["error_type"]=type(e).__name__
    return res

def selftest():
    assert len(ROUTERS)==2 and len(HTTPS_PAGES)==3
    assert http_result(b"HTTP/1.1 405 Method Not Allowed\r\nSet-Cookie: secret=123\r\nServer: envoy\r\n\r\n")=={
        "protocol":"HTTP","status":405,"server":"envoy"}
    assert http_result(b"\x00\x01hidden-token")["status"] is None
    assert all(not "/" in h and p==8080 for h,p in ROUTERS)
    assert all(p.startswith("/") and "?" not in p for _,p in HTTPS_PAGES)
    print("SELFTEST_PASS fixed allowlist + metadata-only parsing")

def main():
    ap=argparse.ArgumentParser();ap.add_argument("--out",type=pathlib.Path)
    ap.add_argument("--selftest",action="store_true");args=ap.parse_args()
    if args.selftest:return selftest()
    if not args.out:ap.error("--out is required")
    report={
        "schema":"SCHEME_C_PUBLIC_ENDPOINT_OBSERVATION_V1",
        "time_utc":dt.datetime.now(dt.timezone.utc).isoformat(),
        "scope":"only documented published endpoints and public policies; NO authentication, NO RPC",
        "notes":["Router public default addresses are NOT proof of JegoTrip-specific server use.",
                 "HTTP errors/no-reply do not imply credentials, service version or protocol compatibility.",
                 "No packet capture, response body, tokens, cookies or app binaries persisted."],
        "router":[router(h,p) for h,p in ROUTERS],
        "https_public_pages":[public_https(h,p) for h,p in HTTPS_PAGES],
    }
    args.out.parent.mkdir(parents=True,exist_ok=True)
    args.out.write_text(json.dumps(report,ensure_ascii=False,indent=2)+"\n")
    print("VENDOR_PUBLIC_ENDPOINTS_OBSERVED",len(report["router"]),len(report["https_public_pages"]))
    for x in report["router"]+report["https_public_pages"]:
        print(x["host"],x["reachability"],x.get("http",{}).get("status"),x.get("error_type",""))
if __name__=="__main__":main()
