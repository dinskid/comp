dtype: INT
  | CHAR
  | SHORT
  | UNSIGNED
  | FLOAT
  | DOUBLE
  | VOID
  ;

%type  <ast> declstmt

%token <f> FCONST
%token <c> CHARCONST

  | expr '-' expr
  | expr '*' expr
  | expr '/' expr
  | expr '%' expr



  | '-' '='
  | '*' '='
  | '/' '='
  | '%' '='
  | '&' '='
  | '|' '='
  | '~' '='