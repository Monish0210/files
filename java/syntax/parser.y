
%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
extern int yylineno;
%}

%token CLASS PUBLIC STATIC VOID INT STRING
%token IF ELSE DO WHILE
%token ID NUMBER

%left '+' '-'
%left '*' '/'
%nonassoc '>' '<' GE LE EQ NE
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

program
    : class_decl
      { printf("Valid syntax\n"); }
    ;

class_decl
    : CLASS ID '{' main_method '}'
    ;

main_method
    : PUBLIC STATIC VOID ID '(' STRING '[' ']' ID ')'
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
    | if_statement
    | do_while_statement
    | block
    ;

variable_decl
    : INT ID
    | INT ID '=' expression
    ;

assignment
    : ID '=' expression
    ;

if_statement
    : IF '(' condition ')' statement %prec LOWER_THAN_ELSE
    | IF '(' condition ')' statement ELSE statement
    ;

do_while_statement
    : DO statement WHILE '(' condition ')' ';'
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
    | '(' expression ')'
    | expression '+' expression
    | expression '-' expression
    | expression '*' expression
    | expression '/' expression
    ;

%%

void yyerror(const char *s)
{
    fprintf(stderr, "Syntax Error at line %d: %s\n",
            yylineno, s);
}

int main(void)
{
    if (yyparse() == 0)
        return 0;

    return 1;
}
