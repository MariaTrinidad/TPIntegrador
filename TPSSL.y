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
int i=0,j=0,k=0,y=0;
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
void inicializar()
{
	for(y=0;y<50;y++)
	{
		strcpy(V[y].tipo,"\0");
		strcpy(V[y].identificador,"\0");
		strcpy(F[y].tipo,"\0");
		strcpy(F[y].identificador,"\0");
	}
}
/*int dobleVariable(int a)
{
	for(y=0;y<a;y++)
	{
	*/	

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

%expect 22

%% /* A continuación las reglas gramaticales y las acciones */
input:	 
	|input line {printf ("linea terminada \n");}
;

line:    declaracionFuncion caracterDeCorte2 {printf ("decl func \n");}
	| declaracion ';' caracterDeCorte2 {printf ("decl \n");}
	| sentencia caracterDeCorte2 {printf("sentencia \n");}
	| error caracterDeCorte
;

caracterDeCorte:         ';' | '\n' | ';''\n'
;

caracterDeCorte2:          | '\n'   
;

declaracionFuncion: 	TIPO_DATO IDENTIFICADOR '(' listaDeclaraciones ')' ';' {printf ("%d funcion\n",i);strcpy(F[i].tipo,$<palabra>1);strcpy(F[i].identificador,$<c.cadena>2); i++;}
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
			|declaracion
			|declaracion ';' listaDeclaraciones
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


declaracion:		TIPO_DATO listaIdentificadores /*{printf ("%d tipo\n",k);for(k=j-1;k>0;k--){if(strcmp(V[k].tipo,"\0")){strcpy(V[k].tipo,$<palabra>1);j++;};};k=j;}*/
;

listaIdentificadores: 	  identificadorA
			| identificadorA ',' listaIdentificadores
;

identificadorA:		  IDENTIFICADOR /*{printf ("%d variable \n",j);for(k=0;k<j;k++){if(strcmp(V[k].identificador,$<c.cadena>1)){k=j+1;};};if(k=j){V[j].funcion=i;strcpy(V[j].identificador,$<c.cadena>1);j++;};if(k<j){strcpy(V[j].identificador,"\0");};}*/
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


yyerror (s)  /* Llamada por yyparse ante un error */
     char *s;
{
  printf ("%s\n", s);
}

main ()
{
  inicializar();
  yyin = fopen("entrada.txt","r+");
  yyout = fopen("salida.txt","w");
  yyparse ();
}
