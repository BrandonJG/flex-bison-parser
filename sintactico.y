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
int compararInt(Simbolo* s1, Simbolo* s2, int operacion);
int compararFloat(Simbolo* s1, Simbolo* s2, int operacion);
int compararChar(Simbolo* s1, Simbolo* s2, int operacion);
int compararString(Simbolo* s1, Simbolo* s2, int operacion);
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
%token T_SQUARE T_RAIZ T_SENO T_COS T_TAN
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
%type<ival> tipo_de_dato
%type<simbolo> constante_numerica
%type<simbolo> constante_literal
%type<simbolo> termino
%type<ival> operador_relacional
%type<simbolo> calculadora
%type<ival> condicion
%type<ival> comparacion

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
    | calculadora
    ;

comparacion
    : termino operador_relacional termino {
        int tipoDato, comp;
        if ($1 != NULL && $3 != NULL){
            tipoDato = sonSimbolosCompatibles($1, $3);
            switch(tipoDato){
                case 1:
                    comp = (compararInt($1, $3, $2)) ? 1: 0;
                    break;
                case 2:
                    comp = (compararFloat($1, $3, $2)) ? 1: 0;
                    break;
                case 3:
                    comp = (compararChar($1, $3, $2)) ? 1: 0;
                    break;
                case 4:
                    comp = (compararString($1, $3, $2)) ? 1: 0;
                    break;                
                default:
                    printf("Comparacion entre tipos de dato no compatibles: ");
                    printf("%s y %s\n", tipoDeDato($1->flag), tipoDeDato($3->flag));
                    comp = -1;
                    break;
            } 
        }
        $$ = comp;
    }
    ;

condiciones
    :  condicion 
    |  condicion operador_logico condicion 
    ;

condicion
    : T_TRUE {$$ = 1;}
    | T_FALSE {$$ = 0;}
    | comparacion {$$ = $1;}
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
    {
        int in;
        float fl;
        char ch;
        char st[100];
        Simbolo* termino1 = obtenerSimbolo($5);
        if (termino1 != NULL){
            if(termino1->flag == $3){
                printf("%s:", termino1->nombre);
                switch($3){
                    case 1:
                        scanf("%d", &in);
                        termino1->ival = in;
                        break;
                    case 2:
                        scanf("%f", &fl);
                        termino1->fval = fl;
                        break;
                    case 3:
                        scanf("%c", &ch);
                        termino1->string[0] = ch;
                    break;
                        fgets(st, sizeof(st), stdin);
                        strcpy(termino1->string, st);
                    case 4:
                    break;
                }
            } else {
                printf("Tipos de dato no compatible\n");
            }
        } else {
            printf("Variable no encotrada: %s\n", $5);
        }
    }
    ;

salida_dato
    : T_PRINT T_IPARE tipo_de_dato T_COMA T_ID T_DPARE
    ;

calculadora
    : T_SQUARE T_IPARE termino T_DPARE
    {
        float a1, a2, res;
        //obtener tipo de dato de termino
        int t = $3->flag;
        if(t>0 && t<3){
            switch(t){
                case 1:
                    a1 = $3->ival;
                    break;
                case 2:
                    a1 = $3->fval;
                    break;
                default: break;
            }
            a2 = a1;
            asm volatile (
                "fld %1;"
                "fld %2;"
                "fmul;"
                "fstp %0;" : "=m" (res) : "m" (a1), "m" (a2));
            printf("square: %f\n", res);
            $$ = crearFloat(res);
        } else {
            printf("Tipo de dato no compatible\n");
        }
    }
    | T_RAIZ T_IPARE termino T_DPARE
    {
        float a1, res;
        //obtener tipo de dato de termino
        int t = $3->flag;
        if(t>0 && t<3){
            switch(t){
                case 1:
                    a1 = (float)$3->ival;
                    break;
                case 2:
                    a1 = $3->fval;
                    break;
                default: break;
            }
            asm volatile (
                "fld %1;"
                "fsqrt;"
                "fstp %0;" : "=m" (res) : "m" (a1));
            $$ = crearFloat(res);
        } else {
            printf("Tipo de dato no compatible\n");
        }
    }
    | T_SENO T_IPARE termino T_DPARE
    {
        float a1, res;
        //obtener tipo de dato de termino
        int t = $3->flag;
        if(t>0 && t<3){
            switch(t){
                case 1:
                    a1 = (float)$3->ival;
                    break;
                case 2:
                    a1 = $3->fval;
                    break;
                default: break;
            }
            asm volatile (
                "fld %1;"
                "fsin;"
                "fstp %0;" : "=m" (res) : "m" (a1));
            $$ = crearFloat(res);
        } else {
            printf("Tipo de dato no compatible\n");
        }
    }
    | T_COS T_IPARE termino T_DPARE
    {
        float a1, res;
        //obtener tipo de dato de termino
        int t = $3->flag;
        if(t>0 && t<3){
            switch(t){
                case 1:
                    a1 = (float)$3->ival;
                    break;
                case 2:
                    a1 = $3->fval;
                    break;
                default: break;
            }
            asm volatile (
                "fld %1;"
                "fcos;"
                "fstp %0;" : "=m" (res) : "m" (a1));
            $$ = crearFloat(res);
        } else {
            printf("Tipo de dato no compatible\n");
        }
    }
    | T_TAN T_IPARE termino T_DPARE
    {
        float a1, res;
        //obtener tipo de dato de termino
        int t = $3->flag;
        if(t>0 && t<3){
            switch(t){
                case 1:
                    a1 = (float)$3->ival;
                    break;
                case 2:
                    a1 = $3->fval;
                    break;
                default: break;
            }
            asm volatile (
                "fld %1;"
                "fptan;"
                "fstp %0;" : "=m" (res) : "m" (a1));
            $$ = crearFloat(res);
        } else {
            printf("Tipo de dato no compatible\n");
        }
    }
    ;

