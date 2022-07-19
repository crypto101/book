Foreword
========

About this book
---------------

   Lots of people working in cryptography have no deep concern with real
   application issues. They are trying to discover things clever enough to write
   papers about.

      *Whitfield Diffie*

This book is intended as an introduction to cryptography for programmers
of any skill level. It's a continuation of a talk of the same name,
which was given by the author at PyCon 2013.

The structure of this book is very similar: it starts with very simple
primitives, and gradually introduces new ones, demonstrating why they're
necessary. Eventually, all of this is put together into complete,
practical cryptosystems, such as TLS, GPG and :term:`OTR`.

The goal of this book is not to make anyone a cryptographer or a
security researcher. The goal of this book is to understand how complete
cryptosystems work from a bird's eye view, and how to apply them in real
software.

The exercises accompanying this book focus on teaching cryptography by
breaking inferior systems. That way, you won't just “know” that some
particular thing is broken; you'll know exactly *how* it's broken, and
that you, yourself, armed with little more than some spare time and your
favorite programming language, can break them. By seeing how these
ostensibly secure systems are actually completely broken, you will
understand *why* all these primitives and constructions are necessary
for complete cryptosystems. Hopefully, these exercises will also leave
you with healthy distrust of DIY cryptography in all its forms.

For a long time, cryptography has been deemed the exclusive realm of
experts. From the many internal leaks we've seen over the years of the
internals of both large and small corporations alike, it has become
obvious that that approach is doing more harm than good. We can no
longer afford to keep the two worlds strictly separate. We must join
them into one world where all programmers are educated in the basic
underpinnings of information security, so that they can work together
with information security professionals to produce more secure software
systems for everyone. That does not make people such as penetration
testers and security researchers obsolete or less valuable; quite the
opposite, in fact. By sensitizing all programmers to security concerns,
the need for professional security audits will become more apparent, not
less.

This book hopes to be a bridge: to teach everyday programmers from any
field or specialization to understand just enough cryptography to do
their jobs, or maybe just satisfy their appetite.

Advanced sections
-----------------

This book is intended as a practical guide to cryptography for
programmers. Some sections go into more depth than they need to in order
to achieve that goal. They're in the book anyway, just in case you're
curious; but I generally recommend skipping these sections. They'll be
marked like this:


.. declare_admonition::
   :name: advanced
   :type: attention

   .. figure:: ./Illustrations/Propeller/Propeller.svg
      :width: 80
      :align: left

   This is an optional, in-depth section. It almost certainly won't help you write better software,
   so feel free to skip it. It is only here to satisfy your inner geek's curiosity.

.. canned_admonition::
   :from_template: advanced

Development
-----------

The entire Crypto 101 project is publicly developed on GitHub under the
``crypto101`` organization, including `this book
<https://www.github.com/crypto101/book/>`_.

This is an early pre-release of this book. All of your questions,
comments and bug reports are highly appreciated. If you don't understand
something after reading it, or if a sentence has particularly clumsy
wording, *that's a bug* and I would very much like to fix it! Of course,
if I never hear about your issue, it's very hard for me to address…

The copy of this book that you are reading right now is based on the git
commit with hash |version|, also known as |release|.

Acknowledgments
---------------

This book would not have been possible without the support and
contributions of many people, even before the first public release. Some
people reviewed the text, some people provided technical review, and
some people helped with the original talk. In no particular order:

-  My wife, Ewa
-  Brian Warner
-  Oskar Żabik
-  Ian Cordasco
-  Zooko Wilcox-O'Hearn
-  Nathan Nguyen (@nathanhere)

Following the public release, many more people contributed changes. I'd
like to thank the following people in particular (again, in no
particular order):

-  coh2, for work on illustrations
-  TinnedTuna, for review work on the XOR section (and others)
-  dfc, for work on typography and alternative formats
-  jvasile, for work on typefaces and automated builds
-  hmmueller, for many, many notes and suggestions
-  postboy (Ivan Zuboff), for many reported issues
-  EdOverflow, for many contributions
-  gliptak (Gábor Lipták) for work on automating builds,

as well as the huge number of people that contributed spelling, grammar
and content improvements. Thank you!
