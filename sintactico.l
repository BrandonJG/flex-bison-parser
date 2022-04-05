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
{CARAC}     {return T_CHAR;}
{CADENA}    {return T_CADENA;}
";"         {return T_PCOMA;}
","         {return T_COMA;}
"{"         {return T_IBRAC;}
"}"         {return T_DBRAC;}
"||"        {return T_OR;}
"&&"        {return T_AND;}
"!="        {return T_DISTINTO;}
"=="        {return T_IGUALQ;}
"<="        {return T_MENORIGUAL;}
">="        {return T_MAYORIGUAL;}
"="         {return T_ASIGN;}
"<"         {return T_MENORQ;}
">"         {return T_MAYORQ;}
"+"         {return T_MAS;}
"-"         {return T_MENOS;}
"*"         {return T_MULTI;}
"/"         {return T_DIVI;}
"("         {return T_IPARE;}
")"         {return T_DPARE;}
"int"       {ultimoTipoDato = 1; return T_WINT;}
"float"     {ultimoTipoDato = 2; return T_WFLOAT;}
"char"      {ultimoTipoDato = 3; return T_WCHAR;}
"string"    {ultimoTipoDato = 4; return T_WSTRING;}
"void"      {return T_WVOID;}
"if"        {return T_IF;}
"else"      {return T_ELSE;}
"while"     {return T_WHILE;}
"true"      {return T_TRUE;}
"false"     {return T_FALSE;}
"print"     {return T_PRINT;}
"scan"      {return T_SCAN;}

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
                    }
                } else {
                    if(buscado == NULL){
                        printf("%s: Intentando usar variable no declarada.\n", yytext);
                    } else {
                        strcpy(yylval.string, yytext);
                        return T_ID;
                    }
                }
            }
.           {showError();}

%%

void showError(){
    printf("Entrada no en lexico");
}