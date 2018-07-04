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
