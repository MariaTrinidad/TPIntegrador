%{
#include <math.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>
#define YYDEBUG 1
extern FILE *yyin;
extern FILE *yyout;
int flag_error=0;
%}

%union { 
  struct {
    char caracter;
    char cadena[50];
    float  valor;
    int  tipo;
    } c;
  int entero;
  char palabra[10];
}

%token <c> NUM
%token <c> CARACTER
%token <c> CADENA
%token <c> IDENTIFICADOR
%token <c> PRESERVADA
%token <palabra> TIPO_DATO
%token <palabra> IF
%token <palabra> DO
%token <palabra> WHILE
%token <palabra> FOR
%token <palabra> ELSE
%token <palabra> RETURN
%token <palabra> SWITCH
%token <palabra> CASE
%token <palabra> BREAK
%token <palabra> DEFAULT
%token <palabra> SIZEOF
%token <entero> error

%type <c> identificadorA
%type <c> expPrimaria

%left '+'
%right '*' '/'
%nonassoc '^'

%expect 5

%% /* A continuación las reglas gramaticales y las acciones */

input:    /* vacío */
        | input line
;

line:     '\n'
        | declaracionFuncion '\n'
;      

declaracionFuncion: 	  TIPO_DATO IDENTIFICADOR '(' listaDeclaraciones ')' sentenciaCompuesta ';'
			| TIPO_DATO IDENTIFICADOR '(' listaDeclaraciones ')' sentenciaCompuesta ';' declaracionFuncion
			| error caracterDeCorte

caracterDeCorte:	';' | '\n'

//expresiones de las sentencias en c//

sentencia:	 	sentenciaCompuesta
			|sentenciaExpresion
			|sentenciaSeleccion
			|sentenciaIteracion
			|sentenciaSalto

sentenciaCompuesta:	'{' listaDeclaraciones listaSentencias '}'

listaDeclaraciones:	declaracion
			|listaDeclaraciones declaracion

listaSentencias: 	sentencia
			|listaSentencias sentencia

sentenciaExpresion:	expresion ';'

sentenciaSeleccion:	IF'(' expresion ')' sentencia
			|IF'('expresion')' sentencia ELSE sentencia

sentenciaIteracion:	WHILE '(' expresion ')' sentencia
			| DO sentencia WHILE '(' expresion ')' ';'
			| FOR '(' expresion ';' listaExpresiones ')' sentencia

listaExpresiones: 	expresion
			|listaExpresiones ';' expresion

sentenciaSalto: 	RETURN expresion ';'

declaracion:		TIPO_DATO listaIdentificadores ';'

listaIdentificadores: 	  identificadorA
			| identificadorA ',' listaIdentificadores
;

identificadorA:		  IDENTIFICADOR
			| IDENTIFICADOR arreglo
			| IDENTIFICADOR '=' expresion
;

arreglo:		'[' expresion ']'

// BNF de las expresiones//

expresion:		expAsignacion

expAsignacion:		expCondicional
			|expUnaria operAsignacion expAsignacion
operAsignacion:		'='
			|'+''='
			|'*''='
expCondicional:         expOR
			|expOR '?' expCondicional

expOR:			expAnd
			|expOR '|''|' expAnd

expAnd:			 expIgualdad
			|expAnd '&''&' expIgualdad

expIgualdad:		expRelacional
			|expIgualdad '=''=' expRelacional
			|expIgualdad'!''=' expRelacional

expRelacional: 		expAditiva
			|expRelacional operRelacional expAditiva

operRelacional:		'>'
			|'>''='
			|'<''='
			|'<'

expAditiva:		expMultiplicativa
			|expAditiva '+' expMultiplicativa
			|expAditiva '-' expMultiplicativa

expMultiplicativa:	 expUnaria
			|expMultiplicativa '*' expUnaria
			|expMultiplicativa '/' expUnaria
			|expMultiplicativa '%' expUnaria

expUnaria:		expPosfijo
			|'+''+' expUnaria
			|'-''-' expUnaria
			|operUnario expUnaria
			|SIZEOF '(' TIPO_DATO ')'
operUnario:		'&'
			|'*'
			|'-'
			|'!'
 
expPosfijo:		expPrimaria
			|expPosfijo '[' expresion ']'
			|expPosfijo '('listaArgumentos')'
			|'('expresion')'

listaArgumentos: 	expAsignacion
			|listaArgumentos ',' expAsignacion

expPrimaria:		IDENTIFICADOR
			|CARACTER
			|NUM
			|CADENA
			|


%%


yyerror (s)  /* Llamada por yyparse ante un error */
     char *s;
{
  printf ("%s\n", s);
}

main ()
{
  yyin = fopen("entrada.txt","r+");  
  yyout = fopen("salida.txt","w");
  yyparse ();
}
