#include<string>
#include "token.h"
using namespace std;

// Actually give the token types a definition in this file
namespace TokenType  {
    // Special tokens
    tokenType ILLEGAL     = "ILLEGAL";
    tokenType END_OF_FILE = "EOF";

    // Identifiers / Literals
    tokenType IDENT    = "IDENT";
    tokenType INTEGER  = "INTEGER";
    tokenType TYPE_DEC = "TYPE_DEC";

    // Operators
    tokenType ASSIGN = "=";
    tokenType PLUS   = "+";

    // Delimiters
    tokenType COMMA  = ",";
    tokenType COLON  = ":";
    tokenType LPAREN = "(";
    tokenType RPAREN = ")";
    tokenType LBRACE = "{";
    tokenType RBRACE = "}";

    // Keywords
    tokenType FUNCTION = "FUNCTION";
    tokenType LET      = "LET";
}

Token::Token(tokenType type, string literal) {
    this->type = type;
    this->literal = literal;
}

string Token::getType()  {
    return this->type;
}

string Token::getLiteral() {
    return this->literal;
}

bool Token::operator==(const Token& other) {
    return (this->type == other.type && this->literal == other.literal);
}

bool Token::operator==(const tokenType type) {
    // Shorthand stuff to check if the token is a given type using the == operator
    return (this->type == type);
}

bool Token::operator!=(const Token& other) {
    // Because !(this == other) didn't work >.>
    return !(this->type == other.type && this->literal == other.literal);
}

bool Token::operator!=(const tokenType type) {
    return !(this->type == type);
}
