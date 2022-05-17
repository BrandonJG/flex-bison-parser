#ifndef TABLA_H
#define TABLA_H

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef struct Simbolo
{
    char nombre[50];
    int flag;
    int ival;
    float fval;
    char string[100];
}Simbolo;

typedef struct  Nodo
{
    Simbolo simbolo;
    struct Nodo *siguiente;
}Nodo;

typedef struct Lista
{
    Nodo *cabeza;
    int longitud;
}Lista;

Nodo *crearNodo(Simbolo *simbolo);

void destruirNodo(Nodo* nodo);

void insertar(Lista *lista, Simbolo *simbolo);

Simbolo *buscar(Lista *lista, char *nombre);

void modificarInt(Lista *lista, char *simbolo, int valor);

void modificarFloat(Lista *lista, char *simbolo, float valor);

void modificarChar(Lista *lista, char *simbolo, char valor);

void modificarString(Lista *lista, char *simbolo, char *valor);

void imprimirLista(Lista* lista);

char* tipoDeDato(int tipo);

#endif