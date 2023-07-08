%{
    #include <stdio.h>
    #include <string.h>
    #include "SymbolTables/symboltable.h"
    char *autore;
    char *data;
    int errore = 0;
    //#include "SymbolTables/symboltable.h"
%}

%union{
    char *str;
}

%token GGMM AA BEG_LIB BEG_PRES WS QUOTES LEFT_PAR RIGHT_PAR COLON CODE NAME SEP ARROW TITLE DOT SEMICOLON CF SLASH
%type <str> GGMM;
%type <str> AA;
%type <str> NAME;
%type <str> TITLE;
%type <str> CODE;

%start input
%%
input: data BEG_LIB biblioteca BEG_PRES lista_prestiti {}
;
data: GGMM SEP GGMM SEP AA {}
;
biblioteca: scrittore ARROW WS lista_libri SEP SEP SEP biblioteca {}
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

lista_prestiti: utente LEFT_PAR prestiti_utente RIGHT_PAR lista_prestiti
|
;
utente: TITLE WS SEP WS CF WS {}
;
prestiti_utente: CODE COLON WS data_prestito SEMICOLON prestiti_utente {aggiungiPrestito($1, data);}
| WS prestiti_utente
|
;
data_prestito: GGMM SLASH GGMM SLASH AA {
    data = strcat($1, "/");
    data = strcat(data, $3);
    data = strcat(data, "/");
    data = strcat(data, $5);
}
;
%%
int main()
{
    yyparse();
    if (!errore){
        printf("Il file è formattato correttamente\n");
        printAvaiableBooks();
        printLoanedBooks();
        freeHashTable();
    }
    
}

int yyerror (char *s) /* Gestisce la presenza di errori sintattici */
{
    printf ("ERRORE DI SINTASSI %s\n",s);
    errore=1;
}
