%{

#include <stdio.h>
#include <stdlib.h>
#include "tabla.h"

extern Lista lista;
extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%define parse.error verbose

%union {
        int ival;
        float fval;
        char cval;
        char string[100];
        Simbolo simbolo;
}

%token<ival> T_INT
%token<fval> T_FLOAT
%token<cval> T_CHAR
%token<string> T_CADENA
%token T_PCOMA
%token T_IBRAC T_DBRAC T_IPARE T_DPARE
%token T_OR T_AND
%token T_IGUALQ T_MENORIGUAL T_MAYORIGUAL T_MENORQ T_MAYORQ T_DISTINTO
%token T_MAS T_MENOS T_MULTI T_DIVI T_ASIGN
%token T_WINT T_WFLOAT T_WCHAR T_WSTRING T_WVOID
%token T_IF T_ELSE T_WHILE T_TRUE T_FALSE T_PRINT T_SCAN T_FUNC
%token T_ID

%left T_COMA
%right T_ASIGN
%left T_OR
%left T_AND
%left T_IGUALQ T_DISTINTO
%left T_MENORQ T_MENORIGUAL T_MAYORQ T_MAYORIGUAL
%left T_MAS T_MENOS
%left T_MULTI T_DIVI
%left T_IPARE

%type<ival> expresion_matematica_simple
%type<fval> expresion_matematica_compuesta

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
        | entrada_dato
        | salida_dato
        ;

comparacion
        : termino operador_relacional termino
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

entrada_dato
        : T_SCAN T_IPARE tipo_de_dato T_COMA T_ID T_DPARE
        ;

salida_dato
        : T_PRINT T_IPARE tipo_de_dato T_COMA T_ID T_DPARE
        ;

expresion_matematica_compuesta
        : T_FLOAT { $$ = $1; }
        | expresion_matematica_compuesta T_MAS expresion_matematica_compuesta { $$ = $1 + $3; }
        | expresion_matematica_compuesta T_MENOS expresion_matematica_compuesta { $$ = $1 - $3; }
        | expresion_matematica_compuesta T_MULTI expresion_matematica_compuesta { $$ = $1 * $3; }
        | expresion_matematica_compuesta T_DIVI expresion_matematica_compuesta { $$ = $1 / $3; }
        | T_IPARE expresion_matematica_compuesta T_DPARE { $$ = $2; }
        | expresion_matematica_simple T_MAS expresion_matematica_compuesta { $$ = $1 + $3; }
        | expresion_matematica_simple T_MENOS expresion_matematica_compuesta { $$ = $1 - $3; }
        | expresion_matematica_simple T_MULTI expresion_matematica_compuesta { $$ = $1 * $3; }
        | expresion_matematica_simple T_DIVI expresion_matematica_compuesta { $$ = $1 / $3; }
        | expresion_matematica_compuesta T_MAS expresion_matematica_simple { $$ = $1 + $3; }
        | expresion_matematica_compuesta T_MENOS expresion_matematica_simple { $$ = $1 - $3; }
        | expresion_matematica_compuesta T_MULTI expresion_matematica_simple { $$ = $1 * $3; }
        | expresion_matematica_compuesta T_DIVI expresion_matematica_simple { $$ = $1 / $3; }
        | expresion_matematica_simple T_DIVI expresion_matematica_simple { $$ = $1 / (float)$3; }
        ; 


expresion_matematica_simple
        : T_INT { $$ = $1; }
        | expresion_matematica_simple T_MAS expresion_matematica_simple { $$ = $1 + $3; }
        | expresion_matematica_simple T_MENOS expresion_matematica_simple { $$ = $1 - $3; }
        | expresion_matematica_simple T_MULTI expresion_matematica_simple { $$ = $1 * $3; }
        | T_IPARE expresion_matematica_simple T_DPARE { $$ = $2; }
        ;

tipo_de_dato
        : T_WINT
        | T_WFLOAT
        | T_WCHAR
        | T_WSTRING
        ;

termino
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
        : T_WINT T_ID
        | T_WFLOAT T_ID
        | T_WCHAR T_ID
        | T_WSTRING T_ID
        ;

definicion
        : 
        | T_ID T_ASIGN expresion_matematica_simple
        | T_ID T_ASIGN expresion_matematica_compuesta
        | T_ID T_ASIGN constante_literal
        | T_ID T_ASIGN T_ID;
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

Simbolo *obtenerSimbolo(char* simbolo){
    Simbolo* buscado = buscar(&lista, simbolo);
    return buscado;
}

int main() {
    char nombreArchivo[30], c;
	FILE* fl;
	printf("Juarez Gonzalez Brandon Jesus - 218292556\n");
	printf("Analizador Sintactico\nNombre de archivo a analizar: ");
	scanf("%s", nombreArchivo);
	fl = fopen(nombreArchivo,"r");
	yyin = fopen(nombreArchivo,"r");
        if(yyin)
        {
            printf("----------\n");
            c = fgetc(fl);
			while(c != EOF){
				printf("%c", c);
				c = fgetc(fl);
			}
			fclose(fl);
            printf("\n----------\n");
			yyparse();
            printf("Analisis sintactico correcto!\n");
            imprimirLista(&lista);
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