/*
 * Simple sqf preprocessor, has some features not present in the base sqf preprocessor,
 * and lacks some features that are.
 * 
 * I am not at all proud of this code, it's kind of garbage, but it works.
 * 
 * You should probably not use this, I just wanted to add a few things that
 * just about no one really needs, but that I thought would be nice to have.
 */


#include <unordered_map>
#include <algorithm>

/* oh yeah baby we're including a cpp file */
#include "tokenizer.cpp"
#include "utils.cpp"


class Preprocessor {
private:
    struct Macro {
        vector<string> value;
        int            level; /* scope */

        Macro(vector<string> value, int level) {
            this->value = value;
            this->level = level;
        }
    };


    /* some of these are unimplemented */
    enum Directives {
        NONE,
        INVALID,
        DEFINE,
        IFDEF,
        IFNDEF,
        ELSE,
        ENDIF,
        EXPORT,
        IMPORT,
        OPTION
    };


    vector<string> tokens;
    unordered_map<string, Macro> macros;
    size_t         index = 0;
    int            scope_level = 0;
    string         path_dest;
    string         path_dir;


    string peek_prev(void) {
        if (index == 0)
            return "";

        return tokens[index - 1];
    }


    string peek(void) {
        if (index >= tokens.size())
            return "";

        return tokens[index];
    }


    string next(void) {
        if (index >= tokens.size())
            return "";

        return tokens[++index];
    }


    string join(vector<string> tokens, bool strip = false) {
        string result;
        
        for (string token : tokens)
            result += token;

        /* strip leading and trailing whitespace */
        if (strip) {
            size_t start = result.find_first_not_of(" \t\n");
            size_t end   = result.find_last_not_of(" \t\n");

            if (start == string::npos)
                return "";

            result = result.substr(start, end - start + 1);
        }

        return result;
    }


    vector<string> next_until(string end, bool skip_leading_whitespace = false) {
        string token;
        vector<string> tokens;

        while ((token = next()) != end) {
            CHECK_EOF(token);

            if (skip_leading_whitespace && token == " " && tokens.size() == 0)
                continue;

            tokens.push_back(token);
        }

        return tokens;
    }


    string back(void) {
        if (index == 0)
            return "";

        return tokens[--index];
    }

    string next_argument(void) {
        string token = next();
        CHECK_EOF(token);

        if (token == " ")
            return next_argument();

        return token;
    }


    bool is_defined(string name) {
        return macros.find(name) != macros.end();
    }


    void insert_macro(string name, vector<string> value) {
        macros.emplace(name, Macro(value, scope_level));
    }


    void clean_scope(int level) {
        for (auto it = macros.begin(); it != macros.end();) {
            if (it->second.level == level) {
                it = macros.erase(it);
            } else {
                ++it;
            }
        }
    }


    int get_directive(string directive) {
        if (directive == "define") return DEFINE;
        if (directive == "ifdef")  return IFDEF;
        if (directive == "ifndef") return IFNDEF;
        if (directive == "else")   return ELSE;
        if (directive == "endif")  return ENDIF;
        if (directive == "option") return OPTION;
        if (directive == "export") return EXPORT;
        if (directive == "import") return IMPORT;
        return INVALID;
    }


    void define(void) {
        string name = next_argument();
        vector<string> value = next_until("\n", true);

        if (is_defined(name))
            EXIT_WITH("Macro already defined: " + name);

        insert_macro(name, value);
    }


    size_t adjust_offset(int offset) {
        size_t i = index + offset;
        while (tokens[i] == " ") 
            ++i;

        return i - index;
    }


    string get_closer(string str) {
        if (str == "(") return ")";
        if (str == "[") return "]";
        if (str == "{") return "}";
        return "";
    }


    bool is_opener(string str) {
        if (str == "(") return true;
        if (str == "[") return true;
        if (str == "{") return true;
        return false;
    }


