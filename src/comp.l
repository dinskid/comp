%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include "y.tab.h"
  #include "tac.h"

  void yyerror(char*);

  #define MAKE_OP(OP) {\
    yylval.s = strdup(yytext);\
    return OP;\
  };
%}

digit [0-9]
letter [a-zA-Z_]
ws [ \t\n\v\f]

%option yylineno

%%
  /* single line comment */
"//".* ;
  /* multi line comment */
"/*"(.|\n)*"*/" ;

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
"if" { return IF; }


(-)?{digit}+ { yylval.val = makeIntConstant(yytext); return ICONST; }
(-)?{digit}+"."{digit}+ {yylval.val = makeFloatConstant(yytext); return FCONST;}
"'"{letter}"'" {yylval.val = makeCharConstant(yytext); return CHARCONST;}
{letter}+({letter}|{digit})* {  yylval.idlist = makeIdentifier(yytext); return IDENTIFIER; }
  /* assignment operators */
"="  MAKE_OP(EQ);
"+=" MAKE_OP(PLUS_EQ);
"-=" MAKE_OP(MINUS_EQ);
"*=" MAKE_OP(STAR_EQ);
"/=" MAKE_OP(SLASH_EQ);
"%=" MAKE_OP(MOD_EQ);
"&=" MAKE_OP(AND_EQ)
"|=" MAKE_OP(OR_EQ)
"^=" MAKE_OP(XOR_EQ)
  /* RelOps: EQUALITY NEQ LT LE GT GE */
"==" MAKE_OP(EQUALITY)
"!=" MAKE_OP(NEQ)
"<"  MAKE_OP(LT)
"<=" MAKE_OP(LE)
">"  MAKE_OP(GT)
">=" MAKE_OP(GE)

[~!%^&*()-+={};:'",<.>/?|] {  return yytext[0]; }
"-"  { yylval.s = "-"; return yytext[0]; } // don't know why - isn't recognised by above
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
