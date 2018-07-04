#include<iostream>
#include<string>
#include "lexer/lexer.h"
using namespace std;

int main() {
    // Create a lexer just to see that it works
    string input = "Hello, World!";
    Lexer lexer(input);
    cout << lexer.getCurrentCharacter() << endl;
    return 0;
}
