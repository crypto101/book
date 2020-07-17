#!/usr/bin/env python3

"""
Adds subfigure functionality

Vendored from https://github.com/jterrace/sphinxtr

Copyright (c) 2012, Jeff Terrace
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
DAMAGE.
"""

import re
from docutils import nodes
import docutils.parsers.rst.directives as directives
from docutils.parsers.rst import Directive
from sphinx.directives.patches import Figure

from typing import Any, Dict, List, Set, Tuple, TypeVar
from typing import cast

from docutils import nodes
from docutils.nodes import Element, Node

from sphinx.application import Sphinx
from sphinx.environment import BuildEnvironment
from sphinx.environment.collectors import EnvironmentCollector
from sphinx.locale import __
from sphinx.transforms import SphinxContentsFilter
from sphinx.util import url_re, logging

class subfigure(nodes.figure):
    pass


def skip_visit(self, node):
    raise nodes.SkipNode


def visit_subfigure_tex(self, node):
    self.__body = self.body
    self.body = []
    self.visit_figure(node)


def depart_subfigure_tex(self, node):
    self.depart_figure(node)
    figoutput = "".join(self.body)
    # the newlines at the beginning mess up the subfigure alignment
    # a newline between two subfigures means "stop stacking subfigures"
    # on this line
    figoutput = figoutput.lstrip("\n")

    # if the node isn't the first, pad
    if node["subfig_i"] != 0:
        figoutput = r"\hspace{\fill}" + figoutput

    # replace the start tag
    base_output = r"\\begin{figure}\[[a-z]*\]"
    replacement = r"\\begin{subfigure}[t]{%s\\linewidth}" % node["width"]
    figoutput = re.sub(base_output, replacement, figoutput)
    # replace the end tag
    figoutput = figoutput.replace(r"\end{figure}", r"\end{subfigure}")
    figoutput = figoutput.replace("\\capstart\n", "")
    # figoutput = figoutput.replace(r"\centering", r"")
    figoutput = figoutput.replace("\\noindent\n", "")
    self.body = self.__body
    self.body.append(figoutput)


def visit_subfigure_html(self, node):
    self.__body = self.body
    self.body = []

    # change the way fignumbers are displayed inside subfigures
    def patched_add_fignumber(node):
        def append_fignumber(figtype, figure_id):
            if self.builder.name == 'singlehtml':
                key = "%s/%s" % (self.docnames[-1], figtype)
            else:
                key = figtype

            if figure_id in self.builder.fignumbers.get(key, {}):
                self.body.append('<span class="caption-number">')
                numbers = self.builder.fignumbers[key][figure_id]
                self.body.append("(%s) " % numbers[-1])
                self.body.append('</span>')

        figtype = self.builder.env.domains['std'].get_enumerable_node_type(node)
        if figtype:
            if len(node['ids']) == 0:
                msg = __('Any IDs not assigned for %s node') % node.tagname
                logger.warning(msg, location=node)
            else:
                append_fignumber(figtype, node['ids'][0])
    self.__saved_add_fignumber = self.add_fignumber
    self.add_fignumber = patched_add_fignumber
    self.visit_figure(node)


def depart_subfigure_html(self, node):
    self.depart_figure(node)
    self.add_fignumber = self.__saved_add_fignumber

    figoutput = "".join(self.body)
    figoutput = figoutput.replace(
        'class="figure',
        'style="width: %g%%" class="subfigure' % (float(node["width"]) * 100),
    )
    self.body = self.__body
    self.body.append(figoutput)


class SubfigureDirective(Figure):
    def run(self):
        res_list = super().run()
        if len(res_list) != 1:
            return res_list

        res, = res_list
        # reclass nodes.figures to subfigures
        if type(res) is nodes.figure:
            res.__class__ = subfigure
        return [res]


class figmatrix(nodes.figure):
    pass


def visit_figmatrix_tex(self, node):
    self.body.append("\n\\begin{figure}[p]\n\\centering\n\\capstart\n")


def depart_figmatrix_tex(self, node):
    self.body.append("\n\n\\end{figure}\n\n")


def visit_figmatrix_html(self, node):
    atts = {"class": "figure figmatrix align-center"}
    self.body.append(self.starttag(node, "div", **atts))


def depart_figmatrix_html(self, node):
    self.body.append("</div>")


