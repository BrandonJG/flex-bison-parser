%{

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "tabla.h"

extern Lista lista;
extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
Simbolo *crearInt(int valor);
Simbolo *crearFloat(float valor);
Simbolo *crearChar(char valor);
Simbolo *crearString(char* valor);
Simbolo *obtenerSimbolo(char* simbolo);
int sonSimbolosCompatibles(Simbolo* s1, Simbolo* s2);
%}

%define parse.error verbose

%union {
        int ival;
        float fval;
        char cval;
        char string[100];
        Simbolo *simbolo;
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
%token<string> T_ID

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
%type<simbolo> constante_numerica
%type<simbolo> constante_literal
%type<simbolo> termino

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
        : termino operador_relacional termino {
            int tipoDato;
            if ($1 != NULL && $3 != NULL){
                tipoDato = sonSimbolosCompatibles($1, $3);
                switch(tipoDato){
                    case 1: break;
                    case 2: break;
                    case 3: break;
                    case 4: break;
                    default:
                        printf("Comparacion entre tipos de dato no compatibles: ");
                        printf("%s y %s\n", tipoDeDato($1->flag), tipoDeDato($3->flag));
                    break;
                }
            }
        }
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
        : constante_numerica { $$ = $1; }
        | constante_literal { $$ = $1; }
        | T_ID { $$ = obtenerSimbolo($1); }
        ;

constante_numerica
        : expresion_matematica_simple { $$ = crearInt($1); }
        | expresion_matematica_compuesta { $$ = crearFloat($1); }
        ;

constante_literal
        : T_CHAR { $$ = crearChar($1); }
        | T_CADENA {$$ = crearString($1); }
        ;        

declaracion_dato
        : T_WINT T_ID
        | T_WFLOAT T_ID
        | T_WCHAR T_ID
        | T_WSTRING T_ID
        ;

definicion
        : 
        | T_ID T_ASIGN termino {
            int tipoDato;
            Simbolo* termino1 = obtenerSimbolo($1);
            if (termino1 != NULL && $3 != NULL){
                tipoDato = sonSimbolosCompatibles(termino1, $3);
                switch(tipoDato){
                    case 1: break;
                    case 2: break;
                    case 3: break;
                    case 4: break;
                    default:
                        printf("Operacion entre tipos de dato no compatibles: "); 
                        printf("%s y %s\n", tipoDeDato(termino1->flag), tipoDeDato($3->flag));
                    break;
                }
            } 
        }
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

Simbolo *crearInt(int valor){
        Simbolo *nuevo = (Simbolo*) malloc(sizeof(Simbolo));
        strcpy(nuevo->nombre, "__int");
        nuevo->flag = 1;
        nuevo->ival = valor;
        return nuevo;
}

Simbolo *crearFloat(float valor){
        Simbolo *nuevo = (Simbolo*) malloc(sizeof(Simbolo));
        strcpy(nuevo->nombre, "__float");
        nuevo->flag = 2;
        nuevo->fval = valor;
        return nuevo;
}

Simbolo *crearChar(char valor){
        Simbolo *nuevo = (Simbolo*) malloc(sizeof(Simbolo));
        strcpy(nuevo->nombre, "__char");
        nuevo->flag = 3;
        nuevo->string[0] = valor;
        return nuevo;
}

Simbolo *crearString(char* valor){
        Simbolo *nuevo = (Simbolo*) malloc(sizeof(Simbolo));
        strcpy(nuevo->nombre, "__string");
        nuevo->flag = 4;
        strcpy(nuevo->string, valor);
        return nuevo;
}

Simbolo *obtenerSimbolo(char* simbolo){
    Simbolo* buscado = buscar(&lista, simbolo);
    return buscado;
}

int sonSimbolosCompatibles(Simbolo* izq, Simbolo* der){
    if(izq->flag == der->flag){
        return izq->flag;
    } else {
        if(izq->flag == 2 && (der->flag == 1 || der->flag == 2)){
            return 2;
        } else {
            return -1;
        }
    }
    return -1;
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
            printf("Analisis sintactico y semantico correcto!\n");
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