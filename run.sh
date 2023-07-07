bison parser.y -d
flex scanner.fl
gcc lex.yy.c parser.tab.c SymbolTables/symboltable.c