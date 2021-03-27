/* prologue */
%{
    #include <iostream>
    #include <cmath>
    #include "parser.hpp"

    // this function will be generated using flex
    extern int yylex();
    extern void yyerror(char const* msg);

    extern FILE *yyin;
%}

%union{
    double dbl;
};


%token <dbl> LITERAL_DBL

%type <dbl> expr
%type <dbl> term

%start program


/* rule section */
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

void yyerror(char const* msg){
    std::cout << "Syntax error: " << msg << "\n";
}

int main(){
    // const char* inputFile = "input/input-2.cpp";
    // yyin = fopen(inputFile,"r");
    // if(!yyin){
    //     std::cout << "[EROARE] Fisierul de input [" << inputFile << "] nu fost deschis!\n";
    //     return -1;
    // }

    //return yyparse();

    while(true){
        int res = yyparse();
        if(res != 0){
            return res;
        }
    }
}