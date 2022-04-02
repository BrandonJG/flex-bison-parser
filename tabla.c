#include "tabla.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

Nodo *crearNodo(Simbolo *simbolo){
    int flag = simbolo->flag;
    Nodo *nodo = (Nodo*) malloc(sizeof(Nodo));
    strcpy(nodo->simbolo.nombre, simbolo->nombre);
    nodo->simbolo.flag = flag;
    switch (flag)
    {
    case 1: //flag para enteros
        nodo->simbolo.ival = simbolo->ival;
        break;
    case 2: //flag para flotantes
        nodo->simbolo.fval = simbolo->fval;
        break;
    case 3: //flag para caracteres
        nodo->simbolo.string[0] = simbolo->string[0];
        break;
    case 4: //flag para cadenas
        strcpy(nodo->simbolo.string, simbolo->string);
        break;
    default:
        break;
    }
    nodo->siguiente = NULL;
    return nodo;
}

void destruirNodo(Nodo* nodo){

}

void insertar(Lista *lista, Simbolo *simbolo){
    Nodo *nodo = crearNodo(simbolo);
    nodo->siguiente = lista->cabeza;
    lista->cabeza = nodo;
    lista->longitud++;
}

Simbolo* buscar(Lista *lista, char *nombre){
    Nodo *aux = lista->cabeza;
    while(aux){
        if(strcmp(aux->simbolo.nombre, nombre) == 0){
            return &aux->simbolo;
        }
        aux = aux->siguiente;
    }
    return NULL;
}

void modificarInt(Lista *lista, char *simbolo, int valor){
    Simbolo *buscado = buscar(lista, simbolo);
    buscado->ival = valor;
}

void modificarFloat(Lista *lista, char *simbolo, float valor){
    Simbolo *buscado = buscar(lista, simbolo);
    buscado->fval = valor;
}

void modificarChar(Lista *lista, char *simbolo, char valor){
    Simbolo *buscado = buscar(lista, simbolo);
    buscado->string[0] = valor;
}

void modificarString(Lista *lista, char *simbolo, char *valor){
    Simbolo *buscado = buscar(lista, simbolo);
    strcpy(buscado->string, valor);
}

void imprimirLista(Lista* lista){
    Nodo *aux = lista->cabeza;
    while(aux!=NULL){
        printf("%s \n",aux->simbolo.nombre);
        switch (aux->simbolo.flag){
        case 1: printf("Entero: %d\n", aux->simbolo.ival);
            break;
        case 2: printf("Flotante: %.3f\n", aux->simbolo.fval);
            break;
        case 3: printf("Caracter: %c\n", aux->simbolo.string[0]);
            break;
        case 4: printf("String: %s\n", aux->simbolo.string);
            break;
        default: printf("Sin tipo de dato\n");
            break;
        }
        aux = aux->siguiente;
    }
}