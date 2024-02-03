NAME = libdatastructure
CC = clang
CCFLAGS = -std=c11
INCLUDES = -I.
LFLAGS = 
LIBS = 

TEST = $(NAME)_test
SHARED = $(NAME).so
STATIC = $(NAME).a

LDFLAGS = -Wl,-soname=$(SHARED)

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	ifdef TEST
		INCLUDES += /usr/local/include
		LFLAGS += -L/usr/local/lib
		LIBS += -lcriterion
	endif
endif
ifeq ($(UNAME_S),Darwin)
	SHARED = $(NAME).dylib
	LDFLAGS = ""

	ifdef TEST
		INCLUDES += /opt/homebrew/include
		LFLAGS += -L/opt/homebrew/lib
		LIBS += -lcriterion
	endif
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

all: shared static

shared: $(SHARED)

static: $(STATIC)

$(STATIC): $(OBJS)
	$(AR) rcs $@ $<

$(SHARED): $(OBJS)
	$(CC) -shared -o $@ $< $(LDFLAGS)

$(OBJS): $(SRCS) $(HEADERS)

.c.o:
	$(CC) $(CCFLAGS) $(INCLUDES) -c $< -o $@

.PHONY: deps format valgrind run clean

deps:
	./install-deps.sh

format:
	find . -type f \( -iname \*.c -o -iname \*.h \) | xargs clang-format -i

# valgrind: clean all
# 	valgrind \
# 		--leak-check=full \
# 		--show-leak-kinds=all \
# 		--track-origins=yes \
# 		--verbose \
# 		--log-file=vg.out \
# 		./$(MAIN) config.yaml

# run: clean all
# 	./$(MAIN) config.yaml

clean:
	$(RM) *.a *.dylib *.so src/*.o