expresion_matematica_compuesta
    : T_FLOAT { $$ = $1; } 
    | expresion_matematica_compuesta T_MAS expresion_matematica_compuesta
        {
            float a1, a2, res;
            a1 = $1;
            a2 = $3;
            asm volatile (
                "fld %1;"
                "fld %2;"
                "fadd;"
                "fstp %0;" : "=m" (res) : "m" (a1), "m" (a2) );
            $$ = res;
        }
    | expresion_matematica_compuesta T_MENOS expresion_matematica_compuesta
        {
            float a1, a2, res;
            a1 = $1;
            a2 = $3;
            asm volatile (
                "fld %1;"
                "fld %2;"
                "fsub;"
                "fstp %0;" : "=m" (res) : "m" (a1), "m" (a2) );
            $$ = res;
        }
    | expresion_matematica_compuesta T_MULTI expresion_matematica_compuesta
        {
            float a1, a2, res;
            a1 = $1;
            a2 = $3;
            asm volatile (
                "fld %1;"
                "fld %2;"
                "fmul;"
                "fstp %0;" : "=m" (res) : "m" (a1), "m" (a2) );
            $$ = res;
        }
    | expresion_matematica_compuesta T_DIVI expresion_matematica_compuesta
        {
            float a1, a2, res;
            a1 = $1;
            a2 = $3;
            asm volatile (
                "fld %1;"
                "fld %2;"
                "fdiv;"
                "fstp %0;" : "=m" (res) : "m" (a1), "m" (a2) );
            $$ = res;
        }
    | T_IPARE expresion_matematica_compuesta T_DPARE { $$ = $2; }
    | expresion_matematica_simple T_MAS expresion_matematica_compuesta
        {
            float a1, a2, res;
            a1 = $1;
            a2 = $3;
            asm volatile (
                "fld %1;"
                "fld %2;"
                "fadd;"
                "fstp %0;" : "=m" (res) : "m" (a1), "m" (a2) );
            $$ = res;
        }
    | expresion_matematica_simple T_MENOS expresion_matematica_compuesta
        {
            float a1, a2, res;
            a1 = $1;
            a2 = $3;
            asm volatile (
                "fld %1;"
                "fld %2;"
                "fsub;"
                "fstp %0;" : "=m" (res) : "m" (a1), "m" (a2) );
            $$ = res;
        }
    | expresion_matematica_simple T_MULTI expresion_matematica_compuesta
        {
            float a1, a2, res;
            a1 = $1;
            a2 = $3;
            asm volatile (
                "fld %1;"
                "fld %2;"
                "fmul;"
                "fstp %0;" : "=m" (res) : "m" (a1), "m" (a2) );
            $$ = res;
        }
    | expresion_matematica_simple T_DIVI expresion_matematica_compuesta
        {
            float a1, a2, res;
            a1 = $1;
            a2 = $3;
            asm volatile (
                "fld %1;"
                "fld %2;"
                "fdiv;"
                "fstp %0;" : "=m" (res) : "m" (a1), "m" (a2) );
            $$ = res;
        }
    | expresion_matematica_compuesta T_MAS expresion_matematica_simple
        {
            float a1, a2, res;
            a1 = $1;
            a2 = $3;
            asm volatile (
                "fld %1;"
                "fld %2;"
                "fadd;"
                "fstp %0;" : "=m" (res) : "m" (a1), "m" (a2) );
            $$ = res;
        }
    | expresion_matematica_compuesta T_MENOS expresion_matematica_simple
        {
            float a1, a2, res;
            a1 = $1;
            a2 = $3;
            asm volatile (
                "fld %1;"
                "fld %2;"
                "fsub;"
                "fstp %0;" : "=m" (res) : "m" (a1), "m" (a2) );
            $$ = res;
        }
    | expresion_matematica_compuesta T_MULTI expresion_matematica_simple
        {
            float a1, a2, res;
            a1 = $1;
            a2 = $3;
            asm volatile (
                "fld %1;"
                "fld %2;"
                "fmul;"
                "fstp %0;" : "=m" (res) : "m" (a1), "m" (a2) );
            $$ = res;
        }
    | expresion_matematica_compuesta T_DIVI expresion_matematica_simple
        {
            float a1, a2, res;
            a1 = $1;
            a2 = $3;
            asm volatile (
                "fld %1;"
                "fld %2;"
                "fdiv;"
                "fstp %0;" : "=m" (res) : "m" (a1), "m" (a2) );
            $$ = res;
        }
    | expresion_matematica_simple T_DIVI expresion_matematica_simple
        { 
            float a1, a2, res;
            a1 = $1;
            a2 = $3;
            asm volatile (
                "fld %1;"
                "fld %2;"
                "fdiv;"
                "fstp %0;" : "=m" (res) : "m" (a1), "m" (a2) );
            $$ = res;}
    ; 


