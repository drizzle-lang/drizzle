#include<iostream>
#include<string>
#include "../src/token/token.cpp"
using namespace std;

void testNextToken() {
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
        Token(TokenType::END_OF_FILE, "")
    };

    // Create a lexer based on the input
    // Lexer lexer(input);

    // Loop through the expected tokens and ensure that the returned token from the lexer matches
    int length = sizeof(expectedTokens) / sizeof(Token);
    for(int i = 0; i < length; i++) {
        // For now just print out the tokens in the expected list
        Token testToken = expectedTokens[i];
        cout << "Token(" << testToken.getType() << ", " << testToken.getLiteral() << ")" << endl;
    }
}
