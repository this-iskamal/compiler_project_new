#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtab.h"

SymbolTable symtab;

void init_symtab() {
    fprintf(stderr, "DEBUG: Initializing symbol table\n");
    symtab.count = 0;
}

Symbol* lookup_symbol(const char* name) {
    fprintf(stderr, "DEBUG: Looking up symbol: %s\n", name);
    for (int i = 0; i < symtab.count; i++) {
        if (strcmp(symtab.symbols[i].name, name) == 0) {
            fprintf(stderr, "DEBUG: Found symbol %s\n", name);
            return &symtab.symbols[i];
        }
    }
    fprintf(stderr, "DEBUG: Symbol %s not found\n", name);
    return NULL;
}

Symbol* add_symbol(const char* name) {
    fprintf(stderr, "DEBUG: Adding symbol: %s\n", name);
    if (symtab.count >= MAX_SYMBOLS) {
        fprintf(stderr, "Error: Symbol table full\n");
        exit(1);
    }
    
    Symbol* sym = lookup_symbol(name);
    if (sym != NULL) {
        return sym;
    }
    
    symtab.symbols[symtab.count].name = strdup(name);
    symtab.symbols[symtab.count].value = 0;
    return &symtab.symbols[symtab.count++];
}

void set_symbol_value(const char* name, int value) {
    Symbol* sym = lookup_symbol(name);
    if (sym == NULL) {
        sym = add_symbol(name);
    }
    sym->value = value;
}

int get_symbol_value(const char* name) {
    Symbol* sym = lookup_symbol(name);
    if (sym == NULL) {
        fprintf(stderr, "Error: Undefined variable %s\n", name);
        exit(1);
    }
    return sym->value;
}