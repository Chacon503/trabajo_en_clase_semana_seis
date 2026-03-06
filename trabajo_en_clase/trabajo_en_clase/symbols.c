#include "symbols.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
SymbolEntry* root_table= NULL;

SymbolEntry* create_entry(char* name){
    //Asignar en memoria el nodo
    SymbolEntry *node =  (SymbolEntry*) malloc(sizeof(SymbolEntry));

    node->data_type = TYPE_INT;
    node->str_alloc  = STR_ALLOC_NONE;
    node->i_value    = 0;
    node->d_value    = 0.0;
    node->c_value    = '\0';
    node->b_value    = 0;
    node->s_value    = NULL;
    node->identifier = strdup(name);

    printf("Entry created: %s\n", name);
    return node;
}

void free_entry(SymbolEntry *entry) {
    if (!entry) return;

    free(entry->identifier);

    if (entry->data_type == TYPE_STRING) {
        switch (entry->str_alloc) {
            case STR_ALLOC_HEAP:
                free(entry->s_value);
                break;
            case STR_ALLOC_STACK:
            case STR_ALLOC_READONLY:
            case STR_ALLOC_NONE:
                break;
        }
    }

    free(entry);
}