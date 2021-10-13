CC=gcc
BIN=bin
SRC=src

all: clean comp
	
comp:
	mkdir -p $(BIN)
	cd $(SRC); \
	flex comp.l; \
	yacc -vd comp.y; \
	$(CC) utils.c tac.c lex.yy.c y.tab.c -o ../$(BIN)/comp -lm -ll; \
	rm lex.yy.c y.tab.c y.tab.h y.output

debug:
	mkdir -p $(BIN)
	cd $(SRC); \
	flex comp.l; \
	yacc -vd comp.y; \
	$(CC) utils.c tac.c lex.yy.c y.tab.c -o ../$(BIN)/comp -lm -ll -g -DDEBUG; \
	rm lex.yy.c y.tab.c y.tab.h y.output

clean:
	rm -rf $(BIN)
