%option noyywrap

%{
    #include <iostream>
    #include <string>
    #include "parser.hpp"

    unsigned int numarLinii = 1;
    unsigned int numarCaractere = 0;
    unsigned int numarTokeni = 0;
    void prelucreazaToken(std::string token, std::string tipToken);
    void prelucreazaEroare(std::string token, std::string tipToken);

    // this function will be generated using bison
    extern int yyparse();
%}

digits [0-9]+
binopr [-+*/]
paranthesis [()]

%%
{digits}  { yylval.dbl = atof(yytext); prelucreazaToken(yytext,"DIGIT"); return LITERAL_DBL;}
{binopr}  { prelucreazaToken(yytext,"BINOP"); return yytext[0]; }
\n        { prelucreazaToken("'slash' n","NEW_LINE"); return '\n';}
.         { prelucreazaEroare(yytext, "nu a fost identificat");}

%%

void prelucreazaToken(std::string token, std::string tipToken){
    std::cout << "Linia [" << numarLinii << "]: Tokenul [\033[32m" << token << "\033[0m] este de tip [\033[32m" << tipToken << "\033[0m]\n";
    numarTokeni++;
    numarCaractere += token.length();
}

void prelucreazaEroare(std::string token, std::string eroare){
    // printeaza cu rosu eroarea si apoi reseteaza
    std::cout << "\033[31mEroare la linia [" << numarLinii << "]: Tokenul [" << token << "] " << eroare << "\033[0m\n";
}
