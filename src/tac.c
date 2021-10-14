#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
// #include "symboltable.h"
#include "tac.h"
#include "utils.h"

STable st;

void debug(char *location, char *s)
{
  printf("from %s: %s\n", location, s);
  fflush(stdout);
}

#ifdef DEBUG
#define dbg(...) debug(__VA_ARGS__)
#else
#define dbg(...)
#endif

int current_temp_var = 0;

Constant *mkConstNode()
{
  return (Constant *)malloc(sizeof(Constant));
}

Constant *makeIntConstant(char *num)
{
  // printf("makeIntConstant: %s\n", num);
  Constant *c = mkConstNode();
  c->x = atoi(num);
  c->size = 4; // integer is of 4 bytes
  // printf("value: %d\n", c->x);
  // printf("end makeIntConstant\n");
  char *s = "int";
  c->type = strdup(s);
  return c;
}
Constant *makeCharConstant(char *text)
{
  Constant *ch = mkConstNode();
  ch->c = text[0];
  ch->size = 1;

  char *s = "char";
  ch->type = strdup(s);
  return ch;
}

Constant *makeFloatConstant(char *decimal)
{
  Constant *fl = mkConstNode();
  fl->f = atof(decimal);
  fl->size = 8;
  char *s = "float";
  fl->type = strdup(s);
  return fl;
}

Node *mkNode()
{
  Node *temp = (Node *)malloc(sizeof(Node));
  char s[100];
  sprintf(s, "t%d", current_temp_var++);
  temp->place = strdup(s);
  dbg("mkNode", temp->place);
  return temp;
}

IdentifierList *makeIdentifier(char *id)
{
  IdentifierList *idlist = (IdentifierList *)malloc(sizeof(IdentifierList));
  STNode *temp = (STNode *)malloc(sizeof(STNode));
  temp->name = strdup(id);
  int index = find(*temp);
  if (index == -1)
  {
    index = insert(*temp);
  }
  // printf("Identifer made\n");
  // printf("st.table[%d]->name = %s\n", index, (st.table[index]).name);
  // fflush(stdout);
  // printf("st.table[%d]->type = %s\n", index, (st.table[index]).type);
  // fflush(stdout);
  idlist->node = &(st.table[index]);
  return idlist;
}

struct astnode *genTwoOperand(struct astnode *dst, struct astnode *src1, char *op, struct astnode *src2)
{
  checkType(src1->type, src2->type);
  struct astnode *temp = mkNode();
  char code[100] = {'\0'};
  sprintf(code, "%s := %s %s %s\n", temp->place, src1->place, op, src2->place);
  // printf("\n\ncode: %s\n\n", code);
  temp->tac = append(3, src1->tac, src2->tac, code);
  // printf("\n\ntac: %s\n\n", temp->tac);
  temp->type = strdup(src1->type);
  return temp;
}

char *append(int len, ...)
{
  va_list codes;

  int SIZE = 0;
  va_start(codes, len);
  for (int i = 0; i < len; i++)
  {
    SIZE += strlen(va_arg(codes, char *));
  }
  va_end(codes);

  char *str = (char *)malloc(SIZE + 17); // just some extra space
  if (str == NULL)
  {
    printf("Ran out of memory");
    exit(1);
  }
  memset(str, '\0', sizeof str);
  va_start(codes, len);
  int j = 0;
  // printf("----------------------------start");
  // printf("----------------------------\n");
  for (int i = 0; i < len; i++)
  {
    char *cur = va_arg(codes, char *);
    while (cur != NULL && *cur != '\0')
    {
      str[j++] = *cur++;
    }
    // printf("%s\n-----------------------------------------\n", str);
  }
  // printf("----------------------------end");
  // printf("----------------------------\n");
  va_end(codes);
  str[j] = '\0';
  // printf("from gencode: %s\n\n", str);
  // printf("end gencode\n\n\n");
  // fflush(stdout);
  char *retval = strdup(str);
  free(str);
  return retval;
}

// SYMBOL TABLE
int hash(char *s)
{
  const int p = 53;
  const int m = 1e9 + 9;
  int hash_value = 0, p_pow = 1;
  while (*s != '\0')
  {
    char c = *s;
    hash_value = (hash_value + (1LL * (c - 'a' + 1) * p_pow) % m) % m;
    p_pow = (1LL * p_pow * p) % m;
    s++;
  }
  return hash_value;
}

void initSymbolTable(int sz)
{
  st.table = (STNode *)malloc(sz * sizeof(STNode));
  st.size = sz;
  for (int i = 0; i < sz; i++)
    st.table[i].size = -1; // symbol table node empty
}

int insert(STNode s)
{
  char *id = strdup(s.name);
  int mod = st.size;
  int index = hash(id) % mod;
  // printf("insert - index: %d\n", index);
  // fflush(stdout);
  if (st.table[index].size == -1)
  {
    st.table[index].name = strdup(id);
    st.table[index].size = 0;
  }
  else
  {
    if (strcmp(st.table[index].name, id) == 0)
    {
      // already insert
    }
    else
    {
      // collision is happening
      printf("insert: %s %d\n", id, index);
      fprintf(stderr, "Collision in symbol table, compilation stopped");
      exit(1);
    }
  }
  return index;
}

int find(STNode s)
{
  // TODO: if collision is handled, this fn should be updated
  char *id = strdup(s.name);
  int mod = st.size;
  int index = hash(id) % mod;
  // printf("find - index: %d\n", index);
  // fflush(stdout);
  return (st.table[index].name != NULL &&
          strcmp(st.table[index].name, id) == 0)
             ? index
             : -1;
}
