%{

#include "TPSSL.tab.h"
#include <math.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>

%}

CEDECIMAL 	  [1-9][0-9]*
CEOCTAL		  0[0-7]*
CEHEXA		  0[xX][A-Fa-f0-9]+
CREAL	          [0-9]*"."[0-9]+([eE]([\+\-]?)[0-9]+)?
CCARACTER	  ['[ -&\(-~]'|'\\t'|'\\n'|'\\'|'\\0']
TDATO             int|char|float|double|long|short|signed|unsigned|struct|union|void|const
RESERVADA	  auto|continue|register|static|typedef|volatile|enum|extern|goto
ID       	  [a-zA-Z_][a-zA-Z0-9_]*
LITERALCADENA	  \"(\\.|[^\\"])*\"

%%

{CEDECIMAL}       {yylval.c.valor = atoi(yytext); yylval.c.tipo = 1; return NUM;}
{CEOCTAL}         {yylval.c.tipo = 2; strcpy(yylval.c.cadena,yytext); return NUM;}
{CEHEXA}          {yylval.c.tipo = 3; strcpy(yylval.c.cadena,yytext); return NUM;}
{CREAL}           {yylval.c.valor = atof(yytext); yylval.c.tipo = 4; return NUM;}
{CCARACTER}       {yylval.c.caracter = yytext; return CARACTER;}
{TDATO}           {strcpy(yylval.palabra,yytext); return TIPO_DATO;}
{RESERVADA}       {strcpy(yylval.palabra,yytext); return PRESERVADA;}
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
"^"               {return '^';}
"("               {return '(';}
")"               {return ')';}
"\n"              {return '\n';}
[ \t\n]+          /* se come los espacios en blanco */

%%

int main(){
yyout = fopen("salida.txt","w");
yyin = fopen("entrada.txt","r");
yylex();
return0;
}


