
%{
#include "y.tab.h"
#include <string.h>
%}

%option noyywrap yylineno

ID      [a-zA-Z_][a-zA-Z0-9_]*
NUMBER  [0-9]+

%%

"//".*                  { /* Ignore comments */ }
[ \t\r\n]+              { /* Ignore whitespace */ }

"class"                 { return CLASS; }
"public"                { return PUBLIC; }
"static"                { return STATIC; }
"void"                  { return VOID; }
"int"                   { return INT; }
"String"                { return STRING; }
"if"                    { return IF; }
"else"                  { return ELSE; }
"do"                    { return DO; }
"while"                 { return WHILE; }

">="                    { return GE; }
"<="                    { return LE; }
"=="                    { return EQ; }
"!="                    { return NE; }

{ID}                    {
                            yylval.name = strdup(yytext);
                            return ID;
                        }

{NUMBER}                { return NUMBER; }

[{}()\[\];=+*/<>-]      { return yytext[0]; }

.                       {
                            printf("Lexical Error at line %d: %s\n",
                                   yylineno, yytext);
                            return yytext[0];
                        }

%%


bison -y -d semantic.y
flex semantic.l
gcc y.tab.c lex.yy.c -o semantic -lfl
./semantic < input.java