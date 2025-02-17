%{
#include <iostream>
#include <vector>
#include <string>
int yylex(); // A function that is to be generated and provided by flex,
             // which returns a next token when called repeatedly.
int yyerror(const char *p) { std::cerr << "Error: " << p << std::endl; };

std::vector<std::string> outputResults;
std::vector<std::string> inputExpres;
int lineNumber = 1;
int expectedLineNumber = 1;
bool divisionByZeroError = false; 
%}

%union {
    int val;
    /* You may include additional fields as you want. */
    /* char op; */
};

%start prog

%token LPAREN RPAREN
%token PLUS MINUS MUL DIV EQ GT LT
%token <val> NUM    /* 'val' is the (only) field declared in %union
                       which represents the type of the token. */

%type <val> expr comparison equation inequality inputChain

/* Resolve the ambiguity of the grammar by defining precedence. */

/* Order of directives will determine the precedence. */
%left EQ GT LT    /* Comparison operators: equality, greater than, less than */
%left PLUS MINUS    /* left means left-associativity. */
%left DIV MUL
%left LPAREN RPAREN 

%precedence NEGATIVE

%%

prog : expr_list                        { 
            for (size_t i = 0; i < outputResults.size(); ++i) {
                std::cout << (i + 1) << ": " << outputResults[i] << std::endl;
            }
        }
     ;

expr_list : comparison '\n'                   { 
            if (divisionByZeroError) {
                outputResults.push_back("Error: Division By Zero");
                divisionByZeroError = false;
            } else {
                outputResults.push_back($1 ? "Yes" : "No");
            }
            inputExpres.push_back(std::to_string(lineNumber) + ": " + std::to_string($1));
        }
          | expr_list comparison '\n'         { 
            if (divisionByZeroError) {
                outputResults.push_back("Error: Division By Zero");
                divisionByZeroError = false;
            } else {
                outputResults.push_back($2 ? "Yes" : "No");
            }
            inputExpres.push_back(std::to_string(lineNumber) + ": " + std::to_string($2));
        }
          ;

comparison : equation                        { $$ = $1; }
           | inequality                      { $$ = $1; }
           | inputChain                      { $$ = $1; }
           ;

equation : expr EQ expr                      { $$ = ($1 == $3); }
         ;

inequality : expr GT expr                    { $$ = ($1 > $3); }
           | expr LT expr                    { $$ = ($1 < $3); }
           ;

inputChain : expr GT expr GT expr                 { $$ = ($1 > $3 && $3 > $5); }
           | expr LT expr LT expr                 { $$ = ($1 < $3 && $3 < $5); }
           | expr GT expr LT expr                 { $$ = ($1 > $3 && $3 < $5); }
           | expr LT expr GT expr                 { $$ = ($1 < $3 && $3 > $5); }
           ;

expr : expr PLUS expr                   { $$ = $1 + $3; }
     | expr MINUS expr                  { $$ = $1 - $3; }
     | MINUS expr %prec NEGATIVE        { $$ = -$2;}
     | expr MUL expr                    { $$ = $1 * $3; }
     | expr DIV expr                    { 
            if ($3 == 0) {
                divisionByZeroError = true;
                $$ = 0; 
            } else {
                $$ = $1 / $3;
            }
        }
     | NUM                              /* default action: { $$ = $1; } */
     | LPAREN expr RPAREN               { $$ = $2; }
     ;

%%

int main()
{
    yyparse(); // A parsing function that will be generated by Bison.
    return 0;
}