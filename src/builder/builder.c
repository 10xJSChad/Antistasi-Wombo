/*
 * Simple addon builder, builds only addons that have been modified since the
 * last build of the addon.
 *
 * Loonix only, windoze get out!!!!!!
 */


#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>
#include <linux/limits.h>
#include <libgen.h>
#include <fcntl.h>


#define EXIT_WITH(...) \
    do { \
        printf(__VA_ARGS__); \
        printf("\n"); \
        exit(EXIT_FAILURE); \
    } while (0)


char* wine_path       = NULL;
char* a3_addonbuilder = NULL;


int str_eq(char* a, char* b) {
    return strcmp(a, b) == 0;
}


char* str_join(char* a, char* b) {
    char buf[PATH_MAX] = {0};
    sprintf(buf, "%s%s", a, b);

    return strdup(buf);
}


char* path_join(char* a, char* b) {
    char buf[PATH_MAX] = {0};
    sprintf(buf, "%s/%s", a, b);

    return strdup(buf);
}


char* read_file(char* path) {
    FILE*  fp   = fopen(path, "r");
    size_t size = 0;
    char* buf;

    if (fp == NULL)
        EXIT_WITH("Failed to open file: %s", path);

    fseek(fp, 0, SEEK_END);
    size = ftell(fp);
    rewind(fp);

    buf = malloc(size + 1);
    if (fread(buf, 1, size, fp) != size)
        EXIT_WITH("Failed to read file: %s", path);

    buf[size] = '\0';

    fclose(fp);
    return buf;
}


char* get_prefix(char* addon_path) {
    DIR* dir = opendir(addon_path);
    struct dirent* entry;

    if (dir == NULL)
        EXIT_WITH("Failed to open directory: %s", addon_path);


    while (entry = readdir(dir)) {
        if (str_eq(entry->d_name, "$PBOPREFIX$")) {
            closedir(dir);
            return(read_file(path_join(addon_path, entry->d_name)));
        }
    }

    closedir(dir);
    return NULL;
}


int is_dot_or_dotdot(char* name) {
    return str_eq(name, ".") || str_eq(name, "..");
}


long get_timestamp(char* path) {
    struct stat statbuf;
    stat(path, &statbuf);
    return statbuf.st_mtime;
}


long get_addon_last_modified(char* path, long* timestamp) {
    DIR* dir = opendir(path);
    struct dirent* entry;

    if (timestamp == NULL) {
        timestamp = malloc(sizeof(long));
        *timestamp = 0;
    }

    if (dir == NULL)
        EXIT_WITH("Failed to open directory: %s", path);

    while (entry = readdir(dir)) {
        if (is_dot_or_dotdot(entry->d_name))
            continue;

        switch (entry->d_type) {
            case DT_DIR:
                get_addon_last_modified(path_join(path, entry->d_name), timestamp);
                break;

            case DT_REG:
                char* file_path = path_join(path, entry->d_name);
                long  file_timestamp = get_timestamp(file_path);

                if (file_timestamp > *timestamp)
                    *timestamp = file_timestamp;

                free(file_path);
                break;

            default:
                break;
        }
    }

    closedir(dir);
    return *timestamp;
}


void run_addonbuilder(char* addon_path, char* build_path, char* prefix) {
    char* addonbuilder_args[] = {
        wine_path,
        a3_addonbuilder,
        addon_path,
        build_path,
        "-packonly",
        str_join("-prefix=", prefix),
        NULL
    };

    if (fork() == 0) {
        int dev_null = open("/dev/null", O_WRONLY);

        if (dev_null == -1)
            EXIT_WITH("Failed to open /dev/null");

        dup2(dev_null, STDOUT_FILENO);
        dup2(dev_null, STDERR_FILENO);

        close(dev_null);
        execvp(addonbuilder_args[0], addonbuilder_args);
    }
}


void build_addon(char* addon_path, char* build_path, char* prefix) {;
    char* addon_pbo = path_join(build_path, str_join(basename(addon_path), ".pbo"));
    long  addon_modified_timestamp = get_addon_last_modified(addon_path, NULL);

    if (access(addon_pbo, F_OK) == -1 || addon_modified_timestamp > get_timestamp(addon_pbo)) {
        printf("Building addon: %s\n", basename(addon_path));
        run_addonbuilder(addon_path, build_path, prefix);
    }
}


int is_addon(char* path) {
    return access(path_join(path, "$PBOPREFIX$"), F_OK) != -1;
}


void build_all_addons(char* path, char* build_path) {
    DIR* dir = opendir(path);
    struct dirent* entry;

    if (dir == NULL)
        EXIT_WITH("Failed to open directory: %s", path);

    while (entry = readdir(dir)) {
        if (is_dot_or_dotdot(entry->d_name))
            continue;

        if (entry->d_type == DT_DIR && is_addon(path_join(path, entry->d_name))) {
            char* addon_path = path_join(path, entry->d_name);
            char* prefix = get_prefix(addon_path);

            build_addon(addon_path, build_path, prefix);

            free(addon_path);
            free(prefix);
        }
    }

    closedir(dir);
}

char* read_line(char* str) {
    char buf[PATH_MAX] = {0};
    size_t i = 0;

    while (*str && *str != '\n') {
        buf[i++] = *(str++);
    }

    return strdup(buf);
}


void read_config(void) {
    char* config_dir = getenv("XDG_CONFIG_HOME");
    char* config_file;
    char* config_content;

    if (config_dir == NULL)
        config_dir = path_join(getenv("HOME"), ".config");

    config_file = path_join(config_dir, "a3builder");

    if (access(config_file, F_OK) == -1) {
        printf("Config file not found: %s\n", config_file);
        printf("Create it and add the following content:\n");
        printf("wine=<path to wine>\n");
        printf("addonbuilder=<path to AddonBuilder.exe>\n");
        printf("\nDo not put the paths in quotes.\n");
        printf("Good luck, if you get it wrong, you're on your own.\n");
        exit(1);
    }

    config_content = read_file(config_file);

    wine_path       = read_line(strstr(config_content, "wine=") + strlen("wine="));
    a3_addonbuilder = read_line(strstr(config_content, "addonbuilder=") + strlen("addonbuilder="));
}


int main(int argc, char** argv) {
    if (argc != 3)
        EXIT_WITH("Usage: %s <addons_path> <build_path>", argv[0]);

    char* addons_path = argv[1];
    char* build_path  = argv[2];
    read_config();

    build_all_addons(addons_path, build_path);
    return 0;
}
