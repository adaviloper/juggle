SPEC=

RUN=nvim --headless --noplugin -u spec.lua

.PHONY: prepare test all

prepare:
	git submodule update --depth 1 --init
	mkdir -p vendor/tree-sitter-parsers
	test -d vendor/tree-sitter-parsers/php || git clone https://github.com/tree-sitter/tree-sitter-php vendor/tree-sitter-parsers/php
	test -d vendor/tree-sitter-parsers/javascript || git clone https://github.com/tree-sitter/tree-sitter-javascript vendor/tree-sitter-parsers/javascript
	test -d vendor/tree-sitter-parsers/typescript || git clone https://github.com/tree-sitter/tree-sitter-typescript vendor/tree-sitter-parsers/typescript
	luarocks install luacheck --local

test:
ifeq ($(strip $(SPEC)),)
	@$(RUN) -c "PlenaryBustedDirectory spec/ { minimal_init = 'spec.lua' }"
else
	@$(RUN) -c "PlenaryBustedFile $(SPEC)"
endif

all: prepare test

