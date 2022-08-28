#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import pathlib
from string import Template
from sphinx.locale import _

try:
    # monkey patch the list of nodes to be treated as literal nodes during translation
    # workaround for https://github.com/sphinx-doc/sphinx/issues/7968
    import sphinx.transforms.i18n as i18n
    import docutils.nodes as nodes
    if nodes.math_block not in i18n.LITERAL_TYPE_NODES:
        i18n.LITERAL_TYPE_NODES = i18n.LITERAL_TYPE_NODES + (nodes.math_block,)
except:
    pass

root = pathlib.Path(__file__).parent
sys.path.insert(0, str(root))

extensions = [
    "sphinx.ext.autodoc",
    "sphinx.ext.viewcode",
    "sphinx.ext.mathjax",
    "sphinxcontrib.bibtex",
    "sphinxcontrib.rsvgconverter",
    "sphinx.ext.imgmath",
    "admonition_templates",
    "subfig",
]

# number figures
numfig = True
numfig_secnum_depth = 2
numfig_format = {'figure': 'Figure %s', 'table': 'Table %s', 'code-block': 'Code Block %s', "subfigure": "Figure %s"}

# only parse rst files
source_suffix = ".rst"

# paths to exclude from the document source scan
exclude_patterns = ["_release", "_build", "_build_*", "Thumbs.db", ".DS_Store", ".venv"]

bibtex_bibfiles = ["Crypto101.bib"]

# the name of the root document
master_doc = "index"

# these can be read inside the .rst, and are also used in the latex preamble + sphinx stuff
project = "Crypto 101"
copyright = "2020, Laurens Van Houtven (lvh)"
author = "lvh"

# these can be accessed as |version| and |release| inside the .rst source
import subprocess


def run_command(*args):
    return subprocess.check_output(args).decode().strip()


version = run_command("git", "rev-parse", "--short", "HEAD")
release = run_command("git", "describe", "--always")

# i18n configuration
locale_dirs = ["locale/"]
gettext_compact = False


pygments_style = "sphinx"

# whether to show .. todo:: 's into the built document
todo_include_todos = True

# https://alabaster.readthedocs.io/en/latest/customization.html#theme-options
html_theme = "alabaster"
html_theme_options = {
    "show_relbars": True,
    "fixed_sidebar": True,
    "github_user": "crypto101",
    "github_repo": "book",
    "github_button": True,
    "github_type": "star",
}

html_show_sourcelink = False
html_static_path = ["_static"]
htmlhelp_basename = "crypto101"

epub_basename = "crypto101"
epub_css_files = ["epub_style.css"]

def read_latex_source(name: str) -> str:
    name += ".tex"
    with (root / "latex" / name).open("r") as fp:
        return fp.read()


def read_latex_template(name: str) -> str:
    return Template(read_latex_source(name)).substitute(globals())


# inline math is rendered as svg, and needs a preamble to render properly
imgmath_latex_preamble = read_latex_source("imgmath")
imgmath_image_format = "svg"
imgmath_font_size = 16

# whether to show the page number after references
latex_show_pagerefs = True
latex_engine = "xelatex"

# what documents to build
latex_documents = [
    (
        # master document
        master_doc,
        # target file name
        "crypto101.tex",
        # title
        project,
        # author
        author,
        # document class
        "memoir",
    )
]

# top level titles are parts
latex_toplevel_sectioning = "part"

latex_docclass = {"manual": "memoir"}
latex_elements = {
    "printindex": "",
    "pointsize": "11pt",
    "papersize": "ebook",
    "fncychap": "",
    "extraclassoptions": "table,dvipsnames,oneside,openany",
    "sphinxsetup": ",".join(
        (
            # titles should be black
            "TitleColor={rgb}{0.0,0.0,0.0}",
            # external links color
            "OuterLinkColor={rgb}{0.929,0.094,0.588}",
            # attention admonitions are used by the advanced warnings
            "attentionBgColor={rgb}{0.694,0.753,0.835}",
            # set the title font family to bold
            "HeaderFamily={\\bfseries}",
        )
    ),
    "fontpkg": r"""
\usepackage{fontspec}
\defaultfontfeatures{Ligatures=TeX}
\setmainfont{Source Serif Pro}
\setmonofont[Scale=MatchLowercase]{Source Code Pro}
\usepackage{microtype}
\usepackage{setspace}
\usepackage{csquotes}
    """,
    "passoptionstopackages": """
\PassOptionsToPackage{dvipsnames,table}{xcolor}
    """,
    "preamble": read_latex_template("preamble"),
    "hyperref": read_latex_template("hyperref"),
    "maketitle": read_latex_template("maketitle"),
}

latex_additional_files = ["./Illustrations/CC/CC-BY-NC.pdf"]
