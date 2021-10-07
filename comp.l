%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include "y.tab.h"

  void yyerror(char*);
%}

digit [0-9]
letter [a-zA-Z_]
ws [ \t\n\v\f]

%option yylineno

%%
  /* list of keywords */
"auto" { return AUTO; }
"double" { return DOUBLE; }
"int" {  return INT; }
"struct" { return STRUCT; }
"break" { return BREAK; }
"else" { return ELSE; }
"long" { return LONG; }
"switch" { return SWITCH; }
"case" { return CASE; }
"enum" { return ENUM; }
"register" { return REGISTER; }
"typedef" { return TYPEDEF; }
"char" { return CHAR; }
"extern" { return EXTERN; }
"return" { return RETURN; }
"union" { return UNION; }
"const" { return CONST; }
"float" { return FLOAT; }
"short" { return SHORT; }
"unsigned" { return UNSIGNED; }
"continue" { return CONTINUE; }
"for" { return FOR; }
"signed" { return SIGNED; }
"void" {  return VOID; }
"default" { return DEFAULT; }
"goto" { return GOTO; }
"sizeof" { return SIZEOF; }
"volatile" { return VOLATILE; }
"do" { return DO; }
"static" { return STATIC; }
"while" { return WHILE; }


{digit}+ { yylval.x = atoi(yytext); return ICONST; }
{letter}+({letter}|{digit})* {  yylval.s = strdup(yytext); return IDENTIFIER; }
[~!%^&*()-+={};:'",<.>/?] {  return yytext[0]; }
{ws}* { ; }
. { 
  char* err;
  sprintf(err, "%s is not a valid lexeme", yytext);
  yyerror(err); 
  }
%%

int yywrap(void) {
	return 1;
}
