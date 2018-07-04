// Define our TokenType values as an enum
#include<string>
using namespace std;

typedef string tokenType;

namespace TokenType {
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
