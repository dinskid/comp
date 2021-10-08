%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
void yyerror(char*);

extern int yylineno;
extern char* yytext;
%}

%right '='
%left '<' '>'
%left '+' '-'
%left '*' '/' '%'
%left '&' '|'
%right '!' '~'

%union {
  int x;
  float f;
  char* s;
  char c;
}

%token <s> IDENTIFIER
%token LBRACE RBRACE LPAREN RPAREN

%token <x> ICONST
%token <f> FCONST
%token <c> CHARCONST


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
  | stmt
  | '{' stmts '}'
  ;


stmt : assignstmt
  | declstmt
  | retstmt
  | BREAK ';'
  | CONTINUE ';'
  | loopstmt
  ;

loopstmt: WHILE '(' expr ')' '{' stmts '}'
  | FOR '(' assignstmt ';' expr ';' expr ')' '{' stmts '}'
  | DO '{' stmts '}' '(' expr ')' ';'
  ;

assignop: '='
  | '+' '='
  | '-' '='
  | '*' '='
  | '/' '='
  | '%' '='
  | '&' '='
  | '|' '='
  | '~' '='
  ;

assignstmt: IDENTIFIER assignop expr ';'

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

retstmt: RETURN expr ';'
  | RETURN ';'
  ;

constant: ICONST
  | FCONST
  | CHARCONST
  ;

expr : arithmetic_expr
  | binary_expr
  | logical_expr
  | '(' expr ')'
  | IDENTIFIER
  | constant
  ;
  
arithmetic_expr: expr '+' expr
  | expr '-' expr
  | expr '*' expr
  | expr '/' expr
  | expr '%' expr
  ;
  
binary_expr: expr '&' expr
  | expr '|' expr
  | expr '^' expr
  | '~' expr
  ;

logical_expr: '!' expr 
  | expr '&' '&' expr
  | expr '|' '|' expr
  | expr '=' '=' expr
  | expr '!' '=' expr
  | expr '>' expr
  | expr '>' '=' expr
  | expr '<' expr
  | expr '<' '=' expr
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
