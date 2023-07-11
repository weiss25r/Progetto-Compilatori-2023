#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#define HASHSIZE 101

struct Book{
    char *author;
    char *title;
    char *bookCode;
    bool loaned;
    char *loanDate;
};

typedef struct Book Book;

typedef struct BookNode {
    struct BookNode *next;
    Book *info;
}BookNode;

unsigned int hash(char *codice);
BookNode *lookup(char *codice);
int insert(char *title, char *bookCode, char *author);
int addLoan(char *bookCode, char *date);
void freeHashTable();
void freeList(BookNode *list);
void freeBook(Book *book);
void printAvailableBooks(FILE *stream);
void printLoanedBooks(FILE *stream);