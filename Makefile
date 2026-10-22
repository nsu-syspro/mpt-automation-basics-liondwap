NAME := $(shell jq -r .name config.json)
VERSION := $(shell jq -r .version config.json)

BUILD_DIR := build
TARGET := $(BUILD_DIR)/$(NAME)
SRC := src/wordcount.c
TESTS := $(wildcard test/*.txt)
CHECKS := $(TESTS:.txt=.check)

CFLAGS := -Wall -Wextra -DNAME=\"$(NAME)\" -DVERSION=\"$(VERSION)\"

.PHONY: all clean check

all: $(TARGET)

$(TARGET): $(SRC) config.json
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) $(SRC) -o $(TARGET)

check: $(CHECKS)

%.check: %.txt $(TARGET)
	@$(TARGET) $< | diff -u $*.expected -

clean:
	rm -rf $(BUILD_DIR)
