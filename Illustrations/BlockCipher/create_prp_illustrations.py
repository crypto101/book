from __future__ import division
from random import Random, shuffle

random = Random(0xdeadbeef).random

def unirange(n):
    """
    Return n equidistant points between 0 (inclusive) and 1 (not inclusive).
    """
    return (i / n for i in xrange(n))

#node_names = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"
node_names = "0123456789ABCDEF"
node_template = """{name} [fillcolor="{hue} {sat} {val}"];"""
nodes = " ".join(node_template.format(name=name, hue=hue, sat=0.4, val=1)
                 for name, hue in zip(node_names, unirange(len(node_names))))

shuffled_names = list(node_names)
shuffle(shuffled_names, random)

shuffled_names_2 = list(node_names)
shuffle(shuffled_names_2, random)

def vertices(permutation, reverse=False):
    if reverse:
        pairs = zip(node_names, shuffled_names)
    else:
        pairs = zip(shuffled_names, node_names)

    return " ".join("{0} -> {1};".format(*pair) for pair in pairs)

graph_template = """
digraph G {{
    graph [splines=curved; start=5; epsilon=0.001];
    node [style=filled, shape=circle];
    {nodes}
    {vertices}
}}
"""

with open("AllNodes.dot", "w") as f:
    f.write(graph_template.format(nodes=nodes, vertices=""))

with open("Encryption.dot", "w") as f:
    f.write(graph_template.format(nodes=nodes,
                                  vertices=vertices(shuffled_names)))

with open("Decryption.dot", "w") as f:
    f.write(graph_template.format(nodes=nodes,
                                  vertices=vertices(shuffled_names, reverse=True)))

with open("Encryption2.dot", "w") as f:
    f.write(graph_template.format(nodes=nodes,
                                  vertices=vertices(shuffled_names_2)))
