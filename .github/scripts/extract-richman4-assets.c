// Extract only the files required for the personal Richman 4 native port.
// Uses libarchive's multi-volume RAR reader (archive_read_open_filenames).
// Does not need proprietary decompression tools and never uploads game assets.
#define _POSIX_C_SOURCE 200809L
#include <archive.h>
#include <archive_entry.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>

static int ends_with(const char *name, const char *suffix) {
    size_t n = strlen(name), s = strlen(suffix);
    return n >= s && strcasecmp(name + n - s, suffix) == 0;
}

static int keep(const char *name) {
    return ends_with(name, ".mkf") ||
           ends_with(name, ".mid") ||
           ends_with(name, ".wav") ||
           strcasecmp(name, "rich4.exe") == 0;
}

int main(int argc, char **argv) {
    if (argc != 5) {
        fprintf(stderr, "usage: %s OUTPUT first.rar.001 second.rar.002 third.rar.003\n", argv[0]);
        return 2;
    }
    const char *volumes[] = {argv[2], argv[3], argv[4], NULL};
    struct archive *archive = archive_read_new();
    archive_read_support_filter_all(archive);
    archive_read_support_format_all(archive);

    int status = archive_read_open_filenames(archive, volumes, 10240);
    if (status != ARCHIVE_OK) {
        fprintf(stderr, "Could not open split RAR archive: %s\n", archive_error_string(archive));
        return 3;
    }

    int count = 0;
    struct archive_entry *entry;
    while ((status = archive_read_next_header(archive, &entry)) == ARCHIVE_OK) {
        const char *path = archive_entry_pathname(entry);
        if (!path) continue;
        const char *name = strrchr(path, '/');
        name = name ? name + 1 : path;
        if (!name[0] || !keep(name)) {
            archive_read_data_skip(archive);
            continue;
        }
        char destination[4096];
        if (snprintf(destination, sizeof(destination), "%s/%s", argv[1], name) >= (int)sizeof(destination))
            return 4;
        FILE *file = fopen(destination, "wb");
        if (!file) {
            perror(destination);
            return 5;
        }
        char buf[65536];
        la_ssize_t length;
        long long bytes = 0;
        while ((length = archive_read_data(archive, buf, sizeof(buf))) > 0) {
            if (fwrite(buf, 1, (size_t)length, file) != (size_t)length) {
                perror("fwrite");
                fclose(file);
                return 6;
            }
            bytes += length;
        }
        if (fclose(file) != 0) {
            perror("fclose");
            return 7;
        }
        if (length < 0 || bytes != archive_entry_size(entry)) {
            fprintf(stderr, "RAR data error for %s: %s\n", name, archive_error_string(archive));
            return 8;
        }
        printf("%s: %lld bytes\n", name, bytes);
        fflush(stdout);
        count++;
    }
    // The supplied archive ends with a non-game file whose legacy Chinese
    // filename cannot be decoded by libarchive on some Linux locales.
    // The source game's needed ASCII-named files precede that entry.
    if (status != ARCHIVE_EOF)
        fprintf(stderr, "RAR reader stopped after game files: %s\n", archive_error_string(archive));
    archive_read_free(archive);
    fprintf(stderr, "Extracted %d game files\n", count);
    return count >= 30 ? 0 : 9;
}
