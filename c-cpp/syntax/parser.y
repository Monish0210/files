
%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
extern int yylineno;
%}

%token INT VOID CHAR FLOAT DOUBLE
%token IF ELSE DO WHILE FOR RETURN
%token ID NUMBER
%token GE LE EQ NE INC DEC

%left '+' '-'
%left '*' '/' '%'
%nonassoc '>' '<' GE LE EQ NE
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

program
    : function
      { printf("Valid syntax\n"); }
    ;

function
    : type ID '(' ')' block
    ;

type
    : INT
    | VOID
    | CHAR
    | FLOAT
    | DOUBLE
    ;

block
    : '{' statements '}'
    ;

statements
    : /* empty */
    | statements statement
    ;

statement
    : declaration ';'
    | assignment ';'
    | RETURN expression ';'
    | RETURN ';'
    | IF '(' condition ')' statement %prec LOWER_THAN_ELSE
    | IF '(' condition ')' statement ELSE statement
    | DO statement WHILE '(' condition ')' ';'
    | block
    ;

declaration
    : type ID
    | type ID '=' expression
    ;

assignment
    : ID '=' expression
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
    | expression '%' expression
    ;

%%

void yyerror(const char *s)
{
    fprintf(stderr, "Syntax Error at line %d: %s\n",
            yylineno, s);
}

int main(void)
{
    return yyparse() == 0 ? 0 : 1;
}
