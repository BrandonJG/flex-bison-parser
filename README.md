# flex-bison-parser
Analizador sintactico

Para Compilar (viejas instrucciones)

```
    bison -d sintactico.y
    flex sintactico.l
    gcc sintactico.tab.c lex.yy.c -o sintactico -lm
```

Nuevas instrucciones

```
    yacc -d sintactico.y
    lex sintactico.l
    gcc tabla.c y.tab.c lex.yy.c -o sintactico
```


    
Para ejecutar

    $ ./sintactico
