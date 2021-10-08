CC=gcc

all: clean comp
	
comp:
	flex comp.l
	yacc -vd comp.y
	$(CC) tac.c lex.yy.c y.tab.c -o comp -lm -ll

debug:
	flex comp.l
	yacc -vd comp.y
	cc tac.c lex.yy.c y.tab.c -o comp -lm -ll -g -DDEBUG


clean:
	rm -rf comp y.tab.c y.tab.h lex.yy.c y.output
