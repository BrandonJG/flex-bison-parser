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
%token T_PCOMA T_COMA
%token T_IBRAC T_DBRAC T_IBRAK T_DBRAK T_IPARE T_DPARE
%token T_OR T_AND
%token T_IGUALQ T_MENORIGUAL T_MAYORIGUAL T_MENORQ T_MAYORQ T_DISTINTO
%token T_MAS T_MENOS T_MULTI T_DIVI T_ASING
%token T_WINT T_WFLOAT T_WCHAR T_WSTRING T_WVOID
%token T_IF T_ELSE T_RETURN T_WHILE
%token T_ID
%token T_NEWLINE T_QUIT

%start programa

%%

programa
		:
		| expresiones
		;

expresiones
		: 
		| definicion
		| declaracion

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