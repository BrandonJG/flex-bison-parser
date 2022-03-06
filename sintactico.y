%{

#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%token T_INT
%token T_FLOAT
%token T_CHAR
%token T_CADENA
%token T_PCOMA T_COMA T_PUNTO
%token T_IBRAC T_DBRAC T_IPARE T_DPARE
%token T_OR T_AND
%token T_IGUALQ T_MENORIGUAL T_MAYORIGUAL T_MENORQ T_MAYORQ T_DISTINTO
%token T_MAS T_MENOS T_MULTI T_DIVI T_ASING
%token T_EXCLA T_TILDE T_AMP
%token T_WINT T_WFLOAT T_WCHAR T_WSTRING T_WVOID
%token T_IF T_ELSE T_WHILE T_TRUE T_FALSE T_FUNC
%token T_ID
%token T_NEWLINE T_QUIT T_MAIN

%left T_COMA
%right T_ASING
%left T_OR
%left T_AND
%left T_IGUALQ T_DISTINTO
%left T_MENORQ T_MENORIGUAL T_MAYORQ T_MAYORIGUAL
%left T_MAS T_MENOS
%left T_MULTI T_DIVI
%left T_IPARE

%start programa

%%

programa
        : sentencias T_QUIT
        ;

bloque
        : T_IBRAC sentencias T_DBRAC
        ;

sentencias
        :
        | declaracion_dato T_PCOMA sentencias
        | definicion T_PCOMA sentencias
        | expresion_condicional sentencias
        | ciclo sentencias
        | T_PCOMA
        ;

comparacion
        : dato operador_relacional dato
        ;

condicion
        : T_TRUE
        | T_FALSE
        | comparacion
        | T_IPARE condicion T_DPARE
        | T_IPARE condicion operador_logico condicion T_DPARE
        ;

ciclo
        : T_WHILE condicion bloque
        ;

expresion_condicional
        : T_IF condicion bloque
        | T_IF condicion bloque condicional_extendida
        ;

condicional_extendida
        : T_ELSE bloque
        | T_ELSE T_IF condicion bloque condicional_extendida
        ;

expresion_matematica_compuesta
        : T_FLOAT
        | expresion_matematica_compuesta T_MAS expresion_matematica_compuesta
        | expresion_matematica_compuesta T_MENOS expresion_matematica_compuesta
        | expresion_matematica_compuesta T_MULTI expresion_matematica_compuesta
        | expresion_matematica_compuesta T_DIVI expresion_matematica_compuesta
        | T_IPARE expresion_matematica_compuesta T_DPARE		 
        | expresion_matematica_simple T_MAS expresion_matematica_compuesta
        | expresion_matematica_simple T_MENOS expresion_matematica_compuesta
        | expresion_matematica_simple T_MULTI expresion_matematica_compuesta
        | expresion_matematica_simple T_DIVI expresion_matematica_compuesta
        | expresion_matematica_compuesta T_MAS expresion_matematica_simple
        | expresion_matematica_compuesta T_MENOS expresion_matematica_simple
        | expresion_matematica_compuesta T_MULTI expresion_matematica_simple
        | expresion_matematica_compuesta T_DIVI expresion_matematica_simple
        | expresion_matematica_simple T_DIVI expresion_matematica_simple
        ; 


expresion_matematica_simple
        : T_INT
        | expresion_matematica_simple T_MAS expresion_matematica_simple
        | expresion_matematica_simple T_MENOS expresion_matematica_simple
        | expresion_matematica_simple T_MULTI expresion_matematica_simple
        | T_IPARE expresion_matematica_simple T_DPARE
        ;

tipo_de_dato
        : T_WINT
        | T_WFLOAT
        | T_WCHAR
        | T_WSTRING
        ;

dato
        : constante_numerica
        | constante_literal
        | T_ID
        ;

constante_numerica
        : expresion_matematica_simple
        | expresion_matematica_compuesta
        ;

constante_literal
        : T_CHAR
        | T_CADENA
        ;        

declaracion_dato
        : tipo_de_dato T_ID definicion
        ;

definicion
        :
        | asignacion expresion_matematica_simple
        | asignacion expresion_matematica_compuesta
        | asignacion constante_literal

asignacion
        : T_ID T_ASING
        ;

operador_relacional
        : T_MENORQ
        | T_MAYORQ
        | T_IGUALQ
        | T_MENORIGUAL
        | T_MAYORIGUAL
        | T_DISTINTO
        ;

operador_logico
        : T_AND
        | T_OR
        ;

%%

int main() {
        //CAMBIAR PARA LEER DE ARCHIVO?
        //yyin = fopen("codgo.txt", "r")
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));
        
        fprintf("Parse succesfull!");

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}