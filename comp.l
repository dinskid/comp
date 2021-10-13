%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include "y.tab.h"
  #include "tac.h"

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
"int" {  char* s = "int"; yylval.s = strdup(s); return INT; }
"struct" { return STRUCT; }
"break" { return BREAK; }
"else" { return ELSE; }
"long" { return LONG; }
"switch" { return SWITCH; }
"case" { return CASE; }
"enum" { return ENUM; }
"register" { return REGISTER; }
"typedef" { return TYPEDEF; }
"char" { char* s = "char"; yylval.s = strdup(s); return CHAR; }
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


{digit}+ { yylval.val = makeIntConstant(yytext); return ICONST; }
{letter}+({letter}|{digit})* {  yylval.idlist = makeIdentifier(yytext); return IDENTIFIER; }
"=" { 
  yylval.s = strdup(yytext);
  return EQ; 
  }
"+=" {
   yylval.s = strdup(yytext);
    return PLUS_EQ; 
   }
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
