/*** Sectiunea de declaratii pentru componentele limbajului C++ (headere, declaratii, variabile, etc. ) ***/
%{
    #include <iostream>
    #include <cmath>
    #include <stdio.h>
    #include <stdbool.h>
    #include <stdlib.h>
    #include "parser.hpp"

	// coduri de culoare
	std::string A = "\033[02m"; /* culoarea primara */
	std::string B = "\033[32m"; /* culoarea secundara */
	std::string R = "\033[00m"; /* pt reset */
	std::string Z = "\033[32m"; /* pt bison */

	extern unsigned int numarLinii;
    extern FILE *yyin;

    // aceasta functie va fi generata de flex
    extern int yylex();

    extern void yyerror(char const* msg);

	// printeaza tipurile de interpretari
	void afiseazaInterpretareConditie(int valoare, int stanga, int dreapta, std::string operatie);
	void afiseazaInterpretareExpresie(int valoare, int stanga, int dreapta, std::string operatie);
	void afiseazaInterpretareGenerala(std::string interpretare);
%}

/* Flex va comunica cu bison folosind yyval.sir_caractere si yyval.numar */
%union{
	char sir_caractere[1000];
	int numar;
}

/*** Declararea tokenilor ***/

%token PLUS MINUS INMULTIRE 
%token ATRIBUIRE EGALITATE MAI_MIC MAI_MARE SHIFTARE_STANGA SHIFTARE_DREAPTA
%token SEMICOLON LINIE_NOUA PD PI AD AI 
%token DIRECTIVA_INCLUDE USING STRING INT IF ELSE WHILE BREAK CONTINUE RETURN

%left EGALITATE
%left PLUS MINUS
%left INMULTIRE
%left IF ELSE
%right UNOP

%token <sir_caractere> IDENTIFICATOR;
%token <numar> VALOARE_VARIABILA_INT;
%token <sir_caractere> VALOARE_VARIABILA_STRING;

%type <numar> expresie;
%type <numar> conditie;
%type <numar> instructiune;


%start program

/*** Declararea gramaticii si a regulilor pentru gramatica ***/
%%

program: /* empty */ {}
	| instructiune LINIE_NOUA program { /*afiseazaInterpretareGenerala("Se trece la linia urmatoare");*/ }
    ;

if_else:	
	IF PD conditie PI AD program AI ELSE AD program AI {
			if($3){
				afiseazaInterpretareGenerala("Conditia din [" + B + "IF" + R + A + "] este [" + B + "TRUE" + R + A +
											 "] ==> Se executa corpul din [" + B + "IF" + R + A + "]");
				}
			else{
				afiseazaInterpretareGenerala("Conditia din [" + B + "IF" + R + A + "] este [" + B + "FALSA" + R + A +
											 "] ==> Se executa corpul din [" + B + "ELSE" + R + A + "]");
				}
		};

	| IF PD conditie PI AD program AI {
			if($3){
				afiseazaInterpretareGenerala("Conditia din [" + B + "IF" + R + A + "] este [" + B + "TRUE" + R + A +
											 "] ==> Se executa corpul din [" + B + "IF" + R + A + "]");
				}
			else{
				afiseazaInterpretareGenerala("Conditia din [" + B + "IF" + R + A + "] este [" + B + "TRUE" + R + A +
											 "] ==> " + B + "NU" + R + A + " se executa corpul din [" + B + "IF" + R + A + "]");
			}
		};
	;

conditie:
	expresie MAI_MARE expresie { 
			$$ = $1 > $3? 1: 0;
			afiseazaInterpretareConditie($$,$1,$3," > ");
		}
	| expresie MAI_MIC expresie {
			$$ =  $1 < $3? 1: 0;
			afiseazaInterpretareConditie($$,$1,$3," < ");
		}
	| expresie EGALITATE expresie {
			$$ = $1 == $3? 1: 0;
			afiseazaInterpretareConditie($$,$1,$3," == ");
		}
	| VALOARE_VARIABILA_INT { 
			$$ = $1;
			afiseazaInterpretareGenerala("Este evaluata valoarea intreaga");
		}
	;

