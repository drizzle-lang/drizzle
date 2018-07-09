#include<iostream>
#include<string>
#include "lexer.h"
using namespace std;

// Helpers that aren't class related
bool isLetter(char character) {
    return ('a' <= character && character <= 'z') || ('A' <= character && character <= 'Z') || (character == '_');
}

bool isDigit(char character) {
    return '0' <= character && character <= '9';
}

// Lexer stuff
Lexer::Lexer(string input) {
    this->input = input;
    this->position = 0;
    this->readPosition = 0;
    // Call the read next char method to set up all the pointers
    this->readNextCharacter();
}

Token Lexer::getNextToken() {
    // Parse the current character of the input and create the corresponding token for it
    tokenType type;
    string value;
    // Skip whitespace characters
    this->skipWhitespace();
    switch (this->currentCharacter) {
        case '=':
            type = TokenType::ASSIGN;
            value = "=";
            break;
        case ':':
            type = TokenType::COLON;
            value = ":";
            break;
        case ';':
            type = TokenType::SEMI_COLON;
            value = ";";
            break;
        case '(':
            type = TokenType::LPAREN;
            value = "(";
            break;
        case ')':
            type = TokenType::RPAREN;
            value = ")";
            break;
        case ',':
            type = TokenType::COMMA;
            value = ",";
            break;
        case '+':
            type = TokenType::PLUS;
            value = "+";
            break;
        case '{':
            type = TokenType::LBRACE;
            value = "{";
            break;
        case '}':
            type = TokenType::RBRACE;
            value = "}";
            break;
        case '\0':
            type = TokenType::END_OF_FILE;
            value = "";
            break;
        default:
            // Check if the token is an identifier and if not return illegal
            if (isLetter(this->currentCharacter)) {
                value = this->readIdentifier();
                if (keywords.count(value) == 1) {
                    type = keywords[value];
                }
                else {
                    type = TokenType::IDENT;
                }
                // Early return here to avoid reading the next character
                Token token(type, value);
                return token;
            }
            else if (isDigit(this->currentCharacter)) {
                type = TokenType::INTEGER; // TODO - Handle floats
                value = this->readNumber();
                Token token(type, value);
                return token;
            }
            else {
                type = TokenType::ILLEGAL;
                value = "";
            }
            break;
    }
    Token token(type, value);
    this->readNextCharacter();
    return token;
}

// Getters and Setters
string Lexer::getInput() {
    return this->input;
}

int Lexer::getPosition() {
    return this->position;
}

int Lexer::getReadPosition() {
    return this->readPosition;
}

char Lexer::getCurrentCharacter() {
    return this->currentCharacter;
}

// Private helper methods
void Lexer::readNextCharacter() {
    // The way this method works, it currently does not support unicode input, only ascii
    // TODO - Expand this to be able to handle Unicode
    if (this->readPosition >= this->input.length()) {
        this->currentCharacter = '\0';
    }
    else {
        this->currentCharacter = this->input[this->readPosition];
    }
    this->position = this->readPosition;
    this->readPosition++;
}

string Lexer::readIdentifier() {
    int pos = this->position;
    while(isLetter(this->currentCharacter)) {
        this->readNextCharacter();
    }
    // Get the slice from pos to this->position and that's the ident name
    int length = this->position - pos;
    return this->input.substr(pos, length);
}

string Lexer::readNumber() {
    int pos = this->position;
    while(isDigit(this->currentCharacter)) {
        this->readNextCharacter();
    }
    // Get the slice from pos to this->position and that's the number
    int length = this->position - pos;
    return this->input.substr(pos, length);
}

void Lexer::skipWhitespace() {
    while (this->currentCharacter == ' ' ||
           this->currentCharacter == '\t' ||
           this->currentCharacter == '\n' ||
           this->currentCharacter == '\r') {
        this->readNextCharacter();
    }
}
