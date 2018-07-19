#include<iostream>
#include<string>
#include "lexer/lexer.h"
using namespace std;

string PROMPT = "sapphire >> ";

int main() {
    // Create a REPL environment that tokenizes user input and just prints out the the tokens
    bool loop = true;
    string line;
    do {
        cout << PROMPT;
        getline(cin, line);
        if (line == "") {
            loop = false;
        }
        else {
            Lexer *lexer = new Lexer(line);
            Token *token;
            while ((token = &lexer->getNextToken()) != TokenType::END_OF_FILE) {
                cout << token->toString() << endl;
            }
        }
    }
    while (loop);
    return 0;
}
