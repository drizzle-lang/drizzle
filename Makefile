CFLAGS = -O
CC = g++
SRC = src/main.cpp src/token/token.cpp
OBJ = build/main.o build/token.o

Sapphire: $(OBJ)
	$(CC) $(CFLAGS) -o bin/sapphire $(OBJ)

build/token.o: src/token/token.cpp src/token/token_type.h
	$(CC) $(CFLAGS) -o build/token.o -c src/token/token.cpp

build/main.o:
	$(CC) $(CFLAGS) -o build/main.o -c src/main.cpp

clean:
	rm build/*.o
