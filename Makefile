# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
SPHINXPROJ    = crypto101
SOURCEDIR     = .
BUILDDIR      ?= _build_en

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

# Serve _build/html with Python built-in server
serve: html
	cd $(BUILDDIR)/html && python3 -m http.server

deploy: html
	rsync -r $(BUILDDIR)/html/* multun@multun.net:/srv/www/crypto101.multun.net/

tx_push:
	# regenerate the .pot translatable strings files
	sphinx-build -b gettext . _build/gettext
	# push the strings to transifex
	tx push -s

tx_pull:
	# pull all community translated strings
	tx pull -a

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	make -f Makefile.assets
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
