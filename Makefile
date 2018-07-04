CFLAGS = -O
CC = g++

token.o: src/token/token.cpp
	$(CC) $(CFLAGS) -o build/token.o -c src/token/token.cpp
