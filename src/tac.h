#ifndef TAC
#define TAC
// Three address code

// enum types {
//   INT,
//   CHAR,
//   FLOAT,
//   LONG,
//   VOID,
// };
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
int insert(STNode);
int find(STNode);

typedef struct constantnode
{
  union
  {
    int x;
    float f;
    char c;
  };
  int size; // currently Idk what for, maybe it would be useful later
  char *type;
} Constant;

typedef struct astnode
{
  char *type;
  char *place;
  char *tac; // three address code
} Node;

typedef struct idlistnode
{
  struct symboltablenode *node;
  // add symbol table entry later if required
  struct idlistnode *next;
} IdentifierList;

typedef struct constantnode Constant;
typedef struct astnode Node;
typedef struct idlistnode IdentifierList;

Constant *makeIntConstant(char *);
Constant *makeCharConstant(char *);
Constant *makeFloatConstant(char *);
Node *mkNode(void);
IdentifierList *makeIdentifier(char *);
char *makeLabel(void);
char *makeEndLabel(char *);

struct astnode *genTwoOperand(struct astnode *, struct astnode *, char *, struct astnode *);
struct astnode *genForRelOp(struct astnode *, struct astnode *, char *, struct astnode *);
char *append(int, ...);

#endif // TAC
