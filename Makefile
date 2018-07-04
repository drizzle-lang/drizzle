CFLAGS = -O
CC = g++
SRC = src/token/token.cpp
OBJ = $(SRC:.cpp = .o)

token.o: src/token/token.cpp
	$(CC) $(CFLAGS) -o build/token.o -c src/token/token.cpp

Sapphire: $(OBJ)
	$(CC) $(CFLAGS) -o bin/sapphire $(OBJ)

clean:
	rm build/*.o
