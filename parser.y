%{
#include <stdio.h>
int errore = 0;
//#include "SymbolTables/symboltable.h"
%}
%token GGMM AA BEG_LIB BEG_PRES WS QUOTES LEFT_PAR RIGHT_PAR COLON CODE NAME SEP ARROW TITLE DOT SEMICOLON
%start input
%%
input: data BEG_LIB biblioteca {printf("INPUT OK");}
;
data: GGMM SEP GGMM SEP AA {printf("DATA OK");}
;
biblioteca: scrittore ARROW WS lista_libri {printf("OK BIBLIOTECA");}
;
scrittore: NAME WS NAME {printf("SCRITTORE OK");}
;
lista_libri: libro lista_libri 
| libro
;
libro: TITLE DOT WS CODE SEMICOLON {printf("LIBRO OK");}
;
%%
int main()
{
    yyparse();
    if (!errore) printf("Programma corretto!!!\n");
}

yyerror (char *s) /* Gestisce la presenza di errori sintattici */
{
    printf ("SYNTAX ERROR %s\n",s);
    errore=1;
}
