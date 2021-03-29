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

    // aceasta functie va fi generate de bison
    extern int yyparse();
%}

/*** Declararea expresiilor regulate ***/
Num [0-9]+
Blank [ \t\r\n]+
Alpha [A-Za-z]

/*** Declararea regulilor pentru tokeni ***/

/*
* {digits}        { yylval.dbl = atof(yytext); prelucreazaToken(yytext,"DIGIT"); return LITERAL_DBL;}
*    {binopr}        { prelucreazaToken(yytext,"BINOP"); return yytext[0]; }
*    "\n"            { prelucreazaToken("'slash' n","NEW_LINE"); return '\n';}
*    [ \t\r\f]+	       {// ignora spatiile}
*    .               { prelucreazaEroare(yytext, "nu a fost identificat");}
*    <<EOF>>         { yyterminate(); }  
*/

%%
{Num}	{prelucreazaToken(yytext,"NUMBER"); yylval = atoi(yytext); return(NUMBER);}
"+" 	{prelucreazaToken(yytext,"PLUS"); return(PLUS);}
"-"		{prelucreazaToken(yytext,"MINUS"); return(MINUS);}
"*"     {prelucreazaToken(yytext,"MULTIPLICATION"); return(MULT);}
"="     {prelucreazaToken(yytext,"ASSIGNMENT"); return(ASGN);}
"<"     {prelucreazaToken(yytext,"LOWER"); return(LOWER);}
">"     {prelucreazaToken(yytext,"GREATER"); return(GREATER);}
";"		{prelucreazaToken(yytext,"SEMICOLON"); return(SEMI);}
"("		{prelucreazaToken(yytext,"LEFT_PARENTHESIS"); return(PL);}
")"		{prelucreazaToken(yytext,"RIGHT_PARENTHESIS"); return(PR);}
"if"	{prelucreazaToken(yytext,"IF"); return(IF);}
"else"	{prelucreazaToken(yytext,"ELSE"); return(ELSE);}
"then"	{prelucreazaToken(yytext,"THEN"); return(THEN);}
"=="	{prelucreazaToken(yytext,"EQUAL"); return(EQUAL);}
"EXIT"  {prelucreazaToken(yytext,"EXIT"); return(EXIT);}
{Alpha}({Alpha}|{Num})* {prelucreazaToken(yytext,"VARIABLE"); return(VARIABLE);}
"\n"    { prelucreazaToken("'slash' n","NEW_LINE"); return '\n';}
[ \t\r\f]+	{/* ignora spatiile */}
<<EOF>>  { yyterminate(); }  
.  {prelucreazaEroare(yytext, "nu a fost identificat");}
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