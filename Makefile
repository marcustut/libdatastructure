NAME = libdatastructure
CC = clang
CCFLAGS = -std=c11
INCLUDES = -I.
LFLAGS = 
LIBS = 

LDFLAGS = -Wl,-soname=$(SHARED)

TEST_BIN = $(NAME)_test
SHARED = $(NAME).so
STATIC = $(NAME).a

PREFIX ?= /usr/local
INCLUDE_PATH ?= include/libdatastructure
LIBRARY_PATH ?= lib
INSTALL_INCLUDE_PATH = $(DESTDIR)$(PREFIX)/$(INCLUDE_PATH)
INSTALL_LIBRARY_PATH = $(DESTDIR)$(PREFIX)/$(LIBRARY_PATH)
INSTALL ?= cp -a

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	TEST_INCLUDES += -I/usr/local/include
	TEST_LFLAGS += -L/usr/local/lib
	TEST_LIBS += -lcriterion
endif
ifeq ($(UNAME_S),Darwin)
	SHARED = $(NAME).dylib
	LDFLAGS = ""

	TEST_INCLUDES += -I/opt/homebrew/include
	TEST_LFLAGS += -L/opt/homebrew/lib
	TEST_LIBS += -lcriterion
endif

ifdef RELEASE
	CCFLAGS += -O3
else
	CCFLAGS += -g3
	CCFLAGS += -Wall -Wextra -Wconversion -Wdouble-promotion -Wno-unused-parameter -Wno-unused-function -Wno-sign-conversion
	CCFLAGS += -fsanitize=address,undefined -fsanitize-trap
	LDFLAGS += -fsanitize=address,undefined -fsanitize-trap
endif

HEADERS = $(shell find include -name '*.h')
SRCS = $(shell find src -name '*.c')
OBJS = $(SRCS:.c=.o)

ifdef TEST
	TESTS = $(shell find tests -name '*.c')
	OBJS += $(TESTS:.c=.o)
endif

all: shared static tests

tests: $(TEST_BIN)

shared: $(SHARED)

static: $(STATIC)

$(TEST_BIN): $(OBJS)
	$(CC) $(CCFLAGS) $(INCLUDES) $(TEST_INCLUDES) -o $(TEST_BIN) $< $(LFLAGS) $(TEST_LFLAGS) $(LIBS) $(TEST_LIBS)

$(STATIC): $(OBJS)
	$(AR) rcs $@ $<

$(SHARED): $(OBJS)
	$(CC) -shared -o $@ $< $(LDFLAGS)

$(OBJS): $(SRCS) $(HEADERS)

.c.o:
	$(CC) $(CCFLAGS) $(INCLUDES) -c $< -o $@

.PHONY: deps format test install clean

deps:
	./install-deps.sh

format:
	@find . -type f \( -iname \*.c -o -iname \*.h \) | xargs clang-format -i && \
		echo "Formatted all .c and .h files in project"

# valgrind: clean all
# 	valgrind \
# 		--leak-check=full \
# 		--show-leak-kinds=all \
# 		--track-origins=yes \
# 		--verbose \
# 		--log-file=vg.out \
# 		./$(MAIN) config.yaml

test: tests
	./$(TEST_BIN)

install: 
	mkdir -p $(INSTALL_LIBRARY_PATH) $(INSTALL_INCLUDE_PATH)
	$(INSTALL) $(HEADERS) $(INSTALL_INCLUDE_PATH)
	$(INSTALL) $(STATIC) $(SHARED) $(INSTALL_LIBRARY_PATH)

clean:
	$(RM) *_test *.a *.dylib *.so src/*.o
