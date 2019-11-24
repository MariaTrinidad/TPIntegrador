%{

#include "TPSSL.tab.h"
#include <math.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>

%}

%option yylineno

CEDECIMAL 	  [1-9][0-9]*
CEOCTAL		  0[0-7]*
CEHEXA		  0[xX][A-Fa-f0-9]+
CREAL	          [0-9]*"."[0-9]+([eE]([\+\-]?)[0-9]+)?
CCARACTER	  '[ -&\(-~]'|'\\t'|'\\n'|'\\'|'\\0'
TDATO             int|char|float|double|long|short|signed|unsigned|struct|union|void|const
RESERVADA	  auto|continue|register|static|typedef|volatile|enum|extern|goto
ID       	  [a-zA-Z_][a-zA-Z0-9_]*
LITERALCADENA	  \"(\\.|[^\\"])*\"

%%

{CEDECIMAL}       {yylval.c.valor = atoi(yytext); yylval.c.tipoDato = 1; yylval.c.tipoOp = 1; return NUM;}
{CEOCTAL}         {strcpy(yylval.c.cadena,yytext); yylval.c.tipoDato = 1; yylval.c.tipoOp = 2; return NUM;}
{CEHEXA}          {strcpy(yylval.c.cadena,yytext); yylval.c.tipoDato = 1; yylval.c.tipoOp = 3; return NUM;}
{CREAL}           {yylval.c.valor = atof(yytext); yylval.c.tipoDato = 1; yylval.c.tipoOp = 4; return NUM;}
{CCARACTER}       {yylval.c.caracter = yytext; yylval.c.tipoDato = 1; yylval.c.tipoOp = 1; return CARACTER;}
{TDATO}           {strcpy(yylval.palabra,yytext); return TIPO_DATO;}
{RESERVADA}       {strcpy(yylval.c.cadena,yytext); return PRESERVADA;}
"if"	          {return IF;}
"do"	          {return DO;}
"while"	          {return WHILE;}
"for"	          {return FOR;}
"else"	          {return ELSE;}
"return"	  {return RETURN;}
"switch"	  {return SWITCH;}
"case"	          {return CASE;}
"break"	          {return BREAK;}
"default"	  {return DEFAULT;}
"sizeof"	  {return SIZEOF;}
{ID}              {strcpy(yylval.c.cadena,yytext); return IDENTIFICADOR;}
{LITERALCADENA}   {strcpy(yylval.c.cadena,yytext); return CADENA;}
","	          {return ',';}
";"               {return ';';}
"."               {return '.';}
"["               {return '[';}
"]"               {return ']';}
"{"               {return '{';}
"}"               {return '}';}
"="               {return '=';}
"+"               {return '+';}
"-"               {return '-';}
"*"               {return '*';}
"/"               {return '/';}
"%"               {return '%';}
"("               {return '(';}
")"               {return ')';}
"<"		  {return MAYOR;}
">"		  {return MENOR;}
"--"		  {return DECREMENTO;}
"*="		  {return PORIGUAL;}
"=="		  {return IGUALDAD2;}
"++"		  {return AUMENTO;}
">="		  {return MAYORIGUAL;}
"<="		  {return MENORIGUAL;}
"+="		  {return AUMENTOIGUAL;}
"&&"		  {return AND;}
"||"		  {return OR;}
"!="		  {return DISTINTO;}
"?"		  {return OPCION;}
"\n"		  {return '\n';}
[ \t\n ]+          /* se come los espacios en blanco */

%%

