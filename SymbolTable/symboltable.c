#include "symboltable.h"
#include <string.h>

static BookNode *hashTable[HASHSIZE];

unsigned int hash(char *codice) {
    if (codice == NULL)
        return 0;

    int hashValue = 0;
    for (int i = 0; i < strlen(codice); i++) {
        hashValue = (127 * hashValue + codice[i]) % HASHSIZE;
    }

    return hashValue;
}

BookNode *lookup(char *codice) {
    BookNode *list = hashTable[hash(codice)];

    while (list != NULL && list->info->bookCode == codice) {
        list = list->next;
    }

    return list;
}

int insert(char *title, char *bookCode, char *author) {
    BookNode **list = &(hashTable[hash(bookCode)]);
    BookNode *prev = NULL;

    while (*list != NULL) {
        prev = *list;
        list = &(*list)->next;
    }

    BookNode *node = malloc(sizeof(BookNode));

    if (prev == NULL) {
        *list = node;
    }

    else {
        prev->next = node;
    }

    node->info = malloc(sizeof(Book));
    Book *book = node->info;
    book->title = malloc(sizeof(char) * (strlen(title) + 1));
    book->bookCode = malloc(sizeof(char) * (strlen(bookCode) + 1));
    strcpy(book->title, title);
    strcpy(book->bookCode, bookCode);
    book->author = NULL;
    book->loanDate = NULL;
    book->loaned = 0;
    node->next = NULL;
    book->author = malloc((strlen(author) + 1) * sizeof(char));
    strcpy(book->author, author);

    return 0;
}

int addLoan(char *bookCode, char *date) {
    BookNode *list = lookup(bookCode);

    if (list == NULL)
        return -1;

    list->info->loaned = 1;
    list->info->loanDate = malloc(sizeof(char) * (strlen(date) + 1));
    strcpy(list->info->loanDate, date);
    return 0;
}

void freeHashTable() {
    for (int i = 0; i < HASHSIZE; i++) {
        freeList(hashTable[i]);
    }
}

void freeList(BookNode *list) {
    if (list == NULL)
        return;

    while (list != NULL) {
        BookNode *tmp = list->next;
        freeBook(list->info);
        free(list);
        list = tmp;
    }
};

void freeBook(Book *book) {
    free(book->author);
    free(book->title);
    free(book->bookCode);

    if (book->loaned) {
        free(book->loanDate);
    }

    free(book);
}

void printAvailableBooks(FILE *stream) {
    fprintf(stream, "--LIBRI DISPONIBILI--\n");
    for (int i = 0; i < HASHSIZE; ++i) {
        if(hashTable[i] != NULL) {
            BookNode *tmp = hashTable[i];
            while(tmp != NULL) {
                if(tmp->info->loanDate == NULL) {
                    fprintf(stream, "(%s).%s\n", tmp->info->title, tmp->info->author != NULL ? tmp->info->author : "");
                }
                tmp = tmp->next;
            }
        }
    }
}

void printLoanedBooks(FILE *stream) {
    fprintf(stream, "\n--LIBRI IN PRESTITO--\n");
    for (int i = 0; i < HASHSIZE; ++i) {
        if(hashTable[i] != NULL) {
            BookNode *tmp = hashTable[i];
            while(tmp != NULL) {
                if(tmp->info->loanDate != NULL) {
                    fprintf(stream, "%s: %s\n", tmp->info->title, tmp->info->loanDate);
                }
                tmp = tmp->next;
            }
        }
    }
}
