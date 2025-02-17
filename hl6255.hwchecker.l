%{
#include <iostream>
#include <stdlib.h>
#include "calc2.tab.h"

extern int lineNumber; 
extern int expectedLineNumber;
extern int yyerror(const char *p);
%}

%option noyywrap

%%
                        /* 'val' in 'yylval.val' is the field declared in
                           calc2.y with the %union directive. */
[0-9]+":"               {lineNumber = atoi(yytext); 
                          if (lineNumber != expectedLineNumber) {
                              std::cerr << "error: Line number out of sequence" << std::endl;
                              exit(1);
                          }
                          expectedLineNumber++; }
[0-9]+                { yylval.val = atoi(yytext); return NUM; }
[0-9]+                { yylval.val = atoi(yytext); return NUM; }
"+"                     { return PLUS; }
"-"                     { return MINUS; }
"*"                     { return MUL; }
"/"                     { return DIV; }
"("                     { return LPAREN; }
")"                     { return RPAREN; }
"="                     { return EQ; }
">"                     { return GT; }
"<"                     { return LT; }
[a-zA-Z_][a-zA-Z0-9_]*  { yyerror("syntax error");exit(1); }
\n                      { return '\n'; } // Increment line number on newline
[ \t\r\n]+              { /* Ignore white characters. */ }
.                       { std::cerr << "Invalid token" << yytext << std::endl; exit(1); }

%%
