======================
 Crypto 101: the book
======================

This is the source repository for `Crypto 101`_, the introductory book
about cryptography by lvh_.

.. _`Crypto 101`: https://www.crypto101.io/
.. _lvh: https://twitter.com/lvh

License
=======

See the LICENSE file.

Building
========

WARNING: Please note that building (anywhere besides on the machine
lvh_ builds on, in any way besides the way that lvh_ builds it) is a
very new and experimental feature, and is many different kinds of
broken. If you try this, and it doesn't work out, *please* file an
issue so we can resolve it.

Run ``make`` in the root directory of the repository to convert the
source files into rendered versions of all supported formats.

Dependencies
------------

Please note that as of now, producing a better book is the primary goal.
All other things being equal, an easier to build book is better than a
harder to build book. But for example, a better illustration that
relies on a new tool is better than a worse illustration.

Emacs 24
~~~~~~~~

The easiest way to get this on OS X is to install Emacs via Homebrew_
or by downloading it from `Emacs For Mac OS X`_.

.. _Homebrew: http://brew.sh/
.. _`Emacs For Mac OS X`: http://emacsformacosx.com/

Keep in mind that the Makefile will build using whatever ``emacs`` is
in your current environment. Notably, if you're on OS X and using
Emacs for Mac OS X, there's a decent chance that ``emacs`` in your
shell environment will actually refer to the massively ancient version
that came shipped with your OS.

org-mode
~~~~~~~~

You will need a recent release of org-mode_. If you install it through
ELPA_ (Emacs 24's default package repository when you do
``list-packages`` and install things), it should be found
automagically. You can override the location of your org-mode
installation by setting the ``ORG_DIR`` environment variable.

.. _org-mode: http://orgmode.org/
.. _ELPA: http://www.emacswiki.org/emacs/ELPA

LaTeX environment
~~~~~~~~~~~~~~~~~

You will need `TeX Live`_ with a great many installed packages. You
will also need ``latexmk`` and ``xetex``, which come with TeX Live.
Any effort to make this list more precise is greatly appreciated.

On Debian, you will need at *least* ``texlive-latex-recommended`` and
``texlive-xetex``.

.. _`TeX Live`: https://www.tug.org/texlive/

potrace
~~~~~~~

potrace is responsible for turning some of the hand-drawn images into
vector formats. It is available from most package sources, including
Homebrew and Macports for OS X, and pretty much every Linux
distribution's default package repository.

Inkscape
~~~~~~~~

Inkscape is necessary to render SVG sources to PDF. If you install it
on OS X using the .app, you won't have a command line script; create
an executable file named ``inkscape`` somewhere on your ``$PATH`` with
the following contents::

  #!/usr/bin/env bash
  /Applications/Inkscape.app/Contents/Resources/script $@

pygments
~~~~~~~~

pygments is used to render source code. You can either install it
through the usual Python channels, or your operating system's package
manager. On Debian and Ubuntu, this package is called
``python-pygments``.
