#include <math.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>

typedef struct Funcion {
		char tipo[50];
		char identificador[50];
		int funcion;
		}Funciones;
typedef struct Variable {
		int funcion;
		char tipo[50];
		char identificador[50];
		int usado;
		}Variables;

void inicializar(Funciones Fa[], Variables Va[])
{
	for(int y=0;y<50;y++)
	{
		strcpy(Va[y].tipo," ");
		strcpy(Va[y].identificador," ");
		Va[y].funcion = 0;
		strcpy(Fa[y].tipo," ");
		strcpy(Fa[y].identificador," ");
		Fa[y].funcion = 0;
	}
}

int busquedaId(Variables Va[], char iden[])
{
	int i=0;	
	while(i<50)
	{
		if(strcmp(Va[i].identificador, iden))
		{
			return 1;
		}
		i++;
	}
	return 0;
}

void agregarId(Variables Va[], char iden[], int funcion, int var)
{
	strcpy(Va[var].identificador,iden);
	Va[var].funcion = funcion;
}

void agregarTipoId(Variables Va[], char tipo[], int var1, int var2)
{	
	for(int i=var1;i>=var2-1;i--)
	{
		strcpy(Va[i].tipo,tipo);
		Va[i].usado = 1;
	}
}

void mostrarIds(Variables Va[])
{
	int i=0;
	printf("\n Mostrando la lista de identificadores:\n");
	while (i<50) 
	{	
		if(Va[i].usado != 0)
		{
			printf( "Nombre: %s\n", Va[i].identificador);
			printf( "Tipo : %s\n", Va[i].tipo);
		}
		i++;
	}
 }

void agregarFuncion(Funciones Fa[], char iden[], char tipo[], int funcion, int var)
{
	strcpy(Fa[var].identificador,iden);
	strcpy(Fa[var].tipo,tipo);
	Fa[var].funcion = funcion;
}

void mostrarFuncs(Funciones Fa[])
{
	int i=0;
	printf("\n Se han declarado las siguientes funciones:\n\n");
	while (i<50) 
	{	
		if(Fa[i].funcion != 0)
		{
			printf( "Nombre: %s\n", Fa[i].identificador);
			printf( "Tipo : %s\n", Fa[i].tipo);
		}
		i++;
	}
 }

void menu(Variables Va[], Funciones Fa[])
{
    printf("\n");
    mostrarIds(Va);
    mostrarFuncs(Fa);
}

void yyerror(char *s){
    extern int yylineno;
    printf("\n Error sintactico %s. En la linea %i \n\n",s,yylineno);
}