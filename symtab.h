#ifndef SYMTAB_H
#define SYMTAB_H

#define MAX_SYMBOLS 100

typedef struct {
    char* name;
    int value;
} Symbol;

typedef struct {
    Symbol symbols[MAX_SYMBOLS];
    int count;
} SymbolTable;

extern SymbolTable symtab;

void init_symtab(void);
Symbol* lookup_symbol(const char* name);
Symbol* add_symbol(const char* name);
void set_symbol_value(const char* name, int value);
int get_symbol_value(const char* name);

#endif