#include<iostream>
#include<string>
#include "token_type.h"
using namespace std;

class Token {
public:
    Token(TokenType type, string literal) {
        this->type = type;
        this->literal = literal;
    }

    TokenType getType() {
        return this->type;
    }

    string getLiteral() {
        return this->literal;
    }
private:
    TokenType type;
    string literal;
};
