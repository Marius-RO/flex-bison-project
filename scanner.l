/* rezolva niste erori/warninguri*/
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

    // aceasta functie va fi generata de bison
    extern int yyparse();
%}

/*** Declararea expresiilor regulate ***/
cifra [0-9]
litera [A-Za-z]
cifra_sau_litera [a-zA-Z0-9]

IDENTIFICATOR {litera}+{cifra_sau_litera}*
VALOARE_VARIABILA_INT {cifra}+
VALOARE_VARIABILA_STRING ["][^\n\r]*["]

/*** Declararea regulilor pentru tokeni ***/

%%
"+" 	    {prelucreazaToken(yytext,"PLUS"); return(PLUS);}
"-"		    {prelucreazaToken(yytext,"MINUS"); return(MINUS);}
"*"         {prelucreazaToken(yytext,"INMULTIRE"); return(INMULTIRE);}
"="         {prelucreazaToken(yytext,"ATRIBUIRE"); return(ATRIBUIRE);}
"<"         {prelucreazaToken(yytext,"MAI_MIC"); return(MAI_MIC);}
">"         {prelucreazaToken(yytext,"MAI_MARE"); return(MAI_MARE);}
"<<"        {prelucreazaToken(yytext,"SHIFTARE_STANGA"); return(SHIFTARE_STANGA);}
">>"        {prelucreazaToken(yytext,"SHIFTARE_DREAPTA"); return(SHIFTARE_DREAPTA);}
";"		    {prelucreazaToken(yytext,"SEMICOLON"); return(SEMICOLON);}
"("		    {prelucreazaToken(yytext,"PARANTEZA_DESCHISA"); return(PD);}
")"		    {prelucreazaToken(yytext,"PARANTEZA_INCHISA"); return(PI);}
"{"         {prelucreazaToken(yytext,"ACOLADA_DESCHISA"); return(AD);}
"}"         {prelucreazaToken(yytext,"ACOLADA_INCHISA"); return(AI);}
"if"	    {prelucreazaToken(yytext,"IF_KEYWORD"); return(IF);}
"else"	    {prelucreazaToken(yytext,"ELSE_KEYWORD"); return(ELSE);}
"=="	    {prelucreazaToken(yytext,"OPERATOR_EGALITATE"); return(EGALITATE);}
"#include"  {prelucreazaToken(yytext,"DIRECTIVA_INCLUDE"); return(DIRECTIVA_INCLUDE);}
"using"     {prelucreazaToken(yytext,"USING_KEYWORD"); return(USING);}
"string"    {prelucreazaToken(yytext,"STRING_KEYWORD"); return(STRING);}
"int"       {prelucreazaToken(yytext,"INT_KEYWORD"); return(INT);}
"while"     {prelucreazaToken(yytext,"WHILE_KEYWORD"); return(WHILE);}
"break"     {prelucreazaToken(yytext,"BREAK_KEYWORD"); return(BREAK);}
"continue"  {prelucreazaToken(yytext,"CONTINUE_KEYWORD"); return(CONTINUE);}
"return"    {prelucreazaToken(yytext,"RETURN_KEYWORD"); return(RETURN);}


{VALOARE_VARIABILA_INT}	    {  prelucreazaToken(yytext,"VALOARE_VARIABILA_INT"); yylval.numar = atoi(yytext); return(VALOARE_VARIABILA_INT);}
{VALOARE_VARIABILA_STRING}  {  prelucreazaToken(yytext,"VALOARE_VARIABILA_STRING"); sscanf(yytext, "%s", yylval.sir_caractere); 
                                return(VALOARE_VARIABILA_STRING); }
{IDENTIFICATOR}              {prelucreazaToken(yytext,"IDENTIFICATOR"); sscanf(yytext, "%s", yylval.sir_caractere);  return(IDENTIFICATOR);}

"//".+            {prelucreazaToken(yytext,"Comentariu pe o singura linie");}
"/*"(\n|.)*"*/"   {prelucreazaToken(yytext,"Comentariu pe mai multe linii");}
"\n"              {numarLinii++; /*prelucreazaToken("'slash' n","LINIE_NOUA");*/ return(LINIE_NOUA);}
[ \t\r\f]+	      {/* ignora spatiile */}
<<EOF>>           { yyterminate(); }  
.                 {prelucreazaEroare(yytext, "nu a fost identificat");}
%%


/*** Implementarea functiilor C++ (main si altele daca este cazul (daca au fost declarate in sectiunea de declaratii)) ***/
void prelucreazaToken(std::string token, std::string tipToken){
    std::cout << "\033[33m[FLEX]\033[0m Linia [" << numarLinii << "]: Tokenul [\033[32m" << token << "\033[0m] este de tip [\033[32m" << tipToken << "\033[0m]\n";
    numarTokeni++;
    numarCaractere += token.length();
}

void prelucreazaEroare(std::string token, std::string eroare){
    // printeaza cu rosu eroarea si apoi reseteaza
    std::cout << "\033[33m[FLEX]\033[0m \033[31mEroare la linia [" << numarLinii << "]: Tokenul [" << token << "] " << eroare << "\033[0m\n";
}