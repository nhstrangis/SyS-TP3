%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
extern char *yytext;
extern int yyleng;
extern int yylex(void);
extern void yyerror(char*);
void validarLongitudIdentificador(char* identificador,int longitud);
void finalizarPrograma();
typedef struct{
	char identificador[32];
	int valor;
}ts;
ts tabla[50];
void inicializarTS(ts tabla[]);
%}
%union{
	char* cadena;
	int num;
}
%token INICIO FIN LEER ESCRIBIR ASIGNACION PUNTOYCOMA COMA SUMA RESTA PARENIZQUIERDO PARENDERECHO
%token <cadena> ID
%token <num> CONSTANTE
%%
programa: INICIO {inicializarTS(tabla);} listaSentencias FIN {finalizarPrograma();}
;
listaSentencias: sentencia
|listaSentencias sentencia
;
sentencia: ID {validarLongitudIdentificador(yytext, yyleng);} ASIGNACION expresion PUNTOYCOMA
|LEER PARENIZQUIERDO listaIdentificadores PARENDERECHO PUNTOYCOMA
|ESCRIBIR PARENIZQUIERDO listaExpresiones PARENDERECHO PUNTOYCOMA
;
listaIdentificadores: ID
|listaIdentificadores COMA ID
;
listaExpresiones: expresion
|listaExpresiones COMA expresion
;
expresion: primaria
|expresion operadorAditivo primaria
;
primaria: ID
|CONSTANTE {printf("El valor de la constante es %d\n",atoi(yytext));}
|PARENIZQUIERDO expresion PARENDERECHO
;
operadorAditivo: SUMA
|RESTA
;
%%
int main(){
yyparse();
}
void yyerror(char *s){
printf("%s\n",s);
exit(0);
}

void validarLongitudIdentificador(char *identificador, int longitud){
	if(longitud>32){
		yyerror("Los identificadores deben tener una longitud maxima de 32 caracteres");
	}
}

void finalizarPrograma(){	
	exit(0);
}

void inicializarTS(ts *tabla){
	tabla[0]=(ts){"inicio", 0};
	tabla[1]=(ts){"fin", 0};
	tabla[2]=(ts){"escribir", 0};
	tabla[3]=(ts){"leer", 0};	
}