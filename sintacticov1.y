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
%token T_IBRAC T_DBRAC T_IBRAK T_DBRAK T_IPARE T_DPARE
%token T_OR T_AND
%token T_IGUALQ T_MENORIGUAL T_MAYORIGUAL T_MENORQ T_MAYORQ T_DISTINTO
%token T_MAS T_MENOS T_MULTI T_DIVI T_ASING
%token T_EXCLA T_TILDE T_AMP
%token T_WINT T_WFLOAT T_WCHAR T_WSTRING T_WVOID
%token T_IF T_ELSE T_RETURN T_WHILE
%token T_ID
%token T_NEWLINE T_QUIT

%start programa

%%

programa
		:
		| declaracion_externa
		| programa declaracion_externa
		| T_QUIT T_NEWLINE {printf("Fin de cadena!\n"); exit(0)}
		;

declaracion_externa
		: definicion_funcion
		| declaracion
		;

definicion_funcion
		: especificador_declaracion declarador lista_declaraciones declaracion_compuesta
		| especificador_declaracion declarador declaracion_compuesta
		;

lista_declaraciones
		: declaracion
		| lista_declaraciones declaracion
		;

declaracion
		: especificador_declaracion T_PCOMA
		| especificador_declaracion lista_inicializadores_declaraciones T_PCOMA	
		;

especificador_declaracion
		: especificador_tipo especificador_declaracion
		| especificador_tipo
		;

lista_inicializadores_declaraciones
		: inicializador_declaracion
		| lista_inicializadores_declaraciones T_COMA inicializador_declaracion
		;

inicializador_declaraciones
		: declarador T_ASING inicializador
		| declarador
		;

declarador
		: T_ID
		| T_IPARE declarador T_DPARE
		| declarador T_IPARE lista_identificadores T_DPARE
		;

lista_identificadores
		: T_ID
		| lista_declaraciones T_COMA T_ID
		;

inicializador
		: T_IBRAC lista_inicializadores T_DBRAC
		| T_IBRAC lista_inicializadores T_COMA T_DBRAC
		| expresion_asignacion
		;

lista_inicializadores
		: designacion inicializador
		| inicializador
		| lista_inicializadores T_COMA designacion inicializador
		| lista_inicializadores T_COMA inicializador
		;

designacion
		: lista_designadores T_ASING
		;

lista_designadores
		: designador
		| lista_designadores designador
		;

designador
		: T_IBRAK expresion_constante T_DBRAK
		| T_PUNTO T_ID
		;

expresion_constante
		: expresion_condicional
		;

expresion_condicional
		:
		;

expresiones
		: 
		| definicion
		| declaracion
		;

especificador_tipo
		: T_WINT
		| T_WFLOAT
		| T_WCHAR
		| T_WSTRING
		| T_WVOID
		;

operador_logico
		: T_OR
		| T_AND
		;

operador_aritmetico
		: T_MAS
		| T_MENOS
		| T_MULTI
		| T_DIVI
		;

operador_relacional
		: T_IGUALQ
		| T_MENORQ
		| T_MAYORQ
		| T_MENORIGUAL
		| T_MAYORIGUAL
		| T_DISTINTO
		;

operando
		: T_ID
		| T_INT
		| T_FLOAT
		;


operando_literal
		: T_ID
		| T_CADENA
		| T_CHAR
		;

%%

int main() {
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}