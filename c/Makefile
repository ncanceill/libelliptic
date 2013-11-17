CC=gcc -W -Wall -Werror -pedantic -g

%.o: %.c
	$(CC) -ansi -o $@ -c $<

sample: elliptic.o sample.o
	$(CC) -o $@ $^

lib: elliptic.o
	ar -cvq libelliptic.a $^

clean:
	rm *.o

