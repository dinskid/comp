#include <string.h>
#include <stdio.h>
#include "tac.h"

extern void yyerror(char *);

void checkDeclared(STNode *id)
{
  // the type of a symbol/identifier is set at the symbol table iff it is
  // declared - as the declaration statement is used for setting type
  if (id->type == NULL)
  {
    char msg[100];
    sprintf(msg, "%s has to be declared before usage", id->name);
    yyerror(msg);
  }
}

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
