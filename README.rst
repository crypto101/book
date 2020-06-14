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

Run ``make book`` in the root directory of the repository to convert the
source files into rendered versions of all supported formats.

Dependencies
------------

Due to the high number of dependencies, using docker is highly recommanded:

.. code-block:: sh

   docker build -t crypto101 docker/
   docker run --rm -it -v "$(realpath .)":/repo -u "$(id -u)" crypto101 ./make-lang YOUR_LANGUAGE_CODE html latexpdf epub

You can find the install procedure for the dependencies for `ubuntu <docker/Dockerfile.ubuntu>`_ and `fedora <docker/Dockerfile.fedora>`_ in
their dedicated dockerfiles.
