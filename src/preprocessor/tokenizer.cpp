#include <cstdio>
#include <iostream>
#include <string>
#include <vector>


#define CHECK_EOF(_str) do { \
    if (_str == "") { cout << "Unexpected EOF" << endl; exit(1); } \
    } while (0)


#define EXIT_WITH(_msg) { cout << _msg << endl; exit(1); }
using namespace std;


class Tokenizer {
private:
    char ch;
    FILE* fp;


    char next(void) {
        ch = fgetc(fp);
        return ch == EOF ? 0 : ch;
    }


    string parse_identifier(void) {
        string token;

        token += ch;
        while (next()) {
            if (isalnum(ch) || ch == '_') {
                token += ch;
            } else {
                break;
            }
        }

        return token;
    }


    string parse_string(void) {
        string token;
        char   quote = ch;

        token += ch;
        while (next()) {
            token += ch;

            if (ch == quote) {
                next();
                break;
            }
        }

        return token;
    }


    string parse_number(void) {
        string token;
        bool   is_float = false;
        
        token += ch;
        while (next()) {
            if (isdigit(ch) || ch == '.') {
                token += ch;

                if (ch == '.') {
                    if (token == "-") continue;
                    if (is_float)     break;
                    is_float = true;
                }
            } else {
                break;
            }
        }

        return token;
    }


public:
    vector<string> tokenize(string filename) {
        vector<string> tokens;
        fp = fopen(filename.c_str(), "r");

        if (fp == NULL)
            EXIT_WITH("Failed to open file: " + string(filename));

        while (next()) {
top:;
            if (isalpha(ch) || ch == '_') {
                tokens.push_back(parse_identifier());
            } else if (isdigit(ch) || ch == '-') {
                tokens.push_back(parse_number());
            } else if (ch == '\'' || ch == '"') {
                tokens.push_back(parse_string());
            } else if (ch == '\\') {
                next();

                if (ch != '\n') {
                    tokens.push_back("\\");
                    goto top;
                } else {
                    continue;
                }
            }
            
            tokens.push_back(string(1, ch));
        }

        fclose(fp);
        return tokens;
    }
};
