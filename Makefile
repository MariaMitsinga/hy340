all:
	bison --yacc --output=parser.c parser.y -v
	flex --outfile=scanner.c Bfasi.l
	gcc -o calc scanner.c parser.c

clean:
	rm -rf *.c
	rm -rf *.output
	rm -rf calc
