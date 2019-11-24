%{
#include <math.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>
#include "ArchivoAdjuntoTPSSL.h"
#define YYDEBUG 1
extern FILE *yyin;
extern FILE *yyout;
int flag_error=0;
int h=0,j=0,k=0,y=0,l=0;
Funciones F[50];
Variables V[50];

%}

%union { 
  struct {
    char caracter;
    char cadena[50];
    float  valor;
    int  tipoDato;
    int  tipoOp;
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
%token <palabra> IGUALDAD2
%token <palabra> AUMENTO
%token <palabra> MAYORIGUAL
%token <palabra> MENORIGUAL
%token <palabra> AUMENTOIGUAL
%token <palabra> AND
%token <palabra> OR
%token <palabra> DISTINTO
%token <palabra> OPCION
%token <palabra> MAYOR
%token <palabra> MENOR
%token <palabra> DECREMENTO
%token <palabra> PORIGUAL

%type <c> identificadorA
%type <c> expPrimaria

%left '+'
%right '*' '/'
%nonassoc '^'

%expect 23
%error-verbose

%% /* A continuación las reglas gramaticales y las acciones */
input:	 
	|input line {printf ("linea terminada \n");}
;

line:    declaracionFuncion caracterDeCorte2 {printf ("decl func \n");}
	| declaracion ';' caracterDeCorte2 {printf ("decl \n");l++;}
	| sentencia caracterDeCorte2 {printf("sentencia \n");}
	| error caracterDeCorte {k=l;}
;

caracterDeCorte:         ';' | '\n' | ';''\n'
;

caracterDeCorte2:          | '\n'   
;

declaracionFuncion: 	TIPO_DATO IDENTIFICADOR '(' listaDeclaraciones ')' ';' {printf ("%d funcion\n",h);h++;}
			|TIPO_DATO IDENTIFICADOR '(' listaDeclaraciones ')' sentenciaCompuesta 
;

//expresiones de las sentencias en c//

sentencia:		sentenciaCompuesta
			|sentenciaExpresion
			|sentenciaSeleccion
			|sentenciaIteracion
			|sentenciaSalto
;

sentenciaCompuesta:	'{'/* vacío */'}'
			|'{' listaDeclaraciones listaSentencias '}'
;
	

listaDeclaraciones:	/* vacío */
			|declaracion {l++}
			|declaracion ',' listaDeclaraciones
;


listaSentencias: 	sentencia
			|sentencia  listaSentencias
;

sentenciaSeleccion:	IF'(' expresion ')' sentencia 
			|IF'('expresion')' sentencia ELSE sentencia 
;


sentenciaIteracion:	WHILE '(' expresion ')' sentencia 
			| DO sentencia WHILE '(' expresion ')' ';'
			| FOR '(' expresion ';' expresion ';' expresion ')' sentencia 
;

sentenciaSalto: 	RETURN expresion ';'
;


sentenciaExpresion:	expresion ';'
;


declaracion:		TIPO_DATO listaIdentificadores {printf ("%d tipo\n",k);agregarTipoId(V,$<c.cadena>1,j,k);k=j;}
;

listaIdentificadores: 	  identificadorA
			| identificadorA ',' listaIdentificadores
;

identificadorA:		  IDENTIFICADOR {printf ("%d variable \n",j);if(busquedaId(V,$<c.cadena>1)){agregarId(V,$<c.cadena>1,h,j);j++;};}
			| IDENTIFICADOR '=' expresion
;

// BNF de las expresiones//

expresion:		expAsignacion {printf ("decl expres \n");}
;

expAsignacion:		expCondicional
			|expUnaria operAsignacion expAsignacion
;

operAsignacion:		AUMENTOIGUAL
			|PORIGUAL
			|'=' {printf ("decl = \n");}
;

expCondicional:         expOR
			|expOR OPCION expCondicional
;

expOR:			expAnd
			|expOR OR expAnd
;

expAnd:			 expIgualdad
			|expAnd AND expIgualdad
;

expIgualdad:		expRelacional
			|expIgualdad IGUALDAD2 expRelacional {printf ("decl == \n");}
			|expIgualdad DISTINTO expRelacional
;

expRelacional: 		expAditiva
			|expRelacional operRelacional expAditiva
;

operRelacional:		MAYOR
			|MENOR
			|MAYORIGUAL
			|MENORIGUAL
			
;

expAditiva:		expMultiplicativa
			|expAditiva '+' expMultiplicativa
			|expAditiva '-' expMultiplicativa
;

expMultiplicativa:	 expUnaria
			|expMultiplicativa '*' expUnaria
			|expMultiplicativa '/' expUnaria
			|expMultiplicativa '%' expUnaria
;

expUnaria:		expPosfijo
			|AUMENTO expUnaria
			|DECREMENTO expUnaria
			|expUnaria AUMENTO
			|expUnaria DECREMENTO
			|operUnario expUnaria
			|SIZEOF '(' TIPO_DATO ')'
;

operUnario:		'&'
			|'*'
			|'-'
			|'!'
;
 
expPosfijo:		expPrimaria
			|expPosfijo '[' expresion ']'
			|expPosfijo '('listaArgumentos')'
			|'('expresion')'
;

listaArgumentos: 	expAsignacion
			|listaArgumentos ',' expAsignacion
;

expPrimaria:		IDENTIFICADOR
			|CARACTER
			|NUM
			|CADENA
;


%%

int main ()
{
  inicializar(V,F);
  yyin = fopen("entrada.txt","r+");
  yyout = fopen("salida.txt","w");
  yyparse ();
  menu(V,F);
}