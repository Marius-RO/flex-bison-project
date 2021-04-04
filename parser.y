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

%union{
	char name[1000];
	int number;
}

/*** Declararea tokenilor ***/
%token IF ELSE PLUS MINUS SEMICOLON LEFT_SHIFT RIGHT_SHIFT RIGHT_PARENTHESIS LEFT_PARENTHESIS RIGHT_BRACKET LEFT_BRACKET EQUALS ASSIGNMENT MULTIPLICATION LOWER GREATER INCLUDE_DIRECTIVE USING STRING INT WHILE BREAK CONTINUE RETURN
%left EQUAL
%left  PLUS MINUS
%left MULT
%left IF ELSE
%right UNOP

%token <name> IDENTIFIER;
%token <number> INTEGER_VALUE;
%token <name> VALOARE_VARIABILA_STRING;

%type <number> Exp;
%type <number> Condition;
%type <number> Statment;


%start program

/*** Declararea gramaticii si a regulilor pentru gramatica ***/
%%

program: /* EMPTY */ {}
	| program Statment '\n' { /*afiseazaInterpretareGenerala("Se trece la linia urmatoare");*/ }
    ;

ifElse:	
	IF LEFT_PARENTHESIS Condition RIGHT_PARENTHESIS LEFT_BRACKET program RIGHT_BRACKET ELSE LEFT_BRACKET program RIGHT_BRACKET {
			if($3){
				afiseazaInterpretareGenerala("Conditia din [" + B + "IF" + R + A + "] este [" + B + "TRUE" + R + A +
											 "] ==> Se executa corpul din [" + B + "IF" + R + A + "]");
				}
			else{
				afiseazaInterpretareGenerala("Conditia din [" + B + "IF" + R + A + "] este [" + B + "FALSA" + R + A +
											 "] ==> Se executa corpul din [" + B + "ELSE" + R + A + "]");
				}
		};

	| IF LEFT_PARENTHESIS Condition RIGHT_PARENTHESIS LEFT_BRACKET program RIGHT_BRACKET {
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

Condition:
	Exp GREATER Exp { 
			$$ = $1 > $3? 1: 0;
			afiseazaInterpretareConditie($$,$1,$3," > ");
		}
	| Exp LOWER Exp {
			$$ =  $1 < $3? 1: 0;
			afiseazaInterpretareConditie($$,$1,$3," < ");
		}
	| Exp EQUALS Exp {
			$$ = $1 == $3? 1: 0;
			afiseazaInterpretareConditie($$,$1,$3," == ");
		}
	| INTEGER_VALUE { 
			$$ = $1;
			afiseazaInterpretareGenerala("Este evaluata valoarea intreaga");
		}
	;

Statment: /*empty*/ {}
	| INCLUDE_DIRECTIVE LOWER IDENTIFIER GREATER { 
		    std::string s($3);
			afiseazaInterpretareGenerala("Se include directiva [" + B + s + R + A + "]");
		}
	| USING IDENTIFIER IDENTIFIER SEMICOLON {
			std::string s1($2);
			std::string s2($3);
			afiseazaInterpretareGenerala("Se foloseste [" + B + s1 + R + A + "] [" + B + s2 + R + A + "]");
		}
	| INT IDENTIFIER LEFT_PARENTHESIS RIGHT_PARENTHESIS LEFT_BRACKET program RIGHT_BRACKET { 
			std::string s1($2);
			afiseazaInterpretareGenerala("Se defineste functia [" + B + s1 + R + A + "] de tip [" + B + "int" + R + A + "]");
		}
	| INT IDENTIFIER ASSIGNMENT Exp SEMICOLON {
			std::string s1($2);
			std::string s2(std::to_string($4));
			afiseazaInterpretareGenerala("Variabila [" + B + s1 + R + A + "] de tip [" + B + "int" + R + A + "] ia valoarea [" 
										+ B + s2 + R + A + "]");
		}
	| STRING IDENTIFIER ASSIGNMENT Exp SEMICOLON {
			std::string s1($2);
			std::string s2(std::to_string($4));
			afiseazaInterpretareGenerala("Variabila [" + B + s1 + R + A + "] de tip [" + B + "string" + R + A + "] ia valoarea [" 
								+ B + s2 + R + A + "]");
		}
	| Exp { 
			std::string s1(std::to_string($1));
			afiseazaInterpretareGenerala("Exp [" + B + s1 + R + A + "]");
		}
	| ifElse Statment {}
	| WHILE LEFT_PARENTHESIS Condition RIGHT_PARENTHESIS LEFT_BRACKET program RIGHT_BRACKET { 
			if($3){
				afiseazaInterpretareGenerala("Conditia din [" + B + "EHILE" + R + A + "] este [" + B + "TRUE" + R + A +
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
	| RETURN Exp SEMICOLON { 
			std::string s1(std::to_string($2));
			afiseazaInterpretareGenerala("Se returneaza valoarea [" + B + s1 + R + A + "]");
		}
	;


Exp:		
	INTEGER_VALUE {
		//std::string s1(std::to_string($1));
		//std::string s1("nimic");
		//afiseazaInterpretareGenerala("Valoare de tip INT " + s1);
	}
	| VALOARE_VARIABILA_STRING {
		//std::string s1(std::to_string($1));
		//std::string s1("nimic");
		//afiseazaInterpretareGenerala("Valoare de tip string " + s1);
	}
	| Exp PLUS Exp {
		$$ = $1 + $3;
		afiseazaInterpretareExpresie($$,$1,$3," + ");
	}
	| Exp MINUS Exp {
		$$ = $1 - $3;
		afiseazaInterpretareExpresie($$,$1,$3," - ");
	}
    | Exp MULTIPLICATION Exp { 
		$$ = $1 * $3;
		afiseazaInterpretareExpresie($$,$1,$3," * ");
	 }
    | '(' Exp ')' { $$ = $2; }
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
	std::cout << Z << "\n[BISON] " << R << "\033[31mEroare la linia [" << numarLinii << "]: Tokenul [" << msg << "] " << R;
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