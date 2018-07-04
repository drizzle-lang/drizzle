#include<iostream>
#include<string>
#include "token_type.h"
using namespace std;

class Token {
public:
    Token(tokenType type, string literal) {
        this->type = type;
        this->literal = literal;
    }

    tokenType getType() {
        return this->type;
    }

    string getLiteral() {
        return this->literal;
    }
private:
    tokenType type;
    string literal;
    // Set up for production style tokens with error info
    string filename;
    long lineNum;
    long charNum;
};