class FigmatrixDirective(Directive):
    has_content = True
    optional_arguments = 3
    final_argument_whitespace = True

    option_spec = {
        "label": directives.uri,
        "alt": directives.unchanged,
        "width": directives.unchanged_required,
    }

    def run(self):
        width = self.options.get("width", None)
        alt = self.options.get("alt", None)

        node = figmatrix("")
        if width is not None:
            node["width"] = width
        if alt is not None:
            node["alt"] = alt

        if self.content:
            self.state.nested_parse(self.content, self.content_offset, node)
            caption_nodes = []
            for child in node.children:
                if isinstance(child, nodes.paragraph):
                    caption_nodes.extend(child.children)
                    node.remove(child)

            caption_rawsource = "".join(e.rawsource for e in caption_nodes)
            caption = nodes.caption(caption_rawsource, "", *caption_nodes)
            # finding the source file / line is required for i18n
            caption.source, caption.line = self.state_machine.get_source_and_line(self.lineno)
            node += caption

        label = self.options.get("label", None)
        if label is not None:
            node['names'].append(label)
            self.state.document.note_explicit_target(node, node)
        return [node]


def node_id(node):
    return node["ids"][0]


def doctree_read(app, doctree):
    env = app.builder.env
    if not hasattr(env, 'subfigures'):
        env.subfigures = {}

    doc_subfigures = env.subfigures.setdefault(env.docname, {})

    for figmatrix_node in doctree.traverse(figmatrix):
        figmatrix_id = node_id(figmatrix_node)
        subfig_i = 0

        i = 0
        # we can't use enumerate, as we delete nodes on the go
        while i < len(figmatrix_node.children):
            removed_nodes = 0
            figure_node = figmatrix_node.children[i]
            if isinstance(figure_node, subfigure):
                if i > 0:
                    # if the node before the figure is a target
                    # move it inside the subfig
                    prevnode = figmatrix_node.children[i - 1]
                    if isinstance(prevnode, nodes.target):
                        figmatrix_node.children.remove(prevnode)
                        figure_node.insert(0, prevnode)
                        removed_nodes += 1

                figure_node["width"] = figmatrix_node["width"]
                figure_node["subfig_i"] = subfig_i
                doc_subfigures[node_id(figure_node)] = (figmatrix_id, subfig_i)
                subfig_i += 1
            elif isinstance(figure_node, nodes.figure):
                raise ExtensionError(_("`figure' can't be used in figmatrix, use `subfigure'"))
            i += 1 - removed_nodes

def env_purge_doc(app, env, docname):
    if not hasattr(env, 'subfigures'):
        return

    env.subfigures.pop(docname, None)


def env_merge_info(app, env, docnames, other) -> None:
    if not hasattr(other, 'subfigures'):
        return

    if not hasattr(env, 'subfigures'):
        env.subfigures = {}

    env.subfigures.update(other.subfigures)


class TocFixupCollector(EnvironmentCollector):
    def clear_doc(self, app: Sphinx, env: BuildEnvironment, docname: str) -> None:
        pass

    def merge_other(self, app: Sphinx, env: BuildEnvironment, docnames: Set[str],
                    other: BuildEnvironment) -> None:
        pass

    def process_doc(self, app: Sphinx, doctree: nodes.document) -> None:
        pass

    def get_updated_docs(self, app: Sphinx, env: BuildEnvironment) -> List[str]:
        updated_docs: Set[str] = set()

        # for each document, get the figure numners
        for docname, doc_fignumbers in env.toc_fignumbers.items():
            updates = 0
            # skip the document if there are no subfigures
            doc_subfig_fignumbers = doc_fignumbers.get("subfigure", None)
            if doc_subfig_fignumbers is None:
                continue

            doc_fig_fignumbers = doc_fignumbers.get("figure", None)
            if doc_fig_fignumbers is None:
                continue

            doc_subfigures = env.subfigures[docname]
            for subfigure_id, (figmatrix_id, subfig_i) in doc_subfigures.items():
                figmatrix_fignumer = doc_fig_fignumbers[figmatrix_id]
                subfig_letter = chr(ord("a") + subfig_i)
                doc_subfig_fignumbers[subfigure_id] = figmatrix_fignumer + (subfig_letter,)
                updates += 1

            if updates:
                updated_docs.add(docname)

        return list(updated_docs)


def setup(app):
    # add_enumerable_node registers a node class as a numfig target
    app.add_enumerable_node(
        figmatrix,
        "figure",
        html=(visit_figmatrix_html, depart_figmatrix_html),
        singlehtml=(visit_figmatrix_html, depart_figmatrix_html),
        text=(skip_visit, None),
        latex=(visit_figmatrix_tex, depart_figmatrix_tex),
    )

    # number subfigures in a separate space
    app.add_enumerable_node(
        subfigure,
        "subfigure",
        html=(visit_subfigure_html, depart_subfigure_html),
        singlehtml=(visit_subfigure_html, depart_subfigure_html),
        text=(skip_visit, None),
        latex=(visit_subfigure_tex, depart_subfigure_tex),
    )

    app.add_directive("figmatrix", FigmatrixDirective)
    app.add_directive("subfigure", SubfigureDirective)
    app.connect("doctree-read", doctree_read)
    app.connect('env-purge-doc', env_purge_doc)
    app.connect('env-merge-info', env_merge_info)
    app.add_env_collector(TocFixupCollector)
