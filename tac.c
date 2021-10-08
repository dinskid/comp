#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tac.h"

void debug(char* location, char* s) {
  printf("from %s: %s\n", location, s);
  fflush(stdout);
}

#ifdef DEBUG
#define dbg(...) debug(__VA_ARGS__)
#else
#define dbg(...)
#endif

int current_temp_var = 0;

Constant* mkConstNode()
{
  return (Constant*)malloc(sizeof(Constant));
}

Constant* makeIntConstant(char* num)
{
  // printf("makeIntConstant: %s\n", num);
  Constant* c = mkConstNode();
  c->x = atoi(num);
  c->size = 4; // integer is of 4 bytes
  // printf("value: %d\n", c->x);
  // printf("end makeIntConstant\n");
  return c;
}

Node* mkNode()
{
  Node* temp = (Node*)malloc(sizeof(Node));
  char s[100];
  sprintf(s, "t%d", current_temp_var++);
  temp->place = strdup(s);
  dbg("mkNode", temp->place);
  return temp;
}

void gen(char* code)
{
}
