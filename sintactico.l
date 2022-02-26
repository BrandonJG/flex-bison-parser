%option noyywrap

%{
#include <stdio.h>

#define YY_DECL int yylex()

#include "sintactico.tab.h"

%}

CARAC \'[^\n']\'
CADENA \"[^\n"]+\"
DIGITO [0-9]
ID [a-zA-Z][a-zA-Z0-9_]+

%%

[ \t]	; // ignore all whitespace
{DIGITO}+\.{DIGITO}}+ 	{yylval.fval = atof(yytext); return T_FLOAT;}
{DIGITO}+		{yylval.ival = atoi(yytext); return T_INT;}
\n		{return T_NEWLINE;}
";"		{return T_PCOMA;}
","		{return T_COMA;}
"{"		{return T_IBRAC;}
"}"		{return T_DBRAC;}
"||"	{return T_OR;}
"&&"	{return T_AND;}
"[" 	{return T_IBRAK;}
"]"	    {return T_DBRAK;}
"=="    {return T_IGUALQ;}
"<="    {return T_MENORIGUAL;}
">="    {return T_MAYORIGUAL;}
"="    {return T_ASIGN;}
"<"    {return T_MENORQ;}
">"    {return T_MAYORQ;}
"+"		{return T_MAS;}
"-"		{return T_MENOS;}
"*"		{return T_MULTI;}
"/"		{return T_DIVI;}
"("		{return T_IZQ;}
")"		{return T_DERE;}

"exit"		{return T_QUIT;}
"quit"		{return T_QUIT;}


%%