typedef struct symboltablenode
{
  char *type;
  char *name;
  int size;
} STNode;

typedef struct symboltable
{
  int size;
  STNode *table;
} STable;

// typedef struct symboltablestack {
//   STable* stack;
//   int top, size;
// } STStack;

void initSymbolTable(int);