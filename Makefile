CC=gcc

all: clean comp
	
comp:
	flex comp.l
	yacc -vd comp.y
	cc lex.yy.c y.tab.c -o comp -lm -ll

clean:
	rm -rf comp y.tab.c y.tab.h lex.yy.c y.output
