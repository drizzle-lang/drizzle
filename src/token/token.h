#include<string>
using namespace std;

// Stuff for TokenTypes
typedef string tokenType;

namespace TokenType  {
    // Special tokens
    extern tokenType ILLEGAL;
    extern tokenType END_OF_FILE;

    // Identifiers / Literals
    extern tokenType IDENT;
    extern tokenType INTEGER;
    extern tokenType TYPE_DEC;

    // Operators
    extern tokenType ASSIGN;
    extern tokenType PLUS;

    // Delimiters
    extern tokenType COMMA;
    extern tokenType COLON;
    extern tokenType LPAREN;
    extern tokenType RPAREN;
    extern tokenType LBRACE;
    extern tokenType RBRACE;

    // Keywords
    extern tokenType FUNCTION;
    extern tokenType LET;
}

// Token class
class Token {
public:
    Token(tokenType type, string literal);

    tokenType getType();

    string getLiteral();
private:
    tokenType type;
    string literal;
    // Set up for production style tokens with error info
    string filename;
    long lineNum;
    long charNum;
};
