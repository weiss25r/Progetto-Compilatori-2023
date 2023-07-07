%{
#include <stdio.h>
#include "SymbolTables/symboltable.h"
int errore = 0;
//#include "SymbolTables/symboltable.h"
%}

%token GGMM AA BEG_LIB BEG_PRES WS QUOTES LEFT_PAR RIGHT_PAR COLON CODE NAME SEP ARROW TITLE DOT SEMICOLON
%start input
%%
input: data BEG_LIB biblioteca BEG_PRES {
}
;
data: GGMM SEP GGMM SEP AA {printf("%d\n", $1);}
;
biblioteca: scrittore ARROW WS lista_libri SEP SEP SEP biblioteca {printf("BIBLIOTECA OK ");}
|
;
scrittore: NAME WS NAME {}
;
lista_libri: TITLE DOT WS CODE SEMICOLON WS lista_libri {}
| 
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
