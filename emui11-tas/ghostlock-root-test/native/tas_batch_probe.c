/*
 * TAS-AN00 EMUI 11 KASLR precondition batch diagnostics.
 * Read-only probes; no GhostLock trigger, root attempt, kernel writes, or memory addresses.
 * Copyright 2026; MIT License.
 */
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <linux/perf_event.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/prctl.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/utsname.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#ifndef PERF_FLAG_FD_CLOEXEC
#define PERF_FLAG_FD_CLOEXEC (1U << 3)
#endif
enum { TOTAL_CASES=13, CASE_TIMEOUT_MS=3000 };
static const char *names[TOTAL_CASES]={
 "process_identity", "security_context", "perf_event_paranoid",
 "kptr_restrict", "dmesg_restrict", "selinux_enforce",
 "kallsyms_visibility", "boot_id_access", "process_status",
 "perf_software_task_user", "perf_software_cpu_user",
 "perf_kernel_only", "perf_exact_leak_shape"
};
static void report_error(const char *label) {
 int e=errno;
 printf("%s_result=error\n%s_errno=%d\n%s_errstr=%s\n",label,label,e,label,strerror(e));
}
static void read_path(const char *label, const char *path, int print_value) {
 int fd=open(path,O_RDONLY|O_CLOEXEC);
 if(fd<0){ report_error(label); return; }
 char buf[160];ssize_t n=read(fd,buf,sizeof(buf)-1);int saved=errno;close(fd);
 if(n<0){errno=saved;report_error(label);return;}
 buf[n]=0;
 char *newline=strchr(buf,'\n');if(newline)*newline=0;
 for(ssize_t i=0;i<n && buf[i];i++)
     if((unsigned char)buf[i]<32 || buf[i]=='=' || buf[i]=='\r')buf[i]='_';
 printf("%s_result=readable\n%s_bytes=%zd\n",label,label,n);
 if(print_value) printf("%s_value=%s\n",label,buf);
}
static void proc_status(void) {
 FILE *f=fopen("/proc/self/status","r");if(!f){report_error("process_status");return;}
 char buf[256];int found=0;
 while(fgets(buf,sizeof(buf),f)) {
   const char *keys[]={"Uid:","CapEff:","Seccomp:","NoNewPrivs:","TracerPid:"};
   const char *labels[]={"uid","cap_eff","seccomp","no_new_privs","tracer_pid"};
   for(int k=0;k<5;k++)if(!strncmp(buf,keys[k],strlen(keys[k]))) {
     char *p=buf+strlen(keys[k]);while(*p=='\t'||*p==' ')p++;
     p[strcspn(p,"\r\n")]=0;printf("%s=%s\n",labels[k],p);found++;
   }
 }
 fclose(f);printf("process_status_fields=%d\n",found);
}
static void kallsyms(void){
 FILE *f=fopen("/proc/kallsyms","r");if(!f){report_error("kallsyms");return;}
 char line[512],address[64]={0};char type=0,name[256]={0};
 int n=fgets(line,sizeof(line),f)!=NULL;fclose(f);
 if(!n){printf("kallsyms_result=empty\n");return;}
 int parsed=sscanf(line,"%63s %c %255s",address,&type,name);
 int nonzero=0;
 if(parsed==3)for(int j=0;address[j];j++)if(address[j]!='0')nonzero=1;
 printf("kallsyms_result=readable\nkallsyms_header_parsed=%d\nkallsyms_first_address_nonzero=%d\n",parsed==3,nonzero);
}
static int perf_open_try(const char *name,int task_clock,int exclude_user,int exclude_kernel,int exact) {
 struct perf_event_attr a;memset(&a,0,sizeof(a));
 a.type=PERF_TYPE_SOFTWARE;
 a.size=sizeof(a);
 a.config=task_clock?PERF_COUNT_SW_TASK_CLOCK:PERF_COUNT_SW_CPU_CLOCK;
 a.disabled=1; a.exclude_user=exclude_user; a.exclude_kernel=exclude_kernel;
 a.exclude_hv=1;
 if(exact) {
   a.sample_period=100000;
   a.sample_type=PERF_SAMPLE_IP|PERF_SAMPLE_TID|PERF_SAMPLE_CALLCHAIN;
   a.sample_max_stack=32;
 }
 errno=0;
 long fd=syscall(__NR_perf_event_open,&a,0,-1,-1,0);
 if(fd<0){report_error(name);return 0;}
 printf("%s_result=open_ok\n%s_fd_opened=1\n",name,name);
 if(exact) {
   long pg=sysconf(_SC_PAGESIZE);
   size_t ms=(size_t)pg*33u;
   errno=0;
   struct perf_event_mmap_page *meta=mmap(NULL,ms,PROT_READ|PROT_WRITE,MAP_SHARED,(int)fd,0);
   if(meta==MAP_FAILED){report_error("perf_exact_mmap");close((int)fd);return 0;}
   printf("perf_exact_mmap_result=success\n");
   errno=0;int reset=ioctl((int)fd,PERF_EVENT_IOC_RESET,0);int er=errno;
   errno=0;int en=ioctl((int)fd,PERF_EVENT_IOC_ENABLE,0);int ee=errno;
   if(en==0){
     for(int i=0;i<250000;i++)syscall(__NR_gettid);
   }
   errno=0;int dis=ioctl((int)fd,PERF_EVENT_IOC_DISABLE,0);int ed=errno;
   __sync_synchronize();
   uint64_t head=meta->data_head,tail=meta->data_tail,rs=meta->data_size;
   printf("perf_exact_reset_rc=%d\nperf_exact_reset_errno=%d\n",reset,er);
   printf("perf_exact_enable_rc=%d\nperf_exact_enable_errno=%d\n",en,ee);
   printf("perf_exact_disable_rc=%d\nperf_exact_disable_errno=%d\n",dis,ed);
   printf("perf_exact_ring_bytes=%" PRIu64 "\n",rs);
   printf("perf_exact_data_bytes=%" PRIu64 "\n",(head>=tail)?head-tail:0);
   int samples=0,valid_ip=0,kernel_ip=0,other_records=0;
   if(rs && !(rs&(rs-1)) && rs<=ms && head>=tail && head-tail<=rs) {
     uint8_t *ring=(uint8_t*)meta+meta->data_offset;
     while(tail+sizeof(struct perf_event_header)<=head && samples+other_records<100000) {
       struct perf_event_header h;
       size_t offset=(size_t)(tail&(rs-1));
       if(offset+sizeof(h)<=rs)memcpy(&h,ring+offset,sizeof(h));
       else {uint8_t b[sizeof(h)];size_t first=(size_t)rs-offset;
         memcpy(b,ring+offset,first);memcpy(b+first,ring,sizeof(h)-first);memcpy(&h,b,sizeof(h));}
       if(h.size<sizeof(h) || h.size>rs || tail+h.size>head)break;
       if(h.type==PERF_RECORD_SAMPLE) {
         samples++;
         if(h.size>=sizeof(h)+sizeof(uint64_t)){
           uint64_t ip=0;size_t po=(size_t)((tail+sizeof(h))&(rs-1));
           if(po+8<=rs)memcpy(&ip,ring+po,8);
           else {uint8_t b[8];size_t first=(size_t)rs-po;memcpy(b,ring+po,first);
                 memcpy(b+first,ring,8-first);memcpy(&ip,b,8);}
           if(ip)valid_ip++;
           if(ip>=UINT64_C(0xffff000000000000))kernel_ip++;
         }
       }else other_records++;
       tail+=h.size;
     }
   }
   printf("perf_exact_sample_records=%d\nperf_exact_nonzero_ip_samples=%d\nperf_exact_kernel_ip_samples=%d\n",samples,valid_ip,kernel_ip);
   printf("perf_exact_other_records=%d\n",other_records);
   munmap(meta,ms);
 }
 close((int)fd);
 return 0;
}
static int run_case(int id) {
 switch(id){
 case 0: {
   struct utsname u;if(uname(&u)<0){report_error("uname");break;}
   printf("kernel_release=%s\nkernel_arch=%s\nuid=%ld\neuid=%ld\npr_get_seccomp=%d\n",
          u.release,u.machine,(long)getuid(),(long)geteuid(),prctl(PR_GET_SECCOMP,0,0,0,0));
   break;
 }
 case 1:read_path("selinux_context","/proc/self/attr/current",1);break;
 case 2:read_path("perf_event_paranoid","/proc/sys/kernel/perf_event_paranoid",1);break;
 case 3:read_path("kptr_restrict","/proc/sys/kernel/kptr_restrict",1);break;
 case 4:read_path("dmesg_restrict","/proc/sys/kernel/dmesg_restrict",1);break;
 case 5:read_path("selinux_enforce","/sys/fs/selinux/enforce",1);break;
 case 6:kallsyms();break;
 case 7:read_path("boot_id","/proc/sys/kernel/random/boot_id",0);break;
 case 8:proc_status();break;
 case 9:perf_open_try("perf_task_user",1,0,1,0);break;
 case 10:perf_open_try("perf_cpu_user",0,0,1,0);break;
 case 11:perf_open_try("perf_cpu_kernel_only",0,1,0,0);break;
 case 12:perf_open_try("perf_exact",0,1,0,1);break;
 default:return 2;
 }
 return 0;
}
static void run_isolated(int id) {
 printf("CASE_BEGIN=%02d:%s\n",id,names[id]);fflush(stdout);
 pid_t pid=fork();
 if(pid<0){report_error("fork");printf("CASE_END=%02d:fork_failed\n",id);return;}
 if(pid==0){setvbuf(stdout,NULL,_IONBF,0);int rc=run_case(id);_exit(rc);}
 int status=0,done=0,elapsed=0;
 for(;elapsed<CASE_TIMEOUT_MS;elapsed+=25){
   pid_t w=waitpid(pid,&status,WNOHANG);
   if(w==pid){done=1;break;}
   if(w<0){done=-1;break;}
   usleep(25000);
 }
 if(done==0){kill(pid,SIGKILL);waitpid(pid,&status,0);printf("CASE_TIMEOUT=%02d\n",id);}
 else if(done>0){
   if(WIFSIGNALED(status))printf("CASE_SIGNAL=%02d:%d\n",id,WTERMSIG(status));
   else if(WIFEXITED(status))printf("CASE_EXIT=%02d:%d\n",id,WEXITSTATUS(status));
 }
 else printf("CASE_WAIT_ERROR=%02d\n",id);
 printf("CASE_END=%02d:%s\n",id,names[id]);
}
int main(int argc,char **argv) {
 setvbuf(stdout,NULL,_IONBF,0);
 if(argc>1 && strcmp(argv[1],"--batch")!=0) {
   fprintf(stderr,"usage: %s --batch\n",argv[0]);return 2;
 }
 puts("TAS_KASLR_BATCH_V1_BEGIN");
 puts("scope=actual_process_context_preconditions_only"); /* UID/SELinux in cases 0/1 determine the running domain; supports both app and authorized ADB shell. */
 puts("kernel_exploit_triggered=false");
 puts("kernel_memory_written=false");
 puts("kernel_addresses_reported=false");
 printf("case_count=%d\n",TOTAL_CASES);
 for(int i=0;i<TOTAL_CASES;i++)run_isolated(i);
 puts("TAS_KASLR_BATCH_V1_END");
 return 0;
}
