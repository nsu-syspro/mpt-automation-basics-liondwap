NAME := $(shell jq -r .name config.json)
VERSION := $(shell jq -r .version config.json)

BUILD_DIR := build
TARGET := $(BUILD_DIR)/$(NAME)
SRC := src/wordcount.c
TESTS := $(wildcard test/*.txt)

CFLAGS := -Wall -Wextra -DNAME=\"$(NAME)\" -DVERSION=\"$(VERSION)\"

.PHONY: all clean check

all: $(TARGET)

$(TARGET): $(SRC) config.json
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) $(SRC) -o $(TARGET)

check: $(TARGET)
	@for test_file in $(TESTS); do \
		expected_file="$${test_file%.txt}.expected"; \
		$(TARGET) "$$test_file" | diff -u "$$expected_file" - || exit 1; \
	done

clean:
	rm -rf $(BUILD_DIR)