instructiune: /*empty*/ {}
	| DIRECTIVA_INCLUDE MAI_MIC IDENTIFICATOR MAI_MARE { 
		    std::string s($3);
			afiseazaInterpretareGenerala("Se include directiva [" + B + s + R + A + "]");
		}
	| USING IDENTIFICATOR IDENTIFICATOR SEMICOLON {
			std::string s1($2);
			std::string s2($3);
			afiseazaInterpretareGenerala("Se foloseste [" + B + s1 + R + A + "] [" + B + s2 + R + A + "]");
		}
	| INT IDENTIFICATOR PD PI AD program AI { 
			std::string s1($2);
			afiseazaInterpretareGenerala("Se defineste functia [" + B + s1 + R + A + "] de tip [" + B + "int" + R + A + "]");
		}
	| INT IDENTIFICATOR ATRIBUIRE expresie SEMICOLON {
			std::string s1($2);
			std::string s2(std::to_string($4));
			afiseazaInterpretareGenerala("Variabila [" + B + s1 + R + A + "] de tip [" + B + "int" + R + A + "] ia valoarea [" 
										+ B + s2 + R + A + "]");
		}
	| STRING IDENTIFICATOR ATRIBUIRE expresie SEMICOLON {
			std::string s1($2);
			std::string s2(std::to_string($4));
			afiseazaInterpretareGenerala("Variabila [" + B + s1 + R + A + "] de tip [" + B + "string" + R + A + "] ia valoarea [" 
								+ B + s2 + R + A + "]");
		}
	| expresie { 
			std::string s1(std::to_string($1));
			afiseazaInterpretareGenerala("Exp [" + B + s1 + R + A + "]");
		}
	| if_else instructiune {}
	| WHILE PD conditie PI AD program AI { 
			if($3){
				afiseazaInterpretareGenerala("Conditia din [" + B + "WHILE" + R + A + "] este [" + B + "TRUE" + R + A +
									"] ==> Se executa corpul din [" + B + "WHILE" + R + A + "]");
				}
			else{
				afiseazaInterpretareGenerala("Conditia din [" + B + "WHILE" + R + A + "] este [" + B + "FALSA" + R + A +
								"] ==> " + B + "NU" + R + A + " se executa corpul din [" + B + "WHILE" + R + A + "]");
				}
			};
	| BREAK SEMICOLON { 
			afiseazaInterpretareGenerala("S-a intalnit [" + B + "BREAK" + R + A + "] in [" + B + "WHILE" + R + A + 
										 "] ==> Se isese din bucla [" + B + "WHILE" + R + A + "]");
		}
	| RETURN expresie SEMICOLON { 
			std::string s1(std::to_string($2));
			afiseazaInterpretareGenerala("Se returneaza valoarea [" + B + s1 + R + A + "]");
		}
	;


expresie:		
	VALOARE_VARIABILA_INT {
		//std::string s1(std::to_string($1));
		//std::string s1("nimic");
		//afiseazaInterpretareGenerala("Valoare de tip INT " + s1);
	}
	| VALOARE_VARIABILA_STRING {
		//std::string s1(std::to_string($1));
		//std::string s1("nimic");
		//afiseazaInterpretareGenerala("Valoare de tip string " + s1);
	}
	| expresie PLUS expresie {
		$$ = $1 + $3;
		afiseazaInterpretareExpresie($$,$1,$3," + ");
	}
	| expresie MINUS expresie {
		$$ = $1 - $3;
		afiseazaInterpretareExpresie($$,$1,$3," - ");
	}
    | expresie INMULTIRE expresie { 
		$$ = $1 * $3;
		afiseazaInterpretareExpresie($$,$1,$3," * ");
	 }
    | '(' expresie ')' { $$ = $2; }
    ;

%%

/*** Implementarea functiilor C++ (main si altele daca este cazul (daca au fost declarate in sectiunea de declaratii)) ***/
void afiseazaInterpretareConditie(int valoare, int stanga, int dreapta, std::string operatie){
	std::cout << Z << "\n[BISON] " << R << A << "Conditia [" << B << stanga << " " << operatie << " " << dreapta << R << A 
			<< "] a fost evaluata  cu valoarea [" << B << valoare << R << A << "]" << R << "\n\n";
}

void afiseazaInterpretareExpresie(int valoare, int stanga, int dreapta, std::string operatie){
    std::cout << Z << "\n[BISON] " << R << A << "Expresia [" << B << stanga << " " << operatie << " " << dreapta << R << A 
		     << "] a fost evaluata  cu valoarea [" << B << valoare << R << A << "]" << R << "\n\n";
}

void afiseazaInterpretareGenerala(std::string interpretare){
	std::cout << Z << "\n[BISON] " << R << A << interpretare << R << "\n\n";
}

void yyerror(char const* msg){
	// printeaza cu rosu eroarea si apoi reseteaza
	std::cout << Z << "\n[BISON] " << R << "\033[31mEroare la linia [" << numarLinii << "]: Mesaj eroare [" << msg << "] " << R << "\n";
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