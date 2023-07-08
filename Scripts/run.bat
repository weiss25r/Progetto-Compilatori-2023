bison parser.y -d
flex scanner.fl
gcc lex.yy.c parser.tab.c SymbolTables/symboltable.c StringsStack/stack.c
a.exe InputFiles/input2.txt