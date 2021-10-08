%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tac.h"

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
  char* s;
  struct astnode* ast;
  struct constantnode* val;
}

%token <s> IDENTIFIER PLUS_EQ EQ
%token LBRACE RBRACE LPAREN RPAREN


%type  <s>   assignop
%type  <ast> expr arithmetic_expr binary_expr logical_expr assignstmt
%type  <val> constant
%token <val> ICONST FCONST CHARCONST
%token <ast> INT CHAR UNSIGNED FLOAT DOUBLE SHORT VOID LONG

%token AUTO	STRUCT
%token BREAK	ELSE	SWITCH
%token CASE	ENUM	REGISTER	TYPEDEF
%token EXTERN	RETURN	UNION
%token CONST	
%token CONTINUE	FOR	SIGNED
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

assignop: EQ {
    $$ = $1;
  }
  | PLUS_EQ {
    // printf("+= from yacc: %s\n", $1);
    $$ = $1;
  }
  ;

assignstmt: IDENTIFIER assignop expr ';' {
  // printf("assignop from assignstmt: %s\n", $2);
  struct astnode* temp = mkNode();
  char code[100];
  // printf("%s\n", $2);
  if ($1[0] == '=') {
    sprintf(code, "%s := %s", temp->place, $3->place);
  } else {
    sprintf(code, "%s := %s %c %s", temp->place, temp->place, $2[0], $3->place);
  }
  printf("%s\n", code);
  temp->tac = strdup(code);
  $$ = temp;
}

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

constant: ICONST {
    $$ = $1;
  }
  | FCONST {
    $$ = $1;
  }
  | CHARCONST {
    $$ = $1;
  }
  ;

expr: arithmetic_expr { $$ = $1; }
  | binary_expr { $$ = $1; }
  | logical_expr { $$ = $1; }
  | '(' expr ')' { $$ = $2; }
  | IDENTIFIER { $$ = mkNode(); }
  | constant {
    struct astnode* temp = mkNode();
    char code[100];
    sprintf(code, "%s := %d", temp->place, $1->x);
    temp->tac = strdup(code);
    // sprintf(temp->tac, code, $1->x);
    $$ = temp;
    printf("%s\n", $$->tac);
  }
  ;
  
arithmetic_expr: expr '+' expr {
    struct astnode* temp = mkNode();
    // char* code = "%s := %s + %s";
    // sprintf(temp->tac, code, temp->place, $1->tac, $3->tac);
    $$ = temp;
  }
  ;
  
binary_expr: expr '&' expr
  | expr '|' expr
  | expr '^' expr
  | '~' expr {
    struct astnode* temp = mkNode();
    char* code = "%s := ~%s";
    sprintf(temp->tac, code, temp->place, $2->place);
    $$ = temp;
  }
  ;

logical_expr: '!' expr {
    struct astnode* temp = mkNode();
    char* code = "%s := ! %s";
    sprintf(temp->tac, code, temp->place, $2->place);
    $$ = temp;
  }
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
