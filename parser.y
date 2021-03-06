/*** Sectiunea de declaratii pentru componentele limbajului C++ (headere, declaratii, variabile, etc. ) ***/
%{
    #include <iostream>
    #include <cmath>
    #include "parser.hpp"


    extern FILE *yyin;

    // aceasta functie va fi generata de flex
    extern int yylex();

    extern void yyerror(char const* msg);

%}

/*** Declararea tokenilor ***/

%union{
    double dbl;
};


%token <dbl> LITERAL_DBL

%type <dbl> expr
%type <dbl> term

%start program


/*** Declararea gramaticii si a regulilor pentru gramatica ***/
%%
program: /* empty */
    | program expr '\n' {  std::cout << $2 << "\n"; }
    ;

expr: term {$$ = $1;}
    | expr '+' term {$$ = $1 + $3;}
    | expr '-' term {$$ = $1 - $3;}
    ;

term: LITERAL_DBL {$$ = $1;}
    | term '*' LITERAL_DBL {$$ = $1 * $3;}
    | term '/' LITERAL_DBL {$$ = $1 / $3;}
    ;

%%

/*** Implementarea functiilor C++ (main si altele daca este cazul (daca au fost declarate in sectiunea de declaratii)) ***/
void yyerror(char const* msg){
    std::cout << "Syntax error: " << msg << "\n";
}

int main(){
    const char* inputFile = "input/input-2.cpp";
    yyin = fopen(inputFile,"r");
    if(!yyin){
         std::cout << "[EROARE] Fisierul de input [" << inputFile << "] nu fost deschis!\n";
         return -1;
    }
    return yyparse();
}