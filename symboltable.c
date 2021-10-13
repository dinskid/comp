#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "symboltable.h"

STable st;

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

void insert(STNode s)
{
  char *id = strdup(s.name);
  int mod = st.size;
  int index = hash(id) % mod;
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
      fprintf(stderr, "Collision in symbol table, compilation stopped");
      exit(1);
    }
  }
}

int find(STNode s)
{
  // TODO: if collision is handled, this fn should be updated
  char *id = strdup(s.name);
  int mod = st.size;
  fflush(stdout);
  int index = hash(id) % mod;
  fflush(stdout);
  return (st.table[index].name != NULL &&
          strcmp(st.table[index].name, id) == 0)
             ? index
             : -1;
}

int main()
{
  int SIZE = 100;
  initSymbolTable(100);
  assert(st.size == SIZE);

  STNode node;
  node.name = "abc";
  insert(node);
  assert(find(node) != -1);

  node.name = "def";
  assert(find(node) == -1);
  printf("Ran tests without any errors!\n");
  return 0;
}

// STStack st;

// void initSymbolTableStack()
// {
//   st.size = 1;
//   st.top = 0;
//   st.stack = initSymbolTable(); // initally it will contain just one ele
// }

// void increaseScope()
// {
//   st.top++; // now top is where we need to insert
//   if (st.top == st.size) {
//     // the stack size must be doubled
//     if (!expand(st)) {
//       // exit if we are not able to expand
//       fprintf(stderr, "Error: Symbol table stack couldn't be created\n");
//       exit(1);
//     }
//   }
// }

// STable* initSymbolTable()
// {
//   STable* tbl = (STable*)malloc(sizeof(STable));
//   tbl->table = (STNode*)malloc(10 * sizeof(STNode));
// };

// SOURCE: https://cp-algorithms.com/string/string-hashing.html