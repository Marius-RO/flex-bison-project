%option noyywrap

/*** Sectiunea de declaratii pentru componentele limbajului C++ (headere, declaratii, variabile, etc. ) ***/
%{
    #include <iostream>
    #include <stdio.h>
    #include <string>
    //#include "parser.hpp"

    unsigned int numarLinii = 1;
    unsigned int numarCaractere = 0;
    unsigned int numarTokeni = 0;
    void prelucreazaToken(std::string token, std::string tipToken);
    void prelucreazaEroare(std::string token, std::string tipToken);

    // aceasta functie va fi generate de bison
    extern int yyparse();
%}

/*** Declararea expresiilor regulate ***/
INTEGER_VALUE [0-9]+
Blank [ \t\r\n]+
Alpha [A-Za-z]
VALOARE_VARIABILA_STRING ["][^\n\r]*["]

/*** Declararea regulilor pentru tokeni ***/

%%
{INTEGER_VALUE}	{prelucreazaToken(yytext,"INTEGER_VALUE"); /** yylval = atoi(yytext); return(INTEGER_VALUE); **/}
"+" 	{prelucreazaToken(yytext,"PLUS"); /*return("PLUS");*/}
"-"		{prelucreazaToken(yytext,"MINUS"); /*return(MINUS);*/}
"*"     {prelucreazaToken(yytext,"MULTIPLICATION"); /*return(MULT);*/}
"="     {prelucreazaToken(yytext,"ASSIGNMENT"); /*return(ASGN);*/}
"<"     {prelucreazaToken(yytext,"LOWER"); /*return(LOWER);*/}
">"     {prelucreazaToken(yytext,"GREATER"); /*return(GREATER);*/}
"<<"    {prelucreazaToken(yytext,"LEFT_SHIFT"); /*return(LEFT_SHIFT);*/}
">>"    {prelucreazaToken(yytext,"RIGHT_SHIFT"); /*return(RIGHT_SHIFT);*/}
";"		{prelucreazaToken(yytext,"SEMICOLON"); /*return(SEMI);*/}
"("		{prelucreazaToken(yytext,"LEFT_PARENTHESIS"); /*return(LEFT_PARENTHESIS);*/}
")"		{prelucreazaToken(yytext,"RIGHT_PARENTHESIS"); /*return(RIGHT_PARENTHESIS);*/}
"{"     {prelucreazaToken(yytext,"RIGHT_BRACKET"); /*return(RIGHT_BRACKET);*/}
"}"     {prelucreazaToken(yytext,"LEFT_BRACKET"); /*return(LEFT_BRACKET);*/}
"if"	{prelucreazaToken(yytext,"IF_KEYWORD"); /*return(IF);*/}
"else"	{prelucreazaToken(yytext,"ELSE_KEYWORD"); /*return(ELSE);*/}
"=="	{prelucreazaToken(yytext,"EQUALS_OPERATOR"); /*return(EQUALS);*/}
"#include"  {prelucreazaToken(yytext,"INCLUDE_DIRECTIVE"); /*return(INCLUDE_DIRECTIVE);*/}
"using"     {prelucreazaToken(yytext,"USING_KEYWORD"); /*return(USING);*/}
"string"    {prelucreazaToken(yytext,"STRING_KEYWORD"); /*return(STRING);*/}
"int"       {prelucreazaToken(yytext,"INT_KEYWORD"); /*return(INT);*/}
"while"     {prelucreazaToken(yytext,"WHILE_KEYWORD"); /*return(WHILE);*/}
"break"     {prelucreazaToken(yytext,"BREAK_KEYWORD"); /*return(BREAK);*/}
"continue"  {prelucreazaToken(yytext,"CONTINUE_KEYWORD"); /*return(CONTINUE);*/}
"return"    {prelucreazaToken(yytext,"RETURN_KEYWORD");/* return(RETURN);*/}


{Alpha}({Alpha}|{INTEGER_VALUE})* {prelucreazaToken(yytext,"IDENTIFIER"); /*return(IDENTIFIER);*/}
{VALOARE_VARIABILA_STRING}  {prelucreazaToken(yytext,"VALOARE_VARIABILA_STRING");}

"//".+            {prelucreazaToken(yytext,"Comentariu pe o singura linie");}
"/*"(\n|.)*"*/"   {prelucreazaToken(yytext,"Comentariu pe mai multe linii");}
"\n"              {numarLinii++; prelucreazaToken("'slash' n","NEW_LINE"); /*return '\n';*/}
[ \t\r\f]+	      {/* ignora spatiile */}
<<EOF>>           { yyterminate(); }  
.                 {prelucreazaEroare(yytext, "nu a fost identificat");}
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


int main(){

    yyin = fopen("input/input-2.cpp","r");
    if(yyin){
            yylex();
    }
    else{
        printf("Fisierul de input nu fost deschis!");
        return 0;
    }

    printf("\nAu fost prelucrate %d caractere , %d tokeni si %d linii\n\n", numarCaractere, numarTokeni, numarLinii);

    return 0;
}