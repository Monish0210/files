
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(const char *s);

extern int yylineno;

char *symbols[100];
int symbol_count = 0;
int semantic_error = 0;

int lookup(char *name)
{
    for (int i = 0; i < symbol_count; i++)
        if (strcmp(symbols[i], name) == 0)
            return 1;
    return 0;
}

void declare(char *name)
{
    if (lookup(name)) {
        printf("Semantic Error at line %d: "
               "Variable '%s' already declared\n",
               yylineno, name);
        semantic_error = 1;
    } else if (symbol_count < 100) {
        symbols[symbol_count++] = strdup(name);
    }
}

void check_variable(char *name)
{
    if (!lookup(name)) {
        printf("Semantic Error at line %d: "
               "Variable '%s' not declared\n",
               yylineno, name);
        semantic_error = 1;
    }
}
%}

%union {
    char *name;
}

%token CLASS PUBLIC STATIC VOID INT STRING
%token IF ELSE DO WHILE
%token <name> ID
%token NUMBER

%left '+' '-'
%left '*' '/'
%nonassoc '>' '<' GE LE EQ NE
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

program
    : CLASS ID '{' main_method '}'
      {
          if (!semantic_error)
              printf("Semantic Analysis Successful\n");
      }
    ;

main_method
    : PUBLIC STATIC VOID ID
      '(' STRING '[' ']' ID ')'
      {
          declare($9);
      }
      block
    ;

block
    : '{' statements '}'
    ;

statements
    : /* empty */
    | statements statement
    ;

statement
    : variable_decl ';'
    | assignment ';'
    | IF '(' condition ')' statement %prec LOWER_THAN_ELSE
    | IF '(' condition ')' statement ELSE statement
    | DO statement WHILE '(' condition ')' ';'
    | block
    ;

variable_decl
    : INT ID
      {
          declare($2);
      }
    | INT ID '=' expression
      {
          declare($2);
      }
    ;

assignment
    : ID '=' expression
      {
          check_variable($1);
      }
    ;

condition
    : expression
    | expression '>' expression
    | expression '<' expression
    | expression GE expression
    | expression LE expression
    | expression EQ expression
    | expression NE expression
    ;

expression
    : NUMBER
    | ID
      {
          check_variable($1);
      }
    | '(' expression ')'
    | expression '+' expression
    | expression '-' expression
    | expression '*' expression
    | expression '/' expression
    ;

%%

void yyerror(const char *s)
{
    printf("Syntax Error at line %d: %s\n", yylineno, s);
}

int main(void)
{
    if (yyparse() != 0)
        return 1;

    return semantic_error ? 1 : 0;
}