    vector<size_t> get_indices_with_offset(int offset) {
        string token = tokens[index];
        size_t initial = index;
        vector<size_t> indices = {initial, initial + 1};

        while (offset > 0) {
            token = next_argument();
            
            if (offset == 1)
                indices[0] = index;

            if (is_opener(token)) {
                back();
                token = join(next_until_match(token, get_closer(token), true));
            }

            --offset;
        }

        indices[1] = index;
        index = initial;

        return indices;
    }


    string get_with_offset(int offset) {
        vector<size_t> indices = get_indices_with_offset(offset);
        return join(vector<string>(tokens.begin() + indices[0], tokens.begin() + indices[1] + 1));
    }


    void erase_with_offset(int offset) {
        vector<size_t> indices = get_indices_with_offset(offset);
        tokens.erase(tokens.begin() + indices[0], tokens.begin() + indices[1] + 1);
    }


    bool is_identifier(string token) {
        if (!isalpha(token[0]) && token[0] != '_')
            return false;
        
        for (size_t i = 1; i < token.length(); ++i)
            if (!isalnum(token[i]) && token[i] != '_')
                return false;

        return true;
    }


    int parse_offset(string offset_str) {
        int offset = stoi(offset_str);

        if (offset < 0)
            EXIT_WITH("Invalid offset: " + to_string(offset));
        
        return offset;
    }


    vector<string> next_until_match(string left, string right, bool skip_leading_whitespace = false) {
        string token;
        vector<string> tokens;
        int level = 0;

        while ((token = next()) != "") {
            if (token == left)  ++level;
            if (token == right) --level;

            if (skip_leading_whitespace && token == " " && tokens.size() == 0)
                continue;

            tokens.push_back(token);

            if (level == 0 && token == right)
                break;
        }

        return tokens;
    }


    bool is_command(string token) {
        if (token == "debug") return true;
        if (token == "alias") return true;
        return false;
    }


    string expand(string name) {
        vector<string> expansion;
        vector<size_t> offsets;
        vector<size_t> queue;
        int            command_offset;

        /* this should be redundant, but sanity check anyway */
        if (!is_defined(name))
            EXIT_WITH("Macro not defined: " + name);

        Macro macro = macros.at(name);
        string prev_token; 

        for (size_t i = 0; i < macro.value.size(); ++i) {
            string token = macro.value[i];

            if (token == "$") {
                string offset_str = macro.value[++i];

                if (offset_str == "@") {
                    while (next() != "\n")
                        expansion.push_back(peek());

                    back();
                    continue;
                } else {
                    int offset = parse_offset(offset_str);

                    /* push offset if not present in vector */
                    if (find(offsets.begin(), offsets.end(), offset) == offsets.end())
                        offsets.push_back(offset);

                    token = get_with_offset(offset);
                }
            }

            if (is_defined(token)) {
                if (prev_token == "\\") {
                    expansion.pop_back();
                    expansion.push_back(token);
                } else {
                    expansion.push_back(expand(token));
                }
            } else if (token == "@") {
                string command = macro.value[++i];
                if (is_command(command)) {
                    /* we'll get back to this after the args have been expanded */
                    queue.push_back(expansion.size());
                    expansion.push_back(command); /* i cant recall why lol */
                }
            } else {
                expansion.push_back(token);
            }

            prev_token = token;
        }


        /* process queued commands */
        for (size_t i = 0; i < queue.size(); ++i) {
            string command = expansion[queue[i]];
            vector<size_t> indices;
            if (command == "debug") {
                size_t j = queue[i];

                if (!is_defined("DEBUG")) {
                    /* remove everything after @debug */
                    expansion.erase(expansion.begin() + j, expansion.end());
                } else {
                    /* remove @debug */
                    expansion.erase(expansion.begin() + j);
                }
            }

            if (command == "alias") {
                string arg1, arg2;
                string identifier;

                for (size_t j = queue[i] + 1; j < expansion.size(); ++j) {
                    indices.push_back(j);
                    
                    if (is_identifier(expansion[j])) {
                        identifier += expansion[j];
                    } else {
                        if (identifier == "")
                            continue;

                        if (arg1 == "") {
                            arg1 = identifier;
                            identifier = "";
                        } else {
                            arg2 = identifier;
                            identifier = "";
                            break;
                        }
                    }          
                }

                if (arg1 == "" || arg2 == "") {
                    if (identifier != "")
                        arg2 = identifier;
                    else
                        EXIT_WITH("Invalid alias command");
                }

                /* erase the arguments */
                for (size_t index : indices) {
                    expansion.erase(expansion.begin() + index);
                }

                /* then replace the command itself with the alias */
                expansion[queue[i]] = arg2;
                insert_macro(arg1, {arg2});
            }
        }

        /* erase tokens that were used in the expansion */
        for (size_t offset : offsets) {
            erase_with_offset(offset);
        }

        return join(expansion, true);
    }


