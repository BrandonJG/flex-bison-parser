# flex-bison-parser
Analizador sintactico

Para Compilar

    $ bison -d sintactico.y
    $ flex sintactico.l
    $ gcc sintactico.tab.c lex.yy.c -o sintactico -lm
    
Para ejecutar

    $ ./sintactico
