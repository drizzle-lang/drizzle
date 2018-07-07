#include<iostream>
#include<string>
#include "../src/lexer/lexer.h"
using namespace std;

int testNextToken() {
    // Test the getNextToken method of the lexer class
    cout << "ensure lexer.getNextToken returns the correct sequence of tokens for a given input" << endl;
    string input = "=+(){},:";
    cout << "input: '" << input << "'" << endl;

    // Build an array of expected tokens
    Token expectedTokens[] = {
        Token(TokenType::ASSIGN, "="),
        Token(TokenType::PLUS, "+"),
        Token(TokenType::LPAREN, "("),
        Token(TokenType::RPAREN, ")"),
        Token(TokenType::LBRACE, "{"),
        Token(TokenType::RBRACE, "}"),
        Token(TokenType::COMMA, ","),
        Token(TokenType::COLON, ":"),
        Token(TokenType::END_OF_FILE, ""),
    };

    // Create a lexer based on the input
    Lexer lexer(input);

    // Loop through the expected tokens and ensure that the returned token from the lexer matches
    int length = sizeof(expectedTokens) / sizeof(Token);
    for(int i = 0; i < length; i++) {
        // Get the next token from the lexer and check that the expected and received tokens match
        Token lexerToken = lexer.getNextToken();
        Token expectedToken = expectedTokens[i];
        if (lexerToken != expectedToken) {
            cout << "Token from lexer did not match expected token!" << endl;
            cout << "expected Token(" << expectedToken.getType() << ", " << expectedToken.getLiteral() << ")" << endl;
            cout << "received Token(" << lexerToken.getType() << ", " << lexerToken.getLiteral() << ")" << endl;
            return 1;
        }
    }
    cout << "OK" << endl;
    return 0;
}
