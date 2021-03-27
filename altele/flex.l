/*** Sectiunea de declaratii pentru componentele limbajului C (headere, declaratii, variabile, etc. ) ***/
%{
    #include <stdio.h>
    unsigned int numarLinii = 1;
    unsigned int numarCaractere = 0;
    unsigned int numarTokeni = 0;
    void prelucreazaToken(char *token, char* tipToken);
    void prelucreazaEroare(char* token, char *eroare);
%}

/*** Declararea expresiilor regulate ***/
litera [a-zA-Z]
cifra [0-9]
identificator [a-zA-Z0-9]

CUVANT_CHEIE #include|using|namespace|char|string|bool|int|float|double|if|else|while|for|break|continue|return

OPERATOR  ";"|"+"|"-"|"*"|"/"|"<"|">"|"("|")"|"{"|"}"|"="|"<<"|">>"

IDENTIFICATOR {litera}+{identificator}*

VALOARE_VARIABILA_INT {cifra}*
VALOARE_VARIABILA_FLOAT {cifra}*+"."+{cifra}*
VALOARE_VARIABILA_CHAR ['][^\n\r]*[']
VALOARE_VARIABILA_STRING ["][^\n\r]*["]

/*** Declararea regulilor pentru tokeni ***/
%%
{CUVANT_CHEIE}              {prelucreazaToken(yytext,"KEYWORD");}
{OPERATOR}                  {prelucreazaToken(yytext,"OPERATOR");}
{IDENTIFICATOR}             {prelucreazaToken(yytext,"IDENTIFICATOR");}
{VALOARE_VARIABILA_INT}     {prelucreazaToken(yytext,"VALOARE_VARIABILA_INT");}
{VALOARE_VARIABILA_FLOAT}   {prelucreazaToken(yytext,"VALOARE_VARIABILA_FLOAT");}
{VALOARE_VARIABILA_CHAR}    {prelucreazaToken(yytext,"VALOARE_VARIABILA_CHAR");}
{VALOARE_VARIABILA_STRING}  {prelucreazaToken(yytext,"VALOARE_VARIABILA_STRING");}

"//".+            {prelucreazaToken(yytext,"Comentariu pe o singura linie");}
"/*"(\n|.)*"*/"   {prelucreazaToken(yytext,"Comentariu pe mai multe linii");}
"\n"              {numarLinii++; prelucreazaToken("'slash' n","NEW_LINE");}
[ \t\r\f]+	      {/* ignora spatiile */}
<<EOF>>           {return 0;}
.                 {prelucreazaEroare(yytext, "nu a fost identificat"); }

%%


/*** Implementarea functiilor C (main si altele daca este cazul (daca au fost delcarate in sectiunea de declaratii)) ***/
void prelucreazaToken(char *token, char* tipToken){
        printf("Linia [%d]: Tokenul [\033[32m%s\033[0m] este de tip [\033[32m%s\033[0m]\n", numarLinii, token, tipToken);
        numarTokeni++;
        numarCaractere += strlen(token);
}

void prelucreazaEroare(char* token, char *eroare){
    // printeaza cu rosu eroarea si apoi reseteaza
    printf("\033[31mEroare la linia [%d]: Tokenul [%s] %s. \n\033[0m", numarLinii, token, eroare);
}

int yywrap(){}

int main(){

    yyin = fopen("input.cpp","r");
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