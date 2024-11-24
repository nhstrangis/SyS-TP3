%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdbool.h>
#include <string.h>

#define MAX_TS 100
#define MAX_IDNT 32

extern char *yytext;
extern int yyleng;
extern int yylex(void);
extern void yyerror(char*);

void validarLongitudIdentificador(char* identificador,int longitud);
void agregarSimbolo(char *idnt);
void finalizarPrograma();
void errorLongitudExcedida();
void errorVariableReDeclarada();

typedef struct{
	char identificador[MAX_IDNT];
	int clave;
} simbolo;

simbolo tabla[MAX_TS];
void inicializarTS(simbolo tabla[]);

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

sentencia: ID {
	validarLongitudIdentificador(yytext, yyleng);
	agregarSimbolo(yytext)
} ASIGNACION expresion PUNTOYCOMA
|LEER PARENIZQUIERDO listaIdentificadores PARENDERECHO PUNTOYCOMA
|ESCRIBIR PARENIZQUIERDO listaExpresiones PARENDERECHO PUNTOYCOMA
;

listaIdentificadores: ID {
	validarLongitudIdentificador(yytext, yyleng);
    agregarSimbolo(yytext);
}
|listaIdentificadores COMA ID
;

listaExpresiones: expresion
|listaExpresiones COMA expresion
;

expresion: primaria
|expresion operadorAditivo primaria
;

primaria: ID {
	validarLongitudIdentificador(yytext, yyleng);
    agregarSimbolo(yytext);
}
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
	printf("Error: %s\n",s);
	exit(0);
}

void errorLongitudExcedida() {
	yyerror("Los identificadores deben tener una longitud maxima de 32 caracteres");
}
 
void errorVariableReDeclarada() {
	yyerror("La varible ya fue declarada");
}

void validarLongitudIdentificador(char *idnt, int longitud){
	if(longitud>MAX_IDNT){
		errorLongitudExcedida();
	}
}

void finalizarPrograma(){	
	exit(0);
}

void inicializarTS(simbolo tabla[]){
	for(int i = 0; i < MAX_TS; i++) {
		tabla[i] = (simbolo){"\0", 0};
	}
	tabla[0]=(simbolo){"inicio", -1};
	tabla[1]=(simbolo){"fin", -1};
	tabla[2]=(simbolo){"escribir", -1};
	tabla[3]=(simbolo){"leer", -1};	
}

bool existeSimbolo(char *idnt) {
	for(int i = 0; i < MAX_TS; i++) {
		if ((strcmp(idnt, tabla[i].identificador) == 0) && (tabla[i].clave != -1)){
			return true; 
		}
	}
	return false;
}

void agregarSimbolo(char *idnt) {
	if (existeSimbolo(idnt)) {
		errorVariableReDeclarada();
	}
	for(int i = 0; i < MAX_TS; i++) {
		if (strcmp("\0", tabla[i].identificador) == 0) {
			strncpy(tabla[i].identificador, idnt, sizeof(tabla[i].identificador) - 1); 
			tabla[i].clave = i+1;
			return; 
		}
	}
	printf("Error: tabla de símbolos llena\n");
    	exit(0);
}