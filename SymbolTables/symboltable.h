#include <stdio.h>
#include <stdlib.h>
#define HASHSIZE 101

typedef struct {
    char *codiceLibro;
    char *data;
}Prestito;

struct Libro{
    char *autore;
    char *titolo;
    char *codice;
    char inPrestito;
    Prestito *prestito;
};

typedef struct Libro Libro;

typedef struct LibroNode {
    struct LibroNode *next;
    Libro *info;
}LibroNode;

unsigned int hash(char *codice);
LibroNode *lookup(char *codice);
int insert(char *titolo, char *codice);
int aggiungiAutore(char *codice, char *autore);
int aggiungiPrestito(char *codice, char *data);
void freeHashTable();
void freeList(LibroNode *list);
void freeBook(Libro *book);
void printAvaiableBooks();
void printLoanedBooks();