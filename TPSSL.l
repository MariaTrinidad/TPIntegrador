%{

#include "TPSSL.tab.h"
#include <stdlib.h>
#include <ctype.h>
#include <stdio.h>

%}

CEDECIMAL 	[1-9][0-9]*
CEOCTAL		0[0-7]*
CEHEXA		0[xX][A-Fa-f0-9]+
CREAL	        [0-9]*"."[0-9]+([eE]([\+\-]?)[0-9]+)?
CCARACTER	['[ -&\(-~]'|'\\t'|'\\n'|'\\'|'\\0']
TDATO           int|char|float|double| etc... (poner los demas)
PRESERVADA	auto|break|case|char|const|continue|default|do|int|long|register|return|short|signed|sizeof|static|struct|awitch|typedef|union|unsigned|void|volatile|while|double|else|enum|extern|float|for|goto|if
ID       	[a-zA-Z_][a-zA-Z0-9_]*
LITERALCADENA	[\"([ -!#-~]*|\\\")*\"]

%%

{CEDECIMAL}       {yylval.c.valor = atoi(yytext); yylval.c.tipo = 1; return NUM;}
{CEOCTAL}         {yylval.c.tipo = 2; strcpy(yylval.c.cadena,yytext); return NUM;}
{CEHEXA}          {yylval.c.tipo = 3; strcpy(yylval.c.cadena,yytext); return NUM;}
{CREAL}           {yylval.c.valor = atof(yytext); yylval.c.tipo = 4; return NUM;}
{CCARACTER}       {strcpy(yylval.c.caracter,yytext; yylval.c.tipo = 4); return CARACTER;}
{TDATO}           {strcpy(yylval.c.cadena,yytext; yylval.c.tipo = 1); return TDATO;}
{PRESERVADA}      {strcpy(yylval.c.cadena,yytext; yylval.c.tipo = 2); return PRESERVADA;}
{ID}              {strcpy(yylval.c.cadena,yytext; yylval.c.tipo = 3); return IDENTIFICADOR;}
{LITERALCADENA}   {strcpy(yylval.c.cadena,yytext; yylval.c.tipo = 4); return CADENA;}
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


