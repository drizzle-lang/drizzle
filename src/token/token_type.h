// Define our TokenType values as an enum
enum TokenType {
    // Special tokens
    ILLEGAL,
    END_OF_FILE,

    // Identifiers / Literals
    IDENT,
    INTEGER,
    TYPE_DEC,

    // Operators
    ASSIGN,
    PLUS,

    // Delimiters
    COMMA,
    COLON,
    LPAREN,
    RPAREN,
    LBRACE,
    RBRACE,

    // Keywords
    FUNCTION,
    LET
};
