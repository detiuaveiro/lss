# Makefile
SHELL := /bin/bash
.PHONY: all clean

all clean:
	@total=$$(find . -mindepth 2 -name "Makefile" | wc -l); \
	current=0; \
	term_width=$$(tput cols); \
	echo "Build started at $$(date)" > build.log; \
	tput civis; \
	find . -mindepth 2 -name "Makefile" -print0 | while IFS= read -r -d '' mkfile; do \
		dir=$$(dirname "$$mkfile"); \
		current=$$((current + 1)); \
		percent=$$((current * 100 / total)); \
		non_bar=$$(printf "%3d%%%%| | %d/%d [%s]" "$$percent" "$$current" "$$total" "$$dir"); \
		non_bar_len=$${#non_bar}; \
		width=$$((term_width - non_bar_len)); \
		if [ $$width -lt 10 ]; then width=10; fi; \
		filled=$$((percent * width / 100)); \
		empty=$$((width - filled)); \
		bar_filled=$$(printf "%$${filled}s" | tr " " "#"); \
		bar_empty=$$(printf "%$${empty}s" | tr " " " "); \
		printf "\r%3d%%|%s%s| %d/%d [%s]\033[K" "$$percent" "$$bar_filled" "$$bar_empty" "$$current" "$$total" "$$dir"; \
		if ! $(MAKE) -s -C "$$dir" $@; then \
			printf "\nError processing %s. See build.log\n" "$$dir"; \
		fi; \
	done; \
	echo ""; \
	tput cnorm; \
	echo "Done."
