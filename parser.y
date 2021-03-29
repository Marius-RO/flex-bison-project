/*** LINKURI UTILE
1. https://stackoverflow.com/questions/21948435/multiple-variables-calc-bison
2. https://github.com/Saria-houloubi/Flex-And-Bison/tree/master/If-Else%20with%20logic
3. https://stackoverflow.com/questions/8632516/how-to-get-string-value-of-token-in-flex-and-bison
***/


/***
CONCLUZII DUPA ZIUA DE LUNI:
1. Logica if-ul merge.
2. Operatiile merg.
3. Am incercat un sistem de asignare pe variabile. Initial am gasit pe linkul 1. ideea de a avea doar variabile dintr-o singura litera
Fiecare variabila are stocata valoarea in vector pe pozitia corespunzatoare literei. Dar avem o mica mare problema:
	Problema este ca operatorul de accces ($n -> $1, $2... etc, o sa-i numesc registrii pt ca seamana cu cei din MIPS :D) intoarce doar o singura valoare.
	In mod default registrii returneaza doar INT, asa cum se intampla si in programul scris de mine.
	Cum eu ar trebui sa obtin si valori int (numere convertite cu atoi - regula {Num} din scanner), dar si valori char* pentru a stii ce litera are variabila,
	nu este posibila implementarea.

Research facut de mine:
	- Exista 2 variabile globale: yylval si yytext. 
	     1. yytext este char* si reprezinta exact caracterele din input prelate de catre flex. 
		 2. yylval este varianta procesata a lui yytext. Din acest motiv facem conversia cu atoi in regula {Num}
		 3. yylval este valoarea pe care o returneaza registrii
		 4. In mod default, toate productiile returneaza Int.

Ce am observat in codul scris de tine:
	1. Se foloseste double pt valoarea din registrii.
	2. Un registru poate avea mai multe valori (structura care de fapt e union). Vezi linkul 3. In exemplul tau, se foloseste un union cu valoarea double
	3. Trebuie specificat de la compilare ce tip returneaza productiile: Exemplu acel %token <dbl> expr.
	4. Fiecare productie returneaza ceva, pentru a returna explicit se foloseste $$ = valoare_returnata.

Solutia pe care am incercat-o: 
    Am incercat un tip de date compus : union {int intVal, double dblVal, char* varName}, din care doar un camp va fi folosit la runtime (cred ca de aia e union).
	Adica: Am de lucru cu VARIABLE : Folosesc varName, Am de lucru cu Expr: Folosesc dblVal.
	Problema: Dupa ce specific ce tip sunt Expr si Variable, automat trebuie specificat si tipul celorlalte productii cum este ifElse, Condition, etc si se complica foarte mult.

O solutie usoara la care ma gandesc dar care nu cred ca este si corecta:
	Sa facem cumva sa lucram numai cu char* si in productii sa facem noi conversia in functie de ce avem nevoie in productia respectiva?

Ce bazaconii vezi acum in cod:
	In parser.hpp am declarat tokenii (=, -, *, (, ), etc)
	If-else functional - Trebuie neaparat respectata productia: if(conditie) then ceva si neaprat ; la final. Asemanator si pt if fara else.
	Asignarile pe variabile merg (+ calcule algebrice). Nu trebuie pus ; la final!


***/

/*** Sectiunea de declaratii pentru componentele limbajului C++ (headere, declaratii, variabile, etc. ) ***/
%{
    #include <iostream>
    #include <cmath>
    #include <stdio.h>
    #include <stdbool.h>
    #include <stdlib.h>
    #include "parser.hpp"


    extern FILE *yyin;

    // aceasta functie va fi generata de flex
    extern int yylex();

    extern void yyerror(char const* msg);

	extern void afisareVectorValori();

	//Vector de variabile. Merg doar variabilele dintr-o singura litra (a, b, c, ...)
	int sym[26];
%}

/*** Declararea tokenilor ***/

%token IF ELSE PLUS MINUS SEMI PR PL THEN EQUAL EXIT ASGN MULT LOWER GREATER BLANK NUMBER VARIABLE
%left EQUAL
%left  PLUS MINUS
%left MULT
%left IF ELSE
%right UNOP


%start program

/*** Declararea gramaticii si a regulilor pentru gramatica ***/
%%

program: /* EMPTY */ {std::cout<<"Spatiu!\n";}
	| program Statment '\n' {  std::cout <<"LinieNoua: "<< $2 << "\n"; }
    ;

ifElse:	
	IF PL Condition PR THEN Statment ELSE Statment SEMI {
														if($3){
																printf("In the if true part\n");
																printf("The statment was executed with the value of %d\n",$6);
															}
														else{
																printf("In the else part\n");
																printf("The statment was executed with the value of %d\n",$8);
															}
															printf("\n");
														};
	| IF PL Condition PR THEN Statment SEMI{
											if($3){
													printf("Correct condition statment value is %d",$6);
												}
											else
												printf("incorrect condition");	
											
											printf("\n");
											};
	;
Condition:
	Exp GREATER Exp {$$ =  $1 > $3? 1: 0;}
	| Exp LOWER Exp {$$ =  $1 < $3? 1: 0; }
	| Exp EQUAL Exp {$$ = $1 == $3? 1: 0; }
	| NUMBER
	;

Statment:
	| Exp { printf("Exp: %d\n", $1); }
	| ifElse Statment {printf("IFELSE STM: \n"); }
	| EXIT {printf("In Exit..");exit(0);}
	| VARIABLE ASGN Exp {
			sym[$1] = $3;
			std::cout<<"Se pune "<<$3<<" pe pozitia " <<$1<<" yyval: "<<yyval<<"\n";
			afisareVectorValori();
		}
	;

Exp:		
	NUMBER {std::cout<<"Number: "<<$1<<"\n";}
    | VARIABLE { 
			std::cout<<"Valoarea de pe pozitia: "<<$1<<" este: "<<sym[$1]<<"\n";
			$$ = sym[$1];
		}
	| Exp PLUS Exp {$$ = $1 + $3;}
	| Exp MINUS Exp {$$ = $1 - $3;}
    | Exp MULT Exp { $$ = $1 * $3; }
    | '(' Exp ')' { $$ = $2; }
    ;

%%

/*** Implementarea functiilor C++ (main si altele daca este cazul (daca au fost declarate in sectiunea de declaratii)) ***/
void yyerror(char const* msg){
    std::cout << "Syntax error: " << msg << "\n";
}

void afisareVectorValori(){
	for(int i = 0; i < 26; i++){
		std::cout<<sym[i]<<" ";
	}
	std::cout<<"\n";
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