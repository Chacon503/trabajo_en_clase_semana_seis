#ifndef SYMBOLS_H
#define SYMBOLS_H

typedef  enum {
    TYPE_INT,
    TYPE_DOUBLE,
    TYPE_STRING,
    TYPE_CHAR,
    TYPE_BOOL,
} DataType;

typedef enum {
    STR_ALLOC_NONE,
    STR_ALLOC_HEAP,
    STR_ALLOC_STACK,
    STR_ALLOC_READONLY
} StringAllocType;

typedef struct SymbolEntry {
    DataType        data_type;
    StringAllocType str_alloc;
    int             i_value;
    double          d_value;
    char            c_value;
    int             b_value;
    char           *s_value;
    char           *identifier;
} SymbolEntry;

SymbolEntry *create_entry(char *name);
void         free_entry(SymbolEntry *entry);


#endif // SYMBOLS_H
