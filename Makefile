CC=gcc
CFLAGS=-I. -Wall
UNAME_S := $(shell uname -s)

# Adjust libraries based on the system
ifeq ($(UNAME_S),Linux)
    LIBS=-lfl -ly
else ifeq ($(UNAME_S),Darwin)
    LIBS=-ll -ly
else
    LIBS=-lfl
endif

# Object files
OBJS = lex.yy.o parser.tab.o tac.o symtab.o

# Final executable name
TARGET = hamro_compiler

# Default target
all: $(TARGET)

# Link the final executable
$(TARGET): $(OBJS)
	$(CC) -o $(TARGET) $(OBJS) $(LIBS)

# Generate lexer
lex.yy.c: lexer.l parser.tab.h
	flex lexer.l

# Generate parser
parser.tab.c parser.tab.h: parser.y
	bison -d parser.y

# Compile the generated lexer
lex.yy.o: lex.yy.c parser.tab.h
	$(CC) $(CFLAGS) -c lex.yy.c

# Compile the generated parser
parser.tab.o: parser.tab.c
	$(CC) $(CFLAGS) -c parser.tab.c

# Compile TAC implementation
tac.o: tac.c tac.h
	$(CC) $(CFLAGS) -c tac.c

# Compile symbol table implementation
symtab.o: symtab.c symtab.h
	$(CC) $(CFLAGS) -c symtab.c

# Clean up generated files
clean:
	rm -f $(TARGET) $(OBJS) lex.yy.c parser.tab.c parser.tab.h *~

# Phony targets
.PHONY: all clean
