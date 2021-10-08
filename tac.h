// Three address code

typedef struct constantnode {
  union
  {
    int x;
    float f;
    char c;
  };
  int size; // currently Idk what for, maybe it would be useful later
} Constant;

typedef struct astnode {
  char* place;
  char* tac; // three address code
} Node;

Constant* makeIntConstant(char*);
Node* mkNode(void);
