bison parser.y -d &&
flex scanner.fl &&
gcc -o biblioteca lex.yy.c parser.tab.c SymbolTable/symboltable.c StringsStack/stack.c &&
rm lex.yy.c
./biblioteca InputFiles/first.txt out1.txt
./biblioteca InputFiles/second.txt out2.txt
./biblioteca InputFiles/third.txt out3.txt
./biblioteca InputFiles/fourth.txt out4.txt
