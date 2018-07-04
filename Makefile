# I finally *get* makefiles

CFLAGS = -O
CC = g++
SRC = src/main.cpp src/token/token.cpp
OBJ = build/main.o build/token.o
TESTOBJ = build/test.o build/lexer_test.o

# Building the actual library

sapphire: $(OBJ)
	$(CC) $(CFLAGS) -o bin/sapphire $(OBJ)

build/token.o: src/token/token.cpp src/token/token_type.h
	$(CC) $(CFLAGS) -o build/token.o -c src/token/token.cpp

build/main.o: src/main.cpp
	$(CC) $(CFLAGS) -o build/main.o -c src/main.cpp

# Building stuff for testing
tests: $(TESTOBJ)
	$(CC) $(CFLAGS) -o bin/test $(TESTOBJ)

build/test.o: test/main.cpp build/lexer_test.o
	$(CC) $(CFLAGS) -o build/test.o -c test/main.cpp

build/lexer_test.o: build/token.o test/lexer.cpp test/lexer.h
	$(CC) $(CFLAGS) -o build/lexer_test.o -c test/lexer.cpp

clean:
	rm build/*.o bin/sapphire
