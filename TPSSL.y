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
    char cadena[50];
    float  valor;
    int  tipo;
    } c;
  int entero;
  char cadena[5];
}

%token <c> NUM
%token <cadena> CARACTER
%token <cadena> CADENA
%token <cadena> IDENTIFICADOR
%token <cadena> TIPO_DATO
%token <cadena> IF
%token <cadena> DO
%token <cadena> WHILE
%token <cadena> FOR
%token <cadena> ELSE
%token <entero> error

%type <cadena> identificadorA
%type <C> expresion

%left '+' '-'
%right '*' '/'
%nonassoc '^'

%% /* A continuación las reglas gramaticales y las acciones */

input:    /* vacío */
        | input line
;

line:     '\n'
        | declaracionFuncion '\n'
;      

declaracionFuncion: 	  TIPO_DATO IDENTIFICADOR (declaracion) sentenciaCompuesta ';' {if(flag_error==0){printf("Se han declarado variables \n");};flag_error=0;}
			| error caracterDeCorte {printf("Falta tipo de dato \n");}

caracterDeCorte:	';' | '\n'

//expresiones de las sentencias en c//

sentencia:	 	sentenciaCompuesta
			|sentenciaExpresion
			|sentenciaSeleccion
			|sentenciaIteracion
			|sentenciaSalto

sentenciaCompuesta:	'{' listaDeclaraciones listaSentencias '}'

listaDEclaraciones:	declaracion
			|listaDeclaraciones declaracion

listaSentencias: 	sentencia
			|listaSentencias sentencia

sentenciaExpresion:	expresion ';'

sentenciaSeleccion:	IF'(' expresion ')' sentencia
			|IF'('expresion')' sentencia ELSE sentencia

sentenciaIteracion:	WHILE '(' expresion ')' sentencia
			DO sentencia WHILE '(' expresion ')' ';'
			FOR '(' expresion ';' listaExpresiones ')' sentencia

listaExpresiones: 	expresion
			|listaExpresiones ';' expresion

sentenciaSalto: 	RETURN expresion ';'

declaracion:		TIPODATO listaIdentificadores ';'

listaIdentificadores: 	  identificadorA
			| identificadorA ',' listaIdentificadores
;

identificadorA:		  IDENTIFICADOR
			| IDENTIFICADOR arreglo
			| IDENTIFICADOR '=' expresion {if(flag_error==0){printf("Se asigna al identificador %s el valor %d \n",$1,$3);};}
			| error {if(flag_error==0){printf("Falta identificador \n");flag_error=1;};}
;

arreglo:		[expresion]

// BNF de las expresiones//

expresion:		expAsignacion

expAsignacion:		expCondicional
			|expUnaria operAsignacion expAsignacion
operAsignacion:		'='
			|'+''='
			|'*''='
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
			|SIZEOF '(' nombreTipo ')'
operUnario:		'&'
			|'*'
			|'-'
			|'!'
 
expPosfijo:		expPrimaria
			|expPosfijo '[' expresion ']'
			expPosfijo '('listaArgumentos')'

listaArgumentos: 	expAsignacion
			|listaArgumentos ',' expAsignacion

expPrimaria:		IDENTIFICADOR
			|CARACTER
			|NUM
			|CADENA
			|'('expresion')'


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
