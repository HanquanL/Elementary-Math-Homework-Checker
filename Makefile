# Makefile for hl6255.hwchecker project

# Compiler and flags
CC = g++
CFLAGS = -Wall -g

# Final executable name
TARGET = hl6255.hwchecker

# Source files for Bison and Flex
BISON_SOURCE = hl6255.hwchecker.y
FLEX_SOURCE  = hl6255.hwchecker.l

# Bison-generated files
BISON_C = calc2.tab.c
BISON_H = calc2.tab.h

# Flex-generated file
FLEX_C = lex.yy.c

# Object files
OBJS = calc2.tab.o lex.yy.o

# Default target: build the executable
all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS) -lfl

# Compile the Bison-generated C file
calc2.tab.o: $(BISON_C)
	$(CC) $(CFLAGS) -c $(BISON_C)

# Compile the Flex-generated C file
lex.yy.o: $(FLEX_C)
	$(CC) $(CFLAGS) -c $(FLEX_C)

# Generate Bison files from the Bison source file
$(BISON_C) $(BISON_H): $(BISON_SOURCE)
	bison -d -o $(BISON_C) $(BISON_SOURCE)

# Generate the Flex file from the Flex source file (depends on the Bison header)
$(FLEX_C): $(FLEX_SOURCE) $(BISON_H)
	flex $(FLEX_SOURCE)

# Clean up generated files and object files
clean:
	rm -f $(TARGET) $(BISON_C) $(BISON_H) $(FLEX_C) *.o

.PHONY: all clean
