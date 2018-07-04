#include<string>
#include "../token/token.h"
using namespace std;

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
};
