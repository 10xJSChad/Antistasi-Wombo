#include <string>
#include <cstdio>
#include <filesystem>
using namespace std;


string read_file(string filename) {
    FILE *fp = fopen(filename.c_str(), "r");
    string content;

    if (fp == NULL) {
        cout << "Failed to open file: " << filename << endl;
        exit(1);
    }

    char buf[BUFSIZ];
    size_t nread;
    
    while ((nread = fread(buf, 1, BUFSIZ, fp)) != 0) {
        content += buf;
    }

    fclose(fp);
    return content;
}


void write_file(string filename, string data) {
    FILE* fp = fopen(filename.c_str(), "w");

    if (fp == NULL) {
        cout << "Failed to open file: " << filename << endl;
        exit(1);
    }

    fwrite(data.c_str(), 1, data.length(), fp);
    fclose(fp);
}


string absolute_path(string path) {
    filesystem::path filepath = path;
    filepath = filesystem::absolute(filepath);
    return filepath.string();
}


string path_join(string path1, string path2) {
    return path1 + "/" + path2;
}