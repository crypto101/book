#!/usr/bin/env python3

from docutils import nodes
from docutils.parsers.rst import Directive
from docutils.parsers.rst import directives
from sphinx.errors import ExtensionError
from copy import copy, deepcopy
from sphinx.locale import _, __
from sphinx.util.docutils import SphinxDirective
from sphinx.transforms import SphinxTransformer


class canned_admonition(nodes.Admonition, nodes.Element):
    def box_class(self):
        res = self["box_class"]
        if res is None:
            return "sphinxadmonition"
        return res

class declare_admonition(nodes.Admonition, nodes.Element):
    pass


def visit_canned_admonition_node(self, node: canned_admonition):
    self.body.append(self.starttag(
        node, 'div', CLASS=('admonition ' + node["type"])))


def depart_canned_admonition_node(self, node):
    self.depart_admonition(node)


def latex_visit_canned_admonition_node(self, node):
    node_title = node["title"]
    if node_title is None:
        node_title = ""
    self.body.append('\n\\begin{%s}{%s}{%s}' % (node.box_class(), node["type"], node_title))
    if not node_title:
        # when there's no title, remove the spacing
        self.body.append("\n\\vspace{-1.4\\baselineskip}")
    self.no_latex_floats += 1


def latex_depart_canned_admonition_node(self, node):
 	self.body.append('\\end{%s}\n' % node.box_class())
 	self.no_latex_floats -= 1


ADMONITION_TYPES = ("attention", "caution", "danger", "error", "hint", "important", "note", "tip", "warning", "admonition")
def admonition_type(argument):
    return directives.choice(argument, ADMONITION_TYPES)


class DeclareAdmonitionDirective(SphinxDirective):
    has_content = True
    required_arguments = 0
    optional_arguments = 1
    final_argument_whitespace = True
    option_spec = {
        "name": directives.unchanged_required,
        "box_class": directives.unchanged_required,
        "type": admonition_type,
    }

    def run(self):
        # create a declare_admonition node
        node = declare_admonition('\n'.join(self.content))

        # parse its content
        self.state.nested_parse(self.content, self.content_offset, node)

        # store metadata inside the node
        node["docname"] = self.env.docname
        node["lineno"] = self.lineno
        node["name"] = self.options["name"]
        node["type"] = self.options.get("type", None)
        node["box_class"] = self.options.get("box_class", None)
        node["title"] = None if not self.arguments else self.arguments[0]
        return [node]


class CannedAdmonitionDirective(SphinxDirective):
    has_content = True
    required_arguments = 0
    optional_arguments = 1
    final_argument_whitespace = True
    option_spec = {
        "from_template": directives.unchanged_required,
    }

    def run(self):
        template = self.options.get("from_template", None)
        if template is None:
            self.error("invalid template")
        # create a template instanciation
        admonition = canned_admonition('\n'.join(self.content))
        self.state.nested_parse(self.content, self.content_offset, admonition)
        admonition["template"] = template
        admonition["title"] = None if not self.arguments else self.arguments[0]
        return [admonition]


def purge_declare_admonitions(app, env, docname):
    # purge the cache for some document
    if not hasattr(env, 'custom_admonitions'):
        return

    env.custom_admonitions = [
        declaration for declaration in env.custom_admonitions
        if declaration['docname'] != docname
    ]


def find_custom_admonition(admonitions, name):
    for admonition in admonitions:
        if admonition["name"] == name:
            return admonition
    return None

def process_canned_admonition_nodes(app, doctree, docname):
    """edit the canned_admonition nodes to copy properties from the declaration"""
    env = app.builder.env

    def fixup_node(node):
        # super dirty hack to get converters to run on stored AST nodes
        try:
            # set env.docname during applying post-transforms
            backup = copy(env.temp_data)
            env.temp_data['docname'] = docname

            transformer = SphinxTransformer(node)
            transformer.set_environment(env)
            transformer.add_transforms(app.registry.get_post_transforms())
            transformer.apply_transforms()
        except ExtensionError:
            import pdb; pdb.post_mortem()
        finally:
            env.temp_data = backup


    for node in doctree.traverse(canned_admonition):
        template_node_name = node["template"]

        template_node = find_custom_admonition(env.custom_admonitions, template_node_name)
        if template_node is None:
            raise ExtensionError(_("Admonition template %s not found") % template_node)

        node["type"] = template_node["type"]
        node["box_class"] = template_node["box_class"]
        template_title = template_node["title"]
        node_title = node["title"]

        for template_node in reversed(template_node.children):
            node.insert(0, deepcopy(template_node))

        title = template_title
        if node_title is not None:
            title = node_title

        node["title"] = title
        fixup_node(node)


def register_admonition_declarations(app, doctree):
    """
    remove the declare_admonition nodes from the AST.
    this is done at the doctree-read stage, as the node needs to be processed a bit
    to be suitable for use (ImageCollector sets up images).
    """
    env = app.builder.env

    if not hasattr(env, 'custom_admonitions'):
        env.custom_admonitions = []

    for node in doctree.traverse(declare_admonition):
        env.custom_admonitions.append(node.deepcopy())
        node.parent.remove(node)

def setup(app):
    app.add_node(declare_admonition)
    app.add_node(canned_admonition,
                 html=(visit_canned_admonition_node, depart_canned_admonition_node),
                 latex=(latex_visit_canned_admonition_node, latex_depart_canned_admonition_node),
                 text=(visit_canned_admonition_node, depart_canned_admonition_node))

    app.add_directive('canned_admonition', CannedAdmonitionDirective)
    app.add_directive('declare_admonition', DeclareAdmonitionDirective)
    app.connect('doctree-read', register_admonition_declarations)
    app.connect('doctree-resolved', process_canned_admonition_nodes)
    app.connect('env-purge-doc', purge_declare_admonitions)

    return {
        'version': '0.1',
        'parallel_read_safe': True,
        'parallel_write_safe': True,
    }
