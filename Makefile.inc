# Configuration
SHM_DIR := /dev/shm/lss-build
CUR_DIR := $(shell basename $(CURDIR))
PARENT_DIR := $(shell basename $(dir $(CURDIR)))
BUILD_PATH := $(SHM_DIR)/$(PARENT_DIR)/$(CUR_DIR)

# PDF Engine and Options
# XeLaTeX works great with Moloch and is often faster for fonts
# LuaLaTeX is used if xelatex is not specified
ENGINE ?= xelatex
PANDOC_FLAGS := -s --metadata-file=config.yml -d defaults.yml

# Determine if we are building slides (beamer) or standard documents
ifeq ($(findstring slides,$(CUR_DIR)),slides)
	PANDOC_DOC_FLAGS = -t beamer --slide-level=2
else
	PANDOC_DOC_FLAGS =
endif

# Target construction
ALL_PDF := $(patsubst %.md,%.pdf,$(wildcard *.md))
ALL_PDF := $(filter-out README.pdf, $(ALL_PDF))

.PHONY: all clean pdf

all: $(ALL_PDF)
pdf: $(ALL_PDF)

%.pdf: %.md
	@mkdir -p $(BUILD_PATH)/$*
	@pandoc $(PANDOC_FLAGS) $(PANDOC_DOC_FLAGS) \
		--pdf-engine=latexmk \
		--pdf-engine-opt=-outdir=$(BUILD_PATH)/$* \
		--pdf-engine-opt=-pdflatex=$(ENGINE) \
		-o $(BUILD_PATH)/$*/$@ $<
	@cp $(BUILD_PATH)/$*/$@ $@

clean:
	rm -rf *.pdf
	rm -rf $(BUILD_PATH)
