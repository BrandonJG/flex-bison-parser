%option noyywrap

%{
#include <stdio.h>
#include <string.h>
#define YY_DECL int yylex()

#include "sintactico.tab.h"

int nwords = 0;
void showError();

%}

CARAC \'[^\n']\'
CADENA \"[^\n"]+\"
ID [a-zA-Z][a-zA-Z0-9_]*

%%

[ \t\n]+	; // ignore all whitespace
[0-9]+\.[0-9]+  {nwords++; yylval.fval = atof(yytext); return T_FLOAT;}
[0-9]+      {nwords++; yylval.ival = atoi(yytext); return T_INT;}
{CARAC}     {nwords++; return T_CHAR;}
{CADENA}    {nwords++; return T_CADENA;}
";"         {nwords++; return T_PCOMA;}
"."         {nwords++; return T_PUNTO;}
","         {nwords++; return T_COMA;}
"{"         {nwords++; return T_IBRAC;}
"}"         {nwords++; return T_DBRAC;}
"||"        {nwords++; return T_OR;}
"&&"        {nwords++; return T_AND;}
"!="        {nwords++; return T_DISTINTO;}
"=="        {nwords++; return T_IGUALQ;}
"<="        {nwords++; return T_MENORIGUAL;}
">="        {nwords++; return T_MAYORIGUAL;}
"="         {nwords++; return T_ASIGN;}
"<"         {nwords++; return T_MENORQ;}
">"         {nwords++; return T_MAYORQ;}
"+"         {nwords++; return T_MAS;}
"-"         {nwords++; return T_MENOS;}
"*"         {nwords++; return T_MULTI;}
"/"         {nwords++; return T_DIVI;}
"&"         {nwords++; return T_AMP;}
"("         {nwords++; return T_IPARE;}
")"         {nwords++; return T_DPARE;}
"~"         {nwords++; return T_TILDE;}
"!"         {nwords++; return T_EXCLA;}
"int"       {nwords++; return T_WINT;}
"float"     {nwords++; return T_WFLOAT;}
"char"      {nwords++; return T_WCHAR;}
"string"    {nwords++; return T_WSTRING;}
"void"      {nwords++; return T_WVOID;}
"if"        {nwords++; return T_IF;}
"else"      {nwords++; return T_ELSE;}
"while"     {nwords++; return T_WHILE;}
"true"      {nwords++; return T_TRUE;}
"false"     {nwords++; return T_FALSE;}
"function"  {nwords++; return T_FUNC;}

"main"      {nwords++; return T_MAIN;}
"exit"      {nwords++; return T_QUIT;}
"quit"      {nwords++; return T_QUIT;}

{ID}        {nwords++; return T_ID;}
.           {showError(); return T_ERROR;}

%%

void showError(){
    printf("Entrada no en lexico");
}