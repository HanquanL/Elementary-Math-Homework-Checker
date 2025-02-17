# Makefile for Elementary-Math-Homework-Checker

# Compiler and tools
FLEX = flex
BISON = bison
CXX = g++
RM = rm -f

# Files
LEX_FILE = hl6255.hwchecker.l
YACC_FILE = hl6255.hwchecker.y
LEX_OUTPUT = lex.yy.c
YACC_OUTPUT = hl6255.hwchecker.tab.c
YACC_HEADER = hl6255.hwchecker.tab.h
EXECUTABLE = hl6255.hwchecker

# Targets
all: $(EXECUTABLE)

$(EXECUTABLE): $(LEX_OUTPUT) $(YACC_OUTPUT)
	$(CXX) -o $@ $(LEX_OUTPUT) $(YACC_OUTPUT)

$(LEX_OUTPUT): $(LEX_FILE)
	$(FLEX) -o $@ $<

$(YACC_OUTPUT): $(YACC_FILE)
	$(BISON) -d -o $@ $<

clean:
	$(RM) $(LEX_OUTPUT) $(YACC_OUTPUT) $(YACC_HEADER) $(EXECUTABLE)

.PHONY: all clean