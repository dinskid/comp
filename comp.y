%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tac.h"
#include "utils.c"

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
  char* s; // use this when some string is to be stored
  struct idlistnode* idlist; // use this to store identifiers (as linked list)
  struct astnode* ast; // use this to store any internal nodes
  struct constantnode* val; // use this to store any constant
}

%token <s> INT CHAR UNSIGNED FLOAT DOUBLE SHORT VOID LONG PLUS_EQ EQ
%type  <s>   assignop dtype

%token <idlist> IDENTIFIER 
%type  <idlist> decllist

%type  <ast> expr arithmetic_expr binary_expr logical_expr assignstmt

%token <val> ICONST FCONST CHARCONST
%type  <val> constant

%token LBRACE RBRACE LPAREN RPAREN
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
  | DO '{' stmts '}' WHILE '(' expr ')' ';'
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
  checkType($1->type, $3->type);
  struct astnode* temp = mkNode();
  char code[100];
  if ($2[0] == '=') {
    sprintf(code, "%s := %s", temp->place, $3->place);
  } else {
    sprintf(code, "%s := %s %c %s", temp->place, temp->place, $2[0], $3->place);
  }
  printf("%s\n", code);
  printf("%s := %s\n", $1->name, temp->place);
  temp->tac = strdup(code);
  $$ = temp;
}

declstmt: dtype decllist ';' {
    printf("Type: %s\n", $1);
    IdentifierList* cur = $2;
    while (cur != NULL) {
      cur->type = strdup($1);
      printf("%s->", cur->type);
      cur = cur->next;
    }
    printf("null\n");
  }
  ;

dtype: INT
  | CHAR
  | SHORT
  | UNSIGNED
  | FLOAT
  | DOUBLE
  | VOID
  ;

decllist: IDENTIFIER ',' decllist {
    $1->next = $3;
    $$ = $1;
  }
  | IDENTIFIER {
    $$ = $1;
  }
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
    printf("Type of constant: %s\n", $1->type);
    temp->type = $1->type;
    // sprintf(temp->tac, code, $1->x);
    $$ = temp;
    printf("%s\n", $$->tac);
  }
  ;
  
arithmetic_expr: expr '+' expr {
    checkType($1->type, $3->type);
    struct astnode* temp = mkNode();
    char code[100];
    sprintf(code, "%s := %s + %s", temp->place, $1->place, $3->place);
    temp->tac = strdup(code);
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
