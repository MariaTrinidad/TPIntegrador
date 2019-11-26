#include <math.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>

typedef struct Funcion {
		char tipo[50];
		char identificador[50];
		int funcion;
		int fusado;
		}Funciones;
typedef struct Variable {
		int funcion;
		char tipo[50];
		char identificador[50];
		int vusado;
		}Variables;
typedef struct errorOperacion {
		char error1[50];
		char error2[50];
		char operacion[50];
		int eusado;
		}ErrorOp;

void inicializar(Funciones Fa[], Variables Va[],ErrorOp Ea[])
{
	for(int y=0;y<50;y++)
	{
		Va[y].funcion = 60;
		Va[y].vusado = 0;
		Fa[y].funcion = 60;
		Fa[y].fusado = 0;
		Ea[y].eusado = 0;
	}
}

int busquedaId(Variables Va[], Funciones Fa[], char iden[])
{
	int i=0;
	while(i<50)
	{
		if(strcmp(Va[i].identificador, iden) || strcmp(Fa[i].identificador, iden))
		{
			return 1;
		}
		i++;
	}
	return 0;
}

void agregarId(Variables Va[], char iden[], int var)
{
	strcpy(Va[var].identificador,iden);
	Va[var].funcion=60;
}

void agregarTipoId(Variables Va[], char tipo[], int var1, int var2)
{
	for(int i=var2;i<var1;i++)
	{
		if(Va[i].funcion == 60)
		{
			strcpy(Va[i].tipo,tipo);
			Va[i].vusado = 1;
		}
	}
}

void agregarTipoIdFuncion(Variables Va[],char tipo,int j)
{
	strcpy(Va[j].tipo,tipo);
	Va[j].vusado = 1;
}

void agregarFuncionId(Variables Va[], int funcion,int var1, int var2)
{
	for(int i=var2;i<=var1;i++)
	{
		Va[i].funcion = funcion;
		printf("%s\n",Va[i].identificador);
	}
}

void mostrarIds(Variables Va[])
{
	int i=0;
	printf("\n Se han declarado las siguientes variables:\n");
	while (i<50)
	{
		if(Va[i].vusado == 1)
		{
			printf( "Nombre: %s\n", Va[i].identificador);
			printf( "Tipo : %s\n", Va[i].tipo);
			printf( "--------------------\n");
		}
		i++;
	}
 }

void agregarFuncion(Funciones Fa[], char iden[], char tipo[], int funcion)
{
	strcpy(Fa[funcion].identificador,iden);
	strcpy(Fa[funcion].tipo,tipo);
	Fa[funcion].funcion = funcion;
	Fa[funcion].fusado = 1;
}

void mostrarFuncs(Funciones Fa[],Variables Va[])
{
	int i=0;
	int u=0;
	int z=0;
	printf("\n Se han declarado las siguientes funciones:\n\n");
	while (i<50)
	{
		if(Fa[i].fusado == 1)
		{
			printf( "Nombre: %s\n", Fa[i].identificador);
			printf( "Tipo : %s\n", Fa[i].tipo);
			printf( "De entrada : \n\n");
			for(u=0; u<50; u++)
			{
				if((Va[u].funcion == i) && (!strcmp(Va[u].identificador," ")) )
					{
						printf( "Variable : %s\n", Va[u].identificador);
						printf( "Tipo : %s\n", Va[u].tipo);
						printf( "%d\n", Va[u].funcion);
						z++;
					}
			}
			if(z==0)
			{
				printf("Vacia \n");
			}
			z=0;
			printf("--------------------\n");
		}
		i++;
	}
 }

 int busquedaIdDeclTipo(Variables Va[], Funciones Fa[], char cadena[])
 {
	int i=0;
	while(i<50)
	{
		if(strcmp(Va[i].identificador, cadena))
		{
			return Va[i].tipo;
		}
		if(strcmp(Fa[i].identificador, cadena))
		{
			return Fa[i].tipo;
		}
		i++;
	}
	return 0;
 }

void operacionError(ErrorOp Ea[],char operador1[],char operador2[],char operacion[], int valor)
{
	strcpy(Ea[valor].error1,operador1);
	strcpy(Ea[valor].error2,operador2);
	strcpy(Ea[valor].operacion,operacion);
	Ea[valor].eusado = 1;
}

void erroresOp(ErrorOp Ea[])
{
	for(int m=0; m<50; m++)
			{
				if(Ea[m].eusado == 1)
				{
					printf( "Error en la %s entre %s y %s \n",Ea[m].operacion,Ea[m].error1,Ea[m].error2);
				}
			}
}

void menu(Variables Va[], Funciones Fa[],ErrorOp Ea[])
{
    printf("\n");
    mostrarIds(Va);
    mostrarFuncs(Fa,Va);
    erroresOp(Ea);
}

void yyerror(char *s){
    extern int yylineno;
    printf("\n %s. En la linea %i \n\n",s,yylineno);
}
