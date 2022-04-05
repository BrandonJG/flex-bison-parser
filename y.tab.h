/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    T_INT = 258,
    T_FLOAT = 259,
    T_CHAR = 260,
    T_CADENA = 261,
    T_PCOMA = 262,
    T_IBRAC = 263,
    T_DBRAC = 264,
    T_IPARE = 265,
    T_DPARE = 266,
    T_OR = 267,
    T_AND = 268,
    T_IGUALQ = 269,
    T_MENORIGUAL = 270,
    T_MAYORIGUAL = 271,
    T_MENORQ = 272,
    T_MAYORQ = 273,
    T_DISTINTO = 274,
    T_MAS = 275,
    T_MENOS = 276,
    T_MULTI = 277,
    T_DIVI = 278,
    T_ASIGN = 279,
    T_WINT = 280,
    T_WFLOAT = 281,
    T_WCHAR = 282,
    T_WSTRING = 283,
    T_WVOID = 284,
    T_IF = 285,
    T_ELSE = 286,
    T_WHILE = 287,
    T_TRUE = 288,
    T_FALSE = 289,
    T_PRINT = 290,
    T_SCAN = 291,
    T_FUNC = 292,
    T_ID = 293,
    T_COMA = 294
  };
#endif
/* Tokens.  */
#define T_INT 258
#define T_FLOAT 259
#define T_CHAR 260
#define T_CADENA 261
#define T_PCOMA 262
#define T_IBRAC 263
#define T_DBRAC 264
#define T_IPARE 265
#define T_DPARE 266
#define T_OR 267
#define T_AND 268
#define T_IGUALQ 269
#define T_MENORIGUAL 270
#define T_MAYORIGUAL 271
#define T_MENORQ 272
#define T_MAYORQ 273
#define T_DISTINTO 274
#define T_MAS 275
#define T_MENOS 276
#define T_MULTI 277
#define T_DIVI 278
#define T_ASIGN 279
#define T_WINT 280
#define T_WFLOAT 281
#define T_WCHAR 282
#define T_WSTRING 283
#define T_WVOID 284
#define T_IF 285
#define T_ELSE 286
#define T_WHILE 287
#define T_TRUE 288
#define T_FALSE 289
#define T_PRINT 290
#define T_SCAN 291
#define T_FUNC 292
#define T_ID 293
#define T_COMA 294

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 24 "sintactico.y"

        int ival;
        float fval;
        char cval;
        char string[100];
        Simbolo *simbolo;

#line 143 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
