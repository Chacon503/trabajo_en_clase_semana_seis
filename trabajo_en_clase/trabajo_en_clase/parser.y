%{
#include <stdio.h>
#include "symbols.h"
int yylex();
void yyerror(const char *s);
extern FILE *yyin;
%}

/*Define the yylval structure*/
%union {
    int i_val;
    int n_val;
    int type_enum;
    struct SymbolEntry *entry;
    double d_val;
    char c_val;
    char *s_val;
}

%token VAR
%token INT_TYPE
%token COLON SEMICOLON LBRACKET RBRACKET ASSIGN
%token DOUBLE_TYPE
%token CHAR_TYPE
%token BOOL_TYPE
%token STRING_TYPE

/*Type definitions for TOKEN*/
%token <entry> IDENTIFIER
%token <i_val> INT_LITERAL
%token <n_val> NUMBER
%token <d_val> DOUBLE_LITERAL
%token <c_val> CHAR_LITERAL
%token <i_val> BOOL_LITERAL
%token <s_val> STRING_LITERAL

/*Defining types into the parser*/
%type <type_enum> data_type
%type <n_val> expression
%type <d_val> double_expr
%type <c_val> char_expr
%type <i_val> bool_expr
%type <s_val> string_expr

%%
program:
        program statement
        | /**/
        ;
statement:  variable_definition SEMICOLON;

data_type:
       INT_TYPE    { $$=TYPE_INT; }
     | DOUBLE_TYPE { $$ = TYPE_DOUBLE; }
     | CHAR_TYPE   { $$ = TYPE_CHAR; }
     | BOOL_TYPE   { $$ = TYPE_BOOL; }
     | STRING_TYPE { $$ = TYPE_STRING; }
     ;

expression:
    NUMBER        { $$ = $1; }
    | INT_LITERAL { $$= (int) $1; }
    ;

double_expr:
      DOUBLE_LITERAL { $$ = $1; }
    | INT_LITERAL    { $$ = (double)$1; }
    ;

char_expr:
      CHAR_LITERAL { $$ = $1; }
    ;

bool_expr:
      BOOL_LITERAL { $$ = $1; }
    | INT_LITERAL  { $$ = ($1 != 0) ? 1 : 0; }
    ;

string_expr:
      STRING_LITERAL { $$ = $1; }
    ;

variable_definition: VAR COLON LBRACKET data_type RBRACKET IDENTIFIER ASSIGN expression {
    $6->data_type =(DataType) $4;
    printf("ASSIGN Value> ID:%s  TYPE: %i VALUE:%d", $6->identifier, $4, $8);
    switch($4){
        case TYPE_INT: $6->i_value =(int)$8;
    }
}
| VAR COLON LBRACKET DOUBLE_TYPE RBRACKET IDENTIFIER ASSIGN double_expr {
    $6->data_type = TYPE_DOUBLE;
    $6->d_value   = $8;
    printf("ASSIGN Value> ID:%s  TYPE: double VALUE:%f", $6->identifier, $6->d_value);
}
| VAR COLON LBRACKET CHAR_TYPE RBRACKET IDENTIFIER ASSIGN char_expr {
    $6->data_type = TYPE_CHAR;
    $6->c_value   = $8;
    printf("ASSIGN Value> ID:%s  TYPE: char VALUE:'%c'", $6->identifier, $6->c_value);
}
| VAR COLON LBRACKET BOOL_TYPE RBRACKET IDENTIFIER ASSIGN bool_expr {
    $6->data_type = TYPE_BOOL;
    $6->b_value   = $8;
    printf("ASSIGN Value> ID:%s  TYPE: bool VALUE:%s (%d)", $6->identifier, $6->b_value ? "true" : "false", $6->b_value);
}
| VAR COLON LBRACKET STRING_TYPE RBRACKET IDENTIFIER ASSIGN string_expr {
    $6->data_type = TYPE_STRING;
    $6->str_alloc = STR_ALLOC_HEAP;
    $6->s_value   = $8;
    printf("ASSIGN Value> ID:%s  TYPE: string VALUE:\"%s\"", $6->identifier, $6->s_value);
    free($6->s_value);
    $6->s_value   = NULL;
    $6->str_alloc = STR_ALLOC_NONE;
}
;

%%

/* Error handler */
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

/*Main  Function*/
int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Could not open %s\n", argv[1]);
            return 1;
        }
        extern FILE *yyin;
        yyin = file;
    }

    int result = yyparse();

    if (result == 0) {
        printf("Parse Successful!\n");
    }

    return result;

}
