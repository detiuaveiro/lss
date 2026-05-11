# Makefile
SHELL := /bin/bash
.PHONY: all clean

all clean:
	@mapfile -d '' mkfiles < <(find . -mindepth 2 -name "Makefile" -print0 | sort -z); \
	tasks=(); \
	unique_dirs=(); \
	for mkfile in "$${mkfiles[@]}"; do \
		dir=$$(dirname "$$mkfile"); \
		unique_dirs+=("$$dir"); \
		mapfile -d '' mdfiles < <(find "$$dir" -maxdepth 1 -name "*.md" ! -name "README.md" -print0 | sort -z); \
		for mdfile in "$${mdfiles[@]}"; do \
			tasks+=("$$dir:$$(basename "$$mdfile")"); \
		done; \
	done; \
	total=$${#tasks[@]}; \
	if [ "$@" = "clean" ]; then \
		mapfile -t unique_dirs < <(printf "%s\n" "$${unique_dirs[@]}" | sort -u); \
		total=$${#unique_dirs[@]}; \
	fi; \
	if [ $$total -eq 0 ]; then echo "No work to do."; exit 0; fi; \
	max_dir=0; max_file=0; \
	for task in "$${tasks[@]}"; do \
		d=$${task%%:*}; f=$${task#*:}; \
		if [ $${#d} -gt $$max_dir ]; then max_dir=$${#d}; fi; \
		if [ $${#f} -gt $$max_file ]; then max_file=$${#f}; fi; \
	done; \
	tput civis; \
	trap 'tput cnorm; exit 1' SIGINT SIGTERM; \
	if [ "$@" = "all" ]; then \
		for ((i=0; i<total; i++)); do \
			task=$${tasks[i]}; \
			dir=$${task%%:*}; file=$${task#*:}; \
			target=$${file%.md}.pdf; \
			current=$$((i + 1)); \
			percent=$$((current * 100 / total)); \
			term_width=$$(tput cols); \
			info=$$(printf "[%-$${max_dir}s] %-$${max_file}s" "$$dir" "$$file"); \
			prefix=$$(printf "%3d%%|" "$$percent"); \
			suffix=$$(printf "| %d/%d %s" "$$current" "$$total" "$$info"); \
			bar_width=$$((term_width - $${#prefix} - $${#suffix})); \
			if [ $$bar_width -lt 5 ]; then bar_width=5; fi; \
			filled=$$((percent * bar_width / 100)); \
			empty=$$((bar_width - filled)); \
			bar=$$(printf "%$${filled}s" | tr " " "#")$$(printf "%$${empty}s"); \
			printf "\r%s%s%s\033[K" "$$prefix" "$$bar" "$$suffix"; \
			if ! $(MAKE) -s -C "$$dir" "$$target" > /dev/null 2>&1; then \
				printf "\nError: %s/%s failed.\n" "$$dir" "$$file"; \
			fi; \
		done; \
	else \
		for ((i=0; i<total; i++)); do \
			dir=$${unique_dirs[i]}; \
			current=$$((i + 1)); \
			percent=$$((current * 100 / total)); \
			term_width=$$(tput cols); \
			info=$$(printf "Cleaning [%-$${max_dir}s]" "$$dir"); \
			prefix=$$(printf "%3d%%|" "$$percent"); \
			suffix=$$(printf "| %d/%d %s" "$$current" "$$total" "$$info"); \
			bar_width=$$((term_width - $${#prefix} - $${#suffix})); \
			if [ $$bar_width -lt 5 ]; then bar_width=5; fi; \
			filled=$$((percent * bar_width / 100)); \
			empty=$$((bar_width - filled)); \
			bar=$$(printf "%$${filled}s" | tr " " "#")$$(printf "%$${empty}s"); \
			printf "\r%s%s%s\033[K" "$$prefix" "$$bar" "$$suffix"; \
			$(MAKE) -s -C "$$dir" clean > /dev/null 2>&1; \
		done; \
	fi; \
	echo ""; \
	tput cnorm; \
	echo "Done."
