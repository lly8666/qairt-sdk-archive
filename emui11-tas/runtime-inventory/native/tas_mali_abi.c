/*
 * TAS-AN00 Mali ABI compatibility metadata, no memory allocations or importing.
 * Safe ioctls: only _IOWR(0x80,0,kbase_ioctl_version_check), based on Bifrost ABI.
 * No writes to device memory, no page-cache changes, no kernel exploits.
 */
#define _GNU_SOURCE
#include <jni.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <stdint.h>
#include <inttypes.h>

struct kbase_ioctl_version_check { uint16_t major, minor; };
struct kbase_ioctl_mem_alloc_user {
    uint64_t va_pages, commit_pages, extent, flags;
};
struct kbase_ioctl_mem_import_user {
    uint64_t flags, phandle;
    uint32_t type, padding;
    uint64_t header_page_number;
};
static void append(char *dest,size_t cap,const char *fmt,const char *label,int val) {
    size_t n=strlen(dest);
    if (n<cap) snprintf(dest+n,cap-n,fmt,label,val);
}

JNIEXPORT jstring JNICALL
Java_io_github_tasaudit_runtimeinventory_ProbeCollector_probeMaliNative(
    JNIEnv *env, jclass cls) {
    (void)cls;
    char result[3200]={0};
    snprintf(result,sizeof(result),
        "[mali]\nprobe_version=1\nread_only=true\n"
        "reference_abi_requested=11.16\n"
        "abi_version_ioctl_request=0x%08x\n"
        "mem_alloc_request_layout_bytes=%zu\n"
        "mem_import_request_layout_bytes=%zu\n"
        "memory_allocate_invoked=false\nmemory_import_invoked=false\n",
        (unsigned)_IOWR(0x80,0,struct kbase_ioctl_version_check),
        sizeof(struct kbase_ioctl_mem_alloc_user),sizeof(struct kbase_ioctl_mem_import_user));
    const char *devices[]={"/dev/mali0","/dev/mali","/dev/mali1"};
    for(unsigned i=0;i<sizeof(devices)/sizeof(devices[0]);i++) {
        const char *d=devices[i];
        char key[70];snprintf(key,sizeof(key),"device_%u",i);
        size_t n=strlen(result);
        snprintf(result+n,sizeof(result)-n,"%s_path=%s\n",key,d);
        struct stat st;
        errno=0;
        if(stat(d,&st)==0){
            n=strlen(result);
            snprintf(result+n,sizeof(result)-n,"%s_stat=OK mode=%04o uid=%lu gid=%lu\n",
                key,st.st_mode&07777,(unsigned long)st.st_uid,(unsigned long)st.st_gid);
        } else {
            append(result,sizeof(result),"%s_stat_errno=%d\n",key,errno);
            continue;
        }
        errno=0;
        int fd=open(d,O_RDONLY|O_CLOEXEC);
        if(fd<0) {
            append(result,sizeof(result),"%s_open_readonly_errno=%d\n",key,errno);
            errno=0;
            fd=open(d,O_RDWR|O_CLOEXEC);
            if(fd<0) {
                append(result,sizeof(result),"%s_open_readwrite_errno=%d\n",key,errno);
                continue;
            }
            n=strlen(result);
            snprintf(result+n,sizeof(result)-n,"%s_open_mode=readwrite\n",key);
        }else {
            n=strlen(result);
            snprintf(result+n,sizeof(result)-n,"%s_open_mode=readonly\n",key);
        }
        struct kbase_ioctl_version_check v={11,16};
        errno=0;
        int rc=ioctl(fd,_IOWR(0x80,0,struct kbase_ioctl_version_check),&v);
        int saved_errno=errno;
        n=strlen(result);
        if(rc>=0) {
            snprintf(result+n,sizeof(result)-n,
                "%s_version_ioctl=PASS\n%s_version_major=%u\n%s_version_minor=%u\n",
                key,key,(unsigned)v.major,key,(unsigned)v.minor);
        } else {
            snprintf(result+n,sizeof(result)-n,"%s_version_ioctl=FAIL errno=%d\n",key,saved_errno);
        }
        close(fd);
    }
    strncat(result,"[/mali]\n",sizeof(result)-strlen(result)-1);
    return (*env)->NewStringUTF(env,result);
}
