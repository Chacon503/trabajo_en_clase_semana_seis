# Target
TARGET = ws_compiler

## Source Files
LEX_SRC = lexer.l
YAC_SRC = parser.y
SYM_SRC = symbols.c

## Generated Files
LEX_OUT = lex.yy.c
YAC_OUT = y.tab.c
YAC_HDR = y.tab.h

## Commands
CC = gcc
LEX = flex
YAC = bison -d -y
CFLAGS = -Wall

# 1. Link everything together
$(TARGET): $(YAC_OUT) $(LEX_OUT) $(SYM_SRC)
	$(CC) $(CFLAGS) $(YAC_OUT) $(LEX_OUT) $(SYM_SRC) -o $(TARGET)

# 2. Generate the Lexer C code (Depends on the Header from Yacc)
$(LEX_OUT): $(LEX_SRC) $(YAC_HDR)
	$(LEX) $(LEX_SRC)

# 3. Generate the Parser C code and Header (Depends ONLY on parser.y)
$(YAC_OUT) $(YAC_HDR): $(YAC_SRC)
	$(YAC) $(YAC_SRC)

clean:
	rm -f $(TARGET) $(LEX_OUT) $(YAC_OUT) $(YAC_HDR)

run: $(TARGET)
	./$(TARGET)
