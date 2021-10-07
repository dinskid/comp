%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
void yyerror(char*);

extern int yylineno;
extern char* yytext;
%}

%union {
  int x;
  float f;
  char* s;
  char c;
}

%token <s> IDENTIFIER
%token LBRACE RBRACE LPAREN RPAREN

%token <x> ICONST FCONST STRCONST CHARCONST
%type <x> expr F


%token AUTO	DOUBLE	INT	STRUCT
%token BREAK	ELSE	LONG	SWITCH
%token CASE	ENUM	REGISTER	TYPEDEF
%token CHAR	EXTERN	RETURN	UNION
%token CONST	FLOAT	SHORT	UNSIGNED
%token CONTINUE	FOR	SIGNED	VOID
%token DEFAULT	GOTO	SIZEOF	VOLATILE
%token DO	IF	STATIC	WHILE

%%
S : fn S
  | fn
  | declstmt S
  | declstmt
  ;

stmts: stmt stmts
  | stmt;

stmt : assignstmt
  | declstmt
  | retstmt
  | BREAK ';'
  | CONTINUE ';'
  ;

assignstmt: IDENTIFIER '=' expr ';' { printf("MOV %s, %d", $1, $3); }

declstmt: dtype decllist ';'
  ;

dtype: INT
  | CHAR
  | SHORT
  | UNSIGNED
  | FLOAT
  | DOUBLE
  | VOID
  ;

decllist: IDENTIFIER ',' decllist
  | IDENTIFIER
  ;

fn: dtype IDENTIFIER '(' ')' '{' stmts '}'

retstmt: RETURN IDENTIFIER ';'
  | RETURN ICONST ';'

expr : expr '+' F { $$ = $1 + $3; }
  | F { $$ = $1; }
  ;
F : F '*' ICONST { $$ = $1 * $3; }
  | ICONST { $$ = $1; }
  ;
%%

void yyerror(char* s) {
  fprintf(stderr, "Error: %s\n\nLine number: %d\nToken: %s\n", s, yylineno, yytext);
  exit(1);
}

int main(void) { 
  printf("In here!\n");
  yyparse();
  printf("Parsing over\n");
  return 0;
}
