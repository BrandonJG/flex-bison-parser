%{

#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%define parse.error verbose

%union {
        int ival;
        float fval;
}

%token<ival> T_INT
%token<fval> T_FLOAT
%token T_CHAR
%token T_CADENA
%token T_PCOMA T_COMA T_PUNTO
%token T_IBRAC T_DBRAC T_IPARE T_DPARE
%token T_OR T_AND
%token T_IGUALQ T_MENORIGUAL T_MAYORIGUAL T_MENORQ T_MAYORQ T_DISTINTO
%token T_MAS T_MENOS T_MULTI T_DIVI T_ASIGN
%token T_EXCLA T_TILDE T_AMP
%token T_WINT T_WFLOAT T_WCHAR T_WSTRING T_WVOID
%token T_IF T_ELSE T_WHILE T_TRUE T_FALSE T_FUNC
%token T_ID
%token T_QUIT T_MAIN T_ERROR

%left T_COMA
%right T_ASIGN
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
        : sentencias
        ;

bloque
        : T_IBRAC sentencias T_DBRAC
        ;

sentencias
        : 
        | sentencia T_PCOMA sentencias
        ;

sentencia
        : declaracion_dato
        | definicion
        | expresion_condicional
        | ciclo
        ;

comparacion
        : dato operador_relacional dato
        ;

condiciones
        :  condicion 
        |  condicion operador_logico condicion 
        ;

condicion
        : T_TRUE
        | T_FALSE
        | comparacion
        ;

ciclo
        : T_WHILE condiciones bloque
        ;

expresion_condicional
        : T_IF T_IPARE condiciones T_DPARE bloque
        | T_IF T_IPARE condiciones T_DPARE bloque condicional_extendida
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
        : tipo_de_dato definicion
        ;

definicion
        : 
        | asignacion expresion_matematica_simple
        | asignacion expresion_matematica_compuesta
        | asignacion constante_literal
        | asignacion T_ID;
        | T_ID
        ;

asignacion
        : T_ID T_ASIGN
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
	yyin = fopen("q4.txt","r");
        if(yyin)
        {
                yyparse();
                printf("Analisis sintactico correcto!\n");
        }
        else{
                printf("Error al abrir el archivo");
        }
	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Error en analisis sintactico: %s\n", s);
	exit(1);
}