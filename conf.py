#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import pathlib
from string import Template
from sphinx.locale import _

root = pathlib.Path(__file__).parent
sys.path.insert(0, str(root))

extensions = [
    "sphinx.ext.autodoc",
    "sphinx.ext.viewcode",
    "sphinx.ext.mathjax",
    "sphinxcontrib.bibtex",
    "sphinxcontrib.rsvgconverter",
    "advanced_admonition",
    "sphinx.ext.imgmath",
]

numfig = True

templates_path = ["_templates"]

source_suffix = ".rst"

master_doc = "index"

project = "Crypto 101"
copyright = "2020, Laurens Van Houtven (lvh)"
author = "Laurens Van Houtven (lvh)"

import subprocess

version = subprocess.check_output(["git", "rev-parse", "--short", "HEAD"]).decode()
release = subprocess.check_output(["git", "describe"]).decode()


locale_dirs = ["locale/"]
gettext_compact = False

exclude_patterns = ["_build", "_build_*", "Thumbs.db", ".DS_Store", ".venv"]

pygments_style = "sphinx"

todo_include_todos = True

html_theme = "alabaster"
# https://alabaster.readthedocs.io/en/latest/customization.html#theme-options
html_theme_options = {
    "show_relbars": True,
    "fixed_sidebar": True,
    "github_user": "crypto101",
    "github_repo": "book",
    "github_button": True,
    "github_type": "star",
}

html_show_sourcelink = False

htmlhelp_basename = "crypto101"
epub_basename = "crypto101"


def read_latex_source(name: str) -> str:
    name += ".tex"
    with (root / "latex" / name).open("r") as fp:
        return fp.read()


def read_latex_template(name: str) -> str:
    return Template(read_latex_source(name)).substitute(globals())


imgmath_image_format = "svg"
imgmath_font_size = 16

imgmath_latex_preamble = read_latex_source("imgmath")

latex_show_pagerefs = True

latex_engine = "xelatex"

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

latex_toplevel_sectioning = "part"

latex_docclass = {"manual": "memoir"}


latex_elements = {
    "printindex": "",
    "pointsize": "11pt",
    "papersize": "ebook",
    "fncychap": "",
    "extraclassoptions": "table,dvipsnames,oneside,openany",
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
    "maketitle": read_latex_template("maketitle"),
}

latex_additional_files = ["./Illustrations/CC/CC-BY-NC.pdf"]

advanced_admonition_text = str(
    _(
        "This is an optional, in-depth section. It almost certainly won't help you write better software, "
        "so feel free to skip it. It is only here to satisfy your inner geek's curiosity."
    )
)
