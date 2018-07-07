# I finally *get* makefiles

CFLAGS = -O
CC = g++
OBJ = build/main.o build/token.o build/lexer.o
TESTOBJ = build/test.o build/lexer_test.o

# Building the actual library

sapphire: $(OBJ)
	$(CC) $(CFLAGS) -o bin/sapphire $(OBJ)

build/token.o: src/token/token.cpp src/token/token.h
	$(CC) $(CFLAGS) -o build/token.o -c src/token/token.cpp

build/lexer.o: src/lexer/lexer.cpp src/lexer/lexer.h
	$(CC) $(CFLAGS) -o build/lexer.o -c src/lexer/lexer.cpp

build/main.o: src/main.cpp
	$(CC) $(CFLAGS) -o build/main.o -c src/main.cpp

# Building stuff for testing
tests: $(TESTOBJ) build/token.o build/lexer.o
	$(CC) $(CFLAGS) -o bin/test $(TESTOBJ) build/token.o build/lexer.o

build/test.o: test/main.cpp
	$(CC) $(CFLAGS) -o build/test.o -c test/main.cpp

build/lexer_test.o: test/lexer.cpp test/lexer.h
	$(CC) $(CFLAGS) -o build/lexer_test.o -c test/lexer.cpp

clean:
	rm build/*.o bin/sapphire
