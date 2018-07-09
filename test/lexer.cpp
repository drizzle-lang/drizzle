#include<iostream>
#include<fstream>
#include<string>
#include "../src/lexer/lexer.h"
using namespace std;

int testNextToken() {
    // Test the getNextToken method of the lexer class
    cout << "ensure lexer.getNextToken returns the correct sequence of tokens for `examples/example1.sph`" << endl;
    ifstream file("examples/example1.sph");
    // TODO - Just pass the file directly as input to the lexer
    string input((istreambuf_iterator<char>(file)), (istreambuf_iterator<char>()));
    cout << input << endl;

    // Build an array of expected tokens
    Token expectedTokens[] = {
        // let five: int = 5;
        Token(TokenType::LET, "let"),
        Token(TokenType::IDENT, "five"),
        Token(TokenType::COLON, ":"),
        Token(TokenType::TYPE, "int"),
        Token(TokenType::ASSIGN, "="),
        Token(TokenType::INTEGER, "5"),
        Token(TokenType::SEMI_COLON, ";"),

        // let ten: int = 10;
        Token(TokenType::LET, "let"),
        Token(TokenType::IDENT, "ten"),
        Token(TokenType::COLON, ":"),
        Token(TokenType::TYPE, "int"),
        Token(TokenType::ASSIGN, "="),
        Token(TokenType::INTEGER, "10"),
        Token(TokenType::SEMI_COLON, ";"),

        // def add(x: num, y: num) -> num {
        Token(TokenType::DEFINE, "def"),
        Token(TokenType::IDENT, "add"),
        Token(TokenType::LPAREN, "("),
        Token(TokenType::IDENT, "x"),
        Token(TokenType::COLON, ":"),
        Token(TokenType::TYPE, "num"),
        Token(TokenType::COMMA, ","),
        Token(TokenType::IDENT, "y"),
        Token(TokenType::COLON, ":"),
        Token(TokenType::TYPE, "num"),
        Token(TokenType::RPAREN, ")"),
        Token(TokenType::RETURN_TYPE, "->"),
        Token(TokenType::TYPE, "num"),
        Token(TokenType::LBRACE, "{"),

        //     return x + y;
        Token(TokenType::RETURN, "return"),
        Token(TokenType::IDENT, "x"),
        Token(TokenType::PLUS, "+"),
        Token(TokenType::IDENT, "y"),
        Token(TokenType::SEMI_COLON, ";"),

        // }
        Token(TokenType::RBRACE, "}"),

        // let result: num = add(five, ten);
        Token(TokenType::LET, "let"),
        Token(TokenType::IDENT, "result"),
        Token(TokenType::COLON, ":"),
        Token(TokenType::TYPE, "num"),
        Token(TokenType::ASSIGN, "="),
        Token(TokenType::IDENT, "add"),
        Token(TokenType::LPAREN, "("),
        Token(TokenType::IDENT, "five"),
        Token(TokenType::COMMA, ","),
        Token(TokenType::IDENT, "ten"),
        Token(TokenType::RPAREN, ")"),
        Token(TokenType::SEMI_COLON, ";"),
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
