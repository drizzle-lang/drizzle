#include<string>
#include<unordered_map>
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
    tokenType TYPE     = "TYPE";

    // Operators
    tokenType ASSIGN      = "=";
    tokenType EQ          = "==";
    tokenType PLUS        = "+";
    tokenType MINUS       = "-";
    tokenType RETURN_TYPE = "->";
    tokenType BANG        = "!";
    tokenType NOT_EQ      = "!=";
    tokenType ASTERISK    = "*";
    tokenType SLASH       = "/";
    tokenType LT          = "<";
    tokenType LE          = "<=";
    tokenType GT          = ">";
    tokenType GE          = ">=";

    // Delimiters
    tokenType COMMA      = ",";
    tokenType COLON      = ":";
    tokenType SEMI_COLON = ";";
    tokenType LPAREN     = "(";
    tokenType RPAREN     = ")";
    tokenType LBRACE     = "{";
    tokenType RBRACE     = "}";

    // Keywords
    tokenType FUNCTION = "FUNCTION";
    tokenType LET      = "LET";
    tokenType RETURN   = "RETURN";
}

unordered_map<string, tokenType> keywords = {
    {"def", TokenType::FUNCTION},
    {"let", TokenType::LET},
    {"return", TokenType::RETURN},
    // Type definitions (temp solution until I figure out the best way to do this)
    {"int", TokenType::TYPE},
    {"num", TokenType::TYPE},
};

Token::Token(tokenType type, string literal) {
    this->type = type;
    this->literal = literal;
    // Replace these with params later
    this->filename = "<stdin>";
    this->lineNum = -1;
    this->charNum = -1;
}

string Token::getType()  {
    return this->type;
}

string Token::getLiteral() {
    return this->literal;
}

string Token::getFilename() {
    return this->filename;
}

int Token::getLineNum() {
    return this->lineNum;
}

int Token::getCharNum() {
    return this->charNum;
}

string Token::toString() {
    return "Token(" + this->type + ", " + this->literal + ")";
}

bool Token::operator==(const Token other) {
    return (this->type == other.type && this->literal == other.literal);
}

bool Token::operator==(const tokenType type) {
    // Shorthand stuff to check if the token is a given type using the == operator
    return (this->type == type);
}

bool Token::operator!=(const Token other) {
    // Because !(this == other) didn't work >.>
    return !(this->type == other.type && this->literal == other.literal);
}

bool Token::operator!=(const tokenType type) {
    return !(this->type == type);
}
