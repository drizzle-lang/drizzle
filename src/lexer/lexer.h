#include<string>
#include "../token/token.h"
using namespace std;

/*
 * The Lexer is responsible for going through a given file and converting the
 * plain text source into a sequence of Token instances.
 * These Tokens will then be passed into a Parser which will be used to build
 * an Abstract Syntax Tree from the source code.
 */
class Lexer {
public:
    Lexer(string input);
    Token getNextToken();
    // Getters and setters
    string getInput();
    int getPosition();
    int getReadPosition();
    char getCurrentCharacter();

private:
    string input;
    int inputSize;
    int position;
    int readPosition;
    char currentCharacter;
    // Helpers
    void readNextCharacter();
    char peekCharacter();
    string readIdentifier();
    string readNumber();
    void skipWhitespace();
};
