flex lexical1.l
bison -d synt1.y
gcc lex.yy.c synt1.tab.c -lfl -ly -o 2compIsil2020.exe
