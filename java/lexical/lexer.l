
%{
#include <stdio.h>
int line_no = 1;
%}

%option noyywrap

ID      [a-zA-Z_][a-zA-Z0-9_]*
NUM     [0-9]+

%%

"//".*                  { /* Ignore single-line comments */ }

"/*"([^*]|\*+[^*/])*\*+"/"   { /* Ignore block comments */ }

[ \t\r]+                { /* Ignore spaces and tabs */ }
\n                      { line_no++; }

"class"|"public"|"static"|"void"|"int"|"if"|"else"|"do"|"while" {
                            printf("Keyword: %-10s Line: %d\n",
                                   yytext, line_no);
                        }

{ID}                    {
                            printf("Identifier: %-10s Line: %d\n",
                                   yytext, line_no);
                        }

{NUM}                   {
                            printf("Number: %-10s Line: %d\n",
                                   yytext, line_no);
                        }

"=="|"!="|"<="|">="|"++"|"--" {
                            printf("Operator: %-10s Line: %d\n",
                                   yytext, line_no);
                        }

[+\-*/=><]              {
                            printf("Operator: %-10s Line: %d\n",
                                   yytext, line_no);
                        }

[{}()\[\];,.]            {
                            printf("Symbol: %-10s Line: %d\n",
                                   yytext, line_no);
                        }

.                       {
                            printf("Lexical Error: '%s' at Line: %d\n",
                                   yytext, line_no);
                        }

%%

int main(void)
{
    yylex();
    return 0;
}



flex lexer.l
gcc lex.yy.c -o lexer -lfl
./lexer < input.java