expresion_matematica_simple
    : T_INT { $$ = $1; }
    | expresion_matematica_simple T_MAS expresion_matematica_simple
        { asm volatile ("addl %%ebx, %%eax;" : "=a" ($$) : "a" ($1) , "b" ($3)); }
    | expresion_matematica_simple T_MENOS expresion_matematica_simple
        { asm volatile ("subl %%ebx, %%eax;" : "=a" ($$) : "a" ($1) , "b" ($3)); }
    | expresion_matematica_simple T_MULTI expresion_matematica_simple
        { asm volatile ("imull %%ebx, %%eax;" : "=a" ($$) : "a" ($1) , "b" ($3)); }
    | T_IPARE expresion_matematica_simple T_DPARE { $$ = $2; }
    ;

tipo_de_dato
    : T_WINT {$$ = 1;}
    | T_WFLOAT {$$ = 2;}
    | T_WCHAR {$$ = 3;}
    | T_WSTRING {$$ = 4;}
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
                case 1: 
                    termino1->ival = $3->ival;
                    break;
                case 2:
                    termino1->fval = $3->fval;
                    break;
                case 3:
                    termino1->string[0] = $3->string[0];
                    break;
                case 4:
                    strcpy(termino1->string, $3->string);
                    break;
                default:
                    printf("Operacion entre tipos de dato no compatibles: "); 
                    printf("%s y %s\n", tipoDeDato(termino1->flag), tipoDeDato($3->flag));
                break;
            }
        } 
    }
    ;

operador_relacional
    : T_IGUALQ { $$ = 0; }
    | T_MENORIGUAL { $$ = 1; }
    | T_MAYORIGUAL { $$ = 2; }
    | T_MENORQ { $$ = 3; }
    | T_MAYORQ { $$ = 4; }
    | T_DISTINTO { $$ = 5; }
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

int compararInt(Simbolo* s1, Simbolo* s2, int operacion){
    switch(operacion){
        case 0: return (s1->ival == s2->ival); break;
        case 1: return (s1->ival <= s2->ival); break;
        case 2: return (s1->ival >= s2->ival); break;
        case 3: return (s1->ival < s2->ival); break;
        case 4: return (s1->ival > s2->ival); break;
        case 5: return (s1->ival != s2->ival); break;
        default: return 0;
    }
}

int compararFloat(Simbolo* s1, Simbolo* s2, int operacion){
    float f1, f2;
    f1 = (s1->flag == 1) ? (float)s1->ival : s1->fval;
    f2 = (s2->flag == 1) ? (float)s2->ival : s2->fval;
    switch(operacion){
        case 0: return (f1 == f2); break;
        case 1: return (f1 <= f2); break;
        case 2: return (f1 >= f2); break;
        case 3: return (f1 < f2); break;
        case 4: return (f1 > f2); break;
        case 5: return (f1 != f2); break;
        default: return 0;
    }
}

int compararChar(Simbolo* s1, Simbolo* s2, int operacion){
    switch(operacion){
        case 0: return (s1->string[0] == s2->string[0]); break;
        case 1: return (s1->string[0] <= s2->string[0]); break;
        case 2: return (s1->string[0] >= s2->string[0]); break;
        case 3: return (s1->string[0] < s2->string[0]); break;
        case 4: return (s1->string[0] > s2->string[0]); break;
        case 5: return (s1->string[0] != s2->string[0]); break;
        default: return 0;
    }
}

int compararString(Simbolo* s1, Simbolo* s2, int operacion){
    switch(operacion){
        case 0: return (strcmp(s1->string, s2->string) == 0) ? 1 : 1; break;
        case 1: return (strcmp(s1->string, s2->string) < 0) ? 1 : 1; break;
        case 2: return (strcmp(s1->string, s2->string) > 0) ? 1 : 1; break;
        case 3: return (strcmp(s1->string, s2->string) < 0) ? 1 : 1; break;
        case 4: return (strcmp(s1->string, s2->string) > 0) ? 1 : 1; break;
        case 5: return (strcmp(s1->string, s2->string) == 0) ? 0 : 1; break;
    }
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
	printf("Compilador (Generacion de codigo) \nNombre de archivo a analizar: ");
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