%{
#include <stdio.h>
#include <string.h>
#include "SymbolTables/symboltable.h"
char *autore;
int errore = 0;
//#include "SymbolTables/symboltable.h"
%}

%union{
    char *str;
}

%token GGMM AA BEG_LIB BEG_PRES WS QUOTES LEFT_PAR RIGHT_PAR COLON CODE NAME SEP ARROW TITLE DOT SEMICOLON
%type <str> GGMM;
%type <str> AA;
%type <str> NAME;
%type <str> TITLE;
%type <str> CODE;

%start input
%%
input: data BEG_LIB biblioteca BEG_PRES {}
;
data: GGMM SEP GGMM SEP AA {}
;
biblioteca: scrittore ARROW WS lista_libri SEP SEP SEP biblioteca {printf("BIBLIOTECA OK ");}
|
;
scrittore: NAME WS NAME {
    autore = strcat($1, " ");
    autore = strcat(autore, $3);
}
;
lista_libri: TITLE DOT WS CODE SEMICOLON WS lista_libri {
    ++$1;
    char libro[strlen($1)];
    strncpy(libro, $1, strlen($1)-1);
    libro[strlen($1)-1] = 0;
    insert(libro, $4, autore);
}
| 
;
%%
int main()
{
    yyparse();
    if (!errore){
        printf("Programma corretto!!!\n");
        printAvaiableBooks();
        freeHashTable();
    }
    
}

int yyerror (char *s) /* Gestisce la presenza di errori sintattici */
{
    printf ("ERRORE DI SINTASSI %s\n",s);
    errore=1;
}
