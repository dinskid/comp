"<<="  { return LSHIFTEQ; }
"=>>"  { return RSHIFTEQ; }
"&="  { return ANDbEQ; }
"|="  { return ORbEQ; }
"^="  { return XOREQ; }

  /* arithmetic operators */
"++" { return INC; }
"--" { return DEC; }
"+"  { return PLUS; }
"-"  { return MINUS; }
"*"  { return STAR; }
"/"  { return FSLASH; }
"%"  { return MOD; }

  /* relational operators */
"=="  { return EQ; }
"!="  { return NE; }
"<"  { return LT; }
"<="  { return LE; }
">"  { return RT; }
">="  { return RE; }

  /* logical operators */
"&&"   { return ANDl; }
"||"   { return ORl; }
"!"   { return NOTl; }

  /* binary operators */
"&" { return ANDb; }
"|" { return ORb; }
"^" { return XOR; }
"~" { return NOTb; }
"<<" { return LSHIFT; }
">>" { return RSHIFT; }

  /* misc symbols */
"?" { return QMARK; }
":" { return COLON; }
