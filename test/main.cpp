// Simple main script to run the tests
#include "lexer.h"

int main() {
    // Lexer tests
    if(testNextToken() == 1) {
        return 1;
    }
    return 0;
}
