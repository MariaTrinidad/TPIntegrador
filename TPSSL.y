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
int i=1,j=2,k=3;
typedef struct Funcion {
		char tipo[50];
		char identificador[50];
		}Funciones;
typedef struct Variable {
		int funcion;
		char tipo[50];
		char identificador[50];
		}Variables;
Funciones F[50];
Variables V[50];
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

%type <c> identificadorA
%type <c> expPrimaria

%left '+'
%right '*' '/'
%nonassoc '^'

%expect 16

%% /* A continuación las reglas gramaticales y las acciones */
input:    /* vacío */
        | input line
;

line:    declaracionFuncion
	| declaracion ';'  {printf ("decl");}
	| sentencia 
	| error caracterDeCorte {printf ("error");}
;      

declaracionFuncion: 	 TIPO_DATO IDENTIFICADOR '(' listaDeclaraciones ')' ';' {printf ("%d funcion\n",i);/*strcpy(F[i].tipo,$<palabra>1);strcpy(F[i].identificador,$<c.cadena>2); i++;*/}
			| error caracterDeCorte {printf ("error\n");}

caracterDeCorte:	';' | '\n'

//expresiones de las sentencias en c//

sentencia:	 	sentenciaCompuesta
			|sentenciaExpresion
			|sentenciaSeleccion
			|sentenciaIteracion
			|sentenciaSalto
			| error caracterDeCorte {printf ("error");}

sentenciaCompuesta:	'{' listaDeclaraciones listaSentencias '}'
			| error caracterDeCorte {printf ("error");}
	

listaDeclaraciones:	declaracion
			|declaracion ';' listaDeclaraciones
			| error caracterDeCorte {printf ("error");}


listaSentencias: 	sentencia
			|sentencia ',' listaSentencias
			| error caracterDeCorte {printf ("error");}


sentenciaExpresion:	expresion ';'
			| error caracterDeCorte {printf ("error");}


sentenciaSeleccion:	IF'(' expresion ')' sentencia
			|IF'('expresion')' sentencia ELSE sentencia
			| error caracterDeCorte {printf ("error");}


sentenciaIteracion:	WHILE '(' expresion ')' sentencia
			| DO sentencia WHILE '(' expresion ')' ';'
			| FOR '(' expresion ';' listaExpresiones ')' sentencia
			| error caracterDeCorte {printf ("error");}


listaExpresiones: 	expresion
			|listaExpresiones ';' expresion
			| error caracterDeCorte {printf ("error");}


sentenciaSalto: 	RETURN expresion ';'
			| error caracterDeCorte {printf ("error");}

declaracion:		/* vacío */
			|TIPO_DATO listaIdentificadores {printf ("%d tipo\n",j);} /*for(k=j;k>=0;k--){if(strcmp(V[k].tipo,"\0")){strcpy(V[k].tipo,$<palabra<1);};};}*/
			| error caracterDeCorte {printf ("error");}

listaIdentificadores: 	  identificadorA
			| identificadorA ',' listaIdentificadores
			| error caracterDeCorte {printf ("error");}
;

identificadorA:		  IDENTIFICADOR {printf ("%d variable \n",k);/*for(k=0;k<j;k++){if(strcmp(V[k].identificador,$<c.cadena>1)){k=j+1;};};if(k=j){V[j].funcion=i;strcpy(V[j].identificador,$<c.cadena>1);j++;};if(k!=j){strcpy(V[j].identificador,"\0");};*/}
			| IDENTIFICADOR '=' expresion
			| error caracterDeCorte {printf ("error");}
;

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


%%


yyerror (s)  /* Llamada por yyparse ante un error */
     char *s;
{
  printf ("%s\n", s);
}

main ()
{
 /* yyin = fopen("entrada.txt","r+"); */
 /* yyout = fopen("salida.txt","w");  */
  yyparse ();
}
