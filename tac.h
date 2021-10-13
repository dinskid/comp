// Three address code

// enum types {
//   INT,
//   CHAR,
//   FLOAT,
//   LONG,
//   VOID,
// };

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
  char *type;
  char *name;
  int size;
  // add symbol table entry later if required
  struct idlistnode *next;
} IdentifierList;

typedef struct constantnode Constant;
typedef struct astnode Node;
typedef struct idlistnode IdentifierList;

Constant *makeIntConstant(char *);
Node *mkNode(void);
IdentifierList *makeIdentifier(char *);