    void directive(void) {
        string directive_string = next_argument();

        switch (get_directive(directive_string))
        {
        case DEFINE:
            define();
            break;

        case IMPORT: {
            string src = next_argument();

            while (next() != "\n")
                ;

            /* strip leading and trailing quotes */
            src = src.substr(1, src.length() - 2);
            
            /* tokenize the file */
            Tokenizer tokenizer;
            vector<string> imported_tokens = tokenizer.tokenize(path_join(path_dir, src));
            
            /* insert the tokens */
            tokens.insert(tokens.begin() + index, imported_tokens.begin(), imported_tokens.end());
            back();
            break;
        }

        case EXPORT: {
            string dest = next_argument();
            
            while (next() != "\n")
                ;

            /* strip leading and trailing quotes */
            dest = dest.substr(1, dest.length() - 2);
            path_dest = dest;
            break;
        }

        default:
            EXIT_WITH("Invalid directive: " + directive_string);
            break;
        }
    }


public:
    string preprocess(string filename, bool debug = false) {
        string result;
        Tokenizer tokenizer;        
        string token;

        tokens = tokenizer.tokenize(filename);
        path_dir = absolute_path(filename).substr(0, absolute_path(filename).find_last_of("/\\"));

        result += ( "///////////////////////////////////////////////"
                    "\n//THIS FILE WAS GENERATED BY THE PREPROCESSOR"
                    "\n//DO NOT EDIT THIS FILE DIRECTLY"
                    "\n///////////////////////////////////////////////"
                    "\n\n");

        if (debug) {
            insert_macro("DEBUG", {""});
        }

        while ((token = peek()) != "") {
            if (token == "{") ++scope_level;
            if (token == "}") {
                clean_scope(scope_level);
                --scope_level;
            }

            if (is_defined(token)) {
                token = expand(token);
            }
            
            if (token == "/" && peek_prev() == "/") {
                result = result.substr(0, result.length() - 2);
                while (next() != "\n")
                    ;
                
                continue;
            }

            if (token == "[") {
                if (is_identifier(peek_prev()) || peek_prev() == "]") {
                    result += " select ";
                    vector<string> args = next_until("]", true);

                    for (string arg : args) {
                        if (is_defined(arg)) {
                            arg = expand(arg);
                        }
                        result += arg;
                    }

                    next();
                    continue;
                }
            }


            if (token == "#") directive();
            else result += token;

            next();
        }

        return result;
    }


    string dest(void) {
        if (path_dest == "")
            EXIT_WITH("No export path specified");

        return path_join(path_dir, path_dest);
    }
};


int main(int argc, char** argv) {
    bool debug = false;
    vector<string> filenames;
    
    for (int i = 1; i < argc; ++i) {
        string arg = argv[i];

        if (arg == "-d" || arg == "--debug") {
            debug = true;
        } else {
            filenames.push_back(arg);
        }
    }

    if (filenames.size() == 0)
        EXIT_WITH("No input files specified");

    for (string filename : filenames) {
        Preprocessor preprocessor;
        string code = preprocessor.preprocess(filename, debug);
        write_file(preprocessor.dest(), code);
    }

    return 0;
}
