%{
#include <iostream>
#include <vector>
#include <string>
int yylex(); // A function that is to be generated and provided by flex,
             // which returns a next token when called repeatedly.
int yyerror(const char *p) { std::cerr << "error: " << p << std::endl; };

std::vector<int> outputResults;
std::vector<std::string> inputExpres;
int lineNumber = 1;
int expectedLineNumber = 1;
%}

%union {
    int val;
    /* You may include additional fields as you want. */
    /* char op; */
};

%start prog

%token LPAREN RPAREN
%token PLUS MINUS MUL DIV
%token <val> NUM    /* 'val' is the (only) field declared in %union
                       which represents the type of the token. */

%type <val> expr

/* Resolve the ambiguity of the grammar by defining precedence. */

/* Order of directives will determine the precedence. */
%left PLUS MINUS    /* left means left-associativity. */
%left DIV MUL

%%

prog : expr_list                        { 
            for (size_t i = 0; i < outputResults.size(); ++i) {
                std::cout << (i + 1) << ": " << outputResults[i] << std::endl;
            }
        }
     ;

expr_list : expr '\n'                   { 
            outputResults.push_back($1); 
            inputExpres.push_back(std::to_string(lineNumber) + ": " + std::to_string($1));
        }
          | expr_list expr '\n'         { 
            outputResults.push_back($2); 
            inputExpres.push_back(std::to_string(lineNumber) + ": " + std::to_string($2));
        }
          ;

expr : expr PLUS expr                   { $$ = $1 + $3; }
     | expr MINUS expr                  { $$ = $1 - $3; }
     | expr MUL expr                    { $$ = $1 * $3; }
     | expr DIV expr                    { $$ = $1 / $3; }
     | NUM                              /* default action: { $$ = $1; } */
     | LPAREN expr RPAREN               { $$ = $2; }
     ;

%%

int main()
{
    yyparse(); // A parsing function that will be generated by Bison.
    return 0;
}