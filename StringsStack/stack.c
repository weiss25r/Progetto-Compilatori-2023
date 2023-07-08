#include <stdio.h>
#include <stdlib.h>
#include "stack.h"
#include <string.h>

static StackNodePtr top = NULL;

int stackIsEmpty(void) {
    return top == NULL;
}

void stackPush(char *item)
{
    StackNodePtr newTop = malloc(sizeof(*newTop));

    if(newTop != NULL) {
        newTop->item = malloc((strlen(item)+1)*sizeof(char));
        strcpy(newTop->item, item);
        newTop->next = top;
        top = newTop;
    }
}

char *stackPop(void)
{
    if(!stackIsEmpty()) {
        StackNodePtr tmp = top->next;
        char *data = top->item;
        free(top);
        top = tmp;
        return data;
    }

    else return NULL;
}