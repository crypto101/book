======================
 Crypto 101: the book
======================

.. image:: https://travis-ci.com/crypto101/book.svg?branch=master
   :target: https://travis-ci.com/crypto101/book

This is the source repository for `Crypto 101`_, the introductory book
about cryptography by lvh_.

.. _`Crypto 101`: https://www.crypto101.io/
.. _lvh: https://twitter.com/lvh

License
=======

See the LICENSE file.

Translations
============

For now, crypto101 is only available in english, but `you can help translate it
into your own language <https://github.com/crypto101/book/issues/372>`_.

Building
========

Run ``make`` in the root directory of the repository to convert the
source files into rendered versions of all supported formats.

Dependencies
------------

Due to the high number of dependencies, Using the provided docker container is highly recommanded:

.. code-block:: sh

   docker build -t crypto101 .
   docker run --rm -it -v "$(realpath .)":/repo -u "$(id -u)" crypto101 ./make-lang YOUR_LANGUAGE_CODE html latexpdf epub

Here are the dependencies for Ubuntu if you don't want to use docker:

- ``graphviz``
- ``latexmk``
- ``make``
- ``potrace``
- a huge chunk of ``texlive`` (On Ubuntu, you will need at *least*
  ``texlive-latex-recommended``, ``texlive-metapost``, ``texlive-xetex``
  and ``texlive-latex-extra``)
- ``context`` (for metafun)
- ``pdf2svg``
- ``python3-sphinx``
- ``sphinx-intl``
- ``python3-sphinxcontrib.bibtex``
- ``python3-sphinxcontrib.svg2pdfconverter``
- ``ghostscript``
- ``xindy``
- Source Serif Pro

 You can also find the dependencies for fedora in the [Dockerfile](Dockerfile).
