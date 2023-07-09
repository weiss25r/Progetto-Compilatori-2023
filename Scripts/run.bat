bison parser.y -d
flex scanner.fl
gcc -o biblioteca lex.yy.c parser.tab.c SymbolTable/symboltable.c StringsStack/stack.c
biblioteca.exe InputFiles/first.txt out1.txt
biblioteca.exe InputFiles/second.txt out2.txt
biblioteca.exe InputFiles/third.txt out3.txt
biblioteca.exe InputFiles/fourth.txt out4.txt
