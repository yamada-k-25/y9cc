CFLAGS=-std=c11 -g -static

y9cc: y9cc.c

test: y9cc
		./test.sh

clean:
		rm -f y9cc *.o *~ tmp*

.PHONY: test clean