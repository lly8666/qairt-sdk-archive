/* TAS / EMUI 11 read-only target compatibility probe.
 * Does not use futex, ptrace, perf_event_open, kernel writes or root.
 * License: MIT. Android NDK API 29+, aarch64. Output: key=value lines.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/utsname.h>
#ifdef __ANDROID__
#include <sys/system_properties.h>
#else
static int __system_property_get(const char *key, char *value) {
  (void)key; value[0] = 0; return 0;
}
#endif
static void safe_print(const char *key, const char *value) {
  char buff[512]; size_t i, end = 0;
  for (i = 0; value && value[i] && end < sizeof(buff)-1; ++i) {
    unsigned char c = (unsigned char)value[i];
    buff[end++] = (c >= 32 && c <= 126 && c != '=') ? (char)c : '_';
  }
  buff[end] = '\0';
  printf("%s=%s\n", key, buff);
}
static void prop(const char *key) {
  char value[512];
  value[0] = '\0';
  __system_property_get(key, value);
  safe_print(key, value);
}
static void first_line(const char *key, const char *path) {
  FILE *f = fopen(path, "r");
  if (!f) { safe_print(key, "UNREADABLE"); return; }
  char value[1024];
  if (!fgets(value, sizeof(value), f)) value[0] = '\0';
  fclose(f);
  value[strcspn(value, "\r\n")] = '\0';
  safe_print(key, value);
}
static void selinux(void) {
  FILE *f = fopen("/sys/fs/selinux/enforce", "r");
  if (!f) { safe_print("selinux_enforcing", "UNREADABLE"); return; }
  char c = '?';
  if (fread(&c, 1, 1, f) != 1) c = '?';
  fclose(f);
  safe_print("selinux_enforcing", c == '1' ? "yes" : c == '0' ? "no" : "unknown");
}
int main(int argc, char **argv) {
  if (argc != 1) {
    fprintf(stderr,"usage: %s   (read-only; redirect output to a text file)\n", argv[0]);
    return 2;
  }
  struct utsname u;
  if (uname(&u)) { perror("uname"); return 1; }
  safe_print("uname_sysname", u.sysname);
  safe_print("uname_release", u.release);
  safe_print("uname_version", u.version);
  safe_print("uname_machine", u.machine);
  first_line("proc_version", "/proc/version");
  prop("ro.product.model");
  prop("ro.product.device");
  prop("ro.product.board");
  prop("ro.build.version.emui");
  prop("ro.build.version.release");
  prop("ro.build.version.sdk");
  prop("ro.build.display.id");
  prop("ro.build.version.incremental");
  prop("ro.boot.verifiedbootstate");
  prop("ro.boot.vbmeta.device_state");
  selinux();
  puts("probe_behavior=read_only_no_root_no_exploit");
  return 0;
}
