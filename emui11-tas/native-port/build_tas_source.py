#!/usr/bin/env python3
"""Produce a hash-pinned TAS-AN00 port from the published MIT MRX source."""
import hashlib, pathlib, re, sys
OLD_SHA='70b95785a11c2a80059eba7a95b52c8a8f8380be6b8fc4eb3efc23e7d1aa4eba'
PORT_SHA='dda52fc17459f52c9a44b0777969c150f914e55c56735b19d777d93dd8a32542'
MACROS={
'LINK_STEXT':'ffffff8008081000',
'LINK_SCHEDULE':'ffffff8009ea2ac8',
'LINK_DO_FUTEX':'ffffff8008290890',
'LINK_RMAPC':'ffffff800822eb08',
'LINK_COMMIT_CREDS':'ffffff80081aa964',
'LINK_INIT_CRED':'ffffff800adfcd28',
'LINK_POLICYDB':'ffffff800b3b97c0',
'LINK_INIT_TASK':'ffffff800adeb4c0',
'LINK_PERF_PARANOID':'ffffff800adda5f4',
'LINK_AVC_CACHE_THRESHOLD':'ffffff800ae5a168',
'SCRATCH_LINK':'ffffff800b283000',
'LINK_GETPID_CFI':'ffffff8008190a94',
'LINK_BOOTID_DF':'ffffff800b09cfa8',
'LINK_SYSCTL_BOOTID':'ffffff800b3e051c',
'LINK_HKIP_UID_BITS':'ffffff800b42c000',
'LINK_HKIP_GID_BITS':'ffffff800b42d000',
'LINK_HKIP_ADDR_LIMIT':'ffffff800b42e000',
'LINK_CAPABLE_LIST':'ffffff8009ec0730',
}
def patch(src,out):
    data=pathlib.Path(src).read_bytes()
    assert hashlib.sha256(data).hexdigest()==OLD_SHA, 'Pinned MRX source checksum mismatch'
    text=data.decode()
    for key,value in MACROS.items():
        p=rf'(?m)^(#define\s+{re.escape(key)}\s+)UINT64_C\(0x([0-9a-fA-F]+)\)'
        text,n=re.subn(p,lambda m:m.group(1)+f'UINT64_C(0x{value})',text)
        assert n==1,key
    text,n=re.subn(r'(?m)^(#define\s+TASK_COMM_OFF\s+)UINT64_C\(0xAB8\)',r'\g<1>UINT64_C(0x9F0)',text)
    assert n==1
    mark='#define _GNU_SOURCE\n'
    assert text.count(mark)==1
    text=text.replace(mark,mark+'#include <sys/utsname.h>\n#include <sys/mount.h>\n#include <sys/system_properties.h>\n')
    guard=r'''
static int tas_target_check(int verbose) {
    struct utsname u;
    char model[PROP_VALUE_MAX]={0},device[PROP_VALUE_MAX]={0},board[PROP_VALUE_MAX]={0};
    char os[PROP_VALUE_MAX]={0},build[PROP_VALUE_MAX]={0};
    int ok=0;
    if(uname(&u)) return 0;
    __system_property_get("ro.product.model",model);
    __system_property_get("ro.product.device",device);
    __system_property_get("ro.product.board",board);
    __system_property_get("ro.build.version.release",os);
    __system_property_get("ro.build.display.id",build);
    ok=!strcmp(model,"TAS-AN00")&&!strcmp(device,"HWTAS")&&!strcmp(board,"TAS")
       &&!strcmp(os,"10")&&!strcmp(u.release,"4.14.116")
       &&strstr(u.version,"Wed Jul 21 19:39:33 CST 2021")!=NULL
       &&strstr(build,"11.0.0.185(")!=NULL;
    if(verbose) {
      printf("TAS_GHOSTLOCK_PORT_V0.1\nidentity=%s\n",ok?"MATCH":"MISMATCH");
      printf("model=%s\ndevice=%s\nboard=%s\nandroid=%s\nkernel=%s\n",model,device,board,os,u.release);
      printf("build=%s\n",build);
      printf("note=experimental_build_not_qualified_for_root\n");
    }
    return ok;
}
'''
    main='int main(int argc,char**argv){'
    assert text.count(main)==1
    text=text.replace(main,guard+'\n'+main+'\n    if(argc>1 && !strcmp(argv[1],"--tas-profile")){ return tas_target_check(1)?0:2; }\n    if(!tas_target_check(1)){ fprintf(stderr,"TAS device mismatch: blocked\\n"); return 2; }')
    d=text.encode()
    actual=hashlib.sha256(d).hexdigest()
    assert actual==PORT_SHA, 'Port hash mismatch '+actual
    pathlib.Path(out).write_bytes(d)
    print('TAS source port PASS',len(d),'bytes',actual)
if __name__=='__main__':
    if len(sys.argv)!=3:raise SystemExit('usage: build_tas_source.py <pinned_upstream.c> <tas_output.c>')
    patch(sys.argv[1],sys.argv[2])
