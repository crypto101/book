Exclusive or
------------

Description
~~~~~~~~~~~

Exclusive or, often called “XOR”, is a Boolean [#boolean]_ binary [#binary]_ operator
that is true when either the first input or the second input, but not
both, are true.

Another way to think of XOR is as something called a “programmable
inverter”: one input bit decides whether to invert the other input bit,
or to just pass it through unchanged. “Inverting” bits is colloquially
called “flipping” bits, a term we'll use often throughout the book.

.. figure:: Illustrations/XOR/ProgrammableInverter.svg
   :alt: a programmable inverter
   :align: center

In mathematics and cryptography papers, exclusive or is generally
represented by a cross in a circle: :math:`\xor`. We'll use the same
notation in this book:

.. figure:: Illustrations/XOR/XOR.svg
   :align: center
   :alt: XOR

The inputs and output here are named as if we're using XOR as an
encryption operation. On the left, we have the plaintext bit
:math:`P_i`. The :math:`i` is just an index, since we'll usually deal
with more than one such bit. On top, we have the key bit :math:`k_i`,
that decides whether or not to invert :math:`P_i`. On the right, we have
the ciphertext bit, :math:`C_i`, which is the result of the XOR
operation.

.. [#boolean]
   Uses only “true” and “false” as input and output values.

.. [#binary]
   Takes two parameters.

A few properties of XOR
~~~~~~~~~~~~~~~~~~~~~~~

Since we'll be dealing with XOR extensively during this book, we'll take
a closer look at some of its properties. If you're already familiar with
how XOR works, feel free to skip this section.

We saw that the output of XOR is 1 when one input or the other (but not
both) is 1:

.. math::

   \begin{array}{c@{\hspace{2em}}c}
   0 \xor 0 = 0 & 1 \xor 0 = 1 \\
   0 \xor 1 = 1 & 1 \xor 1 = 0
   \end{array}

There are a few useful arithmetic tricks we can derive from that.

#. XOR can be applied in any order:
   :math:`a \xor (b \xor c) = (a \xor b) \xor c`
#. The operands can be flipped around: :math:`a \xor b = b \xor a`
#. Any bit XOR itself is 0: :math:`a \xor a = 0`. If :math:`a` is 0,
   then :math:`0 \xor 0 = 0`; if :math:`a` is 1, then :math:`1 \xor 1 = 0`.
#. Any bit XOR 0 is that bit again: :math:`a \xor 0 = a`. If :math:`a`
   is 0, then :math:`0 \xor 0 = 0`; if :math:`a` is 1, then
   :math:`1 \xor 0 = 1`.

These rules imply that :math:`a \xor b \xor a = b`:

.. math::

   \begin{aligned}
   a \xor b \xor a & = a \xor a \xor b & \; & \text{(second rule)} \\
                   & = 0 \xor b        & \; & \text{(third rule)} \\
                   & = b               & \; & \text{(fourth rule)}
   \end{aligned}

We use this property for XOR encryption. The first XOR :math:`a` can be thought of 
as encrypting, and the second one as decrypting.

Bitwise XOR
~~~~~~~~~~~

XOR, as we've just defined it, operates only on single bits or Boolean
values. Since we usually deal with values comprised of many bits, most
programming languages provide a “bitwise XOR” operator: an operator that
performs XOR on the respective bits in a value.

As an example, Python has the ``^`` (caret) operator performing
bitwise XOR on integers. It first expresses two
integers in binary [#binary-integer]_, and then performs XOR on their respective
bits. Hence the name, *bitwise* XOR.

.. math::

   \begin{aligned}
   73 \xor 87 & = 0b1001001 \xor 0b1010111 \\
              & = \begin{array}{*{7}{C{\widthof{$\xor$}}}c}
                      1    & 0    & 0    & 1    & 0    & 0    & 1    & \quad \text{(left)}\\
                      \xor & \xor & \xor & \xor & \xor & \xor & \xor & \\
                      1    & 0    & 1    & 0    & 1    & 1    & 1    & \quad \text{(right)}\\
                  \end{array} \\
              & = \begin{array}{*{7}{C{\widthof{$\xor$}}}}
                      0    & 0    & 1    & 1    & 1    & 1    & 0
                  \end{array} \\
              & = 0b0011110 \\
              & = 30 \\
   \end{aligned}

.. [#binary-integer]
   Usually, numbers are internally stored in binary, so this
   does not take any work. When a number is prefixed with
   “0b” it means that the remaining digits are a binary representation.

One-time pads
~~~~~~~~~~~~~

XOR may seem like an awfully simple, even trivial operator. Even so,
there is an encryption scheme. It is called a one-time pad, which consists of
a single operator with a sequence (“pad”) of random bits. The security of the
scheme depends on using the pad only once. The sequence is called a pad
because it was originally recorded on a physical, paper pad.

The scheme is unique not only in its simplicity. It
has the highest security guarantee possible. If the bits are truly
random, they become unpredictable for an attacker. Additionally, if the pad is only
used once, the attacker learns nothing about the plaintext when viewing
a ciphertext. [#msg-exists]_

.. [#msg-exists]
   The attacker does learn that the message exists and the message length
   in this simple scheme. While this typically is not too
   important, there are situations where this matters. 
   Secure cryptosystems exist to both hide the existence and the length of
   a message.


Suppose we can translate our plaintext into a sequence of bits. We also
have the pad of random bits, shared between the sender and the (one or
more) recipients. We can compute the ciphertext by taking the bitwise
XOR of the two sequences of bits.

.. figure:: Illustrations/XOR/OTP.svg
   :align: center
   :alt: OTP

If an attacker sees the ciphertext, we can prove that
zero information is learned about the plaintext without the key. This property is
called *perfect security*. The proof can be understood intuitively. 
Think of XOR as a programmable inverter, and look at a
particular bit intercepted by Eve, the eavesdropper.

.. figure:: Illustrations/XOR/OTPEve.svg
   :align: center
   :alt: OTP eve

Let's say Eve sees that a particular ciphertext bit :math:`c_i` is 1.
She has no idea if the matching plaintext bit :math:`p_i` was 0 or 1,
because she has no idea if the key bit :math:`k_i` was 0 or 1. Since all
of the key bits are truly random, both options are exactly equally
probable.

Attacks on “one-time pads”
~~~~~~~~~~~~~~~~~~~~~~~~~~

The one-time pad security guarantee only holds if used correctly.
First of all, the one-time pad must consist of truly random data.
Secondly, the one-time pad can only be used once (hence the name).
Unfortunately, most commercial products that claim to be “one-time pads”
are snake oil [#snake-oil]_, and do not satisfy at least one of these two
properties.

.. [#snake-oil]
   “Snake oil” is a term for dubious products that claim
   extraordinary benefits and features, yet do not realize any of
   them.

Not using truly random data
^^^^^^^^^^^^^^^^^^^^^^^^^^^

The first issue is that various deterministic constructs 
produce the one-time pad instead of using truly random data. That is not
necessarily insecure: in fact, the most obvious example, a synchronous
stream cipher, is something we will see later in the book. However, it
does invalidate the “unbreakable” security property of one-time pads.
The end user is better served by a more honest cryptosystem,
not one that lies about its security properties.

Reusing the “one-time” pad
^^^^^^^^^^^^^^^^^^^^^^^^^^

The other issue is with key reuse, which is much more serious. Suppose
an attacker gets two ciphertexts with the same “one-time” pad. The
attacker can then XOR the two ciphertexts, which is also the XOR of the
plaintexts:

.. math::

   \begin{aligned}
   c_1 \xor c_2
   &= (p_1 \xor k) \xor (p_2 \xor k) && (\text{definition})\\
   &= p_1 \xor k \xor p_2 \xor k && (\text{reorder terms})\\
   &= p_1 \xor p_2 \xor k \xor k && (a \xor b = b \xor a) \\
   &= p_1 \xor p_2 \xor 0 && (x \xor x = 0) \\
   &= p_1 \xor p_2 && (x \xor 0 = x)
   \end{aligned}

At first sight, that may not seem like an issue. To extract either
:math:`p_1` or :math:`p_2`, you'd need to cancel out the XOR operation,
which means you need to know the other plaintext. The problem is that
even the result of the XOR operation on two plaintexts contains quite a
bit information about the plaintexts themselves. We'll illustrate this
visually with some images from a broken “one-time” pad process, starting
with :numref:`fig-multitimepad`.

.. figmatrix::
   :label: fig-multitimepad
   :width: 0.48

   .. subfigure:: ./Illustrations/KeyReuse/Broken.png
      :alt:
      :align: center

      First plaintext.

   .. subfigure:: ./Illustrations/KeyReuse/Crypto.png
      :alt:
      :align: center

      Second plaintext.

   .. subfigure:: ./Illustrations/KeyReuse/BrokenEncrypted.png
      :alt:
      :align: center

      First ciphertext.

   .. subfigure:: ./Illustrations/KeyReuse/CryptoEncrypted.png
      :alt:
      :align: center

      Second ciphertext.

   .. subfigure:: ./Illustrations/KeyReuse/Key.png
      :alt:
      :align: center

      Reused key.

   .. subfigure:: ./Illustrations/KeyReuse/CiphertextsXOR.png
      :alt:
      :align: center

      XOR of ciphertexts.

   Two plaintexts, the re-used key, their respective
   ciphertexts, and the XOR of the ciphertexts. Plaintext information clearly
   leaks through when we XOR the ciphertexts.

Crib-dragging
^^^^^^^^^^^^^

A classic approach to break multi-time pad systems is
“crib-dragging.” Crib-dragging uses small sequences expected
to occur with high probability. Those sequences are “cribs”. The
name crib-dragging originates from the fact that these small “cribs” are
dragged from left to right across each ciphertext, and from top to
bottom across the ciphertexts, in the hope of finding a match.
The matches form the sites of the start, or “crib”, if you will, of
further decryption.

The idea is fairly simple. Suppose we have several encrypted messages
:math:`C_i` encrypted with the same “one-time” pad :math:`K`
[#capital-letters]_. If we could correctly guess the plaintext for one of the
messages, let's say :math:`C_j`, we'd know :math:`K`:

.. [#capital-letters]
   We use capital letters when referring to an entire message, as
   opposed to just bits of a message.


.. math::

   \begin{aligned}
   C_j \xor P_j
   &= (P_j \xor K) \xor P_j \\
   &= K \xor P_j \xor P_j \\
   &= K \xor 0 \\
   &= K
   \end{aligned}

Since :math:`K` is the shared secret, we can use it to decrypt all
other messages as if we are the recipient:

.. math::

   P_i = C_i \xor K \qquad \text{for all }i

This typically does not work because we cannot
guess an entire message. However, we can guess parts of a message.

If we guess a few plaintext bits :math:`p_i` correctly for *any* of the
messages that reveals the key bits at that position for *all* of
the messages since :math:`k = c_i \xor p_i`. Hence, all of the
plaintext bits at that position are revealed. Using that value for
:math:`k`, we can compute the plaintext bits :math:`p_i = c_i \xor k`
for all the other messages.

Guessing parts of the plaintext is easier than guessing the entire
plaintext. Suppose we know that the plaintext is in English. There are
sequences that will occur very commonly. For example (the
:math:`\verb*| |` symbol denotes a space):

-  :math:`\verb*| the |` and variants such as :math:`\verb*|. The |`
-  :math:`\verb*| of |` and variants
-  :math:`\verb*| to |` and variants
-  :math:`\verb*| and |` (no variants; only occurs in the middle of a sentence)
-  :math:`\verb*| a |` and variants

If we know more about the plaintext, we can make even better guesses.
For example, if it's HTTP serving HTML, we would expect to see things
like ``Content-Type``, ``<a>``, and so on.

That only tells us which plaintext sequences are likely, giving us
likely guesses. How do we tell if any of those guesses are correct? If
our guess is correct, we know all the other plaintexts at that position
as well, using the technique described earlier. We could simply look at
those plaintexts and decide if they look correct.

In practice, this process needs to be automated because there are so
many possible guesses. Fortunately that's quite easy to do. For example,
a very simple but effective method is to count how often different
symbols occur in the guessed plaintexts: if the messages contain English
text, we'd expect to see a lot of letters e, t, a, o, i, n. If we're
seeing binary nonsense instead, we know that the guess was probably
incorrect, or perhaps that message is actually binary data.

These small, highly probable sequences are called “cribs” because
they're the start of a larger decryption process. Suppose your crib,
``the``, was successful and found the five-letter sequence ``t thr`` in
another message. You can then use a dictionary to find common words
starting with ``thr``, such as ``through``. If that guess were correct,
it would reveal four more bytes in all of the ciphertexts, which can be
used to reveal even more. Similarly, you can use the dictionary to find
words ending in ``t``.

This becomes even more effective for some plaintexts that we know more
about. If some HTTP data has the plaintext ``ent-Len`` in it, then we
can expand that to ``Content-Length:``, revealing many more bytes.

While this technique works as soon as two messages are encrypted with
the same key, it's clear that this becomes even easier with more
ciphertexts using the same key, since all of the steps become more
effective:

-  We get more cribbing positions.
-  More plaintext bytes are revealed with each successful crib and
   guess, leading to more guessing options elsewhere.
-  More ciphertexts are available for any given position, making guess
   validation easier and sometimes more accurate.

These are just simple ideas for breaking multi-time pads. While they're
already quite effective, people have invented even more effective
methods by applying advanced, statistical models based on natural
language analysis. This only demonstrates further just how broken
multi-time pads are. :cite:`mason:nltwotimepads`

Remaining problems
~~~~~~~~~~~~~~~~~~

Real one-time pads, implemented properly, have an extremely strong
security guarantee. It would appear, then, that cryptography is over:
encryption is a solved problem, and we can all go home. Obviously,
that's not the case.

One-time pads are rarely used, because they are horribly impractical:
the key is at least as large as all information you'd like to transmit,
*put together*. Plus, you'd have to exchange those keys securely, ahead
of time, with all people you'd like to communicate with. We'd like to
communicate securely with everyone on the Internet, and that's a very
large number of people. Furthermore, since the keys have to consist of
truly random data for its security property to hold, key generation is
fairly difficult and time-consuming without specialized hardware.

One-time pads pose a trade-off. It's an algorithm with a solid
information-theoretic security guarantee, which you can not get from any
other system. On the other hand, it also has extremely impractical key
exchange requirements. However, as we'll see throughout this book,
secure symmetric encryption algorithms aren't the pain point of modern
cryptosystems. Cryptographers have designed plenty of those, while
practical key management remains one of the toughest challenges facing
modern cryptography. One-time pads may solve a problem, but it's the
wrong problem.

While they may have their uses, they're obviously not a panacea. We need
something with manageable key sizes while maintaining secrecy. We need
ways to negotiate keys over the Internet with people we've never met
before.
