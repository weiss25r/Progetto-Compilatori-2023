%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "SymbolTables/symboltable.h"
    #include "StringsStack/stack.h"
    extern int yylex();
    extern int yyerror();
    extern FILE* yyin;
    char *autore = NULL;;
    int errore = 0;
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
input: data BEG_LIB biblioteca BEG_PRES lista_prestiti
;
data: GGMM SEP GGMM SEP AA
;
biblioteca: scrittore ARROW WS lista_libri SEP SEP SEP biblioteca
| {
    if(autore == NULL) {
        printf("ERRORE: la lista di libri non può essere vuota\n");
        exit(-1);
    }
}
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
utente: TITLE WS SEP WS CF WS
;
prestiti_utente: CODE COLON WS data_prestito SEMICOLON prestiti_utente {
    char *d = stackPop();
    aggiungiPrestito($1, d);
    free(d);
}
| WS prestiti_utente
|
;
data_prestito: GGMM SLASH GGMM SLASH AA {
    char *data = NULL;
    int gg = atoi($1);
    int mm = atoi($3);
    data = strcat($1, "/");
    data = strcat(data, $3);
    data = strcat(data, "/");
    data = strcat(data, $5);
    
    if(!(gg >= 0 && gg<=31 && mm>=0 && mm <=12)) {
        printf("ERRORE: la data del prestito %s non è corretta\n", data);
        exit(-1);
    }
    stackPush(data);
}
;
%%
int main(int argc, char *argv[])
{
    if(--argc == 0) {
        puts("Utilizzo: ./biblioteca path_file.txt");
        return -1;
    }
    yyin = fopen(argv[1], "r");
    yyparse();

    if(errore) {
        freeHashTable();
        return -1;
    }

    printf("Il file è formattato correttamente\n");
    printAvaiableBooks();
    printLoanedBooks();
    freeHashTable();
}

int yyerror (char *s) /* Gestisce la presenza di errori sintattici */
{
    puts("\nERRORE GENERICO DI SINTASSI\n");
    errore=1;
}
