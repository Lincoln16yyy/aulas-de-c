CC      ?= gcc
CFLAGS  ?= -std=c11 -Wall -Wextra
LDLIBS  ?= -lm
BUILD   ?= build

SRCS := $(shell find . -name '*.c' -not -path './$(BUILD)/*')
OBJS := $(patsubst ./%.c,$(BUILD)/%.o,$(SRCS))
BINS := $(patsubst $(BUILD)/%.o,$(BUILD)/%,$(OBJS))

.DEFAULT_GOAL := all

.PHONY: all build check clean list run help

## build: compila todos os programas em $(BUILD)/
build: $(BINS)

all: build

## check: apenas compila, sem gerar executáveis (útil para validar a sintaxe)
check:
	@for src in $(SRCS); do \
		echo "  $(CC) $$src"; \
		$(CC) $(CFLAGS) -fsyntax-only $$src || exit 1; \
	done
	@echo "Todos os $(words $(SRCS)) arquivos compilaram sem erros."

## list: lista todos os programas disponíveis
list:
	@for src in $(SRCS); do echo $$src; done

## run: compila e executa um programa. Ex: make run SRC=exercicios/01-condicionais/exercicio_07.c
run:
ifeq ($(strip $(SRC)),)
	$(error informe o arquivo. Ex: make run SRC=exercicios/01-condicionais/exercicio_07.c)
endif
	@$(MAKE) --no-print-directory $(BUILD)/$(SRC:.c=)
	@echo "--- executando $(SRC) ---"
	@./$(BUILD)/$(SRC:.c=)

$(BUILD)/%: $(BUILD)/%.o
	@$(CC) $(CFLAGS) $(LDFLAGS) $< -o $@ $(LDLIBS)

$(BUILD)/%.o: %.c
	@mkdir -p $(dir $@)
	@$(CC) $(CFLAGS) -c $< -o $@

clean:
	@rm -rf $(BUILD)
	@find . -name '*.bin' -o -name 'a.out' | xargs -r rm -f
	@echo "Limpo."

help:
	@echo "Alvos disponíveis:"
	@grep -E '^## ' $(MAKEFILE_LIST) | sed 's/^## /  /'
