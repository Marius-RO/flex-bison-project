%option noyywrap

/*** Sectiunea de declaratii pentru componentele limbajului C++ (headere, declaratii, variabile, etc. ) ***/
%{
    #include <iostream>
    #include <stdio.h>
    #include <string>
    #include "parser.hpp"

    unsigned int numarLinii = 1;
    unsigned int numarCaractere = 0;
    unsigned int numarTokeni = 0;
    void prelucreazaToken(std::string token, std::string tipToken);
    void prelucreazaEroare(std::string token, std::string tipToken);

    extern bool seteazaFisierulDeInput(const char* filename);
    extern void inchideFisierulDeInput();

    // aceasta functie va fi generate de bison
    extern int yyparse();
%}

/*** Declararea expresiilor regulate ***/
digits [0-9]+
binopr [-+*/]
paranthesis [()]

/*** Declararea regulilor pentru tokeni ***/
%%
{digits}        { yylval.dbl = atof(yytext); prelucreazaToken(yytext,"DIGIT"); return LITERAL_DBL;}
{binopr}        { prelucreazaToken(yytext,"BINOP"); return yytext[0]; }
"\n"            { prelucreazaToken("'slash' n","NEW_LINE"); return '\n';}
[ \t\r\f]+	    {/* ignora spatiile */}
.               { prelucreazaEroare(yytext, "nu a fost identificat");}
<<EOF>>         { inchideFisierulDeInput(); yyterminate(); }

%%

/*** Implementarea functiilor C++ (main si altele daca este cazul (daca au fost declarate in sectiunea de declaratii)) ***/
void prelucreazaToken(std::string token, std::string tipToken){
    std::cout << "Linia [" << numarLinii << "]: Tokenul [\033[32m" << token << "\033[0m] este de tip [\033[32m" << tipToken << "\033[0m]\n";
    numarTokeni++;
    numarCaractere += token.length();
}

void prelucreazaEroare(std::string token, std::string eroare){
    // printeaza cu rosu eroarea si apoi reseteaza
    std::cout << "\033[31mEroare la linia [" << numarLinii << "]: Tokenul [" << token << "] " << eroare << "\033[0m\n";
}

bool seteazaFisierulDeInput(const char* numeFisier){
    if(numeFisier){
        yyin = fopen(numeFisier,"r");
        if(yyin){
            return true;
        }
        return false;
    }
    return false;
}

void inchideFisierulDeInput(){
    if(yyin){
        fclose(yyin);
    }
}