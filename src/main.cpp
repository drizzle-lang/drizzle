#include<iostream>
#include<string>
#include "lexer/lexer.h"
using namespace std;

int main() {
    // Create 2 tokens and check that they are equal
    Token token1(TokenType::IDENT, "x");
    Token token2(TokenType::IDENT, "x");
    cout << "Are tokens equal? (true == 1): " << (token1 == token2) << endl;
    cout << "Does token1 == TokenType::IDENT: " << (token1 == TokenType::IDENT) << endl;
}
