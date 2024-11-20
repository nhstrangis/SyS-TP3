%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
void yyerror(char*);
void errorLexico();
%}
%option noyywrap
DIGITO [0-9]
LETRA [a-zA-Z]
IDENTIFICADOR {LETRA}({LETRA}|{DIGITO})*
costEntera {DIGITO}({DIGITO})*
%%
"inicio"    {return INICIO;}
"fin"		{return FIN;}
"leer"		{return LEER;}
"escribir"	{return ESCRIBIR;}
":="		{return ASIGNACION;}
{costEntera} {yylval.num=atoi(yytext);return CONSTANTE;}
{IDENTIFICADOR} {return ID;}
";"			{return PUNTOYCOMA;}
","			{return COMA;}
"("			{return PARENIZQUIERDO;}
")"			{return PARENDERECHO;}
"+"			{return SUMA;}
"-"			{return RESTA;}
.			{errorLexico();}
%%

void errorLexico(){
	printf("Error lexico: el caracter %s no pertenece al lenguaje MICRO", yytext);
	exit(0);
}
