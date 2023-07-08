typedef struct stackNode {
    char *item;
    struct stackNode *next;
} StackNode;

typedef StackNode *StackNodePtr;

int stackIsEmpty(void);
void stackPush(char *string);
char *stackPop(void);
