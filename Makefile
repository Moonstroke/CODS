# Compilation parameters
DEBUG := n


# Directories
INC_DIR := inc
SRC_DIR := src
OBJ_DIR := obj

# Executables
TEST_EXEC := test_array


# Tests files
TEST_SRC := $(wildcard $(SRC_DIR)/test*.c)
TEST_OBJ := $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(TEST_SRC))

# Common files
SRC := $(filter-out $(TEST_SRC), $(wildcard $(SRC_DIR)/*.c))
OBJ := $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRC))

# Library archive
LIB := libarray.a


# Documentation
DOC_PRG := doxygen
DOC_CFG := Doxyfile
DOC_DIR := doc


# Compilation flags
CC := gcc
CFLAGS := -std=c11 -pedantic -Wall -Wextra -Wpadded
ifeq ($(DEBUG), y)
	CFLAGS += -g
endif
LDLIBS := -llog
LDFLAGS := -I$(INC_DIR)



.PHONY: all clean distclean doc test testclean

all: testclean $(LIB)

$(LIB): $(OBJ)
	$(AR) rcs $(LIB) $(OBJ_DIR)/*.o

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	mkdir -p $(OBJ_DIR)
	$(CC) -c $< -o$@ $(LDFLAGS) $(CFLAGS)


clean:
	rm -rf $(OBJ_DIR)

distclean: clean
	rm -rf $(TEST_EXEC)
	rm -rf $(LIB)
	rm -rf $(DOC_DIR)

doc:
	$(DOC_PRG) $(DOC_CFG)

test: $(TEST_OBJ) $(OBJ)
	$(CC) -o$(TEST_EXEC) $^ $(LDLIBS)
	./$(TEST_EXEC)

testclean:
	rm -rf $(TEST_OBJ) $(TEST_EXEC)
