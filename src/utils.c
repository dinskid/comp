#include <string.h>
#include <stdio.h>

extern void yyerror(char *);

// TODO: add implicit coercion rules
void checkType(char *type1, char *type2)
{
  if (type1 == NULL || type2 == NULL || strcmp(type1, type2) != 0)
  {
    char msg[100];
    sprintf(msg, "Incompatible type: %s %s", type1, type2);
    yyerror(msg);
  }
}