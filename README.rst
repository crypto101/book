======================
 Crypto 101: the book
======================

This is the source repository for Crypto 101, the introductory book
about cryptography by lvh_.

License
=======

See the LICENSE file.

Building
========

Unfortunately, the build process is somewhat intricate right now. This
should all (at some point) be turned into a Makefile or something
similar, but just in case you're feeling adventurous:

1. Compile all the PBM files to vector PDFs using e.g. ``potrace``.
2. Compile the ``org-mode`` file to TeX.
3. Compile the TeX file. This may require a bunch of packages; I
   pretty much just have a TeX Live installation with every package
   you can imagine.

.. _lvh: https://twitter.com/lvh
