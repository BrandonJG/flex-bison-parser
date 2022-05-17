%option noyywrap

%{
#include <stdio.h>
#include <string.h>
#include "tabla.h"
#include "y.tab.h"
#define YY_DECL int yylex()

void showError();
int ultimoTipoDato = -1;
Lista lista = {NULL, 0};
%}

CARAC \'[^\n']\'
CADENA \"[^\n"]+\"
ID [a-zA-Z][a-zA-Z0-9_]*

%%

[ \t\n]+	; // ignore all whitespace
[0-9]+\.[0-9]+  {yylval.fval = atof(yytext); return T_FLOAT;}
[0-9]+      {yylval.ival = atoi(yytext); return T_INT;}
{CARAC}     {ultimoTipoDato = -1; return T_CHAR;}
{CADENA}    {ultimoTipoDato = -1; return T_CADENA;}
";"         {ultimoTipoDato = -1; return T_PCOMA;}
","         {ultimoTipoDato = -1; return T_COMA;}
"{"         {ultimoTipoDato = -1; return T_IBRAC;}
"}"         {ultimoTipoDato = -1; return T_DBRAC;}
"||"        {ultimoTipoDato = -1; return T_OR;}
"&&"        {ultimoTipoDato = -1; return T_AND;}
"!="        {ultimoTipoDato = -1; return T_DISTINTO;}
"=="        {ultimoTipoDato = -1; return T_IGUALQ;}
"<="        {ultimoTipoDato = -1; return T_MENORIGUAL;}
">="        {ultimoTipoDato = -1; return T_MAYORIGUAL;}
"="         {ultimoTipoDato = -1; return T_ASIGN;}
"<"         {ultimoTipoDato = -1; return T_MENORQ;}
">"         {ultimoTipoDato = -1; return T_MAYORQ;}
"+"         {ultimoTipoDato = -1; return T_MAS;}
"-"         {ultimoTipoDato = -1; return T_MENOS;}
"*"         {ultimoTipoDato = -1; return T_MULTI;}
"/"         {ultimoTipoDato = -1; return T_DIVI;}
"("         {ultimoTipoDato = -1; return T_IPARE;}
")"         {ultimoTipoDato = -1; return T_DPARE;}
"int"       {ultimoTipoDato = 1; return T_WINT;}
"float"     {ultimoTipoDato = 2; return T_WFLOAT;}
"char"      {ultimoTipoDato = 3; return T_WCHAR;}
"string"    {ultimoTipoDato = 4; return T_WSTRING;}
"void"      {ultimoTipoDato = -1; return T_WVOID;}
"if"        {ultimoTipoDato = -1; return T_IF;}
"else"      {ultimoTipoDato = -1; return T_ELSE;}
"while"     {ultimoTipoDato = -1; return T_WHILE;}
"true"      {ultimoTipoDato = -1; return T_TRUE;}
"false"     {ultimoTipoDato = -1; return T_FALSE;}
"print"     {ultimoTipoDato = -1; return T_PRINT;}
"scan"      {ultimoTipoDato = -1; return T_SCAN;}
"cuadrado"  {ultimoTipoDato = -1; return T_SQUARE;}
"raiz"      {ultimoTipoDato = -1; return T_RAIZ;}
"seno"      {ultimoTipoDato = -1; return T_SENO;}
"cos"       {ultimoTipoDato = -1; return T_COS;}
"tan"       {ultimoTipoDato = -1; return T_TAN;}

{ID}        {
                Simbolo *buscado = buscar(&lista, yytext);
                if(ultimoTipoDato != -1){
                    if(buscado == NULL){
                        Simbolo simbolo;
                        strcpy(simbolo.nombre, yytext);
                        simbolo.flag = ultimoTipoDato;
                        insertar(&lista, &simbolo);
                        strcpy(yylval.string, yytext);
                        ultimoTipoDato = -1;
                        return T_ID;
                    } else {
                        printf("%s: tiene dos declaraciones. Antes declarada como: %s, ahora como: %s\n",
                        yytext, tipoDeDato(buscado->flag), tipoDeDato(ultimoTipoDato));
                        ultimoTipoDato = -1;
                        return T_ID;
                    }
                } else {
                    if(buscado == NULL){
                        printf("%s: Intentando usar variable no declarada.\n", yytext);
                        return T_ID;
                    } else {
                        strcpy(yylval.string, yytext);
                        return T_ID;
                    }
                }
            }
.           {ultimoTipoDato = -1; showError();}

%%

void showError(){
    printf("Entrada no en lexico");
}