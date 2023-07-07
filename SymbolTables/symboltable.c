#include "symboltable.h"
#include <string.h>

LibroNode *hashTable[HASHSIZE];

unsigned int hash(char *codice) {
    if (codice == NULL)
        return 0;

    int hashValue = 0;
    for (int i = 0; i < strlen(codice); i++) {
        hashValue = (127 * hashValue + codice[i]) % HASHSIZE;
    }

    return hashValue;
}

LibroNode *lookup(char *codice) {
    LibroNode *list = hashTable[hash(codice)];

    while (list != NULL && list->info->codice == codice) {
        list = list->next;
    }

    return list;
}

int insert(char *titolo, char *codice) {
    LibroNode **list = &(hashTable[hash(codice)]);

    LibroNode *prev = NULL;

    while (*list != NULL) {
        prev = *list;
        list = &(*list)->next;
    }

    LibroNode *node = malloc(sizeof(LibroNode));

    if (prev == NULL) {
        *list = node;
    }

    else {
        prev->next = node;
    }

    node->info = malloc(sizeof(Libro));
    Libro *book = node->info;
    book->titolo = malloc(sizeof(char) * (strlen(titolo) + 1));
    book->codice = malloc(sizeof(char) * (strlen(codice) + 1));
    strcpy(book->titolo, titolo);
    strcpy(book->codice, codice);
    book->autore = NULL;
    book->prestito = NULL;
    book->inPrestito = 0;
    node->next = NULL;

    return 0;
}

int aggiungiAutore(char *codice, char *autore) {
    LibroNode *list = lookup(codice);

    if (list == NULL)
        return -1;

    list->info->autore = malloc((strlen(autore) + 1) * sizeof(char));
    strcpy(list->info->autore, autore);
    return 0;
}

int aggiungiPrestito(char *codice, char *data) {
    LibroNode *list = lookup(codice);

    if (list == NULL)
        return -1;

    list->info->inPrestito = 1;
    list->info->prestito = malloc(sizeof(Prestito));
    Prestito *p = list->info->prestito;
    p->data = malloc(sizeof(char)*(strlen(data)+1));
    p->codiceLibro = malloc(sizeof(char)*(strlen(codice)+1));
    strcpy(p->codiceLibro, codice);
    strcpy(p->data, data);
    return 0;
}

void freeHashTable() {
    for (int i = 0; i < HASHSIZE; i++) {
        freeList(hashTable[i]);
    }
}

void freeList(LibroNode *list) {
    if (list == NULL)
        return;

    while (list != NULL)
    {
        LibroNode *tmp = list->next;
        freeBook(list->info);
        free(list);
        list = tmp;
    }
};

void freeBook(Libro *book) {
    free(book->autore);
    free(book->titolo);
    free(book->codice);

    if (book->inPrestito) {
        free(book->prestito->codiceLibro);
        free(book->prestito->data);
        free(book->prestito);
    }

    free(book);
}

void printAvaiableBooks() {
    for (int i = 0; i < HASHSIZE; ++i) {
        if(hashTable[i] != NULL) {
            LibroNode *tmp = hashTable[i];
            while(tmp != NULL) {
                if(!tmp->info->prestito) {
                    printf("(%s).%s\n", tmp->info->titolo, tmp->info->autore != NULL ? tmp->info->autore : "");
                }
                tmp = tmp->next;
            }
        }
    }
}

void printLoanedBooks() {
    for (int i = 0; i < HASHSIZE; ++i) {
        if(hashTable[i] != NULL) {
            LibroNode *tmp = hashTable[i];
            while(tmp != NULL) {
                if(tmp->info->inPrestito) {
                    printf("%s: %s", tmp->info->titolo, tmp->info->prestito->data);
                }
                tmp = tmp->next;
            }
        }
    }
}
