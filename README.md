# flex-bison-parser
Analizador sintactico

Para Compilar

    $ bison -d calc.y
    $ flex calc.l
    $ gcc calc.tab.c lex.yy.c -o calc -lm
    $ ./calc
