PBM_FILES := $(shell find Illustrations/ -type f -name '*.pbm')
SVG_FILES := $(shell find Illustrations/ -type f -name '*.svg')
PDF_FILES = $(patsubst %.pbm,%.pdf,${PBM_FILES})
SVG_PDF_FILES = $(patsubst %.svg,%.pdf,${SVG_FILES})

.PHONY: all clean

all: Illustrations/ModularArithmetic/Clock2.pdf Crypto101.pdf

Illustrations/ModularArithmetic/Clock2.pdf: Illustrations/ModularArithmetic/Source/Clock.svg
	convert $< $@

Crypto101.pdf: ${PDF_FILES} ${SVG_PDF_FILES} Crypto101.tex Header.tex Glossary.tex Crypto101.bib
	latexmk -bibtex -pdf -gg Crypto101.tex

Crypto101.tex: Crypto101.org
	emacs -Q --batch --file Crypto101.org --eval "(progn (setq org-confirm-babel-evaluate nil) (org-latex-export-to-latex))"

%.pdf: %.svg
	@cd $(dir $@); convert $(notdir $<) ../$(notdir $@)

%.pdf: %.pbm
	potrace -b pdf $<

clean:
	find Illustrations -name '*.pdf' -exec rm {} \;
	rm -f Crypto101.tex Crypto101.pdf Crypto101.acn  Crypto101.aux  Crypto101.glo  Crypto101.idx  Crypto101.ist  Crypto101.log  Crypto101.out  Crypto101.pdf  Crypto101.pyg
