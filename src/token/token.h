#include<string>
#include<unordered_map>
using namespace std;

// Stuff for TokenTypes
typedef string tokenType;

/*
 * The TokenType namespace simply defines a set of variables that can be used to
 * define a type of token that is read by the parser.
 * These are accessed like `TokenType::ILLEGAL`, or likewise.
 */
namespace TokenType  {
    // Special tokens
    extern tokenType ILLEGAL;
    extern tokenType END_OF_FILE;

    // Identifiers / Literals
    extern tokenType IDENT;
    extern tokenType INTEGER;
    extern tokenType TYPE;

    // Operators
    extern tokenType ASSIGN;
    extern tokenType EQ;
    extern tokenType PLUS;
    extern tokenType MINUS;
    extern tokenType RETURN_TYPE;
    extern tokenType BANG;
    extern tokenType NOT_EQ;
    extern tokenType ASTERISK;
    extern tokenType SLASH;
    extern tokenType LT;
    extern tokenType LE;
    extern tokenType GT;
    extern tokenType GE;

    // Delimiters
    extern tokenType COMMA;
    extern tokenType COLON;
    extern tokenType SEMI_COLON;
    extern tokenType LPAREN;
    extern tokenType RPAREN;
    extern tokenType LBRACE;
    extern tokenType RBRACE;

    // Keywords
    extern tokenType FUNCTION;
    extern tokenType LET;
    extern tokenType RETURN;
}

extern unordered_map<string, tokenType> keywords;

/*
 * The Token class represents a Sapphire token generated from the source by the Lexer.
 * Tokens are used by the Parser to build an Abstract Syntaxs Tree, which can then be used
 * to interpret the program and run it.
 */
class Token {
public:
    Token(tokenType type, string literal);
    tokenType getType();
    string getLiteral();
    string getFilename();
    int getLineNum();
    int getCharNum();
    string toString();
    bool operator==(const Token other);
    bool operator==(const tokenType type);
    bool operator!=(const Token other);
    bool operator!=(const tokenType type);

private:
    tokenType type;
    string literal;
    // Set up for production style tokens with error info
    string filename;
    long lineNum;
    long charNum;
};
