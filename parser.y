%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "SymbolTable/symboltable.h"
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

%token GGMM AA BEG_LIB BEG_PRES WS LEFT_PAR RIGHT_PAR COLON BOOK_CODE NAME SEP ARROW Q_NAME DOT SEMICOLON CF SLASH
%type <str> GGMM;
%type <str> AA;
%type <str> NAME;
%type <str> Q_NAME;
%type <str> BOOK_CODE;

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
lista_libri: Q_NAME DOT WS BOOK_CODE SEMICOLON WS lista_libri {
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
utente: Q_NAME WS SEP WS CF WS
;
prestiti_utente: BOOK_CODE COLON WS data_prestito SEMICOLON prestiti_utente {
    char *d = stackPop();
    addLoan($1, d);
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
    if(--argc <= 1) {
        puts("Utilizzo: ./biblioteca input.txt output.txt");
        return -1;
    }
    yyin = fopen(argv[1], "r");
    FILE *out = fopen(argv[2], "w");
    yyparse();

    if(errore) {
        freeHashTable();
        return -1;
    }

    printAvailableBooks(out);
    printLoanedBooks(out);
    freeHashTable();
    fclose(out);
    puts("File di output correttamente");
    return 0;
}

int yyerror (char *s) /* Gestisce la presenza di errori sintattici */
{
    puts("\nERRORE GENERICO DI SINTASSI\n");
    errore=1;
}
