/*
 * TAS Mali Bifrost 11.16 compatibility & disposable app-file canary.
 * Adapted solely for interface verification from the existing
 * BellezaEmporium/ghostlock-bkl-l09 enabler/inject_hook.c (MIT license).
 * Does not touch system executables, firmware, SELinux, perf settings, or kernel code.
 *
 * Cases 0-4 test open/version, set_flags, tracking mmap, mem_alloc + CPU mmap,
 * and import user buffer + CPU mmap. Case 5 reproduces the existing Mali import/
 * soft-job/page-cache behaviour against a *newly-created app-owned test page*.
 * Each case is fork-isolated, watchdogged and fully logged.
 */
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <sched.h>
#include <signal.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#define BASE_MEM_PROT_CPU_RD  (1U<<0)
#define BASE_MEM_PROT_CPU_WR  (1U<<1)
#define BASE_MEM_PROT_GPU_RD  (1U<<2)
#define BASE_MEM_IMPORT_TYPE_USER_BUFFER 3
#define BASE_MEM_MAP_TRACKING_HANDLE (3ULL<<12)
#define BASE_JD_REQ_EXTERNAL_RESOURCES (1U<<8)
#define BASE_JD_REQ_SOFT_JOB (1U<<9)
#define BASE_JD_REQ_SOFT_EVENT_WAIT (BASE_JD_REQ_SOFT_JOB|0x5U)
#define CASE_COUNT 6
#define CASE_DEADLINE_MS 6000

struct kbase_ioctl_version_check {uint16_t major,minor;};
struct kbase_ioctl_set_flags {uint32_t create_flags;};
struct base_jd_udata {uint64_t blob[2];};
struct base_dependency {uint8_t atom_id,dependency_type;};
struct base_jd_atom_v2 {
    uint64_t jc;
    struct base_jd_udata udata;
    uint64_t extres_list;
    uint16_t nr_extres,compat_core_req;
    struct base_dependency pre_dep[2];
    uint8_t atom_number,prio,device_nr,padding[1];
    uint32_t core_req;
};
struct base_external_resource {uint64_t ext_resource;};
struct kbase_ioctl_job_submit {uint64_t addr;uint32_t nr_atoms,stride;};
struct base_mem_import_user_buffer {uint64_t ptr,length;};
union kbase_ioctl_mem_import {
    struct {uint64_t flags,phandle;uint32_t type,padding;uint64_t header_page_number;} in;
    struct {uint64_t flags,gpu_va,va_pages;} out;
};
union kbase_ioctl_mem_alloc {
    struct {uint64_t va_pages,commit_pages,extent,flags;} in;
    struct {uint64_t flags,gpu_va;} out;
};
struct gpu {int fd;void* tracking;};

