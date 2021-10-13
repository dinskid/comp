#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "tac.h"
// #include "symboltable.h"

int main()
{
  STNode st;
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