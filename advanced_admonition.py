#!/usr/bin/env python3

"""

This module adds an "advanced" admonition to sphinx.
It enables writting:

.. advanced::

or

.. advanced::

   description

and getting it replaced by a red box containing some canned text + custom description
"""

from typing import List, Tuple
from typing import cast

from docutils import nodes
from docutils.parsers.rst import directives
from docutils.parsers.rst.directives.admonitions import BaseAdmonition

import sphinx  # pylint: disable=unused-import
from sphinx.locale import _
from sphinx.util import texescape
from sphinx.util.docutils import SphinxDirective
from sphinx.writers.latex import LaTeXTranslator


class advanced_node(nodes.Admonition, nodes.Element):  # pylint: disable=invalid-name
    """
    The custom docutils admonition AST node
    """


def visit_advanced_node(self, node):
    """prefix visitor used when writting the node to some format"""
    self.visit_admonition(node)


def depart_advanced_node(self, node):
    """suffix visitor used when writting the node to some format"""
    self.depart_admonition(node)


def latex_visit_advanced_node(self: LaTeXTranslator, node: advanced_node) -> None:
    """prefix visitor used when writting the node to LaTeX"""
    self.body.append("\n\\begin{sphinxadmonition}{attention}{")
    self.body.append(self.hypertarget_to(node))

    # the title is generated when processing the directive
    title_node = cast(nodes.title, node[0])
    title = texescape.escape(title_node.astext(), self.config.latex_engine)
    self.body.append("%s}" % title)
    node.pop(0)


def latex_depart_advanced_node(self: LaTeXTranslator, _: advanced_node) -> None:
    """suffix visitor used when writting the node to LaTeX"""
    self.body.append("\\end{sphinxadmonition}\n")


class Advanced(BaseAdmonition, SphinxDirective):
    """
    An advanced custom admonition
    """

    node_class = advanced_node
    has_content = True
    required_arguments = 0
    optional_arguments = 0
    final_argument_whitespace = False
    option_spec = {"class": directives.class_option, "name": directives.unchanged}

    def run(self) -> List[nodes.Node]:
        settings = self.state.document.settings
        config = settings.env.config

        # insert the canned text into the ast.
        # the source used for location metadata
        source = self.state_machine.get_source(self.lineno)
        self.content.insert(0, config.advanced_admonition_text, source)

        if not self.options.get("class"):
            # CSS classes for the HTML export
            self.options["class"] = config.advanced_admonition_classes

        # this section is mostly copy pasted from the source of the sphinx todo admonition
        (advanced,) = super().run()  # type: Tuple[nodes.Node]
        if isinstance(advanced, nodes.system_message):
            return [advanced]

        if isinstance(advanced, advanced_node):
            advanced.insert(0, nodes.title(text=config.advanced_admonition_title))
            advanced["docname"] = self.env.docname
            self.add_name(advanced)
            self.set_source_info(advanced)
            self.state.document.note_explicit_target(advanced)
            return [advanced]

        raise RuntimeError  # never reached here


def setup(app):
    """
    Registers advanced admonitions into sphinx
    """

    # register conf.py options
    app.add_config_value("advanced_admonition_title", _("Advanced"), "html")
    app.add_config_value("advanced_admonition_text", "", "html")
    app.add_config_value("advanced_admonition_classes", ["attention"], "html")

    # register the new ast node
    app.add_node(
        advanced_node,
        html=(visit_advanced_node, depart_advanced_node),
        latex=(latex_visit_advanced_node, latex_depart_advanced_node),
        text=(visit_advanced_node, depart_advanced_node),
        man=(visit_advanced_node, depart_advanced_node),
        texinfo=(visit_advanced_node, depart_advanced_node),
    )

    # register the new directive
    app.add_directive("advanced", Advanced)

    return {"version": "0.1", "parallel_read_safe": True, "parallel_write_safe": True}