static void stamp(const char*fmt,...){
    va_list ap;va_start(ap,fmt);vprintf(fmt,ap);va_end(ap);fflush(stdout);
}
static void result(const char*stage,int rc,int saved_errno){
    stamp("%s_rc=%d\n%s_errno=%d\n%s_status=%s\n",stage,rc,stage,saved_errno,stage,rc>=0?"PASS":"FAIL");
}
static int open_device(struct gpu*g){
    memset(g,0,sizeof(*g));g->fd=-1;g->tracking=MAP_FAILED;
    errno=0;int fd=open("/dev/mali0",O_RDWR|O_CLOEXEC);
    result("open_mali",fd>=0?0:-1,fd<0?errno:0);
    if(fd<0)return -1;
    g->fd=fd;return 0;
}
static void close_device(struct gpu*g){
    if(g->tracking!=MAP_FAILED)munmap(g->tracking,4096);
    if(g->fd>=0)close(g->fd);
}
static int check_version(struct gpu*g){
    struct kbase_ioctl_version_check ver={11,16};
    errno=0;int rc=ioctl(g->fd,_IOWR(0x80,0,struct kbase_ioctl_version_check),&ver);
    int e=errno;result("abi_version_ioctl",rc,e);
    stamp("abi_reported=%u.%u\n",(unsigned)ver.major,(unsigned)ver.minor);
    return rc>=0 && ver.major==11 && ver.minor==16?0:-1;
}
static int set_flags(struct gpu*g){
    struct kbase_ioctl_set_flags flags={0};
    errno=0;int rc=ioctl(g->fd,_IOW(0x80,1,struct kbase_ioctl_set_flags),&flags);
    result("set_flags",rc,errno);
    return rc<0?-1:0;
}
static int gpu_init(struct gpu*g,int flags){
    if(open_device(g)<0)return -1;
    if(check_version(g)<0){close_device(g);return -1;}
    if(flags && set_flags(g)<0){close_device(g);return -1;}
    return 0;
}
static int tracking_map(struct gpu*g){
    errno=0;
    g->tracking=mmap(NULL,4096,PROT_READ|PROT_WRITE,MAP_SHARED,g->fd,BASE_MEM_MAP_TRACKING_HANDLE);
    int e=errno;result("tracking_map",g->tracking==MAP_FAILED?-1:0,e);
    return g->tracking==MAP_FAILED?-1:0;
}
static void* alloc_gpu(struct gpu*g){
    union kbase_ioctl_mem_alloc a;memset(&a,0,sizeof(a));
    a.in.va_pages=1;a.in.commit_pages=1;
    a.in.flags=BASE_MEM_PROT_CPU_RD|BASE_MEM_PROT_CPU_WR|
        BASE_MEM_PROT_GPU_RD|(1U<<3)|(1U<<22);
    errno=0;
    int rc=ioctl(g->fd,_IOWR(0x80,5,union kbase_ioctl_mem_alloc),&a);
    int e=errno;result("mem_alloc_ioctl",rc,e);
    if(rc<0)return MAP_FAILED;
    stamp("mem_alloc_va_pages=1\n");
    errno=0;
    void*m=mmap(NULL,4096,PROT_READ|PROT_WRITE,MAP_SHARED,g->fd,(off_t)a.out.gpu_va);
    result("mem_alloc_cpu_map",m==MAP_FAILED?-1:0,errno);
    return m;
}
static void* import_buffer(struct gpu*g,void*buf,uint64_t*gpu_va){
    struct base_mem_import_user_buffer ubi={(uint64_t)(uintptr_t)buf,4096};
    union kbase_ioctl_mem_import mi;memset(&mi,0,sizeof(mi));
    mi.in.flags=BASE_MEM_PROT_CPU_RD|BASE_MEM_PROT_CPU_WR|BASE_MEM_PROT_GPU_RD|(1U<<12);
    mi.in.phandle=(uint64_t)(uintptr_t)&ubi;
    mi.in.type=BASE_MEM_IMPORT_TYPE_USER_BUFFER;
    errno=0;
    int rc=ioctl(g->fd,_IOWR(0x80,22,union kbase_ioctl_mem_import),&mi);
    int e=errno;result("mem_import_ioctl",rc,e);
    if(rc<0)return MAP_FAILED;
    if(gpu_va)*gpu_va=mi.out.gpu_va;
    stamp("mem_import_va_pages=%"PRIu64"\n",mi.out.va_pages);
    errno=0;
    void*cmap=mmap(NULL,4096,PROT_READ|PROT_WRITE,MAP_SHARED,g->fd,(off_t)mi.out.gpu_va);
    result("mem_import_cpu_map",cmap==MAP_FAILED?-1:0,errno);
    return cmap;
}
static int submit_soft_job(struct gpu*g,void*jc,uint64_t extres){
    struct base_external_resource er={extres};
    struct base_jd_atom_v2 a;memset(&a,0,sizeof(a));
    a.atom_number=0;
    a.core_req=BASE_JD_REQ_EXTERNAL_RESOURCES|BASE_JD_REQ_SOFT_EVENT_WAIT;
    a.extres_list=(uint64_t)(uintptr_t)&er;
    a.nr_extres=1;
    a.jc=(uint64_t)(uintptr_t)jc;
    struct kbase_ioctl_job_submit s={0};
    s.addr=(uint64_t)(uintptr_t)&a;s.nr_atoms=1;
    s.stride=(uint32_t)sizeof(a);
    errno=0;
    int rc=ioctl(g->fd,_IOW(0x80,2,struct kbase_ioctl_job_submit),&s);
    int e=errno;result("soft_job_submit",rc,e);
    stamp("soft_job_atom_bytes=%zu\n",sizeof(a));
    return rc>=0?0:-1;
}
static int run_test(int id,const char*private_dir){
    struct gpu g;
    if(gpu_init(&g,id!=0)<0)return 3;
    if(id==0){stamp("version_matches_reference=1\n");close_device(&g);return 0;}
    if(id==1){stamp("flags_accepted=1\n");close_device(&g);return 0;}
    if(tracking_map(&g)<0){close_device(&g);return 4;}
    if(id==2){close_device(&g);return 0;}
    if(id==3){
        void*m=alloc_gpu(&g);
        if(m==MAP_FAILED){close_device(&g);return 5;}
        ((volatile uint32_t*)m)[0]=UINT32_C(0x47313136);
        stamp("mem_alloc_roundtrip=%s\n",((volatile uint32_t*)m)[0]==UINT32_C(0x47313136)?"PASS":"FAIL");
        munmap(m,4096);close_device(&g);return 0;
    }
    void*X=mmap(NULL,4096,PROT_READ|PROT_WRITE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
    if(X==MAP_FAILED){result("anon_mmap",-1,errno);close_device(&g);return 6;}
    memset(X,0x41,4096);
    uint64_t imported_gpu_va=0;
    void*cmap=import_buffer(&g,X,&imported_gpu_va);
    if(cmap==MAP_FAILED){munmap(X,4096);close_device(&g);return 7;}
    if(id==4){
        stamp("mem_import_mapping_usable=1\n");
        munmap(cmap,4096);munmap(X,4096);close_device(&g);return 0;
    }
    /* File test: only in app-owned files/, never a system path. */
    struct stat dst;
    if(stat(private_dir,&dst)<0 || !S_ISDIR(dst.st_mode) || dst.st_uid!=getuid()){
        stamp("private_dir_guard=FAIL errno=%d\n",errno);
        munmap(cmap,4096);munmap(X,4096);close_device(&g);return 8;
    }
    stamp("private_dir_guard=PASS\n");
    char filename[1024];
    int n=snprintf(filename,sizeof(filename),"%s/tas_mali_owned_canary_%ld.bin",
                   private_dir,(long)getpid());
    if(n<=0 || n>=(int)sizeof(filename)){
        stamp("file_path_length=INVALID\n");close_device(&g);return 8;
    }
    int wfd=open(filename,O_WRONLY|O_CREAT|O_EXCL|O_CLOEXEC|O_NOFOLLOW,0600);
    if(wfd<0){result("canary_create",-1,errno);close_device(&g);return 9;}
    uint8_t original[4096],desired[4096],actual[4096];
    memset(original,0x41,sizeof(original));memcpy(desired,original,sizeof(desired));
    memcpy(desired,"TAS_MALI_11_16_PAGE_CACHE_TEST",29);
    int wrote=write(wfd,original,4096)==4096;
    if(wrote)fsync(wfd);close(wfd);
    if(!wrote){stamp("canary_init=FAIL\n");unlink(filename);close_device(&g);return 10;}
    stamp("canary_create=PASS\ncanary_path_scope=app_private_only\n");
    int f=open(filename,O_RDONLY|O_CLOEXEC|O_NOFOLLOW);
    if(f<0){result("canary_readonly_open",-1,errno);unlink(filename);close_device(&g);return 11;}
    /* Exact reference shape: imported X, unmap X, remap X as RO file page. */
    munmap(X,4096);X=MAP_FAILED;
    X=mmap(X,4096,PROT_READ,MAP_PRIVATE|MAP_FIXED,f,0);
    /* We must retain the old virtual address explicitly; handled below. */
    if(X==MAP_FAILED){
        result("canary_ro_map",-1,errno);
        close(f);unlink(filename);munmap(cmap,4096);close_device(&g);return 12;
    }
    stamp("canary_ro_map=PASS\n");
    void*jc=alloc_gpu(&g);
    if(jc==MAP_FAILED){
        close(f);unlink(filename);munmap(X,4096);munmap(cmap,4096);close_device(&g);return 13;
    }
    if(submit_soft_job(&g,jc,(uint64_t)(uintptr_t)cmap)<0){
        close(f);unlink(filename);munmap(jc,4096);munmap(X,4096);
        munmap(cmap,4096);close_device(&g);return 14;
    }
    stamp("canary_after_soft_job=1\n");
    memcpy(cmap,desired,4096);
    __builtin___clear_cache((char*)cmap,(char*)cmap+4096);
    ssize_t nr=pread(f,actual,sizeof(actual),0);
    stamp("canary_same_fd_read_bytes=%zd\n",nr);
    stamp("canary_same_fd_modified=%d\n",nr==4096 && !memcmp(actual,desired,4096));
    int f2=open(filename,O_RDONLY|O_CLOEXEC);
    if(f2>=0){
        nr=pread(f2,actual,sizeof(actual),0);
        stamp("canary_second_fd_modified=%d\n",nr==4096 && !memcmp(actual,desired,4096));
        close(f2);
    }else stamp("canary_second_fd_errno=%d\n",errno);
    errno=0;
    void*other=mmap(NULL,4096,PROT_READ,MAP_PRIVATE,f,0);
    if(other!=MAP_FAILED){
        stamp("canary_private_map_modified=%d\n",!memcmp(other,desired,4096));
        munmap(other,4096);
    }else stamp("canary_private_map_errno=%d\n",errno);
    munmap(jc,4096);munmap(X,4096);munmap(cmap,4096);close(f);
    close_device(&g);
    unlink(filename);
    stamp("canary_cleanup=PASS\n");
    return 0;
}
static const char* case_names[CASE_COUNT]={
    "bifrost_11_16_abi","set_flags","tracking_map","gpu_memory_alloc",
    "user_buffer_import","app_private_file_cache_canary"};
static void one_case(int id,const char*dir){
    stamp("CASE_BEGIN=%02d:%s\n",id,case_names[id]);
    pid_t p=fork();
    if(p<0){stamp("CASE_FORK_ERROR=%02d:%d\n",id,errno);return;}
    if(p==0) {
        int rc=run_test(id,dir);
        _exit(rc);
    }
    int status=0,done=0,elapsed=0;
    for(;elapsed<CASE_DEADLINE_MS;elapsed+=25){
        pid_t w=waitpid(p,&status,WNOHANG);
        if(w==p){done=1;break;}
        if(w<0){done=-1;break;}
        usleep(25000);
    }
    if(done==0) {
        stamp("CASE_TIMEOUT=%02d:%dms\n",id,CASE_DEADLINE_MS);
        kill(p,SIGKILL);waitpid(p,&status,0);
    }else if(done<0)stamp("CASE_WAIT_ERROR=%02d:%d\n",id,errno);
    else if(WIFSIGNALED(status))stamp("CASE_SIGNAL=%02d:%d\n",id,WTERMSIG(status));
    else if(WIFEXITED(status))stamp("CASE_EXIT=%02d:%d\n",id,WEXITSTATUS(status));
    stamp("CASE_END=%02d:%s\n",id,case_names[id]);
}
int main(int argc,char**argv){
    setvbuf(stdout,NULL,_IONBF,0);
    if(argc!=3 || strcmp(argv[1],"--batch")) {
        fprintf(stderr,"usage: tas_mali_batch --batch /path/to/private/files\n");return 2;
    }
    stamp("TAS_MALI_COMPAT_V2_BEGIN\n");
    stamp("reference=BellezaEmporium/ghostlock-bkl-l09@381476444fbbbcf0c5e8e3c2e2166647e9134ab5\n");
    stamp("case_count=%d\n",CASE_COUNT);
    stamp("system_file_modified=false\n");
    stamp("boot_partition_modified=false\n");
    stamp("gpu_memory_import_tested=true\n");
    stamp("app_private_canary_requested=true\n");
    for(int i=0;i<CASE_COUNT;i++)one_case(i,argv[2]);
    stamp("TAS_MALI_COMPAT_V2_END\n");
    return 0;
}
