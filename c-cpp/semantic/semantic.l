
%{
#include "y.tab.h"
#include <stdio.h>
#include <string.h>
%}

%option noyywrap yylineno

ID      [a-zA-Z_][a-zA-Z0-9_]*
NUMBER  [0-9]+

%%

^[ \t]*"#"[^\n]*       { /* Ignore preprocessor directives */ }
"//".*                  { /* Ignore comments */ }
"/*"([^*]|\*+[^*/])*\*+"/" { /* Ignore block comments */ }

[ \t\r\n]+              { /* Ignore whitespace */ }

"int"                   { return INT; }
"void"                  { return VOID; }
"char"                  { return CHAR; }
"float"                 { return FLOAT; }
"double"                { return DOUBLE; }
"if"                    { return IF; }
"else"                  { return ELSE; }
"do"                    { return DO; }
"while"                 { return WHILE; }
"for"                   { return FOR; }
"return"                { return RETURN; }

">="                    { return GE; }
"<="                    { return LE; }
"=="                    { return EQ; }
"!="                    { return NE; }
"++"                    { return INC; }
"--"                    { return DEC; }

{ID} {
    yylval.name = strdup(yytext);
    return ID;
}

{NUMBER}                { return NUMBER; }

[{}()\[\];=+*/%<>-]     { return yytext[0]; }

. {
    fprintf(stderr, "Lexical Error at line %d: %s\n",
            yylineno, yytext);
    return yytext[0];
}

%%


bison -y -d semantic.y
flex semantic.l
gcc y.tab.c lex.yy.c -o semantic -lfl
./semantic < input.c