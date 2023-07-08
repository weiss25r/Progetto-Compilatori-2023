bison parser.y -d &&
flex scanner.fl &&
gcc lex.yy.c parser.tab.c SymbolTable/symboltable.c StringsStack/stack.c &&
rm lex.yy.c
./a.out input2.txt