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
{DIGITO}+\.{DIGITO}+ 	{yylval.fval = atof(yytext); return T_FLOAT;}
{DIGITO}+		{yylval.ival = atoi(yytext); return T_INT;}
{CARAC}     {return T_CHAR;}
{CADENA}    {return T_CADENA;}
\n          {return T_NEWLINE;}
";"         {return T_PCOMA;}
"."         {return T_PUNTO;}
","         {return T_COMA;}
"{"         {return T_IBRAC;}
"}"         {return T_DBRAC;}
"||"        {return T_OR;}
"&&"        {return T_AND;}
"!="        {return T_DISTINTO}
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
"&"         {return T_AMP;}
"("         {return T_IPARE;}
")"         {return T_DPARE;}
"~"         {return T_TILDE;}
"!"         {return T_EXCLA;}
"int"       {return T_WINT;}
"float"     {return T_WFLOAT;}
"char"      {return T_WCHAR;}
"string"    {return T_WSTRING;}
"void"      {return T_WVOID;}
"if"        {return T_IF;}
"else"      {return T_ELSE;}
"return"    {return T_RETURN;}
"while"     {return T_WHILE;}
"true"      {return T_TRUE;}
"false"     {return T_FALSE;}
"function"  {return T_FUNC;}

"main"      {return T_MAIN;}
"exit"      {return T_QUIT;}
"quit"      {return T_QUIT;}

{ID}        {return T_ID;}

%%
