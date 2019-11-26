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
int h=0,j=0,k=0,y=0,l=0,x=0,q=0,g=0;
int a[1]={0};
Funciones F[50];
Variables V[50];
ErrorOp E[50];

%}

%union { 
  struct {
    char caracter;
    char cadena[50];
    float  valor;
    int  tipoDato;
	int lvalue;
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
%error-verbose

%% /* A continuación las reglas gramaticales y las acciones */
input:	 
	|input line {printf ("linea terminada \n");linea++;}
;

line:    declaracionFuncion caracterDeCorte2 {printf ("decl func \n");l=0;}
	| declaracion ';' caracterDeCorte2 {printf ("decl \n");l=0;}
	| sentencia caracterDeCorte2 {printf("sentencia \n");}
	| error caracterDeCorte {for(int o=k;o>l;o--){V[o].vusado = 0;};k=l;}
;

caracterDeCorte:         ';' | '\n' | ';''\n'
;

caracterDeCorte2:          | '\n'   
;

declaracionFuncion: 	TIPO_DATO IDENTIFICADOR '(' listaDeclaraciones ')' ';' {if(!busquedaId(V,F,$<c.cadena>2)){agregarFuncion(F,$<c.cadena>2,$<palabra>1,h);printf ("%d funcion\n",h);q=j-l;agregarFuncionId(V,h,x,q);h++;};}
			|TIPO_DATO IDENTIFICADOR '(' listaDeclaraciones ')' sentenciaCompuesta {if(!busquedaId(V,F,$<c.cadena>2)){agregarFuncion(F,$<c.cadena>2,$<palabra>1,h);printf ("%d funcion\n",h);q=j-l;agregarFuncionId(V,h,x,q);h++;};}
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
	

listaDeclaraciones:	/* vacío */ {x=j;}
			|declaracionVarFuncion ',' listaDeclaraciones
			|declaracionVarFuncion 
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

declaracionVarFuncion:  TIPO_DATO identificadorA {if(y==1){agregarTipoIdFuncion(V,$<palabra>1,j);k=j;printf ("%d tipo\n",k);};}
;

declaracion:		TIPO_DATO listaIdentificadores {if(y==1){agregarTipoId(V,$<palabra>1,j,k);k=j;printf ("%d tipo\n",k);};}
;

listaIdentificadores: 	  identificadorA
			| identificadorA ',' listaIdentificadores
;

identificadorA:		  IDENTIFICADOR {x=j;if(!busquedaId(V,F,$<c.cadena>1)){agregarId(V,$<c.cadena>1,j);j++;y=1;l++;printf ("%d variable \n",j);}else{y=0;};}
			| IDENTIFICADOR '=' expresion {x=j;if(!busquedaId(V,F,$<c.cadena>1)){agregarId(V,$<c.cadena>1,j);j++;y=1;l++;printf ("%d variable \n",j);}else{y=0;};}
;

// BNF de las expresiones//

expresion:		expAsignacion {printf ("decl expres \n"); $<c.tipoDato>$=$<c.tipoDato>1;}
;

expAsignacion:		expCondicional {$<c.tipoDato>$=$<c.tipoDato>1;}
			|expUnaria operAsignacion expAsignacion {if ($<c.tipoDato>1==$<c.tipoDato>3&&$<c.lvalue>1==1){$<c.tipoDato>$ = $<c.tipoDato>1;}else{operacionError(E,$<c.cadena>1, $<c.cadena>3, "igual/porigual",g);g++;};}
;

operAsignacion:		AUMENTOIGUAL
			|PORIGUAL
			|'=' {printf ("decl = \n");}
;

expCondicional:         expOR {$<c.tipoDato>$=$<c.tipoDato>1;}
			|expOR OPCION expCondicional {if ($<c.tipoDato>1==$<c.tipoDato>3){$<c.tipoDato>$ = $<c.tipoDato>1;}else{operacionError(E,$<c.cadena>1, $<c.cadena>3, "opcional",g);g++;};}
;

expOR:			expAnd {$<c.tipoDato>$=$<c.tipoDato>1;}
			|expOR OR expAnd {if ($<c.tipoDato>1==$<c.tipoDato>3){$<c.tipoDato>$ = $<c.tipoDato>1;}else{operacionError(E,$<c.cadena>1, $<c.cadena>3, "or",g);g++;};}
;

expAnd:			 expIgualdad{$<c.tipoDato>$=$<c.tipoDato>1;}
			|expAnd AND expIgualdad {if ($<c.tipoDato>1==$<c.tipoDato>3){$<c.tipoDato>$ = $<c.tipoDato>1;}else{operacionError(E,$<c.cadena>1, $<c.cadena>3, "and",g);g++;};}
;

expIgualdad:		expRelacional {$<c.tipoDato>$=$<c.tipoDato>1;}
			|expIgualdad IGUALDAD2 expRelacional {if ($<c.tipoDato>1==$<c.tipoDato>3){$<c.tipoDato>$ = $<c.tipoDato>1;}else{operacionError(E,$<c.cadena>1, $<c.cadena>3, "igualdad comparativa",g);g++;};}
			|expIgualdad DISTINTO expRelacional {if ($<c.tipoDato>1==$<c.tipoDato>3){$<c.tipoDato>$ = $<c.tipoDato>1;}else{operacionError(E,$<c.cadena>1, $<c.cadena>3, "distinto",g);g++;};}
;

expRelacional: 		expAditiva {$<c.tipoDato>$=$<c.tipoDato>1;}
			|expRelacional operRelacional expAditiva {if ($<c.tipoDato>1==$<c.tipoDato>3){$<c.tipoDato>$ = $<c.tipoDato>1;}else{operacionError(E,$<c.cadena>1, $<c.cadena>3, "menor/mayor/menorigual/mayorigual",g);g++;};}
;

operRelacional:		MAYOR
			|MENOR
			|MAYORIGUAL
			|MENORIGUAL
			
;

expAditiva:		expMultiplicativa {$<c.tipoDato>$=$<c.tipoDato>1;}
			|expAditiva '+' expMultiplicativa {if ($<c.tipoDato>1==$<c.tipoDato>3){$<c.tipoDato>$ = $<c.tipoDato>1;}else{operacionError(E,$<c.cadena>1, $<c.cadena>3, "suma",g);g++;};}
			|expAditiva '-' expMultiplicativa {if ($<c.tipoDato>1==$<c.tipoDato>3){$<c.tipoDato>$ = $<c.tipoDato>1;}else{operacionError(E,$<c.cadena>1, $<c.cadena>3, "resta",g);g++;};}
;

expMultiplicativa:	 expUnaria {$<c.tipoDato>$=$<c.tipoDato>1}
			|expMultiplicativa '*' expUnaria {if ($<c.tipoDato>1==$<c.tipoDato>3){$<c.tipoDato>$ = $<c.tipoDato>1;}else{operacionError(E,$<c.cadena>1, $<c.cadena>3, "multiplicacion",g);g++;};}
			|expMultiplicativa '/' expUnaria {if ($<c.tipoDato>1==$<c.tipoDato>3){$<c.tipoDato>$ = $<c.tipoDato>1;}else{operacionError(E,$<c.cadena>1, $<c.cadena>3, "division",g);g++;};}
			|expMultiplicativa '%' expUnaria {if ($<c.tipoDato>1==$<c.tipoDato>3){$<c.tipoDato>$ = $<c.tipoDato>1;}else{operacionError(E,$<c.cadena>1, $<c.cadena>3, "resto division entera",g);g++;};}

expUnaria:		expPosfijo {$<c.tipoDato>$=$<c.tipoDato>1;}
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
 
expPosfijo:		expPrimaria {$<c.tipoDato>$=$<c.tipoDato>1;}
			|expPosfijo '[' expresion ']'
			|expPosfijo '('listaArgumentos')'
			|'('expresion')'
;

listaArgumentos: 	expAsignacion
			|listaArgumentos ',' expAsignacion
;

expPrimaria:		IDENTIFICADOR {if(busquedaId(V,F,$<c.cadena>1)){busquedaIdDeclTipo(V,F,$<c.cadena>1,a);printf("%d\n",a[0]);$<c.tipoDato>$=a[0];}else{$<c.tipoDato>$=0;};}
			|CARACTER {$<c.tipoDato>$=$<c.tipoDato>1;}
			|NUM {$<c.tipoDato>$=$<c.tipoDato>1;}
			|CADENA {$<c.tipoDato>$=$<c.tipoDato>1;}
;


%%

int main ()
{
  inicializar(V,F,E);
  yyin = fopen("entrada.txt","r+");
  yyout = fopen("salida.txt","w");
  yyparse ();
  menu(V,F,E);
}